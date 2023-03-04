AuleSailing = AuleSailing or {}
AuleSailing.allFoundShips = {}
AuleSailing.bals = {}
AuleSailing.crewBalance = true
AuleSailing.crewBalanceLost = nil
AuleSailing.toAdd = {}
AuleSailing.toUpdate = {}
AuleSailing.isCheckingHarbour = false
AuleSailing.currentRole = "No"

AuleSailing.roles = {
  No = "None",
  Ca = "Captain",
  Ba = "Ballista",
  On = "Onager",
  Wa = "Watch",
  He = "Helm",
}

AuleSailing.points = {
  galley = { [0] = 0, 0, 2, 4, 6, 8, 10, 11, 12 },
  strider = { [0] = 0, 0, 3, 4, 6, 8, 9, 10, 10 },
  cutter = { [0] = 0, 2, 4, 5, 7, 8, 8, 9, 9 },
}

AuleSailing.rowingEffectiveness = {
  { cryptic = "I",    name = "I",    effectiveness = 2 },
  { cryptic = "II",   name = "II",   effectiveness = 2 },
  { cryptic = "III",  name = "III",  effectiveness = 2 },
  { cryptic = "IV",   name = "IV",   effectiveness = 1 },
  { cryptic = "V",    name = "V",    effectiveness = 1 },
  { cryptic = "VI",   name = "VI",   effectiveness = 1 },
  { cryptic = "VII",  name = "VII",  effectiveness = 1 },
  { cryptic = "VIII", name = "VIII", effectiveness = 0 },
  { cryptic = "IX",   name = "IX",   effectiveness = 0 },
}

AuleSailing.ship = {
  heading = nil
}

AuleSailing.startCapturingShips = false

AuleSailing.dbStructure = {
  ships = {
    roomId = 0,
    longName = "",
    shortName = "",
    perms = 0,
    _unique = { "shortName" },
  }
}

AuleSailing.db = db:create("sailing", AuleSailing.dbStructure)

function AuleSailing.addShip(shortName, longName, perms, roomId)
  perms = perms or ""

  local newShip = {
    roomId = roomId,
    longName = longName,
    shortName = shortName,
    perms = #perms
  }

  AuleSailing.toAdd[#AuleSailing.toAdd + 1] = newShip
end

function AuleSailing.finishCheckingHarbour()
  AuleSailing.isCheckingHarbour = false
  AuleSailing.startCapturingShips = false
  AuleSailing.startGaggingLines = false

  if #AuleSailing.toAdd > 0 then
    db:add(AuleSailing.db.ships, unpack(AuleSailing.toAdd))
    AuleSailing.toAdd = {}
  end

  if #AuleSailing.toUpdate > 0 then
    for _, ship in ipairs(AuleSailing.toUpdate) do
      db:update(AuleSailing.db.ships, ship)
    end
    AuleSailing.toUpdate = {}
  end

  local knownShipsHere = AuleSailing.getShipsInRoom(mmp.currentroom)

  for _, ship in ipairs(knownShipsHere) do
    if not AuleSailing.allFoundShips[ship.shortName] then
      ship.roomId = 0
      db:update(AuleSailing.db.ships, ship)
    end
  end

  AuleSailing.allFoundShips = {}

  AuleSailing.printHarbourReport()
end

function AuleSailing.getPermissionName(num)
  if num == 1 then
    return "Passenger"
  elseif num == 2 then
    return "Crew"
  elseif num == 3 then
    return "Captain"
  end

  return "None"
end

function AuleSailing.getShip(shortName)
  local results = db:fetch(AuleSailing.db.ships, db:eq(AuleSailing.db.ships.shortName, shortName))

  if #results == 0 then return nil end

  if #results > 1 then
    AuleSailing.say("Got back multiple ships, returning the first one.")
  end

  return results[1]
end

function AuleSailing.getShipsInRoom(roomId)
  return db:fetch(AuleSailing.db.ships, db:eq(AuleSailing.db.ships.roomId, roomId))
end

function AuleSailing.giveBalance()
  AuleSailing.crewBalance = true
  raiseEvent("AuleSailing.gotCrewbalance")
end

function AuleSailing.isCaptain()
  return AuleSailing.currentRole == "Ca"
end

function AuleSailing.printHarbourReport(targetRoomId)
  local roomId = tonumber(targetRoomId) or mmp.currentroom
  local foundShipsWithPerms = {}
  local shipsWithoutPerms = 0

  for _, ship in ipairs(AuleSailing.getShipsInRoom(roomId)) do
    if ship.perms > 0 then
      table.insert(foundShipsWithPerms, ship)
    else
      shipsWithoutPerms = shipsWithoutPerms + 1
    end
  end

  table.sort(foundShipsWithPerms, function(a, b)
    if a.shortName < b.shortName or a.shortName == b.shortName then
      return true
    else
      return false
    end
  end)

  if #foundShipsWithPerms == 0 then
    AuleSailing.say(("There are no ships here that you have access to, and %s ships you don't."):format(
    shipsWithoutPerms))
    return
  end

  local reportLine = "| <HotPink>%-15s<reset> | <DodgerBlue>%-11s<reset> | <gold>%-38s<reset> |\n"
  local sep = "+-----------------+-------------+----------------------------------------+\n"

  AuleSailing.say("Ship report:\n")

  cecho(sep)
  cecho(reportLine:format("ID", "Perms", "Name"))
  cecho(sep)

  for _, ship in ipairs(foundShipsWithPerms) do
    cechoLink(reportLine:format(ship.shortName, AuleSailing.getPermissionName(ship.perms), ship.longName),
      function() send("board ship " .. ship.shortName) end, "Board " .. ship.shortName, true)
  end
  cecho(sep)
  echo("\n")
  cecho(("Plus <green>%s<reset> ships you don't have access to."):format(shipsWithoutPerms))
end

function AuleSailing.say(what)
  cecho(("\n<white>[<MediumBlue>Sailing<white>]<reset> %s"):format(what))
end

function AuleSailing.sendIfIsCaptain(command)
  if not AuleSailing.isCaptain() then return false end

  send(command)
  return true
end

function AuleSailing.setShip(longName, shortName, perms)
  local ship = AuleSailing.getShip(shortName)

  AuleSailing.allFoundShips[shortName] = true

  if not ship then
    AuleSailing.addShip(shortName, longName, perms, mmp.currentroom)
    return
  end

  perms = perms or ""

  if ship.longName == longName and ship.roomId == mmp.currentroom and ship.perms == #perms then
    return
  end

  if tonumber(ship.roomId) ~= tonumber(mmp.currentroom) then
    ship.longName = longName
  end

  ship.longName = longName
  ship.roomId = tonumber(mmp.currentroom)
  ship.perms = #perms

  AuleSailing.toUpdate[#AuleSailing.toUpdate + 1] = ship
end

function AuleSailing.takeBalance()
  AuleSailing.crewBalance = false
  raiseEvent("AuleSailing.lostCrewbalance")
end

function AuleSailing.turnShip(dir)
  if not AuleSailing.isCaptain() then return false end

  send("ship turn " .. dir)
  return true
end

aule.sailing = aule.sailing or {}
aule.sailing.allFoundShips = {}
aule.sailing.bals = {}
aule.sailing.crewBalance = true
aule.sailing.crewBalanceLost = nil
aule.sailing.toAdd = {}
aule.sailing.toUpdate = {}
aule.sailing.isCheckingHarbour = false
aule.sailing.currentRole = "No"

aule.sailing.roles = {
  No = "None",
  Ca = "Captain",
  Ba = "Ballista",
  On = "Onager",
  Wa = "Watch",
  He = "Helm",
}

aule.sailing.points = {
  galley = { [0] = 0, 0, 2, 4, 6, 8, 10, 11, 12 },
  strider = { [0] = 0, 0, 3, 4, 6, 8, 9, 10, 10 },
  cutter = { [0] = 0, 2, 4, 5, 7, 8, 8, 9, 9 },
}

aule.sailing.rowingEffectiveness = {
  { cryptic = "I", name = "I", effectiveness = 2 },
  { cryptic = "II", name = "II", effectiveness = 2 },
  { cryptic = "III", name = "III", effectiveness = 2 },
  { cryptic = "IV", name = "IV", effectiveness = 1 },
  { cryptic = "V", name = "V", effectiveness = 1 },
  { cryptic = "VI", name = "VI", effectiveness = 1 },
  { cryptic = "VII", name = "VII", effectiveness = 1 },
  { cryptic = "VIII", name = "VIII", effectiveness = 0 },
  { cryptic = "IX", name = "IX", effectiveness = 0 },
}

aule.sailing.ship = {
  heading = nil
}

aule.sailing.startCapturingShips = false

aule.sailing.dbStructure = {
  ships = {
    roomId = 0,
    longName = "",
    shortName = "",
    perms = 0,
    _unique = { "shortName" },
  }
}

aule.sailing.db = db:create("sailing", aule.sailing.dbStructure)

function aule.sailing.addShip(shortName, longName, perms, roomId)

  perms = perms or ""

  local newShip = {
    roomId = roomId,
    longName = longName,
    shortName = shortName,
    perms = #perms
  }

  aule.sailing.toAdd[#aule.sailing.toAdd + 1] = newShip
end

function aule.sailing.finishCheckingHarbour()
  aule.sailing.isCheckingHarbour = false
  aule.sailing.startCapturingShips = false
  aule.sailing.startGaggingLines = false

  if #aule.sailing.toAdd > 0 then
    db:add(aule.sailing.db.ships, unpack(aule.sailing.toAdd))
    aule.sailing.toAdd = {}
  end

  if #aule.sailing.toUpdate > 0 then
    for _, ship in ipairs(aule.sailing.toUpdate) do
      db:update(aule.sailing.db.ships, ship)
    end
    aule.sailing.toUpdate = {}
  end

  local knownShipsHere = aule.sailing.getShipsInRoom(mmp.currentroom)

  for _, ship in ipairs(knownShipsHere) do
    if not aule.sailing.allFoundShips[ship.shortName] then
      ship.roomId = 0
      db:update(aule.sailing.db.ships, ship)
    end
  end

  aule.sailing.allFoundShips = {}

  aule.sailing.printHarbourReport()
end

function aule.sailing.getPermissionName(num)
  if num == 1 then return "Passenger"
  elseif num == 2 then return "Crew"
  elseif num == 3 then return "Captain" end

  return "None"
end

function aule.sailing.getShip(shortName)
  local results = db:fetch(aule.sailing.db.ships, db:eq(aule.sailing.db.ships.shortName, shortName))

  if #results == 0 then return nil end

  if #results > 1 then
    aule.sailing.say("Got back multiple ships, returning the first one.")
  end

  return results[1]
end

function aule.sailing.getShipsInRoom(roomId)
  return db:fetch(aule.sailing.db.ships, db:eq(aule.sailing.db.ships.roomId, roomId))
end

function aule.sailing.giveBalance()
  aule.sailing.crewBalance = true
  raiseEvent("aule.sailing.gotCrewbalance")
end

function aule.sailing.isCaptain()
  return aule.sailing.currentRole == "Ca"
end

function aule.sailing.printHarbourReport(targetRoomId)
  local roomId = tonumber(targetRoomId) or mmp.currentroom
  local foundShipsWithPerms = {}
  local shipsWithoutPerms = 0

  for _, ship in ipairs(aule.sailing.getShipsInRoom(roomId)) do
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
    aule.sailing.say(("There are no ships here that you have access to, and %s ships you don't."):format(shipsWithoutPerms))
    return
  end

  local reportLine = "| <HotPink>%-15s<reset> | <DodgerBlue>%-11s<reset> | <gold>%-38s<reset> |\n"
  local sep = "+-----------------+-------------+----------------------------------------+\n"

  aule.sailing.say("Ship report:\n")

  cecho(sep)
  cecho(reportLine:format("ID", "Perms", "Name"))
  cecho(sep)

  for _, ship in ipairs(foundShipsWithPerms) do
    cechoLink(reportLine:format(ship.shortName, aule.sailing.getPermissionName(ship.perms), ship.longName),
      function() send("board ship " .. ship.shortName) end, "Board " .. ship.shortName, true)
  end
  cecho(sep)
  echo("\n")
  cecho(("Plus <green>%s<reset> ships you don't have access to."):format(shipsWithoutPerms))
end

function aule.sailing.say(what)
  cecho(("\n<white>[<MediumBlue>Sailing<white>]<reset> %s"):format(what))
end

function aule.sailing.sendIfIsCaptain(command)
  if not aule.sailing.isCaptain() then return false end

  send(command)
  return true
end

function aule.sailing.setShip(longName, shortName, perms)
  local ship = aule.sailing.getShip(shortName)

  aule.sailing.allFoundShips[shortName] = true

  if not ship then
    aule.sailing.addShip(shortName, longName, perms, mmp.currentroom)
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

  aule.sailing.toUpdate[#aule.sailing.toUpdate + 1] = ship
end

function aule.sailing.takeBalance()
  aule.sailing.crewBalance = false
  raiseEvent("aule.sailing.lostCrewbalance")
end

function aule.sailing.turnShip(dir)
  if not aule.sailing.isCaptain() then return false end

  send("ship turn " .. dir)
  return true
end
Aule.sailing = Aule.sailing or {}
Aule.sailing.allFoundShips = {}
Aule.sailing.bals = {}
Aule.sailing.crewBalance = true
Aule.sailing.crewBalanceLost = nil
Aule.sailing.toAdd = {}
Aule.sailing.toUpdate = {}
Aule.sailing.isCheckingHarbour = false
Aule.sailing.currentRole = "No"

Aule.sailing.roles = {
  No = "None",
  Ca = "Captain",
  Ba = "Ballista",
  On = "Onager",
  Wa = "Watch",
  He = "Helm",
}

Aule.sailing.points = {
  galley = { [0] = 0, 0, 2, 4, 6, 8, 10, 11, 12 },
  strider = { [0] = 0, 0, 3, 4, 6, 8, 9, 10, 10 },
  cutter = { [0] = 0, 2, 4, 5, 7, 8, 8, 9, 9 },
}

Aule.sailing.rowingEffectiveness = {
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

Aule.sailing.ship = {}

Aule.sailing.startCapturingShips = false

Aule.sailing.dbStructure = {
  ships = {
    roomId = 0,
    longName = "",
    shortName = "",
    perms = 0,
    _unique = { "shortName" },
  }
}

Aule.sailing.db = db:create("sailing", Aule.sailing.dbStructure)

function Aule.sailing.addShip(shortName, longName, perms, roomId)

  perms = perms or ""

  local newShip = {
    roomId = roomId,
    longName = longName,
    shortName = shortName,
    perms = #perms
  }

  Aule.sailing.toAdd[#Aule.sailing.toAdd + 1] = newShip
end

function Aule.sailing.finishCheckingHarbour()
  Aule.sailing.isCheckingHarbour = false
  Aule.sailing.startCapturingShips = false
  Aule.sailing.startGaggingLines = false

  if #Aule.sailing.toAdd > 0 then
    db:add(Aule.sailing.db.ships, unpack(Aule.sailing.toAdd))
    Aule.sailing.toAdd = {}
  end

  if #Aule.sailing.toUpdate > 0 then
    for _, ship in ipairs(Aule.sailing.toUpdate) do
      db:update(Aule.sailing.db.ships, ship)
    end
    Aule.sailing.toUpdate = {}
  end

  local knownShipsHere = Aule.sailing.getShipsInRoom(mmp.currentroom)

  for _, ship in ipairs(knownShipsHere) do
    if not Aule.sailing.allFoundShips[ship.shortName] then
      ship.roomId = 0
      db:update(Aule.sailing.db.ships, ship)
    end
  end

  Aule.sailing.allFoundShips = {}

  Aule.sailing.printHarbourReport()
end

function Aule.sailing.getPermissionName(num)
  if num == 1 then return "Passenger"
  elseif num == 2 then return "Crew"
  elseif num == 3 then return "Captain" end

  return "None"
end

function Aule.sailing.getShip(shortName)
  local results = db:fetch(Aule.sailing.db.ships, db:eq(Aule.sailing.db.ships.shortName, shortName))

  if #results == 0 then return nil end

  if #results > 1 then
    Aule.sailing.say("Got back multiple ships, returning the first one.")
  end

  return results[1]
end

function Aule.sailing.getShipsInRoom(roomId)
  return db:fetch(Aule.sailing.db.ships, db:eq(Aule.sailing.db.ships.roomId, roomId))
end

function Aule.sailing.giveBalance()
  Aule.sailing.crewBalance = true
  raiseEvent("aule.sailing.gotCrewbalance")
end

function Aule.sailing.isCaptain()
  return Aule.sailing.currentRole == "Ca"
end

function Aule.sailing.printHarbourReport(targetRoomId)
  local roomId = tonumber(targetRoomId) or mmp.currentroom
  local foundShipsWithPerms = {}
  local shipsWithoutPerms = 0

  for _, ship in ipairs(Aule.sailing.getShipsInRoom(roomId)) do
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
    Aule.sailing.say(("There are no ships here that you have access to, and %s ships you don't."):format(shipsWithoutPerms))
    return
  end

  local reportLine = "| <HotPink>%-15s<reset> | <DodgerBlue>%-11s<reset> | <gold>%-38s<reset> |\n"
  local sep = "+-----------------+-------------+----------------------------------------+\n"

  Aule.sailing.say("Ship report:\n")

  cecho(sep)
  cecho(reportLine:format("ID", "Perms", "Name"))
  cecho(sep)

  for _, ship in ipairs(foundShipsWithPerms) do
    cechoLink(reportLine:format(ship.shortName, Aule.sailing.getPermissionName(ship.perms), ship.longName),
      function() send("board ship " .. ship.shortName) end, "Board " .. ship.shortName, true)
  end
  cecho(sep)
  echo("\n")
  cecho(("Plus <green>%s<reset> ships you don't have access to."):format(shipsWithoutPerms))
end

function Aule.sailing.say(what)
  cecho(("\n<white>[<MediumBlue>Sailing<white>]<reset> %s"):format(what))
end

function Aule.sailing.setShip(longName, shortName, perms)
  local ship = Aule.sailing.getShip(shortName)

  Aule.sailing.allFoundShips[shortName] = true

  if not ship then
    Aule.sailing.addShip(shortName, longName, perms, mmp.currentroom)
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

  Aule.sailing.toUpdate[#Aule.sailing.toUpdate + 1] = ship
end

function Aule.sailing.takeBalance()
  Aule.sailing.crewBalance = false
  raiseEvent("aule.sailing.lostCrewbalance")
end

function Aule.sailing.turnShip(dir)
  if not Aule.sailing.isCaptain() then return false end

  send("ship turn " .. dir)
  return true
end

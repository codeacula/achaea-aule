aule.ui.ihList = aule.ui.ihList or {}
aule.ui.ihList.items = {}
aule.ui.ihList.players = {}

function aule.ui.ihList.addItem(item)
  aule.ui.ihList.items[#aule.ui.ihList.items + 1] = item
  aule.ui.ihList.update()
end

function aule.ui.ihList.addPlayer(player) aule.ui.ihList.players[player] = true end

function aule.ui.ihList.build()
  local parent = aule.ui.containers["leftContainer"]

  local ihConsole = aule.ui.console({
    name = "ihConsole",
    x = "0%",
    y = "50%",
    width = "100%",
    height = "50%"
  }, parent)

  if not ihConsole then
    aule.warn("Unable to create ihConsole")
    return
  end

  ihConsole:disableScrollBar()
  ihConsole:setColor("black")

  aule.ui.ihList.console = ihConsole
end

function aule.ui.ihList.getSortedPlayers()
  local allPlayers = {}

  for playerName, _ in pairs(aule.ui.ihList.players) do
    if not gmcp.Char.Status.name or gmcp.Char.Status.name ~= playerName then
      allPlayers[#allPlayers + 1] = playerName
    end
  end

  return allPlayers
end

function aule.ui.ihList.remove(incItem)
  for i, item in ipairs(aule.ui.ihList.items) do
    if item.id == incItem.id then
      table.remove(aule.ui.ihList.items, i)
      return
    end
  end
end

function aule.ui.ihList.removeItem(item)
  aule.ui.ihList.remove(item)
  aule.ui.ihList.update()
end

function aule.ui.ihList.removePlayer(player)
  aule.ui.ihList.players[player] = true
end

function aule.ui.ihList.setList(items)
  aule.ui.ihList.items = items
  aule.ui.ihList.update()
end

function aule.ui.ihList.setPlayers(playerList)
  aule.ui.ihList.players = {}

  for _, playerInfo in ipairs(playerList) do
    aule.ui.ihList.players[playerInfo.name] = true
  end

  aule.ui.ihList.update()
end

function aule.ui.ihList.update()
  local console = aule.ui.ihList.console
  console:clear()

  local players = aule.ui.ihList.getSortedPlayers()

  if #players > 0 then

    console:cecho("<gold>Players Here:\n")
  
    for _, playerName in pairs(players) do
      console:cechoLink(playerName .. "\n",
        function() raiseEvent("aule.combat.setTarget", playerName) end, "Target "..playerName, true)
    end

    console:echo("\n")
  end

  console:cecho("<gold>Items Here:\n")

  for _, item in ipairs(aule.ui.ihList.items) do
    console:cechoLink(item.name .. "\n",
      function() send("probe " .. item.id) end, "Probe "..item.name, true)
  end
end

registerNamedEventHandler("aule", "aule.ui.ihList.build",
  "aule.ui.containersReady", aule.ui.ihList.build)

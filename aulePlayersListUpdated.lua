function aulePlayersListUpdated()
  local playerList = {}
  local playersHere = aule.cache.playersHere or {}
  
  for player, _ in pairs(playersHere) do
    playerList[player] = true
  end
  
  aule.cache.playersHere = {}
  for _, playerInfo in ipairs(gmcp.Room.Players) do
    aule.cache.playersHere[playerInfo.name] = true
  end
  
  raiseEvent("aule.playersHereUpdated", aule.cache.playersHere)
end

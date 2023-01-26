function aulePlayerLeftRoom()
  aule.cache.playersHere[gmcp.Room.RemovePlayer] = nil
  
  raiseEvent("aule.playerLeft", gmcp.Room.RemovePlayer)
end

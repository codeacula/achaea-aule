function aulePlayerEnteredRoom()
  aule.cache.playersHere[gmcp.Room.AddPlayer.name] = true
  
  raiseEvent("aule.playerEntered", gmcp.Room.AddPlayer.name)
 end

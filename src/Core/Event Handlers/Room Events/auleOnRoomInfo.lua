aule.cache.lastRoomId = 0

function auleOnRoomInfo()
  if gmcp.Room.Info.num ~= aule.cache.lastRoomId then
    raiseEvent("aule.changedRooms", gmcp.Room.Info.num)
    aule.cache.lastRoomId = gmcp.Room.Info.num
  end
end

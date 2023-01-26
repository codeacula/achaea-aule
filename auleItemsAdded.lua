function auleItemsAdded()
  local info = gmcp.Char.Items.Add
  
  if info.location == "room" then
    if info.item.name == "some gold sovereigns" then
      raiseEvent("aule.goldDropped")
      return
    end
  end
end

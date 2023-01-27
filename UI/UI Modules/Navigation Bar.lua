aule.ui.navigationBar = aule.ui.navigationBar or {}
aule.ui.navigationBar.navContainer = aule.ui.navigationBar.navContainer or nil

function aule.ui.navigationBar.addCategory(name, callback)
  local newLabel = aule.ui.label({
    name = "topLabelParent" .. name,
    nestable = true,
  }, aule.ui.containers["navigationContainer"])

  if not newLabel then
    aule.warn("Unable to create newLabel")
    return
  end

  newLabel:setStyleSheet(aule.ui.styles.topButton)

  newLabel:echo("<center>" .. name, nil, "10")

  function newLabel:addDropdownChild(name, displayName, roomNum)
    local newChild = self:addChild({
      name = name, flyOut = true, nestable = true,
      height = px(30), layoutDir = "BV",
    })

    newChild:echo("<center>" .. displayName, nil, "10")
    newChild:setStyleSheet(aule.ui.styles.topButtonChild)

    if roomNum then
      newChild:setClickCallback(function() mmp.gotoRoom(roomNum) end)
    end

    function newChild:addDropdownChild(childName, display, childRoomNum)
      local newChild = self:addChild({
        name = childName, flyOut = true,
        height = px(30), layoutDir = "RV",
      })

      newChild:echo("<center>" .. display, nil, "10")
      newChild:setStyleSheet(self.stylesheet)

      if childRoomNum then
        newChild:setClickCallback(function() mmp.gotoRoom(childRoomNum) end)
      end

      return newChild
    end

    return newChild
  end

  if callback then
    newLabel:setClickCallback(callback)
  end

  return newLabel
end

function aule.ui.navigationBar.build()
  if not aule.ui.layout.navigationBar.active then
    aule.log("Health bars are inactive, not building")
    return
  end

  local parent = aule.ui.containers[aule.ui.layout.navigationBar.parent]

  local navigationBox = aule.ui.hbox({
    name = "navigationContainer",
    x = "0%", y = "40%", height = "50%", width = "90%"
  }, parent)

  raiseEvent("aule.ui.navigationCreated")
end

registerNamedEventHandler("aule", "aule.ui.navigationBar.build", "aule.ui.containersReady", aule.ui.navigationBar.build)

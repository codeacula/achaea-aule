function auleHuntingAddSettings()
  if not keneanung or not keneanung.bashing then
    aule.log("keneanung missing, not adding settings")
    return
  end

  aule.log("Adding settings for hunting")

  aule.hunting.buttons.bashingToggle = aule.ui.settingsWindow.addButton("toggleBashing", "Bashing", 1)
  aule.hunting.buttons.bashingToggle:registerClickCallback(function(button)
    keneanung.bashing.toggle("enabled", "Bashing")
    aule.hunting.uihelpers.updateHuntingButton()
  end)

  aule.hunting.buttons.pickupToggle = aule.ui.settingsWindow.addButton("togglePickup", "Pickup", 1)
  aule.hunting.buttons.pickupToggle:registerClickCallback(function(button)
    keneanung.bashing.toggle("autopickup", "Pickup")
    aule.hunting.uihelpers.updatePickupButton()
  end)

  aule.hunting.buttons.attackToggle = aule.ui.settingsWindow.addButton("toggleAutoattack", "Auto Attack", 1)
  aule.hunting.buttons.attackToggle:registerClickCallback(function(button)
    aule.hunting.attackOnUpdate = not aule.hunting.attackOnUpdate

    local color = "<green>ON"

    if not aule.hunting.attackOnUpdate then
      color = "<red>OFF"
    end

    aule.say("<green>Automatically attacking<reset> has been turned " .. color)

    aule.hunting.uihelpers.updateAutoButton()
  end)

  aule.hunting.uihelpers.updateAutoButton()
  aule.hunting.uihelpers.updateHuntingButton()
  aule.hunting.uihelpers.updatePickupButton()
end

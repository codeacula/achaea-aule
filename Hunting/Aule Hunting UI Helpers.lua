aule.hunting.uihelpers = aule.hunting.uihelpers or {}

function aule.hunting.uihelpers.updateAutoButton()
  if not aule.ui then return end

  if aule.hunting.attackOnUpdate then
    aule.hunting.buttons.attackToggle:setStyleSheet(aule.ui.styles.buttonActive)
  else
    aule.hunting.buttons.attackToggle:setStyleSheet(aule.ui.styles.buttonInactive)
  end
end

function aule.hunting.uihelpers.updateHuntingButton()
  if not aule.ui then return end

  if keneanung.bashing.configuration.enabled then
    aule.hunting.buttons.bashingToggle:setStyleSheet(aule.ui.styles.buttonActive)
  else
    aule.hunting.buttons.bashingToggle:setStyleSheet(aule.ui.styles.buttonInactive)
  end
end

function aule.hunting.uihelpers.updatePickupButton()
  if not aule.ui then return end

  if keneanung.bashing.configuration.autopickup then
    aule.hunting.buttons.pickupToggle:setStyleSheet(aule.ui.styles.buttonActive)
  else
    aule.hunting.buttons.pickupToggle:setStyleSheet(aule.ui.styles.buttonInactive)
  end
end

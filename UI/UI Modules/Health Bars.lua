aule.ui.healthBars = aule.ui.healthBars or {}
aule.ui.healthBars.barEmpty = { 5, 30, 255 }
aule.ui.healthBars.barWarning = { 13, 255, 33 }
aule.ui.healthBars.healthBarFull = { 13, 255, 33 }
aule.ui.healthBars.manaBarFull = { 5, 30, 255 }

aule.ui.healthBars.healthGauge = aule.ui.healthBars.healthGauge or nil
aule.ui.healthBars.manaGauge = aule.ui.healthBars.manaGauge or nil

function aule.ui.healthBars.buildHealthBars()
  if not aule.ui.layout.healthBars.active then
    aule.log("Health bars are inactive, not building")
    return
  end

  local parent = aule.ui.containers[aule.ui.layout.healthBars.parent]

  local healthGauge = aule.ui.gauge({
    name = "healthBar",
    x = "0%", y = "20%",
    width = "45%", height = "70%"
  }, parent)

  if not healthGauge then
    aule.warn("Unable to create healthGauge")
    return
  end

  healthGauge.back:setStyleSheet(aule.ui.styles.healthBack)
  healthGauge:setValue(0, 100)

  healthGauge.back:setClickCallback("raiseEvent", "aule.healthBarClicked")
  healthGauge.front:setClickCallback("raiseEvent", "aule.healthBarClicked")

  aule.ui.healthBars.healthGauge = healthGauge

  local manaGauge = aule.ui.gauge({
    name = "manaBar",
    x = "48%", y = "20%",
    width = "45%", height = "70%"
  }, parent)

  if not manaGauge then
    aule.warn("Unable to create manaGauge")
    return
  end

  manaGauge.back:setStyleSheet(aule.ui.styles.manaBack)
  manaGauge:setValue(0, 100)

  manaGauge.back:setClickCallback("raiseEvent", "aule.healthBarClicked")
  manaGauge.front:setClickCallback("raiseEvent", "aule.healthBarClicked")

  aule.ui.healthBars.manaGauge = manaGauge
end

registerNamedEventHandler("aule", "aule.ui.healthBars.buildHealthBars", "aule.ui.containersReady",
  aule.ui.healthBars.buildHealthBars)

function aule.ui.healthBars.updateHealthBar()
  if not svo.stats.hp then return end

  local healthGauge = aule.ui.healthBars.healthGauge

  if not healthGauge then return end

  if svo.stats.hp > 70 then
    healthGauge.front:setStyleSheet(aule.ui.styles.calculateBackground(aule.ui.healthBars.healthBarFull,
      aule.ui.healthBars.barWarning, svo.stats.currenthealth, svo.stats.maxhealth, svo.stats.maxhealth * .7))
  else
    healthGauge.front:setStyleSheet(aule.ui.styles.calculateBackground(aule.ui.healthBars.barWarning,
      aule.ui.healthBars.barEmpty, svo.stats.currenthealth, svo.stats.maxhealth * .7, 1))
  end

  healthGauge:setValue(svo.stats.currenthealth, svo.stats.maxhealth,
    "<b><center>" .. svo.stats.currenthealth .. "H</center></b>")
end

function aule.ui.healthBars.updateManaBar()
  if not svo.stats.mp then return end
  local manaGauge = aule.ui.healthBars.manaGauge

  if not manaGauge then return end

  if svo.stats.mp > 70 then
    manaGauge.front:setStyleSheet(aule.ui.styles.calculateBackground(aule.ui.healthBars.manaBarFull,
      aule.ui.healthBars.barWarning, svo.stats.currentmana, svo.stats.maxhealth, svo.stats.maxmana * .7))
  else
    manaGauge.front:setStyleSheet(aule.ui.styles.calculateBackground(aule.ui.healthBars.barWarning,
      aule.ui.healthBars.barEmpty, svo.stats.currentmana, svo.stats.maxmana * .7, 1))
  end

  manaGauge:setValue(svo.stats.currentmana, svo.stats.maxmana, "<b><center>" .. svo.stats.currentmana .. "H</center></b>")
end

aule.ui.maps = aule.ui.maps or {}

function aule.ui.maps.buildMapContainer()
  local parent = aule.ui.containers[aule.ui.layout.map.parent]

  local mapContainer = aule.ui.container({
    name = "mapContainer",
    x = aule.ui.layout.map.x, y = aule.ui.layout.map.y,
    width = aule.ui.layout.map.width, height = aule.ui.layout.map.height
  }, parent)

  local mapHeader = aule.ui.hbox({
    name = "mapHeader",
    x = 0, y = 0,
    width = "100%", height = "7%"
  }, mapContainer)

  local mapFooter = aule.ui.container({
    name = "mapFooter",
    x = 0, y = "7%",
    width = "100%",
    height = "93%",
  }, mapContainer)

  aule.ui.maps.mudletMapContainer = aule.ui.container({
    name = "mudletMapContainer",
    x = 0, y = 0,
    width = "100%", height = "100%"
  }, mapFooter)

  aule.ui.maps.mudletMap = aule.ui.mapper({
    name = "mudletMap",
    x = "5%", y = "5%",
    width = "95%", height = "95%"
  }, mapContainer)

  aule.ui.maps.capturedWilderness = false
  aule.ui.maps.capturingWilderness = false
  aule.ui.maps.ignorePrompt = false
  aule.ui.maps.inWilderness = false

  aule.ui.maps.wildernessMap = aule.ui.console({
    name = "wildernessMap",
    x = 0, y = 0,
    height = "100%", width = "100%"
  }, mapFooter)
  aule.ui.maps.wildernessMap:setColor("black")
  aule.ui.maps.wildernessMap:setFontSize(11)

  aule.ui.maps.mapTab = aule.ui.maps.addTab("Mudlet")
  aule.ui.maps.mapTab:setStyleSheet(aule.ui.styles.chatActive)

  aule.ui.maps.wildernessTab = aule.ui.maps.addTab("Wilderness")
  aule.ui.maps.wildernessTab:setStyleSheet(aule.ui.styles.chatNormal)

  aule.ui.maps.wildernessMap:hide()
  setMiniConsoleFontSize("wildernessMap", 10)

end

registerNamedEventHandler("aule", "aule.ui.maps.buildMapContainer", "aule.ui.containersReady",
  aule.ui.maps.buildMapContainer)

function aule.ui.maps.activateMap(name)
  if name == "Wilderness" then
    aule.ui.maps.showWilderness()
    aule.ui.maps.inWilderness = true
  else
    aule.ui.maps.showMap()
    aule.ui.maps.inWilderness = false
  end
end

function aule.ui.maps.addTab(name)
  local newLabel = aule.ui.label({
    name = name .. "MapLabel",
    fgColor = "#ffffff"
  }, aule.ui.containers["mapHeader"])

  if not newLabel then
    aule.warn("Unable to create newLabel")
    return
  end

  newLabel:echo("<center>" .. name, nil, "10")

  newLabel:setStyleSheet(aule.ui.styles.chatNormal)

  newLabel:setClickCallback("aule.ui.maps.activateMap", name)
  return newLabel
end

function aule.ui.maps.showMap()
  aule.ui.maps.mapTab:setStyleSheet(aule.ui.styles.chatActive)
  aule.ui.maps.wildernessTab:setStyleSheet(aule.ui.styles.chatNormal)
  aule.ui.maps.wildernessMap:hide()
  aule.ui.maps.mudletMapContainer:show()
  aule.ui.maps.inWilderness = false
end

function aule.ui.maps.showWilderness()
  aule.ui.maps.mapTab:setStyleSheet(aule.ui.styles.chatNormal)
  aule.ui.maps.wildernessTab:setStyleSheet(aule.ui.styles.chatActive)
  aule.ui.maps.mudletMapContainer:hide()
  aule.ui.maps.wildernessMap:show()
  aule.ui.maps.inWilderness = true
end

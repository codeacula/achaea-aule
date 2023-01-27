if not aule then
  printError("Aule Core isn't loaded! You need to load Aule Core first!")
  return
end

function px(amount)
  if not amount then
    debug.traceback()
    debugc("Was given an invalid amount! Returning 0")
    return 0
  end
  return amount .. "px"
end

aule.ui = aule.ui or {}
aule.ui.chatTabs = {
  {
    name = "Private",
    channels = {
      "says",
      "party",
      "tell %w+",
      "gt",
    }
  },
  {
    name = "City/House",
    channels = {
      "armytell",
      "ct",
      "ht",
      "hnt"
    }
  },
  {
    name = "Clans",
    channels = {
      "clt%d+",
    }
  },
}

aule.ui.containers = aule.ui.containers or {}
aule.ui.layout = {
  bottom = {
    height = 50,
    width = "100%",
  },
  chat = {
    height = "35%",
    parent = "rightContainer",
    width = "100%",
    x = px(0),
    y = px(0),
  },
  healthBars = {
    active = true,
    parent = "bottomLabel",
  },
  left = {
    height = "100%",
    width = 200
  },
  map = {
    height = "65%",
    parent = "rightContainer",
    width = "100%",
    x = px(0),
    y = "35%",
  },
  navigationBar = {
    active = true,
    parent = "topLabel",
  },
  right = {
    height = "100%",
    width = 600
  },
  statusBar = {
    active = true,
    parent = "topLabel",
  },
  top = {
    height = 50,
    width = "100%",
  },
}

aule.ui.window = {}
aule.ui.window.width, aule.ui.window.height = getMainWindowSize()

function aule.ui.buildContainers()
  aule.ui.buildRightContainer()
  aule.ui.buildBottomContainer()
  aule.ui.buildTopContainer()
  aule.ui.buildLeftContainer()

  raiseEvent("aule.ui.containersReady")
end

function aule.ui.copySettings(containerKey)
  if not auleUiSettings or not auleUiSettings[containerKey] then return end

  for key, val in pairs(aule.ui.layout[containerKey]) do
    aule.ui.layout[containerKey][key] = auleUiSettings[containerKey][key] or val
  end

  if auleChatSettings then
    aule.ui.chatTabs = auleChatSettings
  end
end

function aule.ui.importUserSettings()
  if not auleUiSettings then return end

  for key, _ in pairs(aule.ui.layout) do
    aule.ui.copySettings(key)
  end
end

function aule.ui.setBorders()
  setBorderBottom(aule.ui.layout.bottom.height)
  setBorderTop(aule.ui.layout.top.height)
  setBorderLeft(aule.ui.layout.left.width)
  setBorderRight(aule.ui.layout.right.width)

  setCmdLineStyleSheet("main",
    ("QPlainTextEdit { padding-left: %spx; background-color: black; }"):format(aule.ui.layout.left.width))
end

function aule.ui.onLoad()
  aule.ui.importUserSettings()
  aule.ui.setBorders()
  aule.ui.buildContainers()
  aule.say("UI Loaded")
end

registerNamedEventHandler("Aule", "aule.io.onLoad", "aule.loaded", aule.ui.onLoad)

aule.registerEventHandler("UI", "aule.loaded", "aule.ui.onLoad", "Configures the UI once everything has been loaded.")

aule.ui.settingsWindow = aule.ui.settingsWindow or {}
aule.ui.settingsWindow.buttonHeight = 30
aule.ui.settingsWindow.buttonRows = 10
aule.ui.settingsWindow.buttons = aule.ui.settingsWindow.buttons or {}
aule.ui.settingsWindow.container = aule.ui.settingsWindow.container or nil
aule.ui.settingsWindow.rows = aule.ui.settingsWindow.rows or {}

function aule.ui.settingsWindow.addButton(name, display, row)
  if aule.ui.settingsWindow.buttons[name] then
    aule.ui.settingsWindow.buttons[name]:hide()
  end

  local newButton = aule.ui.label({
    name = name .. "Button",
    fgColor = "#ffffff"
  }, aule.ui.settingsWindow.rows[row].container)

  if not newButton then
    aule.warn("Unable to create newButton")
    return
  end

  newButton:echo("<center>" .. display, nil, "8")

  newButton:setStyleSheet(aule.ui.styles.buttonNormal)

  newButton:setClickCallback("aule.ui.settingsWindow.handleSettingsClicked", name)

  newButton:show()

  table.insert(aule.ui.settingsWindow.rows[row].buttons, newButton)

  aule.ui.settingsWindow.buttons[name] = newButton

  newButton.registeredClickCallbacks = {}

  function newButton:registerClickCallback(func)
    self.registeredClickCallbacks[#self.registeredClickCallbacks + 1] = func
  end

  function newButton:callRegisteredCallbacks()
    for _, func in ipairs(newButton.registeredClickCallbacks) do
      func(self)
    end
  end

  return newButton
end

function aule.ui.settingsWindow.buildSettingsContainer()
  local name = "Settings"
  local newLabel = aule.ui.chats.createChatLabel(name)

  local newWindow = aule.ui.label({
    name = name,
    x = 0, y = 0,
    height = "100%", width = "100%"
  }, aule.ui.containers["chatFooter"])

  if not newWindow then
    aule.warn("Unable to create newWindow")
    return
  end

  newWindow:hide()

  aule.ui.chats[name] = { label = newLabel, name = name, window = newWindow }
  aule.ui.settingsWindow.container = aule.ui.chats[name]

  for i = 1, aule.ui.settingsWindow.buttonRows do
    aule.ui.settingsWindow.setUpRow(i)
  end

  raiseEvent("aule.ui.settingsCreated")
  aule.ui.chats.hideChat(name)
end

function aule.ui.settingsWindow.setUpRow(row)
  aule.ui.settingsWindow.rows[row] = {}
  aule.ui.settingsWindow.rows[row].buttons = {}

  aule.ui.settingsWindow.rows[row].container = aule.ui.hbox({
    name = "buttonRow" .. row,
    x = 0, y = aule.ui.settingsWindow.buttonHeight * (row - 1),
    width = "100%", height = px(aule.ui.settingsWindow.buttonHeight)
  }, aule.ui.settingsWindow.container.window)

  aule.ui.settingsWindow.rows[row].container:show()
end

registerNamedEventHandler("aule", "aule.ui.settingsWindow.buildSettingsContainer", "aule.ui.containersReady",
  aule.ui.settingsWindow.buildSettingsContainer)

function aule.ui.settingsWindow.handleSettingsClicked(funcName, name)
  local button = aule.ui.settingsWindow.buttons[funcName]
  button:callRegisteredCallbacks()
end

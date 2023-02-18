aule.ui.chats = aule.ui.chats or {
  activeChat = nil
}

function aule.ui.chats.activateTab(name)
  if not aule.ui.chats[name] then return end

  if aule.ui.chats.activeChat then
    aule.ui.chats.hideChat(aule.ui.chats.activeChat.name)
  end

  aule.ui.chats.activeChat = aule.ui.chats[name]

  aule.ui.chats.showChat(aule.ui.chats.activeChat.name)
end

function aule.ui.chats.buildChatContainer()
  local parent = aule.ui.containers[aule.ui.layout.chat.parent]

  local container = aule.ui.container({
    name = "chatContainer",
    x = aule.ui.layout.chat.x, y = aule.ui.layout.chat.y,
    width = aule.ui.layout.chat.width, height = aule.ui.layout.chat.height
  }, parent)

  aule.ui.hbox({
    name = "chatHeader",
    x = 0, y = 0,
    width = "100%", height = "10%"
  }, container)

  local footer = aule.ui.label({
    name = "chatFooter",
    x = 0, y = "10%",
    width = "100%",
    height = "90%",
  }, container)

  if not footer then
    aule.warn("Unable to create footer")
    return
  end

  footer:setStyleSheet([[
    background-color: #050F2B;
  ]])

  aule.ui.chats.createChatTab("Important", parent)
  aule.ui.chats.activateTab("Important")

  for _, group in pairs(aule.ui.chatTabs) do
    aule.ui.chats.createChatTab(group.name, parent)
  end

  aule.ui.settingsWindow.buildSettingsContainer()

end

registerNamedEventHandler("aule", "aule.ui.buildChatContainer", "aule.ui.containersReady",
  aule.ui.chats.buildChatContainer)

function aule.ui.chats.createChatTab(name, parent)
  local newLabel = aule.ui.chats.createChatLabel(name)

  local newWindow = aule.ui.console({
    name = name .. "ChatWindow",
    x = 0, y = 0,
    height = "100%", width = "100%"
  }, aule.ui.containers["chatFooter"])

  if not newWindow then
    aule.warn("Unable to create newWindow")
    return
  end

  newWindow:setFontSize(10)
  newWindow:setWrap(math.floor(string.match(parent.width, "(%d+)px") / 8))
  newWindow:setColor("black")
  newWindow:enableAutoWrap()

  newWindow:hide()

  aule.ui.chats[name] = { label = newLabel, name = name, window = newWindow }

  return aule.ui.chats[name]
end

function aule.ui.chats.createChatLabel(name)
  local newLabel = aule.ui.label({
    name = name .. "ChatLabel",
    fgColor = "#ffffff"
  }, aule.ui.containers["chatHeader"])

  if not newLabel then
    aule.warn("Unable to create newWindow")
    return
  end

  newLabel:echo("<center>" .. name, nil, "10")

  newLabel:setStyleSheet(aule.ui.styles.chatNormal)

  newLabel:setClickCallback("aule.ui.chats.activateTab", name)
  return newLabel
end

function aule.ui.chats.flashChat(name)
  if aule.ui.chats.activeChat.name == name then return end

  aule.ui.chats[name].label:setStyleSheet(aule.ui.styles.chatAlert)
end

function aule.ui.chats.hideChat(name)
  if not aule.ui.chats[name] then return end

  aule.ui.chats[name].window:hide()
  aule.ui.chats[name].label:setStyleSheet(aule.ui.styles.chatNormal)
end

function aule.ui.chats.send(name, text)
  local timeStamp = getTime(true, "hh:mm:ss")

  aule.ui.chats[name].window:cecho("<white>" .. timeStamp .. " - ")
  aule.ui.chats[name].window:decho(text .. "\n")
  aule.ui.chats.flashChat(name)
end

function aule.ui.chats.showChat(name)
  aule.ui.chats[name].window:show()
  aule.ui.chats[name].label:setStyleSheet(aule.ui.styles.chatActive)
end

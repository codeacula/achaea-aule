aule.cache.chat = {}

function auleHandleIncomingChat()
  local text = ansi2decho(gmcp.Comm.Channel.Text.text)

  if not aule.cache.chat[gmcp.Comm.Channel.Text.channel] then
    aule.cache.chat[gmcp.Comm.Channel.Text.channel] = {}
    for _, chatGroup in ipairs(aule.ui.chatTabs) do
      for _, channel in ipairs(chatGroup.channels) do
        if string.match(gmcp.Comm.Channel.Text.channel, channel) then
          aule.cache.chat[gmcp.Comm.Channel.Text.channel][chatGroup.name] = true
        end
      end
    end
  end

  for chatTab, _ in pairs(aule.cache.chat[gmcp.Comm.Channel.Text.channel]) do
    aule.ui.chats.send(chatTab, text)
  end
end

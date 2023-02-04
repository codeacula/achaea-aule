aule.ui.characterBar = aule.ui.characterBar or {}

function aule.ui.characterBar.build()
  if not aule.ui.layout.statusBar.active then
    aule.log("Status Bar not active")
    return
  end

  local parent = aule.ui.containers[aule.ui.layout.statusBar.parent]

  local characterInfoConsole = aule.ui.console({
    name = "characterInfoConsole",
    x = "0%", y = "0%",
    width = "100%", height = "30%"
  }, parent)

  if not characterInfoConsole then
    aule.warn("Unable to create characterInfoConsole")
    return
  end

  characterInfoConsole:disableScrollBar()

  aule.ui.characterBar.console = characterInfoConsole
end

registerNamedEventHandler("aule", "aule.ui.characterBar.build", "aule.ui.containersReady", aule.ui.characterBar.build)

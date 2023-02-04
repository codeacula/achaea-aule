aule.ui.ihList = aule.ui.ihList or {}

function aule.ui.ihList.build()
  local parent = aule.ui.containers[aule.ui.layout.ihList.parent]
  display(parent)

  local ihConsole = aule.ui.console({
    name = "ihConsole",
    x = aule.ui.layout.ihList.x, y = aule.ui.layout.ihList.y,
    width = aule.ui.layout.ihList.width, height = aule.ui.layout.ihList.height
  }, parent)

  if not ihConsole then
    aule.warn("Unable to create ihConsole")
    return
  end

  ihConsole:disableScrollBar()

  aule.ui.ihList.console = ihConsole
  ihConsole:cecho("Here")
end

registerNamedEventHandler("aule", "aule.ui.characterBar.build", "aule.ui.containersReady", aule.ui.ihList.build)

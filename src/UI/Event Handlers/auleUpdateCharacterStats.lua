function auleUpdateCharacterStats()
  if not aule.ui.layout.statusBar.active then
    aule.log("Skipping processing stats.")
    return
  end

  if not gmcp or not gmcp.Char or not gmcp.Char.Status then return end

  local console = aule.ui.characterBar.console

  clearUserWindow(console.name)

  local stats = gmcp.Char.Status
  console:setFontSize(10)
  console:cecho(("<purple>%s "):format(stats.name))
  console:cecho(("<white> XP:<gold>%s "):format(stats.level))
  console:cecho(("<white> Gold:<gold>%s "):format(stats.gold))
  console:cecho(("<white> Unbound:<gold>%s "):format(stats.unboundcredits))
  console:cecho(("<white> Bound:<gold>%s "):format(stats.boundcredits))

  if stats.unread_msgs == "0" then
    console:cecho(("<white> Messages:<green>%s "):format(stats.unread_msgs))
  else
    console:cecho(("<white> Messages:<red>%s "):format(stats.unread_msgs))
  end
end

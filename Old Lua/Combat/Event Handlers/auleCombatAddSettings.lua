function auleCombatAddSettings()
  aule.log("Adding settings for combat")

  aule.ui.settingsWindow.addButton("toggleBasicDefs", "Basic Defs", 2):registerClickCallback(
    function()
      svo.defs.switch("basic", true)
    end)
  aule.ui.settingsWindow.addButton("toggleHuntingDefs", "Hunting Defs", 2):registerClickCallback(
    function()
      svo.defs.switch("hunting", true)
    end)
  aule.ui.settingsWindow.addButton("toggleCombatDefs", "Combat Defs", 2):registerClickCallback(
    function()
      svo.defs.switch("combat", true)
    end)
  aule.ui.settingsWindow.addButton("toggleEmptyDefs", "Empty Defs", 2):registerClickCallback(
    function()
      svo.defs.switch("empty", true)
    end)
end

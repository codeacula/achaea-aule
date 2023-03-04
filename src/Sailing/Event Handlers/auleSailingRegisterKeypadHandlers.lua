function auleSailingRegisterKeypadHandlers()
  aule.keypad.registerHandler("1", function() return aule.sailing.turnShip("sw") end)
  aule.keypad.registerHandler("2", function() return aule.sailing.turnShip("s") end)
  aule.keypad.registerHandler("3", function() return aule.sailing.turnShip("se") end)
  aule.keypad.registerHandler("4", function() return aule.sailing.turnShip("w") end)
  aule.keypad.registerHandler("5", function() return aule.sailing.sendIfIsCaptain("spyglass look") end)
  aule.keypad.registerHandler("6", function() return aule.sailing.turnShip("e") end)
  aule.keypad.registerHandler("7", function() return aule.sailing.turnShip("nw") end)
  aule.keypad.registerHandler("8", function() return aule.sailing.turnShip("n") end)
  aule.keypad.registerHandler("9", function() return aule.sailing.turnShip("ne") end)


  aule.keypad.registerHandler("0", function() return aule.sailing.turnShip("map") end)
  aule.keypad.registerHandler("/", function() return aule.sailing.turnShip("in") end)
  aule.keypad.registerHandler("*", function() return aule.sailing.turnShip("out") end)
  aule.keypad.registerHandler("-", function() return aule.sailing.turnShip("up") end)
  aule.keypad.registerHandler("+", function() return aule.sailing.turnShip("down") end)
  aule.keypad.registerHandler(".", function() return aule.sailing.turnShip("ih") end)
end

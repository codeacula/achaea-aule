function auleSetUpKeypadWhenLoaded()
  for key, dir in pairs(aule.keypad.directions) do
    aule.keypad.callbacks[key] = {}
  end
  
  raiseEvent("aule.keypad.registerCallbacks")
end

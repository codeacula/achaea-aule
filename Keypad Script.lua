aule.keypad = aule.keypad or {}

aule.keypad.callbacks = {}

aule.keypad.directions = {
  ["0"] = "map",
  ["1"] = "sw",
  ["2"] = "s",
  ["3"] = "se",
  ["4"] = "w",
  ["5"] = "look",
  ["6"] = "e",
  ["7"] = "nw",
  ["8"] = "n",
  ["9"] = "ne",
  ["/"] = "in",
  ["*"] = "out",
  ["-"] = "up",
  ["+"] = "down",
  ["."] = "ih",
}

function aule.keypad.registerHandler(key, func)
  if not aule.keypad.callbacks[key] then
    aule.warn("Key "..key.." isn't a valid key")
    return
  end
  
  aule.keypad.callbacks[key][#aule.keypad.callbacks[key] + 1] = func
end

function aule.keypad.processKey(key)
  if #aule.keypad.callbacks[key] == 0 then
    send(aule.keypad.directions[key])
    return
  end
  
  for _, func in ipairs(aule.keypad.callbacks[key]) do
    local quit = func()
    
    if quit then return end
  end
  
  send(aule.keypad.directions[key])
end

aule.sailing.trading = aule.sailing.trading or {}
aule.sailing.trading.alreadyVisited = {}
aule.sailing.trading.circuitBreakerCount = 0
aule.sailing.trading.circuitBreakerLimit = 100000

function aule.sailing.trading.checkIfWeAlreadyBought(what, dest)
  local limiter = 20
  local currentDest = dest

  while currentDest ~= nil and limiter > 0 do
    if not aule.sailing.trading.circuitBreaker() then return end
    if dest.buyWhat == what then return true end
    limiter = limiter - 1
    currentDest = dest.parent
  end

  return false
end

function aule.sailing.trading.circuitBreaker()
  aule.sailing.trading.circuitBreakerCount = aule.sailing.trading.circuitBreakerCount + 1

  if aule.sailing.trading.circuitBreakerCount >= aule.sailing.trading.circuitBreakerLimit then
    aule.warn("Hit the circuit breaker.")
    print(debug.traceback())
    return false
  end

  return true
end

function aule.sailing.trading.createDestination(name, buyWhat, buyCount, sellWhat, sellCount, fees, parent)
  return {
      name = name,
      dockingFee = fees,
      buyWhat = buyWhat,
      buyCount = buyCount,
      sellWhat = sellWhat,
      sellCount = sellCount,
      parent = parent,
      paths = {}
  }
end

function aule.sailing.trading.findHarbour(name)
  for _, harbourInfo in pairs(aule.sailing.ports) do
    if name == harbourInfo.name then
      return harbourInfo
    end
  end

  return nil
end

function aule.sailing.trading.findRoutes(where, what, count)
  aule.sailing.trading.alreadyVisited = {}
  local finalDestination = aule.sailing.trading.findHarbour(where)

  if not finalDestination then
    aule.warn("Unable to find harbour " .. where .. " in our list")
    return
  end

  local dest = aule.sailing.trading.createDestination(where, nil, nil, what, count, finalDestination.fee)
  local finalDest = aule.sailing.trading.processDestination(dest)

  display(finalDest)
  echo("Done!")
  aule.sailing.trading.circuitBreakerCount = 0
end

function aule.sailing.trading.getListOfCurrentTrades(dest)
  local currentTrades = {}

  local tempDest = dest

  while tempDest do
    if not aule.sailing.trading.circuitBreaker() then return end

    currentTrades[tempDest.sellWhat] = true
    tempDest = tempDest.parent
  end

  return currentTrades
end

function aule.sailing.trading.getPortTrades(port, what)
  local trades = {}
  local alreadyTrading = aule.sailing.trading.getListOfCurrentTrades(dest)

  if not alreadyTrading then
    aule.warn("Couldn't get a list of already traded items")
    return {}
  end

  for _, trade in ipairs(port.trades) do
    if not aule.sailing.trading.circuitBreaker() then return end
    if not alreadyTrading[trade.get.what] and trade.get.what == what then
      trades[#trades + 1] = trade
    end
  end

  return trades
end

function aule.sailing.trading.processDestination(dest)
  -- Go through every port that sells what the harbour
  for name, port in pairs(aule.sailing.ports) do
    if not aule.sailing.trading.circuitBreaker() then return end
    -- We don't need to revisit ports - this also is an easier way to prevent infinite recursion
    if not aule.sailing.trading.checkIfWeAlreadyBought(dest) then
      local foundTrades = aule.sailing.trading.getPortTrades(port, dest.sellWhat)

      for _, trade in ipairs(foundTrades) do
        if not aule.sailing.trading.circuitBreaker() then return end
        if not aule.sailing.trading.checkIfWeAlreadyBought(trade.get.what, dest) then
          dest.paths[#dest.paths + 1] = aule.sailing.trading.createDestination(name, trade.get.what, trade.get.amount,
                  trade.pay.what, trade.pay.amount, port.fee, dest)
        end
      end
    end
  end

  for _, nextDest in ipairs(dest.paths) do
    if not aule.sailing.trading.circuitBreaker() then return end
    aule.sailing.trading.processDestination(nextDest)
  end

  return dest
end

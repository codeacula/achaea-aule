aule.sailing.trading = aule.sailing.trading or {}
aule.sailing.trading.circuitBreakerCount = 0

function aule.sailing.trading.createDestination(name, buyWhat, buyCount, sellWhat, sellCount, fees)
  return {
    name = name,
    dockingFee = fees,
    buyWhat = buyWhat,
    buyCount = buyCount,
    sellWhat = sellWhat,
    sellCount = sellCount,
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
  local finalDestination = aule.sailing.trading.findHarbour(where)

  if not finalDestination then
    aule.warn("Unable to find harbour " .. where .. " in our list")
    return
  end

  local dest = aule.sailing.trading.createDestination(where, nil, nil, what, count, finalDestination.fee)
  local finalDest = aule.sailing.trading.processDestination(dest)
  display(finalDest)
  aule.sailing.trading.circuitBreakerCount = 0
end

function aule.sailing.trading.getPortTrades(port, what)
  local trades = {}
  for _, trade in ipairs(port.trades) do
    if trade.get.what == what then
      trades[#trades + 1] = trade
    end
  end

  return trades
end

function aule.sailing.trading.incrementAndCheckBreaker()
  aule.sailing.trading.circuitBreakerCount = aule.sailing.trading.circuitBreakerCount + 1

  -- 100k should be enough depth, right?
  if aule.sailing.trading.circuitBreakerCount > 100000 then
    aule.warn("Too many hits")
    return true
  end

  return false
end

function aule.sailing.trading.processDestination(dest)
  -- Go through every port that sells what the harbour
  for name, port in pairs(aule.sailing.ports) do
    local foundTrades = aule.sailing.trading.getPortTrades(port, dest.sellWhat)
    aule.sailing.trading.circuitBreakerCount = aule.sailing.trading.circuitBreakerCount + 1

    if aule.sailing.trading.incrementAndCheckBreaker() then return end

    for _, trade in ipairs(foundTrades) do
      if aule.sailing.trading.incrementAndCheckBreaker() then return end
      dest.paths[#dest.paths + 1] = aule.sailing.trading.createDestination(name, trade.get.what, trade.get.amount,
        trade.pay.what, trade.pay.amount, port.fee)
    end
  end

  for _, nextDest in ipairs(dest.paths) do
    if aule.sailing.trading.incrementAndCheckBreaker() then return end
    aule.sailing.trading.processDestination(nextDest)
  end

  return dest
end

AuleSailing.trading = AuleSailing.trading or {}
AuleSailing.trading.alreadyVisited = {}
AuleSailing.trading.circuitBreakerCount = 0
AuleSailing.trading.circuitBreakerLimit = 100000

function AuleSailing.trading.checkIfWeAlreadyBought(what, dest)
  local limiter = 20
  local currentDest = dest

  while currentDest ~= nil and limiter > 0 do
    if not AuleSailing.trading.circuitBreaker() then return end
    if dest.buyWhat == what then return true end
    limiter = limiter - 1
    currentDest = dest.parent
  end

  return false
end

function AuleSailing.trading.circuitBreaker()
  AuleSailing.trading.circuitBreakerCount = AuleSailing.trading.circuitBreakerCount + 1

  if AuleSailing.trading.circuitBreakerCount >= AuleSailing.trading.circuitBreakerLimit then
    aule.warn("Hit the circuit breaker.")
    print(debug.traceback())
    return false
  end

  return true
end

function AuleSailing.trading.createDestination(name, buyWhat, buyCount, sellWhat, sellCount, fees, parent)
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

function AuleSailing.trading.findHarbour(name)
  for _, harbourInfo in pairs(AuleSailing.ports) do
    if name == harbourInfo.name then
      return harbourInfo
    end
  end

  return nil
end

function AuleSailing.trading.findRoutes(where, what, count)
  AuleSailing.trading.alreadyVisited = {}
  local finalDestination = AuleSailing.trading.findHarbour(where)

  if not finalDestination then
    aule.warn("Unable to find harbour " .. where .. " in our list")
    return
  end

  local dest = AuleSailing.trading.createDestination(where, nil, nil, what, count, finalDestination.fee)
  local finalDest = AuleSailing.trading.processDestination(dest)

  display(finalDest)
  echo("Done!")
  AuleSailing.trading.circuitBreakerCount = 0
end

function AuleSailing.trading.getListOfCurrentTrades(dest)
  local currentTrades = {}

  local tempDest = dest

  while tempDest do
    if not AuleSailing.trading.circuitBreaker() then return end

    currentTrades[tempDest.sellWhat] = true
    tempDest = tempDest.parent
  end

  return currentTrades
end

function AuleSailing.trading.getPortTrades(port, what)
  local trades = {}
  local alreadyTrading = AuleSailing.trading.getListOfCurrentTrades(dest)

  if not alreadyTrading then
    aule.warn("Couldn't get a list of already traded items")
    return {}
  end

  for _, trade in ipairs(port.trades) do
    if not AuleSailing.trading.circuitBreaker() then return end
    if not alreadyTrading[trade.get.what] and trade.get.what == what then
      trades[#trades + 1] = trade
    end
  end

  return trades
end

function AuleSailing.trading.processDestination(dest)
  -- Go through every port that sells what the harbour
  for name, port in pairs(AuleSailing.ports) do
    if not AuleSailing.trading.circuitBreaker() then return end
    -- We don't need to revisit ports - this also is an easier way to prevent infinite recursion
    if not AuleSailing.trading.checkIfWeAlreadyBought(dest) then
      local foundTrades = AuleSailing.trading.getPortTrades(port, dest.sellWhat)

      for _, trade in ipairs(foundTrades) do
        if not AuleSailing.trading.circuitBreaker() then return end
        if not AuleSailing.trading.checkIfWeAlreadyBought(trade.get.what, dest) then
          dest.paths[#dest.paths + 1] = AuleSailing.trading.createDestination(name, trade.get.what, trade.get.amount,
            trade.pay.what, trade.pay.amount, port.fee, dest)
        end
      end
    end
  end

  for _, nextDest in ipairs(dest.paths) do
    if not AuleSailing.trading.circuitBreaker() then return end
    AuleSailing.trading.processDestination(nextDest)
  end

  return dest
end

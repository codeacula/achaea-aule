AuleSailing = AuleSailing or {}
AuleSailing.trading = AuleSailing.trading or {}
AuleSailing.trading.circuitBreakerCount = 0
AuleSailing.trading.circuitBreakerLimit = 10000
AuleSailing.trading.startingPoints = {}


-- This is the primary method to call when wanting to find available trade routes
function AuleSailing.trading.findTradeRoutes(where, what, amount)
  AuleSailing.trading.startingPoints = {}
  AuleSailing.trading.circuitBreakerCount = 0
  local finalDest = AuleSailing.trading.createStop(where, what, amount)

  AuleSailing.trading.processNextStops(finalDest)

  for _, start in ipairs(AuleSailing.trading.startingPoints) do
    AuleSailing.trading.getRouteSummary(start)
  end
end

function AuleSailing.trading.checkBreaker(msg)
  AuleSailing.trading.circuitBreakerCount = AuleSailing.trading.circuitBreakerCount + 1

  if msg then
    debugc(msg)
  end

  if AuleSailing.trading.circuitBreakerCount > AuleSailing.trading.circuitBreakerLimit then
    error("Hit the breaker limit!", 0)
  end
end

function AuleSailing.trading.createStop(where, payWhat, payAmount, getWhat, getAmount, nextDestination)
  return {
    where = where,
    payWhat = payWhat,
    payAmount = payAmount,
    getWhat = getWhat,
    getAmount = getAmount,
    next = nextDestination,
    totalToGet = payAmount
  }
end

function AuleSailing.trading.getRouteSummary(start)
  -- First, go to the end, because we'll need to do maths from there
  local currentDest = start
  local allDestinations = { currentDest }

  while currentDest.next do
    allDestinations[#allDestinations + 1] = currentDest.next
    currentDest = currentDest.next
    currentDest.next = nil
  end

  display(allDestinations)
end

function AuleSailing.trading.isAValidStop(fromDest, currentTrade)
  if fromDest.payWhat ~= currentTrade.get.what then
    return false
  end

  local currentDest = fromDest

  while currentDest ~= nil do
    if currentDest.payWhat == currentTrade.pay.what then
      return false
    end

    currentDest = currentDest.next

    if currentDest then
      AuleSailing.trading.checkBreaker("Looking at next location" .. currentDest.where)
    end
  end

  return true
end

function AuleSailing.trading.processNextStops(dest)
  -- Get all destinations that sell what we're looking for
  local newStops = {}

  for _, currentDest in ipairs(AuleSailing.ports) do
    AuleSailing.trading.checkBreaker("Checking port " .. currentDest.name)
    for _, trade in ipairs(currentDest.trades) do
      AuleSailing.trading.checkBreaker(("Checking trade get: %s pay: %s"):format(trade.get.what, trade.pay.what))
      if AuleSailing.trading.isAValidStop(dest, trade) then
        local nextStop = AuleSailing.trading.createStop(currentDest.name, trade.pay.what, trade.pay.amount,
          trade.get.what, trade.get.amount, dest)
        newStops[#newStops + 1] = nextStop

        debugc("Adding " .. nextStop.where .. "as next stop")
      end
    end
  end

  if #newStops == 0 then
    AuleSailing.trading.startingPoints[#AuleSailing.trading.startingPoints + 1] = dest
  else
    for _, nextDest in ipairs(newStops) do
      AuleSailing.trading.processNextStops(nextDest)
    end
  end
end

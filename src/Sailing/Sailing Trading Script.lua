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

  display(AuleSailing.trading.startingPoints)

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
    getAmount = getAmount or payAmount,
    next = nextDestination,
    totalToGet = payAmount
  }
end

function AuleSailing.trading.getRouteSummary(start)
  function copyStop(stop)
    return {
      where = stop.where,
      payWhat = stop.payWhat,
      payAmount = stop.payAmount,
      getWhat = stop.getWhat,
      getAmount = stop.getAmount,
      totalToGet = stop.payAmount
    }
  end

  -- First, go to the end, because we'll need to do maths from there
  local currentDest = start
  local allDestinations = { copyStop(start) }

  while currentDest.next do
    allDestinations[#allDestinations + 1] = copyStop(currentDest.next)
    currentDest = currentDest.next
  end

  for i = #allDestinations - 1, 1, -1 do
    local prevStop = allDestinations[i + 1]
    local currStop = allDestinations[i]

    local howManyPrevPurchases = math.ceil(prevStop.totalToGet / prevStop.getAmount)
    local totalCommsNeeded = prevStop.payAmount * howManyPrevPurchases
    local howManyCurrPurchases = math.ceil(totalCommsNeeded / currStop.getAmount)
    currStop.totalToGet = howManyCurrPurchases * currStop.getAmount
  end

  local routeSummary = {
    destinations = allDestinations,
    totalSteps = #allDestinations
  }

  return routeSummary
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

AuleSailing.trading = AuleSailing.trading or {}
AuleSailing.trading.circuitBreakerCount = 0
AuleSailing.trading.circuitBreakerLimit = 100000
AuleSailing.trading.startingPoints = {}


-- This is the primary method to call when wanting to find available trade routes
function AuleSailing.trading.findTradeRoutes(where, what, amount)
  AuleSailing.trading.startingPoints = {}
  local finalDest = AuleSailing.trading.createStop(where, what, amount)

  AuleSailing.trading.processNextStops(finalDest)
  display(AuleSailing.trading.startingPoints)
end

function AuleSailing.trading.createStop(where, what, amount, nextDestination)
  return {
    where = where,
    what = what,
    amount = amount,
    next = nextDestination
  }
end

function AuleSailing.trading.isAlreadyBuying(dest, what)
  local currentDest = dest

  while currentDest ~= nil do
    if currentDest.what == what then
      debugc("We're already buying " .. what)
      return true
    end
    currentDest = dest.next
  end
  return false
end

function AuleSailing.trading.processNextStops(dest)
  local nextDestinations = {}

  function checkIfViableNextStep(currentDest, currentTrade)
    if currentDest.what ~= currentTrade.get.what then
      return false
    end

    if AuleSailing.trading.isAlreadyBuying(currentDest, currentTrade.pay.what) then
      return false
    end

    return true
  end

  for _, portInfo in ipairs(AuleSailing.ports) do
    for _, trade in ipairs(portInfo.trades) do
      if checkIfViableNextStep(dest, trade) then
        local rAmount = math.ceil(trade.get.amount / dest.amount)
        nextDestinations[#nextDestinations + 1] = AuleSailing.trading.createStop(portInfo.name, trade.pay.what,
          trade.pay.amount * rAmount)
      end
    end
  end

  if #nextDestinations == 0 then
    AuleSailing.trading.startingPoints[#AuleSailing.trading.startingPoints + 1] = dest
  else
    for _, nextDest in ipairs(nextDestinations) do
      AuleSailing.trading.processNextStops(nextDest)
    end
  end
end

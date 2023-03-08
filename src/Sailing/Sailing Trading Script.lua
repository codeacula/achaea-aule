AuleSailing = AuleSailing or {}
AuleSailing.trading = AuleSailing.trading or {}
AuleSailing.trading.startingPoints = {}


-- This is the primary method to call when wanting to find available trade routes
function AuleSailing.trading.findTradeRoutes(where, what, amount)
  AuleSailing.trading.startingPoints = {}
  AuleSailing.trading.circuitBreakerCount = 0
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

function AuleSailing.trading.isAValidStop(fromDest, currentTrade)
  if fromDest.what ~= currentTrade.get.what then
    return false
  end

  local currentDest = fromDest
  local breaker = 0

  while currentDest ~= nil do
    if currentDest.what == currentTrade.get.what then
      return false
    end

    currentDest = fromDest.next
    debugc("Next dest is " .. currentDest.what)

    breaker = breaker + 1
    debugc("Step " .. breaker)
    if breaker > 10 then return false end
  end

  return true
end

function AuleSailing.trading.processNextStops(dest)
  -- Get all destinations that sell what we're looking for
  local newStops = {}

  for _, currentDest in ipairs(AuleSailing.ports) do
    for _, trade in ipairs(currentDest.trades) do
      if AuleSailing.trading.isAValidStop(dest, trade) then
        local nextStop = AuleSailing.trading.createStop(currentDest.name, trade.pay.what, trade.pay.amount, dest)
        newStops[#newStops + 1] = nextStop
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

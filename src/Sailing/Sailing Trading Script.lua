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

function AuleSailing.trading.notAlreadyBuying(dest, what)
  local currentDest = dest

  while currentDest ~= nil do
    if currentDest.what == what then
      return false
    end
    currentDest = dest.next
  end
  return true
end

function AuleSailing.trading.processNextStops(dest)
  local nextDestinations = {}

  for _, portInfo in ipairs(AuleSailing.ports) do
    for _, trade in pairs(portInfo.trades) do
      if AuleSailing.trading.notAlreadyBuying(dest, trade.pay) and trade.get == dest.what then
        nextDestinations[#nextDestinations + 1] = AuleSailing.trading.createStop(portInfo.name, trade.pay.what,
          trade.pay.amount * dest.amount)
      end
    end
  end

  if #nextDestinations == 0 then
    AuleSailing.trading.startingPoints[#AuleSailing.trading.startingPoints + 1] = dest
  end
end

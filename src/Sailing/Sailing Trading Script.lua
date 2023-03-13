AuleSailing = AuleSailing or {}
AuleSailing.trading = AuleSailing.trading or {}
AuleSailing.trading.circuitBreakerCount = 0
AuleSailing.trading.circuitBreakerLimit = 10000
AuleSailing.trading.currentTradeOptions = {}
AuleSailing.trading.selectableTrades = {}
AuleSailing.trading.selectedTrade = nil
AuleSailing.trading.startingPoints = {}


-- This is the primary method to call when wanting to find available trade routes
function AuleSailing.trading.findTradeRoutes(where, what, amount)
  AuleSailing.trading.currentTradeOptions = {}
  AuleSailing.trading.startingPoints = {}
  AuleSailing.trading.selectableTrades = {}
  AuleSailing.trading.circuitBreakerCount = 0
  local finalDest = AuleSailing.trading.createStop(where, what, amount)
  local allRoutes = {}

  AuleSailing.trading.processNextStops(finalDest)

  for _, start in ipairs(AuleSailing.trading.startingPoints) do
    allRoutes[#allRoutes + 1] = AuleSailing.trading.getRouteSummary(start)
  end

  if #allRoutes == 0 then
    AuleSailing.say(("No routes found to deliver %s %s to %s.\n"):format(amount, what, where))
    return
  end

  local currentCheapest = nil
  local currentShortest = nil
  local ignoreRoutes = {}

  for _, report in ipairs(allRoutes) do
    if report.ignore then
      ignoreRoutes[#ignoreRoutes + 1] = report
    else
      AuleSailing.trading.currentTradeOptions[#AuleSailing.trading.currentTradeOptions + 1] = report
    end
  end

  if #AuleSailing.trading.currentTradeOptions == 0 then AuleSailing.trading.currentTradeOptions = ignoreRoutes end

  for _, report in ipairs(AuleSailing.trading.currentTradeOptions) do
    if not currentCheapest or currentCheapest.totalCost > report.totalCost then
      currentCheapest = report
    end

    if not currentShortest or currentShortest.totalSteps > report.totalSteps then
      currentShortest = report
    end
  end

  AuleSailing.say(("Total routes available: <green>%s<reset>, Shortest route: %s, Lowest Cost: %s. To select a trade, send <green>T#<reset>\n\n")
    :format(
      #AuleSailing.trading.currentTradeOptions, currentShortest.totalSteps, currentCheapest.totalCost))

  cecho("<DeepSkyBlue>Shortest<reset>: \n")
  AuleSailing.trading.printRoute(currentShortest, 1)
  AuleSailing.trading.selectableTrades[#AuleSailing.trading.selectableTrades + 1] = currentShortest

  cecho("<DeepSkyBlue>Cheapest<reset>: \n")
  AuleSailing.trading.printRoute(currentCheapest, 2)
  AuleSailing.trading.selectableTrades[#AuleSailing.trading.selectableTrades + 1] = currentCheapest
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
    getWhat = getWhat or payWhat,
    getAmount = getAmount or payAmount,
    next = nextDestination,
    totalToGet = payAmount
  }
end

function AuleSailing.trading.getPort(name)
  for _, port in ipairs(AuleSailing.ports) do
    if port.name == name then return port end
  end

  return nil
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
  local portFees = 0
  local ignore = false

  local port = AuleSailing.trading.getPort(currentDest.where)

  if port then
    if port.ignore then ignore = true end
    portFees = portFees + port.fee
  end

  while currentDest.next do
    allDestinations[#allDestinations + 1] = copyStop(currentDest.next)
    local currPort = AuleSailing.trading.getPort(currentDest.next.where)
    if currPort then portFees = portFees + currPort.fee end
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
    totalCost = portFees + (allDestinations[1].payAmount * allDestinations[1].totalToGet),
    totalSteps = #allDestinations,
    ignore = ignore
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

function AuleSailing.trading.printRoute(routeReport, index)
  local reportString = ""

  reportString = reportString ..
      ("[%s] Route summary - Steps: %s Cost: %s\n"):format(index, routeReport.totalSteps, routeReport.totalCost)

  local eachStep = {}

  for _, step in ipairs(routeReport.destinations) do
    eachStep[#eachStep + 1] = ("<GreenYellow>%s<reset>: <gold>%s <blaze_orange>%s<reset>"):format(step.where,
      step.totalToGet, step.getWhat)
  end

  reportString = reportString .. table.concat(eachStep, " -> ") .. "\n\n"
  cecho(reportString)
end

function AuleSailing.trading.selectTrade(index)
  if #AuleSailing.trading.selectableTrades == 0 then
    AuleSailing.say("No trades are currently selectable")
    return
  end

  if not AuleSailing.trading.selectableTrades[index] then
    AuleSailing.say("There's no trade in position " .. index)
    return
  end

  AuleSailing.trading.selectedTrade = AuleSailing.trading.selectableTrades[index]

  cecho("[" .. index .. "] <DeepSkyBlue>Selected Trade<reset>: \n")
  AuleSailing.trading.printRoute(AuleSailing.trading.selectedTrade)
end

function AuleSailing.trading.showTrades()
  if #AuleSailing.trading.currentTradeOptions == 0 then
    AuleSailing.say(
      "No trade routes have been processed yet. Do HARBOUR INFO at a harbor or send <green>route [harbour] [amount] [what]<reset>")
    return
  end

  for i, report in ipairs(AuleSailing.trading.currentTradeOptions) do
    AuleSailing.trading.selectableTrades[i] = report
    AuleSailing.trading.printRoute(report, i)
  end
end

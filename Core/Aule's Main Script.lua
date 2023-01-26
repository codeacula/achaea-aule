aule = aule or {}

aule.cache = aule.cache or {
  lastRoomId = 0,
  playersHere = {}
} -- For values that aren't important to save from session to session
aule.db = aule.db or {}
aule.dbHandle = aule.dbHandle or {}
aule.showDebug = false
aule.registeredAliases = aule.registeredAliases or {}
aule.registeredEvents = aule.registeredEvents or {}
aule.registeredEventHandlers = aule.registeredEventHandlers or {}

function aule.load()
  -- Set up database stuff here
  aule.dbHandle = db:create("aule", aule.db)
  raiseEvent("aule.loaded")
end

function aule.log(text)
  debugc(text)

  if aule.showDebug then
    aule.say("<DimGrey>" .. text)
  end
end

function aule.registerAlias(system, alias, description)
  aule.registeredAliases[#aule.registeredAliases + 1] = {
    system = system,
    alias = alias,
    description = description
  }
end

function aule.registerEvent(system, event, description)
  aule.registeredEvents[#aule.registeredEvents + 1] = {
    system = system,
    event = event,
    description = description
  }
end

function aule.registerEventHandler(system, event, method, description)
  aule.registeredEventHandlers[#aule.registeredEventHandlers + 1] = {
    system = system,
    event = event,
    method = method,
    description = description
  }
end

function aule.say(what)
  cecho(("<white>[<SlateGray>Aulë<white>]:<reset> %s\n"):format(what))
end

function aule.warn(what)
  aule.say("<yellow>" .. what)
end

aule.registerAlias("Core", "aule", "This menu. How'd you figure it out??")

aule.registerEvent("Core", "aule.loaded", "The Aule system has fully loaded.")

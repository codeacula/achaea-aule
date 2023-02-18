-- Checks to see if we've already created a window using this name
function aule.ui.checkName(name)
  return true
end

-- Register a container under a name, so we can help prevent its reuse
function aule.ui.registerItem(name, item)
  aule.ui.containers[name] = item
  item:show()

  return item
end

-- The following functions create various parts of Geyser and register them with Aule UI. They may not be needed
-- anymore, but idgaf - When I wrote this Mudlet was a bitch to work with when it came to active GUI development
-- and I'm not about to waste my time figuring out something else when this just works.

function aule.ui.console(params, parent)
  if not aule.ui.checkName(params.name) then return end

  return aule.ui.registerItem(params.name, Geyser.MiniConsole:new(params, parent))
end

function aule.ui.container(params, parent)
  if not aule.ui.checkName(params.name) then return end

  return aule.ui.registerItem(params.name, Geyser.Container:new(params, parent))
end

function aule.ui.gauge(params, parent)
  if not aule.ui.checkName(params.name) then return end

  return aule.ui.registerItem(params.name, Geyser.Gauge:new(params, parent))
end

function aule.ui.hbox(params, parent)
  if not aule.ui.checkName(params.name) then return end

  return aule.ui.registerItem(params.name, Geyser.HBox:new(params, parent))
end

function aule.ui.label(params, parent)
  if not aule.ui.checkName(params.name) then return end

  return aule.ui.registerItem(params.name, Geyser.Label:new(params, parent))
end

function aule.ui.mapper(params, parent)
  if not aule.ui.checkName(params.name) then return end

  return aule.ui.registerItem(params.name, Geyser.Mapper:new(params, parent))
end

function aule.ui.vbox(params, parent)
  if not aule.ui.checkName(params.name) then return end

  return aule.ui.registerItem(params.name, Geyser.VBox:new(params, parent))
end

function aule.ui.buildTopContainer()
  local topContainer = aule.ui.container({
    name = "topContainer",
    x = px(aule.ui.layout.left.width), y = px(0),
    width = px(aule.ui.window.width - aule.ui.layout.left.width - aule.ui.layout.right.width),
    height = px(aule.ui.layout.top.height)
  })

  local topLabel = aule.ui.label({
    name = "topLabel",
    x = px(0), y = px(0),
    width = "100%", height = "100%"
  }, topContainer);

  if not topLabel then
    aule.warn("Unable to make the topLabel")
    return
  end

  topLabel:setStyleSheet([[
    border-bottom: 1px solid white;
  ]])
  topLabel:show()
end

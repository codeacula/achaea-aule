function aule.ui.buildBottomContainer()
  local bottomContainer = aule.ui.container({
    name = "bottomContainer",
    x = px(aule.ui.layout.left.width), y = px(aule.ui.window.height - aule.ui.layout.bottom.height),
    width = px(aule.ui.window.width - aule.ui.layout.left.width - aule.ui.layout.right.width),
    height = px(aule.ui.layout.bottom.height)
  })

  local bottomLabel = aule.ui.label({
    name = "bottomLabel",
    x = px(0), y = px(0),
    width = "100%", height = "100%"
  }, bottomContainer);

  if not bottomLabel then
    aule.warn("Unable to make the bottomLabel")
    return
  end

  bottomLabel:setStyleSheet([[
    border-top: 1px solid white;
  ]])
  bottomLabel:show()
end

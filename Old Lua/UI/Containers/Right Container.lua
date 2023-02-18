function aule.ui.buildRightContainer()
  local container = aule.ui.container({
    name = "rightContainer",
    x = px(aule.ui.window.width - aule.ui.layout.right.width), y = "0px",
    width = px(aule.ui.layout.right.width), height = "100%"
  })
end

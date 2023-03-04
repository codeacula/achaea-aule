function aule.ui.buildLeftContainer()
  local container = aule.ui.container({
    name = "leftContainer",
    x = px(aule.ui.window.width - aule.ui.layout.left.width), y = "0px",
    width = px(aule.ui.layout.left.width), height = "100%"
  })
end

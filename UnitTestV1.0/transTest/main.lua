
local bg=Quad2D:create("10.jpg",960,640)
bg:setAnchor(0,0)

local dark=Quad2D:create(Color(0,0,0,125),960,640)
dark:setAnchor(0,0)


local mark=Quad2D:create("transBack.png",140,140)
mark:setPosition(480-216,320-105)
mark:setOpacity(0.5)
--mark:setRegionCircle(0.5,0.5,0.5,40)
mark:setBlend(E_BlendEquation.ADD,E_BlendFactor.DST_COLOR,E_BlendFactor.SRC_ALPHA)


local scene=Scene:create()
local layer=Layer2D:create()
layer:setViewArea(0,0,960,640)
layer:setSortMode(Layer2D.SORT_ORDER_Z)

layer:add(bg)
layer:add(dark)
layer:add(mark)


scene:push(layer)

share:director():run(scene)

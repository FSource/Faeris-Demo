
local l=Layer2D:create()
l:setViewArea(0,0,960,640)

local s=Scene:create()
s:push(l)



l:setTouchEnabled(true)
l:setDispatchTouchEnabled(true)

share:director():run(s)



w=ScrollView:create(900,600)

l:add(w)

--w:setEdgeBounceEnabled(false)
w:setScrollMode(ScrollWidget.SCROLL_ALL)
w:setContentAlign(ScrollWidget.ALIGN_CENTER,ScrollWidget.ALIGN_CENTER);
--w:setMargin(20,20,20,20)

w:setPosition(480,320)

cq=Quad2D:create(Color(255,0,0,100),900,600)
w:addChild(cq)

w_ui=UiWidget:create(900,1200)
--w_ui:setRotateZ(30)
--w_ui:setScale(0.2,0.2,1)

cq=Quad2D:create("floor-dungeon-entrance.png",900,1200);


--[[
cq=ColorQuad2D:create(300,1200,Color.WHITE)
cq:setVertexColor(Color4f(1.0,0.0,0.0,1.0),ColorQuad2D.VERTEX_A);
cq:setVertexColor(Color4f(0.0,1.0,0.0,1.0),ColorQuad2D.VERTEX_B);
cq:setVertexColor(Color4f(0.0,0.0,1.0,1.0),ColorQuad2D.VERTEX_C);
cq:setVertexColor(Color4f(1.0,0.0,1.0,1.0),ColorQuad2D.VERTEX_D);
--]]
cq:setOpacity(0.9)
w_ui:addChild(cq)

w:setContentWidget(w_ui)






























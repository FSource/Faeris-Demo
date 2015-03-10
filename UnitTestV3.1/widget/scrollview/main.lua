
local l=Layer2D:create()
l:setViewArea(0,0,960,640)

local s=Scene:create()
s:push(l)



l:setTouchEnabled(true)
l:setDispatchTouchEnabled(true)

share:director():run(s)



w=ScrollView:create(900,600)

l:add(w)

w:setContentAlign(E_AlignH.CENTER,E_AlignV.CENTER);


w:setPosition(480,320)

w_ui=UiWidget:create(600,600)

w_ui:setBgTexture("floor-dungeon-entrance.png")
w_ui:setBgEnabled(true)

w:setContentWidget(w_ui)


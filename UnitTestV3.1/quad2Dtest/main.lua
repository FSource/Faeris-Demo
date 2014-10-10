scene=Scene:create()

layer=Layer2D:create()

scene:push(layer)

local texture=share:textureMgr():load("testorig.jpg")
local tex_width=texture:getWidth()
local tex_height=texture:getHeight()


q1=Quad2D:create("testorig.jpg")
q1:setPosition(150,100);
q1:setColor(Color(0,100,100));

q2=Quad2D:create("testorig.jpg")
q2:setRegionRect(0.3,0.3,0.4,0.4);
q1:addChild(q2)
--q2:setRenderMode(Quad2D.MODE_COLOR)

layer:add(q1)


q3=Quad2D:create("testorig.jpg")
q3:setPosition(400,100);
q3:setColor(Color(0,100,100));

q4=Quad2D:create("testorig.jpg")
q4:setRegionCircle(0.5,0.5,0.5,40)
q3:addChild(q4)
layer:add(q3)

q5=Quad2D:create("testorig.jpg")
q5:setPosition(650,100);
q5:setColor(Color(0,100,100));

q6=Quad2D:create("testorig.jpg")

q6:setRegionEllipse(0.5,0.5,0.5*tex_height/tex_width,0.5, 20,280,400)

q5:addChild(q6)
layer:add(q5)


sq=Quad2D:create("scale9.png")
sq:setSize(300,190)
sq:setRegionScale9(0.15)

sq:setPosition(200,350)
layer:add(sq)


sq2=Quad2D:create("scale9.png")
sq2:setSize(300,190)

sq2:setPosition(800,350)
layer:add(sq2)

sq3=Quad2D:create("scale9.png")
--sq3:setSize(300,190)

sq3:setPosition(500,350)
layer:add(sq3)



sq4=Quad2D:create("s9_bg.png")
sq4:setSize(200,24)
sq4:setRegionScale9(0.4)
sq4:setPosition(200,500)
sq4:setAnchor(0,0.5)
layer:add(sq4)
sq5=Quad2D:create("s9_r.png")
sq5:setSize(200,24)
sq5:setRegionScale9(0.4)
sq5:setAnchor(0,0.5)
sq4:addChild(sq5)
f_setattrenv(sq5,{})

local t=0

sq5.onUpdate=function(_,dt)
	t=t+dt
	sq5:setSize(200*math.abs(math.sin(t)),24)
	--sq5:setSize(10,24)
	sq5:setRegionScale9(0.4)
end










layer:setViewArea(0,0,960,640)
share:director():run(scene)






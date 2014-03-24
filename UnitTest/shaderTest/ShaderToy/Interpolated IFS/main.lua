scene=Scene:create()

layer=Layer2D:create()

scene:push(layer)

q1=ColorQuad2D:create(960,640,Color4f.RED)

q1:setPosition(480,320);


local shader=share:programMgr():load("shader.vert","shader.frag")

print(shader)
q1:setShader(shader)

q1.data={}

local time=0
local mouse={x=480,y=320}

q1.onUpdate=function(q,dt)
	time=time+dt
end


q1.onDraw=function(q,render)

	render:setProgram(shader)
	local u_time=render:getUniformLocation("iGlobalTime")
	local u_resolution=render:getUniformLocation("iResolution")
	local u_mouse=render:getUniformLocation("iMouse")

	render:setUniform(u_time,Render.U_F_1,1,Vector2(time,0))
	render:setUniform(u_resolution,Render.U_F_2,1,Vector2(960,640))
	render:setUniform(u_mouse,Render.U_F_3,1,Vector3(mouse.x,mouse.y,0))

	q1:draw(render)


end



layer:add(q1)
layer.data={}
layer:setTouchEnabled(true)
layer.onTouchBegin=function(_,x,y)

	local x,y=layer:toLayerCoord(x,y)
	mouse={x=x,y=y}
	return true
end

layer.onTouchMove=function(_,x,y)
	local x,y=layer:toLayerCoord(x,y)
	mouse={x=x,y=y}
end


layer:setViewArea(0,0,960,640)
share:director():run(scene)



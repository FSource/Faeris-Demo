scene=Scene:create()

layer=Layer2D:create()

scene:push(layer)

q1=Quad2D:create("pal.png",960,640)

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

scale=1

q1.onDraw=function(q,render)

	render:setProgram(shader)
	local u_scale=render:getUniformLocation("scale")
	local u_resolution=render:getUniformLocation("resolution")
	local u_mouse=render:getUniformLocation("mouse")

	render:setUniform(u_resolution,Render.U_F_2,1,Vector2(960,640))
	render:setUniform(u_scale,Render.U_F_1,1,Vector2(scale,1))

	q1:draw(render)


end



layer:add(q1)
layer.data={}
layer:setTouchEnabled(true)
layer.onTouchBegin=function(_,x,y)

	local x,y=layer:toLayerCoord(x,y)
	last_pos={x=x,y=y}
	return true
end

layer.onTouchMove=function(_,x,y)
	local x,y=layer:toLayerCoord(x,y)
	local diffy=y-last_pos.y
	scale =scale + diffy/640

	if scale < 0 then 
		scale =0 
	end

	last_pos={x=x,y=y}
end


layer:setViewArea(0,0,960,640)
share:director():run(scene)



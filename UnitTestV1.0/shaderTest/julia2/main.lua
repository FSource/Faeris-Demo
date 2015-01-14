scene=Scene:create()

layer=Layer2D:create()

scene:push(layer)

q1=Quad2D:create("pal.png",960,640)

q1:setPosition(480,320);
q1:setProgramSource("julia.fshader")



q1.data={}

local time=0
local mouse={x=480,y=320}

q1.onUpdate=function(q,dt)
	time=time+dt
end

scale=1
seed={x=0.358,y=0.428}

q1.onDraw1=function(q,render)

	local u_scale=render:getUniformLocation("scale")
	local u_resolution=render:getUniformLocation("resolution")
	local u_seed=render:getUniformLocation("c")


	render:setUniform(u_resolution,Render.U_F_2,1,Vector2(960,640))
	render:setUniform(u_seed,Render.U_F_2,1,Vector2(seed.x,seed.y))

	q1:draw(render)


end



layer:add(q1)
layer.data={}
layer:setTouchEnabled(true)
layer.onTouchBegin=function(_,x,y)

	--[[
	seed.x=math.random()
	seed.y=math.random()
	--]]

	local x,y=layer:toLayerCoord(x,y)
	last_pos={x=x,y=y}
	return true

end

layer.onTouchMove=function(_,x,y)
	local x,y=layer:toLayerCoord(x,y)
	local diffx=(x-last_pos.x)/960
	local diffy=(y-last_pos.y)/640

	seed.x=seed.x+diffx
	seed.y=seed.y+diffy

	last_pos={x=x,y=y}
	print(seed.x,seed.y)
end



layer:setViewArea(0,0,960,640)
share:director():run(scene)








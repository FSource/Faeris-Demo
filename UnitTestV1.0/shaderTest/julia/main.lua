scene=Scene:create()

layer=Layer2D:create()

scene:push(layer)

q1=Quad2D:create("pal.png",900,600)

q1:setPosition(480,320);
q1:setProgramSource("julia.fshader")


local time=0

local mouse={x=480,y=320}

q1.onUpdate=function(q,dt)
	time=time+dt
end




layer:add(q1)
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



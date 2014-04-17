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

q1.onUpdate=function(q,dt)
	time=time+dt
end

q1.onDraw=function(q,render)

	render:setProgram(shader)
	local u_time=render:getUniformLocation("u_time")
	local u_resolution=render:getUniformLocation("u_resolution")
	render:setUniform(u_time,Render.U_F_1,1,Vector2(time,0))
	render:setUniform(u_resolution,Render.U_F_2,1,Vector2(960,640))
	q1:draw(render)


end








layer:add(q1)
layer:setViewArea(0,0,960,640)
share:director():run(scene)



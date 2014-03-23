local quad=ColorQuad2D:create(100,100,Color4f.RED)
--[[
quad.data=
{
	onUpdate=function(self,dt) 
	end

}
--]]

quad:setPosition(480,320);

--quad:setVertexColor(Color4f.RED)


local scene=Scene:create()
local layer=Layer2D:create()
layer:setViewArea(0,0,960,640)

scene:push(layer)
layer:add(quad)

share:director():run(scene)

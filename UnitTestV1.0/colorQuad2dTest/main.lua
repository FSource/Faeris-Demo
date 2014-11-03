local quad=Quad2D:create(Color4f.RED,100,100)
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

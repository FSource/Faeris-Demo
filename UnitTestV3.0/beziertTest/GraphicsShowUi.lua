GraphicsShowUi=f_newclass("GraphicsShowUi")

function GraphicsShowUi:New()

	local ret=Layer2D:create()
	f_extends(ret,self)
	ret:Init()

	return ret
end

function GraphicsShowUi:Init()

	self:setViewArea(-2,-2,4,4)
	self:InitCoord()

	self:InitBezier()

end


function GraphicsShowUi:InitCoord()
	local coord_x=VertexPolygon:create()
	coord_x:append(-1,0)
	coord_x:append(1,0)
	coord_x:setMode(VertexPolygon.LINES)
	coord_x:setColor(Color.BLUE)

	self:add(coord_x)



	local coord_y=VertexPolygon:create()
	coord_y:append(0,-1)
	coord_y:append(0,1)
	coord_y:setMode(VertexPolygon.LINES)
	coord_y:setColor(Color.RED)
	self:add(coord_y)


end

function GraphicsShowUi:InitBezier()

	local b=Bezier:New()
	b:GeneratePoints(0,1,0.25,1)
	self:add(b)

end









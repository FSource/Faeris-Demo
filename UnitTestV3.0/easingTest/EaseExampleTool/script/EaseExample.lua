EaseExample=libfs.Class("EaseExample")

function EaseExample:New()
	local ret=Scene:create()
	libfs.Extends(ret,self)
	ret:Init()
	return ret
end


function EaseExample:Init()
	local layer=Layer2D:create()
	layer:setViewArea(0,0,W_WIDTH,W_HEIGHT)

	layer:add(CurvePanel:New{
		pos={x=0,y=500},
		height=255,
	})

	self:push(layer)

end



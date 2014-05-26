CurvePanel=libfs.Class("CurvePanel")

function CurvePanel:New(cfg)
	local ret=Panel:create()

	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret

end

function CurvePanel:Init(cfg)

	self:setScissorEnabled(false)

	if cfg.pos then 
		self:setPosition(cfg.pos.x,cfg.pos.y)
	end

	self:setSize(W_WIDTH,255)
	self:setAnchor(0,0)
	self:InitAxis()
	self:InitLine(cfg)
end



function CurvePanel:InitAxis()
	local step=W_WIDTH/4
	local start_x=100

	local y=30

	for i=1,4 do 
		local axis=AxisCoord:New{
			width=180,
			height=180,
			center=0.1,
			sampleNu=1000,
		}
		if i==1 then 
			axis:SetCurve(BounceEase:create())
		elseif i==2 then 
			axis:SetCurve(ElasticEase:create())
		elseif i==3 then 
			axis:SetCurve(CircleEase:create())
		elseif i==4 then 
			axis:SetCurve(BackEase:create())
		end
		axis:setPosition(start_x+(i-1)*step,y)
		self:addChild(axis)
	end

end


function CurvePanel:InitLine(cfg)
	local outline=VertexPolygon:create()
	outline:append(0,0)
	outline:append(W_WIDTH,0)

	outline:append(0,cfg.height)
	outline:append(W_WIDTH,cfg.height)
	outline:setColor(Color.BLACK)
	outline:setMode(VertexPolygon.LINES)

	self:addChild(outline)


end









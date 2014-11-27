CurveHListPanel=libfs.Class("CurveHListPanel")

function CurveHListPanel:New(cfg)

	local ret=Panel:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret

end

function CurveHListPanel:Init(cfg)

	self:setScissorEnabled(false)
	self:setTouchEnabled(true)
	self:setDispatchTouchEnabled(true)

	if cfg.pos then 
		self:setPosition(cfg.pos.x,cfg.pos.y)
	end

	self:setSize(W_WIDTH,255)
	self:setAnchor(0,0)
	self:InitAxis()
	self:InitLine(cfg)
end



function CurveHListPanel:InitAxis()
	local step=W_WIDTH/4
	local start_x=100

	local y=60
	self.m_widget={}

	for i=1,4 do 
		local widget=CurveWidget:New()
		widget:setPosition(start_x+(i-1)*step,y)
		self:addChild(widget)
		self.m_widget[i]=widget
	end

end


function CurveHListPanel:InitLine(cfg)

	local outline=VertexPolygon:create()
	outline:append(0,0)
	outline:append(W_WIDTH,0)

	outline:append(0,cfg.height)
	outline:append(W_WIDTH,cfg.height)
	outline:setColor(Color.BLACK)
	outline:setMode(E_DrawMode.LINES)

	self:addChild(outline)

end

function CurveHListPanel:GetCurve(index)
	return self.m_widget[index]:GetCurve()
end









AxisCoord=libfs.Class("AxisCoord")

function AxisCoord:New(cfg) 
	local ret=Entity:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret
end

function AxisCoord:Init(cfg)

	self.m_width=cfg.width 
	self.m_height=cfg.height
	self.m_center=cfg.center or 0.2

	self.m_sampleNu=cfg.sampleNu or 300

	self:InitAxis()

end

function AxisCoord:InitAxis()
	local axis=VertexPolygon:create()

	axis:append(self.m_width*(-self.m_center),0)
	axis:append(self.m_width*(1-self.m_center),0)

	axis:append(0,self.m_height*(-self.m_center))
	axis:append(0,self.m_height*(1-self.m_center))

	axis:setColor(Color.RED)
	axis:setMode(VertexPolygon.LINES)

	self:addChild(axis)

	local curve=VertexPolygon:create()
	curve:setMode(VertexPolygon.LINE_STRIP)
	curve:setColor(Color.BLUE)
	self:addChild(curve)
	self.m_curve=curve

end


function AxisCoord:SetCurve(curve,ease_mode)
	self.m_curve:resize(0)

	for i=0,self.m_sampleNu  do 
		local x=i/self.m_sampleNu
		local y=curve:getValue(x)
		self.m_curve:append(x*(1-self.m_center)*self.m_width,y*(1-self.m_center)*self.m_height)
	end
end






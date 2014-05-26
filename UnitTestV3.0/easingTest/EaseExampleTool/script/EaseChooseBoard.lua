EaseChooseBoard=libfs.Class("EaseChooseBoard")

S_NormalColor=Color(0,114,118)
S_PressColor=Color(205,73,0)

function EaseChooseBoard:New(cfg)
	local ret=ColorQuad2D:create(200,200,Color(151,151,151,200))
	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret
end


function EaseChooseBoard:Init(cfg)

	local label=libfs.NewFType{
		ftype="fLabelTTF",
		fontName=g_DefaultFontName,
		fontSize=25,
		string=cfg.name,
	}
	self:addChild(label)

	local axis=AxisCoord:New{
		width=180,
		height=180,
		center=0.1,
		sampleNu=100,
	}
	axis:setPosition(-80,-80)

	self:addChild(axis)
	local curve=cfg.new()
	axis:SetCurve(curve,FS_EASE_IN)

	self.m_axis=axis

	self:setState("normal")

end

function EaseChooseBoard:setState(s)
	if s=="normal" then 
		self:setColor(S_NormalColor)

		self.m_axis:SetAxisXColor(Color.WHITE)
		self.m_axis:SetAxisYColor(Color.WHITE)
		self.m_axis:SetAxisCurveColor(Color.WHITE)

	else 
		self:setColor(S_PressColor)
		self.m_axis:SetAxisXColor(Color.WHITE)
		self.m_axis:SetAxisYColor(Color.WHITE)
		self.m_axis:SetAxisCurveColor(Color.WHITE)
	end
end




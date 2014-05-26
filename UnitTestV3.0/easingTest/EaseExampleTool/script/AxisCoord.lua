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
	self:InitIndentifyer()

	self:SetCurve(LinearEase:create(),FS_EASE_IN)
	self:SetPositionIdentify(0.2)
end



function AxisCoord:InitAxis()
	local axis_x=VertexPolygon:create()

	axis_x:append(self.m_width*(-self.m_center),0)
	axis_x:append(self.m_width*(1-self.m_center),0)
	axis_x:setColor(Color(102,45,145))
	axis_x:setMode(VertexPolygon.LINES)

	local axis_y=VertexPolygon:create()

	axis_y:append(0,self.m_height*(-self.m_center))
	axis_y:append(0,self.m_height*(1-self.m_center))
	axis_y:setColor(Color(0,134,65))
	axis_y:setMode(VertexPolygon.LINES)


	self:addChild(axis_x)
	self:addChild(axis_y)

	local curve=VertexPolygon:create()
	curve:setMode(VertexPolygon.LINE_STRIP)
	curve:setColor(Color(188,28,72))
	self:addChild(curve)
	self.m_curve=curve

	self.m_axisx=axis_x 
	self.m_axisy=axis_y
	self.m_axisCurve=curve
end

function AxisCoord:InitIndentifyer() 
	local identifier_label=libfs.NewFType{
		ftype="fLabelTTF",
		fontName=g_DefaultFontName,
		fontSize=10,
		string="3,5",
		pos={x=90,y=180},
		--color=Color(36,160,218),
		children={
			["quad"]={
				ftype="fQuad2D",
				textureUrl="image/button_bg.png",
				size={w=3,h=3},
				color=Color(36,160,218,200),
				pos={x=0,y=10}
			}
		}
	}

	self.m_indentifier=identifier_label
	self:addChild(self.m_indentifier)
end


function AxisCoord:SetCurve(curve,ease_mode)
	self.m_curve:resize(0)
	for i=0,self.m_sampleNu  do 
		local x=i/self.m_sampleNu
		local y=curve:getValue(x,ease_mode)
		self.m_curve:append(x*(1-self.m_center)*self.m_width,y*(1-self.m_center)*self.m_height)
	end
	self.m_easeCurve=curve
	self.m_easeMode=ease_mode

	local p=self.m_position 
	self.m_position=nil 
	self:SetPositionIdentify(p)
end

function AxisCoord:SetPositionIdentify(t)

	if self.m_position == t then 
		return 
	end

	self.m_position=t 

	local x=t*(1-self.m_center)*self.m_width
	local y=self.m_easeCurve:getValue(t,self.m_easeMode)*(1-self.m_center)*self.m_height
	self.m_indentifier:setPosition(x,y-10)
	self.m_indentifier:setString(string.format("(%.2f,%.2f)",t,self.m_easeCurve:getValue(t,self.m_easeMode)))
end

function AxisCoord:SetAxisXColor(c)
	self.m_axisx:setColor(c)
end

function AxisCoord:SetAxisYColor(c)
	self.m_axisy:setColor(c)
end

function AxisCoord:SetAxisCurveColor(c)
	self.m_axisCurve:setColor(c)
end






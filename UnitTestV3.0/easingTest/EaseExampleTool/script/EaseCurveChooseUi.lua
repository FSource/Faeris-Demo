EaseCurveChooseUi=libfs.Class("EaseCurveChooseUi")

local S_SelectColor=Color(205,73,0)
local S_UnSelectColor=Color(0,114,188)


function EaseCurveChooseUi:New()
	local ret=Layer2D:create()
	libfs.Extends(ret,self)
	ret:Init()
	return ret
end


function EaseCurveChooseUi:Init()
	self:setViewArea(0,0,W_WIDTH,W_HEIGHT)
	self:setSortMode(Layer2D.SORT_ORDER_Z)
	self:setTouchEnabled(true)
	self:setDispatchTouchEnabled(true)

	self:InitBg()
	self:InitEaseChooseBoard()
	self:InitPressButton()

end

function EaseCurveChooseUi:InitBg()
	local c=Quad2D:create(Color(51,51,51,220),W_WIDTH,W_HEIGHT)
	c:setAnchor(0,0)
	self:add(c)
end


function EaseCurveChooseUi:InitEaseChooseBoard()

	local step_x = W_WIDTH/5
	local start_x= step_x/2
	local start_y= W_HEIGHT-150
	local step_y= -220

	for k,v in ipairs(g_EaseCfg) do 

		local x=start_x+ (k-1)%5*step_x
		local y=start_y+ math.floor((k-1)/5)*step_y
		local board=EaseChooseBoard:New(v)
		board:setTouchEnabled(true)
		board.onTouchBegin=function(x,y)  
			if self.m_foucs then 
				self.m_foucs:setState("normal")
			end
			self.m_foucs=board 
			self.m_foucs:setState("press")
			self.m_foucsIndex=k
		end
		if k== 1 then 
			board:setState("press")
			self.m_foucs=board
		end

		board:setPosition(x,y) 
		self:add(board)
	end
	self.m_foucsIndex=1

end

function EaseCurveChooseUi:InitPressButton()
	local ok_button=libfs.NewFType{
		touchEnabled=true,
		ftype="fButton",
		textureUrl="image/button_bg.png",
		size={w=80,h=30},
		pos={x=W_WIDTH-100,y=30},

		children={
			["label"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=20,
				string="Ok",
			}
		},
		normal={
			color=Color(102,45,145),
		},
		press={
			color=Color(102,45,145,100),
		},
	}

	self:add(ok_button)
	ok_button.onClick=function()
		self:getScene():remove(self)
		self:onOk(self.m_foucsIndex)
	end

	local cancle_button=libfs.NewFType{
		touchEnabled=true,
		ftype="fButton",
		textureUrl="image/button_bg.png",
		size={w=80,h=30},
		pos={x=W_WIDTH-250,y=30},
		children={
			["label"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=20,
				string="Cancel",
			}
		},
		normal={
			color=Color(102,45,145),
		},
		press={
			color=Color(102,45,145,100),
		},
	}

	self:add(cancle_button)
	cancle_button.onClick=function()
		self:getScene():remove(self)
	end

end


function EaseCurveChooseUi:onTouchBegin(x,y)
	self:touchBegin(x,y) 
	return true 
end

function EaseCurveChooseUi:onOk(index)
end



CurveWidget=libfs.Class("CurveWidget")

local S_SelectColor=Color(205,73,0)
local S_UnSelectColor=Color(0,114,188)
local S_LabelColor=Color.WHITE
local S_TabEntitySize={w=80,h=20}
local S_ModeMap={
		FS_EASE_IN,
		FS_EASE_OUT,
		FS_EASE_INOUT,
		FS_EASE_OUTIN,
	}

function CurveWidget:New()
	local ret=Entity:create()
	libfs.Extends(ret,self)
	ret:Init()
	return ret
end

function CurveWidget:Init()
	self:setTouchEnabled(true)
	self:setDispatchTouchEnabled(true)
	self:InitPressButton()
	self:InitRadioButtons()
	self:InitTitle()
	self:InitAxis()
	self.m_tabBar:SetCurrentIndex(1,true)

	self:SetCurveIndex(1)

end




function CurveWidget:InitRadioButtons() 
	self.m_tabBar=libfs.NewFType{
		ftype="TabBar",
		tabWidth=100,
		tabHeight=20,
		vGap=4,
		tabDirection="vertical",
	}
	self.m_tabBar:setPosition(-90,150)
	self.m_tabBar:setTouchEnabled(true)

	self:addChild(self.m_tabBar)
	local labels={"EaseIn","EaseOut","EaseInOut","EaseOutIn"}
	self.m_modeLabels=labels

	for i=1,4 do 
		self.m_tabBar:SetTab(i,{
			ftype="StateButton",
			textureUrl="image/button_bg.png",
			size=S_TabEntitySize,
			anchor={x=0,y=1},
			normal={
				color=S_UnSelectColor
			},
			press={
				color=S_SelectColor
			},
			children={
				["label"]={
					ftype="fLabelTTF",
					fontName=g_DefaultFontName,
					fontSize=15,
					string=labels[i],
					color=S_LabelColor,
					pos={x=S_TabEntitySize.w/2,y=-S_TabEntitySize.h/2}
				}
			}
		})
	end

	self.m_tabBar.onCurrentIndexChange=function(_,index)
		if index <=0 or index > 4 then 
			return
		end
		self.m_index=index
		self:UpdateCurve()
	end

end


function CurveWidget:InitAxis()

	local axis=AxisCoord:New{
		width=180,
		height=180,
		center=0.1,
		sampleNu=1000,
	}

	self.m_curve=LinearEase:create()
	self:addChild(axis)
	self.m_axis=axis
end

function CurveWidget:InitTitle() 
	local title=libfs.NewFType{
		ftype="fLabelTTF",
		fontName=g_DefaultFontName,
		fontSize=15,
		string="LinearEase",
		pos={x=90,y=180},
		color=Color(36,160,218)
	}
	self:addChild(title)
	self.m_title=title

end

function CurveWidget:SetTitle(t)
	self.m_title:setString(t)
end

function CurveWidget:InitPressButton()

	local change_button=libfs.NewFType{
		ftype="fButton",
		touchEnabled=true,
		pos={x=30,y=-40},
		size={w=80,h=25},
		textureUrl="image/button_bg.png",
		normal={
			color=Color(102,45,145),
		},
		press={
			color=Color(102,45,145,100),
		},
		children={
			["label"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=17,
				string="Change",
			}
		}
	}
	self:addChild(change_button)
	change_button.onClick=function()
		self:onChangeClick()
	end

	local edit_button=libfs.NewFType{
		ftype="fButton",
		touchEnabled=true,
		pos={x=130,y=-40},
		size={w=80,h=25},
		textureUrl="image/button_bg.png",
		normal={
			color=Color(102,45,145),
		},
		press={
			color=Color(102,45,145,100),
		},

		children={
			["label"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=17,
				string="Edit",
			}
		}
	}
	self:addChild(edit_button)
	edit_button.onClick=function()
		self:onEditClick()
	end

	self.m_editButton=edit_button 
	self.m_changeButton=change_button

end

function CurveWidget:SetCurveEditEnabled(enable)
	if enable then 
		self.m_editButton:setPositionX(130)
		self.m_changeButton:setPositionX(30)
		self.m_editButton:setVisibles(true)
	else 
		self.m_changeButton:setPositionX(80)
		self.m_editButton:setVisibles(false)
	end

end


function CurveWidget:onHit2D(x,y) 
	return true
end

function CurveWidget:SetMode(m)
	if m== "EaseIn" then 
		self.m_tabBar:SetCurrentIndex(1) 
	elseif m == "EaseOut" then 
		self.m_tabBar:SetCurrentIndex(2) 
	elseif m == "EaseInOut" then 
		self.m_tabBar:SetCurrentIndex(3) 
	elseif m=="EaseOutIn" then 
		self.m_tabBar:SetCurrentIndex(4) 
	end

	self:UpdateCurve()
end

function CurveWidget:GetMode() 
	return self.m_modeLabels[self.m_index]
end

function CurveWidget:UpdateCurve()
	self.m_axis:SetCurve(self.m_curve,S_ModeMap[self.m_index])
end

function CurveWidget:SetCurve(curve,title,editable)
	print(curve:className(),title,editable)
	self.m_curve=curve 
	self:SetTitle(title)
	self:SetCurveEditEnabled(editable)
	self:UpdateCurve()
end
function CurveWidget:GetCurve()
	return self.m_curve,S_ModeMap[self.m_index]
end


function CurveWidget:onChangeClick()
	local choose_ui=EaseCurveChooseUi:New()
	choose_ui.onOk=function(_,index)
		self:SetCurveIndex(index)
	end

	self:getScene():push(choose_ui)
end

function CurveWidget:SetCurveIndex(index)
	local ease=g_EaseCfg[index]
	self:SetCurve(ease.new(),ease.name,ease.edit)

end

function CurveWidget:onEditClick()
	print("onEditClick")
end
function CurveWidget:onUpdate(dt)
	self:update(dt) 
	self.m_axis:SetPositionIdentify(self:getScene():GetCurTimePercent())
end





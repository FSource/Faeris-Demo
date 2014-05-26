ToggleButton=libfs.Class("ToggleButton")

--[[  Param Need: 
--    	width 
--    	height 
--	    toggleOnUrl
--	    toggleOffUrl
--	    slideUrl
--	    useSlide
--	    slideDiffX
--	    state
--	   	slideSpeed
--
--]]


local S_ToggleAttrFunc=libfs.GetAttrFuncs{
	"pos","zorder","scale", 
	"rotate", "touchEnabled","dispatchTouchEnabled",
	"visible","visibles",
}


function ToggleButton:New(cfg) 

	local ret=Entity:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret

end



function ToggleButton:Init(cfg)

	self.m_slidePercent=0
	self.m_slideSpeed=cfg.slideSpeed or 1.0 

	self.m_width=cfg.width or 10
	self.m_height=cfg.height or 10
	self.m_toggleOnUrl=cfg.toggleOnUrl  
	self.m_toggleOffUrl=cfg.toggleOffUrl 

	self.m_slideUrl=cfg.slideUrl 
	self.m_useSlide=cfg.useSlide or false 

	self.m_slideDiffX=cfg.slideDiffX or 0
	self.m_slideDiffXLeft=cfg.slideDiffXLeft or self.m_slideDiffX or 0 
	self.m_slideDiffXRight=cfg.slideDiffXRight or self.m_slideDiffX or 0

	self.m_slideDiffY=cfg.slideDiffY or 0

	self.m_slideTime=cfg.slideTime or 0.1


	local toggle_on_url=Quad2D:create(self.m_toggleOnUrl)
	toggle_on_url:setPosition(self.m_width/2,-self.m_height/2)
	self:addChild(toggle_on_url)
	self.m_toggleOnButton=toggle_on_url

	local toggle_off_url=Quad2D:create(self.m_toggleOffUrl)
	toggle_off_url:setPosition(self.m_width/2,-self.m_height/2)
	self:addChild(toggle_off_url)
	self.m_toggleOffButton=toggle_off_url

	if self.m_useSlide then 

		self.m_slide=Quad2D:create(self.m_slideUrl)
		self:addChild(self.m_slide)
		self.m_slide:setPosition(self.m_slideDiffX,-self.m_height/2)

	end

	local state = cfg.state or "off" 
	self:SetStateQuick(state)

	self:setTouchEnabled(true)
--	self:setDispatchTouchEnabled(true)

	libfs.SetAttrute(S_ToggleAttrFunc,self,cfg)

end





function ToggleButton:SetStateQuick(state)

	self.m_state=state 
	if self.m_state=="off" then 
		self:clearAction()
		self.m_slidePercent=1
	elseif self.m_state == "on" then 
		self:clearAction()
		self.m_slidePercent=0
	end
end


function ToggleButton:SetState(state)
	self.m_state=state
	if self.m_state=="off" then 

		if self.onToggle then 
			self:onToggle(self.m_state)
		end

		local action=RectilinearMotionAction:New{
			attr="m_slidePercent",
			endValue=1,
			equalLose=0.01,
			percent=self.m_slideSpeed*1/10/16*1.5
			
		}
		self:clearAction()
		self:doAction(action)

	elseif self.m_state == "on" then 

		if self.onToggle then 
			self:onToggle(self.m_state)
		end

		local action=RectilinearMotionAction:New{
			attr="m_slidePercent",
			endValue=0,
			equalLose=0.01,
			percent=self.m_slideSpeed*1/10/16*1.5
		}

		self:clearAction()
		self:doAction(action)

	end

end

function ToggleButton:onHit2D(x,y)  

	local v=self:worldToLocal(Vector3(x,y,0))

	if v.x > 0 and v.x < self.m_width then 

		if v.y < 0 and v.y > -self.m_height then 
			return true 
		end
	end

	return false 

end


function ToggleButton:onTouchBegin(x,y)

	self:Toggle()
	return true

end


function ToggleButton:onUpdate(dt)
	self:update(dt)

	self.m_toggleOnButton:setOpacity(self.m_slidePercent)
	self.m_toggleOffButton:setOpacity(1-self.m_slidePercent)

	if self.m_useSlide  then 
		local left_x=self.m_slideDiffXLeft
		local right_x=self.m_width-self.m_slideDiffXRight
		--print(self.m_slideDiffXLeft,self.m_slideDiffXRight)

		local pos_x=left_x+(right_x-left_x)*self.m_slidePercent
		local pos_y=self.m_slideDiffY-self.m_height/2

		self.m_slide:setPosition(pos_x,pos_y)
	end

end



function ToggleButton:Toggle()

	if self.m_state== "on" then 
		self:SetState("off") 
	else 
		self:SetState("on") 
	end
	self:onToggle(self.m_state)
end



function ToggleButton:GetState()

	return self.m_state
end

function ToggleButton:onToggle(value)

end







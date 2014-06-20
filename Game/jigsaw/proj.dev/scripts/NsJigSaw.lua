NsJigSaw=f_newclass()

function NsJigSaw:New()
	local ret=Scene:create()
	f_extends(ret,self)
	ret:Init()
	return ret
end


function NsJigSaw:Init()
	-- create --
	local ui_control=NsJigSaw_UiControl:New()
	local ui_bg=NsJigSaw_UiBg:New()
	local ui_grid=NsJigSaw_UiGrid:New()
	local ui_goal=NsJigSaw_UiGoal:New()

	--local ui_pause=NsJigSaw_Pause:New()
	

	-- push --
	self:push(ui_bg)
	self:push(ui_grid)
	self:push(ui_control)
	self:push(ui_goal)

	-- assign --
	self.m_uiControl=ui_control
	self.m_uiBg=ui_bg 
	self.m_uiGoal=ui_goal
	--scene.m_uiPause=ui_pause
	self.m_uiGrid=ui_grid
	return scene 
end



function NsJigSaw:Success()
	self.m_uiControl:Success()
end

function NsJigSaw:SetLevel(i)
	local l=LEVEL_DATA[i] 
	
	self.m_uiControl:LoadLevel(l,i) 
	--self.m_uiBg:LoadLevel(l)
	self.m_uiGrid:LoadLevel(l)
	self.m_uiGoal:LoadLevel(l)
	self.m_uiGoal:setVisible(false)
	self.m_currentLevel=i
end

function NsJigSaw:NextLevel()
	if self.m_currentLevel == MAX_LEVEL then 
		self:SetLevel(self.m_currentLevel) 
		return 
	end
	self:SetLevel(self.m_currentLevel+1 )
end


-- call back --
function NsJigSaw:onEnter()
end





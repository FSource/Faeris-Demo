
QuitLayer=f_newclass()

function QuitLayer:New()
	local layer=Layer2D:create()
	f_extends(layer,self)
	layer:Init()
	return layer
end

function QuitLayer:Init()

	local font=FontTTF:create("simsun.ttc",80)
	self:setViewArea(0,0,960,640)

	local msg= LabelTTF:create("Are You Sure To Quit?",font);
	local quit=LabelTTF:create("Quit",font);
	local cancel=LabelTTF:create("Cancel",font);


	msg:setPosition(480,500)
	msg:setAlign(LabelTTF.ALIGN_H_CENTER,LabelTTF.ALIGN_V_CENTER)
	msg:setColor(Color.RED)

	quit:setPosition(200,200)
	quit:setAlign(LabelTTF.ALIGN_H_CENTER,LabelTTF.ALIGN_V_CENTER)
	quit:setColor(Color.RED)

	cancel:setPosition(760,200)
	cancel:setAlign(LabelTTF.ALIGN_H_CENTER,LabelTTF.ALIGN_V_CENTER)
	cancel:setColor(Color.RED)


	self:add(msg)
	self:add(quit)
	self:add(cancel)

	self.quit=quit 
	self.cancel=cancel
	self:setTouchEnabled(true);
end

function QuitLayer:onTouchBegin(x,y) 

	local x,y=self:toLayerCoord(x,y)
	if self.quit:hit2D(x,y) then 
		share:scheduler():stop()
		font:decRef()
		font2:decRef()

	elseif self.cancel:hit2D(x,y) then 
		local scene=share:director():current()
		scene:pop()
		scene:pop()
	end
	return true
end



StartLayer=f_newclass()

-- main layer 
function StartLayer:SelectUpdate(dt) 
	self:update(dt)
end


function StartLayer:SelectTouchBegin(x,y)
	print "select touch "
	local x,y=self:toLayerCoord(x,y)
	local focus=nil
	if self.play:hit2D(x,y) then
		focus=self.play
	elseif self.quit:hit2D(x,y) then 
		focus=self.quit
	elseif self.setting:hit2D(x,y) then 
		focus=self.setting 
	end
	self:setFocus(focus)
	return true
end


function StartLayer:SelectTouchEnd(x,y)
	local x,y=self:toLayerCoord(x,y)
	if not self.focus then 
		return true
	end
	local focus=self.focus
	self:setFocus(nil)

	local scene = share:director():current()
	if focus == self.play then 
		self.nextScene=ScenePlay:New() 
		local fade_layer=ColorLayer:create(Color(0,0,0,0))
		self.fadeLayer=fade_layer
		self.fadeAlpha=0
		scene:push(fade_layer)

		util.changeCallBack(self,self.mExitCallBack)

	elseif  focus ==self.setting then 
		self.nextScene=SceneAbout:New()
		local fade_layer=ColorLayer:create(Color(0,0,0,0))
		self.fadeLayer=fade_layer
		self.fadeAlpha=0
		scene:push(fade_layer)

		util.changeCallBack(self,self.mExitCallBack)
	elseif focus == self.quit then 
		local facd_layer=ColorLayer:create(Color(55,55,55,200))
		scene:push(facd_layer)
		scene:push(QuitLayer:New())
	end
	return true
end





function StartLayer:StartUpdate(dt)
	self:update(dt) 
	local total_frame=self.back_ground:getTotalFrame()
	local cur_frame=self.back_ground:getCurFrame()

	print(total_frame,cur_frame)
	if total_frame -1 == cur_frame then 
		self.play:setVisible(true)
		self.quit:setVisible(true)
		self.setting:setVisible(true)
		util.changeCallBack(self,self.mSelectCallBack)
	end
end


function StartLayer:UpdateSelect(dt)
	self:update(dt)
end

function StartLayer:ExitUpdate(dt)
	self.fadeAlpha=self.fadeAlpha+dt*255
	if self.fadeAlpha >255 then 
		self.fadeAlpha=nil
		self.fadeLayer=nil
		local director=share:director()
		local scene=director:current()
		scene:pop()
		director:push()
		director:run(self.nextScene)
	else 
		self.fadeLayer:setColor(Color(0,0,0,self.fadeAlpha))
	end
end



function StartLayer:Init()
	local back_ground=Sprite2D:create("sprites/start.fst")

	local play=Quad2D:create("textures/play.png",122,43)
	play:setPosition(480,240)
	local quit=Quad2D:create("textures/quit.png",122,43)
	quit:setPosition(480,180)

	local setting=Quad2D:create("textures/settings.png",270,46)
	setting:setPosition(480,120)

	self.play=play
	self.back_ground=back_ground
	self.quit=quit
	self.setting=setting 

	self.onEnter=self.OnEnter
	self.onExit=self.OnExit
	self.setFocus=self.SetFocus
	self:setViewArea(0,0,960,640)
	self:setTouchEnabled(true)

	self:add(self.back_ground)
	self:add(self.play)
	self:add(self.quit)
	self:add(self.setting)

end


function StartLayer:OnEnter() 
	self.focus=nil
	self.nextScene=nil
	self.play:setVisible(false)
	self.quit:setVisible(false)
	self.setting:setVisible(false)
	self.back_ground:setAnimation("default")
	self.back_ground:startAnimation(Sprite2D.ANIM_END)
	util.changeCallBack(self,self.mStartCallBack)
end


function StartLayer:SetFocus(ob)
	if self.focus then 
		self.focus:setScale(1,1,1)
	end
	if ob then 
		ob:setScale(2,2,1)
	end
	self.focus=ob
end



function StartLayer:New() 
	local layer=Layer2D:create()

	f_extends(layer,self)
	layer:Init()
	return layer
end



-- layer begin call back 
StartLayer.mSelectCallBack=
{
	onUpdate=StartLayer.SelectUpdate,
	onTouchBegin=StartLayer.SelectTouchBegin,
	onTouchMove=StartLayer.SelectTouchBegin,
	onTouchEnd=StartLayer.SelectTouchEnd,
}


StartLayer.mStartCallBack=
{
	onUpdate=StartLayer.StartUpdate,
}


StartLayer.mExitCallBack=
{
	onUpdate=StartLayer.ExitUpdate
}






-- scene  
SceneStart=f_newclass()
function SceneStart:New()
	local scene=Scene:create()
	f_extends(scene,self)
	scene:Init()
	return scene;

end
function SceneStart:Init()
	-- attribute 
	self.layer=StartLayer:New()
	self:push(self.layer)

	--call back 
end

function  SceneStart:onEnter()

	self.layer:onEnter();

	collectgarbage("collect")
	print("collect gargage")

	share:textureMgr():unloadAll()
	share:sprite2DDataMgr():unloadAll()

end


function SceneStart:onExit(self)
end 


























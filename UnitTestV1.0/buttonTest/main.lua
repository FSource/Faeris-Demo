scene=Scene:create()

layer=Layer2D:create()

scene:push(layer)
layer:setViewArea(0,0,960,640)
layer:setTouchEnabled(true)
layer:setDispatchTouchEnabled(true)



local q=Quad2D:create("play_up.png");
layer:add(q)
q:setPosition(100,100)


local b1=PressButton:create()

b1:setTexture("play_up.png")

b1:setTexture(PressButton.STATE_NORMAL,"play_up.png")
b1:setTexture(PressButton.STATE_PRESS,"play_up.png")
b1:setTexture(PressButton.STATE_DISABLE,"play_down.png")




b1:setScale(PressButton.STATE_PRESS,1.1,1.1,1)
b1:setRotate(PressButton.STATE_PRESS,0,0,30)
--b1:setOpacity(PressButton.STATE_PRESS,0.3)
b1:setColor(PressButton.STATE_PRESS,Color4f(0.5,0.5,0.5,1.0))
b1:setSize(PressButton.STATE_PRESS,300,200)
b1:setAnchor(PressButton.STATE_PRESS,0,0)


b1:setTweenFlags(E_ButtonTweenFlag.TEXTURE+E_ButtonTweenFlag.SCALE+E_ButtonTweenFlag.OPACITY+E_ButtonTweenFlag.COLOR);


--b1:setTweenInfo(PressButton.STATE_ALL,PressButton.STATE_ALL,LinearEase:create(),0.1)
b1:setTweenInfo(PressButton.STATE_ALL,PressButton.STATE_ALL,LinearEase:create(),0.1)



layer:add(b1)


b1:setPosition(480,320)
b1:setTouchEnabled(true);



b1.__fdata={
	onClick=function(self)
		self:click()
		print("onClick")
	end;
	onPressDown=function(self,x,y)
		self:pressDown(x,y)
		print("onPressDown",x,y)
	end;
	onPressMoveIn=function(self,x,y)
		self:pressMoveIn(x,y)
		print("onPressMoveIn",x,y)
	end;
	onPressMoveOut=function(self,x,y)
		self:pressMoveOut(x,y)
		print("onPressMoveOut",x,y)
	end;
	onPressUp=function(self,x,y)
		self:pressUp(x,y)
		print("onPressUp",x,y)
	end;

	onCancel=function(self,x,y)
		print("onCancel")
		self:cancel()
		--self:setDisabled(true);
	end,
	onTouchEnd=function(self,x,y)
		print("onTouchEnd")
		self:touchEnd(x,y)
	end

}








share:director():run(scene)



scene=Scene:create()

layer=Layer2D:create()

scene:push(layer)
layer:setViewArea(0,0,960,640)
layer:setTouchEnabled(true)
layer:setDispatchTouchEnabled(true)



local q=Quad2D:create("play_up.png");
layer:add(q)
q:setPosition(100,100)


local b1=Button:create()
b1:setTouchEnabled(true);

b1_nstate=b1:getNormalState();
b1_nstate:setTexture("play_up.png")

print(Button.FLAG_TEXTURE+Button.FLAG_SCALE)
b1_nstate:setFlag(Button.FLAG_TEXTURE+Button.FLAG_SCALE)

b1_pstate=b1:getPressState();
b1_pstate:setTexture("play_down.png")
b1_pstate:setScale(Vector3(1.2,1.2,1))
b1_pstate:setFlag(Button.FLAG_TEXTURE+Button.FLAG_SCALE)

b1:setStateNormal();

layer:add(b1)

b1:setPosition(480,320)

b1.data={
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
	onPressCancel=function(self,x,y)
		self:pressCancel(x,y)
		print("onPressCancel",x,y)
	end
}










share:director():run(scene)



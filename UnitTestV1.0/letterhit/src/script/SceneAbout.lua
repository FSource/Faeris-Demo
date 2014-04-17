local MSGLAYER_DEFAULT_SPEED=300

MsgLayer=f_newclass()

function MsgLayer:New()
	local ret= Layer2D:create();
	f_extends(ret,self)
	ret:Init()
	return ret 
end


function MsgLayer:Init()

	local i
	for i=1,#SceneAbout.mText do 
		local text=SceneAbout.mText[i]
		local font=FontTTF:create("simsun.ttc",text.size)
		local label=LabelTTF:create(text.text,font)
		label:setPosition(text.x,text.y)
		if text.color then 
			label:setColor(text.color)
		end
		label:setAlign(LabelTTF.ALIGN_H_CENTER,LabelTTF.ALIGN_V_CENTER)

		self:add(label)
	end

	self:setTouchEnabled(true)
	self:setViewArea(0,0,960,640)


	self.viewX=0
	self.viewY=0
	self.viewWidth=960
	self.viewHeight=640
	self.moveSpeed=0.5
	self.needToMove=0
end


function MsgLayer:onTouchBegin(x,y)
	self.needToMove=0
	self.moveSpeed=0
	self.lastpos={x=x,y=y}
	return true;
end

function MsgLayer:ViewMove(diff)
	self.needToMove=diff
end

function MsgLayer:onTouchMove(x,y)

	local pos=self.lastpos;
	if not pos  then 
		pos={x=x,y=y}
	end

	local diff=pos.y-y
	self.moveSpeed=0

	self.lastpos={x=x,y=y}

	diff= diff*self.viewHeight

	self.viewY=self.viewY+diff
	self:setViewArea(self.viewX,self.viewY,self.viewWidth,self.viewHeight)

	if diff < 0  then 
		self.direction=0
	else 
		self.direction=1
	end

	return true;
end


function MsgLayer:onTouchEnd(x,y)
	self:ViewMove(240)
	self.moveSpeed=MSGLAYER_DEFAULT_SPEED
end



function MsgLayer:onUpdate(dt)
	local ds=self.moveSpeed*dt

	if ds >self.needToMove then 
		ds= self.needToMove 
	end

	self.moveSpeed=self.moveSpeed- dt*MSGLAYER_DEFAULT_SPEED

	if self.moveSpeed < 0 then 
		self.moveSpeed =0 
	end


	self.needToMove=self.needToMove-ds

	if self.direction == 1 then 
		self.viewY=self.viewY+ds
	else 
		self.viewY=self.viewY-ds
	end

	self:setViewArea(self.viewX, self.viewY , self.viewWidth,self.viewHeight)

end






SceneAbout=f_newclass()

function SceneAbout:New()
	collectgarbage("collect")
	local ret=Scene:create()
	f_extends(ret,self)
	ret:Init()
	return ret 
end

function SceneAbout:Init()
	local msg=MsgLayer:New()
	local back=BackLayer:New()
	self:push(msg)
	self:push(back)
end



SceneAbout.mText=
{
	{
		x=480,
		y=300,
		text="Faeris Game Studio",
		size=50,
		color=Color.RED,
	},

	{
		x=480,
		y=200,
		text="website: http://www.faeris.com",
		size=30,
		color=Color.WHITE,
	},

	{
		x=480,
		y=100,
		text="forum: http://www.faeris.com/dz",
		size=30,
		color=Color.WHITE,
	},

	{
		x=480,
		y=0,
		text="game: little game for test",
		size=30,
		color=Color.WHITE,
	},

	{
		x=480,
		y=-100,
		text="version: v.1.2",
		size=30,
		color=Color.WHITE,
	},

	{
		x=480,
		y=-200,
		text="mail: support@faeris.com",
		size=30,
		color=Color.WHITE,
	},

}


































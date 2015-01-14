share:scheduler():scheduleWithMiliSecond(true)
scene=Scene:create()
back_layer=Layer2D:create()
role_layer=Layer2D:create()

sprite=Sprite2D:create("sprite/terrian.fst")
sprite:setAnimation("default")
sprite:setPosition(480-34.60,320-7.03)

role=Sprite2D:create("sprite/hero.fst")
role:setAnimation("run")
role:startAnimation(E_AnimPlayMode.LOOP)
role:setPosition(200,320)
role:setScale(0.7,0.7,0.7)
role.__fdata=
{
	moveSpreed=100,
	targetPosX=nil,
	targetPosY=nil,
	movex=nil,
	movey=nil,
	distancex=nil,
	distancey=nil,

	onUpdate=function(self,dt)
		self:update(dt/1000)

		local data=self.data

		if not data.targetPosX or not data.targetPosY then 
			return
		end

		local x,y=self:getPosition()

		local movex=data.movex*dt/1000
		local movey=data.movey*dt/1000

		if math.abs(movex) > math.abs(data.distancex) then 
			movex = data.distancex
		end

		if math.abs(movey) > math.abs(data.distancey) then 
			movey = data.distancey
		end

		data.distancex = data.distancex - movex
		data.distancey = data.distancey - movey

		self:setPosition(x+movex,y+movey)

	end
}


local function role_move(r,x,y)
	r.targetPosX=x
	r.targetPosY=y
	local ox,oy=r:getPosition()
	local d=math.sqrt((x-ox)*(x-ox)+(y-oy)*(y-oy))
	local time=d/r.moveSpreed
	--print("time:"..time)
	r.movex=(x-ox)/time
	r.movey=(y-oy)/time
	r.distancex=(x-ox)
	r.distancey=(y-oy)

	--print("r.dara.movex:"..r.data.movex.. " r.data.movey:"..r.data.movey)

end


back_layer:add(sprite)
back_layer:add(role)
back_layer:setViewArea(0,0,960,640)


back_layer:setViewArea(0,0,960,640)
back_layer:setTouchEnabled(true)

back_layer.__fdata=
{
	viewareaX=0,
	viewareaY=0,
	onTouchBegin=function(self,x,y)
		self.moveTimes=0
		print("on touch begin")
		self.lastPosx=x
		self.lastPosy=y
		return true
	end,
	onTouchMove=function(self,x,y)
		print("touchMove")
		local data=self
		data.moveTimes=data.moveTimes+1
		if self.moveTimes >=3 then 
			local dx=(x-data.lastPosx)*960
			local dy=(y-data.lastPosy)*640
			print("dx:"..dx.." dy:"..dy)
			data.viewareaX=data.viewareaX-dx
			data.viewareaY=data.viewareaY-dy
			self:setViewArea(data.viewareaX,data.viewareaY,960,640)
		end
		data.lastPosx=x
		data.lastPosy=y
	end,

	onTouchEnd=function(self,x,y)
		print("touchEnd")
		x,y =self:toLayerCoord(x,y)
		if self.moveTimes < 3 then 
			role_move(role,x,y)
		end
	end

}

scene:push(back_layer)
role_layer:add(role)






share:director():run(scene)

local alpahbet={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"}

Quad=f_newclass()

function Quad:New()

	local ret=LabelTTF:create("",font)
	f_extends(ret,self)
	ret:Init()
	return ret 
end

function Quad:Init()

	local litter =alpahbet[math.random(1,#alpahbet)]
	self:setString(litter)
	--print (litter)
	local posx=math.random(0,960)
	local posy=math.random(0,640)
	local speedx=math.random(-5,5)*10
	local speedy=math.random(-5,5)*10
	local color=Color(math.random(100,255),math.random(100,255),math.random(100,255))

	self:setPosition(posx,posy)
	self:setColor(color)
	self:setAlign(LabelTTF.ALIGN_H_CENTER,LabelTTF.ALIGN_V_CENTER)
	--	print(string.format("posx:%f,posy:,%f,speedx:%f,speedy:%f",posx,posy,speedx,speedy))

	self.posx=posx
	self.posy=posy
	self.speedx=speedx
	self.speedy=speedy
	self.onUpdate=self.UpdateLive

end

function Quad:dead()
	self.scale=2
	self.onUpdate=self.UpdateDead
end


function Quad:UpdateDead(dt)
	local scale=self.scale
	self.scale=self.scale-dt*1.5

	if self.scale <0 then 
		self:detach()
	else 
		self:setScale(scale,scale,1)
	end

end

function Quad:UpdateLive(dt)
	self.posx=self.posx+dt*self.speedx
	self.posy=self.posy+dt*self.speedy

	if self.posx < 0 or self.posx >960 then 
		self.posx=math.random(0,960)
	end

	if self.posy <0 or self.posy >640 then 
		self.posy=math.random(0,640) 
	end 

	self:setPosition(self.posx,self.posy)

end 

PlayLayer=f_newclass()

function PlayLayer:New()
	local ret=Layer2D:create()
	f_extends(ret,self)
	ret:Init()
	return ret 
end

function PlayLayer:Init()

	local label=LabelTTF:create("Score:0",font2)
	label:setPosition(20,620)
	self.score=0
	self.scoreLabel=label
	self:add(label)

	local quads={}

	for i=0,10 do 
		local q=Quad:New()
		quads[q]=q
		self:add(q)
	end

	self.quads=quads
	self:setViewArea(0,0,960,640)
	self:setTouchEnabled(true)

end

function PlayLayer:onTouchBegin(x,y)
	local quads=self.quads
	x,y=self:toLayerCoord(x,y)

	local need_move={}
	for key,value  in pairs(quads) do 
		if key:hit2D(x,y) then 
			key:dead()
			need_move[key]=key
			self.score=self.score+10
			local new_quad=Quad:New()
			self:add(new_quad)
			quads[new_quad]=new_quad
		end
	end

	for key,value in pairs(need_move) do 
		quads[key]=nil
	end

	self.scoreLabel:setString("Score:"..self.score)
	return true;
end



BackLayer=f_newclass()

function BackLayer:New()
	local ret=Layer2D:create()
	f_extends(ret,self);
	ret:Init()
	return ret
end

function BackLayer:Init()

	self:setViewArea(0,0,960,640)

	local label=LabelTTF:create("<<back",font2)
	self:add(label)

	label:setPosition(800,620)

	self:setTouchEnabled(true)

	local function touch(self,x,y) 
		return false 
	end

	self.label=label

	return layer
end

function BackLayer:onTouchBegin(x,y)
	x,y=self:toLayerCoord(x,y)
	if self.label:hit2D(x,y) then 

		share:director():pop()
		return true
	end
	return false
end

function BackLayer:onTouchMove(x,y)
	return false
end

function BackLayer:onTouchEnd(x,y)
	return false
end



ScenePlay=f_newclass()

function ScenePlay:New()
	local ret=Scene:create()
	f_extends(ret,self)
	ret:Init()
	return ret 
end

function ScenePlay:Init()

	local play_layer=PlayLayer:New()
	local back_layer=BackLayer:New()
	self:push(play_layer)
	self:push(back_layer)

end


function ScenePlay:onEnter()

	print("play")
	share:textureMgr():unloadAll()
	share:sprite2DDataMgr():unloadAll()

end
function ScenePlay:onExit()
	share:textureMgr():unloadAll()
	share:sprite2DDataMgr():unloadAll()
end









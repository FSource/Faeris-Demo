fButton=libfs.Class("fButton")

local S_fButtonPreAttrFunc=libfs.GetAttrFuncs{
	"pos","color","zorder","scale", 
	"rotate","opacity","textureUrl",
	"touchEnabled","children","dispatchTouchEnabled",
	"visible","visibles","anchor","action",
} 

local S_fButtonPostAttrFunc=libfs.GetAttrFuncs{
	"size"
}
function fButton:New(cfg)
	local ret=Quad2D:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	ret.f_raw=cfg
	return ret
end

function fButton:Init(cfg)
	libfs.SetAttrute(S_fButtonPreAttrFunc,self,cfg)
	libfs.SetAttrute(S_fButtonPostAttrFunc,self,cfg)
	if cfg.normal then 
		libfs.SetAttrute(S_fButtonPreAttrFunc,self,cfg.normal)
		libfs.SetAttrute(S_fButtonPostAttrFunc,self,cfg.normal)
	end
	self.m_soundEffect=cfg.soundEffect or  SoundEffect.ButtonPress
	--print(self.m_soundEffect)
end
function fButton:onTouchBegin(x,y)
	g_AudioEngine:playSound(self.m_soundEffect)
	self.f_focus=true
	self:onTouchMoveIn()
	return true
end
function fButton:SetState(state)
	local param=self.f_raw[state] 
	if param then
		libfs.SetAttrute(S_fButtonPreAttrFunc,self,param)
		libfs.SetAttrute(S_fButtonPostAttrFunc,self,param)
	end
end
function fButton:onTouchMove(x,y) 
	local hit=self:onHit2D(x,y)
	if hit then 
		if not self.f_focus then 
			self.f_focus=true
			self:onTouchMoveIn()
		end
	else 
		if self.f_focus then
			self.f_focus=false
			self:onTouchMoveOut()
		end
	end
end
function fButton:onHit2D(x,y)
	return self:hit2D(x,y)
end
function fButton:onTouchEnd(x,y)
	self.f_focus=false
	self:onTouchMoveOut()
	local hit=self:onHit2D(x,y) 
	if hit then 
		self:onClick()
	end
end
function fButton:onClick()
end
function fButton:onTouchMoveIn()
	if self.f_raw.press then 
		libfs.SetAttrute(S_fButtonPreAttrFunc,self,self.f_raw.press);
		libfs.SetAttrute(S_fButtonPostAttrFunc,self,self.f_raw.press);
	end
end
function fButton:onTouchMoveOut()
	if self.f_raw.normal then 
		libfs.SetAttrute(S_fButtonPreAttrFunc,self,self.f_raw.normal);
		libfs.SetAttrute(S_fButtonPostAttrFunc,self,self.f_raw.normal);
	end
end

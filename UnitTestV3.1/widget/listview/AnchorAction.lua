AnchorAction=f_newclass();

function AnchorAction:New(cfg)
	local ret=Action:create()
	f_extends(ret,self)

	ret:Init(cfg)
	return ret

end


function AnchorAction:Init(cfg)

	self.m_startAnchor=cfg.startAnchor;
	self.m_endAnchor=cfg.endAnchor;
	self.m_duration=cfg.duration or 1.0; 
	self.m_timeEscape=0

end


function AnchorAction:onRun(target,dt)
	self.m_timeEscape=self.m_timeEscape+dt
	local finish=false

	if self.m_timeEscape>self.m_duration then 
		
		self.m_timeEscape=self.m_duration;
		finish=true;
	end

	local percent=self.m_timeEscape/self.m_duration;

	local w=self.m_startAnchor.w+(self.m_endAnchor.w-self.m_startAnchor.w)*percent
	local h=self.m_startAnchor.h+(self.m_endAnchor.h-self.m_startAnchor.h)*percent


	target:setAnchor(w,h)


	return finish,0

end








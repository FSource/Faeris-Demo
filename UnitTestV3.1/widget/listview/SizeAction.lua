SizeAction=f_newclass();

function SizeAction:New(cfg)
	local ret=Action:create()
	f_extends(ret,self)
	ret:Init(cfg)

	return ret

end


function SizeAction:Init(cfg)

	self.m_startSize=cfg.startSize;
	self.m_endSize=cfg.endSize;
	self.m_duration=cfg.duration or 1.0; 
	self.m_timeEscape=0

end


function SizeAction:onRun(target,dt)
	self.m_timeEscape=self.m_timeEscape+dt
	local finish=false

	if self.m_timeEscape>self.m_duration then 
		
		self.m_timeEscape=self.m_duration;
		finish=true;
	end

	local percent=self.m_timeEscape/self.m_duration;

	local w=self.m_startSize.w+(self.m_endSize.w-self.m_startSize.w)*percent
	local h=self.m_startSize.h+(self.m_endSize.h-self.m_startSize.h)*percent


	target:setSize(w,h)


	return finish,0

end








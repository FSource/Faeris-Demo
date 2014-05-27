EaseExample=libfs.Class("EaseExample")

function EaseExample:New()
	local ret=Scene:create()
	libfs.Extends(ret,self)
	ret:Init()
	return ret
end


function EaseExample:Init()
	local layer=Layer2D:create()
	layer:setViewArea(0,0,W_WIDTH,W_HEIGHT)

	layer:setTouchEnabled(true)
	layer:setDispatchTouchEnabled(true)

	self.m_curveHListPanel=CurveHListPanel:New{
		pos={x=0,y=500},
		height=255,
	}

	layer:add(self.m_curveHListPanel)

	layer:add(MovePanel:New{
		pos={x=140,y=80}
	})


	self.m_timeLinePanel=TimeLinePanel:New{
		pos={x=0,y=40}
	}

	layer:add(self.m_timeLinePanel)

	self:push(layer)

	self.m_totalTime=3
	self.m_curTime=0
end


function EaseExample:GetCurve(index)
	return self.m_curveHListPanel:GetCurve(index)

end

function EaseExample:GetCurTimePercent()
	return self.m_timeLinePanel:GetTimePercent()
	--return self.m_curTime/self.m_totalTime
	--return 1.0
end

function EaseExample:onUpdate(dt)
	self:update(dt)
	self.m_curTime=self.m_curTime+dt 
	if self.m_curTime >self.m_totalTime then 
		self.m_curTime=0 
	end
end



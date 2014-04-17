ResultText=f_newclass("ResultText")


function ResultText:New(str)

	local ret=LabelTTF:create()
	f_extends(ret,self)
	ret:Init(str)
	return ret

end

function ResultText:Init(str)

	self:setFontName("simsun.ttc")
	self:setFontSize(35)
	self:setString(str)
	self:setPositionX(500)
	self:setColor(Color.RED)

	self.m_beginTime=0
	self.m_curTime=0

	self.m_endTime=2


	self.m_startY=400 
	self.m_endY=600

end

function ResultText:onUpdate(dt)
	if self.m_curTime == self.m_endTime then 
		self:detach()
		return 
	end


	self.m_curTime=self.m_curTime+dt

	if self.m_curTime  >self.m_endTime then 
		self.m_curTime=self.m_endTime
	end


	local pencent=self.m_curTime/self.m_endTime 

	self:setOpacity(1-pencent)

	self:setPositionY(self.m_startY+(self.m_endY-self.m_startY)*pencent)

end









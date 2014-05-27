TimeLinePanel=libfs.Class("TimeLinePanel")


function TimeLinePanel:New(cfg)
	local ret=Entity:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret
end


function TimeLinePanel:Init(cfg)
	if cfg.pos then 
		self:setPosition(cfg.pos.x,cfg.pos.y)
	end
	self:setTouchEnabled(true)
	self:setDispatchTouchEnabled(true)

	self:InitLabel()
	self:InitTimeLine()
	self:InitPressButton()

	self.m_curTime=0 
	self.m_totalTime=1.5
	self.m_run=false
	self.m_loop=false
	self.m_updateTime=true

	self:UpdateTotalTime()
	self:UpdateLoopButton()

end

function TimeLinePanel:InitLabel()

	local time_label=libfs.NewFType{
		ftype="fQuad2D",
		textureUrl="image/button_bg.png",
		pos={x=100,y=0},
		size={w=100,h=30},
		color=Color(1,126,255),
		children={
			["label"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=20,
				string="TimeLine:"
			}
		}
	}
	self:addChild(time_label)
end

function TimeLinePanel:InitTimeLine()
	local timeline=libfs.NewFType{
		ftype="fQuad2D",
		textureUrl="image/button_bg.png",
		pos={x=180,y=0},
		anchor={x=0,y=0.5},
		color=Color(1,125,255),
		size={w=400,h=16}
	}
	self:addChild(timeline)

	local begin_x=180+8 
	local end_x =180+400-8

	local quad=libfs.NewFType{
		touchEnabled=true,
		ftype="fQuad2D",
		textureUrl="image/button_bg.png",
		pos={x=180,y=0},
		size={w=16,h=16},
		color=Color(225,156,0),
		children={
			["time"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=15,
				pos={x=0,y=-14},
			}
		}
	}
	quad.onUpdate=function()
		local x=begin_x+(end_x-begin_x)*self:GetTimePercent()
		quad:setPositionX(x)
		quad.f_children["time"]:setString(string.format("%.2fs",self.m_curTime))
	end

	quad.onTouchBegin=function(t,x,y) 
		self.m_updateTime=false
		quad.m_lastPos={x=x,y=y}
		return true
	end

	quad.onTouchMove=function(t,x,y) 
		local diffx=x-quad.m_lastPos.x
		local px=quad:getPositionX()+diffx
		if px < begin_x then 
			px = begin_x 
		end
		if px > end_x then 
			px = end_x 
		end
		local percent=(px-begin_x)/(end_x-begin_x)
		self:setTimePercent(percent)

		quad:setPositionX(px)
		quad.m_lastPos={x=x,y=y}

	end

	quad.onTouchEnd=function(t,x,y) 
		self.m_updateTime=true 
	end


	self:addChild(quad)



	local dec_button=libfs.NewFType{
		touchEnabled=true,
		ftype="fButton",
		textureUrl="image/button_bg.png",
		pos={x=600,y=0},
		size={w=20,h=20},
		children={
			["label"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=20,
				string="<"
			}
		},
		normal={
			color=Color(1,126,255),
		},
		press={
			color=Color(1,126,255,100),
		}
	}
	self:addChild(dec_button)
	dec_button.onClick=function()
		self.m_totalTime=self.m_totalTime-0.1
		if self.m_totalTime < 0.1 then 
			self.m_totalTime=0.1
		end
		self:UpdateTotalTime()
	end

	local add_button=libfs.NewFType{
		touchEnabled=true,
		ftype="fButton",
		textureUrl="image/button_bg.png",
		pos={x=700,y=0},
		size={w=20,h=20},
		children={
			["label"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=20,
				string=">"
			}
		},
		normal={
			color=Color(1,126,255),
		},
		press={
			color=Color(1,126,255,100),
		}
	}
	self:addChild(add_button)
	add_button.onClick=function()
		self.m_totalTime=self.m_totalTime+0.1 
		self:UpdateTotalTime()
	end


	self.m_totalTimeLabel=libfs.NewFType{
		ftype="fLabelTTF",
		fontName=g_DefaultFontName,
		fontSize=20,
		string="5s",
		pos={x=650,y=0},
		color=Color(1,125,255)
	}
	self:addChild(self.m_totalTimeLabel)

end

function TimeLinePanel:InitPressButton()

	local loop_button=libfs.NewFType{
		touchEnabled=true,
		ftype="fButton",
		textureUrl="image/button_bg.png",
		pos={x=800,y=0},
		size={w=80,h=30},
		children={
			["label"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=20,
				string="Loop"
			}
		},
		color=Color(1,126,255),
	}
	self:addChild(loop_button)
	loop_button.onClick=function()
		self.m_loop=not self.m_loop 
		self:UpdateLoopButton()
	end
	self.m_loopButton=loop_button



	local run_button=libfs.NewFType{
		touchEnabled=true,
		ftype="fButton",
		textureUrl="image/button_bg.png",
		pos={x=900,y=0},
		size={w=80,h=30},
		children={
			["label"]={
				ftype="fLabelTTF",
				fontName=g_DefaultFontName,
				fontSize=20,
				string="run"
			}
		},
		normal={
			color=Color(1,126,255),
		},
		press={
			color=Color(1,126,255,100),
		}
	}
	self:addChild(run_button)

	run_button.onClick=function()

		if self.m_run then 
			self.m_curTime= 0 
		else 
			if self.m_curTime==self.m_totalTime then 
				self.m_curTime=0 
			end
			self.m_run=true 
		end
	end

end


function TimeLinePanel:onHit2D(x,y)
	return true
end


function TimeLinePanel:UpdateLoopButton()

	if self.m_loop then 
		self.m_loopButton:setColor(Color(1,126,255,100))
	else 
		self.m_loopButton:setColor(Color(1,126,255))
	end
end


function TimeLinePanel:UpdateTotalTime()
	self.m_totalTimeLabel:setString(string.format("%.2f",self.m_totalTime))
end


function TimeLinePanel:onUpdate(dt)
	self:update(dt)

	if not self.m_updateTime then 
		return 
	end

	if self.m_curTime > self.m_totalTime then 
		self.m_curTime=self.m_totalTime 
	end


	if self.m_run then 
		self.m_curTime=self.m_curTime + dt 
		if self.m_curTime > self.m_totalTime then 
			if self.m_loop then 
				self.m_curTime=self.m_curTime%self.m_totalTime
			else 
				self.m_curTime=self.m_totalTime
				self.m_run=false 
			end
		end
	end
end

function TimeLinePanel:GetTimePercent()
	return self.m_curTime/self.m_totalTime
end

function TimeLinePanel:setTimePercent(p)
	self.m_curTime =self.m_totalTime* p
end




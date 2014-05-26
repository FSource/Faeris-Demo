EaseCurveChooseUi=libfs.Class("EaseCurveChooseUi")



function EaseCurveChooseUi:New()
	local ret=Layer2D:create()
	libfs.Extends(ret,self)
	ret:Init()
	return ret
end


function EaseCurveChooseUi:Init()
	self:setViewArea(0,0,W_WIDTH,W_HEIGHT)
	self:setSortMode(Layer2D.SORT_ORDER_Z)
	self:setTouchEnabled(true)
	self:setDispatchTouchEnabled(true)

	self:InitBg()
	self:InitEaseChooseBoard()

end

function EaseCurveChooseUi:InitBg()
	local c=ColorQuad2D:create(W_WIDTH,W_HEIGHT,Color(51,51,51,220))
	c:setAnchor(0,0)
	self:add(c)
end


function EaseCurveChooseUi:InitEaseChooseBoard()

	local step_x = W_WIDTH/5
	local start_x= step_x/2
	local start_y= W_HEIGHT-150
	local step_y= -220

	for k,v in ipairs(g_EaseCfg) do 

		local x=start_x+ (k-1)%5*step_x
		local y=start_y+ math.floor((k-1)/5)*step_y
		local board=EaseChooseBoard:New(v)
		board:setTouchEnabled(true)

		board.onTouchBegin=function(x,y)  
			print("tttt") 
			if self.m_foucs then 
				self.m_foucs:setState("normal")
			end
			self.m_foucs=board 
			self.m_foucs:setState("press")
		end

		board:setPosition(x,y) 
		print(x,y)
		self:add(board)
	end
	self.m_foucsIndex=1

end

function EaseCurveChooseUi:onTouchBegin(x,y)
	self:touchBegin(x,y) 
	return true 
end



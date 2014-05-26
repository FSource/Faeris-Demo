VListPanel=libfs.Class("VListPanel")

local S_VListPanelAttrFunc=libfs.GetAttrFuncs{
	"pos","anchor","size","zorder",
	"scale","rotate",
	"touchEnabled","visible","visibles","dispatchTouchEnabled",
}


function VListPanel:New(cfg)

	local ret=Panel:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret

end


function VListPanel:Init(cfg)

	self.Cfg = cfg;

	self.m_mode=cfg.model
	self.m_items={}

	self.m_vGap=cfg.vgap or 0 
	self.m_hGap=cfg.hgap or 0
	self.m_listGap=cfg.listGap or 0

	self.m_panelWidth=cfg.size.w
	self.m_panelHeight=cfg.size.h

	if cfg.anchor then 
		self.m_anchorX=cfg.anchor.x  or 0.5
		self.m_anchorY=cfg.anchor.y or 0.5
	else 
		self.m_anchorX=0.5 
		self.m_anchorY=0.5
	end

	if cfg.pos then 
		self:setPosition(cfg.pos.x,cfg.pos.y)
	end

	if cfg.Debug then
		self:InitPanelQuad();
	end

	self:setSize(self.m_panelWidth,self.m_panelHeight)
	self:setAnchor(self.m_anchorX,self.m_anchorY)

	self.m_yOffset=0

	self.m_itemRoot=Entity:create()

	self.m_itemRoot.data={}

	self.m_itemRoot.onHit2D=function(self,x,y) 
		return true
	end

	self.m_itemRoot:setTouchEnabled(true)
	self.m_itemRoot:setDispatchTouchEnabled(true)

	self:addChild(self.m_itemRoot)


	self.m_itemRootPos={
						x=-self.m_panelWidth*self.m_anchorX,
						y=self.m_panelHeight*(1-self.m_anchorY)
					}


	self.m_itemRoot:setPosition(self.m_itemRootPos.x,self.m_itemRootPos.y)

	self.m_timer=Timer()
	

end

function VListPanel:InitPanelQuad()
	local w = self.m_panelWidth
	local h = self.m_panelHeight;
	
	local color_q = ColorQuad2D:create(Rect2D(0, 0, w, h), Color(255, 0, 0, 100))
	color_q:setAnchor(self.m_anchorX,self.m_anchorY)
	self:addChild(color_q)
end

function VListPanel:Refresh()
	self:clearAction()

	for k,v in ipairs(self.m_items) do 
		v:detach()
	end

	self.m_items={}

	self.m_yOffset=0
	self.m_maxYOffset=0
	self.m_minYOffset=0

	local list_nu=self.m_mode:GetListNu()
	if list_nu == 0 then 
		return 
	end
		
	
	local start_y = self.Cfg.Start_y or 0;

	local w,h= self.m_mode:GetListSize()

	step_y=-(h+self.m_listGap)

	local x=(self.m_panelWidth-w)/2

	for i=1,list_nu do 

		local l=self.m_mode:GetListEntity(i)
		l:setPosition(x,start_y+(step_y)*(i-1))
		self.m_itemRoot:addChild(l)

		self.m_items[i]=l

	end

	self.m_minYOffset=0
	self.m_maxYOffset=h+(h+self.m_listGap)*(list_nu-1)-self.m_panelHeight

	print(self.m_maxYOffset)

	if self.m_maxYOffset <0 then 
		self.m_maxYOffset=0
	end



	self.m_viewMaxY=self.m_itemRootPos.y+h
	self.m_viewMinY=self.m_itemRootPos.y-self.m_panelHeight-h

	self.m_listGapMax=h+self.m_listGap

end


function VListPanel:GetModel()

	return self.m_mode 
end

function VListPanel:getOffsetMovePercent()

	local ret=1
	if self.m_yOffset < self.m_minYOffset then 
		local df=self.m_minYOffset-self.m_yOffset 
		if df > self.m_panelHeight then 
			df =self.m_panelHeight 
		end
		ret=1-df/self.m_panelHeight 
	end

	if self.m_yOffset > self.m_maxYOffset then 
		local df =self.m_yOffset-self.m_maxYOffset 
		if df > self.m_panelHeight then 
			df =self.m_panelHeight 
		end
		ret=1-df/self.m_panelHeight
	end
	return ret*ret*ret
end

function VListPanel:getInnerOffsetMovePercent(v)

	local stop_height=20

	local ret =1 

	if v > 0 then 
		local df=self.m_maxYOffset-self.m_yOffset 

		if df > stop_height then 
			return 1
		else 
			return df/stop_height
		end
	else 
		local df=self.m_yOffset-self.m_minYOffset 

		if df > stop_height then
			return 1
		else 
			return df/stop_height
		end
	end

end


function VListPanel:onTouchBegin(x,y) 
	local ret=self:touchBegin(x,y)
	if ret then 
		--return true 
	end
	self.m_lastPos={x=x,y=y}
	self.onTouchMove=self.onTouchSlideMove
	self.onTouchEnd=self.onTouchSlideEnd
	self:clearAction()

	self.m_lastSlideTime=self.m_timer:now()

	self.m_diffy=0;
	self.m_difft=0;

	return true
end

function VListPanel:onTouchSlideMove(x,y)
	self:touchMove(x,y)
	local diffy=y-self.m_lastPos.y

	local cur_time=self.m_timer:now()
	local difft=self.m_timer:now()-self.m_lastSlideTime 
	self.m_lastSlideTime=cur_time


	local percent=self:getOffsetMovePercent()
	self.m_yOffset=self.m_yOffset+diffy*percent
	self.m_lastPos={x=x,y=y}

	self.m_diffy=diffy
	self.m_difft=difft

end



function VListPanel:onUpdate(dt)
	self:update(dt)
	self:updateRootItemPos()
end



function VListPanel:AlignEdgeAction()

	if self.m_yOffset > self.m_maxYOffset then 
		local action=RectilinearMotionAction:New{
			endValue=self.m_maxYOffset,
			attr="m_yOffset",
		}
		self:doAction(action)
		return  true
	end

	if self.m_yOffset < self.m_minYOffset then 
		local action=RectilinearMotionAction:New{
			endValue=self.m_minYOffset,
			attr="m_yOffset",
		}
		self:doAction(action)
		return  true 
	end
	return false 
end


function VListPanel:onTouchSlideEnd(x,y)
	self:touchEnd(x,y)

	self.onTouchMove=nil 
	self.onTouchEnd=nil

	if self:AlignEdgeAction() then 
		return 
	end

	local distance=self.m_diffy
	local dtime=self.m_difft

	if dtime == 0 then 
		return 
	end


	local v=distance/dtime*1000

	if math.abs(v)< 10 then 
		return 
	end 

	if v > 1500 then 
		v=1500 
	elseif v < -1500  then 
		v=-1500 
	end


	local action=Action:create()

	action.data={
		m_speed=v,
		m_curTime=0,
		m_totalTime=1,

		onRun=function(self,target,dt)
			local finish =false 
			self.m_curTime=self.m_curTime + dt
			if self.m_curTime >= self.m_totalTime then 
				self.m_curTime =self.m_totalTime  
				finish=true
			end

			local speed=self.m_speed* (1-self.m_curTime/self.m_totalTime)^3
			target.m_yOffset=target.m_yOffset+speed*dt*target:getInnerOffsetMovePercent(self.m_speed)
			if target.m_yOffset > target.m_maxYOffset then 
				target.m_yOffset= target.m_maxYOffset 
				return true 
			end

			if target.m_yOffset < target.m_minYOffset then 
				target.m_yOffset=target.m_minYOffset 
				return true
			end
			return finish 
		end
	}
	self:doAction(action)
end


function VListPanel:updateRootItemPos()
	self.m_itemRoot:setPosition(self.m_itemRootPos.x,self.m_itemRootPos.y+self.m_yOffset)
end

function VListPanel:onDraw(render)
	local _,pos_y=self.m_itemRoot:getPosition()
	for k,v in ipairs(self.m_items) do 

		local item_pos_max=pos_y-k*self.m_listGapMax
		local item_pos_min=pos_y-(k+1)*self.m_listGapMax

		if item_pos_max < self.m_viewMinY then 
			v:setVisibles(false)
		elseif  item_pos_min > self.m_viewMaxY then 
			v:setVisibles(false)
		else 
			v:setVisibles(true)
		end
	end
end























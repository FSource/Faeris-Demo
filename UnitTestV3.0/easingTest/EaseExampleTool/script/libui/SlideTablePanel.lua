SlideTablePanel=libfs.Class("SlideTablePanel")
local S_SlideTablePanelAttrFunc=libfs.GetAttrFuncs{

	"pos","anchor","size","zorder",
	"scale","rotate","anchor",
	"touchEnabled","visible","visibles",
	"dispatchTouchEnabled",

}

function SlideTablePanel:New(cfg)

	local ret=Panel:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret
end

function SlideTablePanel:Init(cfg)

	self.m_model=libfs.NewFType(cfg.model)

	self.m_hGridNu=0
	self.m_vGridNu=0
	self.m_direction=cfg.direction or "horizontal"

	self.m_panelWidth= cfg.size.w or 0 
	self.m_panelHeight=cfg.size.h or 0

	self.m_valignNu=cfg.valignNu or 1 
	self.m_halignNu=cfg.halignNu or 1

	self.m_vGap=cfg.vGap or 0 
	self.m_hGap=cfg.hGap or 0

	self.m_gridWidth=0 
	self.m_gridHeight=0

	self.m_cellWidth=0
	self.m_cellHeight=0

	self.m_xOffset=0
	self.m_yOffset=0

	self.m_itemRoot=Entity:create()
	self.m_itemRoot.data={}

	self.m_itemRoot.onHit2D=function(self,x,y) 
		return true
	end

	if cfg.anchor then 
		self.m_anchorX=cfg.anchor.x  or 0.5
		self.m_anchorY=cfg.anchor.y or 0.5
	else 
		self.m_anchorX=0.5 
		self.m_anchorY=0.5
	end



	self.m_itemRoot:setTouchEnabled(true)
	self.m_itemRoot:setDispatchTouchEnabled(true)

	self.m_itemRootPos={
		x=-self.m_panelWidth*self.m_anchorX,
		y=self.m_panelHeight*(1-self.m_anchorY)
	}

	self.m_itemRoot:setPosition(self.m_itemRootPos.x,self.m_itemRootPos.y)

	self:addChild(self.m_itemRoot)

	libfs.SetAttrute(S_SlideTablePanelAttrFunc,self,cfg)

	self.m_items={}

	self.m_timer=Timer()

	self:setTouchEnabled(true)
	self:setDispatchTouchEnabled(true)

end 

function SlideTablePanel:Refresh()

	for k,v in pairs(self.m_items) do 
		for _,z in pairs(v) do 
			z:detach()
		end
	end

	self.m_items={}

	self.m_gridWidth,self.m_gridHeight= self.m_model:GetGridSize()
	self.m_cellWidth=self.m_gridWidth+self.m_hGap
	self.m_cellHeight=self.m_gridHeight+self.m_vGap
	self.m_hGridNu,self.m_vGridNu = self.m_model:GetGridNu()

	self.m_minYOffset=0

	local align_y_value=math.floor(self.m_vGridNu/self.m_valignNu)
	if self.m_vGridNu ~=0 and self.m_vGridNu % self.m_valignNu == 0 then 
		align_y_value = align_y_value -1 
	end
	self.m_maxYOffset= align_y_value*self.m_cellHeight*self.m_valignNu



	local align_x_value=math.floor(self.m_hGridNu/self.m_halignNu)
	if self.m_hGridNu ~= 0 and self.m_hGridNu % self.m_halignNu == 0 then 
		align_x_value=align_x_value - 1 
	end

	self.m_maxXOffset=0 
	self.m_minXOffset= -align_x_value*self.m_cellWidth*self.m_halignNu


	self.m_xOffset = 0 
	self.m_yOffset = 0


	for i=1,self.m_hGridNu do 

		if not self.m_items[i] then 
			self.m_items[i]={}
		end

		for j=1,self.m_vGridNu do 
			local e = self.m_model:GetGridEntity(i,j)
			if e then

				local x=self.m_cellWidth*(i-1)+self.m_hGap/2
				local y=self.m_cellHeight*(j-1)+self.m_vGap/2

				e:setPosition(x,-y)

				self.m_items[i][j]=e 
				self.m_itemRoot:addChild(e)
			end
		end
	end
end


function SlideTablePanel:GetOffsetMovePercent()

	local px,py=1,1 

	if self.m_yOffset > self.m_maxYOffset then 
		local df=self.m_yOffset-self.m_maxYOffset 
		if df> self.m_gridHeight then 
			df=self.m_gridHeight 
		end
		py=1-df/self.m_gridHeight 

	elseif self.m_yOffset < self.m_minYOffset then 
		local df = self.m_minYOffset-self.m_yOffset 
		if df > self.m_gridHeight then 
			df = self.m_gridHeight 
		end
		py=1-df/self.m_gridHeight 
	end

	if self.m_xOffset > self.m_maxXOffset then 
		local df =self.m_xOffset - self.m_maxXOffset 
		if df > self.m_gridWidth then 
			df=self.m_gridWidth 
		end
		px=1-df/self.m_gridWidth 

	elseif self.m_xOffset < self.m_minXOffset then 
		local df = self.m_minXOffset - self.m_xOffset 

		if df > self.m_gridWidth then 
			df=self.m_gridWidth 
		end
		px=1-df/self.m_gridWidth 
	end

	return px^3,py^3

end


function SlideTablePanel:onTouchBegin(x,y)

	local ret= self:touchBegin(x,y) 

	if ret then 
		return true 
	end

	self.m_lastPos={x=x,y=y}
	self.onTouchMove=self.onTouchSlideMove
	self.onTouchEnd=self.onTouchSlideEnd
	self:clearAction()

	self.m_diffx=0
	self.m_diffy=0

	self.m_lastTouchTime=self.m_timer:now()

	return true
end

function SlideTablePanel:onTouchSlideMove(x,y) 

	local diffy=y-self.m_lastPos.y
	local diffx=x-self.m_lastPos.x 


	local cur_touch_time=self.m_timer:now()
	local difft=cur_touch_time-self.m_lastTouchTime
	self.m_lastTouchTime=cur_touch_time



	local px,py =self:GetOffsetMovePercent()

	if self.m_direction == "vertical" then 
		self.m_yOffset=self.m_yOffset + diffy*py
	elseif self.m_direction == "horizontal" then 
		self.m_xOffset = self.m_xOffset + diffx*px
	end

	self.m_diffx=diffx 
	self.m_diffy=diffy
	self.m_difft=difft

	self.m_lastPos={x=x,y=y}

end

function SlideTablePanel:onTouchSlideEnd(x,y) 

	self.onTouchMove = nil 
	self.onTouchEnd=nil

	local endx,endy 

	if self.m_xOffset <= self.m_minXOffset then  
	endx= self.m_minXOffset
elseif self.m_xOffset > self.m_maxXOffset then 
endx=self.m_maxXOffset 
	else 
		local align_z = math.floor((self.m_maxXOffset-self.m_xOffset)/(self.m_cellWidth*self.m_halignNu)+0.5)

		local _,align_f=math.modf((self.m_maxXOffset-self.m_xOffset)/(self.m_cellWidth*self.m_halignNu))


		if self.m_difft and self.m_difft ~= 0 then 
			local v=self.m_diffx/self.m_difft *1000


			local t=(v/(self.m_cellWidth*self.m_halignNu)) 


			if v < 0 then 

				if align_f < 0.5 then 

					if align_f + (-v/(self.m_cellWidth*self.m_halignNu)) > 0.5 then 
						align_z=align_z+1 
					end
				end


			elseif v > 0 then 
				if align_f > 0.5 then 
					if align_f - (v/(self.m_cellWidth*self.m_halignNu)) < 0.5 then 
						align_z = align_z -1 
						if align_z < 0 then 
							align_z = 0 

						end
					end
				end
			end
		end

	endx=self.m_maxXOffset-align_z*(self.m_cellWidth*self.m_halignNu)

end



if self.m_yOffset <= self.m_minYOffset then 
endy = self.m_minYOffset 
elseif self.m_yOffset > self.m_maxYOffset then 
endy =self.m_maxYOffset 
else 
	local align_z = math.floor((self.m_yOffset-self.m_minYOffset)/(self.m_cellHeight*self.m_valignNu)+0.5)

	local _,align_f=math.modf((self.m_yOffset-self.m_minYOffset)/(self.m_cellHeight*self.m_valignNu))


	if self.m_difft and  self.m_difft ~= 0 then 
		local v=self.m_diffy/self.m_difft *1000


		local t=(v/(self.m_cellHeight*self.m_valignNu)) 


		if v > 0 then 

			if align_f < 0.5 then 

				if align_f + (v/(self.m_cellHeight*self.m_valignNu)) > 0.5 then 
					align_z=align_z+1 
				end
			end


		elseif v < 0 then 
			if align_f > 0.5 then 
				if align_f + (v/(self.m_cellHeight*self.m_valignNu)) < 0.5 then 
					align_z = align_z -1 
					if align_z < 0 then 
						align_z = 0 
					end
				end
			end
		end
	end

endy=self.m_minYOffset+align_z*(self.m_cellHeight*self.m_valignNu)

	end

	if self.m_direction == "vertical" then 
		local action = RectilinearMotionAction:New{
		endValue=endy ,
		attr="m_yOffset",
	}
	self:doAction(action)

elseif self.m_direction == "horizontal" then 
	local action = RectilinearMotionAction:New{
	endValue=endx,
	attr="m_xOffset",
}
self:doAction(action)
	end

end

function SlideTablePanel:updateRootItemPos()

	self.m_itemRoot:setPosition(self.m_itemRootPos.x+self.m_xOffset,
	self.m_itemRootPos.y+self.m_yOffset)
end

function SlideTablePanel:onUpdate(dt)
	self:update(dt)
	self:updateRootItemPos()
end














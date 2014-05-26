TabBar=libfs.Class("TabBar")


local S_TabBarAttrFunc=libfs.GetAttrFuncs{
	"pos","zorder","scale","rotate","touchEnabled","dispatchTouchEnabled",
	"children","visible","visibles",
}

function TabBar:New(cfg)

	local ret=Entity:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret

end

function TabBar:Init(cfg)

	self.m_tabWidth=cfg.tabWidth;
	self.m_tabHeight=cfg.tabHeight;
	self.m_tabDirection=cfg.tabDirection or "horizontal"; 
	self.m_curIndex=-1

	self.m_vGap = cfg.vGap or 0
	self.m_hGap=cfg.hGap or 0

	self.m_tabItem={}

	libfs.SetAttrute(S_TabBarAttrFunc,self,cfg)


end

function TabBar:GetTabPos(index)

	if index == 0 then 
		return 0
	end
	local tabpos=0 
	if self.m_tabDirection == "horizontal" then 
		tabpos=(self.m_tabWidth+self.m_hGap)*index
	else 
		tabpos=(self.m_tabHeight+self.m_vGap)*index
	end
	return tabpos 

end

function TabBar:ToTabIndex(pos)
	if self.m_tabDirection=="horizontal" then 
		if pos< self.m_tabWidth then 
			return 0
		else 
			return math.ceil((pos-self.m_tabWidth)/(self.m_tabWidth+self.m_hGap))
		end
	else 
		if -pos< self.m_tabHeight then 
			return 0
		else 
			return math.ceil((-pos-self.m_tabHeight)/(self.m_tabHeight+self.m_vGap))
		end

	end
end



function TabBar:SetTab(index,e)

	local pos=self:GetTabPos(index)
	local t=libfs.NewFType(e)

	if self.m_tabItem[index] then 
		self.m_tabItem[index]:detach()
		self.m_tabItem[index]=nil
	end

	if t then 
		if self.m_tabDirection == "horizontal" then 
			t:setPosition(pos,0)
		else 
			t:setPosition(0,-pos)
		end
		self:addChild(t)
	end

	self.m_tabItem[index]=t


end

function TabBar:SetCurrentIndex(index,sg)

	if self.m_tabItem[self.m_curIndex] then 
		self.m_tabItem[self.m_curIndex]:setState("normal")
	end

	if self.m_tabItem[index] then 
		self.m_tabItem[index]:setState("press")
	end

	if sg then 
		if self.m_curIndex ~=index then
			self.m_curIndex=index
			self:onCurrentIndexChange(self.m_curIndex);
		end
	end

	self.m_curIndex=index
end


function TabBar:GetCurrentIndex()
	return self.m_curIndex
end


function TabBar:onCurrentIndexChange(index)

end


function TabBar:onHit2D(x,y) 

	local v=self:worldToLocal(Vector3(x,y,0))
	local maxn = table.maxn(self.m_tabItem)


	if maxn == 0 then 
		if not self.m_tabItem[0] then 
			return false 
		end
	end


	maxn=maxn+1

	if self.m_tabDirection == "horizontal" then 
		if v.y <= 0 and  v.y > -self.m_tabHeight then 
			local maxx= self.m_tabWidth+(self.m_tabWidth+self.m_hGap)*(maxn-1)
			if v.x >=0  and v.x < maxx then 
				return true 

			end
		end

	else 
		if v.x >=0 and v.x < self.m_tabWidth then 
			local maxy= self.m_tabHeight+(self.m_tabHeight+self.m_vGap)*(maxn-1)
			if v.y <=0 and v.y > -maxy  then 
				return true 
			end
		end
	end
	return false

end


function TabBar:onTouchBegin(x,y)
	local v=self:worldToLocal(Vector3(x,y,0))

	local index=-1 

	if self.m_tabDirection=="horizontal" then 
		index=self:ToTabIndex(v.x) 
	else 
		index=self:ToTabIndex(v.y) 
	end

	if index ~=self.m_curIndex then 
	end

	self:SetCurrentIndex(index,true)
	return true

end








































CatmullRomCurveView=f_newclass("CurveView")

local S_PointSize=5

function CatmullRomCurveView:New()
	local ret=Layer2D:create();
	f_extends(ret,self);
	ret:Init()
	return ret
end


function CatmullRomCurveView:Init()

	self:InitAxis()
	self:setViewArea(-480,-320,960,640)
	self:setTouchEnabled(true)

	self.m_points={
		{x=20,y=20},
		{x=50,y=80},
		{x=100,y=160},
		{x=20,y=300},
		{x=-250,y=-100},
		{x=-400,y=300}
	}

	self.m_catmullRomCurver=CatmullRomCurve3:create()

	self.m_vertexPolygon=VertexPolygon:create()
	self.m_vertexPolygon:setMode(E_DrawMode.LINE_STRIP)
	self.m_vertexPolygon:setColor(Color.RED)

	self.m_mainPoint={}
	self:add(self.m_vertexPolygon)
	self:CalPoint()

	self:InitMoveObject()

	self.m_curMoveTime=0
	self.m_totalMoveTime=5

end



function CatmullRomCurveView:InitAxis()

	local axis=VertexPolygon:create()

	axis:append(-480,0)
	axis:append(480,0)

	axis:append(0,-320)
	axis:append(0,320)
	
	axis:setMode(E_DrawMode.LINES)

	self:add(axis)

end


function CatmullRomCurveView:CalPoint()

	for k,v in pairs(self.m_mainPoint) do 
		v:detach()
	end

	self.m_mainPoint={}

	self.m_catmullRomCurver:clear()
	self.m_vertexPolygon:resize(0)

	for k,v in ipairs(self.m_points) do 
		self.m_catmullRomCurver:addPoint(Vector3(v.x,v.y,0))

		local p=VertexPolygon:create()
		local size=S_PointSize

		p:append(v.x-size,v.y-size,0)
		p:append(v.x+size,v.y-size,0)
		p:append(v.x+size,v.y+size,0)
		p:append(v.x-size,v.y+size,0)
		p:setMode(E_DrawMode.LINE_LOOP)
		p:setColor(Color.BLUE)
		self:add(p)
		table.insert(self.m_mainPoint,p)
	end

	local times=100
	for i=0,times do 
		local v=self.m_catmullRomCurver:getValue(i/times)
		print(i/times,v.x,v.y,v.z)

		self.m_vertexPolygon:append(v)
	end

end


function CatmullRomCurveView:InitMoveObject(dt)

	self.m_moveObject=Quad2D:create(Color.GREEN,30,30)
	self:add(self.m_moveObject)

end

function CatmullRomCurveView:onUpdate(dt)
	self:update(dt)

	self.m_curMoveTime=self.m_curMoveTime+dt 

	if self.m_curMoveTime >self.m_totalMoveTime then 
		self.m_curMoveTime=self.m_curMoveTime-self.m_totalMoveTime 
	end

	local t =self.m_curMoveTime/self.m_totalMoveTime 

	local v=self.m_catmullRomCurver:getValue(t)

	self.m_moveObject:setPosition(v.x,v.y)

end

function CatmullRomCurveView:onTouchBegin(x,y)

	local x,y=self:toLayerCoord(x,y)

	for k,v in ipairs(self.m_points) do 
		print(math.abs(v.x-x),math.abs(v.y-y))
		if  math.abs(v.x-x) < S_PointSize and math.abs(v.y-y) < S_PointSize then 
			self.m_focusPoint=v
			break
		end
	end

	self.m_lastPoint={x=x,y=y}
	return true

end


function CatmullRomCurveView:onTouchMove(x,y)

	if not self.m_focusPoint then 
		return 
	end

		
	local x,y=self:toLayerCoord(x,y)

	local diffx=x-self.m_lastPoint.x 
	local diffy=y-self.m_lastPoint.y

	print(diffx,diffy)
	self.m_focusPoint.x=self.m_focusPoint.x+diffx 
	self.m_focusPoint.y=self.m_focusPoint.y+diffy

	self:CalPoint()

	self.m_lastPoint={x=x,y=y}

end


function CatmullRomCurveView:onTouchEnd(x,y)

	self.m_focusPoint=nil
end













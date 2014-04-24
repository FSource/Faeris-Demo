Bezier=f_newclass("Bezier")

function Bezier:New()
	local ret=VertexPolygon:create()
	f_extends(ret,self)
	ret:Init()
	return ret
end

function Bezier:Init()

	self:GeneratePoints(0,0.33,0.67,1.0)
end

function Bezier:GeneratePoints(p0,p1,p2,p3)

	self:resize(0)
	local max_points=10000

	for i=0,max_points do  
		local t=i/max_points

		local y=(1-t)^3*p0+3*(1-t)^2*t*p1+3*(1-t)*t^2*p2+t^3*p3
		self:append(t,y)
	end

end




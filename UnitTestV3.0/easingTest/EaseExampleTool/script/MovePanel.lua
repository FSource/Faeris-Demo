MovePanel=libfs.Class("MovePanel")

function MovePanel:New(cfg)

	local ret=ColorQuad2D:create(1000,400,Color(27,82,144))
	libfs.Extends(ret,self)
	ret:Init(cfg)
	return ret

end


function MovePanel:Init(cfg)
	self:setAnchor(0,0)
	if cfg.pos then 
		self:setPosition(cfg.pos.x,cfg.pos.y)
	end

	self:InitMoveQuad()
end

function MovePanel:InitMoveQuad()

	local start_x=20
	local width=960

	local start_y=400-50
	local step_y=-100
	local height=60


	for i=1,4 do  
		local bg=ColorQuad2D:create(width,height,Color(64,158,255))
		bg:setPosition(start_x,start_y+step_y*(i-1))
		bg:setAnchor(0,0.5)
		self:addChild(bg)

		local quad_start_x=height/2
		local quad_end_x=width-height/2

		local quad=ColorQuad2D:create(height,height,Color(253,125,184))
		bg:addChild(quad)
		quad.data={}

		quad.onUpdate=function(_,dt)

			local q,mode=self:getScene():GetCurve(i)

			local t=self:getScene():GetCurTimePercent()
			local x=quad_start_x+(quad_end_x-quad_start_x)*q:getValue(t,mode)
			quad:setPositionX(x)
		end
	end
end





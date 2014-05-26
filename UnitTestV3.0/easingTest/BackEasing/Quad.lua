Quad = {}

Quad.__index = Quad;

function Quad:New(o)
	local quad = ColorQuad2D:create(o.W, o.H, o.Color)
	quad.data = {};
	setmetatable(quad.data, self);
	quad:Init(o);
	return quad;
end

function Quad:Init(cfg)
	self.X = cfg.X or 100;
	self.Y = cfg.Y or 100;
	self.X0 = self.X;
	self.Y0 = self.Y;
	self:setPosition(self.X, self.Y);
	
	
	self.Time = 0;
	self.TotalTime = 2
	self.MoveType = "Linear";
	self.EaseType = FS_EASE_IN;
end

function Quad:SetTotalTime(time)
	self.TotalTime = time
end


function Quad:SetInterpolation(interpolation)
	self.Interpolation = interpolation;
end

function Quad:onUpdate(dt)
	if self.Time and self.Time < self.TotalTime then
		self.Time = self.Time + dt;
		if self.Time >= self.TotalTime then
			self.Time = self.TotalTime;
		end
		local p = self.Time/self.TotalTime
		local t = self:GetValueByType(p);
		self.X = self.X0 + self.Interpolation*t;
		self:setPosition(self.X, self.Y)
	end
end


function Quad:InitData()
	self.X = self.X0
	self.Y = self.Y0;
	self.Time = 0
	self:setPosition(self.X, self.Y);
end;
	
function Quad:GetValueByType(p)
	if self.MoveType then
		if self.MoveType == "Linear" then
			if not self.LinerEase then
				self.LinearEase = LinearEase:create();
			end
			self.LinearEase:setMode(self.EaseType)
			return self.LinearEase:getValue(p);
			
		elseif self.MoveType == "Back" then
			if not self.BackEase then
				self.BackEase = BackEase:create();
			end
			self.BackEase:setMode(self.EaseType)
			return self.BackEase:getValue(p);
		else
			return p;
		end
	end
end

function Quad:SetMoveType(type)
	self.MoveType = type;
end

function Quad:SetEaseType(type)
	self.EaseType = type;
end
































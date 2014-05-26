ChooseButton = {}

ChooseButton.__index = ChooseButton;
setmetatable(ChooseButton, TextButton);


function ChooseButton:onTouchBegin(x, y)
	if not self:visible() then return end
	if not self:CanBeChoosed() then return end
	if self:Hit2d(x, y) then 		
		if self.pressTexture then
			self:setTexture(self.pressTexture) 
		else
			self:setColor(Color(100,100,100))
		end
		self.Flag = true;
		if self.Cfg.PressFunc then
			self.Cfg.PressFunc()
		end
		return true 
	end
	return false
end



function ChooseButton:onTouchMove(x, y)
	if not self:visible() then return end
	if not self:CanBeChoosed() then return end
	if self.Flag then
		if self:Hit2d(x, y) then
			if self.pressTexture then
				self:setTexture(self.pressTexture)
			else
				self:setColor(Color(100,100,100)) 
			end
			
		else
			if self.pressTexture then
				self:setTexture(self.normalTexture)
			else
				self:setColor(self.Color)
			end
			
		end
	end
end

function ChooseButton:onTouchEnd(x, y)
	if not self:visible() then return end
	if not self:CanBeChoosed() then return end
	if self.Flag then 
		if self:Hit2d(x, y) then
			self:SetBeChoosed(true)
			if self.Func then	
				self.Func();
			end
		end
		self.Flag = nil
	end
end

function ChooseButton:SetBeChoosed(value)
	self.BeChoosed = value;
	if value then
		if self.pressTexture then
			self:setTexture(self.pressTexture)
		else
			self:setColor(Color(100,100,100))
		end
	else
		if self.pressTexture then
			self:setTexture(self.normalTexture)
		else
			self:setColor(self.Color)
		end
	end
end

function ChooseButton:GetBeChoosed()
	return self.BeChoosed;
end

function ChooseButton:CanBeChoosed()
	return not self:GetBeChoosed();
end

function ChooseButton:Hit2d(x, y)
	if self.Rect then
		return IsPointInRect(x, y, self.Rect)
	else
		return self:hit2D(x, y)
	end
end

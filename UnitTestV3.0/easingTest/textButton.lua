

TextButton = {}

TextButton.__index = TextButton;


function TextButton:New(o)
	local w = o.w;
	local h = o.h;
	local color = o.color or Color(45, 56, 89);
	local entity = ColorQuad2D:create(w, h, color);
	entity.data = {};
	setmetatable(entity.data, TextButton);
	entity:Init(o);
	return entity;
end


function TextButton:Init(cfg)
	self.Cfg = cfg;
	self:setTouchEnabled(true);
	self:InitText();
	self.X = self.Cfg.x;
	self.Y = self.Cfg.y;
	self.Color = self.Cfg.color or Color.RED;
	self:setPosition(self.X,  self.Y);
	
	self.Func = self.Cfg.Func;
end



function TextButton:InitText()
	local text = self.Cfg.text or "ÎÄ×Ö";
	local text_area = LabelTTF:create(g_DefaultFontName, 22, "LV")
	text_area:setAnchor(0.5, 0.5)
	text_area:setString(text)
	text_area:setColor(Color(255, 255, 255));
	self:addChild(text_area);
	
	self.Text = text;
end

function TextButton:GetText()
	return self.Text;
end


function TextButton:onTouchBegin(x, y)
	self:setColor(Color(100,100,100))
	return true
end


function TextButton:onTouchEnd(x, y)
	self:setColor(self.Color)
	if self.Func then	
		self.Func();
	end
	return true
end
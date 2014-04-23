

GameLayer = {}
GameLayer.__index = GameLayer;

function GameLayer:New()
	local layer = Layer2D:create();
	layer.data = {};
	setmetatable(layer.data, self);
	layer:Init()
	return layer
end

function GameLayer:Init()
	
	self:setViewArea(0, 0, W_Width, W_Height);
	self:setTouchEnabled(true)
	self:setSortMode(Layer2D.SORT_ORDER_Z)
	self:setDispatchTouchEnabled(true);
	
	self:InitData();
	self:InitRectFrame();
	self:InitQuad();
	self:InitRunButton();
	self:InitMoveButtons();
	self:InitEaseTypeButtons();
	
end

function GameLayer:InitData()
	self.QuadW = 50;
	self.RectX = 200;
	self.RectY = W_Height - 100;
	self.RectW = W_Width - 2*self.RectX;
	self.RectH = self.QuadW + 3;
	
	self.MoveType = "Linear";
end

function GameLayer:SetMoveType(type)
	self.MoveType = type;
end

function GameLayer:GetMoveType()
	return self.MoveType;
end


function GameLayer:SetEaseType(type)
	self.EaseType = type;
end

function GameLayer:GetEaseType()
	return self.EaseType;
end


function GameLayer:InitRectFrame()
	local quadW = self.QuadW
	local rectX = self.RectX
	local rectY = self.RectY
	local rectW = self.RectW
	local rectH = self.RectH
	local rectParam = {mode = VertexPolygon.LINE_STRIP, color = Color(83, 19, 19)};	
	local vertexs = {
		{x = rectX, y = rectY},
		{x = rectX + rectW, y = rectY},
		{x = rectX + rectW, y = rectY - rectH},
		{x = rectX, y = rectY - rectH},
		{x = rectX, y = rectY},

	}

	local p = VertexPolygon:create();
	for k, v in ipairs(vertexs) do 
		p:append(v.x, v.y)
	end
	p:setMode(rectParam.mode)
	p:setColor(rectParam.color)
	self:add(p)
end

function GameLayer:InitQuad()
	local w = self.QuadW;
	local h = self.QuadW;
	local color = Color(0, 102, 0);
	local x = self.RectX + w/2 + 1;
	local y = self.RectY - h/2 - 1;
	
	local quad = Quad:New{W = w, H = h, Color = color, X = x, Y = y};	
	self:add(quad);
	self.Quad = quad;
	
	

	local totalW = self.RectW - w - 3;
	local totalTime = 1.5;
	local interpolation = totalW;
	quad:SetInterpolation(interpolation);
	quad:SetTotalTime(totalTime)
end

function GameLayer:GetQuad()
	return self.Quad;
end

function GameLayer:InitRunButton()
	local buttonCfg = {
		w = 100,
		h = 60,
		x = 200,
		y = 200,
		text = "Run",
		color = Color(255, 56, 89),
	}

	local button = TextButton:New(buttonCfg)
	self:add(button);
	
	button.Func = function()
		self:Run();
	end
end

function GameLayer:Run()
	local quad = self:GetQuad();
	if quad then
		quad:InitData();
		quad:SetMoveType(self:GetMoveType());
		quad:SetEaseType(self:GetEaseType())
	end
end

function GameLayer:InitMoveButtons()

	self.MoveButtons = {};

	for index, value in ipairs(ChooseModel_CFG) do
		local tbutuon = ChooseButton:New(value);
		self:add(tbutuon);
		table.insert(self.MoveButtons, tbutuon)
		tbutuon.Func = function()
			self:SetMoveType(value.text)
			
			for _, button in ipairs(self.MoveButtons) do
				button:SetBeChoosed(false)
			end
			tbutuon:SetBeChoosed(true)
		end
		
	end
end

local easeTypes = {
	{Text = "EaseIn", Value = FS_EASE_IN},
	{Text = "EaseOut", Value = FS_EASE_OUT},
	{Text = "EaseInOut", Value = FS_EASE_INOUT},
	{Text = "EaseOutIn", Value = FS_EASE_OUTIN},
}

function GameLayer:InitEaseTypeButtons()

	self.EaseTypeButtons = {};

	local x = W_Width - 200;
	local y = W_Height/2;
	
	for index, value in ipairs(easeTypes) do
		local bx = x;
		local by = y - (index - 1)*70
		local cfg =	 {
			w = 120,
			h = 60,
			x = bx,
			y = by,
			text = value.Text,
			color = Color(145, 156, 89),
		};
		button = ChooseButton:New(cfg);
		table.insert(self.EaseTypeButtons, button);
		self:add(button);
		button.Func = function()
			self:SetEaseType(value.Value);
			
			for _, _button in ipairs(self.EaseTypeButtons) do
				_button:SetBeChoosed(false)
			end
			button:SetBeChoosed(true);
		end
	end
end







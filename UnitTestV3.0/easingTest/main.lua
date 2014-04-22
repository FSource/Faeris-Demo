
f_import("textButton.lua");

g_DefaultFontName = "DroidSansFallback.ttf";


local w_width = 960;
local w_height = 640;

local scene=Scene:create()
share:director():run(scene);
local layer = Layer2D:create()
layer:setViewArea(0, 0, w_width, w_height);
scene:push(layer);
layer:setTouchEnabled(true)
layer:setSortMode(Layer2D.SORT_ORDER_Z)
layer:setDispatchTouchEnabled(true);


local quadW = 50;

local rectX = 200;
local rectY = w_height - 100;
local rectW = w_width - 2*rectX;
local rectH = quadW + 3;

local rectParam = {mode = VertexPolygon.LINE_STRIP, color = Color(83, 19, 19)};	

local vertexs = {
	{x = rectX, y = rectY},
	{x = rectX + rectW, y = rectY},
	{x = rectX + rectW, y = rectY - rectH},
	{x = rectX, y = rectY - rectH},
	{x = rectX, y = rectY},

}

local function drawRect()
	local p = VertexPolygon:create();
	for k, v in ipairs(vertexs) do 
		p:append(v.x, v.y)
	end
	p:setMode(rectParam.mode)
	p:setColor(rectParam.color)
	layer:add(p)
end


local function drawBack()
	local back = ColorQuad2D:create(w_width, w_height, Color4f.WHITE)
	back:setPosition(w_width/2, w_height/2);
	layer:add(back);
end



drawBack();
drawRect();





local quad = ColorQuad2D:create(quadW, quadW, Color(0, 102, 0))
local x0 = rectX + quadW/2 + 1;
local y0 = rectY - quadW/2 - 1;
quad:setPosition(x0, y0);
layer:add(quad);

local totalW = rectW - quadW - 2;
local totalTime = 2;
local speed = totalW;

local backEase = BackEase:create();
local linerEase = LinearEase:create();

quad.data={
	Time = 0,
	X = x0;
	Y = y0;
	Type = "Linear";
	onUpdate = function(self, dt)
		if self.Time and self.Time < totalTime then
			self.Time = self.Time + dt;
			if self.Time >= totalTime then
				self.Time = totalTime;

			end
			local p = self.Time/totalTime
			local t = self:GetValueByType(p);
			self.X = x0 + speed*t;
			self:setPosition(self.X, self.Y)
		end
	end ;
	Init = function(self)
		self.X = x0;
		self.Y = y0;
		self.Time = 0
		self:setPosition(self.X, self.Y);
	end;
	
	GetValueByType = function(self, p)
		if self.Type then
			if self.Type == "Linear" then
				if not self.LinerEase then
					self.LinearEase = LinearEase:create();
				end
				return self.LinearEase:getValue(p);
				
			elseif self.Type == "Back" then
				if not self.BackEase then
					self.BackEase = BackEase:create();
				end
				return self.BackEase:getValue(p);
			else
				return p;
			end
		end
	end;
	SetType = function(self, type)
		self.Type = type;
	end
}

local buttonCfg = {
	w = 100,
	h = 60,
	x = 200,
	y = 200,
	text = "Run",
	color = Color(255, 56, 89),
}

local button = TextButton:New(buttonCfg)
layer:add(button);


SType = "Linear"

button.Func = function()

	quad:Init();
	quad:SetType(SType)

end


C_Buttons = {}

chooseButtons = {
	 {
		w = 100,
		h = 60,
		x = 200,
		y = 300,
		text = "Linear",
		color = Color(45, 56, 89),
		Func = function()
			SType = "Linear";
		end
	},
	{
		w = 100,
		h = 60,
		x = 400,
		y = 300,
		text = "Back",
		color = Color(45, 56, 89),
		Func = function()
			SType = "Back";
		end
	},
}

for index, value in ipairs(chooseButtons) do
	local tbutuon = TextButton:New(value);
	layer:add(tbutuon);
	C_Buttons[index] = tbutuon;
end

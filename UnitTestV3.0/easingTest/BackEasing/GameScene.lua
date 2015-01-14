GameScene = f_newclass();


function GameScene:New()
	local scene = Scene:create();

	f_extends(scene,self)

	scene:Init();

	return scene
end

function GameScene:Init()
	local colorlayer = ColorLayer:create(Color(255, 255, 255, 255))
	self:push(colorlayer)

	self:InitGameLayer();
end

function GameScene:InitGameLayer()
	local layer = GameLayer:New();
	self:push(layer);
end






















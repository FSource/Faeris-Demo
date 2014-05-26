GameScene = {

}
GameScene.__index = GameScene;

function GameScene:New()
	local scene = Scene:create();
	scene.data = {};
	setmetatable(scene.data, self)
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






















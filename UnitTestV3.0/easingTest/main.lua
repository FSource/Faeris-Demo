f_import("GameScene.lua")
f_import("GameLayer.lua")
f_import("Quad.lua")

f_import("textButton.lua");
f_import("ChooseModel.lua");



g_DefaultFontName = "DroidSansFallback.ttf";


W_Width = 960;
W_Height = 640;

local scene=GameScene:New();
share:director():run(scene);


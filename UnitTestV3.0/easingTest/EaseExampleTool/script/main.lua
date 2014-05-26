
g_DefaultFontName="font/DroidSansFallback.ttf"
W_WIDTH=1200 
W_HEIGHT=800 

-- aux lib --
f_import("script/libfs/libfs.lua")
f_import("script/libui/libui.lua")

-- config -- 
f_import("script/EaseCfg.lua")


-- app --
f_import("script/AxisCoord.lua") 
f_import("script/EaseExample.lua")
f_import("script/CurveHListPanel.lua")
f_import("script/CurveWidget.lua")
f_import("script/EaseChooseBoard.lua")
f_import("script/EaseCurveChooseUi.lua")



share:director():run(EaseExample:New())


share:render():setClearColor(Color4f(51/255,51/255,51/255,51/255))


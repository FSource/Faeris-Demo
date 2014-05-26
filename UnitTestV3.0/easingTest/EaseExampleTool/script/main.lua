
W_WIDTH=1200 
W_HEIGHT=800 

f_import("script/libfs/libfs.lua")
f_import("script/AxisCoord.lua") 
f_import("script/EaseExample.lua")
f_import("script/CurvePanel.lua")

share:director():run(EaseExample:New())


share:render():setClearColor(Color4f(1,1,1,1))


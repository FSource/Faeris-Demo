f_import("CurveView.lua")

local scene=Scene:create()
scene:push(CatmullRomCurveView:New())
share:director():run(scene)








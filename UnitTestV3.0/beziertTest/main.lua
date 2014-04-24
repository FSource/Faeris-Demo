f_import("GraphicsShowUi.lua")
f_import("Bezier.lua")

local scene=Scene:create()
scene:push(GraphicsShowUi:New())



share:director():run(scene)




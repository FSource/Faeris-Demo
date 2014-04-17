f_import("script/PayCodeUi.lua")
f_import("script/ResultText.lua")




local scene=Scene:create()
scene:push(PayCodeUi:New())


share:director():run(scene)





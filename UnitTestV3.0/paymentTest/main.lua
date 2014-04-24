f_import("script/PayCodeUi.lua")
f_import("script/ResultText.lua")
f_import("script/BuyPayment.lua")
f_import("script/PaymentFakeCfg.lua")

g_Payment=BuyPayment:New(g_PaymentCfg)


local scene=Scene:create()
scene:push(PayCodeUi:New())


share:director():run(scene)




font=FontTTF:create("simsun.ttc",100)
font2=FontTTF:create("simsun.ttc",50)

font:addRef()
font2:addRef()

f_import("script/SceneStart.lua")
f_import("script/SceneAbout.lua")
f_import("script/ScenePlay.lua")
f_import("script/fps.lua")

util={}

function util.changeCallBack(ob,call_backs)

	ob.onUpdate=call_backs.onUpdate
	if not ob.onUpdate then 
		print "data.onUpdate is Null"
	end

	ob.onDraw=call_backs.onDraw
	ob.onTouchBegin=call_backs.onTouchBegin
	ob.onTouchMove=call_backs.onTouchMove
	ob.onTouchEnd=call_backs.onTouchEnd
end




local director=share:director()


local start=SceneStart:New()

director:run(start)





scene=Scene:create()


layer=Layer2D:create()
layer:setViewArea(0,0,960,640)

label=LabelTTF:create("simsun.ttc",30,"Please Press Keybord")
label:setPosition(480,320)

label1=LabelTTF:create("simsun.ttc",30,"FPS:0")
label1:setPosition(60,600)

layer:add(label)
layer:add(label1)




init=false;
cur_string="Please Press Keybord"



g_time=0
fps=0

scene.__fdata={
	onKeypadEvent=function(self,t,code)
		if t==KeypadEvent.KEYPAD_DOWN then 
			return 
		end

		if (code>=KEY_A and code <= KEY_Z) or ( code>=KEY_0 and code <= KEY_9) or (code== KEY_SPACE) then 
			if not init then 
				init =true 
				cur_string=""
			end
			cur_string=cur_string..string.format("%c",code)
			label:setString(cur_string)
		end

		if code ==KEY_BACKSPACE then 
			if not init then 
				return 
			end
			cur_string=string.sub(cur_string,1,-2)
			if cur_string == "" then 
				cur_string="Please Press Keybord" 
				init=false
			end
			label:setString(cur_string)
		end


	end,
	onUpdate=function(self,dt)
		fps=fps+1
		g_time=g_time+dt
		if g_time >=1000 then 
			g_time=g_time-1000
			label1:setString(string.format("FPS:%d",fps))
			fps=0
		end
	end

}

scene:push(layer)

share:director():run(scene);
















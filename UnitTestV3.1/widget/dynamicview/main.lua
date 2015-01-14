
local S_States={

	["State1"]="This is a big and beautiful world. Most of us live and die in the same corner where we were born and never get to see any of it. I don't want to be most of us.",
	["State2"]="You distract me. I've been distracted since the moment I met you. Because all I can think about is how much I want to kiss you.",
	["State3"]="It's the rule of life that everything you have always wanted comes the very second you stop looking for it.",
	["State4"]="If you don't go after what you want, you'll never have it. If you don't step forward, you're always in the same place",
	["State5"]="Just make sure, you know, you appreciate those who are still there for you.",
	["State6"]="It's the rule of life that everything you have always wanted comes the very second you stop looking for it."

}



function S_CreateView(w,h,text)
	local ret=UiWidget:create(w,h)


	local label=LabelTTF:create("simsun.ttc",20,text)
	label:setBoundSize(w,h);

	local w,h=label:getTextWidth(),label:getTextHeight()


	ret:setSize(w,h)

	local q=Quad2D:create(Color(math.random(255),math.random(255),math.random(255),100),w,h)
	ret:addChild(q)




	ret:addChild(label)

	return ret
end



function S_CreateDynamicView(w,h)

	local ret=DynamicView:create(w,h);
	return ret;

end





function S_CreateScene()

	local layer=Layer2D:create()
	layer:setViewArea(0,0,960,640)
	layer:setTouchEnabled(true)
	layer:setDispatchTouchEnabled(true)

	local scene=Scene:create()
	scene:push(layer)


	local dyview=S_CreateDynamicView(600,500)
	dyview:setMargin(20,20,20,20)

	dyview:setBgColor(Color(100,100,0,100));
	dyview:setBgEnabled(true)
	dyview:setPosition(480,320)


	local start_y= 500 
	local step_y=-80
	local start_x=100
	local i=0

	local focus_button=nil

	for k,v in pairs(S_States) do 

		local button=ToggleButton:createWithColorStyle("button_bg.png",Color.WHITE,Color(125,125,125))
		button:setPosition(start_x,start_y+step_y*i)
		button:setSize(80,40)
		button:setColor(ToggleButton.STATE_ON,Color(0,144,188))

		local label=LabelTTF:create("simsun.ttc",20,k)

		button:addChild(label)
		f_setattrenv(button,{})

		if k== "State1"  then 
			button:setToggle(true);
			focus_button=button
		else 
			button:setToggle(false)
		end

		button.onToggleChanged=function(value)

			if not value then 
				return 
			end

			if focus_button == button then 
				return 
			end

			dyview:setCurrentView(k)

			if focus_button then 
				focus_button:setToggle(false)
			end

			focus_button=button
		end

		i=i+1
		layer:add(button)
		dyview:addView(k,S_CreateView(500,400,v))

	end


	local alignh=E_AlignH.CENTER
	local alignv=E_AlignV.CENTER 

	local alignh_map={
		[E_AlignH.LEFT]={
			align=E_AlignH.CENTER,
			text="X:CENTER",
		},

		[E_AlignH.CENTER]={
			align=E_AlignH.RIGHT,
			text="X:RIGHT",
		},

		[E_AlignH.RIGHT]={
			align=E_AlignH.LEFT,
			text="X:LEFT",
		}
	}
	
	local alignv_map={
		[E_AlignV.TOP]={
			align=E_AlignV.CENTER,
			text="Y:CENTER"
		},

		[E_AlignV.CENTER]={
			align=E_AlignV.BOTTOM,
			text="Y:BOTTOM",
		},

		[E_AlignV.BOTTOM]={
			align=E_AlignV.TOP,
			text="Y:TOP",
		}
	}



	local l_align_button=PressButton:createWithDarkStyle("button_bg.png",Color(0,144,188))
	l_align_button:setPosition(start_x,start_y+step_y*i)
	l_align_button:setSize(100,40)
	l_align_button:setColor(PressButton.STATE_NORMAL,Color(205,73,0))
	l_align_button:setPosition(960/2-120,600)

	local l_label=LabelTTF:create("simsun.ttc",20,"X:CENTER")



	l_align_button:addChild(l_label)
	f_setattrenv(l_align_button,{})

	l_align_button.onClick=function()
		local view=dyview:getCurrentView()

		local next_align=alignh_map[alignh]
		alignh=next_align.align
		l_label:setString(next_align.text)

		dyview:setCurrentViewAlign(alignh,alignv)
	end


	layer:add(l_align_button);


	local r_align_button=PressButton:createWithDarkStyle("button_bg.png",Color(0,144,188))
	r_align_button:setColor(PressButton.STATE_NORMAL,Color(205,73,0))
	r_align_button:setSize(100,40)
	r_align_button:setPosition(960/2, 600)


	local r_label=LabelTTF:create("simsun.ttc",20,"Y:CENTER")
	r_align_button:addChild(r_label)
	f_setattrenv(r_align_button,{})

	r_align_button.onClick=function()
		print("click")

		local next_align=alignv_map[alignv]
		alignv=next_align.align 
		r_label:setString(next_align.text)
		dyview:setCurrentViewAlign(alignh,alignv)
	end


	layer:add(r_align_button)

	dyview:setCurrentView("State1")

	layer:add(dyview);

	return scene

end




share:director():run(S_CreateScene())




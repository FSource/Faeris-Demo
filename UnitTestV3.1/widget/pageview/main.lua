
local TEXT_ID=1


function S_CreatePageItem(w,h)

	local page=UiWidget:create(w,h)
	local q=Quad2D:create(Color(math.random(255),math.random(255),math.random(255)),w,h);


	--page:setScissorEnabled(false);
	--page:addChild(q)

	local pw=250 
	local ph=120
	local hborder=140
	local vborder=100

	local start_x=-w/2+hborder
	step_x=(w-hborder*2)/2

	local start_y=h/2-vborder
	step_y=-(h-vborder*2)/2


	print(w,h,step_x,step_y)

	for i=0,2 do 
		start_y=h/2-vborder

		for j=0,2 do 
			local c= Color(math.random(255),math.random(255),math.random(255))
			local qt=Quad2D:create(c,pw,ph)
			f_setattrenv(qt,{})
			qt:setTouchEnabled(true)

			qt.onTouchBegin=function()
				qt:setColor( Color(math.random(255),math.random(255),math.random(255)))
			end




			qt:setPosition(start_x+i*step_x,start_y+j*step_y);
			--print(i,j,start_x+i*step_x,start_y+j*step_y);
			local text=LabelTTF:create("simsun.ttc",16,string.format("Name: NosicLin\nEmail:nosiclin@foxmail.com\nNo.%d",TEXT_ID));
			qt:addChild(text)
			--text:setColor(Color(255-c.b,c.r,c.g))

			page:addChild(qt)


			TEXT_ID=TEXT_ID+1

		end


	end


	return page



end



function S_CreatePageView(w, h)

	local ret=PageView:create(w,h);

	local q=Quad2D:create(Color(100,100,100),w,h)
	q:setZorder(-1)
	ret:addChild(q)

	return ret


end


function S_CreateScene()

	local layer=Layer2D:create()
	layer:setViewArea(0,0,960,640)
	layer:setTouchEnabled(true)
	layer:setDispatchTouchEnabled(true)

	f_setattrenv(layer,{})
	layer.onUpdate=function(l,dt)
		layer:update(dt)
		--print(1/dt)
	end







	local scene=Scene:create()
	scene:push(layer)

	local w=960
	local h=550


	local pgview=S_CreatePageView(w,h)

	for i=1,100 do 
		local page=S_CreatePageItem(w-30,h-30)
		pgview:addPage(page)
	end

	pgview:setPosition(w/2,640/2+(640-h)/2-10)
	layer:add(pgview)

	local prev_button=PressButton:createWithDarkStyle("button_bg.png",Color(0,144,188))
	prev_button:setSize(100,40)
	prev_button:setPosition(480-100,40);
	prev_button:setColor(PressButton.STATE_NORMAL,Color(205,73,0))
	local l_label=LabelTTF:create("simsun.ttc",20,"PrevPage");
	prev_button:addChild(l_label);
	prev_button.onClick=function()
		pgview:slideToPrevPage();
	end
	layer:add(prev_button)

	local next_button=PressButton:createWithDarkStyle("button_bg.png",Color(0,144,188))
	next_button:setPosition(480+100,40);
	next_button:setSize(100,40)
	next_button:setColor(PressButton.STATE_NORMAL,Color(205,73,0))
	local l_label=LabelTTF:create("simsun.ttc",20,"NextPage");
	next_button:addChild(l_label);
	next_button.onClick=function()
		pgview:slideToNextPage();
	end
	layer:add(next_button)

	return scene

end




share:director():run(S_CreateScene())




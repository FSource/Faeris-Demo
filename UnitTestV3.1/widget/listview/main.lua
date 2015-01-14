f_import("SizeAction.lua")
f_import("AnchorAction.lua")


local S_lastIndex=0

local S_UiWidget=0


function S_createListWidget(w,h,i)

	w=w-math.random(100)-40

	--print("S_createListWidget")
	local ret=UiWidget:create(w,h);

	local c= Color(math.random(255),math.random(255),math.random(255),100)

	print("color:",c.r,c.g,c.b,c.a)


	ret.onTouchBegin=function(_,x,y)
		local value=ret:touchBegin(x,y)
		ret:setBgColor( Color4f(math.random(),math.random(),math.random(),0.4))
		S_lastIndex=ret:getParentWidget():getListItemIndex(ret)
		return value
	end 
	ret:setBgEnabled(true)
	ret:setBgColor(c)


	local text=LabelTTF:create("simsun.ttc",18,string.format("Name: NosicLin\nEmail:nosiclin@foxmail.com\nNo.%d",i));
	ret:addChild(text)

	local button=PressButton:createWithDarkStyle("close.png",Color(125,125,125))

	button:setSize(40,40);
	button:setPosition(w/2-25,-h/2+25)

	button.onClick=function()
			local action=SizeAction:New{
				startSize={w=w,h=h},
				endSize={w=w,h=0.0001},
				duration=0.3,
			}

			ret:clearAction()

			S_lastIndex=ret:getParentWidget():getListItemIndex(ret)

			action.onFinish=function()
				ret:detach()
			end

			ret:doAction(action);


	end

	ret:setScissorEnabled(true)
	ret:addChild(button)

	return ret

end

function S_createListView(w,h)

	local ret=ListView:create(E_ScrollDirection.VERTICAL,w,h)

	ret:setMargin(20,20,20,20)

	--print(ret:className(),ret.setMargin,ret.setListGap)
	ret:setListGap(20)

	for i=0,200 do 

		local l=S_createListWidget(w,math.random(80)+80,i)

		if i%2== 0 then 
			ret:addListItem(l,E_AlignH.LEFT,E_AlignV.CENTER)
		elseif i%2==1 then 
			ret:addListItem(l,E_AlignH.RIGHT ,E_AlignV.CENTER)
		end

		S_UiWidget=S_UiWidget+1
	end

	ret:setAnchor(0,0)




	return ret
end

function S_createLayer()
	local ret=Layer2D:create()

	ret:setTouchEnabled(true)
	ret:setDispatchTouchEnabled(true)
	ret:setViewArea(0,0,960,640)

	ret.onUpdate=function(t,dt)
		t:update(dt)
		--print(1/dt)
	end

	local button=PressButton:createWithDarkStyle("add.png",Color(125,125,125))
	button:setSize(100,100)
	button:setPosition(100,500)


	button.onClick=function()
		print("onClick")

		local h=math.random(80)+80
		local u=S_createListWidget(400,h,S_UiWidget)
		u:doAction(SizeAction:New{
			startSize={w=400,h=0.001},
		endSize={w=400,h=h},
		duration=0.3
	})

	ret.m_listView:addListItem(S_lastIndex,u)
	S_UiWidget=S_UiWidget+1
end

ret:add(button)

return ret
end




local l=S_createLayer();



local s=Scene:create()
s:push(l)


local w=S_createListView(400,500)



l:add(w)
w:setPosition(280,100)
l.m_listView=w




share:director():run(s)


































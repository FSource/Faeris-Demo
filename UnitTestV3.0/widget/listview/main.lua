f_import("SizeAction.lua")
f_import("AnchorAction.lua")


local S_lastIndex=0

local S_UiWidget=0


function S_createListWidget(w,h,i)

	w=w-math.random(100)-40

	print("S_createListWidget")
	local ret=UiWidget:create(w,h);

	local c= Color(math.random(255),math.random(255),math.random(255),100)

	print("color:",c.r,c.g,c.b,c.a)

	local q=ColorQuad2D:create(w,h,c)
	ret:addChild(q)
	q:setTouchEnabled(true)

	f_setattrenv(q,{})

	q.onTouchBegin=function()
		q:setColor( Color(math.random(255),math.random(255),math.random(255),100))
		S_lastIndex=ret:getParentWidget():getListItemIndex(ret)
	end 



	local text=LabelTTF:create("simsun.ttc",18,string.format("Name: NosicLin\nEmail:nosiclin@foxmail.com\nNo.%d",i));
	ret:addChild(text)

	local button=PressButton:createWithDarkStyle("close.png",Color(125,125,125))

	button:setSize(40,40);
	button:setPosition(w/2-25,-h/2+25)

	f_setattrenv(button,{
		onClick=function()
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
	})


	ret:setScissorEnabled(true)
	ret:addChild(button)

	return ret

end

function S_createListView(w,h)

	local ret=ListView:create(ListView.SCROLL_VERTICAL,w,h)
	ret:setMargin(20,20,20,20)
	ret:setListGap(20)

	for i=0,100 do 
		local l=S_createListWidget(w,math.random(80)+80,i)

		if i%2== 0 then 
			ret:addListItem(l,ListView.ITEM_ALIGN_LEFT,ListView.ITEM_ALIGN_CENTER)
		elseif i%2==1 then 
			ret:addListItem(l,ListView.ITEM_ALIGN_RIGHT ,ListView.ITEM_ALIGN_CENTER)
		end

		S_UiWidget=S_UiWidget+1
	end

	local q=ColorQuad2D:create(w,h,Color(255,0,0,100))

	ret:addChild(q)
	q:setZorder(-1)

	q:setAnchor(0,0)
	ret:setAnchor(0,0)

	--[[
	ret:doAction(AnchorAction:New{
		startAnchor={w=0,h=0},
		endAnchor={w=1,h=1},
		duration=8
	})
	q:doAction (AnchorAction:New{
		startAnchor={w=0,h=0},
		endAnchor={w=1,h=1},
		duration=8
	})
	--]]



	return ret
end

function S_createLayer()
	local ret=Layer2D:create()

	ret:setViewArea(0,0,960,640)

	f_setattrenv(ret,{
		onUpdate=function(t,dt)
			t:update(dt)
			--print(1/dt)
		end
	})

	local button=PressButton:createWithDarkStyle("add.png",Color(125,125,125))
	button:setSize(100,100)
	button:setPosition(100,500)

	f_setattrenv(button,{})

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



l:setTouchEnabled(true)
l:setDispatchTouchEnabled(true)

share:director():run(s)


































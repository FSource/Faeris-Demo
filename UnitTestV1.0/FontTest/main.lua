local director =share:director();


-- create layer */
local layer= Layer2D:create();
layer.data={}

layer:setTouchEnabled(true)
layer:setDispatchTouchEnabled(true)


--[[
layer.onTouchBegin=function()
	share:scheduler():stop()
end
--]]

layer:setViewArea(0,0,1024,800)
layer:setSortMode(Layer2D.SORT_ORDER_Z)

---[[
-- test new line --
local simsun_lable20=LabelTTF:create("simsun.ttc",20,"\tMyName Is ChenLin \nBut I Have A Good Work \nI Love The World\n\nSo Many Things To Do")
simsun_lable20:setColor(Color.GREEN)
simsun_lable20:setPosition(130,430,0)


local col_q=ColorQuad2D:create()
col_q:setSize(simsun_lable20:getTextSize())
col_q:setColor(Color(125,125,255,125))
simsun_lable20:addChild(col_q)
col_q:setZorder(-1)
layer:add(simsun_lable20)

-- test size 
local simsun_lable30=LabelTTF:create("simsun.ttc",30,"\tMyName Is ChenLin \nBut I Have A Good Work \nI Love The World\n\nSo Many Things To Do")
simsun_lable30:setColor(Color.BLUE)
simsun_lable30:setPosition(330,230,0)
local col_q=ColorQuad2D:create()
col_q:setSize(simsun_lable30:getTextSize())
col_q:setColor(Color(125,125,255,125))
simsun_lable30:addChild(col_q)
col_q:setZorder(-1)

layer:add(simsun_lable30)



--- test anchor 

local simsun_lable20=LabelTTF:create("simsun.ttc",20,"\tMyName Is ChenLin \nBut I Have A Good Work \nI Love The World\n\nSo Many Things To Do")
simsun_lable20:setColor(Color.GREEN)
simsun_lable20:setPosition(230,730,0)
simsun_lable20:setAnchor(0,0)

local col_q=ColorQuad2D:create()
col_q:setSize(5,5)
col_q:setColor(Color(125,125,255,125))
simsun_lable20:addChild(col_q)
col_q:setZorder(-1)
layer:add(simsun_lable20)

local simsun_lable20=LabelTTF:create("simsun.ttc",20,"\tMyName Is ChenLin \nBut I Have A Good Work \nI Love The World\n\nSo Many Things To Do")
simsun_lable20:setColor(Color.GREEN)
simsun_lable20:setPosition(230,730,0)
simsun_lable20:setAnchor(1,1)

local col_q=ColorQuad2D:create()
col_q:setSize(5,5)
col_q:setColor(Color(125,125,255,125))
simsun_lable20:addChild(col_q)
col_q:setZorder(-1)
layer:add(simsun_lable20)


-- test bounds -- 
local simsun_lable20=LabelTTF:create("simsun.ttc",19,"My Name is ChenLin, I Work In NanShan Park, There Are So Many\n Good People Here, \nSo I'M So Exsiting")

simsun_lable20:setColor(Color.GREEN)
simsun_lable20:setPosition(530,630)
simsun_lable20:setBoundSize(400,80)

local col_q=ColorQuad2D:create()
col_q:setSize(simsun_lable20:getTextSize())
col_q:setColor(Color(125,125,255,125))
simsun_lable20:addChild(col_q)
col_q:setZorder(-1)
layer:add(simsun_lable20)

--]]



-- test align 

local simsun_lable20=LabelTTF:create("simsun.ttc",19,"My Name is ChenLin\nI Work In NanShan Park\nThere Are So Many Good People Here\nSo I'M So Exsiting")

simsun_lable20:setColor(Color.GREEN)
simsun_lable20:setPosition(430,270)
simsun_lable20:setBoundSize(200,0)
simsun_lable20:setTextAlign(FS_TEXT_ALIGN_CENTER)

local col_q=ColorQuad2D:create()
col_q:setSize(simsun_lable20:getTextSize())
col_q:setColor(Color(125,125,255,125))
simsun_lable20:addChild(col_q)
col_q:setZorder(-1)
layer:add(simsun_lable20)


local simsun_lable20=LabelTTF:create("simsun.ttc",19,"My Name is ChenLin\nI Work In NanShan Park\nThere Are So Many Good People Here\nSo I'M So Exsiting")

simsun_lable20:setColor(Color.GREEN)
simsun_lable20:setPosition(730,270)
simsun_lable20:setBoundSize(200,0)
simsun_lable20:setTextAlign(FS_TEXT_ALIGN_RIGHT)

local col_q=ColorQuad2D:create()
col_q:setSize(simsun_lable20:getTextSize())
col_q:setColor(Color(125,125,255,125))
simsun_lable20:addChild(col_q)
col_q:setZorder(-1)
layer:add(simsun_lable20)



---- some bug 

local simsun_lable20=LabelTTF:create("simsun.ttc",19,"My Name is ChenLin, I Work In NanShan Park, There Are So Many Good People Here,\nSo I'M So Exsiting")

simsun_lable20:setColor(Color.GREEN)
simsun_lable20:setPosition(530.5,30)

local col_q=ColorQuad2D:create()
col_q:setSize(simsun_lable20:getTextSize())
col_q:setColor(Color(125,125,255,125))
simsun_lable20:addChild(col_q)
col_q:setZorder(-1)
layer:add(simsun_lable20)



-- test hit2d
local simsun_lable20=LabelTTF:create("simsun.ttc",19,"My Name is ChenLin, I Work In NanShan Park, There Are So Many Good People Here,\nSo I'M So Exsiting")
simsun_lable20.data={}
simsun_lable20:setTextAlign(FS_TEXT_ALIGN_CENTER)

local time=0

simsun_lable20:setColor(Color.GREEN)
simsun_lable20:setPosition(530,120)
local col_q=ColorQuad2D:create()
col_q:setSize(simsun_lable20:getTextSize())
col_q:setColor(Color(125,125,255,125))
simsun_lable20:addChild(col_q)
col_q:setZorder(-1)

simsun_lable20.onUpdate=function(self,dt)
	time=time+dt
	self:setString(string.format("My Name is ChenLin\nI Work In NanShan Park\nNow Time Is %fs\nThere Are So Many Good People Here,\nSo I'M So Exsiting",time))
	col_q:setSize(simsun_lable20:getTextSize())
end

simsun_lable20:setTouchEnabled(true)
simsun_lable20.onTouchBegin=function(self)
	self:setColor(Color(math.random(0,255),math.random(0,255),math.random(0,255)))
end








layer:add(simsun_lable20)


scene= Scene:create()
scene:push(layer)


director:run(scene)

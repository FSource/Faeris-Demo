GAME_WIDTH=960
GAME_HEIGHT=640

tips={
	[0]="\tAttempt doesn't necessarily bring success, but giving up definitely leads to failure.",
	"\tThe best preparation for tomorrow is doing your best today.",
	"\tI don't care about other questions and I just try to be myself.",
	"\tYou are already naked. There is no reason not to follow your heart.",
	"\tThe best colour in the whole world, is the one that looks good, on you!",
	"\tEveryone has his own way of finding happiness.",
	"\tLife is a journey, one that is much better traveled with a companion by our side.",
	"\tSometimes you have to fall before you can fly.",
	"\tIf you are able to appreciate beauty in the ordinary, your life will be more vibrant.",
	"\tBe who you are, and never ever apologize for that!",
	"\tConsider the bad times as down payment for the good times. Hang in there.",
	"\tDo not pray for easy lives, pray to be stronger.",
	"\tEverybody can fly without wings when they hold on to their dreams.",
	"\tThere is no such thing as a great talent without great will power.",
	"\tI will start fresh, be someone new.",
	"\tYou can't change your situation. The only thing that you can change is how you choose to deal with it.",
	"\tWhatever is worth doing at all is worth doing well.",
	"\tPerfection is not just about control.It's also about letting go.",
	"\tDream is what makes you happy, even when you are just trying.",
}

font=FontBitmap:create("font/ch.fnt");

Note={}
Note.__index=Note

function Note:Create()
	local layer=Layer2D:create();
	layer.data={}
	layer:setViewArea(0,0,GAME_WIDTH,GAME_HEIGHT)
	setmetatable(layer.data,self)

	local bg=Quad2D:create("textures/note2.png",Rect2D(0,0,GAME_WIDTH,GAME_HEIGHT));
	local pin1=Quad2D:create("textures/pin2.png",60,60);
	local pin2=Quad2D:create("textures/pin2.png",60,60);

	local b_next=Quad2D:create("textures/next.png",120,80);
	local b_prev=Quad2D:create("textures/prev.png",120,80);


	local text_area=LabelBitmap:create(font)
	text_area:setBounds(GAME_WIDTH-200,0)
	text_area:setAlign(LabelBitmap.ALIGN_H_CENTER,LabelBitmap.ALIGN_V_BOTTOM)
	text_area:setTextAlign(LabelBitmap.TEXT_ALIGN_LEFT)

	text_area:setPosition(GAME_WIDTH/2,GAME_HEIGHT-100)

	text_area:setString(tips[0])

	local text_tip=LabelBitmap:create(font)
	text_tip:setPosition(GAME_WIDTH/2,GAME_HEIGHT-40)
	text_tip:setAlign(LabelBitmap.ALIGN_H_CENTER,LabelBitmap.ALIGN_V_BOTTOM)
	text_tip:setTextAlign(LabelBitmap.TEXT_ALIGN_LEFT)



	layer:add(text_area)
	layer:add(text_tip)


	layer:add(bg);
	bg:setZorder(-1);

	layer:add(pin1)
	pin1:setPosition(40,GAME_HEIGHT-40)

	pin1:setZorder(0);
	pin1:setRotateY(180)

	layer:add(pin2);
	pin2:setPosition(GAME_WIDTH-40,GAME_HEIGHT-40)


	layer:add(b_next)
	b_next:setPosition(GAME_WIDTH-70,60)

	layer:add(b_prev)
	b_prev:setPosition(GAME_WIDTH-200,60)
	
	layer:setSortMode(Layer2D.SORT_ORDER_Z)

	layer.m_next=b_next 
	layer.m_prev=b_prev
	layer.m_textArea=text_area
	layer.m_textTip=text_tip;

	layer.m_curIndex=0
	layer.m_maxIndex=#tips+1;
	f_utillog("#tip=%d",#tips)

	layer:setTouchEnabled(true)
	layer:UpdateButtonColor()

	return layer;
end

function Note:onTouchBegin(x,y)
	local x,y=self:toLayerCoord(x,y)
	if self.m_next:hit2D(x,y) then 
		if self.m_curIndex==self.m_maxIndex-1 then 
			return 
		end
		self.m_curIndex=self.m_curIndex+1
		self.m_textArea:setString(tips[self.m_curIndex])
	elseif self.m_prev:hit2D(x,y) then 

		if self.m_curIndex==0 then 
			return 
		end
		self.m_curIndex=self.m_curIndex-1
		self.m_textArea:setString(tips[self.m_curIndex])
	end

	self:UpdateButtonColor()
end

function Note:UpdateButtonColor()
	if self.m_curIndex==0 then 
		self.m_prev:setColor(Color(100,100,100,100));
	else 
		self.m_prev:setColor(Color(255,255,255))
	end

	if self.m_curIndex==self.m_maxIndex-1 then 
		self.m_next:setColor(Color(100,100,100,100))
	else 
		self.m_next:setColor(Color(255,255,255))
	end

	self.m_textTip:setString("tips "..(self.m_curIndex+1).."/"..self.m_maxIndex)

end












scene=Scene:create()
layer=Note:Create()

scene:push(layer);

share:director():run(scene)






-- ui bg -- 
NsJigSaw_UiBg=f_newclass()
function NsJigSaw_UiBg:New() 
	local ret=Layer2D:create()
	local bg=Quad2D:create("textures/background/default.png",Rect2D(0,0,GAME_WIDTH,GAME_HEIGHT))
	ret:setViewArea(0,0,GAME_WIDTH,GAME_HEIGHT)
	ret:add(bg)
	return ret
end

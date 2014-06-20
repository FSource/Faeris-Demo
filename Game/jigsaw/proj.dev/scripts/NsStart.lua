NsStart=f_newclass()

function NsStart:New()
	local scene=Scene:create()
	local menu_layer=NsStart_UiMenu:New()
	scene:push(menu_layer) 
	return scene 
end

GAME_HEIGHT=960 
GAME_WIDTH=640
DEFAULT_FONT="fonts/stxihei.ttf"



-- util lib --
f_import("scripts/utils/util.lua")

-- game data --
f_import("scripts/Level.lua")


-- start scene -- 
f_import("scripts/NsStart.lua")
f_import("scripts/NsStart_UiMenu.lua")



-- game core --
f_import("scripts/NsJigSaw.lua")  --scene 
f_import("scripts/NsJigSaw_UiControl.lua")   -- control layer 
f_import("scripts/NsJigSaw_UiGrid.lua")      -- play layer 
f_import("scripts/NsJigSaw_UiGoal.lua")		 -- show goal layer 
f_import("scripts/NsJigSaw_UiBg.lua") 		 -- background layer 


SN_START=NsStart:New() 
SN_JIGSAW=NsJigSaw:New()
SN_JIGSAW:SetLevel(1)

share:director():run(SN_START) 




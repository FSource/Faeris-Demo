if g_fps then 
	return 
end

W_Width=1000
W_Height=600

g_FpsLayer=Layer2D:create()
local layer=g_FpsLayer
local label=LabelTTF:create("FPS:0",font2)

label:setPosition(W_Width/2,20)
label:setColor(Color(255,0,0))
label:setScale(0.5, 0.5, 1);

label:setAlign(LabelTTF.ALIGN_H_CENTER,LabelTTF.ALIGN_V_CENTER)


local label2=LabelTTF:create("",font2)
label2:setPosition(W_Width/2,50)
label2:setColor(Color(255,0,0))
label2:setAlign(LabelTTF.ALIGN_H_CENTER,LabelTTF.ALIGN_V_CENTER)
label2:setScale(0.5, 0.5, 1);



layer:setViewArea(0,0,W_Width,W_Height)
layer:add(label)
layer:add(label2)



scheduler_target=SchedulerTarget:create()
scheduler_target.data={
	onUpdate=function(self,protity,dt)
		self.m_time=self.m_time+dt 
		self.m_count=self.m_count+1
		if self.m_time >1.0 then 
			self.m_time=self.m_time-1.0

			local scene=share:director():current()
			local entity_nu=0

			assert(share:objectMgr())

			local mgr_ob_nu=share:objectMgr():getManageObjectNu()
			local scene_ob_nu=0

			if scene then 

				local layer_nu=scene:layerNu()
				for i=0,layer_nu-1 do 
					local layer=scene:getLayer(i)
					entity_nu=entity_nu+layer:getEntityNu()
				end
				--scene_ob_nu=scene:takeObjectMgr():getManageObjectNu();
			end

			local ob_nu=FsObject:getObjectNu()
			
			self.m_label:setString("FPS:"..self.m_count.." Ety:"..entity_nu.." Obj:"..ob_nu.." SceOb:"..scene_ob_nu.." ShOb:"..mgr_ob_nu);

			--self.m_label:setString("FPS:"..self.m_count.." Ety:"..entity_nu);

			local texture_nu=share:textureMgr():getCacheResourceNu();
			local sprite_nu=share:sprite2DDataMgr():getCacheResourceNu();

			self.m_label2:setString("Texture:"..texture_nu.." SpriteData:"..sprite_nu)


			self.m_count=0
			self.m_tick=self.m_tick+1
		end

		local render=share:render();
		self.m_layer:draw(render)
	end;

	onFinalize=function(self)
		print("onFinalize fps")
		self.m_layer:decRef()
	end,

	m_label=label,
	m_layer=layer;
	m_label2=label2;
	m_time=0;
	m_count=0;
	m_tick=0;
}

share:scheduler():add(scheduler_target,Scheduler.LOW)





g_fps=true




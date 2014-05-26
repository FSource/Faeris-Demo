fLayer2D=libfs.Class("fLayer2D")


local S_Layer2DAttrFunc={

	["viewArea"]=function(self,rect)
		self:setViewArea(rect.x,rect.y,rect.width,rect.height)
	end;

	["touchEnabled"]=function(self,value)
		self:setTouchEnabled(value)
	end;

	["sortMode"]=function(self,value)
		self:setSortMode(value)
	end;
	
	["dispatchTouchEnabled"]=function(self,value)
		self:setDispatchTouchEnabled(value)
	end;


	["entity"]=function(self,value) 
		local entity={}
		for k,v in pairs(value) do 
			local e=libfs.NewFType(v)
			if e then 
				entity[k]=e 
				self:add(e)
			else 
				f_utillog("create entity failed %d",k)
			end
			--print(f_tabletostring(v))
		end
		self.f_entity=entity
	end
}


function fLayer2D:New(cfg)
	local ret=Layer2D:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	ret.f_raw=cfg

	return ret
end


function fLayer2D:Init(cfg)
	libfs.SetAttrute(S_Layer2DAttrFunc,self,cfg)
end





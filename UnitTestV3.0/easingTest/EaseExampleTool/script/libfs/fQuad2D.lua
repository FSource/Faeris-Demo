fQuad2D=libfs.Class("fQuad2D")

local S_Quad2DAttrFunc=libfs.GetAttrFuncs{
	"pos","color","zorder","scale",
	"rotate","opacity","touchEnabled","children","dispatchTouchEnabled",
	"anchor","visible","visibles","textureUrl",
}


function fQuad2D:New(cfg)

	local ret
	if cfg.new then 
		if cfg.new.size then 
			ret=Quad2D:create(cfg.new.url,cfg.new.size.width,cfg.new.size.height)
		elseif cfg.new.rect then 
			local rect=cfg.new.rect
			ret=Quad2D:create(cfg.new.url,Rect2D(rect.x,rect.y,rect.width,rect.height))
		else 
			ret=Quad2D:create(cfg.new.url)
		end
	end

	if not ret then 
		ret=Quad2D:create()
	end

	libfs.Extends(ret,self)
	ret:Init(cfg)
	ret.f_raw=cfg
	return ret

end


function fQuad2D:Init(cfg)

	libfs.SetAttrute(S_Quad2DAttrFunc,self,cfg)
	if cfg.size then 
		libfs.GetAttrFunc("size")(self,cfg.size)
	end
end
function fQuad2D:Hit2d(x, y)
	if self.f_raw.rect then
		local x1,y1 = self:getPosition()
		return IsCollided(x, y, 0, 0, x1, y1, self.f_raw.rect.width, self.f_raw.rect.height);
	else
		return self:hit2D(x, y)
	end
end
function fQuad2D:onHit2D(x, y)
	return self:Hit2d(x, y);
end




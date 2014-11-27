libfs={}
local S_libfunc=
{
	["bounds"]=function(self,b)
		self:setBounds(b.x,b.y)
	end;

	["color"]=function(self,color)
		self:setColor(color)
	end;

	["opacity"]=function(self,opacity)
		self:setOpacity(opacity)
	end;

	["textureUrl"]=function(self,v)
		self:setTexture(v)
	end;

	
	["align"]=function(self,align) 
		self:setAlign(align.h,align.v)
	end;

	["string"]=function(self,string)
		self:setString(string)
	end;

	["pos"]=function(self,pos) 
		local x=pos.x or 0
		local y=pos.y or 0
		local z=pos.z or 0
		self:setPosition(x,y,z)
	end;

	["scale"]=function(self,scale)
		local sx=scale.x or 1 
		local sy=scale.y or 1
		local sz=scale.z or 1
		self:setScale(sx,sy,sz)
	end;

	["rotate"]=function(self,rotate)
		local rx=rotate.x
		local ry=rotate.y 
		local rz=rotate.z 
		self:setRotate(rx,ry,rx)
	end;

	["zorder"]=function(self,order)
		self:setZorder(order)
	end;
	
	["touchEnabled"]=function(self,value)
		self:setTouchEnabled(value)
	end;

	["dispatchTouchEnabled"]=function(self,value)
		self:setDispatchTouchEnabled(value)
	end;


	["anim"]=function(self,v) 
		self:setAnimation(v.name)
		self:playAnimation(v.mode)
	end;

	["visible"]=function(self,v)
		self:setVisible(v)
	end;

	["visibles"]=function(self,v)
		self:setVisibles(v)
	end;
	
	["anchor"]=function(self,v)
		self:setAnchor(v.x,v.y)
	end;

	["size"]=function(self,v)
		self:setSize(v.w,v.h)
	end;

	["fontName"]=function(self,v)
		self:setFontName(v)
	end;

	["fontSize"]=function(self,v)
		self:setFontSize(v)
	end;

	["boundSize"]=function(self,v)
		self:setBoundSize(v.w,v.h)
	end;

	["lineGap"]=function(self,v)
		self:setLineGap(v)
	end;

	["textAlign"]=function(self,v)

		if v == "left" then 
			self:setTextAlign(FS_TEXT_ALIGN_LEFT)
		elseif v=="center" then 
			self:setTextAlign(FS_TEXT_ALIGN_CENTER)
		elseif v=="right" then 
			self:setTextAlign(FS_TEXT_ALIGN_RIGHT)
		end
	end;

	["children"]=function(self,children)
		self:clearChild()
		self.f_children={}
		for k,v in pairs(children) do 
			local e=libfs.NewFType(v) 
			if not e then 
				f_utillog("Create Entity Failed(%s)",k)
			end
			self:addChild(e)
			self.f_children[k]=e
		end
	end;

	["action"]=function(self,v)
		self:clearAction()
		for k,v in pairs(v) do 
			local action=libfs.Class(v.ftype):New(v)
			self:doAction(action)
		end
	end
}


function libfs.GetAttrFunc(name)
	return S_libfunc[name]
end

function libfs.GetAttrFuncs(attrs)

	local ret={}
	for k,v in ipairs(attrs) do 
		ret[v]=S_libfunc[v]
	end
	return ret

end

function libfs.SetAttrute(funcs,self,cfg)
	for k,v in pairs(cfg)  do 
		local f=funcs[k] 
		if f then 
			f(self,v)
		end
	end
end


local libfs_Classes={}

function libfs.NewFType(cfg) 

	local c=libfs_Classes[cfg.ftype] 
	if c then 
		return c:New(cfg)
	else 
		f_utillog("unkown ftype %s",tostring(cfg.ftype))
	end
	return nil

end

function libfs.Extends(v,f)
	local fclass=nil 
	if type(f) == "string" then 
		fclass = libfs_Classes[f]
	else 
		fclass=f
	end


	if type(v) == "table" then 
		setmetatable(v,fclass)
	else 
		if not v.__fdata then 
			v.__fdata={}
		end
		setmetatable(v.__fdata,fclass)
	end
end



function libfs.Class(name,base)

	if libfs_Classes[name] then 
		return libfs_Classes[name]
	end

	local ret={}
	ret.__index=ret
	libfs_Classes[name]=ret

	if base then 
		local t_base=libfs_Classes[base]
		libfs.Extends(ret,t_base)
	end

	return ret

end 

f_import("script/libfs/fQuad2D.lua")
f_import("script/libfs/fLayer2D.lua")
f_import("script/libfs/fLabelTTF.lua")
f_import("script/libfs/fButton.lua")
f_import("script/libfs/fColorQuad2D.lua")


---- old interface --- 
--
function libfs.NewQuad2D(cfg)

	local ret 

	if cfg.size then 
		ret=Quad2D:create(cfg.url,cfg.size.width,cfg.size.height)
	elseif cfg.rect then 
		ret=Quad2D:create(cfg.url,Rect2D(cfg.rect.x,cfg.rect.y,cfg.rect.width,cfg.rect.height))
	else 
		ret=Quad2D:create(cfg.url)

	end

	libfs.SetFtypeAttribute(ret,cfg)

	return ret

end

function libfs.NewLabelTTF(cfg)

	local ret=LabelTTF:create()
	libfs.SetFtypeAttribute(ret,cfg)
	return ret

end

function libfs.NewSprite(cfg) 
	local ret=Sprite2D:create(cfg.url)
	libfs.SetFtypeAttribute(ret,cfg)
	return ret
end

function  libfs.NewLabelBitmap(cfg)

	local ret=LabelBitmap:create(cfg.font)

	libfs.SetFtypeAttribute(ret,cfg)

	if cfg.string then 
		ret:setString(cfg.string)
	end
	return ret

end

function libfs.NewColorQuad2D(cfg)
	local ret

	if cfg.csize then 
		ret=ColorQuad2D:create(cfg.csize.width,cfg.csize.height,cfg.ccolor)
	elseif cfg.crect then 
		ret=ColorQuad2D:create(Rect2D(cfg.crect.x,cfg.crect.y,cfg.crect.width,cfg.crect.height),cfg.ccolor)
	else 
		ret=ColorQuad2D:create()
	end

	libfs.SetFtypeAttribute(ret,cfg)

	return ret

end



local libfs_NewEntity=
{
	["ColorQuad2D"]=libfs.NewColorQuad2D,
	["LabelBitmap"]=libfs.NewLabelBitmap,
	["LabelTTF"]=libfs.NewLabelTTF,
	["Quad2D"]=libfs.NewQuad2D,
	["Sprite2D"]=libfs.NewSprite,
}


function libfs.NewFtype(cfg) 
	return  libfs_NewEntity[cfg.ftype](cfg)
end

function libfs.SetFtypeAttribute(f,attrs)
	for k,v in pairs(attrs) do 
		local func=S_libfunc[k]
		if func then 
			func(f,v) 
		end
	end

	if attrs.event then 
		attrs.event(f)
	end

end










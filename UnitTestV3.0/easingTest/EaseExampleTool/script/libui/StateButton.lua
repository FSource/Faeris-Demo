StateButton=libfs.Class("StateButton")


local S_StateButtonPreAttrFunc=libfs.GetAttrFuncs{
	"pos","color","zorder","scale", 
	"rotate","opacity","textureUrl",
	"touchEnabled","children","dispatchTouchEnabled",
	"visible","visibles","anchor",
}

local S_StateButtonPostAttrFunc=libfs.GetAttrFuncs{
	"size"
}


function StateButton:New(cfg)

	local ret=Quad2D:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	ret.f_raw=cfg
	return ret

end

function StateButton:Init(cfg)

	libfs.SetAttrute(S_StateButtonPreAttrFunc,self,cfg)
	libfs.SetAttrute(S_StateButtonPostAttrFunc,self,cfg)

	if cfg.normal then 
		libfs.SetAttrute(S_StateButtonPreAttrFunc,self,cfg.normal)
		libfs.SetAttrute(S_StateButtonPostAttrFunc,self,cfg.normal)
	end

end

function StateButton:setState(name)

	local st=self.f_raw[name]
	if st then 
		libfs.SetAttrute(S_StateButtonPreAttrFunc,self,st)
		libfs.SetAttrute(S_StateButtonPostAttrFunc,self,st)
	end

end







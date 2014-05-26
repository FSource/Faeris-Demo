fColorQuad2D=libfs.Class("fColorQuad2D")

local S_ColorQuad2DAttrFunc=libfs.GetAttrFuncs{
	"pos","color","zorder","scale",
	"rotate","opacity","touchEnabled","children","dispatchTouchEnabled",
	"anchor","visible","visibles","size",
}

function fColorQuad2D:New(cfg)
	local ret=ColorQuad2D:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	ret.f_raw=cfg
	return ret
end


function fColorQuad2D:Init(cfg)
	libfs.SetAttrute(S_ColorQuad2DAttrFunc,self,cfg)
end





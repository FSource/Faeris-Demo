fLabelTTF=libfs.Class("fLabelTTF")

local S_LabelTTFAttrFunc=libfs.GetAttrFuncs{
	"pos","scale","rotate",
	"zorder","color","opacity","string","dispatchTouchEnabled",
	"touchEnabled","children","visible","visibles",
	"fontSize","fontName","anchor","boundSize","lineGap",
}


function fLabelTTF:New(cfg)

	local ret=LabelTTF:create()
	libfs.Extends(ret,self)
	ret:Init(cfg)
	ret.f_raw=cfg
	return ret

end

function fLabelTTF:Init(cfg)
	libfs.SetAttrute(S_LabelTTFAttrFunc,self,cfg)
end





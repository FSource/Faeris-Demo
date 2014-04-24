BuyPayment=f_newclass("BuyPayment")


function BuyPayment:New(cfg)
	local ret=Payment:getInstance()

	f_extends(ret,self)
	ret:Init(cfg)
	return ret
end

function BuyPayment:Init(cfg)
	local pay_info=nil

	if FS_CUR_PLATFORM == FS_PLATFORM_ANDROID then 
		local env_pay=f_getenv("payconfig") 
		if env_pay == "mm" then 
			pay_info=cfg.mm 
		elseif env_pay == "egame" then 
			pay_info=cfg.egame 
		elseif env_pay == "unicom" then 
			pay_info=cfg.unicom 
		elseif env_pay == "ihuizhi" then 
			pay_info=cfg.ihuizhi 
		else 
			pay_info=cfg.ihuizhi 
		end
	else 
		pay_info=cfg.fake 
	end


	self:setConfig(cjson.encode(pay_info))
	self.m_paycodes=pay_info.paycodes

	self.m_pends={}
end


function BuyPayment:Billing(name,cfg)

	local paycode=self.m_paycodes[name]
	if not paycode then 
		cfg.onError( {msg="paycodes Not Set"})
		return
	end

	local msg={}

	for k,v in pairs(paycode) do 
		msg[k]=v 
	end

	if cfg.param then 
		for k,v in pairs(cfg.param) do 
			msg[k]=v 
		end
	end

	local trade_id=self:billing(name,cjson.encode(msg))
	self.m_pends[trade_id]=cfg

end

function BuyPayment:onBillingFinish(trade_id,ret_code,msg)
	local cfg=self.m_pends[trade_id]
	self.m_pends[trade_id]=nil

	local t_msg=cjson.decode(msg)

	if ret_code==FS_PAYMENT_SUCCESS then 
		cfg.onSuccess(t_msg)
	elseif ret_code==FS_PAYMENT_FAILED then 
		cfg.onFailed(t_msg)
	elseif ret_code==FS_PAYMENT_CANCEL then 
		cfg.onCancel(t_msg)
	else 
		cfg.onError(t_msg)
	end

end








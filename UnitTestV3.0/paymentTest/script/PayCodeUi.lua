PayCodeUi=f_newclass("PayCodeUi")

function PayCodeUi:New()

	local ret=Layer2D:create()
	f_extends(ret,self)
	ret:Init()
	return ret

end



function PayCodeUi:Init()

	self:setViewArea(0,0,1000,600)
	self:setTouchEnabled(true)
	self:setDispatchTouchEnabled(true);

	self:InitPaycodes()
end


function PayCodeUi:InitPaycodes()

	local paycodes={
		{
			name="revive",
			description="复活",
			image="image/revive.png",
		},

		{
			name="diamond50",
			description="50钻石",
			image="image/diamond50.png"
		},
		{
			name="diamond150",
			description="150钻石",
			image="image/diamond150.png"
		},
		{
			name="diamond300",
			description="300钻石",
			image="image/diamond300.png"
		},
		{
			name="diamond600",
			description="600钻石",
			image="image/diamond600.png"
		},
	}


	local y=300 
	local start_x=200 
	local step_x=100

	for k,v in ipairs(paycodes) do 

		local buttons=Quad2D:create(v.image)
		f_setattrenv(buttons,{})

		buttons:setPosition(start_x+step_x*k,y)
		buttons:setTouchEnabled(true)

		self:add(buttons)

		buttons.onTouchBegin=function()

			buttons:setColor(Color(100,100,100))
			return true
		end
	


		buttons.onTouchEnd=function()

			buttons:setColor(Color.WHITE)

			g_Payment:Billing(v.name,{
				param={
					["uid"]=5,
				},

				onSuccess=function(msg)
					self:ShowPayResult(v.description,"成功"..msg.msg)
				end,

				onFailed=function(msg)
					self:ShowPayResult(v.description,"失败"..msg.msg)
				end,

				onCancel=function(msg)
					self:ShowPayResult(v.description,"取消"..msg.msg)
				end,

				onError=function(msg)
					self:ShowPayResult(v.description,"错误"..msg.msg)
				end,
			})
		end
	end

end



function PayCodeUi:ShowPayResult(description,result)
	local text_label=ResultText:New("购买"..description..result)
	self:add(text_label)
end



















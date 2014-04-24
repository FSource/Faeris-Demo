g_PaymentCfg={
	fake={
		paycodes={
			["revive"]={
				["result"]="success",
				["description"]="复活",
				["money"]=5
			},
			["diamond50"]={
				["result"]="cancel",
				["description"]="50钻石",
				["money"]=5,
			},
			["diamond150"]={
				["result"]="failed",
				["description"]="150钻石",
				["money"]=10,
			},
			["diamond300"]={
				["result"]="error",
				["description"]="300钻石",
				["money"]=20,
			},
			["diamond600"]={
				["result"]="success",
				["description"]="600钻石",
				["money"]=30,
			},
		}
	},

	mm={

		appid="300008181347",
		appkey="0D248303638D8568",
		paycodes={
			["revive"]={
				code="30000818134701",
				description="复活",
				money=5,
				value=1,
				extdata="",
			},
			["diamond50"]={
				code="30000818134702",
				description="50钻石",
				money=5,
				value=1,
				extdata="",
			},
			["diamond150"]={
				code="30000818134703",
				description="150钻石",
				money=10,
				value=1,
				extdata="",
			},
			["diamond300"]={
				code="30000818134704",
				description="300钻石",
				money=20,
				value=1,
				extdata="",
			}
		}
	},


	egame={

	},

	unicom={
		appId="908433415520140225151920986100",
		cpCode="9084334155",
		cpId="86007664",
		key="dc513ea4fbdaa7a14786",
		company="深圳市融网汇智科技有限公司",
		game="跑酷大师",
		--phone="400-8676979"
		phone="0755-86329809",
		url="http://uniview.wostore.cn/log-app/test",

		paycodes={
			["revive"]={
				isVac=true,
				isSms=true,
				isOtherpay=true,
				url="http://www.baidu.com",
				vacCode="140408031617",
				customCode="908433415520140225151920986100001",
				props="复活",
				money="5",
				uid="paypal",
				vacMode="single",
				url="http://uniview.wostore.cn/log-app/test",
			},

			["diamond50"]={
				isVac=true,
				isOtherpay=true,
				isSms=true,
				url="http://www.baidu.com",
				vacCode="140408031618",
				customCode="908433415520140225151920986100002",
				props="50钻石",
				money="5",
				uid="paypal",
				vacMode="single",
				url="http://uniview.wostore.cn/log-app/test",
			},
			["diamond150"]={
				isVac=true,
				isOtherpay=true,
				isSms=true,
				url="http://www.baidu.com",
				vacCode="140408031619",
				customCode="908433415520140225151920986100003",
				props="150钻石",
				money="10",
				uid="paypal",
				vacMode="single",
				url="http://uniview.wostore.cn/log-app/test",
			},
			["diamond300"]={
				isVac=true,
				isOtherpay=true,
				isSms=true,
				vacCode="140408031620",
				customCode="908433415520140225151920986100004",
				url="http://www.baidu.com",
				props="300钻石",
				money="20",
				uid="paypal",
				vacMode="single",
				url="http://uniview.wostore.cn/log-app/test",
			},

			["diamond720"]={
				isVac=true,
				isOtherpay=true,
				isSms=false,
				url="http://www.baidu.com",
				vacCode="140408031621",
				customCode="908433415520140225151920986100005",
				props="720钻石",
				money="40",
				uid="paypal",
				vacMode="single",
				url="http://uniview.wostore.cn/log-app/test",
			},
			["diamond900"]={
				isVac=true,
				isOtherpay=true,
				isSms=false,
				url="http://www.baidu.com",
				vacCode="140408031622",
				customCode="908433415520140225151920986100006",
				props="900钻石",
				money="50",
				uid="paypal",
				vacMode="single",
				url="http://uniview.wostore.cn/log-app/test",
			},

			["diamond1800"]={
				isVac=true,
				isOtherpay=true,
				isSms=false,
				url="http://www.baidu.com",
				vacCode="140408031623",
				customCode="908433415520140225151920986100007",
				props="1800钻石",
				money="90",
				uid="paypal",
				vacMode="single",
				url="http://uniview.wostore.cn/log-app/test",
			},
		}

	},

	ihuizhi={

		["revive"]={

			tradeName="复活",
			tradeDesc="复活",
			money="5",
			mode="sms",
			extInfo="111111111111111",
			itemId="10010",
			playerId=300,
			channel=40,
			url="http::www.baidu.com",
			tradeId="xxx"
		},

		["diamond50"]={
			tradeName="50钻石",
			tradeDesc="购买50钻石",
			money="5",
			mode="sms",
			extInfo="11111",
			itemId="10011",
		},

		["diamond150"]={
			tradeName="150钻石",
			tradeDesc="购买150钻石",
			money="10",
			mode="sms",
			extInfo="11111",
			itemId="10012",

		},

		["diamond300"]={
			tradeName="300钻石",
			tradeDesc="购买300钻石",
			money="20",
			mode="sms",
			extInfo="11",
			itemId="10013",
		},

		["diamond720"]={
			tradeName="720钻石",
			tradeDesc="购买720钻石",
			money="40",
			mode="otherpay",
			extInfo="",
			itemId="006",
		},

		["diamond900"]={
			tradeName="900钻石",
			tradeDesc="购买900钻石",
			money="50",
			mode="otherpay",
			extInfo="",
			itemId="006",
		},

		["diamond1800"]={
			tradeName="1800钻石",
			tradeDesc="购买1800钻石",
			money="90",
			mode="otherpay",
			extInfo="",
			itemId="006",
		}

	},

}




for i=1,100 do
	http=HttpEngine:create()
end 


request=HttpRequest:create()
request:setUrl("www.baidu.com")

request.data={                      
	onReponse=function(self,code,data,err) 
		--print("data"..data)
		f_log("reponse:"..code);
		--f_utillog("code=%d,data=%s,err=%s",code,data,err);
		scene=Scene:create();
		layer=Layer2D:create()
		layer:setViewArea(0,0,960,640)
		quad=Quad2D:create(Color(255,0,0),150,150)
		quad:setPosition(480,320)
		layer:add(quad)
		scene:push(layer)
		share:director():run(scene)
	end
}

f_log("send request");

http:send(request)


-- Copyright (C) Allen.L, CloudFlare Inc. \last Modified 2017-11-06 10:03:35
-- 


local dataVo =Object()

function dataVo:ctor(x)
	ngx.say("dataVo ctor")
	self.req = x
end

function dataVo:print1()
	ngx.say(self.req)
end

function dataVo:say()
	ngx.say("hello dataVo")
end

return dataVo








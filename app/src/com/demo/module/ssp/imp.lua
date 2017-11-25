

local dataVo = require("com.demo.moudle.ssp.dataVo")

local imp = Object(dataVo)

function imp:ctor()
	ngx.say("imp ctor")
end

function imp:say()
	ngx.say("hellp imp")
end

return imp

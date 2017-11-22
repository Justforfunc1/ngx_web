-- Copyright (C) Allen.L, CloudFlare Inc. \last Modified 2017-11-08 14:30:51
--

local _M = {}


local datavo = require("com.demo.service.ssp.dataVo")

function _M.bigRequest(request,response)
	local name = request:get_arg("data")
	name = cjson.decode(name)
	datavo:Value(datavo.imp)
	ngx.exit(200)
	_.map(datavo.req, function(k,v)
		response:write(k)
		response:writeln("  "..v)
	end)

end

return _M


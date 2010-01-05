--[[
	Controller基类
	实现统一接口
--]]

local baseController = Object()

--提取参数
local function extractParam(request)
	local params = {}
	local arg = request.uri_args 
	 _.each(arg, function(k,v)
			params[k] = v
    end)
	return params
end

--参数检查
local function validateParam(params)
	if _.isEmpty(params) then
		return false,"params is error"
	end
	return true,params
end


--初始化构造
function baseController:init(request,response)
	self.request = request
	self.response = response
	self.parameters = ""
end

function baseController:before(request)
	local ok, err = validateParam(extractParam(request))
	if ok then
		self.parameters = err
	end
	return err
end

--设置返回头信息
function baseController:setHeader(key,value)
	self.response:set_header(key, value)
end


function baseController:message()
end


function baseController:getMsg()
	ngx.say(cjson.encode({code = -100, msg = "error"}))
	ngx.exit(200)
end


function baseController:after()
end


return baseController
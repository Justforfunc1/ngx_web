--[[
	validate 解析模块，默认路径：APP_PATH/config/param.lua
	与其他模块的写法方式不一致
	推荐使用这种写法，更加方便不需要添加模块名进行内部调用
--]]

local _M = {}
local util_file = require("util.file")
local controller = "controller"
local method = "action"
local param = "param"

--对应控制器的参数列表
local function check(tab,key1,key2)
	local t = tab or {}
	local k1 = key1 or ""
	local k2 = key2 or ""
	local val = {}
	for k,v in pairs(t) do
		if v[k2] == k1 then
			val = t[k]
		end
	end
	return val
end

--获取参数配置文件
local function getCtrlConfig(ctrl,default_v)
	local app_validate = panshi_cache.get("app_validate")
	if app_validate then
		return check(app_validate,ctrl,controller) or default_v
	end
	local validate_file = ngx.var.APP_PATH .. "/config/param.lua"
	app_validate = util_file.loadlua_nested(validate_file) or {}
	panshi_cache.set("app_validate", app_validate)
	return check(app_validate,ctrl,controller) or default_v
end

--
local function validateConfig(ctrl,action)
	local val = getCtrlConfig(ctrl)
	if _.isEmpty(val) then
		return false,string.format("validate controller [%s] no config !", ctrl)
	end
	local params = {}
	for k,v in pairs(val[method]) do
		if v == action then
			params = val[param][k]
		end
	end
	if _.isEmpty(params) then
		return false,string.format("validate method [%s] no config !", action)
	end
	return true,params
end

_M = {
	getCtrlConfig = getCtrlConfig,
	validateConfig = validateConfig
}

return _M
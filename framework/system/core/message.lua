--[[
消息模块，默认路径：APP_PATH/config/msg.lua
--]]

local _M = {}

local util_file = require("util.file")

function _M.getMsgConfig(k, default_v)
	local app_msg = panshi_cache.get("app_msg")
	if app_msg then
		return app_msg[k] or default_v
	end
	local msg_file = ngx.var.APP_PATH .. "/config/msg.lua"
	app_msg = util_file.loadlua_nested(msg_file) or {}
	panshi_cache.set("app_msg", app_msg)
	return app_msg[k] or default_v
end

function _M.getMsg(k, ...)
	local val = getMsgConfig(k)
	if _.isEmpty(val) then
		return string.format("msg %s not config.", k)
	end
	local tab = { ... }
	local path = k
	for i, v in ipairs(tab) do
		val = val[v]
		path = path .. "[\"" .. v .. "\"]"
		if _.isEmpty(val) then
			return string.format("msg %s not config.", path)
		end
	end
	return val
end

return _M
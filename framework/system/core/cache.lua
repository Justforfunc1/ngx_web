--[[
缓存模块，使用全局变量“PANSHI_C”存储；
“PANSHI_C”在ngx_lua的“init_by_lua_file”指令执行文件“panshi_init.lua”中进行初始化。
为支持多应用，缓存存储在PANSHI_C[app_name]中，需要在nginx配置文件中定义应用名称：APP_NAME。
--]]

local _M = {}

--全局变量
function _M.get(k, default_v)
	local app_name = ngx.var.APP_NAME
	if not PANSHI_C[app_name] then
		return default_v
	end
	return PANSHI_C[app_name][k] or default_v
end

function _M.set(k, v)
	local app_name = ngx.var.APP_NAME
	if not PANSHI_C[app_name] then
		PANSHI_C[app_name] = {}
	end
	PANSHI_C[app_name][k] = v
end

function setG(k, v)
	PANSHI_G[k] = v
end

--共享内存
local shareCache = ngx.shared.cache

function _M.getShare(k, default_v)
	local key = ngx.var.APP_NAME .. k
	local cache = shareCache:get(key)
	if not cache then
		return default_v
	end
	return cache
end

function _M.setShare(k, v)
	local key = ngx.var.APP_NAME .. k
	shareCache:set(key, v)
end

return _M
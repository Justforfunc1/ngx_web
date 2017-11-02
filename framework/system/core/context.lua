--[[
上下文模块,主要涉及路由和bean应用工厂
--]]
local _M = {}

local src_path = "/src/?.lua"
local route_file = "/config/route.lua"
local bean_file = "/config/bean.lua"

function _M.init_pkg_path()
	local pkg_path_init = panshi_cache.get("pkg_path_init")
	if pkg_path_init then
		return
	end
	package.path = package.path .. ";" .. ngx.var.APP_PATH .. src_path
	panshi_cache.set("pkg_path_init", true)
end

function _M.getRoute()
	local route = panshi_cache.get("route")
	if route then
		return route
	end
	local Route = require("core.route")
	route = Route(ngx.var.APP_PATH .. route_file)
	panshi_cache.set("route", route)
	return route
end

function _M.getBeanFactory()
	local beanFactory = panshi_cache.get("beanFactory")
	if beanFactory then
		return beanFactory
	end
	local BeanFactory = require("core.beanfactory")
	beanFactory = BeanFactory(ngx.var.APP_PATH .. bean_file)
	panshi_cache.set("beanFactory", beanFactory)
	return beanFactory
end

return _M
--[[
	测试
	用户信息服务
--]]

local userService = Object(panshi_service)
local tab_util = require("util.table")
--local beanFactory= panshi_context.getBeanFactory()
--local user = beanFactory:getBean("userInfo")
local user_info = require("com.demo.module.test.userInfo")
local app_user = require("com.demo.module.test.appUser")
local app_register = require("util.uuid")

function userService:init()
	self.service_name = "user_service"
	self.user_info = user_info.new("test", "user_info", "id")
	self.app_user = app_user.new("test", "app_user", "uid")
end

function userService:getUserByKey(key)
	local result = self.user_info:loadByKey(key)
	return self:render(result)
end

function userService:putUserInfo(data)
	local result = self.user_info:save(data)
	return self:render(result)
end

function userService:updateUserInfo(data,where)
	local result = self.user_info:update(data,where)
	return self:render(result)
end

function userService:accountRegistration()
	local appid,appkey = app_register.accountRegistration()
	local data = {id = '', uid = appid, key = appkey, stat = 1}
	local result = self.app_user:save(data)
	return self:render(result)
end

return userService

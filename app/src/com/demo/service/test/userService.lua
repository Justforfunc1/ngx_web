--[[
	测试
	用户信息服务
--]]

local userService = Object(panshi_service)
local tab_util = require("util.table")
--local beanFactory= panshi_context.getBeanFactory()
--local user = beanFactory:getBean("userInfo")
local user_info = require("com.demo.module.test.userInfo")

function userService:init()
	self.service_name = "user_service"
	self.user = user_info.new("test", "user_info", "id")
end

function userService:getUserByKey(key)
	local result = self.user:loadByKey(key)
	return self:render(result)
end

function userService:putUserInfo(data)
	local result = self.user:save(data)
	return self:render(result)
end

function userService:updateUserInfo(data,where)
	local result = self.user:update(data,where)
	return self:render(result)
end


return userService

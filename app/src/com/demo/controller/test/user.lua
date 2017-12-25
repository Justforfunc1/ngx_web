--[[
	测试
	user 控制器
--]]
local user = Object(panshi_controller)
local userService = require("com.demo.service.test.userService")
local tab_util = require("util.table")

function user:init()
	self.userService = userService:new()
end


function user:getUserByKey()
	local key = self.parameters.key
	local result = self.userService:getUserByKey(key)
	self:message(result.code,result.result)
end

function user:putUserInfo()
	local params = self.parameters
	local data = {id = params.id or "", name = params.name, age = params.age}
	local result = self.userService:putUserInfo(data)
	self:message(result.code,result.result)
end

function user:updateUserInfo()
	local params = self.parameters
	local set = {name = params.name}
	local where = {id = params.id}
	local result = self.userService:updateUserInfo(set,where)
	self:message(result.code,result.result)
end

function user:accountRegistration()
	local result = self.userService:accountRegistration()
	self:message(result.code,result.result)
end

function user:checkAppUser()
	local result = self.userService:checkAppUser()
	self:message(result.code,result.result)
end

return user
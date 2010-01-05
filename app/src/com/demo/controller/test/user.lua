--[[
	测试
	user 控制器
--]]
local user = Object(panshi_controller)
local userService = require("com.demo.service.test.userService")

function user:init()
	self.userService = userService:new()
end


function user:getUserByKey()
	local params = self.parameters
	local result = self.userService:getUserByKey(params.key)
	self:setHeader("Content-Type","text/json; charset=UTF-8")
    self.response:writeln(cjson.encode(result))
end

function user:putUserInfo()
	local params = self:extractParam()
	local data = {id = params.c or "", name = params.a, age = params.b}
	local result = self.userService:putUserInfo(data)
	self:setHeader("Content-Type","text/json; charset=UTF-8")
    self.response:writeln(cjson.encode(result))
end

function user:updateUserInfo()
	local params = self:extractParam()
	local set = {name = params.a}
	local where = {id = params.b}
	local result = self.userService:updateUserInfo(set,where)
	self:setHeader("Content-Type","text/json; charset=UTF-8")
    self.response:writeln(cjson.encode(result))
end


return user
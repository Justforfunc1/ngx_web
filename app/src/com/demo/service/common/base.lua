--[[
	服务层基类
--]]

local baseService = Object()

local function baseService:ctor()
	self.type = 0
	self.provider = ''
	self.operatorId = 0
	self.clientip = ''
	self.systemId = 0
end

--授权验证
local function check()
end

--异常
local function baseService:repleyException()
end

--正常
local function baseService:repleyOK()
end

--返回消息
local function baseService:repleyMessage()
end

--返回数据
local function baseService:repleyData()
end

--返回数据过滤
local function baseService:filterFiled()
end





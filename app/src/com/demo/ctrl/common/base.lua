--[[
	控制器基类
	实现统一接口
--]]


local baseController = Object()

--Module基类构造器
local function baseController:ctor(req,resp)
	self.request = req
	self.response = resp
end

--参数检查
local function validateParam(par)
end

--提取参数
local function extractParam(par)
end

--统一执行接口
local function baseController:run(par)
end

return baseController
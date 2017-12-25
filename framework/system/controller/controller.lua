--[[
	Controller基类
	实现统一接口
--]]

local baseController = Object()
local tab_util = require("util.table")


--初始化构造
function baseController:init(request,response)
	self.request = request
	self.response = response
	self.parameters = ""
end

--table参数
--@param [par:上传参数] 
--@param [cfg:validate配置参数]
local function g(par,cfg)
	if not _.isTable(par) or not _.isTable(cfg) then
		return false
	end
	for k,v in pairs(cfg) do
		for k1,v1 in pairs(par) do
			if v.param_type == "number" and k1 == k then
				par[k1] = tonumber(v1)
			elseif v.param_type == "string" and k1 == k then
				par[k1] = tostring(v1)
			elseif v.param_type == "table" and k1 == k then
				g(par[k1],cfg[k])
			else
				par[k1] = v1
			end
		end
	end
	return true
end

--提取参数列表中必要参数 注：若参数列表中must字段未配置默认为必须
local function e(list)
	if _.isEmpty(list) or not _.isTable(list) then
		return false
	end
	local val = {}
	local cfg = {}
	
	--获取参数列表数据段
	for k,v in pairs(list) do
		if v.must or v.must == nil then
			if v.param_type == "json" then
				cfg = list.data.table
			else
				cfg = list
			end
		end
	end
	
	--提取关键参数
	local extract
	extract = function(cfg,val)
		for k,v in pairs(cfg) do
			if v.must or v.must == nil then
				if v.param_type == "table" then
					val[k] = {}
					extract(v.table,val[k])
				else
					table.insert(val,k)
				end
			end
		end
	end

	extract(cfg,val)
	return val
end

--必要参数检查
local function c(tab,list)
	if not _.isTable(tab) or _.isEmpty(tab) then
		return false,"check null params exception!"
	end
	
	local err = {}
	local f
	f = function(t,l,a)
		for k,v in pairs(l) do
			if _.isTable(v) then
				a[k] = {}
				f(t[k],v,a[k])
				if _.isEmpty(a[k]) then
					a[k] = nil
				end
			else
				if _.isEmpty(t[v]) then
					a[v] = ''
				end
			end
		end
	end
	f(tab,list,err)

	if not _.isEmpty(err) then
		return false,err
	end
	return true		
end

--参数验证
local function validateParam(self,par)
	local param = par or {}
	local val = {}

	--参数类型转换
	for k,v in pairs(param) do
		if v.param_type == "number" then
			val[k] = tonumber(self.request:get_arg(v.name))
		elseif v.param_type == "string" then
			val[k] = tostring(self.request:get_arg(v.name))
		elseif v.param_type == "table" then
			g(self.request:get_arg(v.name),v.table)
		elseif v.param_type == "json" then
			local status,args = pcall(cjson.decode, self.request:get_arg(v.name))
			if not status then 
				return false,args
			end
			if g(args,v.table) then
				val = args
			end
		else
			val[k] = self.request:get_arg(v.name)
		end
	end
	
	if _.isEmpty(val) then
		return false,"the request no params !"
	else
		local par_list = e(par)		--提取必要参数
		local status,args = c(val, par_list)	--参数验证
		if not status then
			return false,cjson.encode(args)
		end
	end
	
	self.parameters = val	--参数初始化
	return true
end

--控制器before
function baseController:before(ctrl,action)
	local ok,val = panshi_validate.validateConfig(ctrl,action)
	if not ok then
		return false,val
	end
	ok, val = validateParam(self,val)
	if not ok then
		return false,val
	end
	return true
end

--控制器after
function baseController:after(code,data)
	self:setHeader("Content-Type","text/json; charset=UTF-8")
	self.response:writeln(cjson.encode({
		code = code,
		result = data
	}))
end

--设置返回头信息
function baseController:setHeader(key,value)
	self.response:set_header(key, value)
end

--消息返回
function baseController:message(code,data)
	self:after(code,data)
end

--获取消息
function baseController:getMsg(k, ...)
	return panshi_msg.getMsg(k, ...)
end

return baseController
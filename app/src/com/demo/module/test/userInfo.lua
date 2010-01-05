--[[
	测试
	user模块
--]]

local userInfo = Object(panshi_module)
local tab_util = require("util.table")
--local userInfo = Class1(panshi_module)

--构造器
function userInfo:init(name,table,key)
	self.name = name
	self.table = table
	self.key = key
end

--根据key获取数据
function userInfo:loadByKey(key)
	local k = self.key.." = "..key
	return self:s(self.table, k)
end

--保存单表数据
function userInfo:save(data)
	local str = ""
	if _.isEmpty(data.id) then
		str = "\"%s\", \"%s\", %d"
	else
		str = "%d, \"%s\", %d"
	end
	local v = string.format(str,data.id,data.name,data.age)
	return self:i(self.table, v)
end

--更新单表数据
function userInfo:update(data, where)
	return self:u(self.table, tab_util.tab_to_str(data), tab_util.tab_to_str(where))
end

--根据查询列表获取数据
--[[
	sql参数表
	params_table = { 
			operation = "", 
			table = "", 
			fileds = "", 
			set = "",
			where = "", 
			orderby = "", 
			limit = "" 
		} 
--]]
function userInfo:listByWhere(fileds, where, orderby, limit)
	local params_table = { 
		operation = 1, 
		table = self.table, 
		fileds = fileds,
		where = tab_util.tab_to_str(where, " and "), 
		orderby = orderby, 
		limit = limit 
	}
	local sql = self:compileSql(params_table)
	return self.dataBase.query(self.db, sql)
end

return userInfo




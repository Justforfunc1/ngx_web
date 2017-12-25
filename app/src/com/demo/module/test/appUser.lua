--[[
	app_user模块
	用户注册
	用户权限验证
--]]

local app_user = Object(panshi_module)
local tab_util = require("util.table")


--构造器
function app_user:init(name,table,key)
	self.name = name
	self.table = table
	self.key = key
end

--根据key获取数据
function app_user:loadByKey(key)
	local k = self.key.." = "..key
	return self:s(self.table, k)
end

--保存单表数据
function app_user:save(data)
	local str = ""
	if _.isEmpty(data.id) then
		str = "\"%s\", %d, \"%s\", %d"
	else
		str = "%d, %d, \"%s\", %d"
	end
	local v = string.format(str,data.id,data.uid,data.key,data.stat)
	return self:i(self.table, v)
end

--更新单表数据
function app_user:update(data, where)
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
function app_user:listByWhere(fileds, where, orderby, limit)
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

function app_user:getUserKey(key)
	local db = self.dataBase.instance("redis")
	local redis = self.dataBase.getConnect(db)
	local res = redis:hgetall(key);
    local userinfo = tab_util.array_to_hash(res)
	self.dataBase.close(db,redis)
	return userinfo
end

function app_user:setUserKey(key,data)
	local db = self.dataBase.instance("redis")
	local redis = self.dataBase.getConnect(db)
	local res = redis:hmset(key .. data);
	self.dataBase.close(db,redis)
	return userinfo
end

return app_user
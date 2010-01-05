--[[
	Module基类
--]]

local baseModule = Object()
local dataBase = require("db.database")

--构造函数
function baseModule:init(name)
	self.name = name or "test"
	self.dataBase = dataBase
	self.db = self.dataBase.instance(self.name)
end

--获取系统db
function baseModule:getSystemDB()
	return self.dataBase.instance(self.name)
end

--根据主键获取数据
function baseModule:s(table,key)
	return self.dataBase.s(table, key, self.db)
end

--保存单表数据
function baseModule:i(table,data)
	return self.dataBase.i(table, data, self.db)
end

--更新单表数据
function baseModule:u(table,data,where)
	return self.dataBase.u(table, data, where, self.db)
end

--多条件更新
function baseModule:uByWhere(table,set,where)
	return self.dataBase.uByWhere(table, set, where, self.db)
end

--生成sql语句
function baseModule:compileSql(params_table)
	return self.dataBase.compileSql(params_table)
end

--[[
	基类抽象接口
--]]

--根据key获取数据
function baseModule:loadByKey(key)
end

--保持数据
function baseModule:save(data)
end

--更新数据
function baseModule:update(key,data)
end

--根据查询列表获取数据
function baseModule:listByWhere(params_table)
end

return baseModule


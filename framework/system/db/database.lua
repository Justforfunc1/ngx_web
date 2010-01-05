--[[
	DAO数据服务层
--]]

local dataBase = Class("db.database")
local sql_util = require("util.sql")

--sql命令集
local commands = {
		"select",
		"update",
		"insert",
		"delete"
	}

--sql操作标识
dataBase.operation = {
		select = 1,
		update = 2,
		insert = 3,
		delete = 4
	}


--获取系统db
function dataBase.instance(name)
	local db_name = name or 'test'
	local beanFactory = panshi_context.getBeanFactory()
    local mysql = beanFactory:getBean(db_name)
	return mysql
end

--获取数据库conn
function dataBase.getConnect(db)
	if _.isEmpty(db) then
		ngx.log(logger.w(""))
		return false
	end
	local conn = db:getConnect()
	if not conn then
        error("the mysql is connection fail!")
    end
	return conn
end

--关闭DB连接
function dataBase.close(db,conn)
	if _.isEmpty(db) or _.isEmpty(conn) then
		return false
	end
	return db:close(conn)
end

--执行query
function dataBase.query(db,sql)
	if _.isEmpty(db) or _.isEmpty(sql) then
		return false
	end
	local conn = dataBase.getConnect(db)
	local res, err, errno, sqlstate = conn:query(sql)
	db:close(conn)
	return {
		sql = sql, 
		res = res, 
		err = err, 
		errno = errno, 
		sqlstate = sqlstate
	}
end

--事务提交
function dataBase.queryTransaction(db,sqlArray)
	if _.isEmpty(db) or _.isEmpty(sqlArray) then
		return false
	end
	local result_table = db:queryTransaction(sqlArray)
	return result_table
end

--根据主键查询单表信息
function dataBase.s(table, where, db)
	if _.isEmpty(table) or _.isEmpty(where) or _.isEmpty(db) then
		return false
	end
	local sql_table = {
        sql = [[
            select * from ${table}
            @{where}
            limit 1
        ]],
        where = {
            "${where}"
        }
	}	
	local data = { table = table, where = where}
	local sql = sql_util.getsql(sql_table, data)
	local conn = db:getConnect()
    if not conn then
        error("the mysql is connection fail!")
    end
    local res, err, errno, sqlstate = conn:query(sql)
	db:close(conn)
	return {
		sql = sql, 
		res = res, 
		err = err, 
		errno = errno, 
		sqlstate = sqlstate
	}
end

--保存单表数据
function dataBase.i(table,data,db)
	if _.isEmpty(table) or _.isEmpty(data) or _.isEmpty(db) then
		return false
	end
	local sql_table = {
        sql = [[
            insert into ${table}
            values (${values})
        ]]
    }
	local data = { table = table, values = data}
	local sql = sql_util.getsql(sql_table, data)
	local conn = db:getConnect()
    if not conn then
        error("the mysql is connection fail!")
    end
    local res, err, errno, sqlstate = conn:query(sql)
	db:close(conn)
	return {
		sql = sql, 
		res = res, 
		err = err, 
		errno = errno, 
		sqlstate = sqlstate
	}
end

--更新单表数据
function dataBase.u(table,data,where,db)
	if _.isEmpty(table) or _.isEmpty(data) or _.isEmpty(where) or _.isEmpty(db) then
		return false
	end
	local sql_table = {
        sql = [[
            update ${table}
            @{set} @{where}	
        ]],
        set = {
            "${set}"
        },
		where = {
			"${where}"
		}
    }
	local data = { table = table, set = data, where = where}
	local sql = sql_util.getsql(sql_table, data)
	local conn = db:getConnect()
    if not conn then
        error("the mysql is connection fail!")
    end
    local res, err, errno, sqlstate = conn:query(sql)
	db:close(conn)
	return {
		sql = sql, 
		res = res, 
		err = err, 
		errno = errno, 
		sqlstate = sqlstate
	}
end


--多条件更新
function dataBase.uByWhere(table,set,where,db)
	if _.isEmpty(table) or _.isEmpty(set) or _.isEmpty(where) or _.isEmpty(db) then
		return false
	end
	
	local sql_table = {
        sql = [[
            update ${table}
            @{set} @{where}
        ]],
		
        set = {
            "${set}"
        },
		where = {
			"${where}"
		}
    }

	local data = { table = table, set = set, where = where}
	local sql = sql_util.getsql(sql_table, data)
	local conn = db:getConnect()
    if not conn then
        error("the mysql is connection fail!")
    end
    local res, err, errno, sqlstate = conn:query(sql)
	db:close(conn)
	return {
		sql = sql, 
		res = res, 
		err = err, 
		errno = errno, 
		sqlstate = sqlstate
	}
end


--sql_table 构造函数
local function sql_table_ctor(param)
	local sql_table = {}
	local data = {}
	local sql = [[ ${operation} ]]
	
	if not _.isEmpty(param.operation) then
		data.operation = commands[param.operation]
	end
	
	if not _.isEmpty(param.fileds) then
		sql = sql .. " ${fileds}"
		data.fileds = param.fileds
	end
	
	if param.operation == dataBase.operation.select or param.operation == dataBase.operation.delete then
		sql = sql .. " from "
	end
	
	if not _.isEmpty(param.table) then
		sql = sql .. " ${table} "
		data.table = param.table
	end
	
	if not _.isEmpty(param.set) then
		sql = sql .. " @{set} "
		sql_table.set = { "${set}" }
		data.set = param.set
	end
	
	if not _.isEmpty(param.where) then
		sql = sql .. " @{where} "
		sql_table.where = { "${where}" }
		data.where = param.where
	end
	
	if not _.isEmpty(param.orderby) then
		sql = sql .. " ${orderby} "
		data.orderby = param.orderby
	end
	
	if not _.isEmpty(param.limit) then
		sql = sql .. " @{limit} "
		sql_table.limit = { start = "${start}", limit = "${limit}" }
		data.start = param.limit.start
		data.limit = param.limit.limit
	end
	
	sql_table.sql = sql
	return sql_table,data
end


--生成sql语句
-- TODO : 可以做成4种sql语句构造器实现各自不同的构造,进行优化
function dataBase.compileSql(par)
	local param = _.defaults(par,params)
	if _.isEmpty(param.operation) or _.isEmpty(param.table) then
		return false
	end
	local sql_table,data = sql_table_ctor(param)
	return sql_util.getsql(sql_table, data)
end


return dataBase




--[[

--]]

local tab_util = require("util.table")
local dataBase = require("db.database")
local _M = {}

function _M.selectInfo(request, response)
	local db = dataBase.instance("ufo")
	local sql, res, err, errno, sqlstate = dataBase.s('o_owner' ,'oid = 1' , db)
	response:set_header("Content-Type", "text/json; charset=UTF-8")
    response:writeln(cjson.encode({
        sql = sql,
        res = res,
        err = err,
        errno = errno,
        sqlstate = sqlstate
    }))
end

function _M.insertInfo(request, response)
	local db = dataBase.instance()
	local sql, res, err, errno, sqlstate = dataBase.i('user_info' ,'null,"peng",20' , db)
	response:set_header("Content-Type", "text/json; charset=UTF-8")
    response:writeln(cjson.encode({
        sql = sql,
        res = res,
        err = err,
        errno = errno,
        sqlstate = sqlstate
    }))
end

function _M.updateInfo(request, response)
	local db = dataBase.instance()
	local sql, res, err, errno, sqlstate = dataBase.u('user_info' ,'name = "guo", age = 23',"id = 3" , db)
	response:set_header("Content-Type", "text/json; charset=UTF-8")
    response:writeln(cjson.encode({
        sql = sql,
        res = res,
        err = err,
        errno = errno,
        sqlstate = sqlstate
    }))
end

function _M.updateByWhere(request, response)
	local db = dataBase.instance()
	local sql, res, err, errno, sqlstate = dataBase.uByWhere('user_info', 
		tab_util.tab_to_str({name = 'li', age = 20},", "), tab_util.tab_to_str({name = 'liu', age = 8}," and "), db)
	response:set_header("Content-Type", "text/json; charset=UTF-8")
    response:writeln(cjson.encode({
        sql = sql,
        res = res,
        err = err,
        errno = errno,
        sqlstate = sqlstate
    }))
end

function _M.returnSql(request, response)
	local par1 = { 
		operation = 2, 
		table = "user_info", 
		set = tab_util.tab_to_str({name = "liu",age = 8}, ", "),
		where = tab_util.tab_to_str({name = "allen",age = 20}, " and ")
	}
	
	local par = { 
		operation = 1, 
		table = "user_info", 
		fileds = "*",
		where = 'age = 20',
		orderby = "order by id",
		limit = {start = 0, limit = 1}
	}
	
	local sql = dataBase.compileSql(par1)
	response:writeln(sql)
end
	
return _M

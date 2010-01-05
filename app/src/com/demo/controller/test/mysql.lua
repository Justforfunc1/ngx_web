--[[

--]]

local _M = {}

local sql_util = require("util.sql")

function _M.mysql(request, response)
    local stat = request:get_arg("stat") or ""
    local sql_table = {
        sql = [[
            select * from adword
            @{where}
            order by adword_id desc
            limit #{start},#{limit}
        ]],
        where = {
            "status = #{status}"
        }
    }
    local data = { status = stat, start = 0, limit = 10 }
    local sql = sql_util.getsql(sql_table, data)
    local beanFactory = panshi_context.getBeanFactory()
    local mysql_util = beanFactory:getBean("mysql")
    local mysql = mysql_util:getConnect()
    if not mysql then
        error("the mysql is connection fail!")
    end
    local res, err, errno, sqlstate = mysql:query(sql)
    mysql_util:close(mysql)
    response:set_header("Content-Type", "text/json; charset=UTF-8")
    response:writeln(cjson.encode({
        sql = sql,
        res = res,
        err = err,
        errno = errno,
        sqlstate = sqlstate
    }))
end

function _M.transaction(request, response)
    local beanFactory = panshi_context.getBeanFactory()
    local mysql_util = beanFactory:getBean("mysql")
    local sqlArray = {
        "update SYS_USER set USER_NAME='管理员1' where ID=1",
        "update SYS_USER set USER_NAME_A='管理员2' where ID=1" -- USER_NAME_A not exists
    }
    local result_table = mysql_util:queryTransaction(sqlArray)
    response:writeln(cjson.encode(result_table))
end

return _M
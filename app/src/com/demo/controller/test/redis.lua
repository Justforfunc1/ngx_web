--[[

--]]
local _M = {}

local table_util = require("util.table")

function _M.redis(request, response)
    local uid = 1149104128
    local beanFactory = panshi_context.getBeanFactory()
    local redis_util = beanFactory:getBean("redis")
    local redis = redis_util:getConnect()
    --local res = redis:get(uid)
    local res = redis:hgetall(uid);
    local userinfo = table_util.array_to_hash(res)
    redis_util:close(redis)
    response:writeln(cjson.encode(res))
end

return _M 
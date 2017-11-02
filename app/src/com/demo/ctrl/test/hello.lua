--[[

--]]
local _M = {}

--[[
 获取普通参数/文件参数/请求体例子
--]]
function _M.hello(request, response)
     
    -- request:get_arg 支持获取get,post（含文件）方式传过来的参数
    local name = request:get_arg("name") or "world, try to give a param with name."
    ngx.log(logger.i("name=", name))
    -- 获取到的文件类型是table类型，包含filename（文件名）和value（文件内容）属性
    local file = request:get_arg("file")
    if not _.isEmpty(file) then
        local file_save = io.open("/Users/zhuminghua/Downloads/output/"..file["filename"],"w")
        file_save:write(file["value"]);
        file_save:close();
    end
    
    -- 获取到的request_body类型，注意如果client_max_body_size和client_body_buffer_size不一致，
    -- 请求体超过client_body_buffer_size nginx会缓存到文件中，如果请求体比较大，建议将两者设置成一致
    --local request_body = request:get_request_body()
--    local file_save = io.open("/Users/zhuminghua/Downloads/output/aaa.jpg","w")
--    file_save:write(request_body);
--    file_save:close();
    local q = request.query_string
    local a = request.uri_args
    _.each(a, function(k,v) 
        response:write("key:"..k)
        response:writeln("--value:"..v)
    end)
    response:writeln("hello, " .. name)
end

return _M
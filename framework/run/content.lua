--[[
内容响应处理,control执行
--]]
local resty_random = require("resty.random")
local Request = require("core.request")
local Response = require("core.response")
local db_monitor = require("db.monitor")

-- 执行变量
local execute_var = {
    stop = false,
    status = 200
}

-- 初始化
function init()
    -- 生成request_id
    ngx.ctx.request_id = resty_random.token(20)
    
    -- 初始化应用包路径
    panshi_context.init_pkg_path()
    
    --请求基本变量
    local uri = ngx.var.uri
    local method = ngx.var.request_method
    
    -- 获取路由
    execute_var["route"] = panshi_context.getRoute()
    execute_var["ctrl_config"] = execute_var["route"]:getRoute(uri, method)
    if not execute_var["ctrl_config"] then
        ngx.log(ngx.ERR, "no ctrl find for : ", uri)
        execute_var["stop"] = true
        execute_var["status"] = 404
        return
    end
    
    -- 加载ctrl
    local ok, ctrl = pcall(require, execute_var["ctrl_config"].class)
    if not ok then
        ngx.log(ngx.ERR, "ctrl import fail :", ctrl)
        execute_var["stop"] = true
        execute_var["status"] = 404
        return
    end
    execute_var["ctrl"] = ctrl
    
    -- 初始化输入输出
    ngx.ctx.request = Request:new()
    ngx.ctx.response = Response:new()
    
    -- 获取拦截器
    execute_var["interceptorAry"] = execute_var["route"]:getInterceptor(uri, method)
end

--响应内容
function render()
    -- 初始化
    init()
    
    -- 提前终止
    if execute_var["stop"] then
        -- 清除请求体，如果没有清除，会将请求体放到下次请求的header中
        ngx.req.discard_body()
        ngx.exit(execute_var["status"])
        return
    end
    
    -- 执行ctrl方法
    if execute_var["ctrl"].new then
        execute_ctrl_new()
    else
        execute_ctrl_fun()
    end
    
    -- 监控数据库连接
    db_monitor.check("redis_connect", "mysql_connect")
    
    -- 输出内容
    ngx.ctx.response:finish()
    
    -- 清除请求体，如果没有清除，会将请求体放到下次请求的header中
    ngx.req.discard_body()
end

--执行类中的方法
function execute_ctrl_new()
    --拦截器before
    local interceptor_ok, interceptor_msg = execute_before()
    if not interceptor_ok then
        ngx.log(ngx.INFO, "interceptor ctrl success.")
        if interceptor_msg then
            ngx.ctx.response:writeln(interceptor_msg)
        end
        return
    end
    --control.method
    local ctrl_instance = execute_var["ctrl"]:new()
    local ctrl_method = ctrl_instance[execute_var["ctrl_config"].method]
    if ctrl_method and _.isFunction(ctrl_method) then
        local call_ok, err_info = pcall(ctrl_method, ctrl_instance, ngx.ctx.request, ngx.ctx.response)
        execute_after(call_ok, err_info)
    else
        ngx.log(ngx.ERR, "ctrl has no method.")
    end
end

--执行模块中的函数
function execute_ctrl_fun()
    --拦截器before
    local interceptor_ok, interceptor_msg = execute_before()
    if not interceptor_ok then
        ngx.log(ngx.INFO, "interceptor ctrl success.")
        if interceptor_msg then
            ngx.ctx.response:writeln(interceptor_msg)
        end
        return
    end
    --control.method
    local ctrl = execute_var["ctrl"]
    local ctrl_method = ctrl[execute_var["ctrl_config"].method]
    if ctrl_method and _.isFunction(ctrl_method) then
        local call_ok, err_info = pcall(ctrl_method, ngx.ctx.request, ngx.ctx.response)
        execute_after(call_ok, err_info)
    else
        ngx.log(ngx.ERR, "ctrl has no method.")
    end
end

--执行拦截器中的beforeHandle
function execute_before()
    if _.size(execute_var["interceptorAry"]) == 0 then
        return true, "no interceptor."
    end
    local call_ok, interceptor, rs_ok = true, nil, true
    for key, value in pairs(execute_var["interceptorAry"]) do
        call_ok, interceptor = pcall(require, value)
        if call_ok and _.isFunction(interceptor["beforeHandle"]) then
            call_ok, rs_ok, rs_msg = pcall(interceptor["beforeHandle"])
            if call_ok then
                -- 有一个返回失败，则返回
                if not rs_ok then
                    return false, rs_msg
                end
            else
                ngx.log(ngx.ERR, "interceptor call beforeHandle fail : ", rs_ok)
            end
        end
    end
    return true, "interceptor ok."
end

--执行拦截器中的afterHandle
function execute_after(ctrl_call_ok, err_info)
    if not ctrl_call_ok then
        ngx.log(ngx.ERR, "ctrl execute error : ", err_info)
    end
    if _.size(execute_var["interceptorAry"]) == 0 then
        return
    end
    local call_ok, interceptor = true, nil
    for key, value in pairs(execute_var["interceptorAry"]) do
        call_ok, interceptor = pcall(require, value)
        if call_ok and _.isFunction(interceptor["afterHandle"]) then
            pcall(interceptor["afterHandle"], ctrl_call_ok, err_info)
        end
    end
end

-- 执行
do
    render()
end
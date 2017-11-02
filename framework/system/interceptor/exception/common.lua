--[[
异常处理拦截器(默认使用)，建议在应用行自行实现
--]]
local _M = {}

--before
function _M.beforeHandle()
    local request = ngx.ctx.request
    local headParam = {}
    headParam["appkey"] = request:get_header("appkey") or ""
    headParam["appversion"] = request:get_header("apiversion") or ""
    ngx.log(logger.i("request header is ", cjson.encode(headParam)))
    return true, ''
end

--after显示异常信息
function _M.afterHandle(ctrl_call_ok, err_info)
    if not ctrl_call_ok then
        ngx.ctx.response:writeln(cjson.encode(
                {
                    head = {
                        status = 4,
                        msg = err_info or "the ctrl execute fail!",
                        request_id = ngx.ctx.request_id,
                        timestamp = ngx.time()
                    }
                }
        ))
    end
end

return _M

--[[
	认证拦截器(默认使用)
	接口请求认证
--]]
--todo:用户信息模块
--用户权限验证
--请求有效期验证
--GET 校验sign与token
--POST 校验token


local _M = {}

--before
function _M.beforeHandle()	
    local request = ngx.ctx.request

    local headParam = {}
	headParam["appkey"] = request:get_header("appkey") or ""
    headParam["timestamp"] = request:get_header("timestamp") or ""
    headParam["token"] = request:get_header("token") or ""
	headParam["sign"] = request:get_header("sign") or ""
    ngx.log(logger.i("request header is ", cjson.encode(headParam)))

	local beanFactory = panshi_context.getBeanFactory()
	local paramService = beanFactory:getBean("paramService")
	local params = request.uri_args
	local ok,val = paramService:necessaryParams()
	if not ok then
		if val then
			return false,cjson.encode(val)
		end
		return false, 'without this permission.'
	end
    return true,''
end

--after显示异常信息
function _M.afterHandle(ctrl_call_ok, err_info)
    if not ctrl_call_ok then
        ngx.ctx.response:writeln(cjson.encode(
                {
                    head = {
                        status = 403,
                        msg = err_info or "the ctrl execute fail!",
                        request_id = ngx.ctx.request_id,
                        timestamp = ngx.time()
                    }
                }
        ))
    end
end

return _M
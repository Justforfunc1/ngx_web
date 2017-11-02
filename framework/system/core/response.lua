--[[
输出处理类
--]]
local Response = Class("core.Response")

function Response:init()
	ngx.log(ngx.DEBUG, "[Response:init] start.")
	self._output = {}
	self._cookies = {}
	self._eof = false
end

function Response:write(content)
	if self._eof then
		ngx.log(ngx.ERR, "response has been explicitly finished before.")
		return
	end
	table.insert(self._output, content)
end

function Response:writeln(content)
	if self._eof then
		ngx.log(ngx.ERR, "response has been explicitly finished before.")
		return
	end
	table.insert(self._output, content)
	table.insert(self._output, "\r\n")
end

function Response:redirect(url, status)
	ngx.redirect(url, status)
end

function Response:set_header(key, value)
	if _.isEmpty(key) or _.isEmpty(value) then
		ngx.log(ngx.ERR, "response set header key or value is empty.")
		return
	end
	ngx.header[key] = value
end

function Response:set_cookie(key, value, encrypt, duration, path)
	local cookie = self:_set_cookie(key, value, encrypt, duration, path)
	self._cookies[key] = cookie
	self:set_header("Set-Cookie", _.values(self._cookies))
end

function Response:_set_cookie(key, value, encrypt, duration, path)
	if not value then return nil end
	if not key or key == "" or not value then
		return
	end
	if not duration or duration <= 0 then
		duration = 604800 -- 7 days, 7*24*60*60 seconds
	end
	if not path or path == "" then
		path = "/"
	end
	if value and value ~= "" and encrypt == true then
		value = ndk.set_var.set_encrypt_session(value)
		value = ndk.set_var.set_encode_base64(value)
	end
	local expiretime = ngx.time() + duration
	expiretime = ngx.cookie_time(expiretime)
	return table.concat({ key, "=", value, "; expires=", expiretime, "; path=", path })
end

function Response:error(info)
	if self._eof then
		ngx.log(ngx.ERR, "response has been explicitly finished before.")
		return
	end
	ngx.status = 500
	self:set_header("Content-Type", "text/html; charset=utf-8")
	self:write(info)
end

function Response:finish()
	if self._eof then
		ngx.log(ngx.ERR, "response has been explicitly finished before.")
		return
	end
	self._eof = true -- 标记结束
	ngx.print(self._output) -- 输出
	self._output = nil -- 清空内容
	local ok, ret = pcall(ngx.eof) -- 关闭链接
	if not ok then
		ngx.log(ngx.ERR, "ngx.eof() error:" .. ret)
	end
end

return Response
--[[
	Service基类
--]]

local baseService = Object()

--初始化构造
function baseService:init(name)
	self.service_name = name
	self.result = result
end

--数据过滤
local function filterFiled(data)
	if _.isEmpty(data) then
		 ngx.log(logger.d("result is ", cjson.encode(data)))
		return false
	end
	if _.isTable(data) then
		if not _.isEmpty(data.errno) or not _.isEmpty(data.err) then
			ngx.log(logger.d("sql : ", data.sql, " err : ",data.err))
			return false,{data.errno,data.err}
		end
		if not _.isEmpty(data.res) then
			if not _.isEmpty(data.res.affected_rows) then
				return true,{affected_rows = data.res.affected_rows}
			end
			return true,data.res
		end		
	end
	return false,data
end

--数据返回
function baseService:render(data)
	local ok,err = filterFiled(data)
	if ok then 
		return self:repleyData(1,err)
	else
		if _.isTable(err) then
			return self:repleyMessage(err.errno,err.err)
		elseif _.isString(err) then
			return self:repleyMessage(-100,err)
		else
			return self:repleyException("Exception!")
		end	
	end
end

--异常
function baseService:repleyException(e)
	return self:repleyData(-500, e)
end

--正常
function baseService:repleyOK(data)
	return self:repleyData(1, (_.isEmpty(data) and "ok") or data)
end

--返回消息
function baseService:repleyMessage(code, name)
	local msg = panshi_msg.getMsg(name, tostring(code))
	return self:repleyData(code,msg)
end

--返回数据
function baseService:repleyData(code, data)
	return {code = code, result = data}
end

--计算分页
function baseService:pages(totalRecord,maxResult)
	return math.ceil(totalRecord/maxResult)
end

return baseService




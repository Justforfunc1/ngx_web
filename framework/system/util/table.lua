--[[
表常用方法
--]]
local _M = {}

local ok, new_tab = pcall(require, "table.new")
if not ok then new_tab = function(narr, nrec) return {} end end

_M.new_tab = new_tab

--[[
-- for resty.redis
--]]
function _M.array_to_hash(t)
	if not t or not _.isArray(t) then
		return nil
	end
	local n = #t
	local h = new_tab(0, n / 2)
	for i = 1, n, 2 do
		h[t[i]] = t[i + 1]
	end
	return h
end


--[[
输出table
--]]
function _M.tab_print(str)
   if _.isEmpty(str) or not _.isTable(str) then
       return false
   end
   local val = ""
   for k,v in pairs(str) do
       if _.isTable(v) then
           _M.tab_print(v)  
	   else
			val = val..k.."=".."["..v.."]"..", " 
       end
	end    
	return val
end


--[[
计算无序table的长度
--]]
local count = 0
function _M.tab_len(t)
	if _.isEmpty(t) or not _.isTable(t)then
		return false
	end
	for k,v in pairs(t) do
		if type(v) == "table" then
			_M.tab_len(v)
		else
			count = count +1
		end
		
	end
	return count
end


--[[
以tag分割tab转成string
--]]
function _M.tab_to_str(t,tag)
	local mark = tag or ", "
	if _.isTable(t) then
		local str = ''
		local count = 0
		local l = _M.tab_len(t)
		for k,v in pairs(t) do
			if (_.isString(v)) then
				v = '"'..v..'"'
			end
			str = str..k..'='..v
			count = count + 1
			if(count < l) then
				str = str..mark
			end			
		end
		return str
	end
	return t
end

--[[
返回无序table转数组
--]]
function _M.tab_to_array(tab)
	if _.isEmpty(tab) or not _.isTable(tab) then
		return tab or ""
	end
	local val = {}
	local i = 1
	for k,v in pairs(tab) do
		val[i] = v
		i = i + 1
	end
	return val
 end
 
--[[
无序table根据key排序迭代
--]]
local function pairs_by_keys(t, f)
	local a = {}
	for n in pairs(t) do 
		table.insert(a, n) 
	end
	table.sort(a, f)
	local i = 0
	local iter = function()
		i = i + 1
		if a[i] == nil then 
			return nil
		else 
			return a[i], t[a[i]]
		end
	end
	return iter
end


--[[
无序table排序
--]]
function _M.tab_sort_by_key(t)
	local a = {}
	for k,v in pairs_by_keys(t) do
		a[k] = v
	end
	return a
end

--[[
按顺序拼接无序table
--]]
function _M.tab_concat_by_key(t)
	local tab = t or {}
	local str = ''
	for k,v in pairs_by_keys(tab) do
		str = str..k..v
	end
	return str
end



return _M

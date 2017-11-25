--[[
	模块声明方法
--]]

local moduleName = ...
local _M = {}
_G[moduleName] = _M
package.loaded[moduleName] = _M

--方法一
--使用元表设置_index属性,模拟级城市新
--使用元表带来的开销
setmetatable(_M, {__index = _G})

--方法二
--保存全局环境
--使用全局环境时需要添加前缀_G
local _G = _G 


--方法三
--不能运用全局环境，需要将用到的环境中用到的全局方法引用到本地环境
--开销小，速度快
local io = io
local pairs = pairs
local _ = _
local type = type

--设置当前环境
setfenv(1, _M)
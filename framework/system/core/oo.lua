
--[[
	OO类，目前功能不可以。
	无继承类使用class
	继承类使用object
	todo:
	整合class与object模块，统一实现通用的class类
--]]

local _class = {}

local class = function(super)
	local cls = {}
	cls.ctor = false
	cls.super = super
	cls.__index = cls
	cls.new = function(...)
		local obj = {}
		
		do
			local create
			create = function(c,...)
				if c.super then
					create(c.super,...)
				end
				if c.ctor then
					c.ctor(obj,...)
				end
			end
			create(cls,...)
		end
		
		setmetatable(obj, { __index=_class[cls] })
		return obj
	end
	
	local vtbl = {}
	_class[cls]=vtbl
 
	setmetatable(cls,{__newindex=
		function(t,k,v)
			vtbl[k]=v
		end
	})

	setmetatable(cls,{__tostring=
		function(cls)
			return 11
		end
	})
 
	if super then
		setmetatable(vtbl,{__index=
			function(t,k)
				local ret=_class[super][k]
				vtbl[k]=ret
				return ret
			end
		})
	end
 
	return cls
end

return setmetatable({}, { __call = function(...) return class(...):new(...) end })
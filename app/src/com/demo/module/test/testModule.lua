
local baseModule = require("com.demo.module.common.baseModule")
local owner = Object(baseModule)

owner.oid = 0
owner.company = ''
owner.domain = ''
owner.province = 0
owner.city = 0
owner.mobile = ''
owner.address = ''
owner.stat = 0
owner.owner_type = 1
owner.owner_group = 3

local function owner:ctor() 
	self.oid = 0
	self.company = ''
	self.domain = ''
	self.province = 0
	self.city = 0
	self.mobile = ''
	self.address = ''
	self.stat = 0
	self.owner_type = 1
	self.owner_group = 3
end

local function owner:get()




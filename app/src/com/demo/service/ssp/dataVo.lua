-- Copyright (C) Allen.L, CloudFlare Inc. \last Modified 2017-11-06 10:03:35
--

local tab = require("util.table")
local dataVo = Class()

local imp = {
	id = 0,
	tagid = 0,
	bidfloor = 0,
	
	
}

dataVo.req = {}

dataVo.imp = {}
dataVo.imp.id = 0
dataVo.imp.tagid = 0
dataVo.imp.bidfloor = 0

dataVo.imp.banner = {}
dataVo.imp.banner.width = 0
dataVo.imp.banner.high = 0
dataVo.imp.banner.type = ''

dataVo.imp.video = {}
dataVo.imp.video.w = 0
dataVo.imp.video.h = 0
dataVo.imp.video.mimes = 0
dataVo.imp.video.minduration = 0
dataVo.imp.video.maxduration = 0

dataVo.site = Class()
dataVo.site.id = 0
dataVo.site.name = ''
dataVo.site.domian = ''
dataVo.site.type = 0
	
dataVo.device = Class()
dataVo.device.type = 0
dataVo.device.track = 0
dataVo.device.os = 0
dataVo.device.id = 0
dataVo.device.udid = 0

dataVo.user = Class()
dataVo.user.id = 0
dataVo.user.tag = ''


function dataVo:Value(arg)
	tab.tab_print(arg)
	return true
end


function dataVo:init()
end

function dataVo:setValue(arg)
	if _.isEmpty(arg) then
		return nil
	end
	for k,v in pairs(arg) do
		if(type(v) == 'table') then
			dataVo:setValue(v)
		else
			self.req[k]=v
		end
	end
	return self.req
end

return dataVo


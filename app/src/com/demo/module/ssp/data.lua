
local moduleName = ...
local _M = {}
_G[moduleName] = _M
package.loaded[moduleName] = _M
setmetatable(_M, {__index = _G})
setfenv(1, _M)

imp = {}
imp.id = 0
imp.tagid = 0
imp.bidfloor = 0
imp.banner = banner
imp.video = vide

banner = {}
banner.width = 0
banner.high = 0
banner.type = ''

video = {}
video.w = 0
video.h = 0
video.mimes = 0
video.minduration = 0
video.maxduration = 0

site = {}
site.id = 0
site.name = ''
site.domian = ''
site.type = 0
	
device = {}
device.type = 0
device.track = 0
device.os = 0
device.id = 0
device.udid = 0

user = {}
user.id = 0
user.tag = ''


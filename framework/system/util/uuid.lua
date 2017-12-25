--[[
	自定义用户id生成器
	Twitter Snowflake分布式id生成算法机制
--]]

local _M = {}
local uuid = require("resty.uuid")
local bit = require("bit")
local twepoch = 1288834974657 --默认使用2010/11/04  时间戳刚好占位41位
local workerIdBits = 5 --机器id占位数
local datacenterIdBits = 5 --数据标识占位数
local maxWorkerId = bit.bxor(-1,bit.lshift(-1,workerIdBits))	--支持最大机器id
local maxDatacenterId = bit.bxor(-1,bit.lshift(-1,datacenterIdBits)) --支持的最大数据标识id
local sequenceBits = 12		--序列在id中占的位数
local workerIdShift = sequenceBits	--机器ID向左移12位
local datacenterIdShift = sequenceBits + workerIdBits --数据标识id向左移17位(12+5)
local timestampLeftShift = sequenceBits + workerIdBits + datacenterIdBits --时间截向左移22位(5+5+12)
local sequenceMask = bit.bxor(-1,bit.lshift(-1,sequenceBits)) --生成序列的掩码，这里为4095 (0b111111111111=0xfff=4095)
local workerId = 0 		--工作机器ID(0~31)
local datacenterId = 0	--数据中心ID(0~31)
local sequence = 0		--毫秒内序列(0~4095)
local lastTimestamp = 0	--上次获取id的时间戳

--获取新的时间戳
local function tilNextMillis(lastTime)
	local timestamp = os.time()
	while(timestamp <= lastTime) do
		timestamp = os.time()
	end
	return timestamp
end

--集群和工作id
local function idWoker(work_id,datacenter_id)
		if work_id > datacenter_id and work_id < 0 then
			ngx.log(logger.e("workerId[%d] is less than 0 or greater than maxWorkerId[%d].", workerId, maxWorkerId))
			return false
		end
		if datacenter_id > maxDatacenterId and datacenter_id < 0 then
			ngx.log(logger.e("datacenterId[%d] is less than 0 or greater than maxDatacenterId[%d].", datacenterId, maxDatacenterId))
			return false
		end
		workerId = work_id
		datacenterId = datacenter_id
		return true
end

--获取下个id
local function nextId()
	local timestamp = os.time()
	if timestamp < lastTimestamp then
		ngx.log(logger.e("Clock moved backwards.  Refusing to generate id for %d milliseconds", lastTimestamp - timestamp))
		return false
	end
	if timestamp == lastTimestamp then
		sequence = bit.band((sequence + 1),sequenceMask)
		if sequence == 0 then
			timestamp = tilNextMillis(lastTimestamp)
		end
	else 
		sequence = 0
	end
	
	lastTimestamp = timestamp
	
	local id = bit.bor(bit.lshift((timestamp - twepoch),timestampLeftShift),
			bit.lshift(datacenterId,datacenterIdShift),
			bit.lshift(workerId,workerIdShift),
			sequence)
		
	--可能是长整形溢出问题导致数值为负
	if id < 0 then
		id = -id
	end
	return id
end

--随机生成用户appkey_id
local function getAppId(w,d)
	local w = w or 1
	local d = d or 1
	local ok = idWoker(w,d)
	if not ok then
		return false
	end
	ok = nextId()
	if not ok then
		return false
	end
	return ok
end

--随机生成用户uuid密钥
local function getAppKey()
	return uuid.generate()
end

--用户接口注册
local function accountRegistration()
	local appid = getAppId()
	if not appid or appid <= 0 then
		ngx.log(logger.w("User Account Registration Error! appid = ", appid))
		return false
	end
	local appkey = getAppKey()
	if not appkey then
		ngx.log(logger.w("User Account Registration Error! appkey = ", appkey))
		return false
	end
	return appid,appkey
end

_M = {
	accountRegistration = accountRegistration
}

return _M

--[[
id = {
  class = "",
  arg = {
    {value/ref = ""}
  },
  property = {
    {name = "",value/ref = ""}
  },
  init_method = "",
  single = 0  -- default 1
}
--]]
mysql_uc = {
    class = "db.mysql",
    arg = {
        { value = "${mysql}" }
    }
}
redis_uc = {
    class = "db.redis",
    arg = {
        { value = "${redis}" }
    }
}



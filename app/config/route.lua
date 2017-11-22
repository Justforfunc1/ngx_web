--[[
全匹配路由，优先级高
route = {
  {"*/GET/POST", "url1","file1","method"},
  {"*", "url2","file2","method"}
}
模式匹配路由
route_pattern = {
  {"*", "url1","file1","method"},
  {"*", "url2","file2","method"}
}
拦截器配置，注：拦截器必须实现beforeHandle和afterHandle方法
interceptor = {
    {
        url = {
            { "*", "url1", true },  -- method, url, pattern
            { "POST", "url2", false },
        },
        class = "file",
        excludes = {
            "url1",
            "url2"
        }
    }
}
--]]
route = {
    { "GET", "/api/test/hello", "com.demo.ctrl.test.hello", "hello" },
    { "*", "/api/test/pic", "com.demo.ctrl.test.hello", "pic" },
    { "*", "/api/test/mysql", "com.demo.ctrl.test.mysql", "mysql" },
    { "*", "/api/test/mysql/transaction", "com.demo.ctrl.test.mysql", "transaction" },
    { "*", "/api/test/redis", "com.demo.ctrl.test.redis", "redis" },
    { "*", "/api/test/baidu", "com.demo.ctrl.test.httpclient", "baidu" },
    { "*", "/api/test/proxy", "com.demo.ctrl.test.httpclient", "proxy" },
    { "*", "/api/test/form", "com.demo.ctrl.test.form", "form" },
    { "POST", "/api/test/request", "com.demo.ctrl.test.bigRequest", "bigRequest" },
    { "*", "/api/test/apitest1", "com.demo.ctrl.test.apiTest", "getOwnerInfo" },
    { "*", "/api/test/apitest2", "com.demo.ctrl.test.apiTest", "getOwnerList" }
}

route_pattern = {}

interceptor = {
    {
        url = {
            {"*", "/", true}
        },
        class = "interceptor.exception.common"
    }
}

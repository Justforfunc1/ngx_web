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
    
    --controller接口
    { "GET", "/api/test/hello", "com.demo.controller.test.hello", "hello" },
    { "*", "/api/test/pic", "com.demo.controller.test.hello", "pic" },
    { "*", "/api/test/mysql", "com.demo.controller.test.mysql", "mysql" },
    { "*", "/api/test/mysql/transaction", "com.demo.controller.test.mysql", "transaction" },
    { "*", "/api/test/redis", "com.demo.controller.test.redis", "redis" },
    { "*", "/api/test/baidu", "com.demo.controller.test.httpclient", "baidu" },
    { "*", "/api/test/proxy", "com.demo.controller.test.httpclient", "proxy" },
    { "*", "/api/test/form", "com.demo.controller.test.form", "form" },
    
    --dataBase接口测试
    { "*", "/api/test/database1", "com.demo.controller.test.database", "selectInfo" },
    { "*", "/api/test/database2", "com.demo.controller.test.database", "insertInfo" },
    { "*", "/api/test/database3", "com.demo.controller.test.database", "updateInfo" },
    { "*", "/api/test/database4", "com.demo.controller.test.database", "updateByWhere" },
    { "*", "/api/test/database5", "com.demo.controller.test.database", "returnSql" },
    
    --Module接口测试
    { "*", "/api/test/moduletest1", "com.demo.module.test.testModule", "loadByKey" },
    { "*", "/api/test/moduletest2", "com.demo.module.test.testModule", "save" },
    { "*", "/api/test/moduletest3", "com.demo.module.test.testModule", "update" },
    { "*", "/api/test/moduletest4", "com.demo.module.test.testModule", "uByWhere" },
    { "*", "/api/test/moduletest5", "com.demo.module.test.testModule", "listByWhere" },
    
    --Controller接口测试
    { "*", "/api/test/ctrtest1", "com.demo.controller.test.user", "getUserByKey" },
    { "*", "/api/test/ctrtest2", "com.demo.controller.test.user", "putUserInfo" },
    { "*", "/api/test/ctrtest3", "com.demo.controller.test.user", "updateUserInfo" }
    
}

route_pattern = {
    
}

interceptor = {
    {
        url = {
            {"*", "/", true}
        },
        class = "interceptor.exception.common"
    }
}

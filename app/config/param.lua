--[[
	validate 参数配置
--]]

--user 示例
user = {
		controller = "com.demo.controller.test.user", --控制器类名
		action = {		
			"getUserByKey",	--控制器方法列表,按递增顺序排列,方法的key对应param字段参数的key
			"putUserInfo",
			"updateUserInfo"
		},
		param = {	--参数列表与方法有序key对应的
			{ 
				key = { --对应参数名
					name = "a",					--接口参数名
					param_type = "number",		--参数类型
					must = true					--是否必须，默认ture 
					}
			},
			{
				name = {
					name = "a",
					param_type = "string",
					must = true
					},
				age = {
					name = "b",
					param_type = "number",
					must = true
				}

			},
			{
				data = {
					name = "data",		
					param_type = "json",	--当参数类型为json时指定解析后的json_table名为table
					must = true,
					table = {
						name = {
							param_type = "string",
							must = true,
							},
						id = {
							param_type = "number",
							must = true,
							},
						site = {
							param_type = "table",
							table = {
								site_id = {
									param_type = "number"
								},
								site_name = {
									param_type = "string"
								},
								site_age = {
									param_type = "number",
									must = false
								}
							}
						}
					}
				}
			}
		}
}

	

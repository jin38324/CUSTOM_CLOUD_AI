
## 部署ollama模型

此处以codellama为例，在linux使用ollama启动codellama模型。

首先打开服务器端口，配置HOST，以允许远程访问。假设主机IP地址是`111.111.111.111`。

```sh
service ollama stop

OLLAMA_HOST=0.0.0.0:11434 ollama serve
```

启动codellam模型：

```sh
ollama run codellama
```

测试本地访问：

```sh
curl http://localhost:11434/api/generate -d '{
  "model": "codellama",
  "prompt": "Write a sample Oracle SQL to select customers",
  "stream": false
}'
```

测试远程访问：

```sh
curl http://111.111.111.111:11434/api/generate -d '{
  "model": "codellama",
  "prompt": "Write a sample Oracle SQL to select customers",
  "stream": false
}'
```

输出示例：

```json
{"model":"codellama","created_at":"2024-05-23T06:02:02.423194149Z","response":"\nHere is a sample Oracle SQL statement that selects customers:\n```\nSELECT * FROM customers;\n```\nThis will return all columns and rows from the `customers` table. You can modify the query by adding or removing columns, or using WHERE clauses to filter the results based on specific criteria. For example:\n```\nSELECT name, address FROM customers WHERE city = 'New York';\n```\nThis will return only the `name` and `address` columns for customers who live in New York City.\n\nYou can also use joins to combine data from multiple tables in your query. For example:\n```\nSELECT c.name, o.order_date\nFROM customers c\nJOIN orders o ON c.customer_id = o.customer_id;\n```\nThis will return the `name` and `order_date` columns for all customers who have placed orders in your database.","done":true,"done_reason":"stop","context":[518,25580,29962,3532,14816,29903,29958,5299,829,14816,29903,6778,13,13,6113,263,4559,15401,3758,304,1831,20330,518,29914,25580,29962,13,13,10605,338,263,4559,15401,3758,3229,393,27778,20330,29901,13,28956,13,6404,334,3895,20330,29936,13,28956,13,4013,674,736,599,4341,322,4206,515,278,421,6341,414,29952,1591,29889,887,508,6623,278,2346,491,4417,470,11077,4341,29892,470,773,5754,3711,6394,304,4175,278,2582,2729,373,2702,16614,29889,1152,1342,29901,13,28956,13,6404,1024,29892,3211,3895,20330,5754,4272,353,525,4373,3088,2670,13,28956,13,4013,674,736,871,278,421,978,29952,322,421,7328,29952,4341,363,20330,1058,5735,297,1570,3088,4412,29889,13,13,3492,508,884,671,26205,304,14405,848,515,2999,6131,297,596,2346,29889,1152,1342,29901,13,28956,13,6404,274,29889,978,29892,288,29889,2098,29918,1256,13,21482,20330,274,13,29967,6992,11299,288,6732,274,29889,15539,29918,333,353,288,29889,15539,29918,333,29936,13,28956,13,4013,674,736,278,421,978,29952,322,421,2098,29918,1256,29952,4341,363,599,20330,1058,505,7180,11299,297,596,2566,29889],"total_duration":2231556438,"load_duration":1117087,"prompt_eval_duration":11533000,"eval_count":191,"eval_duration":2177532000} 
```


## 配置SELECT AI

### 打开网络权限

```sql
BEGIN  
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
         host => '111.111.111.111',
         ace  => xs$ace_type(privilege_list => xs$name_list('http'),
                             principal_name => 'DEMO',
                             principal_type => xs_acl.ptype_db)
   );
END;
/
```

### 测试网络连通性

```sql
SELECT UTL_HTTP.REQUEST('http://111.111.111.111:11434') RESPONSE from dual;
```

返回结果：

```
Ollama is running
```

### 注册模型

```sql
BEGIN
    -- CUSTOM_CLOUD_AI.UNREGIST_MODEL(provider => 'deepseek');

    CUSTOM_CLOUD_AI.REGIST_MODEL(
		provider    =>    'ollama',
		endpoint    =>    'http://111.111.111.111:11434/api/generate',
		auth    =>    '',
		response_parse_path    =>    '$.response',
		request_template    =>    '{
    "model": "<MODEL>",
	"prompt": "<CONTENT>",
    "stream": false,
	"options": {
    "num_ctx": <MAX_TOKENS>
  }
  }'
	);
END;
/
```

创建模型配置：

```sql
BEGIN
    -- CUSTOM_CLOUD_AI.DROP_PROFILE(profile_name => 'DEEPSEEK_LIANG');

	CUSTOM_CLOUD_AI.CREATE_PROFILE(
      profile_name    =>'ollama_codellama',
	  description     => '使用ollama中的模型访问Oracle Database',
      attributes      => '{
	    "provider": "ollama",
        "model" : "codellama",
        "object_list": [{"owner": "DEMO", "name": "SALES"},
                        {"owner": "DEMO", "name": "CUSTOMERS"}
						]
       }');
        
		-- below variables are option
		-- "temperature": 0,
        -- "max_tokens":512,
        -- "stop_tokens": [";"],
END;
/
```

### 测试效果

测试AI对话

```sql
SELECT 
	CUSTOM_CLOUD_AI.CHAT(
      profile_name    =>'ollama_codellama',
	  prompt     => '介绍一下你自己'
	  ) as RESPONSE
FROM DUAL;
```

返回结果：

```
Hello! My name is LLaMA, I'm a large language model trained by a team of researcher at Meta AI. My primary function is to generate human-like text based on the input I receive. I can answer questions, provide information, and even have conversations with users in a way that simulates human-human interaction. My capabilities are constantly evolving, so please let me know if there's anything specific you would like me to help you with!
```

测试提示词生成

```sql
SELECT 
	length(CUSTOM_CLOUD_AI.SHOWPROMPT(
      profile_name    =>'ollama_codellama',
	  prompt     => '告诉我销售总金额'
	  )) as RESPONSE
FROM DUAL;
```

测试生成SQL

```sql
SELECT 
	CUSTOM_CLOUD_AI.SHOWSQL(
      profile_name    =>'ollama_codellama',
	  prompt     => '告诉我销售总金额'
	  ) as RESPONSE
FROM DUAL;
```

返回结果：

```md
SELECT SUM(AMOUNT_SOLD) AS TOTAL_SALES
FROM DEMO.SALES
```
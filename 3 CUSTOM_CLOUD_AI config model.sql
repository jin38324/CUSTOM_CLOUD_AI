-- This example is base on model: deepseek-code



-- Open network access for user, execute as admin user

BEGIN  
    DBMS_NETWORK_ACL_ADMIN.APPEND_HOST_ACE(
         host => 'api.deepseek.com',
         ace  => xs$ace_type(privilege_list => xs$name_list('http'),
                             principal_name => 'BOCE',
                             principal_type => xs_acl.ptype_db)
   );
END;
/


-- Regist model  

BEGIN
    -- CUSTOM_CLOUD_AI.UNREGIST_MODEL(provider => 'deepseek');

    CUSTOM_CLOUD_AI.REGIST_MODEL(
		provider    =>    'deepseek',    -- a custom name
		endpoint    =>    'https://api.deepseek.com/chat/completions',  -- API endpoint
		auth    =>    'sk-08a3b043cac6412c9b8ffa75dd530357',  -- API key
		response_parse_path    =>    '$.choices[0].message.content',  -- how to parse response json, depends on the API, https://docs.oracle.com/en/database/oracle/oracle-database/23/adjsn/json-path-expressions.html
		request_template    =>    '{
    "model": "<MODEL>",
    "temperature": <TEMPERATURE>,
    "max_tokens": <MAX_TOKENS>,
    "stop": <STOP>,
    "stream": false,
    "messages": [
      {
        "content": "You are a helpful assistant",
        "role": "system"
      },
      {
        "content": "<CONTENT>",
        "role": "user"
      }
    ]    
  }'    -- a json template for request data, depends on the API, placeholders like <NAMES> shold be upper case, will be replaced to virables 
	);
END;
/

-- Create a profile, to config how to use LLM and which tables are included
BEGIN
    -- CUSTOM_CLOUD_AI.DROP_PROFILE(profile_name    =>'DEEPSEEK_LIANG');

	CUSTOM_CLOUD_AI.CREATE_PROFILE(
      profile_name    =>'DEEPSEEK_LIANG',    -- a custom name
	  description     => 'Use public LLM AI API in Oracle Database',     -- a custom description
      attributes      => '{
	    "provider": "deepseek",
        "model" : "deepseek-coder",
        "object_list": [{"owner": "SH", "name": "SALES"},
                        {"owner": "SH", "name": "CUSTOMERS"}
						]
       }');
        
		-- below variables are option
		-- "temperature": 0,
        -- "max_tokens":512,
        -- "stop_tokens": [";"],

END;
/

-- Change prompt template, this is an option, default template will be created when create_profile
BEGIN
	CUSTOM_CLOUD_AI.UPDATE_PROFILE_PROMPT(
      profile_name    =>'DEEPSEEK_LIANG',
	  template_name     => 'prompt_template', -- prompt_template or prompt_ddl
	  template_value     => '....');  -- you can change the value, but placedholders should not be missing
END;
/

-- Defalt prompt_template:
-- placeholder: <prompt> <table_infos>
/*
Read the below table description and write an Oracle SQL to answer the following question. 
Pay attention to Table name, use only below tables.

Oracle databse tables with their properties:
<table_infos>

QUESTION:
<prompt>

TASK:
Generate plain text without markdown formate. Do not write anything else except the SQL query.
Use full table name, contains schema name.
Select proper columns. Keep the column sort order as above.


Generated Oracle SQL Statement:
*/


-- Defalt prompt_ddl:
-- placeholder: <table_comment> <schema> <table_name> <column_info>
/*
### Table meaning: <table_comment>
CREATE TABLE  <schema>.<table_name> (
column_name data_type, 
<column_info>
*/
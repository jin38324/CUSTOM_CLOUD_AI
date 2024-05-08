
-- test LLM answer
SELECT 
	CUSTOM_CLOUD_AI.CHAT(
      profile_name    =>'DEEPSEEK_LIANG',
	  prompt     => 'Introduce yourself'
	  )
FROM DUAL;

-- test LLM answer
SELECT 
	CUSTOM_CLOUD_AI.CHAT(
      profile_name    =>'DEEPSEEK_LIANG',
	  prompt     => '简要介绍一下你自己'
	  )
FROM DUAL;


-- Generate prompt based on templates and table information
SELECT 
	CUSTOM_CLOUD_AI.SHOWPROMPT(
      profile_name    =>'DEEPSEEK_LIANG',
	  prompt     => 'give me tha total sales number'
	  )
FROM DUAL;

-- Generate prompt based on templates and table information
SELECT 
	CUSTOM_CLOUD_AI.SHOWPROMPT(
      profile_name    =>'DEEPSEEK_LIANG',
	  prompt     => '告诉我销售总金额'
	  )
FROM DUAL;


SELECT 
	CUSTOM_CLOUD_AI.SHOWSQL(
      profile_name    =>'DEEPSEEK_LIANG',
	  prompt     => 'give me tha total sales number'
	  )
FROM DUAL;

SELECT 
	CUSTOM_CLOUD_AI.SHOWSQL(
      profile_name    =>'DEEPSEEK_LIANG',
	  prompt     => '告诉我销售总金额'
	  )
FROM DUAL;
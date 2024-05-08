
-- test LLM answer
SELECT 
	CUSTOM_CLOUD_AI.CHAT(
      profile_name    =>'DEEPSEEK_LIANG',
	  prompt     => 'Introduce yourself'
	  )
FROM DUAL;


-- Generate prempt based on templates and table information
SELECT 
	CUSTOM_CLOUD_AI.SHOWPROMPT(
      profile_name    =>'DEEPSEEK_LIANG',
	  prompt     => 'give me tha total sales number'
	  )
FROM DUAL;

SELECT 
	CUSTOM_CLOUD_AI.SHOWSQL(
      profile_name    =>'DEEPSEEK_LIANG',
	  prompt     => 'give me tha total sales number'
	  )
FROM DUAL;
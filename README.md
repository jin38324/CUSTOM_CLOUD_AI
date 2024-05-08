# 简介

此项目使用自定义PL/SQL构建类似于SELECT AI的功能。

# 原理

表 CUSTOM_CLOUD_AI_REGEST_MODELS 用于存储模型端点信息
表 CUSTOM_CLOUD_AI_PROFILES 用于存储prfile信息

自定义包CUSTOM_CLOUD_AI 包含以下方法：

procedure  REGIST_MODEL ： 把LLM API的端点信息存储到数据表
procedure UNREGIST_MODEL ： 删除端点信息
procedure CREATE_PROFILE ： 创建模型调用信息
procedure DROP_PROFILE ： 删除模型调用信息
procedure UPDATE_PROFILE_PROMPT ： 更新profile中的提示词模板

function CHAT ： 直接向LLM提问，获取文本答案;
function GET_TABLE_INFO ： 获取表的DDL信息和comments
function SHOWPROMPT ： 根据提示词模板，组装提示词
function SHOWSQL ： 把提示词发送给LLM，获得SQL

# 安装方法：
1、执行CUSTOM_CLOUD_AI package.sql，创建包；
2、参照CUSTOM_CLOUD_AI initial.sql,初始化模型配置；

# 使用方法：
参照 use case example.sql

-- DROP TABLE CUSTOM_CLOUD_AI_REGEST_MODELS;

CREATE TABLE CUSTOM_CLOUD_AI_REGEST_MODELS (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    model_provider VARCHAR2(100) UNIQUE,
    model_endpoint VARCHAR2(1000),
    model_auth VARCHAR2(1000),
    model_response_parse_path VARCHAR2(1000),
    model_request_template VARCHAR2(4000),
    CONSTRAINT pk_custom_cloud_ai_regest_models PRIMARY KEY (id)
);


-- DROP TABLE CUSTOM_CLOUD_AI_PROFILES;

CREATE TABLE CUSTOM_CLOUD_AI_PROFILES (
    id NUMBER GENERATED BY DEFAULT AS IDENTITY,
    ai_profile_name VARCHAR2(256) UNIQUE,
    ai_description VARCHAR2(4096),
    attributes CLOB,
    provider VARCHAR2(256),
    model VARCHAR2(256),
    temperature NUMBER,
    max_tokens NUMBER,
    stop_tokens VARCHAR2(256),
    object_list CLOB,
	prompt_template VARCHAR2(32767),
	prompt_ddl VARCHAR2(32767),
    CONSTRAINT pk_custom_cloud_ai_profiles PRIMARY KEY (id)
);

ALTER TABLE CUSTOM_CLOUD_AI_PROFILES ADD CONSTRAINT chk_json CHECK (attributes IS JSON);
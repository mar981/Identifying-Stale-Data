--USING STL_QUERY

with queries_ran_by_dbt as (
	select distinct 
	--querytxt, -- can remove querytxt in final version, just here for easier debugging
	regexp_substr(querytxt,'("node_id": ).*\\}') as query_txt_model,
	regexp_substr(querytxt,'("dev".)("[\\w_]+")') as query_txt_schema
	from stl_query
	where userid = [userid]
	and querytxt like '/* {"app": "dbt"%' and querytxt not like '%"dev.information_schema"%' --to exclude queries for compression encoding
	and starttime::date > '2021-10-01' and starttime::date < '2021-11-17'
),
only_models_and_cleaning as (
	select 
		replace(replace(query_txt_schema,'"',''),'dev.','') as query_txt_schema_clean,
		replace(replace(replace(query_txt_model,'"',''),'node_id: model.dw_dbt.',''),'}','') as model_clean
	from queries_ran_by_dbt
	--where query_txt_model like '%model.%' and query_txt_schema_clean not like 'ci%'
	group by 1,2
),
clean as (
	select distinct
		model_clean as model,
		query_txt_schema_clean as schema_name
		--case when model = [model_name] then [schema_name] else query_txt_schema_clean end as schema_name
	from only_models_and_cleaning
)

select * from clean limit 100;

--USING STL_SCAN
SELECT distinct trim(perm_table_name) FROM STL_SCAN where userid = 103;

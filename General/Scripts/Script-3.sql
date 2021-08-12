
-- databases : 

SELECT
    pg_database.datname,
    pg_database_size(pg_database.datname) AS bytes,
    pg_size_pretty(pg_database_size(pg_database.datname)) AS hsize
    FROM pg_database
   order by bytes desc;
   
 -- schemas : 
 SELECT schema_name FROM information_schema.schemata
 
  SELECT nspname,* FROM pg_catalog.pg_namespace 
  where nspname not like 'pg%'
  
  SELECT nspname,* FROM pg_catalog.pg_namespace 
  where nspname not like '%_timescale_%'
  
  






select * from timescaledb_information.jobs


SELECT "time", machine, machineserial, recipe, recipeloadcounter, loggeractivationuid, loggeridentifier, bnewrecipientweight, 
recipientweight_eunit, recipientweight_eweightresult, recipientweight_fgrossweight, recipientweight_fmaxoverweight, 
recipientweight_fmaxunderweight, recipientweight_fnetweight, recipientweight_fsetpoint, recipientweight_ftareweight, 
recipientweight_icountinactiverecipe, recipientweight_imoduleindex, recipientweight_istructversion, 
recipientweight_itimeofweightms, recipientweight_smodulekey, 
recipientweight_srecipientid FROM ppltesttslite3.weightdata
order by time desc
limit 1000

select machineserial from ppltesttslite3.weightdata order by time desc limit 1

-- get active batchnumber
select last(recipeloadcounter, time) from ppltesttslite3.weightdata
select first(time,time) from ppltesttslite3.weightdata where recipeloadcounter = (select last(recipeloadcounter, time) from ppltesttslite3.weightdata)

--************ functions  *****************


select * from public.pattyn_getbatchstart()
select * from public.pattyn_getbatchstart('20')

select * from timescaledb_information.chunks
select * from _timescaledb_catalog.chunk order by id;

-- test the vacuum !!

SELECT pg_size_pretty (pg_database_size ('Pattyn')) as total_Pattyn_database_size; --5369 MB
select * from timescaledb_information.hypertables h 

select * from weightdata w order by time desc limit 100
select * from objects w order by time desc limit 100
select * from alarms w order by time desc limit 100

vacuum (full, verbose) 

select cast(emptybox as integer)::boolean,  * from pattyntestplcts.mec11_datas_pbd
where cast(emptybox as integer)::boolean <> false 
limit 100
 

-- create function to show scheme.table name from all schemes ?
-- create funtion to select data from (scheme.table) ??

-- SELECT decompress_chunk(i) from show_chunks('ppltesttslite2.objects') i;

-- Bereken de stddev van verschillende batch-onderdelen
--https://www.postgresql.org/docs/9.2/xfunc-sql.html
-- via function returns setof ??


select * from public.dba_chunk_details



select view_definition, * from timescaledb_information.continuous_aggregates MV
drop materialized view weightdata_hourly

SELECT default_version, installed_version FROM pg_available_extensions where name = 'timescaledb';

CREATE MATERIALIZED VIEW pattyntestplcts.weightdata_hourly -- materialized view is schema
WITH (timescaledb.continuous) AS
 SELECT weightdata.loggeractivationuid,
    weightdata.machine,
    weightdata.machineserial,
    weightdata.recipe,
    weightdata.recipeloadcounter,
    weightdata.recipientweight_imoduleindex,
    weightdata.recipientweight_eweightresult,
    (weightdata.recipientweight_istructversion)::integer AS recipientweight_istructversion,
    time_bucket('01:00:00'::interval, weightdata."time") AS bucket,
    count(weightdata.recipientweight_eweightresult) AS nrofweightresult,
    max(weightdata.recipientweight_fsetpoint) AS setpoint,
    max(weightdata.recipientweight_fmaxoverweight) AS maxoverweight,
    max(weightdata.recipientweight_fmaxunderweight) AS maxunderweight,
    count(weightdata.recipientweight_fnetweight) AS nrofboxes,
    sum(weightdata.recipientweight_fnetweight) AS totalweight,
    min(weightdata.recipientweight_fnetweight) AS minboxweight,
    max(weightdata.recipientweight_fnetweight) AS maxboxweight,
    avg(weightdata.recipientweight_fnetweight) AS avgboxweight,
    stddev(weightdata.recipientweight_fnetweight) AS stdevboxweight,
    first(weightdata."time", weightdata.recipientweight_fnetweight) AS fillingfirsttime,
    last(weightdata."time", weightdata.recipientweight_fnetweight) AS fillinglasttime,
    first(weightdata."time", weightdata."time") AS bucketfirsttime,
    last(weightdata."time", weightdata."time") AS bucketlasttime,
    avg(weightdata.recipientweight_ftareweight) AS avgtareweight,
    max((weightdata.recipientweight_smodulekey)::text) AS skey
   FROM pattyntestplcts.weightdata
  WHERE (weightdata.recipientweight_fnetweight IS NOT NULL)
  GROUP BY weightdata.recipientweight_istructversion, weightdata.machine, weightdata.machineserial, weightdata.loggeractivationuid, weightdata.recipe, weightdata.recipeloadcounter, weightdata.recipientweight_imoduleindex, weightdata.recipientweight_eweightresult, (time_bucket('01:00:00'::interval, weightdata."time"));
  
 
 SELECT add_continuous_aggregate_policy('pattyntestplcts.weightdata_hourly',
start_offset => INTERVAL '2 day',
end_offset => INTERVAL '1 h',
schedule_interval => INTERVAL '1 h'); --1184


select * from timescaledb_information.continuous_aggregates
ALTER MATERIALIZED VIEW pattyntestplcts.weightdata_hourly owner to testcompany

select * from timescaledb_information.jobs



-- example group by

select * from pattyntestplcts.weightdata w limit 10
select recipe, recipeloadcounter,  sum(recipientweight_fnetweight ) from pattyntestplcts.weightdata w 
group by recipe, recipeloadcounter
limit 1000


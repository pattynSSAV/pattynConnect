select * from public.dba_database_details d limit 100

select * from timescaledb_information.compression_settings

select recipientweight_icustomerfield,recipientweight_scustomerfield, * from  pattyntestplcts.weightdata order by time desc limit 400




alter table pattyntestplcts.actorobjects SET(
timescaledb.compress)
select add_compression_policy ('pattyntestplcts.actorobjects', interval '1 days');


alter table pattyntestplcts.argocheck_datas_pbd SET(
timescaledb.compress)

select add_compression_policy ('pattyntestplcts.argocheck_datas_pbd', interval '1 days');


SELECT M.relscheme, relname, sum(rowcount) AS "Records", sum(size) /(1024*1024) AS "tableMB", sum(totalsize) /(1024*1024) AS "totalMB", sum(rowcount)/(sum(size)+1)*(1024*1024) AS "table_recPerMB", sum(size)/(sum(rowcount)+1) AS "table_bytePerrecord", sum(rowcount)/(sum(totalsize)+1)*(1024*1024) AS "totalrecPerMB", sum(totalsize)/(sum(rowcount)+1) AS "totalbytePerrecord"
FROM public.dbatablesizes M
WHERE time in (SELECT last(time,time)
FROM public.dbatablesizes ) and relscheme in ('pattyntestplcts') group by relscheme, relname
ORDER BY relscheme, "tableMB" desc







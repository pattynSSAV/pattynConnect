select recipe from general 
order by time desc
limit 1

select * from  pattyn_getrecipeperiods_epoch ('1002', '2021-01-20T04:49:49.815Z', '2021-01-20T07:49:49.815Z');

select * from  pattyn_getrecipeperiods_epoch ('1002', '2021-03-03T04:49:49.815Z', now()::timestamp)


-- select the start (from time) for a running recipe : starttime --> now()
select * from  pattyn_getrecipeperiods_epoch ('1002', '2021-03-03T04:49:49.815Z', now()::timestamp)

select * from  pattyn_getrecipeperiods_epoch ('1002', (now()- interval '1 day')::timestamp, now()::timestamp) 
order by recipe_epoch_time_from desc limit 1

select now() - interval '1 day'

select * from public.pattyn_getrecipeperiods('1002', (now()- interval '1 day')::timestamp, now()::timestamp)
order by time_from desc limit 1

--in GRAFANA 
select   time,  recipientweight_fnetweight AS "boxes"
FROM weightdata_v1
WHERE
--  $__timeFilter("time")
time > (select time_from from public.pattyn_getrecipeperiods('1002', (now()- interval '1 day')::timestamp, now()::timestamp) order by time_from desc limit 1)
  and recipe in ($Recipe)
--GROUP BY 1
ORDER BY 1

-- origional : 
SELECT "Recipe" FROM (SELECT last("BoxMade"), "Recipe" FROM "autogen"."General" WHERE $timeFilter GROUP BY time($__interval) fill(null))


-- TRY to FILL the time bar
SELECT 
time, Recipe, machineserial FROM  general WHERE 
time > (
		select time_from from public.pattyn_getrecipeperiods('1002', (now()- interval '1 day')::timestamp, now()::timestamp)
		order by time_from desc limit 1)
		
-- Select active batch ? 
select time_from, recipe from public.pattyn_getrecipeperiods('1002', (now()- interval '1 day')::timestamp, now()::timestamp) order by time_from desc limit 1
explain analyse select time_from, recipe from public.pattyn_getrecipeperiods('1002', (now()- interval '1 day')::timestamp, now()::timestamp) order by time_from desc limit 1

select distinct recipe from weightdata_v1 wv 
explain select distinct recipe from weightdata_v1 wv
explain analyse select distinct recipe from weightdata_v1 wv


		-- of in epoch ??
		SELECT 
time, Recipe FROM  general WHERE 
time > (
		select recipe_epoch_time_from from public.pattyn_getrecipeperiods_epoch('1002', (now()- interval '1 day')::timestamp, now()::timestamp)
		order by recipe_epoch_time_from desc limit 1)

select * from weightdata_v1 wv limit 50

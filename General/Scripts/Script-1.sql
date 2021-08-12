select distinct  
--"time"
-- machine
 --machineserial
--, recipe
--, recipebatch
--, loggeractivationuid
--, recipientweight_eweightresult
--, recipientweight_fmaxoverweight
--, recipientweight_fmaxunderweight
--, recipientweight_fnetweight   
--, recipientweight_fsetpoint
--, recipientweight_ftareweight
--, recipientweight_fnetweight + recipientweight_ftareweight as mygross 
--, recipientweight_fgrossweight
--, recipientweight_ibatchnr
--, recipientweight_itimeofweightms
 --recipientweight_iunitid
--, recipientweight_srecipientid
 recipientweight_sunitid
--, brecipientweightupdated
FROM testplctimescale.weightdata_v1
limit 100

select recipebatch, recipientweight_iunitid , recipientweight_sunitid , recipientweight_srecipientid ,  * from testplctimescale.weightdata_v1  order by time desc limit 100

select count(*) from testplctimescale.weightdata_v1   where recipebatch = '168' --9576
select * from testplctimescale.weightdata_v1   where recipebatch = '168' order by time asc limit 1 -- 2021-03-30 22:11:27
select * from testplctimescale.weightdata_v1   where recipebatch = '168' order by time desc limit 1 --2021-03-31 02:48:09


select count(*) from weightdata_hourly ws  where recipebatch = '168' --20
select * from weightdata_hourly ws  where recipebatch = '168' order by bucketfirsttime asc --2021-03-30 22:11:27
select * from weightdata_hourly ws  where recipebatch = '168' order by bucketlasttime desc --2021-03-31 02:48:09





SELECT 
machine 
, machineserial
, recipe
, recipebatch
, loggeractivationuid
, recipientweight_sunitid
, recipientweight_eweightresult
, time_bucket(INTERVAL '1 hour', time) AS bucket  
-- these are all the needed seperate fields. Now let's aggregate...
,count(recipientweight_eweightresult) AS nrofweightresult
,max(recipientweight_fsetpoint) AS setpoint
,max(recipientweight_fmaxoverweight) as maxoverweight
,max(recipientweight_fmaxunderweight) as maxunderweight
,count(recipientweight_fnetweight) as nrofboxes
,sum(recipientweight_fnetweight) as totalweight 
,min(recipientweight_fnetweight) as minboxweight
,max(recipientweight_fnetweight) as maxboxweight
,avg(recipientweight_fnetweight) as avgboxweight
,stddev(recipientweight_fnetweight) as stdevboxweight --not correct on time buckets ?
,first(time, recipientweight_fnetweight) as fillingfirsttime
,first(time, recipientweight_eweightresult) as fillingfirsttime1
,last(time, recipientweight_fnetweight) as fillinglasttime
, first(time,time )as bucketfirsttime
, last(time,time )as bucketlasttime
,avg(recipientweight_ftareweight) as avgtareweight
--,avg(recipientweight_fgrossweight) as avggrossweight
FROM testplctimescale.weightdata_v1
where recipientweight_fnetweight is not null and recipebatch  ='168'
GROUP BY machine ,machineserial , recipe, recipebatch, loggeractivationuid, recipientweight_sunitid, recipientweight_eweightresult, bucket
order by bucket

--with no data -- to prevent aggregating the entire materialized view on creation...


select recipe, sum(totalweight) from testplctimescale.weightdata_hourly group by recipe
select  * from testplctimescale.weightdata_hourly 

select * from weightdata_v1 order by time desc limit 100


explain analyse
select time_from from public.pattyn_getrecipeperiods('1002', (now()- interval '1 day')::timestamp, now()::timestamp)
order by time_from desc limit 1

explain analyse
select time_from from public.pattyn_getrecipeperiods('1002', (now()- interval '8 hour')::timestamp, now()::timestamp)
order by time_from desc limit 1


select time_bucket(interval '1 day', time ) as day, count(time) from weightdata_v1 wv group by day
order by day desc

-- search the actual running recipebatch starttime !!
select first(bucketfirsttime, bucket), 
last(bucketlasttime, bucket), 
recipebatch 
from weightdata_hourly where bucket > now() -interval '24 hour' 
group by recipebatch 
order by recipebatch::numeric desc



select  recipebatch , first(bucketfirsttime , recipebatch) from weightdata_hourly 
group by recipebatch
order by bucketfirsttime desc  



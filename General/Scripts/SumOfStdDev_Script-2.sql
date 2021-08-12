--https://stats.stackexchange.com/questions/25848/how-to-sum-a-standard-deviation#:~:text=Short%20answer%3A%20You%20average%20the,get%20the%20average%20standard%20deviation.&text=For%20your%20data%3A,sum%3A%2010%2C358%20MWh&text=standard%20deviation%3A%20804.71%20(%20sqrt(647564)%20)

-- combined mean, combined variance : 
-- https://www.emathzone.com/tutorials/basic-statistics/combined-variance.html  ! correct maar moeilijk !!



select recipe, 
recipebatch,
recipientweight_eweightresult,
recipientweight_fnetweight from weightdata_v1 wv where recipebatch ='116' and recipientweight_eweightresult is not null

-- variance = sum of variances ==> 
--s = sqrt(s1^2 + s2^2 + ... + s12^2) : sum of standard deviation, enkel bij gelijk aantal observaties ?
--stddev = sqrt(variance) 
select recipe, 
recipebatch,
recipientweight_eweightresult,
count(recipientweight_fnetweight),
--range(recipientweight_fnetweight)::numeric as range_netw,
min(recipientweight_fnetweight),
max(recipientweight_fnetweight),
max(recipientweight_fnetweight)-min(recipientweight_fnetweight) as net_range,
avg(recipientweight_fnetweight) , -- =mean value ?
variance(recipientweight_fnetweight) ,
sqrt(variance(recipientweight_fnetweight)) as sigma, --stddev = sqrt(variance)
stddev(recipientweight_fnetweight),
avg(recipientweight_fnetweight)  + stddev(recipientweight_fnetweight) as sigma1_683,
avg(recipientweight_fnetweight)  + 2* stddev(recipientweight_fnetweight) as sigma2_954,
avg(recipientweight_fnetweight)  + 3* stddev(recipientweight_fnetweight) as sigma3_997,
--round(recipientweight_fnetweight::numeric , 2) as rnd
ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY recipientweight_fnetweight)::numeric, 5) AS median_recipientweight_fnetweight,
mode() WITHIN GROUP (ORDER BY recipientweight_fnetweight) as mode_netw
from weightdata_v1
where recipientweight_eweightresult is not null
and recipebatch ='116'
group by recipe, recipebatch, recipientweight_eweightresult
order by recipebatch::numeric , recipientweight_eweightresult 


-- kerngetallen voor de complete batch (eweightresult)
select recipe, 
recipebatch,
count(recipientweight_fnetweight) as N,  -- N or number of observations
avg(recipientweight_fnetweight) as mean, -- =mean value ?
variance(recipientweight_fnetweight) , --stddev = sqrt(variance)
stddev(recipientweight_fnetweight)
from weightdata_v1
where recipientweight_eweightresult is not null
and recipebatch ='116'
group by recipe, recipebatch
order by recipebatch::numeric  



-- kerngetallen per observatiegroep (eweightresult) -- bij uitbreiding W1, W2, W3, ....
select recipe, 
recipebatch,
recipientweight_eweightresult,
count(recipientweight_fnetweight) as N,  -- N or number of observations
avg(recipientweight_fnetweight) as mean, -- =mean value ?
variance(recipientweight_fnetweight) , --stddev = sqrt(variance)
stddev(recipientweight_fnetweight)
from weightdata_v1
where recipientweight_eweightresult is not null
and recipebatch ='116'
group by recipe, recipebatch, recipientweight_eweightresult
order by recipebatch::numeric , recipientweight_eweightresult 

-- now select the combined variance for the above results, and compare !!



-- combined mean, combined variance : 
-- https://www.emathzone.com/tutorials/basic-statistics/combined-variance.html  ! correct maar moeilijk !!

-- Start with the Combined mean : Xc
select 
recipe, recipebatch,recipientweight_eweightresult,
count(recipientweight_fnetweight) as N, -- N or number of observations
avg(recipientweight_fnetweight) as mean -- =mean value ? Xc = (n1X1 + n2X2 + n3X3)/(n1+n2+n3)

from weightdata_v1
where recipientweight_eweightresult is not null
and recipebatch ='116'
group by recipe, recipebatch, recipientweight_eweightresult



with detailmean as (
  select 
  recipe, recipebatch,recipientweight_eweightresult,
  count(recipientweight_fnetweight) as N, -- N or number of observations
  avg(recipientweight_fnetweight) as mean -- =mean value ? Xc = (n1X1 + n2X2 + n3X3)/(n1+n2+n3)
  from weightdata_v1
  where recipientweight_eweightresult is not null
	and recipebatch ='116'
	group by recipe, recipebatch, recipientweight_eweightresult
) , 
	detailvariance as (
	  select 
	  recipe, recipebatch,recipientweight_eweightresult,
	  variance(recipientweight_fnetweight) as xvariance --stddev = sqrt(variance)
	  from weightdata_v1
	  where recipientweight_eweightresult is not null
		and recipebatch ='116'
		group by recipe, recipebatch, recipientweight_eweightresult
)
select M.N, M.mean, V.xvariance from detailmean M inner join  detailvariance V on 
(M.recipe = V.recipe and M.recipebatch = V.recipebatch and  M.recipientweight_eweightresult = V.recipientweight_eweightresult)

--of :
--select M.N, M.mean, V.xvariance from detailmean M , detailvariance V
--	where M.recipe = V.recipe 
--	and M.recipebatch = V.recipebatch 
--	and M.recipientweight_eweightresult = V.recipientweight_eweightresult



-- En nu alles samen gooien ? : get the combined mean as a starter...
-- step 1 : calculate the combined mean Xc over all populations 
with detailmean as (
  select 
  recipe, recipebatch,recipientweight_eweightresult,
  count(recipientweight_fnetweight) as N, -- N or number of observations
  avg(recipientweight_fnetweight) as mean -- =mean value ? Xc = (n1X1 + n2X2 + n3X3)/(n1+n2+n3)
  from weightdata_v1
  where recipientweight_eweightresult is not null
	and recipebatch ='116'
	group by recipe, recipebatch, recipientweight_eweightresult
) , 
	detailvariance as ( -- only necessary in step 2 ??) 
	  select 
	  recipe, recipebatch,recipientweight_eweightresult,
	  variance(recipientweight_fnetweight) as xvariance --stddev = sqrt(variance)
	  from weightdata_v1
	  where recipientweight_eweightresult is not null
		and recipebatch ='116'
		group by recipe, recipebatch, recipientweight_eweightresult
) , 
 allresults as (
select M.N, M.mean, V.xvariance, M.N * M.mean as NmeanProduct  from detailmean M inner join  detailvariance V on 
(M.recipe = V.recipe and M.recipebatch = V.recipebatch and  M.recipientweight_eweightresult = V.recipientweight_eweightresult)
)

select (sum(NmeanProduct)/ sum(N)) as combinedMeanXc from allresults

---stap per stap ...
-- En nu alles samen gooien ? : get the combined mean as a starter...
-- step 1 : calculate the combined mean combinedMeanXc over all populations 
with detailmean as (
  select 
  recipe, recipebatch,recipientweight_eweightresult, --nog line, machine, scale toevoegen !!
  count(recipientweight_fnetweight) as N, -- N or number of observations
  avg(recipientweight_fnetweight) as mean -- =mean value ? Xc = (n1X1 + n2X2 + n3X3)/(n1+n2+n3)
  from weightdata_v1
  where recipientweight_eweightresult is not null
	and recipebatch ='116'
	group by recipe, recipebatch, recipientweight_eweightresult
)  , 
	tblCombinedMean as (
select M.N * M.mean as nX, N  from detailmean M 
)

select (sum(nX)/ sum(N)) as combinedMeanXc from tblCombinedMean CM






-- Definities : 
-- stddev = sqrt(variance)
-- average = mean
-- median = the (avg) of the middle value(s) 

--function1 to find the median !! Do we need the median ? probably not
SELECT  
  ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY item_count)::numeric, 2) AS median_item_count
FROM orders  
WHERE item_count <> 0;  

;
select * from public.pbd_get_machines_for_recipe_1(25) limit 100

/*
-- with argocheck as (
		select count(*)
			from pattyntestplcts.argocheck_datas_pbd
			where recipeloadcounter = '25' --cast(recipeloadcounterIn as varchar)'
			into countArgoCheck;

		select 'machine' as machineid, min(machine) as machine, count(*) from pattyntestplcts.argocheck_datas_pbd where recipeloadcounter = '25' union   
	    select 'machine' as machineid, min(machine), count(*) from pattyntestplcts.argocount_datas_pbd where recipeloadcounter = '25' union
	    select 'machine' as machineid, min(machine), count(*) from pattyntestplcts.mec11_datas_pbd where recipeloadcounter = '25'  union
	    select 'machine' as machineid, min(machine), count(*) from pattyntestplcts.checkweigher_datas_pbd where recipeloadcounter = '25'  
			 
	    with mymachines as (
	    select 'machine1' as machineid, min(machine) as machine, count(*) from pattyntestplcts.argocheck_datas_pbd where recipeloadcounter = '25' union   
	    select 'machine2' as machineid, min(machine), count(*) from pattyntestplcts.argocount_datas_pbd where recipeloadcounter = '25' union
	    select 'machine3' as machineid, min(machine), count(*) from pattyntestplcts.mec11_datas_pbd where recipeloadcounter = '25'  union
	    select 'machine4' as machineid, min(machine), count(*) from pattyntestplcts.checkweigher_datas_pbd where recipeloadcounter = '25'
	    )
	    select * from mymachines
*/	

-- 3x faster if not existing, slower if existing :( 
		select
		case when (select exists (select 1 from pattyntestplcts.argocheck_datas_pbd where recipeloadcounter = '25' limit 1)) 
			then (select machine from pattyntestplcts.argocheck_datas_pbd where recipeloadcounter = '25' limit 1)	    
			end
		


	    --
	    CREATE EXTENSION IF NOT EXISTS tablefunc;
	   --
	   -- drop table mylist 
	   
	    with mymachines as (
	    select 'machine' as machineid, min(machine) as machine, count(*) from pattyntestplcts.argocheck_datas_pbd where recipeloadcounter = '25' union   
	    select 'machine' as machineid, min(machine), count(*) from pattyntestplcts.argocount_datas_pbd where recipeloadcounter = '25' union
	    select 'machine' as machineid, min(machine), count(*) from pattyntestplcts.mec11_datas_pbd where recipeloadcounter = '25'  union
	    select 'machine' as machineid, min(machine), count(*) from pattyntestplcts.checkweigher_datas_pbd where recipeloadcounter = '25'
	    ),
	    shortlist as (
	    select machineid, 'attribute' as attribute, machine from mymachines order by 1)
	    select * into temp mylist from shortlist order by 1
	    
	    -- select * from mylist -- temp table, delete first before running above query !
	    
	    select * from crosstab (
	    'select machineid, attribute, machine from mylist
		where attribute = ''attribute'' order by 1,2')
	    as mymachines(row_name text, machine1 text, machine2 text,machine3 text,machine4 text,machine5 text);

/*
	 |row_name|machine1 |machine2 |machine3    |machine4|machine5|
	 |machine |argocount|argocheck|checkweigher|mec11   |        |
*/  
	    
--	https://www.postgresql.org/docs/9.3/tablefunc.html    
	    
	    
 CREATE OR REPLACE FUNCTION public.pbd_get_machines_for_recipe_2(recipeloadcounterin integer)
 RETURNS TABLE( row_name text, machine1 text, machine2 text,machine3 text,machine4 text,machine5 text)
 LANGUAGE plpgsql
AS $function$

begin

		--CREATE EXTENSION IF NOT EXISTS tablefunc;
	   --
	    drop table  if exists mylist;
	    create temporary table mylist on commit drop as
	    (
	    with mymachines as (
	    select 'machine' as machineid, min(machine) as machine, count(*) from pattyntestplcts.argocheck_datas_pbd where recipeloadcounter = cast(recipeloadcounterIn as varchar) union   
	    select 'machine' as machineid, min(machine), count(*) from pattyntestplcts.argocount_datas_pbd where recipeloadcounter = cast(recipeloadcounterIn as varchar) union
	    select 'machine' as machineid, min(machine), count(*) from pattyntestplcts.mec11_datas_pbd where recipeloadcounter = cast(recipeloadcounterIn as varchar)  union
	    select 'machine' as machineid, min(machine), count(*) from pattyntestplcts.checkweigher_datas_pbd where recipeloadcounter = cast(recipeloadcounterIn as varchar)
	    ),
	    shortlist as (
	    select machineid, 'attribute' as attribute, machine from mymachines order by 1)
		select * from shortlist
		);
		
--	    select * into temporary mylist from shortlist order by 1
 
	    
	    -- select * from mylist -- temp table, delete first before running above query !

	    return	query    
	    select * from crosstab (
	    'select machineid, attribute, machine from mylist
		where attribute = ''attribute'' order by 1,2')
	    as mymachines(row_name text, machine1 text, machine2 text,machine3 text,machine4 text,machine5 text);	

	--return query select String::varchar
	-- return query select 'myResult'::varchar

end;
$function$
;


select * from public.pbd_get_machines_for_recipe_2(25)

-- Permissions

ALTER FUNCTION public.pbd_get_machines_for_recipe_1(int4) OWNER TO "PattynAdmin";
GRANT ALL ON FUNCTION public.pbd_get_machines_for_recipe_1(int4) TO "PattynAdmin";

	    
	    
	    

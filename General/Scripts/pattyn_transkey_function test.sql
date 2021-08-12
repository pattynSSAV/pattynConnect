

-- test section start
select * from capturetranslations limit(10) 
select distinct (c.language) from capturetranslations c 

select 'Concatenation'||' '||'of types : '||3||'?' as result

select split_part('_29_1_39_1','_',1) as s1, split_part('_29_1_39_1','_',2) as s2, split_part('_29_1_39_1','_',3) as s3, split_part('_29_1_39_1','_',4) as s4;

select case when (select c.language from capturetranslations c  where c.language = 'da_DK' limit(1)) is null
	then 'en_UK'
	else (select c.language from capturetranslations c  where c.language = 'da_DK' limit(1))
end as Testcol;
	-- test section end


-- Create function start
drop function public.pattyn_transskey( skey varchar(25),typeid integer, lang varchar(25));

create or replace function public.Pattyn_TransSkey ( skey varchar(25),typeid integer, lang varchar(25))
returns varchar(1000) as $TranslationFunction$
declare 
	S ALIAS for skey;
	T ALIAS for typeid;
	L ALIAS for lang; 
    generalSkey varchar(14);
    dLanguage varchar(5);
--    uKey varchar(25);
begin
	-- transform skey to general skey
	select into generalSkey '_'||split_part(S,'_',2)||'_1_'||split_part(S,'_',4)||'_'||split_part(S,'_',5); --in : _29_2_39_1 ==> _29_1_39_1
	-- check language variable, change to english if nok
	select into dLanguage case when (select c.language from capturetranslations c  where c.language = L limit(1)) is null
		then 'en_US'
		else (select c.language from capturetranslations c  where c.language = L limit(1))
		end;
	-- generate uKey 
	-- select into uKey dLanguage ||'_'||T||generalSkey;
	--get and return the translation
--	return c.translation from capturetranslations c where c.uniquekey = uKey limit(1);
	return c.translation from capturetranslations c where c.uniquekey = dLanguage ||'_'||T||generalSkey limit(1);

 
/*
usage :
select Pattyn_Transskey('_29_1_39_1','6','en_US') --Emergency stop 
select Pattyn_Transskey('_29_3_39_1','6','pl_PL') --Wylacznik awaryjny ==> let op de '3'
select Pattyn_Transskey('_29_1_39_1','6','da_DD') -- Emergency stop ==> taal bestaat niet ==> engels
select Pattyn_Transskey('_29_1_39_1','6','nl_BE') --Noodstop
*/

end;
$TranslationFunction$
language PLPGSQL 


-- Create function end

select Pattyn_Transskey('_29_1_39_1','6','en_US'), Pattyn_Transskey('_29_3_39_1','6','pl_PL'), Pattyn_Transskey('_29_1_39_1','6','da_DD'), Pattyn_Transskey('_29_1_39_1','6','nl_BE')


--select * from capturetranslations c where c.skey like '%_29_1_39_1' and typeid = '6'
select Pattyn_Transskey('_29_1_39_1','6','en_US') --Emergency stop 
select Pattyn_Transskey('_29_3_39_1','6','pl_PL') --Wylacznik awaryjny ==> let op de '3'
select Pattyn_Transskey('_29_1_39_1','6','da_DD') -- Emergency stop ==> taal bestaat niet ==> engels
select Pattyn_Transskey('_29_1_39_1','6','nl_BE') --Noodstop

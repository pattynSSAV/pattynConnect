select * from dba_log where logcomment like 'Refre%' limit 10

create view public.vw_dashboardlogs as 
select * from dba_log
where graf_organization is not null
and functionname is null;

select * from vw_dashboardlogs vd where logcomment like 'Refre%'
limit 10

select logtime,logcategory,logcomment,graf_organization,graf_username,graf_dashboard,sessionuser,graf_range
from vw_dashboardlogs vd where logcomment like 'Refre%' limit 20

drop view public.vw_dashboardlogs
CREATE OR REPLACE VIEW public.vw_dashboardlogs
AS SELECT dba_log.logtime,
    dba_log.logcategory,
    dba_log.logcomment,
    dba_log.graf_organizationid,
    dba_log.graf_organization,
    dba_log.graf_userid,
    dba_log.graf_username,
--    dba_log.graf_useremail,
    dba_log.graf_dashboard,
    dba_log.graf_range,
--    dba_log.functionname,
    dba_log.sessionuser
--    dba_log.searchpath,
--    dba_log.clientaddr,
--    dba_log.clientport
   FROM dba_log
  WHERE dba_log.graf_organization IS NOT NULL AND dba_log.functionname IS NULL;

-- Permissions

ALTER TABLE public.vw_dashboardlogs OWNER TO "PattynAdmin";
GRANT ALL ON TABLE public.vw_dashboardlogs TO "PattynAdmin";
GRANT SELECT ON TABLE public.vw_dashboardlogs TO public;

select pattyn_check_string('this is a dangerous text !;--')

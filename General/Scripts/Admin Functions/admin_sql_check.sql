
--drop function public.pattyn_check_string ( VARCHAR)
CREATE OR replace FUNCTION public.pattyn_check_string (in_string VARCHAR) 
RETURNS INT 

LANGUAGE plpgsql

as $$ 

 
DECLARE ret_val INTEGER := 1;

/* FUNCTION COMMENT : 
 * 
 * Created 	 : 20210728
 * CreatedBy : SSAV
 * 
 ----------------------------------------------------------------------------------
 * Change History : 
 *
 * 
 * ----------------------------------------------------------------------------------
 * Purpose : 
 * ----------------------------------------------------------------------------------
 * 	check (function) variables for dangerous patterns to avoid some basic "sql injection" issues
 *   
 * 
 * ----------------------------------------------------------------------------------
 * Inputs  : 
 * ----------------------------------------------------------------------------------
 * a text variable
 * 
 *
 * ----------------------------------------------------------------------------------
 * Output  : 
 * ----------------------------------------------------------------------------------
 * returns 1 if input string is OK, 0 otherwise

* ----------------------------------------------------------------------------------
* 
* Example of how to Use the function : 
*
* select pattyn_check_string('this is a dangerous text !;--')
* select pattyn_check_string('this is not a dangerous text !')
* 
* <in function example :> 
* if 	(pattyn_check_string(v_logcategory) = 0) 
		then raise exception 'input did not pass the SQL injection security test !'
				using hint = 'check the input variables for words like -end- -begin- -drop- ...';
		else
			-- do something here ;
		end if;
* 
* 
* see e.g. public.pattyn_dba_functionlogger() to see this function in action !
* ----------------------------------------------------------------------------------
* 
* 
* END OF FUNCTION COMMENT
*/ 
		

BEGIN
    ---assume ret_val=1;  
   
    IF (in_string like '%''%') then ret_val:=0;
    ELSEIF (in_string like '%--%') then ret_val:=0;
    ELSEIF (in_string like '%/*%') then ret_val:=0;
    ELSEIF (in_string like '%*/%') then ret_val:=0;
    ELSEIF (in_string like '%@') then ret_val:=0;
    ELSEIF (in_string like '%@@%') then ret_val:=0;
    ELSEIF (in_string like '%char%') then ret_val:=0;
    ELSEIF (in_string like '%nchar%') then ret_val:=0;
    ELSEIF (in_string like '%varchar%') then ret_val:=0;
    ELSEIF (in_string like '%nvarchar%') then ret_val:=0;
    
    ELSEIF (in_string like '%select%') then ret_val:=0;
    ELSEIF (in_string like '%insert%') then ret_val:=0;
    ELSEIF (in_string like '%update%') then ret_val:=0;
    ELSEIF (in_string like '%delete%') then ret_val:=0;
    ELSEIF (in_string like '%from%') then ret_val:=0;
    ELSEIF (in_string like '%table%') then ret_val:=0;
 
    ELSEIF (in_string like '%drop%') then ret_val:=0;
    ELSEIF (in_string like '%create%') then ret_val:=0;
    ELSEIF (in_string like '%alter%') then ret_val:=0;
 
    ELSEIF (in_string like '%begin%') then ret_val:=0;
    ELSEIF (in_string like '%end%') then ret_val:=0; --risky ? 
 
    ELSEIF (in_string like '%grant%') then ret_val:=0;
    ELSEIF (in_string like '%deny%') then ret_val:=0;
 
    ELSEIF (in_string like '%exec%') then ret_val:=0;
    ELSEIF (in_string like '%sp_%') then ret_val:=0;
    ELSEIF (in_string like '%xp_%') then ret_val:=0;
 
    ELSEIF (in_string like '%cursor%') then ret_val:=0;
    ELSEIF (in_string like '%fetch%') then ret_val:=0;
 
    ELSEIF (in_string like '%kill%') then ret_val:=0;
    ELSEIF (in_string like '%open%') then ret_val:=0;
 
    ELSEIF (in_string like '%sysobjects%') then ret_val:=0;
    ELSEIF (in_string like '%syscolumns%') then ret_val:=0;
    ELSEIF  (in_string like '%sys%') then ret_val:=0;
    end if;
    
 
    RETURN (ret_val);
 
END;
$$;


select pattyn_check_string('this is a dangerous text !;--')
select pattyn_check_string('this is not a dangerous text !')

-- test input


-- https://www.postgresql.org/docs/13/errcodes-appendix.html
-- Class 22
-- Class 42

CREATE TABLE public.example (
	id int4 NOT NULL GENERATED ALWAYS AS IDENTITY,
	line varchar(10) NULL,
	machine varchar(10) NULL,
	recipe varchar(10) NULL,
	nnumeric numeric NULL,
	bboolean bool NULL,
	iint int4 NULL,
	iint2 int2 NULL,
	iint4 int4 NULL,
	iint8 int8 NULL,
	rreal float4 NULL,
	ffloat4 float4 NULL,
	ffloat8 float8 NULL,
	sstring10 varchar(10) NULL
);

INSERT INTO public.example
(line, machine, recipe, nnumeric, bboolean, iint, iint2, iint4, iint8, rreal, ffloat4, ffloat8, sstring10)
VALUES('', '', '', 0, false, 0, 0, 0, 0, 0, 0, 0, '');


-- test boolean field error codes

INSERT INTO public.example (line, bboolean) VALUES('b1', NULL);
INSERT INTO public.example (line, bboolean) VALUES('b2', '0');
INSERT INTO public.example (line, bboolean) VALUES('b3', '1');
INSERT INTO public.example (line, bboolean) VALUES('b4', false);
INSERT INTO public.example (line, bboolean) VALUES('b5', true);

INSERT INTO public.example (line, bboolean) VALUES('b6', '2'); --SQL Error [22P02]: ERROR: invalid input syntax for type boolean: "2" 
INSERT INTO public.example (line, bboolean) VALUES('b6', 'a'); --SQL Error [22P02]: ERROR: invalid input syntax for type boolean: "a"
INSERT INTO public.example (line, bboolean) VALUES('b6', a); --SQL Error [42703]: ERROR: column "a" does not exist
INSERT INTO public.example (line, bboolean) VALUES('b6', 0); --SQL Error [42804]: ERROR: column "bboolean" is of type boolean but expression is of type integer.   Hint: You will need to rewrite or cast the expression.
INSERT INTO public.example (line, bboolean) VALUES('b6', -1); --SQL Error [42804]: ERROR: column "bboolean" is of type boolean but expression is of type integer.   Hint: You will need to rewrite or cast the expression.
INSERT INTO public.example (line, bboolean) VALUES('b6', 0.1); --SQL Error [42804]: ERROR: column "bboolean" is of type boolean but expression is of type numeric  Hint: You will need to rewrite or cast the expression.

select id, line, bboolean   from public.example where line like 'b_%' order by id asc

-- test integer field error codes - standard integer int = int4, precision 10 !

INSERT INTO public.example (line, iint) VALUES('int_1', NULL);
INSERT INTO public.example (line, iint) VALUES('int_2', 0);
INSERT INTO public.example (line, iint) VALUES('int_3', 330000);
INSERT INTO public.example (line, iint) VALUES('int_4', -330000);
INSERT INTO public.example (line, iint) VALUES('int_5', 1234567890); 

INSERT INTO public.example (line, iint) VALUES('int_6', 0.2); -- Wordt afgerond zonder foutmelding !
INSERT INTO public.example (line, iint) VALUES('int_7', 9.5); -- Wordt afgerond zonder foutmelding !
INSERT INTO public.example (line, iint) VALUES('int_8', -12.6); -- Wordt afgerond zonder foutmelding !
INSERT INTO public.example (line, iint) VALUES('int_9', 123456789.123); -- Wordt afgerond zonder foutmelding !

INSERT INTO public.example (line, iint) VALUES('int_9', 12345678901); --SQL Error [22003]: ERROR: integer out of range
INSERT INTO public.example (line, iint) VALUES('int_9', 'a'); --SQL Error [22P02]: ERROR: invalid input syntax for type integer: "a"

select id, line, iint  from public.example where line like 'int_%' order by id asc


-- test integer field error codes - integer = int2, precision 5 !

INSERT INTO public.example (line, iint2) VALUES('int2_1', NULL);
INSERT INTO public.example (line, iint2) VALUES('int2_2', 0);
INSERT INTO public.example (line, iint2) VALUES('int2_3', 12345);
INSERT INTO public.example (line, iint2) VALUES('int2_3', 123456); --SQL Error [22003]: ERROR: smallint out of range
INSERT INTO public.example (line, iint2) VALUES('int2_9', 'a'); --SQL Error [22P02]: ERROR: invalid input syntax for type smallint: "a"

select id, line, iint2  from public.example where line like 'int2_%' order by id asc

-- test integer field error codes - integer = int8, precision 19 !

INSERT INTO public.example (line, iint8) VALUES('int8_1', 1234567890123456789);
INSERT INTO public.example (line, iint8) VALUES('int8_2', 1234567890123456789.5555);
INSERT INTO public.example (line, iint8) VALUES('int8_3', 12345678901234567890); --SQL Error [22003]: ERROR: bigint out of range

select id, line, iint8  from public.example where line like 'int8_%' order by id asc

INSERT INTO public.example (line, rreal) VALUES('real_1', 123456789012345678);
INSERT INTO public.example (line, rreal) VALUES('real_1', 1234567890123456789);
INSERT INTO public.example (line, rreal) VALUES('real_1', 12345678901234567890); --SQL Error [22003]: ERROR: bigint out of range


select id, line, rreal  from public.example where line like 'real_%' order by id asc
delete from public.example where line like 'int8_%'

INSERT INTO public.example (line, sstring10) VALUES('string_1', 'tekst');
INSERT INTO public.example (line, sstring10) VALUES('string_1', 'tekst_tekst'); --SQL Error [22001]: ERROR: value too long for type character varying(10)



-- https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADMIN-DBOBJECT
-- https://www.postgresqltutorial.com/postgresql-database-indexes-table-size/

select pg_column_size() from public.example where line like 'real_%' order by id asc

select pg_total_relation_size() from public.example where line like 'real_%' order by id asc-- including indexes !!, in bytes

select pg_size_pretty (pg_column_size('public.example.rreal')) -- 
select pg_size_pretty (pg_relation_size('public.example')) --table only
select pg_size_pretty (pg_total_relation_size('public.example')) -- table including indexes or additional objects

-- column size ? 
select pg_column_size(a)
from (select iint8 from public.example)
s(a) 

select pg_column_size(a)
select pg_column_size(1::boolean)
select pg_column_size(1::smallint)
select pg_column_size(1::int)
select pg_column_size(1::bigint)

select pg_column_size(1::varchar(10))
select pg_column_size(1::varchar(20))
select pg_column_size(1::varchar(255))

select pg_column_size(12345::varchar(10))
select pg_column_size(12345::varchar(20))
select pg_column_size(12345::varchar(255))


select pg_column_size('tekst'::varchar(10))
select pg_column_size('tekst'::varchar(20))
select pg_column_size('tekst'::varchar(255))

select pg_column_size('tekst_tekst'::varchar(10))
select pg_column_size('tekst_tekst'::varchar(20))
select pg_column_size('tekst_tekst'::varchar(40))
select pg_column_size('tekst_tekst'::varchar(50))


select pg_column_size('tekst_tekst_tekst_tekst'::varchar(10))
select pg_column_size('tekst_tekst_tekst_tekst'::varchar(20))
select pg_column_size('tekst_tekst_tekst_tekst'::varchar(255))

select pg_column_size('tekst_tekst_tekst_tekst_tekst_tekst_tekst_tekst_'::varchar(10))
select pg_column_size('tekst_tekst_tekst_tekst_tekst_tekst_tekst_tekst'::varchar(20))
select pg_column_size('tekst_tekst_tekst_tekst_tekst_tekst_tekst_tekst'::varchar(50))
select pg_column_size('tekst_tekst_tekst_tekst_tekst_tekst_tekst_tekst'::varchar(255))


select pg_column_size(a)
from (select iint8 from public.example)
s(a) 


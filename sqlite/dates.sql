-- -- create tables with integers and date ranges -- --

-- build table _int_ of integer range --
-- this version doesn't use CTE, so works in pre-3.8.x sqlite3 --
-- 2^21 = 2m --

create temp table if not exists __tmp1 as
  select 0 as ix union values (1), (2), (3), (4), (5), (6), (7);

create temp table if not exists __tmp2 as
  select T.* from __tmp1 T join __tmp1 join __tmp1 join __tmp1  join __tmp1  join __tmp1; 

create table if not exists _int_ as
  select rowid ix from __tmp2; 

drop table if exists __tmp1;
drop table if exists __tmp2;


-- build table _dt_ of (text) date ranges --
-- from 2000-01-01 to 2099-12-31 --
create temp table if not exists __tmp1 as
select ix, date(ix+2415020 + 100*365+24) F 
from _int_ limit 365*100 + 25;

create table if not exists _dt_ as
select 
  ix,
  F,
  strftime('%Y', F) YY,
  strftime('%m', F) m,
  strftime('%d', F) d,
  strftime('%j', F) j,
  strftime('%w', F) w,
  replace(strftime('%w', F), '0', '7') u, 
  strftime('%W', F) WW
from __tmp1;

create index if not exists _dt_ix_ on _dt_ (
 ix, F, YY, m, d, j, w, u, WW
);

drop table if exists __tmp1;

create view if not exists _dt2_ as
select
  ix,
  F,
  YY,
  cast(YY % 100 as text) y,
  m,
  case when m='01' then 'Jan' when m='02' then 'Feb' when m='03' then 'Mar' when m='04' then 'Apr'  when m='05' then 'May' when m='06' then 'Jun'
       when m='07' then 'Jul' when m='08' then 'Aug' when m='09' then 'Sep' when m='10' then 'Oct'  when m='11' then 'Nov' when m='12' then 'Dec' end b,
--  strftime('%m', F) B  TBD,
  d,
  j,
  w,
  case when w='0' then 'Sun' when w='1' then 'Mon' when w='2' then 'Tue' when w='3' then 'Wed'  when w='4' then 'Thu' when w='5' then 'Fri' when w='6' then 'Sat' end a,
  case when w='0' then 'Sunday' when w='1' then 'Monday' when w='2' then 'Tuesday' when w='3' then 'Wednesday'  when w='4' then 'Thursday' when w='5' then 'Friday' when w='6' then 'Saturday' end AA,
  substr('00' || (((strftime('%j', date(F), '-3 days', 'weekday 4')) - 1) / 7 + 1), -2, 2) VV,
  strftime('%Y', F, '-3 days', 'weekday 4')  GG,
  strftime('%s', F) s,
  cast(replace(F,'-','') as int) iYmd
from
  _dt_
;


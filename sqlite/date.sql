-- build table _dt_ of (text) date ranges --
-- from 2000-01-01 to 2099-12-31 --

-- date(2415021) = '1900-01-01'
-- date(2451545) = '2000-01-01'

create table if not exists __tmp1 as
select 
  yyyy_mm_dd,
  replace(strftime('%w', yyyy_mm_dd), '0', '7') u, 
  substr('00' || (((strftime('%j', date(yyyy_mm_dd), '-3 days', 'weekday 4')) - 1) / 7 + 1), -2, 2) VV,
  strftime('%Y', yyyy_mm_dd, '-3 days', 'weekday 4')  GG
FROM (select date(i+2451545 ) AS yyyy_mm_dd FROM __seq LIMIT 365*100 + 25) ;

create table if not exists __iso8601 as
select 
  yyyy_mm_dd,
  GG || '-W' || VV || '-' || u AS yyyy_www_d,
  strftime('%Y',yyyy_mm_dd) || '-' ||strftime('%j',yyyy_mm_dd)  AS yyyy_ddd
from __tmp1;

create table if not exists __date as
select 
  yyyy_mm_dd,
  strftime('%Y')  yyyy,
  strftime('%m')  mm,
  strftime('%d')  dd,
  case when u='7' then 'Sun' when u='1' then 'Mon' when u='2' then 'Tue' when u='3' then 'Wed'  when u='4' then 'Thu' when u='5' then 'Fri' when u='6' then 'Sat' end wday,
  case when u='7' then 'Sunday' when u='1' then 'Monday' when u='2' then 'Tuesday' when u='3' then 'Wednesday'  when u='4' then 'Thursday' when u='5' then 'Friday' when u='6' then 'Saturday' end weekday
from __tmp1;


drop table __tmp1;

-- build table _seqdt of dates --
-- from 2001-01-01 to 2099-12-31 --

-- date(2415021) = '1900-01-01'
-- date(2451911) = '2001-01-01'

DROP TABLE IF EXISTS _seqdt;
CREATE TABLE _seqdt AS
SELECT
  yyyymmdd,
  strftime('%Y', yyyymmdd, '-3 days', 'weekday 4') || '-W' ||
  substr('00' || (((strftime('%j', date(yyyymmdd), '-3 days', 'weekday 4')) - 1) / 7 + 1), -2, 2)  || '-' ||
  replace(strftime('%w', yyyymmdd), '0', '7')  AS yyyywwwd,
  strftime('%Y',yyyymmdd) || '-' ||strftime('%j',yyyymmdd)  AS yyyy_ddd
FROM (
  SELECT date(i+2451911) AS yyyymmdd
  FROM _seq WHERE i<365*99+24
)
;

DROP TABLE IF EXISTS _dow;
CREATE TABLE _dow AS
SELECT '1' AS w, '1' AS u, 'Mon' AS wday, 'Monday' AS weekday
UNION  SELECT '2', '2', 'Tue', 'Tuesday'
UNION  SELECT '3', '3', 'Wed', 'Wednesday'
UNION  SELECT '4', '4', 'Thu', 'Thursday'
UNION  SELECT '5', '5', 'Fri', 'Friday'
UNION  SELECT '6', '6', 'Sat', 'Saturday'
UNION  SELECT '0', '7', 'Sun', 'Sunday'
ORDER BY u
;

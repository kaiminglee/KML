-- -- create table _seq sequence with column "i" with 8^6(=262144) integers

---- use CTE on version >= 3.8.3 
-- DROP TABLE IF EXISTS _seq;
-- CREATE TABLE _seq AS
-- WITH RECURSIVE
--   cnt(i) AS (VALUES(0) UNION ALL SELECT i+1 FROM cnt WHERE i<262143)
-- SELECT i FROM cnt;
 
---- without CTE
CREATE TEMP TABLE __t1 AS
  SELECT 0 UNION SELECT 1 UNION SELECT 2 UNION SELECT 3 
  UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7
; 
CREATE TEMP TABLE __t2 AS
  SELECT 0 FROM __t1, __t1, __t1, __t1, __t1, __t1; 
DROP TABLE IF EXISTS _seq;
CREATE TABLE _seq AS
  SELECT rowid-1 AS i FROM __t2;


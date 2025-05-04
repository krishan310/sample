with cte as (
select distinct a.store , b.quarter 
 from stores a cross join stores b 
 order by store)  
 select store ,quarter from ( 
 select  a.store , a.quarter , b.store as sat   from cte a left join stores b on a.store = b.store and a.quarter = b.quarter) temp 
 where sat  is NULL;  
 
 -- m2 
SELECT  store , concat ('Q' , 
cast((10-sum(DISTINCT CAST(RIGHT(quarter, 1) AS UNSIGNED)) ) as char(2)))
FROM stores group by store; 

WITH RECURSIVE ct AS (
  SELECT DISTINCT store, 1 AS q_no FROM stores
  UNION ALL
  SELECT store, q_no + 1 FROM ct WHERE q_no < 4
), 
cte as (
SELECT store , concat('Q' , cast(q_no as char(2))) as pk FROM ct) 
select * from cte a  left join stores b on a.store= b.store and a.pk = b.quarter ; 


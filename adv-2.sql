--  
-- WITH RECURSIVE batch_split AS (
--     SELECT batch_id, 1 AS qty
--     FROM batch
--     UNION ALL
--     SELECT cte.batch_id, cte.qty + 1 AS qty
--     FROM batch_split cte
--     JOIN batch b ON cte.batch_id = b.batch_id
--     WHERE cte.qty < b.quantity
-- ), 
--  orders_split as ( 
-- select order_number , 1 as qty from ord 
-- union all 
-- select cte.order_number  , cte.qty+1 as qty from 
-- orders_split cte join ord b on 
-- cte.order_number = b.order_number and 
-- cte.qty < b.quantity )  , 
-- cte as (
-- select order_number , 1 as qty , row_number() over() as rn 
--  from orders_split ) , 
--  cte2 as(
-- SELECT batch_id , 1 as qty , 
-- row_number() over() as rn  FROM batch_split) 
-- select a.order_number , b.batch_id , 
-- sum(b.qty) 
--  from cte a  left join cte2 b  on a.rn = b.rn
--  group by a.order_number , b.batch_id  
--  order by a.order_number , b.batch_id ; 
with batch_cte as 
        (select *, row_number() over(order by batch_id) as rn
        from (
            with recursive batch_split as
                (select batch_id, 1 as quantity from batch
                union all
                select b.batch_id, (cte.quantity+1) as quantity
                from batch_split cte
                join batch b on b.batch_id = cte.batch_id and b.quantity > cte.quantity)
            select batch_id, 1 as quantity
            from batch_split) x),
    order_cte as
        (select *, row_number() over(order by order_number) as rn
        from (
            with recursive order_split as
                (select order_number, 1 as quantity from orders
                union all
                select o.order_number, (cte.quantity+1) as quantity
                from order_split cte
                join orders o on o.order_number = cte.order_number and o.quantity > cte.quantity)
            select order_number, 1 as quantity
            from order_split) x)
select o.order_number, b.batch_id, sum(o.quantity) as quantity
from order_cte o
left join batch_cte b on o.rn = b.rn
group by o.order_number, b.batch_id
order by o.order_number, b.batch_id;

select instr('krishna','s') ;  
select substr('krishna' , 1 , 4 ); 
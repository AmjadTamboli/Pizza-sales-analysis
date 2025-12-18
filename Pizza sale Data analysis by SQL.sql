create database `Pizza DB`;
use `pizza DB`;

-- check table
select * from `pizza sales`;

-- change pizza_id and order_is data type as text
alter table `pizza sales` modify pizza_id text;
alter table `pizza sales` modify order_id text;
-- create a new column for order_date as data type as date
alter table `pizza sales`
add order_date1 date ;
set sql_safe_updates=0;
UPDATE `pizza sales`
SET order_date1 = STR_TO_DATE(order_date,"%d-%m-%Y")
where pizza_id>0;
update `pizza sales` set order_date=date_format(ORDER_DAte1,'%y-%m-%d')
where pizza_id>0;
alter table `pizza sales` modify order_date date;
alter table `pizza sales`
drop order_date1;
set sql_safe_updates=1;

-- create a time table and change order_time as time data type
alter	table `pizza sales`
add order_time1 time;
set sql_safe_updates=0;
update `pizza sales` 
set order_time1= order_time
where order_time regexp '^[0-9]{2}:[0-9]{2}:[0-9]{2}$';
update `pizza sales`
set order_time=null;
alter table `pizza sales` modify order_time time;
update `pizza sales` 
set order_time = order_time1
where order_time1 regexp '^[0-9]{2}:[0-9]{2}:[0-9]{2}$';
 alter table `pizza sales` drop order_time1;
set sql_safe_updates=1;

-- total revenue for KPI reqiorment
select cast(sum(total_price) as decimal(10,2)) revenue from `pizza sales`;
-- 817860.04

-- count average order values
select   (sum(total_price)/count(distinct order_id)) as 'Average order value' from `pizza sales`;
-- 38.30

-- total pizza sold
select sum(quantity) from `pizza sales`;
-- 49574

-- total orders
select  count(distinct order_id) as `total orders` from `pizza sales`;
-- 21350

-- Average order per Pizza
select cast(cast(sum(quantity) as decimal(10,2))/count(distinct order_id) as decimal(10,2)) as `Average pizza per order` 
from `pizza sales`;
-- 2.32

-- daily trend for total order
select dayofweek(order_date) as days,dayname(order_date)as `order Day`,count(distinct order_id) as `orders received` 
from `pizza sales`
group by dayname(order_date),dayofweek(order_date)
ORDER BY (DAYOFWEEK(order_date))asc;
-- every day sales are show

-- hourly trends for total orders
select hour(order_time)as `order time` ,count(distinct Order_id) as `Order Received` 
from `pizza sales`
group by hour(order_time);
-- show all order send as per hours

-- percentage of sales by pizza category
select pizza_category,cast((sum(total_price)/(select sum(total_price) from `pizza sales`)*100) AS decimal(10,2))as `Sale percentage`
from `pizza sales`
group by pizza_category;
-- a create a percetange 

-- percentage pizza sales as per size
select pizza_size,cast(sum(total_price) as decimal(10,2) ) as`sales Revenue`,
cast(sum(total_price)/(select sum(total_price) from `pizza sales`)*100 as decimal(10,2)) as `percentage sales`
from `pizza sales`
group by pizza_size;
-- a percetage sell be create

-- total pizza sold by pizza catagory
select Pizza_category,sum(quantity) as `pizza quantity` from `pizza sales`
group by pizza_category;
-- pizza solds

-- top 5 best seller by total pizza sold
select pizza_name,sum(quantity)as `pizza sold`
from `pizza sales`
group by pizza_name
order by sum(quantity)desc
limit 5;
-- top 5 selling pizza by quantity

-- bottom 5 wrost sold pizza 
select pizza_name,sum(quantity) as `pizza sold` from `pizza sales`
group by pizza_name
order by sum(quantity)
limit 5;





































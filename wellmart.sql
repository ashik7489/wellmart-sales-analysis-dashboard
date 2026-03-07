-- create database wellmart_dataset;
-- select * from wellmart;
use wellmart_dataset;

-- 1️⃣ Total kitni sales hui overall?
select sum(weekly_sales) from wellmart;
-- SELECT SUM(Weekly_Sales) FROM wellmart;

-- 2️⃣ Average weekly sales kya hai?
select avg(weekly_sales) from wellmart;
-- 3️⃣ Maximum sales kis week me hui?
select max(weekly_sales) from wellmart;
-- 4️⃣ Minimum sales kis week me hui?
select min(weekly_sales) from wellmart;
-- 5️⃣ Total kitne stores hain?
select count(distinct(store)) from wellmart;
-- 🟡 LEVEL 2 – Store Analysis

-- 6️⃣ Top 5 stores based on average sales?
select store,avg(weekly_sales)as top5 from wellmart
group by store
order by top5 desc
limit 5;
-- 7️⃣ Kaunsa store sabse stable hai? (Lowest STD logic manually)
select 
store,
stddev(weekly_sales) as top1
,
avg(weekly_sales)
from wellmart 
group by store
order by top1 
limit 1;
-- 8️⃣ Top 5 stores based on total revenue?
select store,
sum(weekly_sales)  as top5 from 
wellmart 
group by store 
order by top5 desc 
limit 5;
-- 9️⃣ Kaunsa store sabse weak performer hai?
select store,
sum(weekly_sales) as weak
from wellmart 
group by store 
order by weak 
limit 1;
-- 10️⃣ Har store ka total contribution % nikalna.
select 
store,
sum(weekly_sales) as total_weekly_sales,
round((sum(weekly_sales) / (select sum(weekly_sales) from wellmart))
  *100,2)
  as percentage
  from wellmart 
  group by store;
-- 🟠 LEVEL 3 – Time Based Analysis

-- 11️⃣ Year wise total sales?
alter table wellmart modify date date;

select year(date) as year_wise, sum(weekly_sales) as total 
from wellmart 
group by year_wise
-- 12️⃣ Year over year growth calculate karo.

-- 13️⃣ Month wise average -- 
select month(date), avg(weekly_sales) from 
wellmart 
group by month(date);
-- 14️⃣ Quarter wise sales?
select 
quarter(date) as q,
sum(weekly_sales) from wellmart
group by  q;
-- 15️⃣ Top 3 best performing months?
SELECT MONTH(DATE) , sum(weekly_sales) from 
wellmart
group by month(date)
order by sum(weekly_sales) desc 
limit 3;
-- 🔵 LEVEL 4 – Holiday Impact

-- 16️⃣ Holiday vs Non-Holiday average sales difference?
select holiday_flag, sum(weekly_sales) from 
wellmart
group by holiday_flag;
-- 17️⃣ Holiday weeks me total kitni sales hui?
select holiday_flag, sum(weekly_sales) from 
wellmart 
group by holiday_flag;
-- 18️⃣ Har store ka holiday impact compare karo.

-- 19️⃣ Kis month me holiday ka impact strongest tha?
SELECT 
    MONTHNAME(date) AS month,
    SUM(CASE 
        WHEN holiday_flag = 1 THEN weekly_sales 
        ELSE 0 
    END) AS holiday_sales
FROM wellmart
GROUP BY MONTHNAME(date)
ORDER BY holiday_sales DESC;
-- 🟣 LEVEL 5 – Economic Factor Analysis

-- 20️⃣ Fuel price aur sales ke beech relation?
select 
fuel_price,
avg(weekly_sales) as wk from
wellmart 
group by fuel_price 
order by wk desc;
-- 21️⃣ Unemployment high hone par sales pe kya effect?
SELECT 
    CORR(unemployment, weekly_sales) AS unemployment_sales_correlation
FROM wellmart;
-- 22️⃣ CPI aur sales ka average compare karo.
select 
   avg(cpi) as cpi_avg
,
avg(weekly_sales) as wks
from wellmart;
-- 23️⃣ Temperature extreme hone par sales change hoti hai kya?

-- 🔴 LEVEL 6 – Advanced (Interview Level)

-- 24️⃣ Top 10 highest sales weeks identify karo.
select 
date,
sum(weekly_sales) as top10 
from wellmart 
group by date
order by top10 desc 
limit 10;
-- 25️⃣ Har year ka best performing store kaun tha?
select year,
 sum(weekly_sales) topstore 
 from wellmart 
 group by year;
 select * from (
 select year,store,
 sum(weekly_sales) as top,
 rank() over(partition by year order by sum(weekly_sales) desc) as rnk
 from wellmart
 group by store,year ) t
 where rnk=1;
 
-- 26️⃣ Ranking function use karke store ranking nikalo.
select 
store, 
sum(weekly_sales) as top_store,
rank() over(order by sum(weekly_sales) desc ) as rnk
from wellmart
group by store;
-- 27️⃣ Running total sales calculate karo.
select 
date,
sum(weekly_sales) as weekly_sales ,
sum(sum(weekly_sales)) over (order by date ) as runing_total
from wellmart 
group by date;
-- 28️⃣ Moving average (4 week) nikal sakte ho?
SELECT 
    date,
    weekly_sales,
    
    AVG(weekly_sales) OVER(
        ORDER BY date
        ROWS BETWEEN 3 PRECEDING AND CURRENT ROW
    ) AS moving_avg_4_week

FROM wellmart
ORDER BY date;
-- 29️⃣ Top 3 stores har quarter me?
select * from (select year,
store,
quarter(date),
sum(weekly_sales) as top
,rank() over(partition by year, quarter(date) order by sum(weekly_sales) desc ) as rnk 
from wellmart 
group by year,quarter(date),store) t
where rnk<=3;



-- 30️⃣ Kis year me sabse zyada volatility thi?

SELECT 
    Year,
    STDDEV(Weekly_Sales) AS sales_volatility
FROM wellmart
GROUP BY Year
ORDER BY sales_volatility DESC;
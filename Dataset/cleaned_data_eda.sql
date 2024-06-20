select * from new_table; 
select count(*) from new_table; 
select 
	round(avg(Quantity),2) as mean_Quantity,
	round(avg(ReturnQuantity),2) as mean_ReturnQuantity,
	round(avg(Final_cost),2) as mean_Final_cost,
	round(avg(Final_Sales),2) as mean_Final_Sales,
	round(avg(RtnMPR),2) as mean_RtnMPR 
	from
	new_table; 
    
    with ranked as 
(
select Final_cost, 
Final_Sales, 
Quantity, 
ReturnQuantity, 
RtnMPR,
row_number() over (order by Final_cost) as r,
count(*) over () as c 
from new_table),
median as 
( 
select Final_cost, 
Final_Sales, 
Quantity, 
ReturnQuantity, 
RtnMPR 
from ranked 
where r in (floor((c+1)/2),ceiling((c+1)/2))
)
select round(avg(Final_cost), 2),
round(avg(Final_Sales),2),
round(avg(Quantity),2),
round(avg(ReturnQuantity),2),
round(avg(RtnMPR),2) 
from median;  

select 
mode_Quantity.mode_value as mode_Quantity,
mode_Quantity.mode_count as mode_Quantity_count,
mode_ReturnQuantity.mode_value as mode_ReturnQuantity,
mode_ReturnQuantity.mode_count as mode_ReturnQuantity_count,
mode_Final_Sales.mode_value as mode_Final_Sales,
mode_Final_Sales.mode_count as mode_Final_Sales_count,
mode_Final_cost.mode_value as mode_Final_cost,
mode_Final_cost.mode_count as mode_Final_cost_count,
mode_RtnMPR.mode_value as mode_RtnMPR,
mode_RtnMPR.mode_count as mode_RtnMPR_count
from(
 SELECT Quantity AS mode_value, COUNT(*) AS mode_count
 FROM new_table
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1 ) as mode_Quantity,
 ( SELECT ReturnQuantity AS mode_value, COUNT(*) AS mode_count
 FROM new_table
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1
 ) as mode_ReturnQuantity,
 (SELECT final_cost AS mode_value, COUNT(*) AS mode_count
 FROM new_table
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1
 ) as mode_Final_cost,
 (SELECT Final_Sales AS mode_value, COUNT(*) AS mode_count
 FROM new_table
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1
 ) as mode_Final_Sales,
 ( select RtnMPR AS mode_value, COUNT(*) AS mode_count
 FROM new_table
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1
 ) as mode_RtnMPR; 
 
 
 SELECT
 ROUND(VARIANCE(Quantity), 2) AS variance_quantity,
 ROUND(VARIANCE(ReturnQuantity), 2) AS variance_return_quantity,
 ROUND(VARIANCE(Final_Cost), 2) AS variance_final_cost,
 ROUND(VARIANCE(Final_Sales), 2) AS variance_final_sales,
 ROUND(VARIANCE(RtnMPR), 2) AS variance_rtnmrp
FROM new_table; 

SELECT
 ROUND(STDDEV(Quantity), 2) AS stddev_quantity,
 ROUND(STDDEV(ReturnQuantity), 2) AS stddev_return_quantity,
 ROUND(STDDEV(Final_Cost), 2) AS stddev_final_cost,
 ROUND(STDDEV(Final_Sales), 2) AS stddev_final_sales,
 ROUND(STDDEV(RtnMPR), 2) AS stddev_rtnmrp
FROM new_table; 
-- Range:
SELECT
 MAX(Quantity) - MIN(Quantity) AS range_quantity,
 MAX(ReturnQuantity) - MIN(ReturnQuantity) AS range_return_quantity,
 MAX(Final_Cost) - MIN(Final_Cost) AS range_final_cost,
 MAX(Final_Sales) - MIN(Final_Sales) AS range_final_sales,
 MAX(RtnMPR) - MIN(RtnMPR) AS range_rtnmrp
FROM new_table; 

select Quantity_skewness1.Quantity_skewness,
ReturnQuantity_skewness1.ReturnQuantity_skewness,
Final_cost_skewness1.Final_cost_skewness,
Final_Sales_skewness1.Final_Sales_skewness,
RtnMPR_skewness1.RtnMPR_skewness
from 
(SELECT 
ROUND((SUM(POW(Quantity - (SELECT AVG(Quantity) FROM new_table), 3)) / (COUNT(*) * 
POW(STDDEV(Quantity), 3))), 2) AS Quantity_skewness
FROM new_table) Quantity_skewness1, 
(select 
round((sum(pow(ReturnQuantity - (select avg(ReturnQuantity) from new_table),3))/(count(*) * 
pow(stddev(ReturnQuantity),3))),2) as  ReturnQuantity_skewness from new_table) 
ReturnQuantity_skewness1,
(select 
round((sum(pow(Final_cost - (select avg(Final_cost) from new_table),3))/(count(*) * 
pow(stddev(Final_cost),3))),2) as  Final_cost_skewness from new_table) 
Final_cost_skewness1,
 (
select 
round((sum(pow(Final_Sales - (select avg(Final_Sales) from new_table),3))/(count(*) * 
pow(stddev(Final_Sales),3))),2) as  Final_Sales_skewness from new_table) 
Final_Sales_skewness1, 
(select 
round((sum(pow(RtnMPR - (select avg(RtnMPR) from new_table),3))/(count(*) * 
pow(stddev(RtnMPR),3))),2) as  RtnMPR_skewness from new_table) 
RtnMPR_skewness1;  









select
kurtosis_quantity1.kurtosis_quantity,
kurtosis_Returnquantity1.kurtosis_Returnquantity,
kurtosis_Final_cost1.kurtosis_Final_cost, 
kurtosis_Final_Sales1.kurtosis_Final_Sales,
kurtosis_RtnMPR1.kurtosis_RtnMPR
from 
(SELECT 
ROUND((SUM(POWER(Quantity - (SELECT AVG(Quantity) FROM new_table), 4)) / (COUNT(Quantity) * POWER(STDDEV(Quantity), 
4))), 2) AS kurtosis_quantity 
from new_table) kurtosis_quantity1,
(SELECT 
ROUND((SUM(POWER(ReturnQuantity - (SELECT AVG(ReturnQuantity) FROM new_table), 4)) / (COUNT(ReturnQuantity) * POWER(STDDEV(ReturnQuantity), 
4))), 2) AS kurtosis_Returnquantity 
from new_table) kurtosis_Returnquantity1,
(SELECT 
ROUND((SUM(POWER(Final_cost - (SELECT AVG(Final_cost) FROM new_table), 4)) / (COUNT(Final_cost) * POWER(STDDEV(Final_cost), 
4))), 2) AS kurtosis_Final_cost 
from new_table) kurtosis_Final_cost1,
(SELECT 
ROUND((SUM(POWER(Final_Sales - (SELECT AVG(Final_Sales) FROM new_table), 4)) / (COUNT(Final_Sales) * POWER(STDDEV(Final_Sales), 
4))), 2) AS kurtosis_Final_Sales 
from new_table) kurtosis_Final_Sales1,
(SELECT 
ROUND((SUM(POWER(RtnMPR - (SELECT AVG(RtnMPR) FROM new_table), 4)) / (COUNT(RtnMPR) * POWER(STDDEV(RtnMPR), 
4))), 2) AS kurtosis_RtnMPR 
from new_table) kurtosis_RtnMPR1;medicine_detail_backup
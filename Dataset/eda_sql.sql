use medicines_db; 

select * from medicine_detail; 

ALTER TABLE medicine_detail DROP column Patient_ID ; 

ALTER TABLE medicine_detail modify Dateofbill Date;
SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE "secure_file_priv";


load data local infile 'C://ProgramData//MySQL//MySQL Server 8.0//Uploads//Medical Inventory Optimaization Dataset.csv' into table medicine_detail
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows; 
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Medical Inventory Optimaization Dataset.csv'
INTO TABLE medicine_detail
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SHOW VARIABLES LIKE 'local_infile';
SET GLOBAL local_infile = 1; 










LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Medical Inventory Optimaization Dataset.csv'
INTO TABLE medicine_detail
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
SET Dateofbill = STR_TO_DATE(@Dateofbill, '%m/%d/%Y');


ALTER TABLE medicine_detail modify DrugName VARCHAR (500);



select count(*) from medicine_detail;
select Typeofsales, Specialisation, Dept, Dateofbill, Quantity, ReturnQuantity, 
Final_cost, Final_Sales, RtnMPR, Formulation, DrugName, SubCat, SubCat1, count(*)
from medicine_detail
GROUP BY Typeofsales, Specialisation, Dept, Dateofbill, Quantity, ReturnQuantity, 
Final_cost, Final_Sales, RtnMPR, Formulation, DrugName, SubCat, SubCat1
HAVING COUNT(*) > 1;

select count(*) from medicine_detail;

SELECT VERSION(); 

SHOW VARIABLES LIKE "%version%";  

select * from medicine_detail;  

-- calculate mean median and mode and measure of central tendancy

	select 
	round(avg(Quantity),2) as mean_Quantity,
	round(avg(ReturnQuantity),2) as mean_ReturnQuantity,
	round(avg(Final_cost),2) as mean_Final_cost,
	round(avg(Final_Sales),2) as mean_Final_Sales,
	round(avg(RtnMPR),2) as mean_RtnMPR 
	from
	medicine_detail;


SELECT 
 ROUND(AVG(Final_Cost), 2) AS median_final_cost,
 ROUND(AVG(Final_Sales), 2) AS median_final_sales,
 ROUND(AVG(Quantity), 2) AS median_quantity,
 ROUND(AVG(ReturnQuantity), 2) AS median_return_quantity,
 ROUND(AVG(RtnMPR), 2) AS median_rtnmrp
FROM (
 SELECT Final_Cost, Final_Sales, Quantity, ReturnQuantity, RtnMPR,
 ROW_NUMBER() OVER (ORDER BY Final_Cost) AS row_num,
 COUNT(*) OVER () AS total_rows FROM medicine_detail
) AS subquery
WHERE row_num IN (FLOOR((total_rows + 1) / 2), CEILING((total_rows + 1) / 2)); 


with ranked as 
(
select Final_cost, 
Final_Sales, 
Quantity, 
ReturnQuantity, 
RtnMPR,
row_number() over (order by Final_cost) as r,
count(*) over () as c 
from medicine_detail),
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
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1 ) as mode_Quantity,
 ( SELECT ReturnQuantity AS mode_value, COUNT(*) AS mode_count
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1
 ) as mode_ReturnQuantity,
 (SELECT final_cost AS mode_value, COUNT(*) AS mode_count
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1
 ) as mode_Final_cost,
 (SELECT Final_Sales AS mode_value, COUNT(*) AS mode_count
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1
 ) as mode_Final_Sales,
 ( select RtnMPR AS mode_value, COUNT(*) AS mode_count
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1
 ) as mode_RtnMPR;


 SELECT Quantity AS mode_value, COUNT(*) AS mode_count
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1 ;
SELECT ReturnQuantity AS mode_value, COUNT(*) AS mode_count
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1 ; 
SELECT final_cost AS mode_value, COUNT(*) AS mode_count
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1 ; 
SELECT Final_Sales AS mode_value, COUNT(*) AS mode_count
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1 ; 
 
select RtnMPR AS mode_value, COUNT(*) AS mode_count
 FROM medicine_detail
 GROUP BY Quantity
 ORDER BY COUNT(*) DESC
 LIMIT 1; 
 
 -- measure of dispersion and standard deviation 
 
 SELECT
 ROUND(VARIANCE(Quantity), 2) AS variance_quantity,
 ROUND(VARIANCE(ReturnQuantity), 2) AS variance_return_quantity,
 ROUND(VARIANCE(Final_Cost), 2) AS variance_final_cost,
 ROUND(VARIANCE(Final_Sales), 2) AS variance_final_sales,
 ROUND(VARIANCE(RtnMPR), 2) AS variance_rtnmrp
FROM medicine_detail; 


SELECT
 ROUND(STDDEV(Quantity), 2) AS stddev_quantity,
 ROUND(STDDEV(ReturnQuantity), 2) AS stddev_return_quantity,
 ROUND(STDDEV(Final_Cost), 2) AS stddev_final_cost,
 ROUND(STDDEV(Final_Sales), 2) AS stddev_final_sales,
 ROUND(STDDEV(RtnMPR), 2) AS stddev_rtnmrp
FROM medicine_detail;


-- Range:
SELECT
 MAX(Quantity) - MIN(Quantity) AS range_quantity,
 MAX(ReturnQuantity) - MIN(ReturnQuantity) AS range_return_quantity,
 MAX(Final_Cost) - MIN(Final_Cost) AS range_final_cost,
 MAX(Final_Sales) - MIN(Final_Sales) AS range_final_sales,
 MAX(RtnMPR) - MIN(RtnMPR) AS range_rtnmrp
FROM medicine_detail; 

-- skewness and curtoisis 
select Quantity_skewness1.Quantity_skewness,
ReturnQuantity_skewness1.ReturnQuantity_skewness,
Final_cost_skewness1.Final_cost_skewness,
Final_Sales_skewness1.Final_Sales_skewness,
RtnMPR_skewness1.RtnMPR_skewness
from 
(SELECT 
ROUND((SUM(POW(Quantity - (SELECT AVG(Quantity) FROM medicine_detail), 3)) / (COUNT(*) * 
POW(STDDEV(Quantity), 3))), 2) AS Quantity_skewness
FROM medicine_detail) Quantity_skewness1, 
(select 
round((sum(pow(ReturnQuantity - (select avg(ReturnQuantity) from medicine_detail),3))/(count(*) * 
pow(stddev(ReturnQuantity),3))),2) as  ReturnQuantity_skewness from medicine_detail) 
ReturnQuantity_skewness1,
(select 
round((sum(pow(Final_cost - (select avg(Final_cost) from medicine_detail),3))/(count(*) * 
pow(stddev(Final_cost),3))),2) as  Final_cost_skewness from medicine_detail) 
Final_cost_skewness1,
 (
select 
round((sum(pow(Final_Sales - (select avg(Final_Sales) from medicine_detail),3))/(count(*) * 
pow(stddev(Final_Sales),3))),2) as  Final_Sales_skewness from medicine_detail) 
Final_Sales_skewness1, 
(select 
round((sum(pow(RtnMPR - (select avg(RtnMPR) from medicine_detail),3))/(count(*) * 
pow(stddev(RtnMPR),3))),2) as  RtnMPR_skewness from medicine_detail) 
RtnMPR_skewness1;  



 










































select
kurtosis_quantity1.kurtosis_quantity,
kurtosis_Returnquantity1.kurtosis_Returnquantity,
kurtosis_Final_cost1.kurtosis_Final_cost, 
kurtosis_Final_Sales1.kurtosis_Final_Sales,
kurtosis_RtnMPR1.kurtosis_RtnMPR
from 
(SELECT 
ROUND((SUM(POWER(Quantity - (SELECT AVG(Quantity) FROM medicine_detail), 4)) / (COUNT(Quantity) * POWER(STDDEV(Quantity), 
4))), 2) AS kurtosis_quantity 
from medicine_detail) kurtosis_quantity1,
(SELECT 
ROUND((SUM(POWER(ReturnQuantity - (SELECT AVG(ReturnQuantity) FROM medicine_detail), 4)) / (COUNT(ReturnQuantity) * POWER(STDDEV(ReturnQuantity), 
4))), 2) AS kurtosis_Returnquantity 
from medicine_detail) kurtosis_Returnquantity1,
(SELECT 
ROUND((SUM(POWER(Final_cost - (SELECT AVG(Final_cost) FROM medicine_detail), 4)) / (COUNT(Final_cost) * POWER(STDDEV(Final_cost), 
4))), 2) AS kurtosis_Final_cost 
from medicine_detail) kurtosis_Final_cost1,
(SELECT 
ROUND((SUM(POWER(Final_Sales - (SELECT AVG(Final_Sales) FROM medicine_detail), 4)) / (COUNT(Final_Sales) * POWER(STDDEV(Final_Sales), 
4))), 2) AS kurtosis_Final_Sales 
from medicine_detail) kurtosis_Final_Sales1,
(SELECT 
ROUND((SUM(POWER(RtnMPR - (SELECT AVG(RtnMPR) FROM medicine_detail), 4)) / (COUNT(RtnMPR) * POWER(STDDEV(RtnMPR), 
4))), 2) AS kurtosis_RtnMPR 
from medicine_detail) kurtosis_RtnMPR1;





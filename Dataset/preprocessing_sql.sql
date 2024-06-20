select * from medicine_detail limit 10; 

describe medicines_db; 

describe medicine_detail; 
select Dateofbill from medicine_detail;

SELECT
 COUNT(CASE WHEN TRIM(Typeofsales) = '' OR Typeofsales IS NULL THEN 1 END) AS 
typeofsales_missing,
 COUNT(CASE WHEN TRIM(Typeofsales) <> '' AND Typeofsales IS NOT NULL THEN 1 END) AS 
typeofsales_non_missing,
count(case when trim(Typeofsales) = '' or Typeofsales is null then 1 end) as Typeofsales_missing,
count(case when trim(Typeofsales) <> '' or Typeofsales is not null then 1 end) as Typeofsales_non_missing,
COUNT(CASE WHEN TRIM(Specialisation) = '' OR Specialisation IS NULL THEN 1 END) AS 
specialisation_missing,
 COUNT(CASE WHEN TRIM(Specialisation) <> '' AND Specialisation IS NOT NULL THEN 1 END) AS 
specialisation_non_missing ,
COUNT(CASE WHEN TRIM(Dept) = '' OR Dept IS NULL THEN 1 END) AS dept_missing,
 COUNT(CASE WHEN TRIM(Dept) <> '' AND Dept IS NOT NULL THEN 1 END) AS dept_non_missing,
  COUNT(CASE WHEN TRIM(Dateofbill) = '' OR Dateofbill IS NULL THEN 1 END) AS dateofbill_missing,
 COUNT(CASE WHEN TRIM(Dateofbill) <> '' AND Dateofbill IS NOT NULL THEN 1 END) AS 
dateofbill_non_missing,
COUNT(CASE WHEN Quantity IS NULL THEN 1 END) AS quantity_missing,
 COUNT(CASE WHEN Quantity IS NOT NULL THEN 1 END) AS quantity_non_missing,
 
 COUNT(CASE WHEN ReturnQuantity IS NULL THEN 1 END) AS returnquantity_missing,
 COUNT(CASE WHEN ReturnQuantity IS NOT NULL THEN 1 END) AS returnquantity_non_missing,
 COUNT(CASE WHEN Final_Cost IS NULL THEN 1 END) AS final_cost_missing,
 COUNT(CASE WHEN Final_Cost IS NOT NULL THEN 1 END) AS final_cost_non_missing,
 COUNT(CASE WHEN Final_Sales IS NULL THEN 1 END) AS final_sales_missing,
 COUNT(CASE WHEN Final_Sales IS NOT NULL THEN 1 END) AS final_sales_non_missing,
 COUNT(CASE WHEN RtnMPR IS NULL THEN 1 END) AS rtnmrp_missing,
 COUNT(CASE WHEN RtnMPR IS NOT NULL THEN 1 END) AS rtnmrp_non_missing,
 COUNT(CASE WHEN TRIM(Formulation) = '' OR Formulation IS NULL THEN 1 END) AS 
formulation_missing,
 COUNT(CASE WHEN TRIM(Formulation) <> '' AND Formulation IS NOT NULL THEN 1 END) AS 
formulation_non_missing,
 COUNT(CASE WHEN TRIM(DrugName) = '' OR DrugName IS NULL THEN 1 END) AS 
drugname_missing,
 COUNT(CASE WHEN TRIM(DrugName) <> '' AND DrugName IS NOT NULL THEN 1 END) AS 
drugname_non_missing,
 COUNT(CASE WHEN TRIM(SubCat) = '' OR SubCat IS NULL THEN 1 END) AS subcat_missing,
 COUNT(CASE WHEN TRIM(SubCat) <> '' AND SubCat IS NOT NULL THEN 1 END) AS 
 subcat_non_missing,
 COUNT(CASE WHEN TRIM(SubCat1) = '' OR SubCat1 IS NULL THEN 1 END) AS subcat1_missing,
 COUNT(CASE WHEN TRIM(SubCat1) <> '' AND SubCat1 IS NOT NULL THEN 1 END) AS 
subcat1_non_missing,
 COUNT(*) AS total_rows
FROM medicine_detail; 


UPDATE medicine_detail
SET
Formulation = CASE WHEN Formulation = '' THEN 'unknown' ELSE Formulation END;

select formulation from medicine_detail; 
select count(formulation) from medicine_detail where formulation = 'unknown'; 

UPDATE medicine_detail
SET
Formulation = CASE WHEN Formulation = 'unknown' THEN '' ELSE Formulation END; 

UPDATE medicine_detail
SET
DrugName = CASE WHEN DrugName = '' THEN 'unknown' ELSE DrugName END; 

UPDATE medicine_detail
SET
SubCat = CASE WHEN SubCat = '' THEN 'unknown' ELSE SubCat END; 
UPDATE medicine_detail
SET
SubCat1 = CASE WHEN SubCat1 = '' THEN 'unknown' ELSE SubCat1 END; 

select Formulation, DrugName,SubCat,SubCat1 from medicine_detail; 

CREATE TABLE missing_values AS
SELECT *
FROM medicine_detail
WHERE Formulation = 'unknown'
 OR DrugName = 'unknown'
 OR SubCat = 'unknown'
 OR SubCat1 = 'unknown'; 
 
 select * from missing_values;  
 select count(*) as missing_recods_count from missing_values; 
 
select Typeofsales, Specialisation, Dept, Dateofbill, Quantity, ReturnQuantity, 
Final_cost, Final_Sales, RtnMPR, Formulation, DrugName, SubCat, SubCat1, count(*)
from medicine_detail
WHERE Formulation<>'unknown'and DrugName <> 'unknown'and SubCat <> 'unknown' and subcat1 <>'unknown'
GROUP BY Typeofsales, Specialisation, Dept, Dateofbill, Quantity, ReturnQuantity, 
Final_cost, Final_Sales, RtnMPR, Formulation, DrugName, SubCat, SubCat1
HAVING COUNT(*) > 1; 

DELETE FROM medicine_detail
WHERE (Typeofsales, Specialisation, Dept, Dateofbill, Quantity, ReturnQuantity, 
Final_cost, Final_Sales, RtnMPR, Formulation, DrugName, SubCat, SubCat1) IN (
 SELECT t.Typeofsales, t.Specialisation, t.Dept,t.Dateofbill,t.Quantity,
 t.ReturnQuantity,t.Final_cost,t.Final_Sales,t.RtnMPR,t.Formulation,t.DrugName,t.SubCat,t.SubCat1
 FROM (
 SELECT Typeofsales, Specialisation, Dept, Dateofbill, Quantity, ReturnQuantity, 
Final_cost, Final_Sales, RtnMPR, Formulation, DrugName, SubCat, SubCat1
 FROM medicine_detail
 WHERE Formulation<>'unknown'and DrugName <> 'unknown'and SubCat <> 'unknown' and subcat1 <>'unknown'
 GROUP BY Typeofsales, Specialisation, Dept, Dateofbill, Quantity, ReturnQuantity, 
Final_cost, Final_Sales, RtnMPR, Formulation, DrugName, SubCat, SubCat1
 HAVING COUNT(*) > 1
 ) AS t
);
SELECT COUNT(*) AS total_rows FROM medicine_detail;



SELECT DISTINCT *
FROM your_table; 

select count(*) from medicine_detail; 

select * from medicine_detail;  

CREATE TABLE new_table AS
SELECT *
FROM medicine_detail
WHERE Quantity BETWEEN
 (SELECT AVG(Quantity) - 3 * STDDEV(Quantity) FROM medicine_detail)
 AND
 (SELECT AVG(Quantity) + 3 * STDDEV(Quantity) FROM medicine_detail) 
 AND ReturnQuantity BETWEEN
 (SELECT AVG(ReturnQuantity) - 3 * STDDEV(ReturnQuantity) FROM medicine_detail)
 AND
 (SELECT AVG(ReturnQuantity) + 3 * STDDEV(ReturnQuantity) FROM medicine_detail)
 AND Final_Cost BETWEEN
 (SELECT AVG(Final_Cost) - 3 * STDDEV(Final_Cost) FROM medicine_detail)
 AND
 (SELECT AVG(Final_Cost) + 3 * STDDEV(Final_Cost) FROM medicine_detail)
 AND Final_Sales BETWEEN
 (SELECT AVG(Final_Sales) - 3 * STDDEV(Final_Sales) FROM medicine_detail)
 AND
 (SELECT AVG(Final_Sales) + 3 * STDDEV(Final_Sales) FROM medicine_detail) 
 AND RtnMPR BETWEEN
 (SELECT AVG(RtnMPR) - 3 * STDDEV(RtnMPR) FROM medicine_detail)
 AND
 (SELECT AVG(RtnMPR) + 3 * STDDEV(RtnMPR) FROM medicine_detail); 
 
 select count(*) as total_rows from new_table;  
 
select count(*) from  medicine_detail; 


 

  
  


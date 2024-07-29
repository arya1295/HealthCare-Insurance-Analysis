create database HIA;
use HIA;
select * from `hospitalisation details`;
select * from `medical examinations`;
select * from names;



alter table names rename column name to Name ;
alter table names rename column `ï»¿Customer ID` to `Customer ID` ;

ALTER TABLE `hospitalisation details`
ADD COLUMN `Age` INT;

UPDATE `hospitalisation details`
SET `Age` = YEAR(CURDATE()) - `year`;

#1.To gain a comprehensive understanding of the factors influencing hospitalization costs
#a.Merge the two tables by first identifying the columns in the data tables that will help you in merging

SELECT 
    h.`Customer ID`, 
    h.children, 
    h.charges, 
    h.`Hospital tier`, 
    h.`City tier`, 
    h.`State ID`,
    d.BMI, 
    d.HBA1C, 
    d.`Heart Issues`, 
    d.`Any Transplants`, 
    d.`Cancer history`, 
    d.NumberOfMajorSurgeries, 
    d.smoker
FROM 
    `hospitalisation details` h
INNER JOIN 
    `medical examinations` d ON h.`Customer ID`= d.`Customer ID`;

#In both tables, add a Primary Key constraint for these columns
-- Adding a primary key to the Hospitalizations table
ALTER TABLE `hospitalisation details`
ADD CONSTRAINT PK_CustID PRIMARY KEY (`Customer ID`(10));

-- Adding a primary key to the HealthDetails table
ALTER TABLE `medical examinations`
ADD CONSTRAINT PK_CustomerID PRIMARY KEY (`Customer ID`(10));

#Deleting the row where the customer Id=?.
select * from `hospitalisation details` where `Customer ID` ='?';
delete from `hospitalisation details` where `Customer ID` = '?';

#2.Retrieve information about people who are diabetic and have heart problems with their average age, the average number of dependent children, average BMI, and average hospitalization costs

SELECT 
    AVG(hd.`Age`) AS AverageAge,
    AVG(hd.`children`) AS AverageChildren,
    AVG(me.`BMI`) AS AverageBMI,
    AVG(hd.`charges`) AS AverageHospitalizationCosts
FROM 
    `hospitalisation details` hd
JOIN 
    `medical examinations` me ON hd.`Customer ID` = me.`Customer ID`
WHERE 
    me.`HBA1C` >= 6.5 
    AND me.`Heart Issues` = 'Yes';
    
 #3.Find the average hospitalization cost for each hospital tier and each city level   

SELECT 
    `Hospital tier`, 
    `City tier`, 
    AVG(`charges`) AS AverageHospitalizationCost
FROM 
    `hospitalisation details`
GROUP BY 
    `Hospital tier`, 
    `City tier` ;
    
#4.Determine the number of people who have had major surgery with a history of cancer
SELECT COUNT(*) AS NumberOfPeople
FROM `medical examinations`
WHERE `Cancer History` = 'Yes'
  AND `NumberOfMajorSurgeries` > 0;
  
#5.Determine the number of tier-1 hospitals in each state

SELECT 
    `State ID`, 
    COUNT(DISTINCT `Hospital tier`) AS NumberOfTier1Hospitals
FROM 
    `hospitalisation details`
WHERE 
    `Hospital Tier` = 'tier - 1'
GROUP BY 
    `State ID`;
    
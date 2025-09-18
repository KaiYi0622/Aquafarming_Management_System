-- Query 1
-- Calculate revenue for each fish species in half a year 
-- Eg. second half of year
SELECT F.Species_ID AS SP_ID,
	   F.Species_name,
	   F.Market_value,
	   SUM(SD.Weight_sold) AS Weight_sold,
       ROUND(SUM(SD.Weight_sold * F.Market_value), 2) AS Revenue
FROM Sales S
JOIN Sales_detail SD ON S.Sales_ID = SD.Sales_ID
JOIN Rearing_batch RB ON SD.Batch_ID = RB.Batch_ID
JOIN Fish F ON RB.Species_ID = F.Species_ID
WHERE EXTRACT(YEAR FROM S.Date_sold) = 2024 AND EXTRACT(MONTH FROM S.Date_sold) BETWEEN 7 AND 12
GROUP BY F.Species_ID, F.Species_name, F.Market_value
ORDER BY F.Species_ID;

-- Calculate total revenue for all fish species in November 2024
SELECT SUM(Revenue) AS Total_Revenue
FROM (
    SELECT SUM(SD.Weight_sold * F.Market_value) AS Revenue
    FROM Sales S
    JOIN Sales_detail SD ON S.Sales_ID = SD.Sales_ID
    JOIN Rearing_batch RB ON SD.Batch_ID = RB.Batch_ID
    JOIN Fish F ON RB.Species_ID = F.Species_ID
    WHERE EXTRACT(YEAR FROM S.Date_sold) = 2024 AND EXTRACT(MONTH FROM S.Date_sold) BETWEEN 7 AND 12
    GROUP BY F.Species_name
);


-- Extra Query
-- BY MONTH
-- Query to calculate total revenue for each month in the year 2024
SELECT EXTRACT(MONTH FROM S.Date_sold) AS Month,
       SUM(SD.Weight_sold * F.Market_value) AS Total_Revenue
FROM Sales S
JOIN Sales_detail SD ON S.Sales_ID = SD.Sales_ID
JOIN Rearing_batch RB ON SD.Batch_ID = RB.Batch_ID
JOIN Fish F ON RB.Species_ID = F.Species_ID
WHERE EXTRACT(YEAR FROM S.Date_sold) = 2024
GROUP BY EXTRACT(MONTH FROM S.Date_sold)
ORDER BY EXTRACT(MONTH FROM S.Date_sold);


-- Query 2
-- Get the water bill and electricity bill for each month/year
SELECT SUM(Water_bill) AS Water_bill,
	   SUM(Electricity_bill) AS Electricity_bill,
	   EXTRACT(YEAR FROM Period) AS Year,
	   EXTRACT(MONTH FROM Period) AS Month
FROM Associated_cost
WHERE EXTRACT(YEAR FROM Period) = 2024
GROUP BY EXTRACT(YEAR FROM Period), EXTRACT(MONTH FROM Period);


-- Get the water bill and electricity bill for second half of year
SELECT 
    SUM(Water_bill) AS Water_bill,
    SUM(Electricity_bill) AS Electricity_bill
FROM 
    Associated_cost
WHERE 
    EXTRACT(YEAR FROM Period) = 2024
    AND EXTRACT(MONTH FROM Period) BETWEEN 7 AND 12
GROUP BY 
    EXTRACT(YEAR FROM Period);


-- Find the depreciation value of equipment for half a year, grouped by equipment
SELECT E.Equip_ID,
       SUM(PR.Purchase_cost * E.Depreciation_rate/100 * 0.5) AS Depreciation_Value
FROM Equipment E
JOIN Purchase_record PR ON E.Equip_ID = PR.Equip_ID
WHERE EXTRACT(YEAR FROM PR.Purchase_date) = 2024
AND EXTRACT(MONTH FROM PR.Purchase_date) BETWEEN 7 AND 12 
GROUP BY E.Equip_ID
ORDER BY E.Equip_ID;


-- Query 3
-- Find the sum of purchase records for the second half of the year
SELECT EXTRACT(YEAR FROM Purchase_date) AS Year,
	   EXTRACT(MONTH FROM Purchase_date) As Month,
	   SUM(Purchase_cost) AS Total_Purchase_Cost
FROM Purchase_record
WHERE EXTRACT(YEAR FROM Purchase_date) = 2024
AND EXTRACT(MONTH FROM Purchase_date) BETWEEN 7 AND 12
GROUP BY EXTRACT(YEAR FROM Purchase_date), EXTRACT(MONTH FROM Purchase_date);

SELECT SUM(Purchase_cost) AS Total_Purchase_Cost
FROM Purchase_record
WHERE EXTRACT(YEAR FROM Purchase_date) = 2024
AND EXTRACT(MONTH FROM Purchase_date) BETWEEN 7 AND 12;

-- Find the total salary of all employees for second half of year
SELECT SUM(Salary * 6) AS Total_Salary
FROM Employee;

SELECT Emp_id,
	   Emp_name,
SUM(Salary * 6) AS Total_Salary
FROM Employee
GROUP BY Emp_id, Emp_name;


-- Query 4
-- Find total profit 
CREATE GLOBAL TEMPORARY TABLE temp_profit (
	Total_Revenue DECIMAL(10, 2),
    Total_Purchase_Cost DECIMAL(10, 2),
    Total_Utilities_Bill DECIMAL(10, 2),
    Total_Depreciation_Value DECIMAL(10, 2),
    Total_Salary DECIMAL(10, 2),
    Total_Profit DECIMAL(10, 2)
);

-- Insert the values into the temporary table, calculate Total_Profit dynamically
INSERT INTO temp_profit (Total_Revenue, Total_Purchase_Cost, Total_Utilities_Bill, Total_Depreciation_Value, Total_Salary)
VALUES (52000.00, 620.00, 1300.00, 13.5, 39000.00);

-- Select Total_Profit
SELECT 
    Total_Revenue - (Total_Purchase_Cost + Total_Utilities_Bill + Total_Depreciation_Value + Total_Salary) AS Total_Profit
FROM 
    temp_profit;
	
-- Calculate profit and update the temp_profit table
UPDATE temp_profit
SET Total_Profit = Total_Revenue - (Total_Purchase_Cost + Total_Utilities_Bill + Total_Depreciation_Value + Total_Salary);

-- Select the updated values
SELECT * FROM temp_profit;



-- Query 5
-- Compare the fish behavior for anamoly detection
SELECT Fish_behavior.Batch_ID AS batch_ID, Fish_behavior.Fish_health as fish_health, Water_quality.Temperature as temperature, Water_quality.pH as pH, Water_quality.Dissolve_oxygen as Oxygen, Water_quality.Ammonia_concentration as Ammonia_conc, Water_quality.Nitrate_concentration AS nitrate_conc, Fish_behavior.Avg_weight as avg_weight
FROM Rearing_batch
JOIN Fish_behavior ON Rearing_batch.Batch_ID = Fish_behavior.Batch_ID
JOIN Water_quality ON Rearing_batch.Batch_ID = Water_quality.Batch_ID
JOIN 
	(SELECT Batch_ID, MAX(Wq_date) AS Max_date 
	 FROM Water_quality 
	 GROUP BY Batch_ID) Max_dates 
	ON Water_quality.Batch_ID = Max_dates.Batch_ID 
	   AND Water_quality.Wq_date = Max_dates.max_date
WHERE Fish_behavior.Batch_ID = Water_quality.Batch_ID 
      AND Fish_behavior.Fb_date = Water_quality.Wq_date 
      AND Fish_behavior.Fish_health = 'Unhealthy';

SELECT Rearing_batch.Batch_ID AS batch_ID, Fish.Weight_ref AS weight_ref, Fish.Age_ref as age_ref, Fish.Temperature_ref as temp_ref, Fish.pH_ref as ph_ref, Fish.Oxygen_ref as oxy_ref, Fish.Ammonia_ref as ammonia_ref, Fish.Nitrate_ref as nitrate_ref
FROM Rearing_batch
JOIN Fish ON Rearing_batch.Species_ID = Fish.Species_ID
WHERE Fish.Species_ID = 'SP001' AND Rearing_batch.Batch_ID = 'B001';


-- Query 6
-- Show a list of past customers
-- to boost the sales of the particular species that has low sales
SELECT DISTINCT Rearing_batch.Species_ID, Customer.Cust_ID, Customer.Cust_name, Customer.Cust_contact
FROM Sales
JOIN Sales_detail ON Sales.Sales_ID = Sales_detail.Sales_ID 
JOIN Customer ON Sales.Cust_ID = Customer.Cust_ID
JOIN Rearing_batch ON Sales_detail.Batch_ID = Rearing_batch.Batch_ID
WHERE Rearing_batch.Species_ID = 'SP001';

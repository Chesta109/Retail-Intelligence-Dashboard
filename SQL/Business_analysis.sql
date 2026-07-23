
-- Total Revenue,Total Quanitity, and Total Profit
SELECT ROUND(SUM(Revenue),2) as Total_Revenue , SUM(Quantity) as Total_Quantity ,
ROUND(SUM(Profit),2) as Total_Profit FROM Retail_Analysis;

-- Revenue Trend By Month
SELECT YEAR(Order_Date) as Year , MONTH(Order_Date) as Month, ROUND(SUM(Revenue),2) as Monthly_Sales
FROM Retail_Analysis GROUP BY YEAR(Order_Date) , Month(Order_Date) ORDER BY Year,Month;

-- Products having negative profit
SELECT Product_Name,SUM(Profit) as Profit_Generated
FROM Retail_Analysis GROUP BY Product_Name
HAVING SUM(Profit) < 0 
ORDER BY Profit_Generated;

-- Customer Lifetime value
SELECT Customer_Name , COUNT(Order_Number) as Orders , SUM(Revenue) as Revenue
FROM Retail_Analysis
GROUP BY Customer_Name  ORDER BY Revenue desc;

-- Top Cities
SELECT TOP 10  Customer_City as City , ROUND(SUM(Revenue),2) as Revenue , SUM(Quantity) as Quantity,ROUND(SUM(Profit),2) as Profit
FROM Retail_Analysis 
GROUP BY Customer_City ORDER BY Revenue desc;

-- State Performance
SELECT State , ROUND(SUM(Revenue),2) as Revenue, ROUND(SUM(Profit),2) as Profit,SUM(Quantity) as Quantity
FROM Retail_Analysis
GROUP BY State ORDER BY Profit desc;

-- Sales Contribution %
SELECT Category , SUM(Revenue) as Sales,
ROUND(SUM(Revenue) * 100 / SUM(SUM(Revenue)) OVER(),2) as Sales_Percentage
FROM Retail_Analysis
GROUP BY Category
ORDER BY Sales_Percentage desc;

-- Running Sales
SELECT Order_Date , ROUND(SUM(Revenue),2) as Daily_sales,
ROUND(SUM(SUM(Revenue)) OVER(ORDER BY Order_date),2) as Running_sales
FROM Retail_Analysis
GROUP BY Order_Date;

-- Rank Products By Revenue
SELECT Product_Name,ROUND(SUM(Revenue),2) as Revenue,
RANK() OVER(ORDER BY ROUND(SUM(Revenue),2) DESC ) as Product_Rank
FROM Retail_Analysis
Group By Product_Name;

-- Top - 3 Products in each Category
WITH Product_Rank as (
SELECT Category , Product_Name,ROUND(SUM(Revenue),2) as Revenue,
DENSE_RANK() OVER(PARTITION BY Category ORDER BY ROUND(SUM(Revenue),2) DESC) as pr_rank
FROM Retail_Analysis
GROUP BY Category,Product_Name
)
SELECT * FROM Product_Rank WHERE pr_rank<=3;

-- Customer Segmentation
SELECT
CASE
WHEN SUM(Revenue)>=10000 THEN 'High Value'
WHEN SUM(Revenue)>=5000 THEN 'Medium Value'
ELSE 'Low Value'
END Customer_Type,
COUNT(*) Customers
FROM Retail_Analysis
GROUP BY Customer_Name;

-- Repeat Customers
SELECT Customer_Name ,ROUND(SUM(Revenue),2) as Revenue, COUNT(Customer_Name) as Orders_Count 
FROM Retail_Analysis
GROUP BY Customer_Name 
HAVING COUNT(Customer_Name) > 1
ORDER BY Orders_count desc;

-- Most Frequently Purchased Products
SELECT TOP 10 Product_Name ,COUNT(Product_Name) as Product_Count
FROM Retail_Analysis
GROUP BY Product_Name 
HAVING COUNT(Product_Name) > 1
ORDER BY Product_Count DESC;

-- Highest Profit Order
SELECT TOP 1 *
FROM Retail_Analysis
ORDER BY Profit DESC;

-- Lowest Profit Order
SELECT TOP 1 * 
FROM Retail_Analysis
ORDER BY Profit;


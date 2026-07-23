

USE Retail;
GO

SELECT * FROM customers;
SELECT * FROM Exchange;
SELECT * FROM Products;
SELECT * FROM Sales;
SELECT * FROM Stores;
 
EXEC sp_help 'customers';
EXEC sp_help 'Exchange';
EXEC sp_help 'Products';
EXEC sp_help 'Sales';
EXEC sp_help 'Stores';

CREATE VIEW Retail_Analysis AS

SELECT

-- Sales Information
s.Order_Number,
s.Line_Item,
s.Order_Date,
s.Delivery_Date,
s.Quantity,

-- Customer Information
c.CustomerKey,
c.Name AS Customer_Name,
c.Gender,
c.City AS Customer_City,
c.State_Code,
c.State,
c.Zip_Code,
c.Country AS Customer_Country,
c.Continent,
c.Birthday,

-- Product Information
p.ProductKey,
p.Product_Name,
p.Brand,
p.Color,
p.Unit_Cost_USD,
p.Unit_Price_USD,
p.SubcategoryKey,
p.Subcategory,
p.CategoryKey,
p.Category,

-- Store Information
st.StoreKey,
st.Country AS Store_Country,
st.State AS Store_State,
st.Square_Meters,
st.Open_Date,

-- Exchange Rate
e.Exchange,

-- Calculated Columns
(s.Quantity * p.Unit_Price_USD * e.Exchange) AS Revenue,

(s.Quantity * p.Unit_Cost_USD * e.Exchange) AS Cost,

((p.Unit_Price_USD - p.Unit_Cost_USD)
 * s.Quantity
 * e.Exchange) AS Profit,

ROUND(
(
(p.Unit_Price_USD - p.Unit_Cost_USD)
/
p.Unit_Price_USD
) * 100,
2
) AS Profit_Margin

FROM Sales s

LEFT JOIN Customers c
ON s.CustomerKey = c.CustomerKey

LEFT JOIN Products p
ON s.ProductKey = p.ProductKey

LEFT JOIN Stores st
ON s.StoreKey = st.StoreKey

LEFT JOIN Exchange e
ON s.Currency_Code = e.Currency
AND s.Order_Date = e.Date;

SELECT * FROM Retail_Analysis;
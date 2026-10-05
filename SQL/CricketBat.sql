

USE CricketBatSales

GO

SELECT * FROM dbo.Sales

SELECT * FROM dbo.Brand_Master

SELECT * FROM dbo.Bat_Master

    /* Checking Nulls */

SELECT COUNT(*) AS TotalRows,
    COUNT(DISTINCT Sale_ID) AS Distinct_Rows,
    SUM(
        CASE
            WHEN Sale_ID IS NULL THEN 1
            ELSE 0
        END
    ) AS NULL_IDS
FROM dbo.Sales


SELECT COUNT(*) AS TotalRows,
    COUNT(DISTINCT Brand_ID) AS Distinct_Rows,
    SUM(
        CASE
            WHEN Brand_ID IS NULL THEN 1
            ELSE 0
        END
    ) AS NULL_IDS
FROM dbo.Brand_Master

SELECT COUNT(*) AS TotalRows,
    COUNT(DISTINCT Bat_ID) AS Distinct_Rows,
    SUM(
        CASE
            WHEN Bat_ID IS NULL THEN 1
            ELSE 0
        END
    ) AS NULL_IDS
FROM dbo.Bat_Master

    /*Duplicate Check*/

SELECT Sale_ID,
    COUNT(*) AS Dup_Rows
FROM dbo.Sales
GROUP BY Sale_ID
HAVING COUNT(*) > 1

/*Constraints*/

ALTER TABLE dbo.Sales
ADD CONSTRAINT PK_Sales
PRIMARY KEY(Sale_ID)

ALTER TABLE dbo.Brand_Master
ADD CONSTRAINT PK_Brand_Master
PRIMARY KEY(Brand_ID)

ALTER TABLE dbo.Bat_Master
ADD CONSTRAINT PK_Bat_Master
PRIMARY KEY(Bat_ID)

/* Date Check*/

SELECT MAX(Order_Date) AS Last_Date,
       MIN(Order_Date) AS Start_Date,
       COUNT(DISTINCT YEAR(Order_Date)) AS Total_Years
FROM   dbo.Sales;


/*Creating VIEW For Dimension*/

CREATE VIEW dbo.Vw_Dim_bat
AS
SELECT 
    B.Bat_ID,
    B.Brand_ID,
    Br.Brand_Name,
    B.Model,
    B.Willow_Type,
    B.Grade,
    B.Weight_Grams,
    B.Weight_Display,
    B.Handle_Type,
    B.Player_Level,
    B.Bat_Size,
    B.Profile,
    B.List_Price_INR,
CASE 
        WHEN B.List_Price_INR < 15000 Then 'Entry'
        WHEN B.List_Price_INR < 25000 Then 'Intermediate'
        WHEN B.List_Price_INR < 40000 Then 'Premium'
        Else 'Professional'
    END AS Price_Segment,
B.Image_URL,
    B.Image_Angle,
    B.Image_Source_Type,
    Br.Brand_Default_Hex,
    Br.Brand_Website_URL
FROM dbo.Bat_Master as B
INNER JOIN dbo.Brand_Master as Br
    ON B.Brand_ID = Br.Brand_ID
    GO
    
SELECT * FROM dbo.Vw_Dim_bat

/*Creating VIEW For Fact Table*/

CREATE VIEW Vw_Fact_Sales AS 
SELECT 
Sale_ID,
Order_Date,
Bat_ID,
Quantity,
Unit_Price,
Unit_Cost,
Discount_Pct,
CAST(Quantity*Unit_Price AS decimal(18,2)) AS Gross_Sales,
CAST((Quantity*Unit_Price)*Discount_Pct AS decimal(18,2))
AS Discount_Amount,
CAST((Quantity*Unit_Price)-
(Quantity*Unit_Price)*Discount_Pct AS decimal(18,2))
AS Net_Sales,
CAST(Quantity*Unit_Cost AS decimal(18,2)) AS Total_Cost,
CAST((Quantity*Unit_Price)
-((Quantity*Unit_Price)*Discount_Pct)
-(Quantity*Unit_Cost) AS DECIMAL(18,2)) AS Gross_Profit
FROM dbo.Sales
GO

SELECT * from dbo.Vw_Fact_Sales



---Bat Images Query

UPDATE dbo.Bat_Master
SET Image_URL = CASE Bat_ID

    WHEN 'BAT001' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/ss_transparent.png'

    WHEN 'BAT002' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/sg_transparent.png'

    WHEN 'BAT003' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/mrf_transparent.png'

    WHEN 'BAT004' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/dsc_transparent.png'

    WHEN 'BAT005' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/gm_transparent.png'

    WHEN 'BAT006' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/ceat_transparent.png'

    WHEN 'BAT007' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/kookaburra_transparent.png'

    WHEN 'BAT008' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/gray_nicolls_transparent.png'

    WHEN 'BAT009' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/sf_transparent.png'

    WHEN 'BAT010' THEN
    'https://raw.githubusercontent.com/Basildias17-ai/Cricket-bat-images/main/cricket-bat-images/spartan_transparent.png'

    ELSE Image_URL
END;

CREATE DATABASE insurance_analytics;
USE insurance_analytics;
SELECT DATABASE();

CREATE TABLE regions (
    Region_ID VARCHAR(10) PRIMARY KEY,
    Region VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    Product_ID VARCHAR(10) PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL
);

CREATE TABLE agents (
    Agent_ID VARCHAR(10) PRIMARY KEY,
    Agent_Name VARCHAR(100) NOT NULL,
    Region_ID VARCHAR(10),
    Agent_Type VARCHAR(50),
    Joining_Date DATE,
    Experience_Years DECIMAL(5,2),

    FOREIGN KEY (Region_ID)
        REFERENCES regions(Region_ID)
);

CREATE TABLE customers (
    Customer_ID VARCHAR(10) PRIMARY KEY,
    Customer_Name VARCHAR(150) NOT NULL,
    Gender VARCHAR(20),
    DOB DATE,
    City VARCHAR(100),
    Region_ID VARCHAR(10),
    Occupation VARCHAR(100),
    Income_Band VARCHAR(50),
    Customer_Segment VARCHAR(50),
    Join_Date DATE,

    FOREIGN KEY (Region_ID)
        REFERENCES regions(Region_ID)
);

CREATE TABLE policies (
    Policy_ID VARCHAR(12) PRIMARY KEY,
    Customer_ID VARCHAR(10) NOT NULL,
    Product_ID VARCHAR(10) NOT NULL,
    Agent_ID VARCHAR(10),
    Policy_Start_Date DATE,
    Policy_End_Date DATE,
    Premium_Amount DECIMAL(15,2),
    Sum_Assured DECIMAL(18,2),
    Policy_Status VARCHAR(50),
    Payment_Mode VARCHAR(50),
    Renewal_Status VARCHAR(50),
    Region_ID VARCHAR(10),

    FOREIGN KEY (Customer_ID)
        REFERENCES customers(Customer_ID),

    FOREIGN KEY (Product_ID)
        REFERENCES products(Product_ID),

    FOREIGN KEY (Agent_ID)
        REFERENCES agents(Agent_ID),

    FOREIGN KEY (Region_ID)
        REFERENCES regions(Region_ID)
);

CREATE TABLE claims (
    Claim_ID VARCHAR(12) PRIMARY KEY,
    Policy_ID VARCHAR(12) NOT NULL,
    Customer_ID VARCHAR(10) NOT NULL,
    Claim_Date DATE,
    Claim_Type VARCHAR(100),
    Claim_Amount DECIMAL(15,2),
    Approved_Amount DECIMAL(15,2),
    Claim_Status VARCHAR(50),
    Settlement_Date DATE,
    Rejection_Reason VARCHAR(255),
    Severity VARCHAR(50),
    Claim_TAT_Days INT,

    FOREIGN KEY (Policy_ID)
        REFERENCES policies(Policy_ID),

    FOREIGN KEY (Customer_ID)
        REFERENCES customers(Customer_ID)
);

CREATE TABLE claim_payments (
    Payment_ID VARCHAR(13) PRIMARY KEY,
    Claim_ID VARCHAR(12) NOT NULL,
    Payment_Date DATE,
    Payment_Amount DECIMAL(15,2),
    Payment_Status VARCHAR(50),
    Payment_Mode VARCHAR(50),

    FOREIGN KEY (Claim_ID)
        REFERENCES claims(Claim_ID)
);

SHOW TABLES;

DESCRIBE customers;
DESCRIBE policies;
DESCRIBE claims;
DESCRIBE claim_payments;
DESCRIBE products;
DESCRIBE regions;
DESCRIBE agents;

SELECT COUNT(*) FROM regions;
SELECT * FROM regions;

SELECT COUNT(*) FROM products;
SELECT * FROM products;

SELECT COUNT(*) FROM agents;
SELECT * FROM AGENTS;

SELECT COUNT(*) FROM customers;
SELECT * FROM customers;

SELECT COUNT(*) FROM policies;
SELECT * FROM policies;

SELECT COUNT(*) FROM claims;
SELECT * FROM claims;

SELECT COUNT(*) FROM claim_payments;
SELECT * FROM claim_payments;

SELECT 'Regions' AS Table_Name, COUNT(*) AS Records FROM regions
UNION ALL
SELECT 'Products', COUNT(*) FROM products
UNION ALL
SELECT 'Agents', COUNT(*) FROM agents
UNION ALL
SELECT 'Customers', COUNT(*) FROM customers
UNION ALL
SELECT 'Policies', COUNT(*) FROM policies
UNION ALL
SELECT 'Claims', COUNT(*) FROM claims
UNION ALL
SELECT 'Claim Payments', COUNT(*) FROM claim_payments;

SELECT COUNT(*) AS Missing_Customers
FROM policies p
LEFT JOIN customers c
    ON p.Customer_ID = c.Customer_ID
WHERE c.Customer_ID IS NULL;

SELECT COUNT(*) AS Missing_Products
FROM policies p
LEFT JOIN products pr
    ON p.Product_ID = pr.Product_ID
WHERE pr.Product_ID IS NULL;

SELECT COUNT(*) AS Missing_Agents
FROM policies p
LEFT JOIN agents a
    ON p.Agent_ID = a.Agent_ID
WHERE p.Agent_ID IS NOT NULL
  AND a.Agent_ID IS NULL;
  
  SELECT COUNT(*) AS Missing_Regions
FROM policies p
LEFT JOIN regions r
    ON p.Region_ID = r.Region_ID
WHERE r.Region_ID IS NULL;

SELECT COUNT(*) AS Missing_Policies
FROM claims c
LEFT JOIN policies p
    ON c.Policy_ID = p.Policy_ID
WHERE p.Policy_ID IS NULL;

SELECT COUNT(*) AS Missing_Customers
FROM claims c
LEFT JOIN customers cu
    ON c.Customer_ID = cu.Customer_ID
WHERE cu.Customer_ID IS NULL;

SELECT COUNT(*) AS Orphan_Payments
FROM claim_payments cp
LEFT JOIN claims c
    ON cp.Claim_ID = c.Claim_ID
WHERE c.Claim_ID IS NULL;

SELECT COUNT(*) AS Customer_Policy_Mismatches
FROM claims c
JOIN policies p
    ON c.Policy_ID = p.Policy_ID
WHERE c.Customer_ID <> p.Customer_ID;





SELECT COUNT(*) AS Total_Policies
FROM policies;
SELECT ROUND(SUM(Premium_Amount), 2) AS Total_Premium
FROM policies;
SELECT COUNT(*) AS Total_Claims
FROM claims;
SELECT ROUND(SUM(Claim_Amount), 2) AS Total_Claim_Amount
FROM claims;
SELECT ROUND(SUM(Approved_Amount), 2) AS Total_Approved_Amount
FROM claims;

SELECT
    ROUND(
        (
            (SELECT SUM(Claim_Amount) FROM claims)
            /
            (SELECT SUM(Premium_Amount) FROM policies)
        ) * 100,
        2
    ) AS Loss_Ratio_Percent;
    
    SELECT
    Claim_Status,
    COUNT(*) AS Claim_Count
FROM claims
GROUP BY Claim_Status
ORDER BY Claim_Count DESC;

SELECT
    ROUND(
        (SUM(Claim_Status = 'Settled') / COUNT(*)) * 100,
        2
    ) AS Settlement_Ratio_Percent
FROM claims;

SELECT
    ROUND(AVG(Claim_TAT_Days), 2) AS Average_Claim_TAT_Days
FROM claims
WHERE Claim_TAT_Days IS NOT NULL;

SELECT
    Renewal_Status,
    COUNT(*) AS Policy_Count
FROM policies
GROUP BY Renewal_Status
ORDER BY Policy_Count DESC;

SELECT
    ROUND(
        (SUM(Renewal_Status = 'Renewed') / COUNT(*)) * 100,
        2
    ) AS Renewal_Rate_Percent
FROM policies;

SELECT
    Policy_Status,
    COUNT(*) AS Policy_Count
FROM policies
GROUP BY Policy_Status
ORDER BY Policy_Count DESC;

SELECT
    ROUND(
        (SUM(Policy_Status = 'Cancelled') / COUNT(*)) * 100,
        2
    ) AS Cancellation_Rate_Percent
FROM policies;

SELECT
    ROUND(AVG(Claim_Amount), 2) AS Average_Claim_Amount
FROM claims
WHERE Claim_Amount IS NOT NULL;

SELECT
    pr.Product_Name,
    COUNT(p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium
FROM policies p
JOIN products pr
    ON p.Product_ID = pr.Product_ID
GROUP BY pr.Product_Name
ORDER BY Total_Premium DESC;

SELECT
    pr.Product_Name,
    COUNT(c.Claim_ID) AS Total_Claims,
    ROUND(SUM(c.Claim_Amount), 2) AS Total_Claim_Amount
FROM claims c
JOIN policies p
    ON c.Policy_ID = p.Policy_ID
JOIN products pr
    ON p.Product_ID = pr.Product_ID
GROUP BY pr.Product_Name
ORDER BY Total_Claim_Amount DESC;

WITH Product_Premium AS (
    SELECT
        p.Product_ID,
        pr.Product_Name,
        SUM(p.Premium_Amount) AS Total_Premium
    FROM policies p
    JOIN products pr
        ON p.Product_ID = pr.Product_ID
    GROUP BY
        p.Product_ID,
        pr.Product_Name
),

Product_Claims AS (
    SELECT
        p.Product_ID,
        SUM(c.Claim_Amount) AS Total_Claim_Amount
    FROM claims c
    JOIN policies p
        ON c.Policy_ID = p.Policy_ID
    GROUP BY
        p.Product_ID
)

SELECT
    pp.Product_Name,
    ROUND(pp.Total_Premium, 2) AS Total_Premium,
    ROUND(COALESCE(pc.Total_Claim_Amount, 0), 2) AS Total_Claim_Amount,
    ROUND(
        (COALESCE(pc.Total_Claim_Amount, 0) / pp.Total_Premium) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM Product_Premium pp
LEFT JOIN Product_Claims pc
    ON pp.Product_ID = pc.Product_ID
ORDER BY Loss_Ratio_Percent DESC;

SELECT
    pr.Product_Name,
    COUNT(c.Claim_ID) AS Total_Claims,
    ROUND(
        (COUNT(c.Claim_ID) /
        (SELECT COUNT(*) FROM claims)) * 100,
        2
    ) AS Claim_Frequency_Percent
FROM claims c
JOIN policies p
    ON c.Policy_ID = p.Policy_ID
JOIN products pr
    ON p.Product_ID = pr.Product_ID
GROUP BY pr.Product_Name
ORDER BY Total_Claims DESC;

SELECT
    pr.Product_Name,
    COUNT(c.Claim_ID) AS Total_Claims,
    ROUND(AVG(c.Claim_Amount), 2) AS Average_Claim_Amount
FROM claims c
JOIN policies p
    ON c.Policy_ID = p.Policy_ID
JOIN products pr
    ON p.Product_ID = pr.Product_ID
WHERE c.Claim_Amount IS NOT NULL
GROUP BY pr.Product_Name
ORDER BY Average_Claim_Amount DESC;

SELECT
    c.Customer_Segment,
    COUNT(p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium
FROM policies p
JOIN customers c
    ON p.Customer_ID = c.Customer_ID
GROUP BY c.Customer_Segment
ORDER BY Total_Premium DESC;

SELECT
    c.Customer_Segment,
    COUNT(cl.Claim_ID) AS Total_Claims,
    ROUND(SUM(cl.Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(AVG(cl.Claim_Amount), 2) AS Average_Claim_Amount
FROM claims cl
JOIN customers c
    ON cl.Customer_ID = c.Customer_ID
WHERE cl.Claim_Amount IS NOT NULL
GROUP BY c.Customer_Segment
ORDER BY Total_Claim_Amount DESC;

SELECT
    r.Region,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium,
    COUNT(DISTINCT c.Claim_ID) AS Total_Claims,
    ROUND(SUM(c.Claim_Amount), 2) AS Total_Claim_Amount
FROM regions r
LEFT JOIN policies p
    ON r.Region_ID = p.Region_ID
LEFT JOIN claims c
    ON p.Policy_ID = c.Policy_ID
GROUP BY r.Region_ID, r.Region
ORDER BY Total_Premium DESC;

SELECT
    r.Region,
    COUNT(c.Claim_ID) AS Total_Claims,
    ROUND(
        COUNT(c.Claim_ID) /
        (SELECT COUNT(*) FROM claims) * 100,
        2
    ) AS Claim_Frequency_Percent
FROM regions r
LEFT JOIN policies p
    ON r.Region_ID = p.Region_ID
LEFT JOIN claims c
    ON p.Policy_ID = c.Policy_ID
GROUP BY r.Region_ID, r.Region
ORDER BY Total_Claims DESC;

SELECT
    a.Agent_ID,
    a.Agent_Name,
    COUNT(p.Policy_ID) AS Total_Policies,
    ROUND(SUM(p.Premium_Amount), 2) AS Total_Premium
FROM agents a
LEFT JOIN policies p
    ON a.Agent_ID = p.Agent_ID
GROUP BY
    a.Agent_ID,
    a.Agent_Name
ORDER BY Total_Premium DESC
LIMIT 10;

SELECT
    a.Agent_ID,
    a.Agent_Name,
    COUNT(DISTINCT p.Policy_ID) AS Total_Policies,
    COUNT(c.Claim_ID) AS Total_Claims,
    ROUND(SUM(c.Claim_Amount), 2) AS Total_Claim_Amount
FROM agents a
JOIN policies p
    ON a.Agent_ID = p.Agent_ID
LEFT JOIN claims c
    ON p.Policy_ID = c.Policy_ID
WHERE c.Claim_Amount IS NOT NULL
GROUP BY
    a.Agent_ID,
    a.Agent_Name
ORDER BY Total_Claim_Amount DESC
LIMIT 10;

WITH Agent_Premium AS (
    SELECT
        a.Agent_ID,
        a.Agent_Name,
        SUM(p.Premium_Amount) AS Total_Premium
    FROM agents a
    JOIN policies p
        ON a.Agent_ID = p.Agent_ID
    GROUP BY
        a.Agent_ID,
        a.Agent_Name
),
Agent_Claims AS (
    SELECT
        p.Agent_ID,
        SUM(c.Claim_Amount) AS Total_Claim_Amount
    FROM policies p
    JOIN claims c
        ON p.Policy_ID = c.Policy_ID
    WHERE c.Claim_Amount IS NOT NULL
    GROUP BY p.Agent_ID
)
SELECT
    ap.Agent_ID,
    ap.Agent_Name,
    ROUND(ap.Total_Premium, 2) AS Total_Premium,
    ROUND(COALESCE(ac.Total_Claim_Amount, 0), 2) AS Total_Claim_Amount,
    ROUND(
        (COALESCE(ac.Total_Claim_Amount, 0) / ap.Total_Premium) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM Agent_Premium ap
LEFT JOIN Agent_Claims ac
    ON ap.Agent_ID = ac.Agent_ID
WHERE ac.Total_Claim_Amount IS NOT NULL
ORDER BY Loss_Ratio_Percent DESC
LIMIT 10;

SELECT
    pr.Product_Name,
    COUNT(c.Claim_ID) AS Claims_With_TAT,
    ROUND(AVG(c.Claim_TAT_Days), 2) AS Average_Claim_TAT_Days
FROM claims c
JOIN policies p
    ON c.Policy_ID = p.Policy_ID
JOIN products pr
    ON p.Product_ID = pr.Product_ID
WHERE c.Claim_TAT_Days IS NOT NULL
GROUP BY pr.Product_Name
ORDER BY Average_Claim_TAT_Days DESC;

SELECT
    pr.Product_Name,
    COUNT(c.Claim_ID) AS Total_Claims,
    SUM(c.Claim_Status = 'Settled') AS Settled_Claims,
    ROUND(
        SUM(c.Claim_Status = 'Settled') /
        COUNT(c.Claim_ID) * 100,
        2
    ) AS Settlement_Ratio_Percent
FROM claims c
JOIN policies p
    ON c.Policy_ID = p.Policy_ID
JOIN products pr
    ON p.Product_ID = pr.Product_ID
GROUP BY pr.Product_Name
ORDER BY Settlement_Ratio_Percent DESC;

SELECT
    Claim_Status,
    COUNT(*) AS Total_Claims,
    ROUND(
        COUNT(*) / (SELECT COUNT(*) FROM claims) * 100,
        2
    ) AS Claim_Status_Percent
FROM claims
GROUP BY Claim_Status
ORDER BY Total_Claims DESC;

SELECT
    Rejection_Reason,
    COUNT(*) AS Rejected_Claims,
    ROUND(
        COUNT(*) /
        (SELECT COUNT(*)
         FROM claims
         WHERE Claim_Status = 'Rejected') * 100,
        2
    ) AS Rejection_Percent
FROM claims
WHERE Claim_Status = 'Rejected'
GROUP BY Rejection_Reason
ORDER BY Rejected_Claims DESC;

SELECT
    Severity,
    COUNT(Claim_ID) AS Total_Claims,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(AVG(Claim_Amount), 2) AS Average_Claim_Amount
FROM claims
WHERE Claim_Amount IS NOT NULL
GROUP BY Severity
ORDER BY Total_Claim_Amount DESC;

SELECT
    Severity,
    COUNT(Claim_ID) AS Total_Claims,
    ROUND(SUM(Claim_Amount), 2) AS Total_Claim_Amount,
    ROUND(AVG(Claim_Amount), 2) AS Average_Claim_Amount
FROM claims
WHERE Claim_Amount IS NOT NULL
GROUP BY Severity
ORDER BY Total_Claim_Amount DESC;

SELECT
    Severity,
    COUNT(Claim_ID) AS Total_Claims,
    SUM(Claim_Status = 'Settled') AS Settled_Claims,
    ROUND(
        SUM(Claim_Status = 'Settled') /
        COUNT(Claim_ID) * 100,
        2
    ) AS Settlement_Ratio_Percent,
    ROUND(
        AVG(Claim_TAT_Days),
        2
    ) AS Average_Claim_TAT_Days
FROM claims
GROUP BY Severity
ORDER BY Average_Claim_TAT_Days DESC;

WITH Customer_Premium AS (
    SELECT
        c.Customer_ID,
        c.Customer_Name,
        c.Customer_Segment,
        COUNT(p.Policy_ID) AS Total_Policies,
        SUM(p.Premium_Amount) AS Total_Premium
    FROM customers c
    JOIN policies p
        ON c.Customer_ID = p.Customer_ID
    GROUP BY
        c.Customer_ID,
        c.Customer_Name,
        c.Customer_Segment
),
Customer_Claims AS (
    SELECT
        c.Customer_ID,
        COUNT(cl.Claim_ID) AS Total_Claims,
        SUM(cl.Claim_Amount) AS Total_Claim_Amount,
        AVG(cl.Claim_Amount) AS Average_Claim_Amount
    FROM customers c
    JOIN claims cl
        ON c.Customer_ID = cl.Customer_ID
    WHERE cl.Claim_Amount IS NOT NULL
    GROUP BY c.Customer_ID
)
SELECT
    cp.Customer_ID,
    cp.Customer_Name,
    cp.Customer_Segment,
    cp.Total_Policies,
    ROUND(cp.Total_Premium, 2) AS Total_Premium,
    cc.Total_Claims,
    ROUND(cc.Total_Claim_Amount, 2) AS Total_Claim_Amount,
    ROUND(cc.Average_Claim_Amount, 2) AS Average_Claim_Amount,
    ROUND(
        (cc.Total_Claim_Amount / cp.Total_Premium) * 100,
        2
    ) AS Loss_Ratio_Percent
FROM Customer_Premium cp
JOIN Customer_Claims cc
    ON cp.Customer_ID = cc.Customer_ID
ORDER BY Loss_Ratio_Percent DESC
LIMIT 20;



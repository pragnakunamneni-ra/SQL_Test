CREATE PROCEDURE GetAnnualCustomerSales
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = DATEFROMPARTS(YEAR(GETDATE()), 1, 1);
    DECLARE @EndDate DATE = DATEFROMPARTS(YEAR(GETDATE()), 12, 31);

    SELECT 
        c.CustomerID,
        c.CustomerName,
        SUM(s.TotalAmount) AS AnnualSales
    FROM Sales s
    INNER JOIN Customers c ON s.CustomerID = c.CustomerID
    WHERE s.SaleDate BETWEEN @StartDate AND @EndDate
    GROUP BY c.CustomerID, c.CustomerName
    ORDER BY AnnualSales DESC;
END;

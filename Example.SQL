
CREATE PROCEDURE GetQuarterlyCustomerSales
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        DECLARE @Year INT = YEAR(GETDATE());
        DECLARE @Quarter INT = DATEPART(QUARTER, GETDATE());
        DECLARE @StartDate DATE = DATEFROMPARTS(@Year, ((@Quarter - 1) * 3) + 1, 1);
        DECLARE @EndDate DATE = DATEADD(DAY, -1, DATEADD(MONTH, 3, @StartDate));

        SELECT 
            c.CustomerID,
            c.CustomerName,
            SUM(s.TotalAmount) AS QuarterlySales
        FROM Sales s
        INNER JOIN Customers c ON s.CustomerID = c.CustomerID
        WHERE s.SaleDate BETWEEN @StartDate AND @EndDate
        GROUP BY c.CustomerID, c.CustomerName
        ORDER BY QuarterlySales DESC;
    END TRY
    BEGIN CATCH
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

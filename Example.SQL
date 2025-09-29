

-- =============================================
-- Author:        <Your Name>
-- Create date:   <Date>
-- Description:   Returns quarterly sales for each customer for the current quarter.
--                Includes error handling for robust execution.
-- =============================================
CREATE PROCEDURE GetQuarterlyCustomerSales
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        -- Get current year and quarter
        DECLARE @Year INT = YEAR(GETDATE());
        DECLARE @Quarter INT = DATEPART(QUARTER, GETDATE());

        -- Calculate start and end dates for the current quarter
        DECLARE @StartDate DATE = DATEFROMPARTS(@Year, ((@Quarter - 1) * 3) + 1, 1);
        DECLARE @EndDate DATE = DATEADD(DAY, -1, DATEADD(MONTH, 3, @StartDate));

        -- Select customer sales for the current quarter
        SELECT 
            c.CustomerID,           -- Unique customer identifier
            c.CustomerName,         -- Customer name
            SUM(s.TotalAmount) AS QuarterlySales -- Total sales for the quarter
        FROM Sales s
        INNER JOIN Customers c ON s.CustomerID = c.CustomerID
        WHERE s.SaleDate BETWEEN @StartDate AND @EndDate
        GROUP BY c.CustomerID, c.CustomerName
        ORDER BY QuarterlySales DESC;
    END TRY
    BEGIN CATCH
        -- Return error details if an exception occurs
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

-- Indexes to optimize performance
CREATE INDEX IDX_Sales_CustomerID ON Sales(CustomerID);
CREATE INDEX IDX_Sales_SaleDate ON Sales(SaleDate);

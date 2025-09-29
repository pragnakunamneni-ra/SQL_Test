-- =============================================
-- Author:        <Your Name>
-- Create date:   <Date>
-- Description:   Returns quarterly sales for each customer for the current year
-- =============================================
CREATE PROCEDURE GetQuarterlyCustomerSales
AS
BEGIN
    BEGIN TRY
        -- Prevent extra result sets from interfering with SELECT statements
        SET NOCOUNT ON;

        -- Set start and end dates for the current year
        DECLARE @Year INT = YEAR(GETDATE());

        -- Select customer sales for each quarter of the current year
        SELECT 
            c.CustomerID,           -- Unique identifier for the customer
            c.CustomerName,         -- Name of the customer
            DATEPART(QUARTER, s.SaleDate) AS Quarter, -- Quarter number (1-4)
            SUM(s.TotalAmount) AS QuarterlySales      -- Total sales amount for the quarter
        FROM Sales s
        INNER JOIN Customers c ON s.CustomerID = c.CustomerID -- Join sales with customers
        WHERE YEAR(s.SaleDate) = @Year                        -- Filter sales within the year
        GROUP BY c.CustomerID, c.CustomerName, DATEPART(QUARTER, s.SaleDate) -- Group by customer and quarter
        ORDER BY c.CustomerID, Quarter;
    END TRY
    BEGIN CATCH
        -- Error handling: return error information
        SELECT 
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine,
            ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;

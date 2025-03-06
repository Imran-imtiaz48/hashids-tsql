CREATE PROCEDURE [dbo].[seedNumberTable]  
    @start INT = NULL,  
    @end INT = NULL,  
    @withStringConversion BIT = NULL  
AS  
BEGIN  
    SET NOCOUNT ON;  

    SET @start = ISNULL(@start, 0);  
    SET @end = ISNULL(@end, 8192);  
    SET @withStringConversion = ISNULL(@withStringConversion, 1);  

    DECLARE @upper INT = @end + 1;  

    TRUNCATE TABLE [dbo].[Number];  

    DECLARE @seed TABLE(i INT);  
    INSERT INTO @seed(i) VALUES (0), (1), (2), (3), (4), (5), (6), (7);  

    INSERT INTO [dbo].[Number](i)  
    SELECT i FROM @seed WHERE i BETWEEN @start AND @end;  

    WHILE (SELECT MAX(i) FROM [dbo].[Number]) < @end  
    BEGIN  
        INSERT INTO [dbo].[Number](i)  
        SELECT n.i + (SELECT COUNT(*) FROM [dbo].[Number])  
        FROM [dbo].[Number] n  
        WHERE n.i + (SELECT COUNT(*) FROM [dbo].[Number]) < @upper;  
    END  

    IF @withStringConversion = 1  
    BEGIN  
        UPDATE n  
        SET  
            ia = CAST(n.i AS VARCHAR(10)),  
            iu = CAST(n.i AS NVARCHAR(10))  
        FROM [dbo].[Number] n;  
    END  
END;  

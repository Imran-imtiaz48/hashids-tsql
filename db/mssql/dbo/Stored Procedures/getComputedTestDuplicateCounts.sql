CREATE PROCEDURE [dbo].[getComputedTestDuplicateCounts]  
AS  
BEGIN  
    SET NOCOUNT ON;  

    SELECT  
        SUM(ISNULL(cs.[Count], 0)) AS CaseSensitiveDuplicates,  
        SUM(ISNULL(ci.[Count], 0)) AS CaseInsensitiveDuplicates  
    FROM [dbo].[ComputedTest] t  
    LEFT JOIN (  
        SELECT HashId, COUNT(*) AS [Count]  
        FROM [dbo].[ComputedTest]  
        GROUP BY HashId  
        HAVING COUNT(*) > 1  
    ) cs ON t.HashId = cs.HashId  
    LEFT JOIN (  
        SELECT HashId COLLATE SQL_Latin1_General_CP1_CI_AS AS HashId, COUNT(*) AS [Count]  
        FROM [dbo].[ComputedTest]  
        GROUP BY HashId COLLATE SQL_Latin1_General_CP1_CI_AS  
        HAVING COUNT(*) > 1  
    ) ci ON t.HashId = ci.HashId;  
END;  

/****** Object:  StoredProcedure [SAP_ECC].[DF_TruncateTable]    Script Date: 4/2/2020 10:50:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER    PROCEDURE [SAP_ECC].[DF_TruncateTable]
(
  @pi_TabName  nvarchar(100)
)
-- =============================================================================================================
-- Author:      Stuart, Greg
-- Create Date: 04-Jun-2019
-- Description: Procedure to take in a tablename as parameter and utilising dynamic SQL delete all records from 
--              this table. This is intended to be used as an action within an ADF pipeline in preperation for 
--              populating data.
-- =============================================================================================================
AS
DECLARE @SQLString nvarchar(200);
DECLARE @ParmDefinition nvarchar(200);
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON
	SET @SQLString = N'TRUNCATE TABLE '+ @pi_TabName;
	EXECUTE sp_executesql @SQLString;
END

/****** Object:  StoredProcedure [insights_batch].[TableSchema2JSON]    Script Date: 4/8/2020 11:19:43 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============================================================================================================================
-- <Author>			Adam Catton
-- <Create Date>	8-8-2019
-- <Description>	Stored Procedure returns columns from INFORMATION_SCHEMA for provided table output as JSON.
--
-- <Change Control>
-- <Name>			<Date>			<Change Description>
-- Nick             03-Feb-2020	    Include type in json output

-- ============================================================================================================================
ALTER PROCEDURE [insights_batch].[TableSchema2JSON]
(
@TableName VARCHAR(50)
)
AS
BEGIN

    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
	
    SET NOCOUNT ON;

	SET XACT_ABORT ON;

	------------------------------------------------------------------------------------
	-- BEGIN TRY...CATCH BLOCK
	------------------------------------------------------------------------------------

	BEGIN TRY

		------------------------------------------------------------------------------------
		-- BEGIN TRANSACTION
		------------------------------------------------------------------------------------

		BEGIN TRAN;

			SELECT (
				SELECT [ColumnName], DataFactoryDataType As [type]
				FROM [insights_batch].[TableSchema]
				WHERE [TableName] = @TableName
				FOR JSON AUTO
			) AS [Columns]

		COMMIT TRAN;

	END TRY

	BEGIN CATCH;

		------------------------------------------------------------------------------------
		-- Raise Error
		------------------------------------------------------------------------------------

		DECLARE @ErrorMessage NVARCHAR(4000);  
		DECLARE @ErrorSeverity INT;  
		DECLARE @ErrorState INT;  
  
		SELECT   
		@ErrorMessage = ERROR_MESSAGE(),  
		@ErrorSeverity = ERROR_SEVERITY(),  
		@ErrorState = ERROR_STATE();  
  
		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState); 

		------------------------------------------------------------------------------------
		-- Rollback or Commit transaction
		------------------------------------------------------------------------------------

	    -- Uncommitable Transaction

		IF (XACT_STATE()) = -1  
		BEGIN
		
			PRINT  N'The transaction is in an uncommittable state. Rolling back transaction.'  
			ROLLBACK TRANSACTION;  

		END;  
  
		-- Commitable Transaction

		IF (XACT_STATE()) = 1  
		BEGIN 
		
			PRINT N'The transaction is committable. Committing transaction.'  
			COMMIT TRANSACTION;     

		END;  

	END CATCH;

END

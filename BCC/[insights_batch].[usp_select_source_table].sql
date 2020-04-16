/****** Object:  StoredProcedure [insights_batch].[usp_select_source_table]    Script Date: 4/8/2020 11:03:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-------
-- ============================================================================================================================
-- <Author>			NicK Beagley
-- <Create Date>	19-Nov-2019
-- <Description>	Stored Procedure returns tables for a particular project
--
-- <Change Control>
-- <Name>			<Date>			<Change Description>
-- Nick             19-Nov-2019	    Initial Version
-- ============================================================================================================================
ALTER PROCEDURE [insights_batch].[usp_select_source_table]
(
@SourceName NVARCHAR(200)
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

		SELECT TableName 
		FROM insights_batch.CTLBatch_SourceTable
		WHERE SourceName = @SourceName
		ORDER BY SortOrder

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

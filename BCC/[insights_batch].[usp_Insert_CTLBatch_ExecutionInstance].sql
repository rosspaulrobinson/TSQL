/****** Object:  StoredProcedure [insights_batch].[usp_Insert_CTLBatch_ExecutionInstance]    Script Date: 4/7/2020 3:19:58 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============================================================================================================================
-- <Author>			Adam Catton
-- <Create Date>	8-8-2019
-- <Description>	Stored Procedure creates new Execution Instance entry.
--
-- <Change Control>
-- <Name>			<Date>			<Change Description>
-- Nick             21-Nov-2019     Taken from Telephony. Deployed to shared concepts. Support UTC naming on DT. Increased column sizes
-- Nick             22-Nov-2019     Capturing METADATA DatamovementID too
-- ============================================================================================================================
ALTER  PROCEDURE [insights_batch].[usp_Insert_CTLBatch_ExecutionInstance]
(
@DataFactoryName VARCHAR(100),
@PipelineName VARCHAR(200),
@PipelineRunID VARCHAR(100),
@PipelineTriggerID VARCHAR(100),
@PipelineTriggerName VARCHAR(200),
@PipelineTriggerStartTimeUTC DATETIME,
@PipelineTriggerType VARCHAR(50),
@InsightsMovementID VARCHAR(100)
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

			INSERT INTO [insights_batch].[CTLBatch_ExecutionInstance] (
	
				[DataFactoryName], 
				[PipelineName], 
				[PipelineRunID], 
				[PipelineTriggerID],
				[PipelineTriggerName],
				[PipelineTriggerStartTimeUTC],
				[PipelineTriggerType],
				[InsightsMovementID]

			)

			VALUES (

				@DataFactoryName,
				@PipelineName,
				@PipelineRunID,
				@PipelineTriggerID,
				@PipelineTriggerName,
				@PipelineTriggerStartTimeUTC,
				@PipelineTriggerType,
				@InsightsMovementID
			);

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

/****** Object:  StoredProcedure [sap-shared].[SetHierarchyRootNodeParentsToNull]    Script Date: 4/7/2020 3:36:21 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [sap-shared].[SetHierarchyRootNodeParentsToNull]
AS
BEGIN
  -- This procedure sets the parent id value of the hierarchy root nodes to NULL.
  -- They are set to 00000000 in the source data and there is no row in the table with this value
   UPDATE [sap-shared].[0COSTCENTER] SET PARENTID = NULL WHERE PARENTID = '00000000'

   UPDATE [sap-shared].[0GL_ACCOUNT] SET PARENTID = NULL WHERE PARENTID = '00000000'

   UPDATE [sap-shared].[0INM_INGU] SET PARENTID = NULL WHERE PARENTID = '00000000'

   UPDATE [sap-shared].[0INM_INID] SET PARENTID = NULL WHERE PARENTID = '00000000'

   UPDATE [sap-shared].[0ORGUNIT] SET PARORG = NULL WHERE PARORG = '00000000'

   UPDATE [sap-shared].[0PROFIT_CTR] SET PARENTID = NULL WHERE PARENTID = '00000000'

   UPDATE [sap-shared].[ZCAGL_ACC] SET PARENTID = NULL WHERE PARENTID = '00000000'
END

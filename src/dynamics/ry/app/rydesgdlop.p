/*---------------------------------------------------------------------------------
  File: rydesgdlop.p

  Description:  AppServer pass-through wrapper for generateDataLogicObject().

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDatabaseName           AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcTableName              AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDumpName               AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDataObjectName         AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcProductModule          AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER plSuppressValidation     AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER pcLogicProcedureName     AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcLogicObjectType        AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcLogicProcedureTemplate AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDataObjectRelativePath AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDataLogicRelativePath  AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcRootFolder             AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcFolderIndicator        AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER plCreateMissingFolder    AS LOGICAL              NO-UNDO.

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateDataLogicObject'
    &PList        = "( INPUT pcDatabaseName,
                       INPUT pcTableName,
                       INPUT pcDumpName,
                       INPUT pcDataObjectName,
                       INPUT pcProductModule,
                       INPUT pcResultCode,
                       INPUT plSuppressValidation,
                       INPUT pcLogicProcedureName,
                       INPUT pcLogicObjectType,
                       INPUT pcLogicProcedureTemplate,
                       INPUT pcDataObjectRelativePath,
                       INPUT pcDataLogicRelativePath,
                       INPUT pcRootFolder,
                       INPUT pcFolderIndicator,
                       INPUT plCreateMissingFolder    )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

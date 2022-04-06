/*---------------------------------------------------------------------------------
  File: rydesgsdlp.p

  Description:  AppServer pass-through wrapper for generateSBODataLogicObject().

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDatabaseName           AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcTableList              AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDumpName               AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDataObjectName         AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcProductModule          AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcLogicProcedureName     AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcLogicObjectType        AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcLogicProcedureTemplate AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDataLogicRelativePath  AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcRootFolder             AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcIncludeFileList        AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER plCreateMissingFolder    AS LOGICAL              NO-UNDO.

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateSBODataLogicObject'
    &PList        = "( INPUT pcDatabaseName,
                       INPUT pcTableList,
                       INPUT pcDumpName,
                       INPUT pcDataObjectName,
                       INPUT pcProductModule,
                       INPUT pcResultCode,
                       INPUT pcLogicProcedureName,
                       INPUT pcLogicObjectType,    
                       INPUT pcLogicProcedureTemplate,
                       INPUT pcDataLogicRelativePath,
                       INPUT pcRootFolder, 
                       INPUT pcIncludeFileList,
                       INPUT plCreateMissingFolder    )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

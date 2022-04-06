/*---------------------------------------------------------------------------------
  File: rydesgedop.p

  Description:  AppServer pass-through wrapper for generateDataObject().

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
DEFINE INPUT PARAMETER pcObjectTypeCode         AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcProductModule          AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER plCreateSDODataFields    AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER plSdoDeleteInstances     AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER plSuppressValidation     AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER plFollowJoins            AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER piFollowDepth            AS INTEGER              NO-UNDO.
DEFINE INPUT PARAMETER pcFieldSequence          AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcLogicProcedureName     AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDataObjectRelativePath AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDataLogicRelativePath  AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcRootFolder             AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER plCreateMissingFolder    AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER pcAppServerPartition     AS CHARACTER            NO-UNDO.

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateDataObject'
    &PList        = "( INPUT pcDatabaseName,
                       INPUT pcTableName,
                       INPUT pcDumpName,
                       INPUT pcDataObjectName,
                       INPUT pcObjectTypeCode,
                       INPUT pcProductModule,
                       INPUT pcResultCode,
                       INPUT plCreateSDODataFields,
                       INPUT plSdoDeleteInstances,   
                       INPUT plSuppressValidation,
                       INPUT plFollowJoins,    
                       INPUT piFollowDepth,           
                       INPUT pcFieldSequence,
                       INPUT pcLogicProcedureName,
                       INPUT pcDataObjectRelativePath,
                       INPUT pcDataLogicRelativePath,
                       INPUT pcRootFolder,
                       INPUT plCreateMissingFolder,
                       INPUT pcAppServerPartition        )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

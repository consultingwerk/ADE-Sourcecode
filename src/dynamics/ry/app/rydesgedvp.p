/*---------------------------------------------------------------------------------
  File: rydesgedvp.p

  Description:  AppServer pass-through wrapper for generateDynamicViewer().

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectTypeCode            AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName                AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectDescription         AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcProductModuleCode         AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcSdoObjectName             AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER plDeleteExistingInstances   AS LOGICAL      NO-UNDO.
DEFINE INPUT  PARAMETER pcDisplayedDatabases        AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcEnabledDatabases          AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcDisplayedTables           AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcEnabledTables             AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcDisplayedFields           AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcEnabledFields             AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER piMaxFieldsPerColumn        AS INTEGER      NO-UNDO.
DEFINE INPUT  PARAMETER pcDataObjectFieldSequence   AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcDataObjectFieldList       AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pdVisualObjectObj           AS DECIMAL      NO-UNDO. 

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateDynamicViewer'
    &PList        = "(INPUT  pcObjectTypeCode,
                      INPUT  pcObjectName,
                      INPUT  pcObjectDescription,
                      INPUT  pcProductModuleCode,
                      INPUT  pcResultCode,
                      INPUT  pcSdoObjectName,
                      INPUT  plDeleteExistingInstances,
                      INPUT  pcDisplayedDatabases,
                      INPUT  pcEnabledDatabases,    
                      INPUT  pcDisplayedTables,      
                      INPUT  pcEnabledTables,       
                      INPUT  pcDisplayedFields,
                      INPUT  pcEnabledFields,       
                      INPUT  piMaxFieldsPerColumn,
                      INPUT  pcDataObjectFieldSequence,
                      INPUT  pcDataObjectFieldList,
                      OUTPUT pdVisualObjectObj         )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

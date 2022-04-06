/*---------------------------------------------------------------------------------
  File: rydesgevop.p

  Description:  AppServer pass-through wrapper for generateVisualObject().

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectType              AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectName              AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcProductModuleCode       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode              AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcSdoObjectName           AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcTableName               AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER pcDataBaseName            AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER piMaxObjectFields         AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER piMaxFieldsPerColumn      AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER plGenerateFromDataObject  AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER pcDataObjectFieldList     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plDeleteExistingInstances AS LOGICAL   NO-UNDO.
DEFINE INPUT  PARAMETER pcDataObjectFieldSequence AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER plUseSDOFieldOrder        AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER pdVisualObjectObj         AS DECIMAL   NO-UNDO.

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateVisualObject'
    &PList        = "( INPUT  pcObjectType,
                       INPUT  pcObjectName,
                       INPUT  pcProductModuleCode,
                       INPUT  pcResultCode,
                       INPUT  pcSdoObjectName,
                       INPUT  pcTableName,         
                       INPUT  pcDataBaseName,
                       INPUT  piMaxObjectFields,
                       INPUT  piMaxFieldsPerColumn,
                       INPUT  plGenerateFromDataObject,
                       INPUT  pcDataObjectFieldList,
                       INPUT  plDeleteExistingInstances,
                       INPUT  pcDataObjectFieldSequence,
                       INPUT  plUseSDOFieldOrder,
                       OUTPUT pdVisualObjectObj                )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

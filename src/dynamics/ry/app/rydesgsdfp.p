/*---------------------------------------------------------------------------------
  File: rydesgsdfp.p

  Description:  AppServer pass-through wrapper for generateDynamicSDF().

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcObjectName                AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectDescription         AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcProductModuleCode         AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode                AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER plDeleteExistingInstances   AS LOGICAL      NO-UNDO.
DEFINE INPUT  PARAMETER pcSDFType                   AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcSuperProcedure            AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeLabels           AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeValues           AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcAttributeDataType         AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pdSDFObjectObj              AS DECIMAL      NO-UNDO. 

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateDynamicSDF'
    &PList        = "( INPUT  pcObjectName,
                       INPUT  pcObjectDescription,
                       INPUT  pcProductModuleCode,
                       INPUT  pcResultCode,
                       INPUT  plDeleteExistingInstances,
                       INPUT  pcSDFType,
                       INPUT  pcSuperProcedure,
                       INPUT  pcAttributeLabels,        
                       INPUT  pcAttributeValues,       
                       INPUT  pcAttributeDataType,
                       OUTPUT pdSDFObjectObj               )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

/*---------------------------------------------------------------------------------
  File: rydesgedfp.p

  Description:  AppServer pass-through wrapper for generateDataFields().

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcDataBaseName           AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER pcTableName              AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER pcProductModuleCode      AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER pcResultCode             AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER plGenerateFromDataObject AS LOGICAL          NO-UNDO.
DEFINE INPUT PARAMETER pcDataObjectFieldList    AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER pcSdoObjectName          AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER pcObjectTypeCode         AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER pcOverrideAttributes     AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER pcFieldNames             AS CHARACTER        NO-UNDO.

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateDataFields'
    &PList        = "( INPUT pcDataBaseName,
                       INPUT pcTableName,
                       INPUT pcProductModuleCode,
                       INPUT pcResultCode,
                       INPUT plGenerateFromDataObject,
                       INPUT pcDataObjectFieldList,
                       INPUT pcSdoObjectName,
                       INPUT pcObjectTypeCode,
                       INPUT pcOverrideAttributes,
                       INPUT pcFieldNames             )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

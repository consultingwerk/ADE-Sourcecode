/*---------------------------------------------------------------------------------
  File: rydesgecfp.p

  Description:  AppServer pass-through wrapper for generateCalculatedField().

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcCalcFieldName          AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcDataType               AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFieldFormat            AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFieldLabel             AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFieldHelp              AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcProductModuleCode      AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcResultCode             AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcObjectTypeCode         AS CHARACTER  NO-UNDO.

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateCalculatedField'
    &PList        = "( INPUT pcCalcFieldName,
                       INPUT pcDataType,
                       INPUT pcFieldFormat,
                       INPUT pcFieldLabel,
                       INPUT pcFieldHelp,
                       INPUT pcProductModuleCode,
                       INPUT pcResultCode,
                       INPUT pcObjectTypeCode        )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

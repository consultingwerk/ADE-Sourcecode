/*---------------------------------------------------------------------------------
  File: rydesgeeip.p

  Description:  AppServer pass-through wrapper for generateEntityInstances().

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcEntityObjectName           AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER pcFieldList                  AS CHARACTER        NO-UNDO.
DEFINE INPUT PARAMETER plDeleteExistingInstances    AS LOGICAL          NO-UNDO.

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateEntityInstances'
    &PList        = "( INPUT pcEntityObjectName,
                       INPUT pcFieldList,
                       INPUT plDeleteExistingInstances  )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

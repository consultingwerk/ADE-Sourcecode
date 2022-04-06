/*---------------------------------------------------------------------------------
  File: rydesgeeop.p

  Description:  AppServer pass-through wrapper for generateEntityObject().

  Purpose:

  Parameters:   <none>

  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   07/16/2003  Author:     Peter Judge

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER pcTableNames             AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcEntityObjectType       AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcEntityProductModule    AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER plAutoProPerform         AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER piPrefixLength           AS INTEGER              NO-UNDO.
DEFINE INPUT PARAMETER pcSeparator              AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcAuditingEnabled        AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcDescFieldQualifiers    AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcKeyFieldQualifiers     AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER pcObjFieldQualifiers     AS CHARACTER            NO-UNDO.
DEFINE INPUT PARAMETER plDeployData             AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER plVersionData            AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER plReuseDeletedKeys       AS LOGICAL              NO-UNDO.
DEFINE INPUT PARAMETER plAssociateDataFields    AS LOGICAL              NO-UNDO.

{ src/adm2/globals.i }

{launch.i
    &PLIP         = 'ry/app/rygenomngp.p'
    &IProc        = 'generateEntityObject'
    &PList        = "( INPUT pcTableNames,
                       INPUT pcEntityObjectType,
                       INPUT pcEntityProductModule,
                       INPUT plAutoProPerform,
                       INPUT piPrefixLength,    
                       INPUT pcSeparator,
                       INPUT pcAuditingEnabled,
                       INPUT pcDescFieldQualifiers,
                       INPUT pcKeyFieldQualifiers,
                       INPUT pcObjFieldQualifiers,
                       INPUT plDeployData,
                       INPUT plVersionData,
                       INPUT plReuseDeletedKeys,
                       INPUT plAssociateDataFields   )"
    &PlipRunError = "RETURN ERROR cErrorMessage."
}
IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).

ASSIGN ERROR-STATUS:ERROR = NO.
RETURN.
/* *** E - O - F *** */

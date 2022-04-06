/*---------------------------------------------------------------------------------
  File: ryrepcopsp.p

  Description:  Dynamics AppServer proxy code: calculateObjectPaths()

  Purpose:      This procedure acts as the server-side proxy for the calculateObjectPaths()
                  API in the Repository Manager. 

  Parameters:   
                  
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/11/2003  Author:     Pjudge

  Update Notes: Created from Template aftemplipp.p
  
 -------------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pcObjectName            AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectObj             AS DECIMAL    NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectType            AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcProductModule         AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcObjectparameter       AS CHARACTER  NO-UNDO.
    DEFINE INPUT  PARAMETER pcNameSpace             AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcRootDirectory         AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcRelativeDirectory     AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcSCMRelativeDirectory  AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFullPathName          AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcOutputObjectName      AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFileName              AS CHARACTER  NO-UNDO.
    DEFINE OUTPUT PARAMETER pcError                 AS CHARACTER  NO-UNDO.
 
    {src/adm2/globals.i} 
    
    RUN  calculateObjectPaths IN gshRepositoryManager ( INPUT  pcObjectName,
                                                        INPUT  pcObjectObj,
                                                        INPUT  pcObjectType,
                                                        INPUT  pcProductModule,
                                                        INPUT  pcObjectparameter,
                                                        INPUT  pcNameSpace,
                                                        OUTPUT pcRootDirectory,
                                                        OUTPUT pcRelativeDirectory,
                                                        OUTPUT pcSCMRelativeDirectory,
                                                        OUTPUT pcFullPathName,
                                                        OUTPUT pcOutputObjectName,
                                                        OUTPUT pcFileName,
                                                        OUTPUT pcError                  ) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
/* E O F */
/*---------------------------------------------------------------------------------
  File: ryrepcopsp.p

  Description:  Dynamics AppServer proxy code: resolveResultCodes()

  Purpose:      This procedure acts as the server-side proxy for the resolveResultCodes()
                  API in the Repository Manager. 

  Parameters:   
                  
  History:
  --------
  (v:010000)    Task:           0   UserRef:    
                Date:   09/11/2003  Author:     Pjudge

  Update Notes: Created from Template aftemplipp.p
  
 -------------------------------------------------------------------------------------*/
    DEFINE INPUT        PARAMETER plDesignMode      AS LOGICAL          NO-UNDO.
    DEFINE INPUT-OUTPUT PARAMETER pcResultCodes     AS CHARACTER        NO-UNDO.
 
    {src/adm2/globals.i} 
    RUN resolveResultCodes IN gshRepositoryManager (INPUT        plDesignMode, 
                                                    INPUT-OUTPUT pcResultCodes) NO-ERROR.
    IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
        RETURN ERROR (IF RETURN-VALUE EQ "":U THEN ERROR-STATUS:GET-MESSAGE(1) ELSE RETURN-VALUE).
    
    ASSIGN ERROR-STATUS:ERROR = NO.
    RETURN.
/* E O F */
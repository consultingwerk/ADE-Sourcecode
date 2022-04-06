/*------------------------------------------------------------------------
  File:               indcuglob.i

  Description:        These are the DCU global variables for the managers
                      that may be used by the DCU.
                      
                      NOTE that these are not GLOBAL SHARED variables,
                      but rather variables that are frequently used in 
                      the DCU and therefore should only be initialized
                      once. 
                      
                      This include file contains definitions of the 
                      variables as well as the procedure that initializes
                      the variables with the appropriate manager handle.

  Author:             Bruce Gruenbaum

  Created:            08/07/2003
  
  Updates:
------------------------------------------------------------------------*/

DEFINE VARIABLE ghUIManager        AS HANDLE     NO-UNDO.
DEFINE VARIABLE glManagersStarted  AS LOGICAL    NO-UNDO.

SUBSCRIBE PROCEDURE THIS-PROCEDURE TO "DCU_ManagersStarted":U ANYWHERE.

glManagersStarted = LOGICAL(DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                             "dcu_managers_started":U)) NO-ERROR.
IF glManagersStarted = YES THEN
  RUN "DCU_ManagersStarted":U IN THIS-PROCEDURE.

PROCEDURE DCU_ManagersStarted:
  ghUIManager = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE,
                                               "InstallUIManager":U).
END.





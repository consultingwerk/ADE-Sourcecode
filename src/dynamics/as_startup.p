/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* asstartup.p */
DEFINE INPUT PARAMETER cStartupData       AS CHARACTER NO-UNDO.

/* pull in old Astra 1 global variables so triggers function until code
   is removed from them that uses these variables
*/
{af/sup/afghplipdf.i NEW GLOBAL}

/* global variables */
{src/adm2/globals.i}

/* The following code sets up the minimum path information that is
   essential to get the environment going */
{af/sup2/afsetuppath.i}

DEFINE VARIABLE hLoopHandle AS HANDLE     NO-UNDO.
DEFINE VARIABLE hProc AS HANDLE     NO-UNDO.
DEFINE VARIABLE cProc       AS CHARACTER  NO-UNDO.

cProc = SEARCH("af/app/afxmlcfgp.r").
IF cProc = ? THEN
  cProc = SEARCH("af/app/afxmlcfgp.p").

hLoopHandle = SESSION:FIRST-PROCEDURE.
DO WHILE VALID-HANDLE(hLoopHandle):
  IF R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.p":U) > 0
  OR R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.r":U) > 0 THEN 
  DO:
    hProc = hLoopHandle.
    hLoopHandle = ?.
  END.
  ELSE
    hLoopHandle = hLoopHandle:NEXT-SIBLING.
END. /* VALID-HANDLE(hLoopHandle) */

IF cProc = ? THEN
DO:
  RUN ICFCFM_InitializedServices.
END. /* cProc = ? */
ELSE /* cProc <> ? */
DO:

  IF NOT VALID-HANDLE(hProc) THEN 
  DO:
    RUN VALUE(cProc) PERSISTENT SET hProc.

    RUN subscribeAll IN THIS-PROCEDURE (hProc, THIS-PROCEDURE).
  
    RUN initializeSession IN THIS-PROCEDURE ("":U) NO-ERROR.
    IF RETURN-VALUE <> "" THEN
    DO:
      MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
          RETURN-VALUE.
      QUIT.
    END. /* RETURN-VALUE <> "" */

  END. /* NOT VALID-HANDLE(hProc) */

END. /* cProc <> ? */


/* prestart the data-related ADM2 super procedures */
/* no need to keep the handles as they can die on Appserver Agent shutdown */

RUN adm2/smart.p                PERSISTENT.
RUN adm2/query.p                PERSISTENT.
RUN adm2/data.p                 PERSISTENT.
RUN adm2/dataext.p              PERSISTENT.

PROCEDURE ICFCFM_InitializedServices:
  DEFINE VARIABLE cSessType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE htProperty    AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htService     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE htManager     AS HANDLE     NO-UNDO.
  
  IF CONNECTED("ICFDB":U) THEN
  DO:
    CREATE ALIAS AFDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS ASDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS RYDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS db_metaschema  FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS db_index       FOR DATABASE VALUE("ICFDB":U).
  END.

  IF cProc <> ? THEN
  DO:

    /* If we're running on the AppServer side, afsesstyperetr.p will look
       at the client_SessionType to determine connection parameters, etc.
       But we're starting the AppServer! So we have to fool afsesstyperetr.p
       into thinking that the client session type is what this is */
    cSessType = DYNAMIC-FUNCTION("getSessionParam":U IN THIS-PROCEDURE,
                                 "ICFSESSTYPE":U).

    DYNAMIC-FUNCTION("setSessionParam":U IN THIS-PROCEDURE,
                     "client_SessionType":U,
                     cSessType).

    /* Now we need to retrieve from the database the appropriate session
     information for this session. */
    RUN obtainSessionTableHandles IN THIS-PROCEDURE /* actually in config file maneger */
      (OUTPUT htProperty,
       OUTPUT htService,
       OUTPUT htManager).
  
    RUN af/app/afsesstyperetr.p ON gshAstraAppServer
      (INPUT-OUTPUT TABLE-HANDLE htProperty,
       INPUT-OUTPUT TABLE-HANDLE htService,
       INPUT-OUTPUT TABLE-HANDLE htManager) NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR RETURN-VALUE.
       
  
    RUN initializeWithChanges IN THIS-PROCEDURE NO-ERROR.
    IF ERROR-STATUS:ERROR THEN
      RETURN ERROR RETURN-VALUE.

  END.

END PROCEDURE.

PROCEDURE ICFCFM_ManagersStarted:
  DEFINE VARIABLE glICFRunning AS LOGICAL    NO-UNDO.
  glICFRunning = DYNAMIC-FUNCTION("isICFRunning":U IN THIS-PROCEDURE).
  IF glICFRunning = ? OR 
     glICFRunning = NO THEN
    RETURN "ICFSTARTERR: Unable to start Progress Dynamics. Managers not started.".
END.


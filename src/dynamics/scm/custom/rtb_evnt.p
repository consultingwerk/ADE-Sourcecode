/* rtb_evnt.p - This file provides hooks into Roundtable.

    By modifying rtb_evnt.p, you can intercept or filter various events
    that occur in a Roundtable session.  Roundtable call this routine
    when certain processing occurs.
    
Input Parameters:
    p_product : Currently, this is always "Roundtable".
    p_event   : The name of the event (eg. "Close", "Open", "Before-Save")
    p_context : A unique context string that can be used to compare the
                object, or context, of an event. (eg. This might be a
                RECID or HANDLE of the object being closed or opened).
                NOTE: this context string will be unique for a given
                class of events in a given product, but not necessarily
                across products or events.  That is, an event for a given
                window will always have the same context id, even if the
                name of the window changes.
   p_other    : Additional information passed about an event. (eg. a
                save event normally passes the File Name for the save).
                
Output Parameters:
    p_ok      : On a case by case basis, this procedure allows you to
                cancel various Roundtable events.
   
Here are the currently supported parameter values and events:

Create new object:
    
    p_product : "Roundtable"
    p_event   : "OBJECT-ADD-BEFORE"
    p_context : ""
    p_other   : Object name 
    p_ok      : logical - false will cancel the add
    
    p_product : "Roundtable"
    p_event   : "OBJECT-ADD"
    p_context : STRING value of RECID of the rtb_object table
    p_other   : Object name
    p_ok      : Ignored
    
Delete object:

    p_product : "Roundtable"
    p_event   : "OBJECT-DELETE-BEFORE"
    p_context : STRING value of RECID of the rtb_object table
    p_other   : Object name 
    p_ok      : logical - false will cancel the delete
    
    p_product : "Roundtable"
    p_event   : "OBJECT-DELETE"
    p_context : WIP version of the object that was deleted
    p_other   : Object Name
    p_ok      : Ignored


Create custom variant:

    p_product : "Roundtable"
    p_event   : "CREATE-CV-BEFORE"
    p_context : ""
    p_other   : Object name 
    p_ok      : logical - false will cancel
    
    p_product : "Roundtable"
    p_event   : "CREATE-CV"
    p_context : STRING value of RECID of the rtb_object table
    p_other   : Object name
    p_ok      : Ignored

Assign object:

    p_product : "Roundtable"
    p_event   : "ASSIGN-OBJECT-BEFORE"
    p_context : ""
    p_other   : Object name, Object type, Product Module, Version 
    p_ok      : logical - false will cancel
    
    p_product : "Roundtable"
    p_event   : "ASSIGN-OBJECT"
    p_context : STRING value of RECID of the rtb_object table
    p_other   : Object name
    p_ok      : Ignored

Compile object:
    
    p_product : "Roundtable"
    p_event   : "OBJECT-COMPILE-BEFORE"
    p_context : STRING value of RECID of the rtb_object table
    p_other   : Object name
    p_ok      : logical - false will cancel the compile

    p_product : "Roundtable"
    p_event   : "OBJECT-COMPILE"
    p_context : STRING value of RECID of rtb_object table
    p_other   : Object name
    p_ok      : Ignored
    
Complete object:
    
    p_product : "Roundtable"
    p_event   : "OBJECT-CHECK-IN-BEFORE"
    p_context : STRING value of RECID of the rtb_object table
    p_other   : Object name
    p_ok      : logical - false will cancel check in
    
    p_product : "Roundtable"
    p_event   : "OBJECT-CHECK-IN"
    p_context : STRING value of RECID of the rtb_object table
    p_other   : Object name
    p_ok      : Ignored

Check out object:
    
    p_product : "Roundtable"
    p_event   : "OBJECT-CHECK-OUT-BEFORE"
    p_context : STRING value of RECID of the rtb_object table
    p_other   : object name, check-out level ("version", "revision", or "patch")
    p_ok      : logical - false will cancel check out
    
    p_product : "Roundtable"
    p_event   : "OBJECT-CHECK-OUT"
    p_context : STRING value of RECID of the rtb_object table
    p_other   : Object name
    p_ok      : Ignored

Create deployment:
    
    p_product : "Roundtable"
    p_event   : "DEPLOY-BEFORE"
    p_context : STRING value of RECID of the rtb_site table
    p_other   : STRING value of RECID of the rtb_deploy table
    p_ok      : logical - false will cancel deployment
    
    p_product : "Roundtable"
    p_event   : "DEPLOY"
    p_context : STRING value of RECID of the rtb_site table
    p_other   : STRING value of RECID of the rtb_deploy table
    p_ok      : Ignored

Create release:
    
    p_product : "Roundtable"
    p_event   : "RELEASE-CREATE-BEFORE"
    p_context : ""
    p_other   : Workspace id
    p_ok      : logical - false will cancel release create
    
    p_product : "Roundtable"
    p_event   : "RELEASE-CREATE"
    p_context : ""
    p_other   : Workspace id, release number
    p_ok      : Ignored

Perform schema update:
    
    p_product : "Roundtable"
    p_event   : "SCHEMA-UPDATE-BEFORE"
    p_context : ""
    p_other   : Workspace id
    p_ok      : logical - false will cancel schema update
    
    p_product : "Roundtable"
    p_event   : "SCHEMA-UPDATE"
    p_context : ""
    p_other   : Workspace id
    p_ok      : Ignored

Create task:
    
    p_product : "Roundtable"
    p_event   : "TASK-CREATE-BEFORE"
    p_context : ""
    p_other   : Workspace id
    p_ok      : logical - false will cancel task create
    
    p_product : "Roundtable"
    p_event   : "TASK-CREATE-DURING"
    p_context : String value of RECID of rtb.rtb_task 
    p_other   : Task number in GUI - Wspace-id in TTY 
    p_ok      : Ignored
    
    p_product : "Roundtable"
    p_event   : "TASK-CREATE"
    p_context : String value of RECID of rtb.rtb_task 
    p_other   : Task number
    p_ok      : Ignored

Complete task:
    
    p_product : "Roundtable"
    p_event   : "TASK-COMPLETE-BEFORE"
    p_context : ""
    p_other   : Task number
    p_ok      : logical - false will cancel task completion
    
    p_product : "Roundtable"
    p_event   : "TASK-COMPLETE"
    p_context : ""
    p_other   : Task number
    p_ok      : Ignored

Create deployment site:
    
    p_product : "Roundtable"
    p_event   : "DEPLOY-SITE-CREATE-BEFORE"
    p_context : ""
    p_other   : Workspace, License Type, Site Code
    p_ok      : logical - false will cancel site creation
    
    p_product : "Roundtable"
    p_event   : "DEPLOY-SITE-CREATE"
    p_context : ""
    p_other   : Workspace id, License Type, Site Code
    p_ok      : Ignored

Import into a workspace:
    
    p_product : "Roundtable"
    p_event   : "IMPORT-BEFORE"
    p_context : ""
    p_other   : Workspace id
    p_ok      : logical - false will cancel import
    
    p_product : "Roundtable"
    p_event   : "IMPORT"
    p_context : ""
    p_other   : Workspace id
    p_ok      : Ignored

Changing workspaces:
    
    (IN TTY, the BEFORE-CHANGE-WORKSPACE would be better described as a
     "before select workspace".  It does not fire when you leave a WS. 
     It fires when you first select a workspace.)
     
    p_product : "Roundtable"
    p_event   : "BEFORE-CHANGE-WORKSPACE" 
    p_context : STRING(Grtb-proc-handle) (main Roundtable procedure handle)
                "?" in TTY.
    p_other   : Comma delimited list in GUI: From-Workspace,To-Workspace
                If there is no From-Workspace, From-Workspace is blank.
                When selecting "None" (no current workspace), To-Workspace
                is set to "None".  Workspace being selected in TTY
    p_ok      : False cancels the change-workspace in TTY.  Ignored in
                GUI (can't prevent workspace selection).

    p_product : "Roundtable"
    p_event   : "CHANGE-WORKSPACE"
    p_context : STRING(Grtb-proc-handle) (main Roundtable procedure handle)
                "?" in TTY
    p_other   : String value of the name of the workspace that was selected.
    p_ok      : Ignored. Can't prevent workspace selection.

Move To Web:

    p_product : "Roundtable",
    p_event   : "MOVE-TO-WEB-BEFORE",
    p_context : STRING value of RECID of rtb.rtb_object,
    p_other   : INPUT Object, Obj-Type, Pmod, WS Module 
    p_ok      : False cancels move

    p_product : "Roundtable",
    p_event   : "MOVE-TO-WEB",
    p_context : STRING value of RECID of rtb.rtb_object,
    p_other   : INPUT Object, Obj-Type, Pmod, WS Module 
    p_ok      : Ignored

Task Change:

    p_product : "Roundtable",
    p_event   : "TASK-CHANGE",
    p_context : "",
    p_other   : Task Number 
    p_ok      : Ignored
    
    
Partner Site Load

    p_product   :   "Roundtable",
    p_event     :   "PARTNER-LOAD-BEFORE",
    p_context   :   Potential Workspace ID,   /* no records are created yet */
    p_other     :   Workspace Path,  /* entry 1 is the root path */
    p_ok        :   Cancel load if FALSE,
    
    p_product   :   "Roundtable",
    p_event     :   "PARTNER-LOAD",
    p_context   :   String value of RECID of rtb.rtb_wspace loaded
    p_other     :   Workspace Path, /* entry 1 is the root path */
    p_ok        :   Cancel load if FALSE,
    

ProPath Change

    This is an unsupported hook in the fact that it may not be called 
    EVERY time the propath is changed (possible context are listed
    below).  
           
    p_product   :   "Roundtable",
    p_event     :   "PROPATH-CHANGE-BEFORE",
    p_context   :   RECID (table depends on context)
    p_other     :   context (see note)
    p_ok        :   Cancel change if FALSE,
    
    p_product   :   "Roundtable",
    p_event     :   "PROPATH-CHANGE",
    p_context   :   RECID (table depends on context)
    p_other     :   context (see note)
    p_ok        :   Ignored
      
    Possible "other" and "context" values include
        p_other     - BEFORE-COMPILE (both "PROPATH-CHANGE-BEFORE" and
                       A hooks)   
        p_context   - RECID is rtb_object to be compiled.  It is not perfect as
                      the workspace path is stripped from the ProPath before 
                      this hook is fired.                                              
        p_other     - AFTER-COMPILE  (both hooks)   
        p_context   - RECID is rtb_object that was compiled   
              
        p_other     - BEFORE-XREF (both hooks)    
        p_context   - RECID is rtb_object that was compiled   
        p_other     - AFTER (both hooks)    
        p_context   - RECID is rtb_object that was compiled           

Change Share Status

    p_product   :   "Roundtable",
    p_event     :   "OBJECT-CHANGE-SHARE-STATUS-BEFORE",
    p_context   :   String value of RECID for rtb.rtb_object
    p_other     :   Object, Old status, New Status, Workspace Path, Task Path
    p_ok        :   Cancel if false
        
    p_product   :   "Roundtable",
    p_event     :   "OBJECT-CHANGE-SHARE-STATUS",
    p_context   :   String value of RECID for rtb.rtb_object
    p_other     :   Object, Old status, New Status, Workspace Path, Task Path
    p_ok        :   Ignored

Roundtable Startup/Shutdown

    p_product   :   "Roundtable",
    p_event     :   "ROUNDTABLE-STARTUP",
    p_context   :   
    p_other     :   
    p_ok        :   Cancel if false
        
    p_product   :   "Roundtable",
    p_event     :   "ROUNDTABLE-SHUTDOWN",
    p_context   :   
    p_other     :   
    p_ok        :   Ignored

    p_product   :   "Roundtable",
    p_event     :   "SESSION-SHUTDOWN",
    p_context   :   
    p_other     :   
    p_ok        :   Ignored
*/

DEFINE INPUT  PARAMETER p_product   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p_event     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p_context   AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER p_other     AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER p_ok        AS LOGICAL    NO-UNDO INITIAL TRUE.

DEFINE VARIABLE cErrorMessage       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cReturnMessage      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hLoopHandle         AS HANDLE     NO-UNDO.
DEFINE VARIABLE hRtbEvent           AS HANDLE     NO-UNDO.
DEFINE VARIABLE hPreRtbEvent        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hXMLConfMan         AS HANDLE     NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE Grtb-desk-handle AS WIDGET-HANDLE NO-UNDO.

{rtb/g/rtbglobl.i}

ASSIGN
  cErrorMessage = "":U.

/*
  /* The following debugging code can be uncommented... */
  MESSAGE
    "Product:" p_product SKIP
    "Event:" p_event SKIP
    "Context:" p_context SKIP
    "Other Data:" p_other
    VIEW-AS ALERT-BOX QUESTION BUTTONS OK-CANCEL TITLE "rtb_evnt.p" UPDATE p_ok.
*/

IF NOT CONNECTED("ICFDB":U)
THEN RETURN.

/* First walk the widget tree and get the handles */
IF  p_product = "Roundtable"
THEN DO:

  /* See if already running first */
  ASSIGN
    hLoopHandle = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE(hLoopHandle):

    IF NOT VALID-HANDLE(hRtbEvent) AND 
       ( hLoopHandle:FILE-NAME    = "rtb/prc/ryrtbevntp.p":U OR    
         hLoopHandle:PRIVATE-DATA = "ryrtbevntp.p":U)
    THEN
      ASSIGN hRtbEvent = hLoopHandle.

    IF NOT VALID-HANDLE(hPreRtbEvent) AND 
       ( hLoopHandle:FILE-NAME    = "rtb/prc/rtbpreevent.p":U OR    
         hLoopHandle:PRIVATE-DATA = "rtbpreevent.p":U)
    THEN
      ASSIGN hPreRtbEvent = hLoopHandle.

    IF NOT VALID-HANDLE(hXMLConfMan) AND
       (R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.p":U) > 0 OR 
        R-INDEX(hLoopHandle:FILE-NAME,"afxmlcfgp.r":U) > 0)
    THEN
      ASSIGN hXMLConfMan = hLoopHandle.

    IF  VALID-HANDLE(hRtbEvent) AND 
        VALID-HANDLE(hPreRtbEvent) AND 
        VALID-HANDLE(hXMLConfMan) 
    THEN 
      ASSIGN hLoopHandle = ?.
    ELSE
      ASSIGN hLoopHandle = hLoopHandle:NEXT-SIBLING.
  END.

END.

/***********************************************************************************/
/* Pre-validation : Any code in this section is not bound to the Repository at all */
/***********************************************************************************/
IF  p_product = "Roundtable"
THEN DO:
  IF NOT VALID-HANDLE(hPreRtbEvent) THEN 
      RUN rtb/prc/rtbpreevent.p PERSISTENT SET hPreRtbEvent NO-ERROR.

  IF VALID-HANDLE(hPreRtbEvent) THEN
    RUN processPreEvent IN hPreRtbEvent
                       (INPUT p_event,
                        INPUT p_context,
                        INPUT p_other,
                        OUTPUT cReturnMessage).
  IF cReturnMessage <> "":U THEN 
  DO:
    IF cReturnMessage = "Cancelled":U THEN 
      ASSIGN p_ok = FALSE.
    ELSE 
      ASSIGN p_ok = TRUE.
    RETURN.
  END.
END.

/*****************/
/* Standard Code */
/*****************/

IF  p_product = "Roundtable" AND 
    p_event  <> "BEFORE-CHANGE-WORKSPACE" THEN 
DO:
  IF NOT VALID-HANDLE(hRtbEvent) THEN 
  DO:
    IF SEARCH("rtb/prc/ryrtbevntp.p":U) <> ? OR 
       SEARCH("rtb/prc/ryrtbevntp.r":U) <> ? THEN
      RUN rtb/prc/ryrtbevntp.p PERSISTENT SET hRtbEvent.
  END.
END.

IF  p_product = "Roundtable" AND 
    p_event   = "BEFORE-CHANGE-WORKSPACE" AND 
    ENTRY(1,p_other) <> "" THEN /* only if previous workspace valid - kill running plips */ 
DO:
  /* If the user has selected the same workspace as the from and to workspace
     (by having accidentally selected the same workspace as they currently
     have selected from the workspace combo) - then there is no need to shut
     down the framework. This can be doine by selecting workspace None and then 
     selecting the workspace again. 
     
     If the user has selected a different workspace or workspace None - then 
     the framework has to be shut down. 
     */ 
  IF NUM-ENTRIES(p_other) = 2 AND 
     ENTRY(1, p_other) = ENTRY(2, p_other) THEN
  RETURN.
  
  IF VALID-HANDLE(hXMLConfMan) THEN
    APPLY "CLOSE":U TO hXMLConfMan.    

  IF VALID-HANDLE(hRtbEvent) THEN
    RUN killPlip IN hRtbEvent.
    
  IF VALID-HANDLE(hPreRtbEvent) THEN    
    RUN killPlip IN hPreRtbEvent.
  
  ASSIGN 
      hXMLConfMan  = ?
      hRtbEvent    = ? 
      hPreRtbEvent = ?.
  
  /* Remove the Progress Dynamics menu from the tabletop */    
  RUN rtb/prc/afrtbmenup.p (INPUT Grtb-proc-handle).
END.

IF p_product = "Roundtable":U AND p_event = "CHANGE-WORKSPACE":U THEN 
DO:
  FIND FIRST rtb_wspace WHERE rtb_wspace.wspace-id = p_other NO-LOCK. 
  IF AVAILABLE rtb_wspace THEN
    IF INDEX(rtb_wspace.locked-by, "DCU":U) > 0 THEN 
    DO:
      ASSIGN cErrorMessage = "The Dynamics environment has not been started. The workspace is locked : " + "~n" + 
                              "'" + rtb_wspace.locked-by + "'" + "~n":U + "~n":U + 
                             "Access to the workspace is limited as the integration hooks between RTB" + "~n":U + 
                             "and Dynamics are not enabled. " + "~n":U + "~n":U + 
                             "Wait until the DCU upgrade has been completed and re-select the workspace, " + "~n":U + 
                             "or contact your system administrator for further information.".   
      
      MESSAGE
      cErrorMessage
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      
      IF VALID-HANDLE(hRtbEvent) THEN
        RUN killPlip IN hRtbEvent.
      
      RETURN.
    END.

  IF VALID-HANDLE(hRtbEvent) THEN 
     RUN icfstart.p NO-ERROR.  

  /* Add the Progress Dynamics menu to the tabletop */
  RUN rtb/prc/afrtbmenup.p (INPUT Grtb-proc-handle) NO-ERROR.
  
  /* Kill the RTB status handler Grtb-p-stat.
     This will be re-started when a workspace has been selected. 
     
     This cannot be done as part of the BEFORE-WORKSPACE-CHANGE event, as 
     the RTB desktop window makes use of the handle to the status window 
     during workspace selection.
     */
  IF VALID-HANDLE(Grtb-p-stat) THEN 
  DO:
    DELETE PROCEDURE Grtb-p-stat.   
    ASSIGN Grtb-p-stat = ?.     
  END.  
  
  IF NOT VALID-HANDLE(Grtb-p-stat) THEN
  IF SEARCH("rtb/p/rtb_stat.p") <> ? OR 
     SEARCH("rtb/p/rtb_stat.r") <> ? THEN 
  DO:
    /* Re-start the status handler for RTB. It is important that this is called 
       with a handle to a WINDOW widget. This must be the RTB desktop rtb_dek.w. 
       The code below is assuming that this is the current window. 
    */
    IF NOT VALID-HANDLE(Grtb-desk-handle) THEN
    ASSIGN Grtb-desk-handle = CURRENT-WINDOW:HANDLE.    
    
    RUN rtb/p/rtb_stat.p PERSISTENT SET Grtb-p-stat (INPUT Grtb-desk-handle).     
  END.
END.

IF  p_product = "Roundtable" THEN 
DO:
  IF VALID-HANDLE(hRtbEvent)
  THEN
    RUN process-event IN hRtbEvent
                     (INPUT p_event,
                      INPUT p_context,
                      INPUT p_other,
                      OUTPUT cErrorMessage).

  IF cErrorMessage <> "":U THEN
    MESSAGE
      "RTB Error: " + cErrorMessage
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
END.

IF cErrorMessage <> "":U
THEN 
  ASSIGN p_ok = FALSE.
ELSE 
  ASSIGN p_ok = TRUE.

RETURN.







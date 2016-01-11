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
    p_other   : Object name
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
    
  RTB variables is not available in this program
  grtb-userid
  grtb-wspace-id
  grtb-task-num
  grtb-proc-handle

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
*/

DEFINE INPUT  PARAMETER p_product   AS CHAR       NO-UNDO.
DEFINE INPUT  PARAMETER p_event     AS CHAR       NO-UNDO.
DEFINE INPUT  PARAMETER p_context   AS CHAR       NO-UNDO.
DEFINE INPUT  PARAMETER p_other     AS CHAR       NO-UNDO.
DEFINE OUTPUT PARAMETER p_ok        AS LOGICAL    NO-UNDO INITIAL TRUE.

DEFINE VARIABLE lh_handle           AS HANDLE     NO-UNDO.
DEFINE VARIABLE lh_rtbevntp         AS HANDLE     NO-UNDO.

DEFINE VARIABLE lv_error_message    AS CHARACTER  NO-UNDO.

ASSIGN
  lv_error_message = "":U.

/* The following debugging code can be uncommented... */
/*
MESSAGE "Product:" p_product SKIP
        "Event:" p_event SKIP
        "Context:" p_context SKIP
        "Other Data:" p_other
        VIEW-AS ALERT-BOX QUESTION 
                BUTTONS OK-CANCEL
                TITLE "rtb_evnt.p"
                UPDATE p_ok.
*/

IF NOT CONNECTED("ICFDB":U)
THEN RETURN.

IF  p_product = "Roundtable"
THEN DO:

  /* See if already running first */
  ASSIGN
    lh_handle = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE(lh_handle)
  AND NOT (VALID-HANDLE(lh_rtbevntp))
  :

    /* handle:FILE-NAME    = "rtb/prc/ryrtbevntp.p":U */
    /* handle:PRIVATE-DATA = "ryrtbevntp.p":U         */
    IF lh_handle:PRIVATE-DATA = "ryrtbevntp.p":U
    THEN
      ASSIGN
        lh_rtbevntp = lh_handle.

    ASSIGN
      lh_handle = lh_handle:NEXT-SIBLING.

  END.

END.

IF  p_product = "Roundtable"
AND p_event  <> "BEFORE-CHANGE-WORKSPACE"
THEN DO:

  IF NOT VALID-HANDLE(lh_rtbevntp)
  THEN DO:
    IF SEARCH("rtb/prc/ryrtbevntp.p":U) <> ?
    OR SEARCH("rtb/prc/ryrtbevntp.r":U) <> ?
    THEN
      RUN rtb/prc/ryrtbevntp.p PERSISTENT SET lh_rtbevntp.
  END.

END.

IF  p_product = "Roundtable"
AND p_event   = "BEFORE-CHANGE-WORKSPACE"
AND ENTRY(1,p_other) <> ""
THEN DO:              /* previous workspace - kill running plips */

  /* kill new ICF environment plips if installed  */
  IF SEARCH("af/sup2/afshutdwnp.p":U) <> ?
  OR SEARCH("af/sup2/afshutdwnp.r":U) <> ?
  THEN DO:
    RUN af/sup2/afshutdwnp.p.
  END.

  IF VALID-HANDLE(lh_rtbevntp)
  THEN
    RUN killPlip IN lh_rtbevntp.

END.

IF  p_product = "Roundtable"
AND p_event = "CHANGE-WORKSPACE"
THEN DO:

  IF SEARCH("icfstart.p":U) <> ? 
  OR SEARCH("icfstart.r":U) <> ?
  THEN
    RUN icfstart.p.

END.

IF  p_product = "Roundtable"
THEN DO:

  IF VALID-HANDLE(lh_rtbevntp)
  THEN
    RUN process-event IN lh_rtbevntp
                     (INPUT p_event
                     ,INPUT p_context
                     ,INPUT p_other
                     ,OUTPUT lv_error_message).

  IF lv_error_message <> "":U
  THEN
    MESSAGE
      "RTB Error: " + lv_error_message
      VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

END.

IF lv_error_message <> "":U
THEN ASSIGN p_ok = FALSE.
ELSE ASSIGN p_ok = TRUE.

RETURN.

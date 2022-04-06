&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
/* Procedure Description
"ADE Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME daftemwizcw
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" daftemwizcw _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" daftemwizcw _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" daftemwizcw _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS daftemwizcw 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: aftemwizcw.w

  Description:  Wizard controller window

  Purpose:      To control the execution of wizard windows

  Parameters:   ip_context_id (integer)  - recid of internal XFTR block (_TRG)
                trg-Code  (character) - code block of XFTR (body of XFTR)

  History:
  --------
  (v:010000)    Task:          41   UserRef:    AS0
                Date:   06/02/1998  Author:     Anthony Swindells

  Update Notes: Implement Wizard Controller

  (v:010001)    Task:          54   UserRef:    
                Date:   12/02/1998  Author:     Anthony Swindells

  Update Notes: Kill persistent procedure rtbprocp.p when finished

  (v:010005)    Task:         103   UserRef:    
                Date:   20/03/1998  Author:     Anthony Swindells

  Update Notes: Fix WRX problems.

  (v:010006)    Task:         142   UserRef:    
                Date:   06/04/1998  Author:     Anthony Swindells

  Update Notes: Modify wizards to only run if not editing in read-only mode, i.e. if the object
                being edited belongs to the current task.

  (v:010010)    Task:         864   UserRef:    
                Date:   14/12/1998  Author:     Anthony Swindells

  Update Notes: Make sure environment works if RTB not connected.

  (v:010011)    Task:        1216   UserRef:    
                Date:   02/04/1999  Author:     Anthony Swindells

  Update Notes: Implement V9 framework charges

  (v:010012)    Task:        6180   UserRef:    
                Date:   28/06/2000  Author:     Anthony Swindells

  Update Notes: V9 Templates

----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       aftemwizcw.w
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    010001

{ src/adm2/support/admhlp.i } /* ADM Help File Defs */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER ip_context_id AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER trg-Code  AS CHARACTER NO-UNDO.

/* Shared Variable Definitions ---                                      */

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE intro-text   AS CHARACTER NO-UNDO.
DEFINE NEW SHARED VARIABLE fld-list     AS CHARACTER NO-UNDO.

/* Used to keep track of persistent procedures during design */ 
DEFINE TEMP-TABLE tSupport NO-UNDO
  FIELD Hdl  AS HANDLE 
  FIELD Name AS CHAR.

/* Local global variables used in Functions */
DEFINE VARIABLE gFuncLibHdl      AS HANDLE                            NO-UNDO.
DEFINE VARIABLE gLastBtn         AS CHAR                              NO-UNDO.
DEFINE VARIABLE gStartedProcList AS CHARACTER                         NO-UNDO.

DEFINE VARIABLE gCancelOnfinish  AS LOG                               NO-UNDO.
DEFINE VARIABLE gPreView         AS LOG                               NO-UNDO.
DEFINE VARIABLE gPreViewName     AS CHAR                              NO-UNDO.

/* Support SBO as DataSource */
DEFINE VARIABLE gDataSourceNames   AS CHARACTER     INIT ?            NO-UNDO.
DEFINE VARIABLE gUpdateTargetNames AS CHARACTER     INIT ?            NO-UNDO.

DEFINE VARIABLE ptype            AS CHARACTER NO-UNDO.
DEFINE VARIABLE br-recid         AS CHARACTER NO-UNDO.
DEFINE VARIABLE h_win            AS CHARACTER NO-UNDO.  
DEFINE VARIABLE lCancel          AS LOG                               NO-UNDO.  

DEFINE VARIABLE pgm-list         AS CHARACTER NO-UNDO.
DEFINE VARIABLE dheight          AS INTEGER   NO-UNDO.
DEFINE VARIABLE dwidth           AS INTEGER   NO-UNDO.
DEFINE VARIABLE dTitle           AS CHARACTER NO-UNDO.
DEFINE VARIABLE Help-File        AS CHARACTER NO-UNDO.
DEFINE VARIABLE Help-Context     AS INTEGER   NO-UNDO.
DEFINE VARIABLE current-page     AS INTEGER   NO-UNDO.
DEFINE VARIABLE current-proc     AS HANDLE    NO-UNDO.
DEFINE VARIABLE tcode            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_code          AS CHARACTER NO-UNDO.

DEFINE VARIABLE r                AS RECID     NO-UNDO.
DEFINE VARIABLE ok_to_finish     AS LOGICAL   NO-UNDO INITIAL NO.
DEFINE VARIABLE cResult          AS CHARACTER NO-UNDO INITIAL NO.
DEFINE VARIABLE l                AS LOGICAL   NO-UNDO.
DEFINE VARIABLE gcRepositorySDO  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glRepository     AS LOGICAL    NO-UNDO INIT YES.

FUNCTION shutdown-sdo RETURNS LOGICAL
        (INPUT procHandle     AS HANDLE) IN gFuncLibHdl.

/* UIB API call general variables */
DEFINE VARIABLE lv_uibinfo                      AS CHARACTER    NO-UNDO.
DEFINE VARIABLE lv_srecid                       AS INTEGER      NO-UNDO.
DEFINE VARIABLE lv_definitions                  AS CHARACTER    NO-UNDO.

/* Handle to procedure containing Roundtable procedures */
DEFINE VARIABLE hScmTool                     AS HANDLE       NO-UNDO.

/* Roundtable/Object information variables */
DEFINE VARIABLE lv_task_number          AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_task_summary         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_description     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_programmer      AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_userref         AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_workspace       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_task_date            AS DATE NO-UNDO.
DEFINE VARIABLE lv_user_code            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_user_name            AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_name          AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_template_name        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_version       AS INTEGER NO-UNDO.
DEFINE VARIABLE lv_object_summary       AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_description   AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_upd_notes     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_previous_versions    AS CHARACTER NO-UNDO.
DEFINE VARIABLE lv_object_version_task  AS INTEGER NO-UNDO.


/* If we are opening a Template file and the wizard is one that is run when we
   first create a new program (i.e. it runs the af/sup/aftemwizew.w),
   then DON'T RUN THE WIZARD.  Use the
   standard UIB call to see if the current code record is in a Template file. */

RUN adeuib/_accsect.p ("GET":U,?,?,INPUT-OUTPUT ip_context_id,INPUT-OUTPUT lv_code).

RUN adeuib/_uibinfo.p (ip_context_id, ?, "TEMPLATE":U, OUTPUT cResult).
IF  cResult = STRING(yes) AND
    INDEX(lv_code,"af/cod/aftemwizew.w":U) <> 0
    THEN RETURN.

/* Special case for comments section XFTR - AFTEMWIZPW.W
   If the aftemwizpw.w wizard is called in an open event, then the code section
   will contain the special text "Check object version notes" - in which case this
   code should be run. It checks the program definition section for the current
   object version and if there is already an entry - aborts this XFTR, or if the
   program does not exist, the XFTR is aborted as it is a true create situation
   rather than a re-edit.
*/
IF INDEX(lv_code,"Check object version notes":U) <> 0 THEN
  DO:
    /* First check if the object has been saved, and if not, abort this XFTR as
       it is a true create situation */
    RUN adeuib/_uibinfo.p ( ?, ?, "FILE-NAME":U, OUTPUT lv_uibinfo ).
    IF lv_uibinfo = ? THEN RETURN.

    ASSIGN lv_uibinfo = TRIM(LC(REPLACE(lv_uibinfo,"~\":U,"/":U))).
    IF R-INDEX(lv_uibinfo,"/":U) > 0 THEN
        ASSIGN lv_uibinfo = TRIM(SUBSTRING(lv_uibinfo, R-INDEX(lv_uibinfo,"/":U) + 1)).
    ASSIGN lv_object_name = lv_uibinfo.
                            
    /* Next check the definition section for the current version notes */    
    hScmTool = DYNAMIC-FUNCTION('getProcedureHandle':U IN THIS-PROCEDURE, INPUT "PRIVATE-DATA:SCMTool":U).    
    
    IF VALID-HANDLE(hScmTool)
    THEN
      RUN rtb-get-taskinfo IN hScmTool
                  (   OUTPUT  lv_task_number,
                      OUTPUT  lv_task_summary,
                      OUTPUT  lv_task_description,
                      OUTPUT  lv_task_programmer,
                      OUTPUT  lv_task_userref,
                      OUTPUT  lv_task_workspace,
                      OUTPUT  lv_task_date   ).
    IF VALID-HANDLE(hScmTool)
    AND lv_object_name <> ""
    AND lv_task_number > 0
    THEN
      RUN rtb-get-objectinfo IN hScmTool
                  (    INPUT   lv_object_name,
                       INPUT   lv_task_number,
                       OUTPUT  lv_object_version,
                       OUTPUT  lv_object_summary,
                       OUTPUT  lv_object_description,
                       OUTPUT  lv_object_upd_notes,
                       OUTPUT  lv_previous_versions,
                       OUTPUT  lv_object_version_task).

    /* Get the current contents of the definition section */
    RUN adeuib/_accsect.p( "GET":U, ?, "DEFINITIONS":U,
                           INPUT-OUTPUT lv_srecid,
                           INPUT-OUTPUT lv_definitions ).

    /* Next check version history notes exist for this object version */
    IF lv_task_number = 0 OR lv_object_version = 0 OR
       lv_object_version_task <> lv_task_number OR
        INDEX(lv_definitions,"(v:":U + STRING(lv_object_version,"999999":U)) <> 0 THEN
        RETURN.

  END.

/* Do some very early checking and see if this wizard XFTR has been
 * flagged to be deleted. If so, delete it and do not continue
 * running the wizard. 
 */
ASSIGN tcode = TRIM(trg-Code).
IF TRIM(ENTRY(2, tcode,CHR(10))) = "Destroy on next read */":U THEN DO:
  RUN adeuib/_accsect.p ("DELETE":U,?,?,INPUT-OUTPUT ip_context_id,INPUT-OUTPUT trg-Code).
  RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME daftemwizcw

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b_Cancel b_back b_next b_finish re_rect 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSourceNames daftemwizcw 
FUNCTION getDataSourceNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFuncLibHandle daftemwizcw 
FUNCTION getFuncLibHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastButton daftemwizcw 
FUNCTION getLastButton RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPreview daftemwizcw 
FUNCTION getPreview RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPreViewName daftemwizcw 
FUNCTION getPreViewName RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getRepositorySDO daftemwizcw 
FUNCTION getRepositorySDO RETURNS CHARACTER
  ( OUTPUT plrep  AS LOGICAL)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSupportHandle daftemwizcw 
FUNCTION getSupportHandle RETURNS HANDLE
  (pName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateTargetNames daftemwizcw 
FUNCTION getUpdateTargetNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IsFirstRun daftemwizcw 
FUNCTION IsFirstRun RETURNS LOGICAL
  (pProgName As CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCancelOnFinish daftemwizcw 
FUNCTION setCancelOnFinish RETURNS LOGICAL
  (pCancelOnFinish As LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataSourceNames daftemwizcw 
FUNCTION setDataSourceNames RETURNS LOGICAL
  ( pcNames AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPreview daftemwizcw 
FUNCTION setPreview RETURNS LOGICAL
  (pOtherSave As CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPreviewName daftemwizcw 
FUNCTION setPreviewName RETURNS LOGICAL
  (pFileName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setRepositorySDO daftemwizcw 
FUNCTION setRepositorySDO RETURNS LOGICAL
  ( INPUT pcSDO AS CHAR,
    INPUT plRep AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateTargetNames daftemwizcw 
FUNCTION setUpdateTargetNames RETURNS LOGICAL
  ( pcNames AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON b_back 
     LABEL "< &Back" 
     SIZE 12 BY 1.

DEFINE BUTTON b_Cancel AUTO-END-KEY 
     LABEL "Cancel" 
     SIZE 12 BY 1.

DEFINE BUTTON b_finish AUTO-GO 
     LABEL "&Finish" 
     SIZE 12 BY 1.

DEFINE BUTTON b_next 
     LABEL "&Next >" 
     SIZE 12 BY 1.

DEFINE RECTANGLE re_rect
     EDGE-PIXELS 3 GRAPHIC-EDGE  NO-FILL 
     SIZE 53.2 BY 1.52.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME daftemwizcw
     b_Cancel AT ROW 18.14 COL 76.6
     b_back AT ROW 18.14 COL 89.6
     b_next AT ROW 18.14 COL 102.6
     b_finish AT ROW 18.14 COL 115.6
     re_rect AT ROW 17.86 COL 75.4
     SPACE(0.00) SKIP(0.13)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER NO-HELP 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE ""
         DEFAULT-BUTTON b_next CANCEL-BUTTON b_Cancel.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX daftemwizcw
                                                                        */
ASSIGN 
       FRAME daftemwizcw:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME daftemwizcw
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL daftemwizcw daftemwizcw
ON HELP OF FRAME daftemwizcw
DO:
  /* Help on Wizard Page Basics */
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Wizard}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL daftemwizcw daftemwizcw
ON WINDOW-CLOSE OF FRAME daftemwizcw
DO:
   APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_back
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_back daftemwizcw
ON CHOOSE OF b_back IN FRAME daftemwizcw /* < Back */
DO:
  gLastBtn = "BACK":U.
  RUN wizproc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Cancel daftemwizcw
ON CHOOSE OF b_Cancel IN FRAME daftemwizcw /* Cancel */
DO:
  gLastBtn = "CANCEL":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_finish
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_finish daftemwizcw
ON CHOOSE OF b_finish IN FRAME daftemwizcw /* Finish */
DO:
   DEFINE VARIABLE cUpdateTargets AS CHARACTER  NO-UNDO.
   IF VALID-HANDLE (current-proc) AND
       LOOKUP("validate-window":U,current-proc:INTERNAL-ENTRIES) > 0 THEN
   DO:
     RUN validate-window IN current-proc.
     IF LENGTH(RETURN-VALUE) > 0 THEN
     DO:
       IF RETURN-VALUE <> "ERROR":U THEN 
         MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX INFORMATION.
       RETURN NO-APPLY.
     END.
   END.    

   gLastBtn = "FINISH":U.
   /* If this is a SmartViewer or SmartBrowser then create the Fields or Columns */
   IF fld-list NE "":U THEN
   DO:
      /* if specified updateTargets then tell _crtsobj to enable these only */ 
      cUpdateTargets = getUpdateTargetNames().    
      IF cUpdateTargets <> ? THEN
        fld-list = fld-list + ";":U + cUpdateTargets.

      RUN adeuib/_crtsobj.w (ptype,fld-list).
   END.

   PUBLISH "ab_WizardFinished":U. 

   APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_next daftemwizcw
ON CHOOSE OF b_next IN FRAME daftemwizcw /* Next > */
DO:
  gLastBtn = "NEXT":U.
  RUN wizproc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK daftemwizcw 


/* ***************************  Main Block  *************************** */

/* Update SmartBrowser display */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U,  OUTPUT ptype).

getFuncLibHandle().

IF NUM-DBS = 0 
AND (pType BEGINS "WEB":U) = FALSE THEN 
DO:
  RUN adecomm/_dbcnnct.p (
    INPUT "You must have at least one connected database to create a " + ptype + " object.",
    OUTPUT l).
  if l eq no THEN RETURN.
END.
/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

ON U1 OF FRAME {&FRAME-NAME} DO:
  ASSIGN ok_to_finish = YES.
END.

ON U2 OF FRAME {&FRAME-NAME} DO:
  ASSIGN ok_to_finish = NO.
END.

ON END-ERROR OF FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE choice AS LOGICAL INITIAL NO NO-UNDO.
  MESSAGE "Are you sure you want to cancel?" VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE choice.
  IF NOT choice THEN RETURN NO-APPLY.
  ASSIGN gLastBtn = "CANCEL":U.
END.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK TRANSACTION:

  RUN Setup.
  IF pgm-list = "":U OR pgm-list = ? THEN DO:
    MESSAGE "No programs were specified!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
  RUN enable_UI.
  ASSIGN 
    current-page = 0
    lCancel      = true.
  RUN WizProc.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.
  ASSIGN 
    lCancel = no.
  /* Get handle of the window */
  RUN adeuib/_uibinfo.p (?, "WINDOW ?":U, "HANDLE":U, OUTPUT h_win).

  /* flag window as 'dirty' (needs to be saved) */
  RUN adeuib/_winsave.p (WIDGET-HANDLE(h_win), FALSE). 
END.

/* APPLY "close":U TO current-proc. */
/* RUN disable_UI.                  */

/* Cleanup */
RUN destroyObject.

IF ptype eq "SmartBrowser":U THEN DO:
  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "CONTAINS BROWSE RETURN CONTEXT":U,
                         OUTPUT br-recid).
  ASSIGN r = INT(br-recid).
  RUN adeuib/_undbrow.p (INPUT r). 
END.

/* qssuckr cleans up when '_abort' is returned.
   gCancelonfinish is used for html files that don't use the structured proc */ 

IF lCancel OR gCancelOnFinish THEN
  RETURN "_ABORT".

/*/* Delete the Wizard XFTR and its _TRG record. */
 * RUN adeuib/_accsect.p ("DELETE":U,?,?,INPUT-OUTPUT ip_context_id,INPUT-OUTPUT trg-Code).*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject daftemwizcw 
PROCEDURE destroyObject :
/*------------------------------------------------------------------------------
  Purpose:   Cleanup when cancel or finish    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
 RUN disable_UI.

  /* Delete the current page */
 IF VALID-HANDLE(current-proc) THEN
 DO:
   /* make sure no processing is done in the page */ 
   gLastBtn = "CANCEL":U. 
   APPLY "close":U TO current-proc.
 END.
 /* Kill sdo's (web) started by wizard pages */
 shutdown-sdo(THIS-PROCEDURE).

 FOR EACH tSupport:
   IF VALID-HANDLE(tSupport.Hdl) THEN
     APPLY "CLOSE" TO tSupport.Hdl.
 END.

/*  /* Delete the Wizard XFTR and its _TRG record. */                                        */
/*  RUN adeuib/_accsect.p ("DELETE":U,?,?,INPUT-OUTPUT ip_context_id,INPUT-OUTPUT trg-code). */
/*                                                                                           */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI daftemwizcw  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME daftemwizcw.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI daftemwizcw  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  ENABLE b_Cancel b_back b_next b_finish re_rect 
      WITH FRAME daftemwizcw.
  {&OPEN-BROWSERS-IN-QUERY-daftemwizcw}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSDOhandle daftemwizcw 
PROCEDURE getSDOhandle :
/*------------------------------------------------------------------------------
  Purpose: get the handle of the SDO and start it if it's not started.   
  Parameters: 
     INPUT pcFilename  - SDO name
     OUTPUT phHandle 

  Notes:  This is a procedure wrapper of the get-sdo-hdl function in abfunc.w 

          This encapsulates the initializeObject call that is necessary when 
          the remote "pretender" is started. (Because the remote http calls 
          has a wait-for this cannot be called from the function)       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcFileName AS CHAR   NO-UNDO.
  DEFINE OUTPUT PARAMETER phSDO      AS HANDLE NO-UNDO.

  phSDO = DYNAMIC-FUNCTION("get-sdo-hdl":U IN  getFuncLibHandle(),
                            pcFileName,
                            THIS-PROCEDURE).

  /* Remote "pretender" must be initialized, we cannot check objecttype 
    or anything, because the pretender will lie about anything (of course) 
    (Maybe we need to add a IamAPretender property?) */
  IF VALID-HANDLE(phSDO) AND phSDO:FILE-NAME = "web2/support/_rmtsdo.p":U THEN
     RUN initializeObject IN phSDO. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Setup daftemwizcw 
PROCEDURE Setup :
/*------------------------------------------------------------------------------
  Purpose:     Parses XFTR code block.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE tcode     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE firstline AS CHARACTER NO-UNDO.

  ASSIGN tcode      = TRIM(trg-Code)
         firstline  = ENTRY(1,tcode,CHR(10))
         dtitle     = TRIM(SUBSTRING(firstline,3,LENGTH(firstline) - 2,"CHARACTER":U))
         intro-text = ENTRY(2,tcode,CHR(10))
         pgm-list   = ENTRY(3,tcode,CHR(10)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WizProc daftemwizcw 
PROCEDURE WizProc :
/*------------------------------------------------------------------------------
  Purpose:     Manages wizard procedures
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF VARIABLE  num-pages AS INTEGER  NO-UNDO.

    ASSIGN
      num-pages = NUM-ENTRIES(pgm-list).

    IF num-pages = 1 THEN ASSIGN ok_to_finish = YES.

    IF current-page = 0 THEN DO: /* first time - initialize */
      ASSIGN current-page     = 1
             b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = no.
      IF num-pages = 1 THEN 
        ASSIGN b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = no
               b_Next:SENSITIVE IN FRAME {&FRAME-NAME} = no.
    END.
    ELSE DO:
      IF SELF:NAME = "b_Next":U THEN DO:
        IF (current-page + 1) <= num-pages THEN DO:

        IF VALID-HANDLE (current-proc) AND
            LOOKUP("validate-window":U,current-proc:INTERNAL-ENTRIES) > 0 THEN
          DO:
            RUN validate-window IN current-proc.
            IF LENGTH(RETURN-VALUE) > 0 THEN
              DO:
                IF RETURN-VALUE <> "ERROR":U THEN 
                    MESSAGE RETURN-VALUE VIEW-AS ALERT-BOX INFORMATION.
                RETURN.
              END.
          END.    
          APPLY "close":U TO current-proc.

          IF NOT VALID-HANDLE(current-proc) THEN           
            ASSIGN current-page     = current-page + 1
                   b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
        END.
        b_Next:SENSITIVE IN FRAME {&FRAME-NAME} = 
                                 (current-page < num-pages).
      END.
      ELSE IF SELF:NAME = "b_Back":U THEN DO:
        APPLY "close":U TO current-proc.
        ASSIGN current-page = current-page - 1
               b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = current-page > 1
               b_Next:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
      END.
    END.

    ASSIGN b_finish:SENSITIVE = (current-page eq num-pages) AND ok_to_finish
           FRAME {&FRAME-NAME}:TITLE = dtitle + " - Page ":U + string(current-page) +
                                       " of ":U + STRING(num-pages).    
    IF NOT VALID-HANDLE(current-proc)
    OR (current-proc:FILE-NAME <> TRIM(ENTRY(current-page,pgm-list))) THEN 
    DO:
      RUN VALUE(TRIM(ENTRY(current-page,pgm-list))) PERSISTENT 
        SET current-proc (INPUT FRAME {&FRAME-NAME}:HANDLE).     

      /* Add to list of started pages, 
         IsFirstRun() will now return false for this procedures name */ 

      IF NOT CAN-DO (gStartedProcList,current-proc:file-name) THEN
        ASSIGN gStartedProcList = (IF gStartedProcList = "":U 
                                   THEN "":U
                                   ELSE gStartedProcList + ",":U)
                                    + current-proc:file-name. 
    END.   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSourceNames daftemwizcw 
FUNCTION getDataSourceNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: Returns DataSourceNames picked from the SBO  
    Notes:  
------------------------------------------------------------------------------*/
  RETURN gDataSourceNames.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFuncLibHandle daftemwizcw 
FUNCTION getFuncLibHandle RETURNS HANDLE
  (  ) :
/*------------------------------------------------------------------------------
  Purpose: Return the handle of the AppBuilder function library .   
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT VALID-HANDLE(gFuncLibHdl) THEN 
  DO:
      gFuncLibHdl = SESSION:FIRST-PROCEDURE.
      DO WHILE VALID-HANDLE(gFuncLibHdl):
        IF gFuncLibHdl:FILE-NAME = "adeuib/_abfuncs.w":U THEN LEAVE.
        gFuncLibHdl = gFuncLibHdl:NEXT-SIBLING.
      END.
  END.
  RETURN gFuncLibHdl.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastButton daftemwizcw 
FUNCTION getLastButton RETURNS CHARACTER
  ( ) :
/*------------------------------------------------------------------------------
  Purpose: To be called from wizard pages to check if we are going back or forth   
  Notes:   gLastBtn is set in choose triggers
------------------------------------------------------------------------------*/

  RETURN gLastBtn.  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPreview daftemwizcw 
FUNCTION getPreview RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gPreview.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPreViewName daftemwizcw 
FUNCTION getPreViewName RETURNS CHARACTER
  () :
/*------------------------------------------------------------------------------
  Purpose: Get the preview filename so _wizend can redisplay if you 
           do back and next    
    Notes:  
------------------------------------------------------------------------------*/
  RETURN gPreViewName. 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getRepositorySDO daftemwizcw 
FUNCTION getRepositorySDO RETURNS CHARACTER
  ( OUTPUT plrep  AS LOGICAL) :
/*------------------------------------------------------------------------------
  Purpose:     Gets the SDO repository type (Dynamic or Static) which is called 
               from the wizard page icf/af/cod2/aftemwizow.w
  Parameters   pcRep     Rep
                         Static
  ReturnValue  Name of SDO in repository         
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN plrep  = glRepository .

  RETURN gcRepositorySDO.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSupportHandle daftemwizcw 
FUNCTION getSupportHandle RETURNS HANDLE
  (pName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Start a persistent support procedure that can be requested
           from the wizard pages.
    Notes:  
------------------------------------------------------------------------------*/
  DEF VAR Hdl AS HANDLE NO-UNDO.


  FIND tSupport WHERE tSupport.Name = pNAME NO-ERROR.

  IF AVAIL tSupport THEN 
    ASSIGN Hdl = tSupport.Hdl.

  ELSE  
  DO ON STOP UNDO,LEAVE:
    RUN VALUE (pName) PERSISTENT SET Hdl.     

    IF VALID-HANDLE(Hdl) THEN 
    DO:
      CREATE tSupport.
      ASSIGN 
        tSupport.Hdl  = Hdl
        tSupport.Name = pName.
    END.
  END.

  RETURN Hdl.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateTargetNames daftemwizcw 
FUNCTION getUpdateTargetNames RETURNS CHARACTER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  Returns UpdateTargetNames selected from the SBOs objects 
    Notes:  
------------------------------------------------------------------------------*/

  RETURN gUpdateTargetNames.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION IsFirstRun daftemwizcw 
FUNCTION IsFirstRun RETURNS LOGICAL
  (pProgName As CHAR):
/*------------------------------------------------------------------------------
  Purpose: Called from a Wizards page main block  to check if this is the 
           first time.  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN NOT CAN-DO(gStartedProcList,pProgName).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCancelOnFinish daftemwizcw 
FUNCTION setCancelOnFinish RETURNS LOGICAL
  (pCancelOnFinish As LOG) :
/*------------------------------------------------------------------------------
  Purpose: Set to true to DELETE the window on finish !
           Used for HTML file generation   
    Notes:  
------------------------------------------------------------------------------*/
  gCancelOnFinish = pCancelOnFinish.
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataSourceNames daftemwizcw 
FUNCTION setDataSourceNames RETURNS LOGICAL
  ( pcNames AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Saves DataSourceNames selected from the SBOs objects 
    Notes: These names are picked on the Data Source page and used to set 
           fields to exclude from the filed picker.
           The field list is used by the appbuilder to generate the 
           Displayed-tables preprocessor that again will become
           DataSourceNames in the viewer at run time.  
------------------------------------------------------------------------------*/
  gDataSourceNames = pcNames.   
  RETURN TRUE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPreview daftemwizcw 
FUNCTION setPreview RETURNS LOGICAL
  (pOtherSave As CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Set to true to DELETE the window on finish !
           Used for HTML file generation   
    Notes:  
------------------------------------------------------------------------------*/
  gPreView = TRUE.
  RETURN TRUE.    
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPreviewName daftemwizcw 
FUNCTION setPreviewName RETURNS LOGICAL
  (pFileName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose: Save the preview filename so _wizend can redisplay if you 
           do back and next    
    Notes:  
------------------------------------------------------------------------------*/
  gPreViewName = pFileName. 
  RETURN TRUE.   

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setRepositorySDO daftemwizcw 
FUNCTION setRepositorySDO RETURNS LOGICAL
  ( INPUT pcSDO AS CHAR,
    INPUT plRep AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:     Sets the SDO repository type (Dynamic or Static) which is called 
               from the wizard page icf/af/cod2/aftemwizow.w
  Parameters   pcSDO  Name of SDO in repository         
              
    Notes:  
------------------------------------------------------------------------------*/  
   ASSIGN gcRepositorySDO  = pcSDO
          glRepository     = plrep.
         
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateTargetNames daftemwizcw 
FUNCTION setUpdateTargetNames RETURNS LOGICAL
  ( pcNames AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose: Saves UpdateTargetNames selected from the SBOs objects 
    Notes: These names are picked on the Data Source page and used to disable 
          the fields. The enabled field list is used by the appbuilder to 
          generate the Enabled-tables preprocessor that again will become
          UpdateTargetNames in the viewer at run time.  
------------------------------------------------------------------------------*/
  gUpdateTargetNames = pcNames.   
  RETURN TRUE.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


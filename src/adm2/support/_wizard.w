&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12 GUI
/* Procedure Description
"ADE Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d_wizard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_wizard 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _wizard.w

  Description: Wizard driver program

  Input Parameters:
      trg-recid (int)  - recid of internal XFTR block (_TRG)

  Input-Output Parameters:
      trg-Code  (char) - code block of XFTR (body of XFTR)

  Author: Gerry Seidl

  Created: 4/3/95
  Changed: 3/12/98 HD Added logic to stop if NEXT gives error.              
              Function GetLastButton returns the last button pressed.  
              Wizproc do not start next if current was not deleted. 
 
  Changed: 4/8/98 HD Added IsFirstRun. 
              Some wizards need to know if this is the first time they are 
              running. 
              IsFirstRun will return TRUE in the Main Block of the wizard
              if thats the case.                   
  
  Changed: 6/25/98 HD Added setNoSave, setPreView and getPreview.
              setpreview is used ot enable     
  
  Notes:   A wizard procedure that needs validation on NEXT must do the following: 
           
           1. WizardHandle = SOURCE-PROCEDURE .  
           2. ON CLOSE of THIS-PROCEDURE:
                If DYNAMIC-FUNCTION(GetLastButton in WizardHandle) = "NEXT" then.
           3.  If something is wrong prevent deletion of the procedure by:            
                 RETURN NO-APPLY. 
                 
           You can override regular Progress 4gl code generation by 
           by calling the function setUseOtherSave.        
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{ src/adm2/support/admhlp.i } /* ADM Help File Defs */

{adecomm/oeideservice.i}

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER trg-recid AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER trg-Code  AS CHARACTER NO-UNDO.
DEFINE VARIABLE OEIDE_wizard     AS handle   NO-UNDO.
/* Shared Variable Definitions ---                                      */
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

/* set to true to avoid dialog box and allow embedding in IDE  */
DEFINE VARIABLE gUseWindow         AS LOGICAL                         NO-UNDO.


DEFINE VARIABLE ghWindow          AS HANDLE                            NO-UNDO.
DEFINE VARIABLE ghFrame           AS HANDLE                            NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE ptype            AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE br-recid         AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE h_win            AS CHARACTER                         NO-UNDO.  
DEFINE VARIABLE lCancel          AS LOG                               NO-UNDO.  

DEFINE VARIABLE pgm-list         AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE dheight          AS INTEGER                           NO-UNDO.
DEFINE VARIABLE dwidth           AS INTEGER                           NO-UNDO.
DEFINE VARIABLE dTitle           AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE Help-File        AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE Help-Context     AS INTEGER                           NO-UNDO.
DEFINE VARIABLE current-page     AS INTEGER                           NO-UNDO.
DEFINE VARIABLE current-proc     AS HANDLE                            NO-UNDO.
DEFINE VARIABLE tcode            AS CHARACTER                         NO-UNDO.

DEFINE VARIABLE r                AS RECID                             NO-UNDO.
DEFINE VARIABLE ok_to_finish     AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE cResult          AS CHARACTER                         NO-UNDO.
DEFINE VARIABLE l                AS LOGICAL                           NO-UNDO.
DEFINE VARIABLE hWaitFrame       AS HANDLE                            NO-UNDO.
define variable gSharedProjectNames as character no-undo. 
FUNCTION shutdown-sdo RETURNS LOGICAL
        (INPUT procHandle     AS HANDLE) IN gFuncLibHdl.

/* If we are opening a Template file, then DON'T RUN THE WIZARD.  Use the
   standard UIB call to see if the current code record is in a Template file. */
RUN adeuib/_uibinfo.p (trg-recid, ?, "TEMPLATE":U, OUTPUT cResult).
IF cResult eq STRING(yes) THEN RETURN.

/* Do some very early checking and see if this wizard XFTR has been
 * flagged to be deleted. If so, delete it and do not continue
 * running the wizard. 
 */
ASSIGN tcode = TRIM(trg-code).
IF TRIM(ENTRY(2, tcode,CHR(10))) = "Destroy on next read */":U THEN DO:
  RUN adeuib/_accsect.p ("DELETE":U,?,?,INPUT-OUTPUT trg-recid,INPUT-OUTPUT trg-code).
  RETURN.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME d_wizard

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b_Cancel b_back b_next b_finish 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDataSourceNames d_wizard 
FUNCTION getDataSourceNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFuncLibHandle d_wizard 
FUNCTION getFuncLibHandle RETURNS HANDLE
  (  )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLastButton d_wizard 
FUNCTION getLastButton RETURNS CHARACTER
  ( )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getNumPages d_wizard 
FUNCTION getNumPages RETURNS INTEGER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getOkToFinish d_wizard 
FUNCTION getOkToFinish RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPreview d_wizard 
FUNCTION getPreview RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getPreViewName d_wizard 
FUNCTION getPreViewName RETURNS CHARACTER
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSharedProjectNames d_wizard 
FUNCTION getSharedProjectNames returns character
  (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getSupportHandle d_wizard 
FUNCTION getSupportHandle RETURNS HANDLE
  (pName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUpdateTargetNames d_wizard 
FUNCTION getUpdateTargetNames RETURNS CHARACTER
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getUseWindow d_wizard 
FUNCTION getUseWindow RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD IsFirstRun d_wizard 
FUNCTION IsFirstRun RETURNS LOGICAL
  (pProgName As CHAR) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCancelOnFinish d_wizard 
FUNCTION setCancelOnFinish RETURNS LOGICAL
  (pCancelOnFinish As LOG)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setDataSourceNames d_wizard 
FUNCTION setDataSourceNames RETURNS LOGICAL
  ( pcNames AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPreview d_wizard 
FUNCTION setPreview RETURNS LOGICAL
  (pOtherSave As CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setPreviewName d_wizard 
FUNCTION setPreviewName RETURNS LOGICAL
  (pFileName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setSharedProjectNames d_wizard 
FUNCTION setSharedProjectNames returns logical
  (pcNames as char  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setUpdateTargetNames d_wizard 
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


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME d_wizard
     b_Cancel AT ROW 13.19 COL 34.14
     b_back AT ROW 13.19 COL 47.14
     b_next AT ROW 13.19 COL 60.14
     b_finish AT ROW 13.19 COL 73.14
     SPACE(1.45) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER NO-HELP 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE ""
         DEFAULT-BUTTON b_next.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d_wizard
   FRAME-NAME                                                           */
ASSIGN 
       FRAME d_wizard:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_wizard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_wizard d_wizard
ON HELP OF FRAME d_wizard
DO:
  /* Help on Wizard Page Basics */
  RUN adecomm/_adehelp.p ("AB":U, "CONTEXT":U, {&Help_on_Wizard}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_wizard d_wizard
ON WINDOW-CLOSE OF FRAME d_wizard
DO:
   APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_back
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_back d_wizard
ON CHOOSE OF b_back IN FRAME d_wizard /* < Back */
DO:
  gLastBtn = "BACK":U.
  RUN wizproc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_Cancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_Cancel d_wizard
ON CHOOSE OF b_Cancel IN FRAME d_wizard /* Cancel */
DO:
  gLastBtn = "CANCEL":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_finish
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_finish d_wizard
ON CHOOSE OF b_finish IN FRAME d_wizard /* Finish */
DO:
  run finishWizard.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_next d_wizard
ON CHOOSE OF b_next IN FRAME d_wizard /* Next > */
DO:
  gLastBtn = "NEXT":U.
  RUN wizproc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d_wizard 


/* ***************************  Main Block  *************************** */

ON END-ERROR OF FRAME {&FRAME-NAME} DO:
  DEFINE VARIABLE choice AS LOGICAL INITIAL NO NO-UNDO.
  MESSAGE "Are you sure you want to cancel?" VIEW-AS ALERT-BOX QUESTION
    BUTTONS YES-NO UPDATE choice.
  IF NOT choice THEN RETURN NO-APPLY.
  ASSIGN gLastBtn = "CANCEL":U.
END.

ON U1 OF FRAME {&FRAME-NAME} DO:
  ASSIGN ok_to_finish = YES.
END.

ON U2 OF FRAME {&FRAME-NAME} DO:
  ASSIGN ok_to_finish = NO.
END.

 
/* Update SmartBrowser display */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U,  OUTPUT ptype).

getFuncLibHandle().

IF NUM-DBS = 0 
AND (pType BEGINS "WEB":U) = FALSE
AND ptype = 'SmartDataObject':U THEN
DO:
  RUN adecomm/_dbcnnct.p (
    INPUT "You must have at least one connected database to create a " + ptype + " object.",
    OUTPUT l).
  if l eq no THEN 
      RETURN "_ABORT".
END.

if OEIDEIsrunning then 
do:    
  if valid-handle(hOEIDEService) then
  do:      
      run getIsIDEIntegrated in hOEIDEService (output gUseWindow ).
  end.     
end.     

if not gUseWindow then 
do:
  /* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
  IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
  THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.
end.

if gUseWindow then 
do:
   /** NOTE: adeuib/_templateinfo uses this line to check if the wizardd is supported */ 
   run adeuib/_oeidewizard.p persistent set OEIDE_wizard.
   run setWizard in OEIDE_wizard (this-procedure).  
    
   run createWindow(input-output ghwindow, input-output ghframe).  
   ON U1 OF ghFrame DO:
     ASSIGN ok_to_finish = YES.
   END.

   ON U2 OF ghFrame DO:
      ASSIGN ok_to_finish = NO.
   END.
    
end.
else do:
   ON U1 OF FRAME {&FRAME-NAME} DO:
     ASSIGN ok_to_finish = YES.
   END.

   ON U2 OF FRAME {&FRAME-NAME} DO:
      ASSIGN ok_to_finish = NO.
   END.
    
end.    
 
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON STOP    UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK :
   
  RUN Setup.
  IF pgm-list = "":U OR pgm-list = ? THEN DO:
    MESSAGE "No programs were specified for this Wizard." VIEW-AS ALERT-BOX.
    RETURN.
  END.
  if gUseWindow = false then 
  do:
    RUN enable_UI.
  end.
  ASSIGN 
    current-page = 0
    lCancel      = true.
  
  if gUseWindow then
     current-window = ghWindow.   
  
  RUN WizProc. 
  if gUseWindow = false then
     hWaitFrame = FRAME {&FRAME-NAME}:handle.
  else 
  do:
    view ghwindow.
    view ghframe.
    hWaitFrame = ghFrame.
/*    ON END-ERROR ANYWHERE                   */
/*    do:                                     */
/*       message "end-error"                  */
/*       view-as alert-box.                   */
/*        run cancelWizard in this-procedure. */
/*        return no-apply.                    */
/*    end.                                    */
/*    ON ENDKEY ANYWHERE                      */
/*    do:                                     */
/*       message "endkey"                     */
/*       view-as alert-box.                   */
/*        run cancelWizard in this-procedure. */
/*        /* set up for events from the ide */*/
/*        return no-apply.                    */
/*    end.                                    */
  end.
  
  WAIT-FOR GO OF hWaitFrame.
  /* have not been able to find a way to apply end-error or error for ide */
  if gLastBtn <> "Cancel":U then
  do:
     lCancel = no.
      
      /* Get handle of the window */
      RUN adeuib/_uibinfo.p (?, "WINDOW ?":U, "HANDLE":U, OUTPUT h_win).
      
      /* flag window as 'dirty' (needs to be saved) */
      RUN adeuib/_winsave.p (WIDGET-HANDLE(h_win), FALSE).
  end. 
END.
/* Cleanup */
RUN destroyObject.

/* qssuckr cleans up when '_abort' is returned.
   gCancelonfinish is used for html files that don't use the structured proc */ 

IF lCancel OR gCancelOnFinish THEN
  RETURN "_ABORT".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE cancelWizard d_wizard 
PROCEDURE cancelWizard :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    gLastBtn = "CANCEL". 
    if valid-handle(hWaitFrame) then 
        APPLY "GO":U TO hWaitFrame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createWindow d_wizard 
PROCEDURE createWindow :
/*------------------------------------------------------------------------------
  Purpose:  create window and frame that replaces the dialog-box 
            for embedding in IDE   
  Parameters:  <none>
  Notes:     
------------------------------------------------------------------------------*/
  DEFINE input-output parameter phWindow AS HANDLE NO-UNDO. 
  DEFINE input-output parameter phFrame AS HANDLE NO-UNDO. 
  
  define variable iHwnd as integer no-undo.
  
  create window phwindow
      assign width = frame {&frame-name}:width 
             height =  frame {&frame-name}:height 
             three-d = true
             message-area = false
             resize = false
             status-area = false  
        .
   
   run getViewHwnd in hOEIDEService ("","WIZARD",output iHwnd).       
   
   if iHwnd > 0 then 
   do:
       ASSIGN 
         phWindow:IDE-WINDOW-TYPE = 0 /* no window */ 
         phWindow:IDE-PARENT-HWND = iHwnd.
   end.         
    
   create frame phFrame
      assign width = frame {&frame-name}:width 
             height = frame {&frame-name}:height 
             three-d = true
             scrollable = false
        .
        
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyObject d_wizard 
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
 /* Kill sdos (web) started by wizard pages */
 shutdown-sdo(THIS-PROCEDURE).
  
 FOR EACH tSupport:
   IF VALID-HANDLE(tSupport.Hdl) THEN
     APPLY "CLOSE" TO tSupport.Hdl.
 END.

 /* Delete the Wizard XFTR and its _TRG record. */
 RUN adeuib/_accsect.p ("DELETE":U,?,?,INPUT-OUTPUT trg-recid,INPUT-OUTPUT trg-code).
 
 delete object ghwindow no-error.
 delete object ghframe no-error.
 if valid-handle(OEIDE_wizard) then
     run destroyObject in OEIDE_wizard.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d_wizard  _DEFAULT-DISABLE
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
  HIDE FRAME d_wizard.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d_wizard  _DEFAULT-ENABLE
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
  ENABLE b_Cancel b_back b_next b_finish 
      WITH FRAME d_wizard.
  {&OPEN-BROWSERS-IN-QUERY-d_wizard}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE finishWizard d_wizard 
PROCEDURE finishWizard :
DEFINE VARIABLE cUpdateTargets AS CHARACTER  NO-UNDO.

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
  
  /* adeweb/_genwpg.p subscribes */
  PUBLISH "ab_WizardFinished":U. 
 
  APPLY "GO":U TO hWaitFrame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getSDOhandle d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE oeide_Supported d_wizard 
PROCEDURE oeide_Supported PRIVATE :
/*------------------------------------------------------------------------------
                        Purpose: Java checks if this exists in the rcode to identify if the 
                                 wizard is supported.                                                                                                                                     
                        Notes:                                                                                                                                            
        ------------------------------------------------------------------------------*/
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Setup d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ShowCurrentPage d_wizard 
PROCEDURE ShowCurrentPage :
/*------------------------------------------------------------------------------
        Purpose: run the new page if curent-proc not valid/current-page .                                                                                                                                         
        Notes:                                                                                                                                            
        ------------------------------------------------------------------------------*/
    DEFINE VARIABLE    hParent   AS HANDLE   NO-UNDO.
 
    hParent   = if gUseWindow then ghFrame else FRAME {&FRAME-NAME}:handle.
    IF NOT VALID-HANDLE(current-proc)
    OR (current-proc:FILE-NAME <> TRIM(ENTRY(current-page,pgm-list))) THEN 
    DO:
        
      RUN VALUE(TRIM(ENTRY(current-page,pgm-list))) 
           PERSISTENT SET current-proc (hParent).
    
      /* Add to list of started pages, 
         IsFirstRun() will now return false for this procedures name */ 
      IF NOT CAN-DO (gStartedProcList,current-proc:file-name) THEN
      DO:
        ASSIGN gStartedProcList = (IF gStartedProcList = "":U 
                                   THEN "":U
                                   ELSE gStartedProcList + ",":U)
                                 + current-proc:file-name. 
                                 
         /*  TODO - signal this to IDE - see closeEditor in oeideservice. 
             the wizard pages adds endkey end-error events on the window handle
            (for design time?). This causes problems when we host this in 
             a window instead of a dialog. */
/*            The following auses a  GPF:                                    */
/*        ON END-ERROR OF {&WINDOW-NAME} OR ENDKEY OF {&WINDOW-NAME} ANYWHERE*/
/*          persistent run cancelWizard in this-procedure.                   */
/*                                                                           */
      END.                                 
    END.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidateAction d_wizard 
PROCEDURE ValidateAction :
DEFINE INPUT  PARAMETER pcAction         AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pcStatus         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lCurrentChanged AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lCanFinish      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lHasNext        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE lHasPrev        AS LOGICAL   NO-UNDO.
  
  /*------------------------------------------------------------------------------
   Purpose: Validates current-proc and adjusts current-page 
            according to pcAction if valid page                                                                                                                                          
   Notes:   Split the validation from display for IDE 
            Java display thread cannot wait for response from request that 
            displays data to IDE from ABL (from other thread)                                                                                                                                    
  ------------------------------------------------------------------------------*/
  DEFINE VARIABLE iPage AS INTEGER NO-UNDO.
  
  iPage = current-page.
  gLastBtn = pcAction.
 
 
  RUN ValidateCurrentPage.
 
  assign 
    lCurrentChanged = (iPage <> current-page)
    lCanFinish = ok_to_finish
    lHasNext   = current-page < num-entries(pgm-list)
    lHasPrev   = current-page > 1. 
   
  pcStatus = string(int(lCurrentChanged)) 
           + string(int(lCanFinish))
           + string(int(lHasNext))
           + string(int(lHasPrev)).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidateCurrentPage d_wizard 
PROCEDURE ValidateCurrentPage :
DEF    VARIABLE    num-pages AS INTEGER  NO-UNDO.
  
    num-pages = NUM-ENTRIES(pgm-list).
/*      MESSAGE "current-page" current-page*/
/*      VIEW-AS ALERT-BOX.                 */
    IF current-page = 0 THEN 
    DO: /* first time - initialize */
      ASSIGN current-page     = 1.
      if not gUseWindow then
      do: 
          b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = no.
          IF num-pages = 1 THEN 
             ASSIGN b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = no
                    b_Next:SENSITIVE IN FRAME {&FRAME-NAME} = no.
      end.
    END.
    ELSE DO:
      
      IF gLastBtn = "Next":U THEN 
      DO:
        IF (current-page + 1) <= num-pages THEN 
        DO:
          APPLY "close":U TO current-proc.
          IF NOT VALID-HANDLE(current-proc) THEN           
            ASSIGN current-page     = current-page + 1.
            if not gUseWindow then
                b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
        END.
        if not gUseWindow then
            b_Next:SENSITIVE IN FRAME {&FRAME-NAME} = (current-page < num-pages).
      END.
      ELSE IF gLastBtn = "Back":U THEN 
      DO:
        APPLY "close":U TO current-proc.
        ASSIGN current-page = current-page - 1.
        if not gUseWindow then
            assign
               b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = current-page > 1
               b_Next:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
      END.
    END.
    if not gUseWindow then
    do: 
        ASSIGN b_finish:SENSITIVE = (current-page eq num-pages) AND ok_to_finish
               FRAME {&FRAME-NAME}:TITLE = dtitle + " - Page ":U + string(current-page) +
                                " of ":U + STRING(num-pages).
                                
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WizProc d_wizard 
PROCEDURE WizProc :
/*------------------------------------------------------------------------------
  Purpose:     Manages wizard procedures
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    run ValidateCurrentPage.
    run ShowCurrentPage.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDataSourceNames d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFuncLibHandle d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLastButton d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getNumPages d_wizard 
FUNCTION getNumPages RETURNS INTEGER
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/ 
  RETURN num-entries(pgm-list). 

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getOkToFinish d_wizard 
FUNCTION getOkToFinish RETURNS LOGICAL
        (  ):
        /*------------------------------------------------------------------------------
                        Purpose:                                                                                                                                          
                        Notes:                                                                                                                                            
        ------------------------------------------------------------------------------*/
    RETURN ok_to_finish.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPreview d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getPreViewName d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSharedProjectNames d_wizard 
FUNCTION getSharedProjectNames returns character
  (  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
        return gSharedProjectNames.
end function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getSupportHandle d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUpdateTargetNames d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getUseWindow d_wizard 
FUNCTION getUseWindow RETURNS LOGICAL
        (  ):

        /*------------------------------------------------------------------------------
                        Purpose:                                                                                                                                          
                        Notes:                                                                                                                                            
        ------------------------------------------------------------------------------*/
   return gUseWindow.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION IsFirstRun d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCancelOnFinish d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setDataSourceNames d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPreview d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setPreviewName d_wizard 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setSharedProjectNames d_wizard 
FUNCTION setSharedProjectNames returns logical
  (pcNames as char  ):
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/
    gSharedProjectNames = pcNames.
        return true.

end function.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setUpdateTargetNames d_wizard 
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


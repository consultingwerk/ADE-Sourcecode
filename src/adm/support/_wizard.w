&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
/* Procedure Description
"ADE Wizard"
*/
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME d_wizard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS d_wizard 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
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
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER trg-recid AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER trg-Code  AS CHARACTER NO-UNDO.

/* Shared Variable Definitions ---                                      */

/* Local Variable Definitions ---                                       */
DEFINE NEW SHARED VARIABLE intro-text   AS CHARACTER NO-UNDO.

DEFINE VARIABLE ptype        AS CHARACTER NO-UNDO.
DEFINE VARIABLE br-recid     AS CHARACTER NO-UNDO.
DEFINE VARIABLE h_win        AS CHARACTER NO-UNDO.  

DEFINE VARIABLE pgm-list     AS CHARACTER NO-UNDO.
DEFINE VARIABLE dheight      AS INTEGER   NO-UNDO.
DEFINE VARIABLE dwidth       AS INTEGER   NO-UNDO.
DEFINE VARIABLE dTitle       AS CHARACTER NO-UNDO.
DEFINE VARIABLE Help-File    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Help-Context AS INTEGER   NO-UNDO.
DEFINE VARIABLE current-page AS INTEGER   NO-UNDO.
DEFINE VARIABLE current-proc AS HANDLE    NO-UNDO.
DEFINE VARIABLE tcode        AS CHARACTER NO-UNDO.

DEFINE VARIABLE r            AS RECID     NO-UNDO.
DEFINE VARIABLE ok_to_finish AS LOGICAL   NO-UNDO INITIAL NO.
DEFINE VARIABLE cResult      AS CHARACTER NO-UNDO INITIAL NO.
DEFINE VARIABLE l            AS LOGICAL   NO-UNDO.

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

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME d_wizard

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS b_Cancel b_back b_next b_finish 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
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
     b_Cancel AT ROW 12.43 COL 32
     b_back AT ROW 12.43 COL 45
     b_next AT ROW 12.43 COL 58
     b_finish AT ROW 12.43 COL 71
     SPACE(2.39) SKIP(0.37)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER NO-HELP 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE ""
         DEFAULT-BUTTON b_next.

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX d_wizard
   Default                                                              */
ASSIGN 
       FRAME d_wizard:SCROLLABLE       = FALSE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX d_wizard
/* Query rebuild information for DIALOG-BOX d_wizard
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX d_wizard */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME d_wizard
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL d_wizard d_wizard
ON WINDOW-CLOSE OF FRAME d_wizard
DO:
 DEFINE VARIABLE choice AS LOGICAL INITIAL NO NO-UNDO.
 MESSAGE "Are you sure you want to cancel?" VIEW-AS ALERT-BOX QUESTION
   BUTTONS YES-NO UPDATE choice.
 IF NOT choice THEN RETURN NO-APPLY.
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_back
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_back d_wizard
ON CHOOSE OF b_back IN FRAME d_wizard /* < Back */
DO:
  RUN wizproc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_finish
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_finish d_wizard
ON CHOOSE OF b_finish IN FRAME d_wizard /* Finish */
DO:
  APPLY "GO":U TO FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME b_next
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL b_next d_wizard
ON CHOOSE OF b_next IN FRAME d_wizard /* Next > */
DO:
  RUN wizproc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK d_wizard 


/* ***************************  Main Block  *************************** */
/* Update SmartBrowser display */
RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "TYPE":U,  OUTPUT ptype).

IF NUM-DBS = 0 THEN DO:
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

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK TRANSACTION:

  RUN Setup.
  IF pgm-list = "":U OR pgm-list = ? THEN DO:
    MESSAGE "No programs were specified!" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
  RUN enable_UI.
  ASSIGN current-page = 0.
  RUN WizProc.
  WAIT-FOR GO OF FRAME {&FRAME-NAME}.

  /* Get handle of the window */
  RUN adeuib/_uibinfo.p (?, "WINDOW ?":U, "HANDLE":U, OUTPUT h_win).
  
  /* flag window as 'dirty' (needs to be saved) */
  RUN adeuib/_winsave.p (WIDGET-HANDLE(h_win), FALSE). 
END.
APPLY "close":U TO current-proc.
RUN disable_UI.

IF ptype eq "SmartBrowser":U THEN DO:
  RUN adeuib/_uibinfo.p (?, "PROCEDURE ?":U, "CONTAINS BROWSE RETURN CONTEXT":U,
                         OUTPUT br-recid).
  ASSIGN r = INT(br-recid).
  RUN adeuib/_undbrow.p (INPUT r). 
END.

/* Delete the Wizard XFTR and its _TRG record. */
RUN adeuib/_accsect.p ("DELETE":U,?,?,INPUT-OUTPUT trg-recid,INPUT-OUTPUT trg-code).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI d_wizard _DEFAULT-DISABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI d_wizard _DEFAULT-ENABLE
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE WizProc d_wizard 
PROCEDURE WizProc :
/*------------------------------------------------------------------------------
  Purpose:     Manages wizard procedures
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF current-page = 0 THEN DO: /* first time - initialize */
      ASSIGN current-page     = 1
             b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = no.
      IF NUM-ENTRIES(pgm-list) = 1 THEN 
        ASSIGN b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = no
               b_Next:SENSITIVE IN FRAME {&FRAME-NAME} = no.
    END.
    ELSE DO:
      IF SELF:NAME = "b_Next":U THEN DO:
        IF (current-page + 1) <= NUM-ENTRIES(pgm-list) THEN DO:
          APPLY "close":U TO current-proc.
          ASSIGN current-page     = current-page + 1
                 b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
        END.
        IF current-page = NUM-ENTRIES(pgm-list) THEN
             b_Next:SENSITIVE IN FRAME {&FRAME-NAME} = no.
        ELSE b_Next:SENSITIVE IN FRAME {&FRAME-NAME} = yes.
        
      END.
      ELSE IF SELF:NAME = "b_Back":U THEN DO:
        APPLY "close":U TO current-proc.
        ASSIGN current-page = current-page - 1.
        IF current-page = 1 THEN b_Back:SENSITIVE IN FRAME {&FRAME-NAME} = no.
        ASSIGN b_Next:SENSITIVE = yes.
      END.
    END.
    IF current-page <> NUM-ENTRIES(pgm-list) THEN
      b_finish:SENSITIVE    = no.
    ELSE IF ok_to_finish THEN b_finish:SENSITIVE = yes.
    ELSE b_finish:SENSITIVE = no.
    
    ASSIGN FRAME {&FRAME-NAME}:TITLE = dtitle + " - Page ":U + 
      string(current-page) + " of ":U + STRING(NUM-ENTRIES(pgm-list)).
    RUN VALUE(TRIM(ENTRY(current-page,pgm-list))) PERSISTENT 
      SET current-proc (INPUT FRAME {&FRAME-NAME}:HANDLE).  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




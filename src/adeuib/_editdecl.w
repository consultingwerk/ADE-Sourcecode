&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2009 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _editdecl.w

  Description: Edit "declarative" statements

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Haavard Danielsen

  Created: 5/2009
  
  Modified by:
  
  Note:     
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions --- */            
define input parameter ph_win   as handle  no-undo.

/* Local Variable Definitions ---                                       */
&GLOBAL-DEFINE WIN95-BTN YES
{adeuib/uniwidg.i}
{adeuib/sharvars.i}
{adeuib/triggers.i}    /* Trigger TEMP-TABLE definitions                 */
{adeuib/uibhlp.i}    /* UIB Help File Defs */
 
DEFINE BUFFER      x_U FOR _U.
DEFINE BUFFER      x_P FOR _P.
 
DEFINE STREAM test.         /* Used for syntax checking                 */

FUNCTION compile-userfields RETURNS CHARACTER
  (INPUT p_U_PRecid AS RECID) IN _h_func_lib.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS declarations chk-syntax 
&Scoped-Define DISPLAYED-OBJECTS declarations af-label 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CheckSyntax Dialog-Frame 
FUNCTION CheckSyntax RETURNS LOGICAL
  ()  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD findTRG Dialog-Frame 
FUNCTION findTRG RETURNS LOGICAL
        (  ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON chk-syntax 
     LABEL "&Check Syntax" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE declarations AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 71 BY 7.29
     FONT 2 NO-UNDO.

DEFINE VARIABLE af-label AS CHARACTER FORMAT "X(256)":U INITIAL "&Declarative statements" 
      VIEW-AS TEXT 
     SIZE 23 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     declarations AT ROW 2.33 COL 3 NO-LABEL
     chk-syntax AT ROW 9.81 COL 59
     af-label AT ROW 1.52 COL 25 RIGHT-ALIGNED NO-LABEL
     SPACE(48.99) SKIP(9.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Edit Declarative Statements".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   FRAME-NAME Custom                                                    */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN af-label IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-R                                                    */
ASSIGN 
       declarations:RETURN-INSERTED IN FRAME Dialog-Frame  = TRUE.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Edit Declarative Statements */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME chk-syntax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL chk-syntax Dialog-Frame
ON CHOOSE OF chk-syntax IN FRAME Dialog-Frame /* Check Syntax */
DO:  
  IF CheckSyntax() THEN
    MESSAGE "Syntax is correct." VIEW-AS ALERT-BOX INFORMATION.         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME declarations
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL declarations Dialog-Frame
ON SHIFT-F2 OF declarations IN FRAME Dialog-Frame
DO:
  RUN CheckSyntax.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&Help_On_Declarative_Statements} }
if {&Help_On_Declarative_Statements} = 0 then 
   btn_help:visible = false.
/* For shortcut intended on the editor field */
ON ALT-U OF FRAME {&FRAME-NAME}
  APPLY "ENTRY" TO declarations.
  
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  FIND x_U WHERE x_U._HANDLE eq ph_win.
  FIND x_P WHERE x_P._u-recid eq RECID(x_U).
  findTRG().
  RUN enable_UI.
  
  RUN display-record.
  
   /* Whole thing is a transaction to handle cancel action               */
  DO TRANSACTION:
    WAIT-FOR GO OF FRAME {&FRAME-NAME}.
    RUN assign-record.
  END.  /* Transaction */
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assign-record Dialog-Frame 
PROCEDURE assign-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def var cError as char no-undo.
  
  do with frame {&FRAME-NAME}: 
    if not findTRG() then 
    do:
      create _TRG.
      assign _TRG._tSECTION = "_CUSTOM"
             _TRG._tEVENT = "_DECLARATIONS" 
             _TRG._wRECID   = RECID(x_U)
             _TRG._pRECID   = RECID(x_P).   
    end.
    _trg._tCode = declarations:SCREEN-VALUE.
       
    if not CheckSyntax() then 
        return error.
    
    cError = compile-userfields(RECID(_P)).
    if cError <> "" then 
    do:
      message
       "The following error was returned from the compiler:"
       SKIP(1)
       cerror 
      view-as alert-box information.
      return error.
    end.
  end.  /* Do with frame frame-name */
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE clear-screen Dialog-Frame 
PROCEDURE clear-screen :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
      ASSIGN declarations:SENSITIVE    = FALSE
             declarations:SCREEN-VALUE = "":U.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI Dialog-Frame  _DEFAULT-DISABLE
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
  HIDE FRAME Dialog-Frame.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE display-record Dialog-Frame 
PROCEDURE display-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  do with frame {&FRAME-NAME}:
     if avail _trg then  
       declarations:SCREEN-VALUE = _TRG._tCODE.
     declarations:SENSITIVE    = true.
  end.
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI Dialog-Frame  _DEFAULT-ENABLE
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
  DISPLAY declarations af-label 
      WITH FRAME Dialog-Frame.
  ENABLE declarations chk-syntax 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CheckSyntax Dialog-Frame 
FUNCTION CheckSyntax RETURNS LOGICAL
  () :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE errormsg AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE tmpfile  AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE i        AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE lAnswer  AS LOGICAL NO-UNDO.  
  RUN adecomm/_tmpfile.p ("T2":U, ".p":U, OUTPUT tmpfile).
    
  OUTPUT STREAM test TO VALUE(tmpfile) NO-MAP.
 
  do with frame {&FRAME-NAME}:   
    put stream test unformatted declarations:SCREEN-VALUE skip.
    output STREAM test CLOSE.
  
    compile VALUE(tmpfile) no-error.
    
    os-delete VALUE(tmpfile).
  
    if not compiler:error then
      return true.
    else do: /* Else a syntax error */
      /**
      if error-status:get-number(1) = 14145 then
      do:
          lAnswer = no. 
          message "This section is intended only for declarative statements, but has definitional or executable statements."
                  "Confirm that you want to continue."
               view-as alert-box question buttons yes-no.
               
      end.
      else */
  
      do i = 1 to error-status:num-messages:       
        errormsg = errormsg + error-status:get-message(i) + CHR(10). 
       
      end.    
      message REPLACE(errormsg,tmpfile,'')  view-as alert-box error.
 
      apply "ENTRY" to declarations.      
      declarations:CURSOR-OFFSET = compiler:file-offset.
      return false.
    end.    
  end. /* DO WITH FRAME {&FRAME-NAME} */
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION findTRG Dialog-Frame 
FUNCTION findTRG RETURNS LOGICAL
        (  ):
   find _TRG  where _TRG._wRECID    = RECID(x_U) and
                    _TRG._tSECTION = "_CUSTOM" and
                    _TRG._tEVENT   = "_DECLARATIONS"  no-error.
   return avail _trg.                 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


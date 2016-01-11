&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Dialog-Frame 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _umaint.w

  Description: Temp-table maintenance dialog-box for user fields

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Haavard Danielsen

  Created: 7/1998
  
  Modified by:
  
  Note:   This is a special case where only additional-fields are used.
          NO temp-table is defined.   
          User defined fields are treated as variables, but the Appbuilder 
          does not generate the definition. 
          The reason for keeping the user definitions here is that 
          the ANALYZE statement gives a compiler error if fields used in the
          frame are defined in the DEFINITION section.   
------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
&GLOBAL-DEFINE WIN95-BTN YES
{adeuib/uniwidg.i}
{adeuib/sharvars.i}
{adeuib/uibhlp.i}    /* UIB Help File Defs */

DEFINE VARIABLE row-recid   AS RECID                              NO-UNDO.
DEFINE STREAM test.         /* Used for syntax checking                 */

FUNCTION compile-userfields RETURNS CHARACTER
  (INPUT p_U_PRecid AS RECID) IN _h_func_lib.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS additnl-fields chk-syntax 
&Scoped-Define DISPLAYED-OBJECTS additnl-fields af-label 

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


/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON chk-syntax 
     LABEL "&Check Syntax" 
     SIZE 15 BY 1.14.

DEFINE VARIABLE additnl-fields AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 71 BY 7.29
     FONT 2 NO-UNDO.

DEFINE VARIABLE af-label AS CHARACTER FORMAT "X(256)":U INITIAL "&User Fields" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     additnl-fields AT ROW 2.33 COL 3 NO-LABEL
     chk-syntax AT ROW 9.81 COL 59
     af-label AT ROW 1.52 COL 14 RIGHT-ALIGNED NO-LABEL
     SPACE(59.99) SKIP(9.76)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "User Fields Maintenance".


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
   Custom                                                               */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.

ASSIGN 
       additnl-fields:RETURN-INSERTED IN FRAME Dialog-Frame  = TRUE.

/* SETTINGS FOR FILL-IN af-label IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-R                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* User Fields Maintenance */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME additnl-fields
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL additnl-fields Dialog-Frame
ON SHIFT-F2 OF additnl-fields IN FRAME Dialog-Frame
DO:
  RUN CheckSyntax.
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.

{adecomm/okbar.i &TOOL = "AB"
                 &CONTEXT = {&Help_On_User_Fields} }

/* For shortcut intended on the editor field */
ON ALT-U OF FRAME {&FRAME-NAME}
  APPLY "ENTRY" TO additnl-fields.
  
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
  
  FIND FIRST _UF WHERE _UF._p-recid    = RECID(_P) NO-ERROR.
  
  RUN enable_UI.
  
  IF AVAILABLE _UF THEN RUN display-record.
  
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
  DEF VAR cError AS CHAR NO-UNDO.
  
  DO WITH FRAME {&FRAME-NAME}: 
    FIND FIRST _UF WHERE _UF._p-recid  = RECID(_P) NO-ERROR.
    
    IF additnl-fields:SCREEN-VALUE = "":U AND AVAIL _UF THEN DELETE _UF.   
    
    ELSE DO:
      IF NOT AVAIL _UF THEN CREATE _UF.
    
      ASSIGN _UF._p-recid     = RECID(_P)            
             _UF._DEFINITIONS = additnl-fields:SCREEN-VALUE.
    END.
    
    IF NOT CheckSyntax() THEN RETURN ERROR.
    
    cError = compile-userfields(RECID(_P)).
    IF cError <> "" THEN 
    DO:
      MESSAGE
       "Some or one of the variables that are marked as"
       "User Fields are not defined properly." 
       SKIP
       "The following error was returned when checking definitions"
       "against User Fields:" 
       SKIP(1)
       cerror 
      VIEW-AS ALERT-BOX INFORMATION.
      RETURN ERROR.
    END.
  END.  /* Do with frame frame-name */
END PROCEDURE.

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
      ASSIGN additnl-fields:SENSITIVE    = FALSE
             additnl-fields:SCREEN-VALUE = "":U.
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
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN additnl-fields:SCREEN-VALUE = _UF._DEFINITIONS
           additnl-fields:SENSITIVE    = TRUE.
  END.
END PROCEDURE.

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
  DISPLAY additnl-fields af-label 
      WITH FRAME Dialog-Frame.
  ENABLE additnl-fields chk-syntax 
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
    
  RUN adecomm/_tmpfile.p ("T2":U, ".p":U, OUTPUT tmpfile).
    
  OUTPUT STREAM test TO VALUE(tmpfile) NO-MAP.
 
  DO WITH FRAME {&FRAME-NAME}:   
    PUT STREAM test UNFORMATTED additnl-fields:SCREEN-VALUE.
    
    OUTPUT STREAM test CLOSE.
  
    COMPILE VALUE(tmpfile) NO-ERROR.
  
    OS-DELETE VALUE(tmpfile).
  

    IF NOT COMPILER:ERROR THEN
      RETURN TRUE.
    ELSE DO: /* Else a syntax error */
      DO i = 1 TO ERROR-STATUS:NUm-MESSAGES:       
        errormsg = errormsg + ERROR-STATUS:GET-MESSAGE(i) + CHR(10). 
       
      END.    
      MESSAGE REPLACE(errormsg,tmpfile,'')  VIEW-AS ALERT-BOX ERROR.
      APPLY "ENTRY" TO additnl-fields.      
      additnl-fields:CURSOR-OFFSET = COMPILER:FILE-OFFSET.
      RETURN FALSE.
    END.    
  END. /* DO WITH FRAME {&FRAME-NAME} */
 
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r2 GUI
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
/*

Procedure:    adetran/pm/_resolve.w
Author:       R. Ryan
Created:      2/95 
Updated:      9/95
Purpose:      Dialog box for resolving consolidation conflicts.
Background:   This procedure is called from _ldtran.w and _ldgloss.w, which are,
              in turn, called by _consol.w - which is the main dialog for 
              consolidating translations and glossaries.               
Notes:        Reconciliation logic works like this: when a record for the kit is
              found in the project, but the records differ, then a conflict needs
              to be resolved.  This dialog is called when a flag from _consol.w
              asks that each conflict be addressed.
              
                o Replace existing target with new ..The kit overwrites the project        
                o Reject new stuff ....... ......... The project data wins over the kit 
                                                     and the new stuff is tossed aside.
              
Called by:    pm/_ldtran.p   passes conflicting translation strings
              pm/_ldgloss.p  passes conflicting glossary strings
              
Parameters:   pSource (input/char)        The source string from the project/kit
              pOldTarget (input/char)     The translation from the project
              pNewTarget (input/char)     The translation from the kit
              pResolve (output/char)      Which radio-set did the user press?
                                          N=Replace old stuff with newer stuff
                                          O=Reject newer stuff/keep older stuff
              pOKPressed (output/logical) Did the user press the ok button?
*/

define input parameter pSource as char no-undo.
define input parameter pOldTarget as char no-undo.
define input parameter pNewTarget as char no-undo.
define output parameter pResolve as char no-undo init true.
define output parameter pOKPressed as logical no-undo.

{ adetran/pm/tranhelp.i } /* definitions for help context strings */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK SourcePhrase BtnCancel BtnHelp ~
OldTarget NewTarget ResolveType Label1 Label2 Label3 ContainerRectangle1 
&Scoped-Define DISPLAYED-OBJECTS SourcePhrase OldTarget NewTarget ~
ResolveType Label1 Label2 Label3 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 12.2 BY 1.1.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 12.2 BY 1.1.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 12.2 BY 1.1.

DEFINE VARIABLE NewTarget AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 44.8 BY 1 NO-UNDO.

DEFINE VARIABLE OldTarget AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 44.8 BY 1 NO-UNDO.

DEFINE VARIABLE SourcePhrase AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 44.8 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE Label1 AS CHARACTER FORMAT "X(256)":U INITIAL "Source Phrase:" 
      VIEW-AS TEXT 
     SIZE 45.2 BY .86 NO-UNDO.

DEFINE VARIABLE Label2 AS CHARACTER FORMAT "X(256)":U INITIAL "Original Translation:" 
      VIEW-AS TEXT 
     SIZE 45 BY .86 NO-UNDO.

DEFINE VARIABLE Label3 AS CHARACTER FORMAT "X(256)":U INITIAL "New Translation:" 
      VIEW-AS TEXT 
     SIZE 45 BY .86 NO-UNDO.

DEFINE VARIABLE ResolveType AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Replace Project Data With &New Kit Translation", "N",
"Reject New Data and Keep &Old Project Translation", "O"
     SIZE 60 BY 1.57 NO-UNDO.

DEFINE RECTANGLE ContainerRectangle1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50 BY 7.14.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.48 COL 55
     SourcePhrase AT ROW 2.67 COL 6 NO-LABEL
     BtnCancel AT ROW 2.81 COL 55.2
     BtnHelp AT ROW 4.24 COL 55.2
     OldTarget AT ROW 4.81 COL 6 NO-LABEL
     NewTarget AT ROW 6.95 COL 6 NO-LABEL
     ResolveType AT ROW 9.1 COL 3 NO-LABEL
     Label1 AT ROW 1.71 COL 3.8 COLON-ALIGNED NO-LABEL
     Label2 AT ROW 3.86 COL 4 COLON-ALIGNED NO-LABEL
     Label3 AT ROW 6 COL 6 NO-LABEL
     ContainerRectangle1 AT ROW 1.48 COL 3
     SPACE(16.39) SKIP(2.66)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Resolve Conflict"
         DEFAULT-BUTTON BtnOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
   EXP-POSITION                                                         */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:ROW              = 1
       FRAME Dialog-Frame:COLUMN           = 1.

/* SETTINGS FOR FILL-IN Label3 IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Resolve Conflict */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
or help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("tran","context",49360, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK Dialog-Frame
ON CHOOSE OF BtnOK IN FRAME Dialog-Frame /* OK */
DO:
  assign
    pResolve   = ResolveType:screen-value
    pOKPressed = true.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Dialog-Frame 


/* ***************************  Main Block  *************************** */

/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */
IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME {&FRAME-NAME}:PARENT eq ?
THEN FRAME {&FRAME-NAME}:PARENT = ACTIVE-WINDOW.


/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
   assign
     Label1:screen-value    = "Source Phrase:"
     Label2:screen-value    = "Original Translation:"
     Label3:screen-value    = "New Translation:"
     Label1:width           = font-table:get-text-width-chars(Label1:screen-value,4)
     Label2:width           = font-table:get-text-width-chars(Label2:screen-value,4)
     Label3:width           = font-table:get-text-width-chars(Label3:screen-value,4).

  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} focus ResolveType.
END.
RUN disable_UI.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize Dialog-Frame 
PROCEDURE Realize :
frame {&frame-name}:hidden = true.

  assign
    SourcePhrase:read-only    = true
    OldTarget:read-only       = true
    NewTarget:read-only       = true   
    SourcePhrase:screen-value = pSource
    OldTarget:screen-value    = pOldTarget
    NewTarget:screen-value    = pNewTarget.

  enable     
    SourcePhrase
    OldTarget
    NewTarget
    ResolveType 
    BtnOK
    BtnCancel
    BtnHelp   
  with frame dialog-frame.
  
  frame {&frame-name}:hidden = false.                                            
  run adecomm/_setcurs.p ("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


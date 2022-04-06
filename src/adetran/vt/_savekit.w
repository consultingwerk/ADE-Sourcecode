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

  File: _savekit.w

  Description: 

  Input Parameters:

  Output Parameters:

  Author: 

  Created: 
  Updated: 11/96 SLK Long filename
        lc/caps
------------------------------------------------------------------------*/
define output parameter pZipName as char no-undo.     
define output parameter pSpanVolumes as logical no-undo.
define output parameter pOKPressed as logical no-undo.

{adetran/vt/vthlp.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS Rect3 BtnOK ZipName BtnFile BtnCancel ~
SpanVolumes ReplaceIfExists BtnHelp ZipLabel 
&Scoped-Define DISPLAYED-OBJECTS ZipName SpanVolumes ReplaceIfExists ~
ZipLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel AUTO-END-KEY 
     LABEL "Cancel":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnFile 
     LABEL "&Files...":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.14.

DEFINE VARIABLE EDITOR-1 AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 53.6 BY 1.62.

DEFINE VARIABLE ZipLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Zip File" 
      VIEW-AS TEXT 
     SIZE 9.6 BY .67 NO-UNDO.

DEFINE VARIABLE ZipName AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN NATIVE 
     SIZE 37.6 BY 1 NO-UNDO.

DEFINE RECTANGLE Rect3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 57.4 BY 3.67.

DEFINE VARIABLE ReplaceIfExists AS LOGICAL INITIAL no 
     LABEL "Replace If &Exists" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.8 BY .67 NO-UNDO.

DEFINE VARIABLE SpanVolumes AS LOGICAL INITIAL no 
     LABEL "Span Multiple &Volumes" 
     VIEW-AS TOGGLE-BOX
     SIZE 31.8 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.57 COL 61.2
     ZipName AT ROW 1.91 COL 4.4 NO-LABEL
     BtnFile AT ROW 1.95 COL 44
     BtnCancel AT ROW 2.86 COL 61.2
     EDITOR-1 AT ROW 3.1 COL 4.4 NO-LABEL
     SpanVolumes AT ROW 3.19 COL 5.6
     ReplaceIfExists AT ROW 3.86 COL 5.6
     BtnHelp AT ROW 4.14 COL 61
     ZipLabel AT ROW 1.24 COL 4.4 NO-LABEL
     Rect3 AT ROW 1.52 COL 2.6
     SPACE(17.99) SKIP(0.18)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Save Kit".


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Allow: Basic,Browse,DB-Fields,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX Dialog-Frame
                                                                        */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE.

/* SETTINGS FOR EDITOR EDITOR-1 IN FRAME Dialog-Frame
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN ZipLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN ZipName IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Save Kit */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFile Dialog-Frame
ON CHOOSE OF BtnFile IN FRAME Dialog-Frame /* Files... */
DO: 
  DEFINE VARIABLE ZipFile AS CHARACTER NO-UNDO.
  define var OKPressed as logical no-undo.

  SYSTEM-DIALOG GET-FILE ZipFile
     TITLE      "Zip File"
     FILTERS    "Zip Files (*.zip)" "*.zip",
                "All Files (*.*)"       "*.*" 
     USE-FILENAME
     UPDATE OKpressed.      

  IF OKpressed = TRUE THEN
    ZipName:screen-value = ZipFile.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
or help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("vt","context",123, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK Dialog-Frame
ON CHOOSE OF BtnOK IN FRAME Dialog-Frame /* OK */
DO:           
  /*
  ** Before doing anything, first test to see if a name 
  ** exists.
  */ 
  if ZipName:screen-value = "" then do:
    message "You must enter a filename first." view-as alert-box warning
    title "Zip Error".
    apply "entry" to ZipName.
    return no-apply.
  end.   
  
  apply "leave" to ZipName.

  /*
  ** OK, it exists, but check to see if we should overwrite this 
  */                             
  file-info:filename = entry(1,ZipName:screen-value,".") + ".db".
  if file-info:full-pathname <> ? and NOT ReplaceIfExists:checked then do:
    message ZipName:screen-value  skip(1)
    'This file already exists.' view-as alert-box warning title "Zip Error".
    apply "entry" to ReplaceIfExists.
    return no-apply.
  end.  
  else do:
    os-delete value(file-info:full-pathname).
  end.
     
  assign    
    pZipName     = ZipName:screen-value    
    pSpanVolumes = SpanVolumes:checked               
    pOKPressed   = true.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ZipName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ZipName Dialog-Frame
ON LEAVE OF ZipName IN FRAME Dialog-Frame
DO:
  define var TestName as char no-undo.
  define var DirName as char no-undo.
  define var BaseName as char no-undo.
  
  run adecomm/_osprefx.p (ZipName:screen-value,output DirName, output BaseName).  
  TestName = trim(entry(1,BaseName,".")). 


  /* Removed to allow long filenames
  if length(TestName,"CHARACTER") > 8 then do:
    message ZipName:screen-value skip 
      "This filename is not valid." view-as alert-box warning title "Filename Error".
    ZipName:auto-zap = true.
    apply "entry" to ZipName in frame Dialog-frame.
    return no-apply.  
  end.                      
  Removed to allow long filenames */
  
  if index(ZipName:screen-value,"a:\") > 0 or index(ZipName:screen-value,"b:\") > 0 then
     SpanVolumes:sensitive = true.
  else assign
    SpanVolumes:sensitive  = false
    SpanVolumes:checked    = false.
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
     ZipName              = ldbname("kit") + ".zip" 
     ZipName:screen-value = ZipName.
     
   RUN Realize.
   WAIT-FOR GO OF FRAME {&FRAME-NAME} focus ZipName.
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
DISPLAY ZipLabel SpanVolumes ReplaceifExists WITH FRAME Dialog-Frame.
  
  ENABLE
    ZipName BtnFile SpanVolumes ReplaceIfExists BtnOk BtnCancel BtnHelp
  WITH FRAME Dialog-Frame.
  
  SpanVolumes:sensitive = if index(ZipName:screen-value,"a:\") > 0 or
                             index(ZipName:screen-value,"b:\") > 0 
                          then true
                          else false.
    
  apply "value-changed" to ZipName.  
  frame {&frame-name}:hidden = false.                                            
  run adecomm/_setcurs.p ("").
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


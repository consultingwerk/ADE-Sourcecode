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
/*

Procedure:    adetran/pm/_consol.w
Author:       R. Ryan
Created:      2/95 
Updated:      9/95
Purpose:      Dialog box for consolidating kits
Background:   This program updates the connected project's 
              project, translation, and glossary tables with 
              data from the kit database.  The project manager
              picks from a combo-box list of kits.  If that kit
              isn't connected, it connects it.  Updating a glossary
              is optional.  
              
Notes:        Reconciliation logic works like this: when a record for the kit is
              found in the project, but the records differ, then a conflict needs
              to be resolved:
              
                o Keep newer stuff ......... The kit overwrites the project        
                o Keep older stuff ......... The project data wins over the kit and
                                             the kit data is toss aside
                o Ask about each conflict .. A conflict resolution dialog is
                                             displayed.  Once evaluated, either
                                             of the first two conditions are met.
              
Calls:        pm/_ldtran.p   loads kit translations
              pm/_ldgloss.p  loads kit glossary 
              pm/_resolve.w  resolves a conflict where project <> kit data 
*/

define output parameter pOKPressed as logical no-undo. 
define output parameter pErrorStatus as logical no-undo. 

{ adetran/pm/tranhelp.i } /* definitions for help context strings */  


define shared var _hGloss as handle no-undo.
define shared var _hKits as handle no-undo.
define shared var s_Glossary as char no-undo.
define shared var CurLanguage as char no-undo.  
define shared var KitDB as char no-undo.   
define shared var _Kit as char no-undo. 

define var OKPressed as logical no-undo.
define var Result as logical no-undo.
define var ErrorStatus as logical no-undo. 
define var ThisMessage as char no-undo.
define var i as integer no-undo.
define var KitList as char no-undo.
define var GlossaryList as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BtnOK KitName BtnCancel LanguageName BtnHelp ~
GlossaryName UpdateGlossary ReconcileType KitLabel GlossaryLabel ~
ReconcileLabel ContainerRectangle1 Rect-3 Rect2 
&Scoped-Define DISPLAYED-OBJECTS KitName LanguageName GlossaryName ~
UpdateGlossary ReconcileType KitLabel Language-txt GlossaryLabel ~
ReconcileLabel 

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

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnOK AUTO-GO 
     LABEL "OK":L 
     SIZE 15 BY 1.14.

DEFINE VARIABLE KitName AS CHARACTER FORMAT "X(256)":U 
     LABEL "Name" 
     VIEW-AS COMBO-BOX SORT INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE GlossaryName AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 32 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE LanguageName AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 32 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE GlossaryLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Glossary" 
      VIEW-AS TEXT 
     SIZE 11.6 BY .67 NO-UNDO.

DEFINE VARIABLE KitLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Translations" 
      VIEW-AS TEXT 
     SIZE 13.6 BY .67 NO-UNDO.

DEFINE VARIABLE Language-txt AS CHARACTER FORMAT "X(256)":U INITIAL "Language:" 
      VIEW-AS TEXT 
     SIZE 11 BY .76 NO-UNDO.

DEFINE VARIABLE ReconcileLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Reconciliation" 
      VIEW-AS TEXT 
     SIZE 14.6 BY .67 NO-UNDO.

DEFINE VARIABLE ReconcileType AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Always Keep &Newer Translations", 1,
"Always Keep &Older Translations", 2,
"&Ask About Each Conflict", 3
     SIZE 37 BY 2.38 NO-UNDO.

DEFINE RECTANGLE ContainerRectangle1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.4 BY 3.33.

DEFINE RECTANGLE Rect-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.4 BY 2.38.

DEFINE RECTANGLE Rect2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 46.4 BY 3.52.

DEFINE VARIABLE UpdateGlossary AS LOGICAL INITIAL yes 
     LABEL "&Update Glossary" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BtnOK AT ROW 1.71 COL 51
     KitName AT ROW 2.43 COL 13 COLON-ALIGNED
     BtnCancel AT ROW 3.14 COL 51
     LanguageName AT ROW 3.52 COL 15 NO-LABEL
     BtnHelp AT ROW 4.57 COL 51
     GlossaryName AT ROW 5.86 COL 15.6 NO-LABEL
     UpdateGlossary AT ROW 6.95 COL 15.6
     ReconcileType AT ROW 9.1 COL 8 NO-LABEL
     KitLabel AT ROW 1.48 COL 4 NO-LABEL
     Language-txt AT ROW 3.62 COL 2 COLON-ALIGNED NO-LABEL
     GlossaryLabel AT ROW 5.29 COL 4.4 NO-LABEL
     ReconcileLabel AT ROW 8.14 COL 4.8 NO-LABEL
     ContainerRectangle1 AT ROW 1.71 COL 2.6
     Rect-3 AT ROW 5.52 COL 3
     Rect2 AT ROW 8.43 COL 3
     SPACE(17.39) SKIP(0.56)
    WITH VIEW-AS DIALOG-BOX 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         FONT 4
         TITLE "Consolidate"
         DEFAULT-BUTTON BtnOK.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DIALOG-BOX
   Other Settings: COMPILE
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

/* SETTINGS FOR FILL-IN GlossaryLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN KitLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN Language-txt IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ReconcileLabel IN FRAME Dialog-Frame
   ALIGN-L                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Consolidate */
DO:
 APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp Dialog-Frame
ON CHOOSE OF BtnHelp IN FRAME Dialog-Frame /* Help */
or help of frame {&frame-name} do:
  run adecomm/_adehelp.p ("tran","context",{&Consolidate_Kit_Dialog_Box}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOK Dialog-Frame
ON CHOOSE OF BtnOK IN FRAME Dialog-Frame /* OK */
DO:
  DEFINE VARIABLE gloss-message AS CHARACTER                                 NO-UNDO.
  DEFINE VARIABLE trans-message AS CHARACTER                                 NO-UNDO.

  RUN adecomm/_setcurs.p ("WAIT":U).

  /* Automatically connect to the kit database  */
  FILE-INFO:filename = _kit.
  IF FILE-INFO:FULL-PATHNAME <> ? THEN DO:
    KitDB = FILE-INFO:FULL-PATHNAME.
    RUN adetran/common/_k-alias.p (OUTPUT ErrorStatus).
    IF ErrorStatus THEN DO:
      ThisMessage = _Kit + "^could not be connected.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":u, "ok":u, ThisMessage).
      RETURN NO-APPLY.
    END.  /* If there was an error */
  END.  /* If there is a valid file-name */

  /* Ready to load translations (database must be connected) ...  */
  FRAME {&FRAME-NAME}:HIDDEN = TRUE.
  RUN adetran/pm/_ldtran.p (
    ReconcileType:SCREEN-VALUE,
    KitName:SCREEN-VALUE,
    LanguageName:SCREEN-VALUE,
    OUTPUT ErrorStatus,
    OUTPUT trans-message).
  IF ErrorStatus THEN RETURN.
    
  /* Now load glossary  */  
  IF UpdateGlossary:CHECKED THEN DO:
    /* First check to see if glossary still exists */
    Result = YES.
    IF NOT CAN-FIND(FIRST xlatedb.XL_Glossary WHERE xlatedb.XL_Glossary.GlossaryName =
                          GlossaryName:SCREEN-VALUE) THEN DO:
      ThisMessage = "The " + GlossaryName:SCREEN-VALUE + " glossary" +
                   " has been deleted since this kit was created." +
                   "^^Do you want to recreate it?".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT result, "q*":U, "yes-no":U, ThisMessage).
      IF result THEN DO TRANSACTION:
        CREATE xlatedb.XL_Glossary.
        ASSIGN xlatedb.XL_Glossary.GlossaryName = GlossaryName:SCREEN-VALUE
               xlatedb.XL_Glossary.GlossaryType = CurLanguage + "/":U + 
                                                     LanguageName:SCREEN-VALUE
               xlatedb.XL_Glossary.CreateDate   = TODAY
               xlatedb.XL_Glossary.LinkType     = "S":U.
      END. /* If they want to recreate the glossary - TRANSACTION */
    END.  /* If the glossary has disappearred */
    IF result THEN
      RUN adetran/pm/_ldgloss.p (INPUT  GlossaryName:SCREEN-VALUE, 
                                 OUTPUT ErrorStatus,
                                 OUTPUT gloss-message). 
  END. /* If Glossary has been checked */
  RUN adecomm/_s-alert.p (INPUT-OUTPUT result, "i*":U, "ok":U,
       trans-message + "^":U + gloss-message). 
   
  RUN Realize IN _hKits. /* resets the percentage in the browse */
END.  /* End of trigger */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME KitName
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL KitName Dialog-Frame
ON VALUE-CHANGED OF KitName IN FRAME Dialog-Frame /* Name */
DO:
  if self:screen-value = "" then return.
  find xlatedb.XL_Kit where xlatedb.XL_Kit.KitName = self:screen-value
                      no-lock no-error.
  if available xlatedb.XL_Kit then do:
    LanguageName:screen-value = xlatedb.XL_Kit.LanguageName.
    GlossaryName:screen-value = xlatedb.XL_Kit.GlossaryName.
  end. 
  KitDB = KitName:screen-value.
  _Kit = KitName:screen-value.  
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

  DEFINE VARIABLE tmp-string AS CHARACTER NO-UNDO.
  
  run adetran/pm/_getproj.p (output GlossaryList, output KitList, output ErrorStatus).

  assign
    KitLabel:screen-value       = "Translations"
    GlossaryLabel:screen-value  = "Glossary"
    ReconcileLabel:screen-value = "Reconciliation"
    KitLabel:width              = font-table:get-text-width-chars(KitLabel:screen-value,4)
    GlossaryLabel:width         = font-table:get-text-width-chars(GlossaryLabel:screen-value,4)
    ReconcileLabel:width        = font-table:get-text-width-chars(ReconcileLabel:screen-value,4)
    KitName:list-items          = left-trim(KitList) 
    KitName:list-items          = replace(left-trim(KitName:List-Items,","),chr(10),"")
    UpdateGlossary:screen-value = string(true).
    
  tmp-string = ENTRY(NUM-ENTRIES(_Kit,"~\":U), _Kit,"~\":U).
  IF tmp-string = _Kit THEN
    tmp-string = ENTRY(NUM-ENTRIES(_Kit,"~/":U), _Kit,"~/":U).
  IF CAN-DO(KitName:List-Items, tmp-string) THEN KitName:SCREEN-VALUE = tmp-string.
  
  RUN Realize.
  WAIT-FOR GO OF FRAME {&FRAME-NAME} focus KitName.
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
 enable 
    KitName  
    LanguageName
    GlossaryName
    UpdateGlossary
    ReconcileType
    BtnOK
    BtnCancel
    BtnHelp   
  with frame dialog-frame.
  
  ASSIGN Language-txt:WIDTH = FONT-TABLE:GET-TEXT-WIDTH-CHARS(
                                 Language-txt, 4)
         Language-txt:X     = LanguageName:X - 
                              (SESSION:PIXELS-PER-COLUMN / 2) -
                              Language-txt:WIDTH-PIXELS - 1
         GlossaryName:read-only in frame dialog-frame = true
         LanguageName:read-only in frame dialog-frame = true.
  
  apply "value-changed" to KitName.
  ASSIGN frame {&frame-name}:hidden = false.
  DISPLAY Language-txt WITH FRAME {&FRAME-NAME}.
  run adecomm/_setcurs.p ("").
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


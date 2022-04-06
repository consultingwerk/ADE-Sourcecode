&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          kit              PROGRESS
*/
&Scoped-define WINDOW-NAME PropsWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS PropsWin 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_props.w
Author:       F. Chang
Created:      1/95 
Updated:      9/95
                12/96 SLK enabled TOOLTIP, handles TOOLTIP
                03/97 SLK Bug#97-01-16-036 tooltip target in source area
                      SLK Bug#97-03-05-072 switch doesn't switch tooltip labels
Purpose:      Visual Translator's Properties Window
Background:   This is a persistent procedure that is run from
              vt/_main.p *only* after a database is connected.
              Once connected, this window is run persistent 
              and hidden.  Besides _main.p, this is the single
              largest and most complicated piece of code in
              the Visual Translator. 
              
Notes:        When a procedure is visualized, that procedure
              has trigger code that address internal procedures
              that are found here (in hProps).  Double clicking on 
              an object does these things:
              
                1. CurWin is initialized to this procedure
                2. CurObj is the current object
                3. The object type is determined and list-items
                   for the 'ObjectType' are created.
                4. The 'vBasePhrase' is determined ...
                5. If 'AutoTrans' is true and a match exists in
                   XL_Instance, that translation is displayed both
                   on the visualized procedure and in the Properties
                   Window.
                6. If 'AutoTrans' is true and match wasn't available
                   in XL_Instance, but is available in XL_GlossEntry,
                   that match is displayed on the visualized procedure
                   and in the Properties Window. 
                7. The vBasePhrase is 'exploded' into word tokens and
                   the vBasePhrase combo is populated with all 
                   possibilities.
                                    
              Once a translation is made, either by picking it from the
              browser, or making it manually, this is what happens:
              
                1. The visualized procedure object property is updated 
                   (i.e. label, screen-value, radio-set, etc.).
                2. The translation is added to XL_Instance.
                3. If 'ConfirmAdds' is true, then the translator is
                   asked if this translation should be added to the glossary.
                4. If 'ConfirmAdds' is false, then the translation is
                   automatically added to the glossary *unless* it already
                   exists.                                
                   
Procedures:   Key procedures include:    

                MenuLbl         reads temp table of menu labels.
                SetSensitivity  enables/disables buttons in the window.
                FindObjectType  identifies the type of object this is.  
                FindSourceValue identifies the source value to use.
                FindTargetValue gets the target to use.
                
Variables:    Key variables include:   

                PropsWindow     this window handle
                hProps          this procedure's handle
                CurWin          the current visualized procedure's
                                window handle.
                CurObj          the current visualized procedure's
                                object handle.
                
                                             
Includes:     vt/_props.i   vt/_prpty.i
Called by:    vt/_main.p 
*/



CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{adetran/vt/vthlp.i}
{adetran/vt/_shrvar.i}
DEFINE SHARED VARIABLE tDispType AS CHARACTER                        NO-UNDO.

DEFINE VARIABLE CurrentPointer    AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE ErrorStatus       AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE NewTrans          AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE no-andpersand     AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE ObjectGroup       AS WIDGET-HANDLE                    NO-UNDO.
DEFINE VARIABLE pFileSav          AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE rc                AS INTEGER                          NO-UNDO.
DEFINE VARIABLE result            AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE tBrColWH          AS WIDGET-HANDLE                    NO-UNDO.
DEFINE VARIABLE tChar             AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE tCharSav          AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE ThisMessage       AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE tInt              AS INTEGER                          NO-UNDO.
DEFINE VARIABLE tInt2             AS INTEGER                          NO-UNDO.
DEFINE VARIABLE tmpChar           AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE tmp-flnm          AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE tmp-string        AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE tnextsib          AS WIDGET-HANDLE                    NO-UNDO.
DEFINE VARIABLE tPrevWh           AS WIDGET-HANDLE                    NO-UNDO.
DEFINE VARIABLE tSTFlg            AS LOGICAL   FORMAT "Source/Target" NO-UNDO.
DEFINE VARIABLE tTopList          AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE hParObj           AS HANDLE                           NO-UNDO.
DEFINE VARIABLE cOrigTargetPhrase AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE tmpdir            AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE tmpfile           AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE tmppos            AS INTEGER                          NO-UNDO.
DEFINE VARIABLE tParent           AS WIDGET-HANDLE                    NO-UNDO.

DEFINE TEMP-TABLE ww  NO-UNDO  /* Wigdet Walker                   */
  FIELD wndw   AS HANDLE       /* Window                          */
  FIELD sq     AS INTEGER      /* Sequence (frame sq or Browse sq)*/
  FIELD rw     AS INTEGER      /* Row (to nearest int)            */
  FIELD cl     AS INTEGER      /* Column (to nearest int)         */
  FIELD is-frm AS LOGICAL      /* Is this a frame ?               */
  FIELD fldgrp AS HANDLE       /* Field Group                     */
  FIELD hndl   AS HANDLE       /* Widget-Handle                   */
 INDEX wndw-seq IS PRIMARY wndw sq rw cl
 INDEX is-frm              wndw is-frm sq
 INDEX hndl                hndl
 INDEX fldgrp              fldgrp.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME LookUpBrowser

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES kit.XL_GlossEntry

/* Definitions for BROWSE LookUpBrowser                                 */
&Scoped-define FIELDS-IN-QUERY-LookUpBrowser kit.XL_GlossEntry.TargetPhrase 
&Scoped-define ENABLED-FIELDS-IN-QUERY-LookUpBrowser 
&Scoped-define OPEN-QUERY-LookUpBrowser OPEN QUERY LookUpBrowser FOR EACH kit.XL_GlossEntry ~
      WHERE kit.XL_GlossEntry.ShortSrc BEGINS SUBSTRING(tmp-string, 1, 63, "RAW":U) ~
 AND kit.XL_GlossEntry.SourcePhrase MATCHES tmp-string NO-LOCK.
&Scoped-define TABLES-IN-QUERY-LookUpBrowser kit.XL_GlossEntry
&Scoped-define FIRST-TABLE-IN-QUERY-LookUpBrowser kit.XL_GlossEntry


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-LookUpBrowser}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 BtnClose BtnMovePrev BtnMoveNext ~
BtnFrames BtnExpose BtnSwitch BtnHelp ObjectType vBasePhrase vTranslation ~
BtnSave LookUpBrowser UseWordIdx TargetLabel ChoiceLabel 
&Scoped-Define DISPLAYED-OBJECTS ObjectType vBasePhrase vTranslation ~
UseWordIdx TargetLabel ChoiceLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 DEFAULT-FRAME 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR PropsWin AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mFile 
       MENU-ITEM mSave          LABEL "&Save"         
       MENU-ITEM mClose         LABEL "&Close"        .

DEFINE SUB-MENU mEdit 
       MENU-ITEM mCut           LABEL "Cut"            ACCELERATOR "SHIFT-DEL"
       MENU-ITEM mCopy          LABEL "Copy"           ACCELERATOR "CTRL-INS"
       MENU-ITEM mPaste         LABEL "Paste"          ACCELERATOR "SHIFT-INS".

DEFINE SUB-MENU mView 
       MENU-ITEM mSource        LABEL "&Source"       
              TOGGLE-BOX
       MENU-ITEM mTarget        LABEL "&Target"       
              TOGGLE-BOX.

DEFINE SUB-MENU mObject 
       MENU-ITEM mNextFrame     LABEL "Next &Frame"   
       MENU-ITEM mNextObject    LABEL "&Next Object"  
       MENU-ITEM mPrevObject    LABEL "&Previous Object".

DEFINE MENU MENU-BAR-C-Win MENUBAR
       SUB-MENU  mFile          LABEL "&File"         
       SUB-MENU  mEdit          LABEL "&Edit"         
       SUB-MENU  mView          LABEL "&View"         
       SUB-MENU  mObject        LABEL "&Object"       .


/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnClose 
     IMAGE-UP FILE "adetran/images/close":U
     LABEL "&Close" 
     SIZE 5.8 BY 1.43 TOOLTIP "Close".

DEFINE BUTTON BtnExpose 
     IMAGE-UP FILE "adetran/images/expose":U
     IMAGE-INSENSITIVE FILE "adetran/images/expose-i":U
     LABEL "&Expose" 
     SIZE 6 BY 1.43 TOOLTIP "Expose".

DEFINE BUTTON BtnFrames 
     IMAGE-UP FILE "adetran/images/frames":U
     IMAGE-INSENSITIVE FILE "adetran/images/frames-i":U
     LABEL "&Frames" 
     SIZE 6 BY 1.43 TOOLTIP "Frames".

DEFINE BUTTON BtnHelp 
     IMAGE-UP FILE "adetran/images/help":U
     LABEL "Help" 
     SIZE 6 BY 1.43 TOOLTIP "Help".

DEFINE BUTTON BtnMoveNext 
     IMAGE-UP FILE "adetran/images/forwrd":U
     IMAGE-INSENSITIVE FILE "adetran/images/forwrd-i":U
     LABEL "&Next" 
     SIZE 6 BY 1.43 TOOLTIP "Next".

DEFINE BUTTON BtnMovePrev 
     IMAGE-UP FILE "adetran/images/bckwrd":U
     IMAGE-INSENSITIVE FILE "adetran/images/bckwrd-i":U
     LABEL "&Prev" 
     SIZE 6 BY 1.43 TOOLTIP "Prev".

DEFINE BUTTON BtnSave 
     IMAGE-UP FILE "adetran/images/check":U
     LABEL "Translate" 
     SIZE 3.8 BY 1 TOOLTIP "Translate"
     FONT 4.

DEFINE BUTTON BtnSwitch 
     IMAGE-UP FILE "adetran/images/switch":U
     IMAGE-INSENSITIVE FILE "adetran/images/switch-i":U
     LABEL "&Switch" 
     SIZE 6 BY 1.43 TOOLTIP "Switch".

DEFINE VARIABLE ObjectType AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEMS "Label","Private-data" 
     SIZE 25.8 BY 1
     BGCOLOR 8 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE vBasePhrase AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Source" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 56 BY 1
     BGCOLOR 8  NO-UNDO.

DEFINE VARIABLE vTranslation AS CHARACTER 
     VIEW-AS EDITOR
     SIZE 52 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE ChoiceLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Glossary:" 
      VIEW-AS TEXT 
     SIZE 9 BY .62 NO-UNDO.

DEFINE VARIABLE TargetLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Target:" 
      VIEW-AS TEXT 
     SIZE 8 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 1 GRAPHIC-EDGE  
     SIZE 69 BY .1
     BGCOLOR 0 FGCOLOR 0 .

DEFINE VARIABLE UseWordIdx AS LOGICAL INITIAL no 
     LABEL "Use &Word Indexing" 
     VIEW-AS TOGGLE-BOX
     SIZE 40 BY .76 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY LookUpBrowser FOR 
      kit.XL_GlossEntry SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE LookUpBrowser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS LookUpBrowser PropsWin _STRUCTURED
  QUERY LookUpBrowser NO-LOCK DISPLAY
      kit.XL_GlossEntry.TargetPhrase FORMAT "X(55)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS SIZE 56 BY 3.24
         FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BtnClose AT ROW 1 COL 28
     BtnMovePrev AT ROW 1 COL 34
     BtnMoveNext AT ROW 1 COL 40
     BtnFrames AT ROW 1 COL 46
     BtnExpose AT ROW 1 COL 52
     BtnSwitch AT ROW 1 COL 58
     BtnHelp AT ROW 1 COL 64
     ObjectType AT ROW 1.24 COL 2 NO-LABEL
     vBasePhrase AT ROW 3.62 COL 12 COLON-ALIGNED
     vTranslation AT ROW 4.52 COL 14 NO-LABEL
     BtnSave AT ROW 4.57 COL 66
     LookUpBrowser AT ROW 5.67 COL 14
     UseWordIdx AT ROW 9 COL 14.2
     TargetLabel AT ROW 4.52 COL 4 COLON-ALIGNED NO-LABEL
     ChoiceLabel AT ROW 5.81 COL 2 COLON-ALIGNED NO-LABEL
     RECT-3 AT ROW 2.43 COL 1
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 70 BY 10.43
         FONT 4
         DEFAULT-BUTTON BtnSave.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW PropsWin ASSIGN
         HIDDEN             = YES
         TITLE              = "Properties"
         HEIGHT             = 10.24
         WIDTH              = 70
         MAX-HEIGHT         = 11.19
         MAX-WIDTH          = 77.4
         VIRTUAL-HEIGHT     = 11.19
         VIRTUAL-WIDTH      = 77.4
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-C-Win:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW PropsWin
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   1                                                                    */
/* BROWSE-TAB LookUpBrowser BtnSave DEFAULT-FRAME */
/* SETTINGS FOR COMBO-BOX ObjectType IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(PropsWin)
THEN PropsWin:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE LookUpBrowser
/* Query rebuild information for BROWSE LookUpBrowser
     _TblList          = "kit.XL_GlossEntry"
     _Options          = "NO-LOCK"
     _Where[1]         = "kit.XL_GlossEntry.ShortSrc BEGINS SUBSTRING(tmp-string, 1, 63, ""RAW"":U)
 AND kit.XL_GlossEntry.SourcePhrase MATCHES tmp-string"
     _FldNameList[1]   > kit.XL_GlossEntry.TargetPhrase
"XL_GlossEntry.TargetPhrase" ? "X(55)" "character" ? ? ? ? ? ? no ? no no ?
     _Query            is OPENED
*/  /* BROWSE LookUpBrowser */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME PropsWin
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PropsWin PropsWin
ON END-ERROR OF PropsWin /* Properties */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
     /*
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
  */
  PropsWin:hidden = true.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PropsWin PropsWin
ON ENTRY OF PropsWin /* Properties */
DO:
   if valid-event(PropsWin,"entry":U) then
    apply "entry":U to vTranslation in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL PropsWin PropsWin
ON WINDOW-CLOSE OF PropsWin /* Properties */
DO:
  /* These events will close the window and terminate the procedure.      */
  /* (NOTE: this will override any user-defined triggers previously       */
  /*  defined on the window.)                                             */
 /*  APPLY "CLOSE":u TO THIS-PROCEDURE.
    RETURN NO-APPLY. */
    FOR EACH ww:
      DELETE ww.
    END.

    PropsWin:hidden = true.
    RUN PropsWinState IN hMain (NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME DEFAULT-FRAME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME PropsWin
ON ALT-G OF FRAME DEFAULT-FRAME
ANYWHERE
DO:
  APPLY "ENTRY":U TO LookUpBrowser.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME PropsWin
ON ALT-S OF FRAME DEFAULT-FRAME
ANYWHERE
DO:
  APPLY "ENTRY":U TO vBasePhrase.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL DEFAULT-FRAME PropsWin
ON ALT-T OF FRAME DEFAULT-FRAME
ANYWHERE
DO:
  APPLY "ENTRY":U TO vTranslation. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnClose PropsWin
ON CHOOSE OF BtnClose IN FRAME DEFAULT-FRAME /* Close */
DO:

  if CurrentPointer THEN DO:
    run adecomm/_adehelp.p ("vt":u,"context":u,{&Close_Btn}, ?).
    run ResetCursor.
    return.
  end.
  else PropsWin:hidden = true.
  FOR EACH ww:
    DELETE ww.
  END.
  RUN PropsWinState IN hMain (NO).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnExpose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnExpose PropsWin
ON CHOOSE OF BtnExpose IN FRAME DEFAULT-FRAME /* Expose */
DO:
   if CurrentPointer THEN DO:
    run adecomm/_adehelp.p ("vt":u,"context":u,{&Expose_Btn}, ?).
    run ResetCursor.
    return.
  end.
  else IF VALID-HANDLE(CurObj) THEN DO:
    if lookup(CurObj:name,tTopList) = 0 THEN DO:
      if can-query(CurObj,"move-to-top":u) then
        assign result = CurObj:move-to-top()
               tTopList = tTopList + ",":u + CurObj:name.
    end. /* IF the object name is not is tTopList */
    else do: /* The CurObj is already in tTopList */
      if can-query(CurObj,"move-to-bottom":u) then
         assign result = CurObj:move-to-bottom()
                tTopList = replace(tTopList,CurObj:name,"":U)
                tTopList = replace(tTopList,",,":u,",":u).
    end. /* Else move it to the bottom */
    tTopList = trim(tTopList,",":u).
  end.  /* This is for real - NOT HELP */
END.  /* End of trigger */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnFrames
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnFrames PropsWin
ON CHOOSE OF BtnFrames IN FRAME DEFAULT-FRAME /* Frames */
DO:
  DEFINE VARIABLE this-seq AS INTEGER                         NO-UNDO.

  IF CurrentPointer THEN DO:  /* User is looking for help */
    RUN adecomm/_adehelp.p ("vt":u,"context":u,{&Next_Frame_Btn}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:  /* User wants to switch frames */ 
    IF NOT CAN-FIND(FIRST ww WHERE ww.wndw = CurWin) THEN
      RUN gen-ww (CurWin).

    IF NOT VALID-HANDLE(ObjectGroup) THEN
      FIND FIRST ww WHERE ww.wndw = CurWin AND ww.is-frm
                 USE-INDEX is-frm NO-ERROR.
    ELSE DO:
      FIND ww WHERE ww.hndl = ObjectGroup NO-ERROR.
      FIND NEXT ww WHERE ww.wndw = CurWin AND ww.is-frm NO-ERROR.
      IF NOT AVAILABLE ww THEN
      FIND FIRST ww WHERE ww.wndw = CurWin AND ww.is-frm
                 USE-INDEX is-frm NO-ERROR.        
    END.
    IF NOT AVAILABLE ww THEN RETURN.    

    /* If there is a current object, turn off its selection */
    IF VALID-HANDLE(CurObj) THEN DO:
      CurObj:SELECTED = FALSE NO-ERROR.
    END.

    /* Have a frame to move to */ 
    ASSIGN ObjectGroup         = ww.hndl
           this-seq            = ww.sq
           result              = IF CAN-QUERY(ObjectGroup,"MOVE-TO-TOP":U)
                                 THEN ObjectGroup:MOVE-TO-TOP() ELSE FALSE.
    IF CAN-SET(ObjectGroup,"VISIBLE":U) THEN ObjectGroup:VISIBLE = YES.
    
    /* For starters make the first child the CurObj */
    FIND NEXT ww WHERE ww.wndw = CurWin AND ww.sq = this-seq NO-ERROR.
    CurObj = IF AVAILABLE ww THEN ww.hndl ELSE ObjectGroup.
  END.  /* Else switch frames */   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp PropsWin
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
DO:
  CurrentPointer = true.
  result = BtnHelp:load-image("adetran/images/help-d":u).
  result = ObjectType:load-mouse-pointer("adetran/images/help.cur":u).
  result = BtnClose:load-mouse-pointer("adetran/images/help.cur":u).
  result = BtnSave:load-mouse-pointer("adetran/images/help.cur":u).
  result = BtnMovePrev:load-mouse-pointer("adetran/images/help.cur":u).
  result = BtnMoveNext:load-mouse-pointer("adetran/images/help.cur":u).
  result = BtnFrames:load-mouse-pointer("adetran/images/help.cur":u).
  result = BtnSwitch:load-mouse-pointer("adetran/images/help.cur":u).
  result = BtnExpose:load-mouse-pointer("adetran/images/help.cur":u).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnMoveNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnMoveNext PropsWin
ON CHOOSE OF BtnMoveNext IN FRAME DEFAULT-FRAME /* Next */
DO:
  DEFINE VARIABLE this-seq AS INTEGER                         NO-UNDO.
  DEFINE VARIABLE HL-Obj   AS WIDGET-HANDLE                   NO-UNDO.
  DEFINE VARIABLE par-hndl AS WIDGET-HANDLE                   NO-UNDO.

  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("vt":u,"context":u,{&Next_Object_Btn}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO: /* Not Help */
    RUN adecomm/_setcurs.p ("WAIT").
    
    IF NOT CAN-FIND(FIRST ww WHERE ww.wndw = CurWin) THEN
      RUN gen-ww (CurWin).

    FIND ww WHERE ww.hndl = CurObj NO-ERROR.
    IF NOT AVAILABLE ww THEN DO:
      RUN adecomm/_setcurs.p ("").
      RETURN NO-APPLY.  /* (???) this should never happen... */
    END.

    IF VALID-HANDLE(CurObj) THEN DO:
      ASSIGN HL-Obj = CurObj.
      IF LOOKUP(CurObj:TYPE,
        "FILL-IN,COMBO-BOX,EDITOR,SLIDER,SELECTION-LIST,RADIO-SET,TEXT":U) > 0
        AND CAN-QUERY(CurObj, "SIDE-LABEL-HANDLE":U)
      THEN DO:
        IF VALID-HANDLE(CurObj:SIDE-LABEL-HANDLE) THEN
          HL-Obj = CurObj:SIDE-LABEL-HANDLE.
      END.
      IF CAN-QUERY(CurObj,"SELECTED":U)  THEN CurObj:SELECTED  = FALSE.
      IF CAN-QUERY(HL-Obj,"SELECTED":U)  THEN HL-Obj:SELECTED  = FALSE.
      IF CAN-QUERY(HL-Obj,"RESIZABLE":U) THEN HL-Obj:RESIZABLE = FALSE.

      /* *** 9/28/99 tomn: attempt at providing visual cue for browse columns...
      IF CurObj:TYPE = "FILL-IN":U THEN
      DO:
        hParObj = CurObj:PARENT.
        IF VALID-HANDLE(hParObj) AND hParObj:TYPE = "BROWSE":U THEN
          ASSIGN CurObj:LABEL-FGCOLOR = ?.  /* Restore label text to default color */
      END.
      *** */
    END.  /* If CurObj is valid */

    FIND-VALID:
    REPEAT:  /* Until we get a valid widget */
      this-seq = ww.sq.
      FIND NEXT ww WHERE ww.wndw = CurWin USE-INDEX wndw-seq NO-ERROR.
      IF NOT AVAILABLE ww THEN
        FIND FIRST ww WHERE ww.wndw = CurWin AND ww.hndl NE CurWin 
                            USE-INDEX wndw-seq NO-ERROR.
      IF NOT AVAILABLE ww THEN DO:  /* ??? this shouldn't happen... */
        RUN adecomm/_setcurs.p ("").
        RETURN NO-APPLY.
      END.
      
      IF ww.sq NE this-seq THEN DO:  /* Try to pop new frame to the top */
        /* It seems a little wierd to set ObjectGroup to a widget that
           isn't a frame or browse, but I'm too scared to change it.    */
        ASSIGN ObjectGroup = ww.hndl.
        IF ObjectGroup:TYPE = "FRAME":U THEN
          ASSIGN result              = ObjectGroup:MOVE-TO-TOP()
                 ObjectGroup:VISIBLE = YES.

        /* If the widget is not a frame, get its frame and pop it to top */
        IF NOT ww.is-frm AND VALID-HANDLE(ww.fldgrp) THEN DO:
          ASSIGN par-hndl = ww.fldgrp:PARENT.
          IF par-hndl:TYPE = "FRAME":U THEN
            ASSIGN result           = par-hndl:MOVE-TO-TOP()
                   par-hndl:VISIBLE = YES.
        END. /* If not a frame and has a valid field group */
      END. /* If the frame has changed - ww.sq is really a frame-id */
      IF NOT ww.is-frm OR ww.hndl:TITLE <> ? THEN LEAVE FIND-VALID.
    END. /* Until we get a valid widget */

    /* This is my next object */
    ASSIGN CurObj                     = ww.hndl
           vBasePhrase                = "":U
           vBasePhrase:screen-value   = "":U
           vBasePhrase:list-items     = "":U
           vTranslation               = "":U
           vTranslation:screen-value  = "":U.

    ASSIGN HL-Obj = CurObj.
    IF LOOKUP(CurObj:TYPE,
      "FILL-IN,COMBO-BOX,EDITOR,SLIDER,SELECTION-LIST,RADIO-SET,TEXT":U) > 0
      AND CAN-QUERY(CurObj, "SIDE-LABEL-HANDLE":U)
    THEN DO:
      IF VALID-HANDLE(CurObj:SIDE-LABEL-HANDLE) THEN
        HL-Obj = CurObj:SIDE-LABEL-HANDLE.
    END.
    IF CAN-QUERY(HL-Obj,"SELECTED":U)  THEN HL-Obj:SELECTED  = TRUE.
    IF CAN-QUERY(HL-Obj,"RESIZABLE":U) THEN HL-Obj:RESIZABLE = TRUE.

    /* *** 9/28/99 tomn: attempt at providing visual cue for browse columns...
    IF CurObj:TYPE = "FILL-IN":U THEN
    DO:
      hParObj = CurObj:PARENT.
      IF VALID-HANDLE(hParObj) AND hParObj:TYPE = "BROWSE":U THEN
        ASSIGN CurObj:LABEL-FGCOLOR = 12.  /* Make label text red */
    END.
    *** */

    RUN FindObjectType.
    RUN REFRESH IN hLongStr (INPUT vBasePhrase:SCREEN-VALUE,
                             INPUT vTranslation:SCREEN-VALUE,
                             INPUT hProps).
  END. /* For real - NOT HELP */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnMovePrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnMovePrev PropsWin
ON CHOOSE OF BtnMovePrev IN FRAME DEFAULT-FRAME /* Prev */
DO:
  DEFINE VARIABLE this-seq AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE HL-Obj   AS WIDGET-HANDLE                     NO-UNDO.
  DEFINE VARIABLE par-hndl AS WIDGET-HANDLE                     NO-UNDO.

  IF CurrentPointer THEN DO:  /* Help */
    RUN adecomm/_adehelp.p ("vt":u,"context":u,{&Prev_Object_Btn}, ?).
    RUN ResetCursor.
    RETURN.
  END.  /* User wanted help */
  ELSE DO:  /* Not Help */
    RUN adecomm/_setcurs.p ("WAIT").
    IF NOT CAN-FIND(FIRST ww WHERE ww.wndw = CurWin) THEN
      RUN gen-ww (CurWin).
      
    FIND ww WHERE ww.hndl = CurObj NO-ERROR.
    IF NOT AVAILABLE ww THEN DO:
      RUN adecomm/_setcurs.p ("").
      RETURN NO-APPLY.  /* (???) this should never happen... */
    END.

    IF VALID-HANDLE(CurObj) THEN DO:
      ASSIGN HL-Obj = CurObj.
      IF LOOKUP(CurObj:TYPE,
        "FILL-IN,COMBO-BOX,EDITOR,SLIDER,SELECTION-LIST,RADIO-SET,TEXT":U) > 0
        AND CAN-QUERY(CurObj, "SIDE-LABEL-HANDLE":U)
      THEN DO:
        IF VALID-HANDLE(CurObj:SIDE-LABEL-HANDLE) THEN
          HL-Obj = CurObj:SIDE-LABEL-HANDLE.
      END.
      IF CAN-QUERY(CurObj,"SELECTED":U)  THEN CurObj:SELECTED  = FALSE.
      IF CAN-QUERY(HL-Obj,"SELECTED":U)  THEN HL-Obj:SELECTED  = FALSE.
      IF CAN-QUERY(HL-Obj,"RESIZABLE":U) THEN HL-Obj:RESIZABLE = FALSE.

      /* *** 9/28/99 tomn: attempt at providing visual cue for browse columns...
      IF CurObj:TYPE = "FILL-IN":U THEN
      DO:
        hParObj = CurObj:PARENT.
        IF VALID-HANDLE(hParObj) AND hParObj:TYPE = "BROWSE":U THEN
          ASSIGN CurObj:LABEL-FGCOLOR = ?.  /* Restore label text to default */
      END.
      *** */

    END.  /* If CurObj is valid */

    FIND-VALID:
    REPEAT:  /* Until we get a valid widget */
      this-seq = ww.sq.
      FIND PREV ww WHERE ww.wndw = CurWin AND ww.hndl NE CurWin
                         USE-INDEX wndw-seq NO-ERROR.
      IF NOT AVAILABLE ww THEN
        FIND LAST ww WHERE ww.wndw = CurWin AND ww.hndl NE CurWin
                         USE-INDEX wndw-seq NO-ERROR.
      IF NOT AVAILABLE ww THEN DO:
        RUN adecomm/_setcurs.p ("").
        RETURN NO-APPLY.  /* (???) this should never happen... */
      END.

      IF ww.sq NE this-seq THEN DO:  /* Try to pop new frame to the top */
        /* It seems a little wierd to set ObjectGroup to a widget that
           isn't a frame or browse, but I'm too scared to change it.    */
        ASSIGN ObjectGroup = ww.hndl.
        IF ObjectGroup:TYPE = "FRAME":U THEN
           ASSIGN result              = ObjectGroup:MOVE-TO-TOP()
                  ObjectGroup:VISIBLE = YES.

        /* If the widget is not a frame, get its frame and pop it to top */
        IF NOT ww.is-frm AND VALID-HANDLE(ww.fldgrp) THEN DO:
          ASSIGN par-hndl = ww.fldgrp:PARENT.
          IF par-hndl:TYPE = "FRAME":U THEN 
            ASSIGN result           = par-hndl:MOVE-TO-TOP()
                   par-hndl:VISIBLE = YES.
        END. /* If not a frame and has a valid field group */
      END. /* If the frame has changed - ww.sq is really a frame-id */
      IF NOT ww.is-frm OR ww.hndl:TITLE <> ? THEN LEAVE FIND-VALID.
    END. /* Until we get a valid widget */

    /* This is my prev object */
    ASSIGN CurObj                    = ww.hndl
           vBasePhrase               = "":U
           vBasePhrase:screen-value  = "":U
           vBasePhrase:list-items    = "":U
           vTranslation              = "":U
           vTranslation:screen-value = "":U.
    
    ASSIGN HL-Obj = CurObj.
    IF LOOKUP(CurObj:TYPE,
      "FILL-IN,COMBO-BOX,EDITOR,SLIDER,SELECTION-LIST,RADIO-SET,TEXT":U) > 0
      AND CAN-QUERY(CurObj, "SIDE-LABEL-HANDLE":U)
    THEN DO:
      IF VALID-HANDLE(CurObj:SIDE-LABEL-HANDLE) THEN
        HL-Obj = CurObj:SIDE-LABEL-HANDLE.
    END.
    IF CAN-QUERY(HL-Obj,"SELECTED":U)  THEN HL-Obj:SELECTED  = TRUE.
    IF CAN-QUERY(HL-Obj,"RESIZABLE":U) THEN HL-Obj:RESIZABLE = TRUE.

    /* *** 9/28/99 tomn: attempt at providing visual cue for browse columns...
    IF CurObj:TYPE = "FILL-IN":U THEN
    DO:
      hParObj = CurObj:PARENT.
      IF VALID-HANDLE(hParObj) AND hParObj:TYPE = "BROWSE":U THEN
        ASSIGN CurObj:LABEL-FGCOLOR = 12.  /* Make label text red */
    END.
    *** */

    RUN FindObjectType.
    RUN REFRESH IN hLongStr (INPUT vBasePhrase:SCREEN-VALUE,
                             INPUT vTranslation:SCREEN-VALUE,
                             INPUT hProps).
  END.  /* For real - NOT HELP */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnSave PropsWin
ON CHOOSE OF BtnSave IN FRAME DEFAULT-FRAME /* Translate */
DO:
  APPLY "CHOOSE":U TO MENU-ITEM mSave IN MENU MENU-BAR-C-Win.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnSwitch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnSwitch PropsWin
ON CHOOSE OF BtnSwitch IN FRAME DEFAULT-FRAME /* Switch */
DO:

  /* When BtnSwitch is pressed show the source strings (if translated
     were showing) or the translations (if source was showing.)   */

  DEFINE VARIABLE FrameGroup AS WIDGET-HANDLE                 NO-UNDO.
  DEFINE VARIABLE tMenu      AS WIDGET-HANDLE                 NO-UNDO.
  DEFINE VARIABLE tInt       AS INTEGER                       NO-UNDO.

  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("vt":U,"context":U,{&Switch_Btn}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO: /* NOT HELP */
    RUN adecomm/_setcurs.p ("WAIT").
    tSTFlg = not tSTFlg.  /* Switch the sense of the Source/Target flag */
    IF tSTFlg THEN
      ASSIGN MENU-ITEM mSource:CHECKED IN MENU MENU-BAR-C-Win   = TRUE
             MENU-ITEM mSource:SENSITIVE IN MENU MENU-BAR-C-Win = FALSE
             MENU-ITEM mTarget:CHECKED IN MENU MENU-BAR-C-Win   = FALSE
             MENU-ITEM mTarget:SENSITIVE IN MENU MENU-BAR-C-Win = TRUE.
    ELSE
      ASSIGN MENU-ITEM mSource:CHECKED IN MENU MENU-BAR-C-Win   = FALSE
             MENU-ITEM mSource:SENSITIVE IN MENU MENU-BAR-C-Win = TRUE
             MENU-ITEM mTarget:CHECKED IN MENU MENU-BAR-C-Win   = TRUE
             MENU-ITEM mTarget:SENSITIVE IN MENU MENU-BAR-C-Win = FALSE.

    IF VALID-HANDLE(CurWin:MENU-BAR) THEN DO:  /* If the rc has a menu-bar */
      ASSIGN tMenu = CurWin:MENU-BAR.
      DO WHILE tMenu NE ?:  /* Loop through all MENU-ITEMs */
        IF tMenu:TYPE = "MENU":U THEN 
        DO:
           RUN SwitchLbl(tMenu,tSTFlg).  /* Push down */
        END.
        ELSE IF tMenu:TYPE = "SUB-MENU":U THEN 
        DO:
           RUN SwitchLbl(tMenu,tSTFlg).  /* Push down */
        END.
        ELSE IF tMenu:TYPE = "MENU-ITEM":U THEN DO:

          /* Try to find tTblObj where Old label is current tMenu:label */
          {adetran/vt/_prpty.i label tTblObj.ObjOLbl tMenu:label tMenu}
          IF AVAILABLE tTblobj THEN tMenu:LABEL = tTblObj.ObjNLbl. /* Switch the label */
          ELSE DO: /* Couldn't find that so try to find tTblObj based on New label */
            {adetran/vt/_prpty.i label tTblObj.ObjNLbl tMenu:label tMenu}
            IF AVAILABLE tTblobj THEN tMenu:Label = tTblObj.ObjOLbl.
          END.  /* Search based on new-label */
        END. /* If a MENU-ITEM */
        ASSIGN tMenu = IF CAN-QUERY(tMenu,"NEXT-SIBLING":U) THEN 
           tMenu:NEXT-SIBLING
        ELSE 
           ?.
      END.  /* looping through the menus */
    END.  /* IF there is a menu-bar */

    FrameGroup = CurWin:FIRST-CHILD.
    DO WHILE FrameGroup NE ?:   /* Go through all of the frames */
      /* Try to find tTblObj of frame title based on Old label */
      {adetran/vt/_prpty.i title tTblObj.ObjOLbl FrameGroup:TITLE FrameGroup}
      IF AVAILABLE tTblobj THEN FrameGroup:TITLE = tTblObj.ObjNLbl.
      ELSE DO: /* Try to find tTblObj based on New label */
        {adetran/vt/_prpty.i title tTblObj.ObjNLbl FrameGroup:TITLE FrameGroup}
        IF AVAILABLE tTblobj THEN FrameGroup:TITLE = tTblObj.ObjOLbl.
      END.  /* Else try base new label */

      RUN SwitchLbl(FrameGroup,tSTFlg).      /* Push down  */
      FrameGroup = FrameGroup:NEXT-SIBLING.  /* Next frame */
    END.  /* while we have a valid frame */
    RUN adecomm/_setcurs.p ("").
  END.  /* For real - NOT HELP */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME LookUpBrowser
&Scoped-define SELF-NAME LookUpBrowser
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL LookUpBrowser PropsWin
ON VALUE-CHANGED OF LookUpBrowser IN FRAME DEFAULT-FRAME
DO:
  IF NOT AVAILABLE kit.XL_GlossEntry AND UseWordIdx:CHECKED THEN DO:
    GET FIRST LookupBrowser.
  END.
  vTranslation:screen-value in frame {&frame-name}  =
        if avail kit.XL_GlossEntry then kit.XL_GlossEntry.targetphrase else "":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mClose PropsWin
ON CHOOSE OF MENU-ITEM mClose /* Close */
DO:
  apply "choose":u to btnclose in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mCopy
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mCopy PropsWin
ON CHOOSE OF MENU-ITEM mCopy /* Copy */
DO:
  if CurrentPointer THEN DO:
    run adecomm/_adehelp.p ("vt":u,"context":u,{&VT_Copy_Command}, ?).
    run ResetCursor.
    return.
  end.
  else do:
    if vTranslation:selection-start in frame {&frame-name} <> vTranslation:selection-end
    THEN clipboard:value = vTranslation:selection-text.
    ELSE clipboard:value = vTranslation:screen-value.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mCut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mCut PropsWin
ON CHOOSE OF MENU-ITEM mCut /* Cut */
DO:
  if CurrentPointer THEN DO:
    run adecomm/_adehelp.p ("vt":u,"context":u,{&VT_Cut_Command}, ?).
    run ResetCursor.
    return.
  end.
  else do: 
    if vTranslation:selection-start in frame {&frame-name} <> vTranslation:selection-end
    THEN assign clipboard:value = vTranslation:selection-text
                result = vTranslation:replace-selection-text("":U).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mEdit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mEdit PropsWin
ON MENU-DROP OF MENU mEdit /* Edit */
DO:
  run SetEditButtons.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mNextFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mNextFrame PropsWin
ON CHOOSE OF MENU-ITEM mNextFrame /* Next Frame */
DO:
  apply "choose":u to btnframes in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mNextObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mNextObject PropsWin
ON CHOOSE OF MENU-ITEM mNextObject /* Next Object */
DO:
  apply "choose":u to btnmovenext in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mPaste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mPaste PropsWin
ON CHOOSE OF MENU-ITEM mPaste /* Paste */
DO:
  assign Menu-Item mCut:sensitive in menu MENU-BAR-C-Win = true
         Menu-Item mCopy:sensitive in menu MENU-BAR-C-Win = true.

  if CurrentPointer THEN DO:
    run adecomm/_adehelp.p ("vt":u,"context":u,{&VT_Paste_Command}, ?).
    run ResetCursor.
    return.
  end.
  else do:
    if vTranslation:selection-start in frame {&frame-name} <> vTranslation:selection-end
    THEN result = vTranslation:replace-selection-text(clipboard:value).
    ELSE result = vTranslation:insert-string(clipboard:value).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mPrevObject
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mPrevObject PropsWin
ON CHOOSE OF MENU-ITEM mPrevObject /* Previous Object */
DO:
  apply "choose":u to btnmoveprev in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mSave PropsWin
ON CHOOSE OF MENU-ITEM mSave /* Save */
DO:
  DEFINE VARIABLE  vAns     AS LOGICAL             NO-UNDO.
  DEFINE VARIABLE  nInt     AS INTEGER             NO-UNDO.
  DEFINE VARIABLE  nChar    AS CHARACTER           NO-UNDO.
  DEFINE VARIABLE  ss       AS CHARACTER           NO-UNDO.
  DEFINE VARIABLE  st       AS CHARACTER           NO-UNDO.

  tmp-flnm = IF SUBSTRING(pFileName, 1, 1, "CHARACTER":U) = ".":U THEN
                SUBSTRING(pFileName, 3, -1, "CHARACTER":U)        ELSE pFileName.

  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("vt":U,"context":U,{&Save_Btn}, ?).
    RUN ResetCursor.
    return.
  END.

  ELSE DO:  /* Not Help */
    IF vTranslation:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U THEN RETURN.
    ASSIGN vTranslation.

    IF CAN-FIND(kit.xl_invalid WHERE kit.xl_invalid.Targetphrase MATCHES
                                     vTranslation) THEN DO:
      ThisMessage = "This Translation Is Invalid.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).
      RETURN NO-APPLY.
    END.  /* The translation is invalid */

    /* Update instance record first, to make sure it is available... */
    DO TRANSACTION ON ERROR UNDO, LEAVE:
      ASSIGN ss = REPLACE(vBasePhrase,"~&":U,"":U)
             st = REPLACE(vTranslation,"~&":U,"":U).

      find first kit.XL_Instance where kit.XL_Instance.ProcedureName = tmp-flnm and
          COMPARE(REPLACE(kit.XL_Instance.SourcePhrase,"~&":U,"":U), "=":U, ss, "CAPS":U)
        exclusive-lock NO-WAIT no-error.

      IF LOCKED kit.XL_Instance THEN DO:
        ThisMessage = "This string is locked by another user":U.

        find first kit.XL_Instance where kit.XL_Instance.ProcedureName = tmp-flnm and
            COMPARE(REPLACE(kit.XL_Instance.SourcePhrase,"~&":U,"":U), "=":U, ss, "CAPS":U)
          NO-LOCK.
        RUN adecomm/_setcurs.p ("WAIT":U).
        FIND FIRST kit._Lock WHERE _Lock-RecID = INTEGER(RECID(kit.XL_Instance)) 
                           AND (_Lock-Flags = "X":U OR  /* Exclusive-lock */
                                _Lock-Flags = "S":U OR  /* Share-lock     */
                                _Lock-Flags = "U":U)    /* Upgraded lock  */
          NO-LOCK NO-ERROR.
        IF AVAILABLE kit._Lock THEN DO:
          ASSIGN ThisMessage = REPLACE(ThisMessage, "another user":U, _Lock-Name).
          FIND FIRST kit._Connect WHERE _Connect-Usr = _Lock-Usr NO-LOCK NO-ERROR.
          IF AVAILABLE kit._Connect THEN
            ThisMessage = ThisMessage + " on device: ":U + _Connect-Device.
        END.

        RUN adecomm/_setcurs.p ("":U).
        RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage). 

        RETURN.
      END.  /* kit.XL_Instance is locked */

      ELSE IF AVAILABLE kit.XL_Instance THEN
      DO:
        IF kit.XL_Instance.TargetPhrase NE cOrigTargetPhrase THEN
        DO:
          ThisMessage = REPLACE("The Target Phrase has been changed since you began working on it.  The new value is ~"&1~".  Do you still want to save your changes?":U, "&1":U, kit.XL_Instance.TargetPhrase).
          RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "q":U, "yes-no":U, ThisMessage). 
          IF ErrorStatus /* i.e., user selected "yes" */ THEN DO:
            ASSIGN NewTrans                     = (kit.XL_Instance.ShortTarg = "":U)
                   cOrigTargetPhrase            = vTranslation
                   kit.XL_Instance.TargetPhrase = vTranslation
                   kit.XL_Instance.ShortTarg    = SUBSTRING(vTranslation,1,63,"RAW":U).
            if kit.XL_Instance.ShortTarg = ? THEN kit.XL_Instance.ShortTarg = "":U.

            find first kit.XL_Project EXCLUSIVE-LOCK no-error.
            IF AVAILABLE kit.XL_Project THEN DO:
              IF NewTrans AND kit.XL_Instance.ShortTarg NE "":U THEN
                kit.XL_Project.TranslationCount = kit.XL_Project.TranslationCount + 1.
              ELSE IF NOT NewTrans AND kit.XL_Instance.ShortTarg = "":U THEN
                kit.XL_Project.TranslationCount = kit.XL_Project.TranslationCount - 1.
            END.

            RUN OpenQuery in hTrans.
            tModFlag = true.
          END.  /* Save Changes */
          ELSE RETURN.
        END.  /* Record was changed by another user */

        ELSE 
        DO:
          ASSIGN NewTrans                     = (kit.XL_Instance.ShortTarg = "":U)
                 cOrigTargetPhrase            = vTranslation
                 kit.XL_Instance.TargetPhrase = vTranslation
                 kit.XL_Instance.ShortTarg    = SUBSTRING(vTranslation,1,63,"RAW":U).
          if kit.XL_Instance.ShortTarg = ? THEN
            kit.XL_Instance.ShortTarg = "":U.

          find first kit.XL_Project EXCLUSIVE-LOCK no-error.
          IF AVAILABLE kit.XL_Project THEN DO:
            IF NewTrans AND kit.XL_Instance.ShortTarg NE "":U THEN
              kit.XL_Project.TranslationCount = kit.XL_Project.TranslationCount + 1.
            ELSE IF NOT NewTrans AND kit.XL_Instance.ShortTarg = "":U THEN
              kit.XL_Project.TranslationCount = kit.XL_Project.TranslationCount - 1.
          END.

          RUN OpenQuery in hTrans.
          tModFlag = true.
        END.  /* Record was locked successfully */
      END.  /* AVAILABLE kit.XL_Instance */

      ELSE DO:  /* Record is not available - may have been deleted in MU mode */
        /* We don't allow deletion of translations in VT at this point, but if
        ** we ever do, we really need better handling of this situation... 
        */
        ThisMessage = "Source string not available for translation.".
        RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage). 
        RETURN.
      END.  /* Record not available */

      ASSIGN vTranslation:FGCOLOR = 0.
      /* Update the active window with the translation value. 
         This also in essence swithes the tSTFlg to Target
       */
      RUN setActiveTrans.

      /* Update Glossary */
      find first kit.XL_GlossEntry where
          kit.XL_GlossEntry.ShortSrc  BEGINS SUBSTRING(ss, 1, 63, "RAW":U) AND
          kit.XL_GlossEntry.ShortTarg BEGINS SUBSTRING(st, 1, 63, "RAW":U) AND
          COMPARE(kit.XL_GlossEntry.SourcePhrase, "=":U, ss, "CAPS":U) and
          COMPARE(kit.XL_GlossEntry.TargetPhrase, "=":U, st, "CAPS":U)
        EXCLUSIVE-LOCK NO-ERROR.
      if not avail kit.XL_GlossEntry THEN DO:
        if ConfirmAdds THEN DO:
          ThisMessage = "Do you want to update glossary?".
          RUN adecomm/_s-alert.p (INPUT-OUTPUT vAns, "q":U, "yes-no":U, ThisMessage).
        end.
        ELSE vAns = true.    
        IF vAns THEN DO:
          CREATE kit.XL_GlossEntry.                
          FIND FIRST kit.XL_Project EXCLUSIVE-LOCK.
          kit.XL_Project.GlossaryCount = kit.XL_Project.GlossaryCount + 1.
        END.
      end. /* If not available Gloss Entry */
    
      IF AVAILABLE kit.XL_GlossEntry THEN DO:
        assign kit.XL_GlossEntry.SourcePhrase         = ss
               kit.XL_GlossEntry.TargetPhrase         = st
               kit.XL_GlossEntry.ShortSrc             = SUBSTRING(ss, 1, 63, "RAW":U)
               kit.XL_GlossEntry.ShortTarg            = SUBSTRING(st, 1, 63, "RAW":U)
               kit.XL_GlossEntry.ModifiedByTranslator = true
               kit.XL_GlossEntry.GlossaryType         = "C":U.
        RUN OpenQry. /* Redisplay updated glossary in props window */  
        RUN OpenQuery IN hGloss. /* Redisplay updated glossary in VT window */
      END.  /* If the glossary entry is available */
    END.  /* TRANSACTION */
  
    FIND CURRENT kit.XL_Instance NO-LOCK NO-ERROR.  /* Downgrade lock */
    FIND CURRENT kit.XL_Project  NO-LOCK NO-ERROR.  /* Downgrade lock */
  END.  /* For real - NOT HELP */
END.  /* On choose of mSave */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mSource
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mSource PropsWin
ON VALUE-CHANGED OF MENU-ITEM mSource /* Source */
DO:
  if self:checked THEN DO:
    if tSTFlg then
      assign tSTFlg = false
             menu-item mSource:Checked in menu MENU-BAR-C-Win = false
             menu-item mSource:sensitive in menu MENU-BAR-C-Win = true
             menu-item mTarget:Checked in menu MENU-BAR-C-Win = true
             menu-item mTarget:sensitive in menu MENU-BAR-C-Win = false. 
    else apply "choose":u to btnswitch in frame {&frame-name}.
  end. /* If SELF:CHECKED */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mTarget
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mTarget PropsWin
ON VALUE-CHANGED OF MENU-ITEM mTarget /* Target */
DO:
  if self:checked THEN DO:
    if tSTFlg = false then
      assign tSTFlg = true
             menu-item mSource:Checked in menu MENU-BAR-C-Win = true
             menu-item mSource:sensitive in menu MENU-BAR-C-Win = false
             menu-item mTarget:Checked in menu MENU-BAR-C-Win = false
             menu-item mTarget:sensitive in menu MENU-BAR-C-Win = true.
    else apply "choose":u to btnswitch in frame {&frame-name}.
   end.  /* If self:checked */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ObjectType
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ObjectType PropsWin
ON VALUE-CHANGED OF ObjectType IN FRAME DEFAULT-FRAME
DO:
  IF CurrentPointer THEN DO:
    RUN adecomm/_adehelp.p ("vt":U,"context":U,{&Object_Type_CB}, ?).
    RUN ResetCursor.
    RETURN.
  END.
  ELSE DO:
    RUN adecomm/_setcurs.p("WAIT":U).
    ASSIGN vBasePhrase               = "":U
           vBasePhrase:SCREEN-VALUE  = "":U
           vTranslation              = "":U
           vTranslation:SCREEN-VALUE = "":U.
    RUN FindSourceValue.
    RUN FindTargetValue.
    RUN adecomm/_setcurs.p("":U).
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TargetLabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TargetLabel PropsWin
ON LEAVE OF TargetLabel IN FRAME DEFAULT-FRAME
DO:
  tPrevWH = last-event:widget-leave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TargetLabel PropsWin
ON RETURN OF TargetLabel IN FRAME DEFAULT-FRAME
DO:
  return no-apply.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME UseWordIdx
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL UseWordIdx PropsWin
ON VALUE-CHANGED OF UseWordIdx IN FRAME DEFAULT-FRAME /* Use Word Indexing */
DO:
  RUN Openqry.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vBasePhrase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vBasePhrase PropsWin
ON MOUSE-SELECT-DBLCLICK OF vBasePhrase, vTranslation IN FRAME DEFAULT-FRAME
DO:
  RUN REALIZE IN hLongStr (INPUT vBasePhrase:SCREEN-VALUE,
                           INPUT vTranslation:SCREEN-VALUE,
                           INPUT hProps).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vBasePhrase PropsWin
ON VALUE-CHANGED OF vBasePhrase IN FRAME DEFAULT-FRAME /* Source */
DO:
  run adecomm/_setcurs.p("wait":u).
  ASSIGN vTranslation              = "":U
         vTranslation:screen-value = "":U
         vBasePhrase               = vBasePhrase:SCREEN-VALUE.
  RUN OpenQry.
  run FindTargetValue.
  RUN REFRESH IN hLongStr (INPUT vBasePhrase:SCREEN-VALUE,
                           INPUT vTranslation:SCREEN-VALUE,
                           INPUT hProps).
  run adecomm/_setcurs.p("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vTranslation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vTranslation PropsWin
ON LEAVE OF vTranslation IN FRAME DEFAULT-FRAME
DO:
   tPrevWh = last-event:widget-leave.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK PropsWin 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}
       result                        = Current-window:load-icon("adetran/images/vt%":u).


/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:

  assign PropsWin:hidden = True
         PropsWin:parent = MainWindow:handle.
         
  run AlwaysOnTop.
 
  assign PropsWIndow              = Current-WIndow:handle
         ChoiceLabel:screen-value = "Glossary:"
         ChoiceLabel:width        = font-table:get-text-width-chars (trim(ChoiceLabel:screen-value),4)
         ChoiceLabel:column       = (LookupBrowser:column - ChoiceLabel:width) - .5
         ChoiceLabel:row          = LookupBrowser:row
         TargetLabel:screen-value = "Target:"
         TargetLabel:width        = font-table:get-text-width-chars (trim(TargetLabel:screen-value),4)
         TargetLabel:column       = (vTranslation:column - TargetLabel:width) - .5
         TargetLabel:row          = vTranslation:row
         vBasePhrase:DELIMITER   = CHR(4).

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE focus vTranslation.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AlwaysOnTop PropsWin 
PROCEDURE AlwaysOnTop :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
run adecomm/_topmost.p (input PropsWin:hWnd, input PropsOnTop, output rc).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI PropsWin  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(PropsWin)
  THEN DELETE WIDGET PropsWin.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE DispCBtn PropsWin 
PROCEDURE DispCBtn :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define input parameter        pType as char no-undo.
  define input parameter        pWidth as dec no-undo.
  define input parameter        pInit  as Char no-undo.
  define input-output parameter pLabel as char no-undo.

  define variable txt    as char               no-undo.
  define variable i-fill as int                no-undo.

  case pType:
    when "BU":u THEN DO:
      assign txt = "":U
             txt = trim(pLabel).
      IF LENGTH(txt, "raw":u) > (pWidth) - 2 THEN DO:
        IF (pWidth) < 1.5 THEN      ASSIGN txt = "<":u.
        ELSE IF (pWidth) < 2.5 THEN ASSIGN txt = "<>":u.
        ELSE ASSIGN txt = "<":u + SUBSTRING(txt,
                                    INTEGER((LENGTH(txt) + 3 - (pWidth)) / 2),
                                    INTEGER(pWidth) - 2) + ">":u.
      END.  /* If length of text > field width - 2 */
      ELSE /* Label will fit */
        ASSIGN i-fill  = INTEGER(((pWidth) - LENGTH(txt, "raw":u) - 2) / 2)
               txt     = "<":u + FILL(" ":u, i-fill) + txt +
                                  FILL(" ":u, INTEGER((pWidth) - 2 -
                                  i-fill -  LENGTH(txt, "raw":u))) + ">":u.
    end. /* When BU */
    when "TB":u THEN DO:
      assign txt   = trim(PLabel)
             txt   = (IF CAN-DO("YES,TRUE":u,pInit)
                        THEN "[X]":u  ELSE "[ ]":u) + txt.
    end.  /* WHEN TB */
  end case.

  ASSIGN pLabel    = txt.
                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI PropsWin  _DEFAULT-ENABLE
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
  DISPLAY ObjectType vBasePhrase vTranslation UseWordIdx TargetLabel ChoiceLabel 
      WITH FRAME DEFAULT-FRAME IN WINDOW PropsWin.
  ENABLE RECT-3 BtnClose BtnMovePrev BtnMoveNext BtnFrames BtnExpose BtnSwitch 
         BtnHelp ObjectType vBasePhrase vTranslation BtnSave LookUpBrowser 
         UseWordIdx TargetLabel ChoiceLabel 
      WITH FRAME DEFAULT-FRAME IN WINDOW PropsWin.
  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
  VIEW PropsWin.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindLbl PropsWin 
PROCEDURE FindLbl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define input  parameter pWH   as widget-handle no-undo.

  define variable vChildWidget  as widget-handle no-undo.
  define variable vNextSibling  as widget-handle no-undo.
  define variable tListItems    as char          no-undo.

  tmp-flnm = IF SUBSTRING(pFileName, 1, 1, "CHARACTER":U) = ".":U THEN
                SUBSTRING(pFileName, 3, -1, "CHARACTER":U)          ELSE pFileName.

  if can-query(pWH,"FIRST-CHILD":u) then vChildWidget = pWH:first-child.
  do while vChildWidget <> ?:  /* DO WHILE VALID HANDLE */
    if (vChildWidget:type = "Field-group":u) OR 
        (vChildWidget:type="LITERAL":u) then
    do:   end.  /* Don't count fields-groups */
    else TotObject = TotObject + 1.

    ASSIGN vNextSibling = IF CAN-QUERY(vChildWidget,"NEXT-SIBLING":U) THEN 
                             vChildWidget:Next-Sibling
                          ELSE
                             ?.

    if vChildWidget:type = "Menu-Item":u THEN DO:  /* Create a tTblObj record */
      {adetran/vt/_props.i vChildWidget:Label vChildWidget:name label}
    end.
    ELSE IF vChildWidget:TYPE = "Sub-Menu":U THEN DO:  /* Create a tTblObj record */
      {adetran/vt/_props.i vChildWidget:Label vChildWidget:name label}
    END.
    else if (tDispType = "c":u and entry(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "BU":u) or
            (tDispType = "c":u and entry(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "TB":u) THEN DO:
      assign tChar = entry(2,vChildWidget:PRIVATE-DATA,CHR(4))
             tChar = replace(tChar,"&":u,"":U)
             tChar = trim(tChar)
             tCharSav = tChar.
      {adetran/vt/_props.i tChar vChildWidget:name label}  /* Create a tTblObj rec */
      if (tChar <> tCharSav) and (avail tTblObj) THEN DO:
        assign tmpChar = if entry(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "TB":u
                         THEN entry(3,vChildWidget:PRIVATE-DATA,CHR(4)) ELSE "":U
               tChar   = tTblObj.ObjNLbl.
        run DispCBtn(entry(1,vChildWidget:PRIVATE-DATA,CHR(4)),
                     input vChildwidget:width-char,
                     input tmpChar,
                     input-output tChar).
        assign vChildWidget:screen-value = tChar
               vChildWidget:PRIVATE-DATA =
                        (if entry(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "TB":u then
                            entry(1,vChildWidget:PRIVATE-DATA,CHR(4)) + CHR(4) +
                            tTblObj.ObjNLbl + CHR(4) + entry(3,vchildwidget:PRIVATE-DATA,CHR(4))
                         else entry(1,vChildWidget:PRIVATE-DATA,CHR(4)) + CHR(4) +
                              tTblObj.ObjNLbl).
      end.  /* IF avail tTblObj and tChar <> tCharSav */
    end.  /* Else if character BU OR TB */
    else if (tDispType = "c":u and entry(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "CB":u) THEN DO:
      assign tListItems = "":U
             tChar = entry(2,vChildWidget:PRIVATE-DATA,CHR(4)).
      do tInt = 1 to NUM-ENTRIES(tChar):
        find first kit.XL_Instance where
                   kit.XL_Instance.SourcePhrase MATCHES entry(tInt,tChar) and
                   kit.XL_Instance.ProcedureName = tmp-flnm no-lock no-error.
        if (AVAILABLE kit.XL_Instance) and (kit.XL_Instance.TargetPhrase <> "":U) THEN DO:
          create tTblObj.
          assign tTblObj.ObjWName = PFileName
                 tTblObj.ObjName  = vChildWidget:name
                 tTblObj.ObjType  = "items":u
                 tTblObj.ObjOLbl  = entry(tInt,tChar)
                 tTblObj.ObjNLbl  = kit.XL_Instance.TargetPhrase
                 tTblObj.FoundIn  = "INST":U
                 tListItems = tListItems +  kit.XL_Instance.TargetPhrase  + ",":u.
        end. /* If there is an instance record with a valid target */
        else do: /* Look for a glossary entry */
          find first kit.XL_GlossEntry where
              kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(entry(tInt,tChar), 1, 63, "RAW":U) AND
              kit.XL_GlossEntry.SourcePhrase MATCHES entry(tInt,tChar)
            no-lock no-error.
          if (available kit.XL_GlossEntry) and (kit.XL_GlossEntry.TargetPhrase <> "":U) THEN DO:
            create tTblObj.
            assign tTblObj.ObjWName = pFileName
                   tTblObj.ObjName  = vChildWidget:name
                   tTblObj.ObjType  = "Items":u
                   tTblObj.ObjOLbl  = entry(tInt,tChar)
                   tTblObj.ObjNLbl  = kit.XL_GlossEntry.TargetPhrase
                   tTblObj.FoundIn  = "GLOSS":U
                   tListItems = tListItems +  
                                (IF AutoTrans THEN kit.XL_GlossEntry.TargetPhrase
                                              ELSE tTblObj.ObjOLbl)  + ",":u.
          end.  /* If available glossary */
          else tListItems = tListItems +  entry(tInt,tChar) + ",":u.
        end.  /* Else look for a glossary entry */
      end.  /* Do tInt for all entries of tChar */
      assign tListItems = trim(tListItems,",":u)
             vChildWidget:PRIVATE-DATA = entry(1,vChildWidget:PRIVATE-DATA,CHR(4)) + CHR(4) +
                                               tListItems.
    end.  /* Character mode and CB */

    if (tDispType = "c":u  and ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "LI":u) or
       (tDispType <> "c":u and vChildWidget:type = "TEXT":u) THEN DO:
      {adetran/vt/_props.i vChildWidget:screen-value vChildWidget:name text}
    end.
    else if can-query(vChildWidget,"Label":u)  THEN DO:
      {adetran/vt/_props.i vChildWidget:Label vChildWidget:name label}
    end.

    if can-query(vChildWidget,"Tooltip":u) THEN DO:
      {adetran/vt/_props.i vChildWidget:Tooltip vChildWidget:name tooltip}
    end.  /* If the widget has tooltip */

    if can-query(vChildWidget,"List-Items":u) THEN DO:
      tListItems = "":U.
      do tInt = 1 to NUM-ENTRIES(vChildWidget:list-items):
        find first kit.XL_Instance where
                   kit.XL_Instance.SourcePhrase MATCHES entry(tInt,vChildWidget:list-items) and
                   kit.XL_Instance.ProcedureName = tmp-flnm no-lock no-error.
        if (AVAILABLE kit.XL_Instance) and (kit.XL_Instance.TargetPhrase <> "":U) THEN DO:
          create tTblObj.
          assign tTblObj.ObjWName = PFileName
                 tTblObj.ObjName  = vChildWidget:name
                 tTblObj.ObjType  = "items":u
                 tTblObj.ObjOLbl  = entry(tInt,vChildWidget:list-items)
                 tTblObj.ObjNLbl  = kit.XL_Instance.TargetPhrase
                 tTblObj.FoundIn  = "INST":U
                 tListItems = tListItems +  kit.XL_Instance.TargetPhrase  + ",":u.
        end. /* If avail inst and has a translation */
        else do:  /* Look for a glossary entry */
          find first kit.XL_GlossEntry where
                kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(entry(tInt,vChildWidget:list-items),
                                                     1, 63, "RAW":U) AND
                kit.XL_GlossEntry.SourcePhrase MATCHES entry(tInt,vChildWidget:list-items)
             no-lock no-error.
          if (available kit.XL_GlossEntry) and (kit.XL_GlossEntry.TargetPhrase <> "":U) THEN DO:
            create tTblObj.
            assign tTblObj.ObjWName = pFileName
                   tTblObj.ObjName  = vChildWidget:name
                   tTblObj.ObjType  = "Items":u
                   tTblObj.ObjOLbl  = entry(tInt,vChildWidget:list-items)
                   tTblObj.ObjNLbl  = kit.XL_GlossEntry.TargetPhrase
                   tTblObj.FoundIn  = "GLOSS":U
                   tListItems = tListItems +
                                (IF AutoTrans THEN kit.XL_GlossEntry.TargetPhrase
                                              ELSE tTblObj.ObjOLbl)  + ",":u.
          end. /* Found a glossary entry */
          else tListItems = tListItems +  entry(tInt,vChildWidget:list-items) + ",":u.
        end. /* looking for a glossary entry */
      end. /* do tInt for each entry in list-items */
      vChildWidget:List-Items = TRIM(tListItems,",":u).
    end.  /* If the widget has list-items */
    
    if can-query(vChildWidget,"List-Item-Pairs":u) THEN DO:
      tListItems = "":U.
      do tInt = 1 to NUM-ENTRIES(vChildWidget:LIST-ITEM-PAIRS):
        find first kit.XL_Instance where
                   kit.XL_Instance.SourcePhrase MATCHES entry(tInt,vChildWidget:LIST-ITEM-PAIRS) and
                   kit.XL_Instance.ProcedureName = tmp-flnm no-lock no-error.
        if (AVAILABLE kit.XL_Instance) and (kit.XL_Instance.TargetPhrase <> "":U) THEN DO:
          create tTblObj.
          assign tTblObj.ObjWName = PFileName
                 tTblObj.ObjName  = vChildWidget:name
                 tTblObj.ObjType  = "items":u
                 tTblObj.ObjOLbl  = entry(tInt,vChildWidget:LIST-ITEM-PAIRS)
                 tTblObj.ObjNLbl  = kit.XL_Instance.TargetPhrase
                 tTblObj.FoundIn  = "INST":U
                 tListItems = tListItems +  kit.XL_Instance.TargetPhrase  + ",":u.
        end. /* If avail inst and has a translation */
        else do:  /* Look for a glossary entry */
          find first kit.XL_GlossEntry where
                kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(entry(tInt,vChildWidget:LIST-ITEM-PAIRS),
                                                     1, 63, "RAW":U) AND
                kit.XL_GlossEntry.SourcePhrase MATCHES entry(tInt,vChildWidget:LIST-ITEM-PAIRS)
             no-lock no-error.
          if (available kit.XL_GlossEntry) and (kit.XL_GlossEntry.TargetPhrase <> "":U) THEN DO:
            create tTblObj.
            assign tTblObj.ObjWName = pFileName
                   tTblObj.ObjName  = vChildWidget:name
                   tTblObj.ObjType  = "Items":u
                   tTblObj.ObjOLbl  = entry(tInt,vChildWidget:LIST-ITEM-PAIRS)
                   tTblObj.ObjNLbl  = kit.XL_GlossEntry.TargetPhrase
                   tTblObj.FoundIn  = "GLOSS":U
                   tListItems = tListItems +
                                (IF AutoTrans THEN kit.XL_GlossEntry.TargetPhrase
                                              ELSE tTblObj.ObjOLbl)  + ",":u.
          end. /* Found a glossary entry */
          else tListItems = tListItems +  entry(tInt,vChildWidget:LIST-ITEM-PAIRS) + ",":u.
        end. /* looking for a glossary entry */
      end. /* do tInt for each entry in list-item-pairs */
      vChildWidget:LIST-ITEM-PAIRS = TRIM(tListItems,",":u).
    end.  /* If the widget has list-item-pairs */
 
    if can-query(vChildWidget,"Radio-Buttons":u) THEN DO:
      tListItems = "":U.
      do tInt = 1 to NUM-ENTRIES(vChildWidget:Radio-Buttons):
        if tInt mod 2 = 0 then  /* Get the radio values */
          tListItems = tListItems + entry(tInt,vChildWidget:radio-Buttons) + ",":u.
        else do:  /* Here we have a radio button label */
          find first kit.XL_Instance where
                     kit.XL_Instance.SourcePhrase MATCHES entry(tInt,vChildWidget:radio-buttons) and
                     kit.XL_Instance.ProcedureName = tmp-flnm no-lock no-error.
          if (AVAILABLE kit.XL_Instance) and (kit.XL_Instance.TargetPhrase <> "":U) THEN DO:
            create tTblObj.
            assign tTblObj.ObjWName = PFileName
                   tTblObj.ObjName  = vChildWidget:name
                   tTblObj.ObjType  = "items":u
                   tTblObj.ObjOLbl  = entry(tInt,vChildWidget:radio-buttons)
                   tTblObj.ObjNLbl  = kit.XL_Instance.TargetPhrase
                   tTblObj.FoundIn  = "INST":U
                   tListItems = tListItems +  kit.XL_Instance.TargetPhrase  + ",":u.
          end.  /* If there is an instance with a valid translation */
          else do:  /* Look for a glossary entry */
            find first kit.XL_GlossEntry where
                 kit.XL_GlossEntry.ShortSrc     BEGINS 
                      SUBSTRING(entry(tInt,vChildWidget:radio-buttons), 1, 63, "RAW":U) AND
                 kit.XL_GlossEntry.SourcePhrase MATCHES entry(tInt,vChildWidget:radio-buttons)
               no-lock no-error.
            if (available kit.XL_GlossEntry) and (kit.XL_GlossEntry.TargetPhrase <> "":U) THEN DO:
              create tTblObj.
              assign tTblObj.ObjWName = pFileName
                     tTblObj.ObjName  = vChildWidget:name
                     tTblObj.ObjType  = "Items":u
                     tTblObj.ObjOLbl  = entry(tInt,vChildWidget:radio-buttons)
                     tTblObj.ObjNLbl  = kit.XL_GlossEntry.TargetPhrase
                     tTblObj.FoundIn  = "GLOSS":U
                     tListItems = tListItems +  
                                  (IF AutoTrans THEN kit.XL_GlossEntry.TargetPhrase
                                                ELSE tTblObj.ObjOLbl)  + ",":u.
            end.  /* If a glossary entry was found */
            else tListItems = tListItems +  entry(tInt,vChildWidget:radio-buttons) + ",":u. 
          end.  /* looking for a glossary entry */
        end.  /* A radio-button label */
      end.  /* Looping through a radio-set radio-buttons */
      vChildWidget:radio-buttons = TRIM(tListItems,",":u).
    end. /* If can query radio-buttons */

    if vChildWidget:Type = "Browse":u THEN DO:
      assign tBrColWH = vChildwidget:First-Column
             tListItems = "":U.

      do while tBrColWH <> ?:
        find first kit.XL_Instance where
                   kit.XL_Instance.SourcePhrase MATCHES tBrColWh:Label and
                   kit.XL_Instance.ProcedureName = tmp-flnm no-lock no-error.
        if (AVAILABLE kit.XL_Instance) and (kit.XL_Instance.TargetPhrase <> "":U) THEN DO:
          create tTblObj.
          assign tTblObj.ObjWName = PFileName
                 tTblObj.ObjName  = tBrColWH:Name
                 tTblObj.ObjType  = "colabel":u
                 tTblObj.ObjOLbl  = tBrColWH:Label
                 tTblObj.ObjNLbl  = kit.XL_Instance.TargetPhrase
                 tTblObj.FoundIn  = "INST":U
                 tListItems = tListItems +  kit.XL_Instance.TargetPhrase  + ",":u
                 tBrColWH:Label = kit.XL_Instance.TargetPhrase.
        end. /* If an instance with a translation */
        else do:  /* Look for a glossary entry */
          find first kit.XL_GlossEntry where
               kit.XL_GlossEntry.ShortSrc     BEGINS SUBSTRING(tBrColWH:label, 1, 63, "RAW":U) AND
               kit.XL_GlossEntry.SourcePhrase MATCHES tBrColWH:label
             no-lock no-error.
          if (available kit.XL_GlossEntry) and (kit.XL_GlossEntry.TargetPhrase <> "":U) THEN DO:
            create tTblObj.
            assign tTblObj.ObjWName = pFileName
                   tTblObj.ObjName  = tBrColWH:Name
                   tTblObj.ObjType  = "colabel":u
                   tTblObj.ObjOLbl  = tBrColWH:Label
                   tTblObj.ObjNLbl  = kit.XL_GlossEntry.TargetPhrase
                   tTblObj.FoundIn  = "GLOSS":U
                   tListItems = tListItems +
                                (IF AutoTrans THEN kit.XL_GlossEntry.TargetPhrase
                                              ELSE tTblObj.ObjOLbl) + ",":u.
            IF AutoTrans THEN ASSIGN tBrColWH:Label = kit.XL_GlossEntry.TargetPhrase.
          end.  /* If a glossary entry exists */
          else tListItems = tListItems + tBrColWH:Label + ",":u.
        end.  /* looking for a glossary entry */
        tBrColWH = tBrColWH:Next-Column.
      end. /* Do while we have a valid browse column */
    end.  /*  If we have a browser */

    run FindLbl(vChildWidget).     /* Push */
    assign vChildWidget = vNextSiblIng.

  end.  /*  DO WHILE VALID CHILD WIDGET */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindObjectType PropsWin 
PROCEDURE FindObjectType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE(CurObj) THEN RETURN.
  DO WITH FRAME {&FRAME-NAME}:
    IF tDispType = "c":U THEN DO: /* If character mode */
      IF      CurObj:TYPE = "FRAME":U     THEN ObjectType = "Title":U.
      ELSE IF CurObj:TYPE = "SUB-MENU":U  THEN ObjectType = "Label":U.
      ELSE IF CurObj:TYPE = "MENU-ITEM":U THEN ObjectType = "Label":U.
      ELSE IF CurObj:TYPE = "BROWSE":U    THEN ObjectType = "Title,Help":U.
      ELSE
        CASE ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)):
          WHEN "FF":U THEN ObjectType = "Label,Format,Help":U.
          WHEN "CB":U THEN ObjectType = "Label,Format,List-Items,List-Item-Pairs,Help":U.
          WHEN "SE":U THEN ObjectType = "List-Items,List-Item-Pairs,Help":U.
          WHEN "TB":U THEN ObjectType = "Label,Format,Help":U.
          WHEN "BU":U THEN ObjectType = "Label,Help":U.
          WHEN "LI":U THEN ObjectType = "Text,Help":U.
          WHEN "RS":U THEN ObjectType = "Radio-Buttons,Help":U.
          WHEN "ED":U THEN ObjectType = "Label":U.
          WHEN "SL":U THEN ObjectType = "Label,Help":U.
        END CASE.
    END.  /* If character mode */
    ELSE  /* GUI mode */
      CASE CurObj:TYPE:
        WHEN "FRAME":U          THEN ObjectType = "Title,Private-Data":U.
        WHEN "FILL-IN":U        THEN ObjectType = "Label,Format,Help,Private-Data,Tooltip":U.
        WHEN "COMBO-BOX":U      THEN ObjectType = "Label,Format,List-Items,List-Item-Pairs,Help,Private-Data,Tooltip":U.
        WHEN "SELECTION-LIST":U THEN ObjectType = "List-Items,List-Item-Pairs,Help,Private-Data,Tooltip":U.
        WHEN "TOGGLE-BOX":U     THEN ObjectType = "Label,Format,Help,Private-Data,Tooltip":U.
        WHEN "BUTTON":U         THEN ObjectType = "Label,Help,Private-Data,Tooltip":U.
        WHEN "TEXT":U           THEN ObjectType = "Text,Help,Private-Data,Tooltip":U.
        WHEN "RADIO-SET":U      THEN ObjectType = "Radio-Buttons,Help,Private-Data,Tooltip":U.
        WHEN "SUB-MENU":U       THEN ObjectType = "Label,Private-data":U.
        WHEN "MENU-ITEM":U      THEN ObjectType = "Label,Private-data":U.
        WHEN "EDITOR":U         THEN ObjectType = "Label,Private-data,Tooltip":U.
        WHEN "SLIDER":U         THEN ObjectType = "Label,Private-data,Help,Tooltip":U.
        WHEN "BROWSE":U         THEN ObjectType = "Title,Private-Data,Help,Tooltip":U.
        WHEN "WINDOW":U         THEN ObjectType = "Title,Private-Data":U.
        WHEN "RECTANGLE":U      THEN ObjectType = "Tooltip":U.
        WHEN "IMAGE":U          THEN ObjectType = "Tooltip":U.
      END CASE.

    /* Always do below (in both character or GUI mode */
    ASSIGN PropsWin:TITLE            = "Properties - ":U + CurObj:NAME
           ObjectType:LIST-ITEMS     = ObjectType
           ObjectType:SCREEN-VALUE   = ObjectType:ENTRY(1).
    APPLY "VALUE-CHANGED":U TO ObjectType.
  END. /* DO WITH FRAME {FRAME-NAME} */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindSourceValue PropsWin 
PROCEDURE FindSourceValue :
/*-----------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
-------------------------------------------------------------------------*/
  DEFINE VARIABLE i          AS INTEGER                           NO-UNDO.
  DEFINE VARIABLE TempString AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE TempSource AS CHARACTER                         NO-UNDO.

  IF NOT VALID-HANDLE(CurObj) THEN RETURN.
  
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN vBasePhrase              = "":U
           vBasePhrase:SCREEN-VALUE = "":U
           vBasePhrase:LIST-ITEMS   = ?
           TempString               = "":U
           TempSource               = "":U.
    CASE ObjectType:SCREEN-VALUE:
      WHEN "Text":U THEN DO:
        /* First attempt to find by Original Text from the screen */
        {adetran/vt/_prpty.i Text tTblObj.ObjOLbl CurObj:SCREEN-VALUE Curobj}
        IF NOT AVAILABLE tTblObj THEN  /* Now try by translation */
          {adetran/vt/_prpty.i Text tTblObj.ObjNLbl CurObj:SCREEN-VALUE Curobj}
        IF NOT AVAILABLE tTblObj THEN
          /* Now try either assuming screen-value has been truncated */
          FIND FIRST tTblObj WHERE tTblObj.ObjWName = CurWin:TITLE AND
                                   tTblObj.ObjName  = Curobj:NAME  AND
                                   tTblObj.ObjType  = "TEXT":U AND
                                  (tTblObj.ObjOLbl BEGINS CurObj:SCREEN-VALUE OR
                                   tTblObj.ObjNLbl BEGINS CurObj:SCREEN-VALUE)
                                NO-ERROR.
        IF AVAILABLE tTblObj THEN TempSource = tTblObj.ObjOLbl.
                             ELSE TempSource = CurObj:SCREEN-VALUE.  /* Assume No-translation */
      END.
      WHEN "Label":U THEN DO:
          IF (tDispType = "c":U AND (ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) = "BU":U)) THEN
          DO:
            ASSIGN tChar = ENTRY(2,CurObj:PRIVATE-DATA,CHR(4))
                   tChar = LEFT-TRIM(tChar,"<":U)    
                   tChar = RIGHT-TRIM(tChar,">":U) 
                   tChar = TRIM(REPLACE(tChar,"&":U,"":U)).   
                                  
            {adetran/vt/_prpty.i label tTblObj.ObjNLbl tChar Curobj}      
            IF AVAILABLE tTblObj THEN TempSource = tTblObj.ObjOLbl.
                                 ELSE TempSource = tChar.
          END.  /* If char mode AND a button */
          ELSE IF (tDispType = "c":U AND entry(1,CurObj:Private-data,CHR(4)) = "TB":U) THEN
          DO:  
            ASSIGN tChar = ENTRY(2, CurObj:PRIVATE-DATA, CHR(4))
                   tChar = SUBSTRING(tChar, INDEX(tChar,"]":U) + 1, LENGTH(tChar))
                   tChar = TRIM(REPLACE(tChar, "&":U, "":U)).

            {adetran/vt/_prpty.i label tTblObj.ObjNLbl tChar Curobj}
            IF AVAILABLE tTblObj THEN TempSource = tTblObj.ObjOLbl.
                                 ELSE TempSource = tChar.
          END. /* Else if char mode toggle box */
          ELSE DO:
            tParent = curobj:PARENT.
            {adetran/vt/_prpty.i label tTblObj.ObjNLbl CurObj:label Curobj}
            IF NOT AVAILABLE tTblObj AND tParent:TYPE = "BROWSE":U THEN
            DO:
              /* >>> We have a browse column <<< */
              FIND tTblObj WHERE tTblObj.ObjName = CurObj:NAME AND
                                 tTblObj.ObjType = "colabel":U NO-ERROR.
            END.  /* If a browse column */
            IF AVAILABLE tTblObj THEN TempSource = tTblObj.ObjOLbl.
                                 ELSE TempSource = CurObj:LABEL.
          END.  /* Else must be gui and not a browse, button or toggle box */
      END.  /* When a label */
      WHEN "Private-Data":U THEN TempSource = CurObj:PRIVATE-DATA.
      WHEN "Help":U         THEN TempSource = CurObj:HELP.
      WHEN "Format":U       THEN TempSource = CurObj:FORMAT.
      WHEN "Tooltip":U      THEN DO:
        {adetran/vt/_prpty.i Tooltip tTblObj.ObjNLbl CurObj:Tooltip Curobj}
        IF AVAILABLE tTblObj THEN TempSource = tTblObj.ObjOLbl.
                             ELSE TempSource = CurObj:TOOLTIP.
      END.
      WHEN "Title":U        THEN DO:
        {adetran/vt/_prpty.i Title tTblObj.ObjNLbl CurObj:title Curobj}
        IF AVAILABLE tTblObj THEN TempSource = tTblObj.ObjOLbl.
                             ELSE TempSource = CurObj:TITLE.
      END. /* When a title */
      WHEN "Radio-Buttons":U THEN DO:   
        ASSIGN tCharSav = CurObj:Radio-Buttons
               tChar    = "":U.
        do tInt2 = 1 to NUM-ENTRIES(tCharSav):
          IF tInt2 mod 2 = 0 THEN next.
          ELSE do:
            {adetran/vt/_prpty.i items tTblObj.ObjNLbl entry(tInt2,tCharSav) Curobj}      
            IF AVAILABLE tTblObj THEN tChar = tChar + tTblObj.ObjOLbl + CHR(4). 
                                 ELSE tChar = tChar + entry(tInt2,tCharSav) + CHR(4).
          END. /* Else not a radio-value */
        END.  /* Run through the entries of the radio-set */                                           
  
        vBasePhrase:LIST-ITEMS = TRIM(tChar,CHR(4)).
        If NUM-ENTRIES(vBasePhrase:LIST-ITEMS, CHR(4)) > 0 THEN DO:
          ASSIGN vBasePhrase              = ENTRY(1,vBasePhrase:LIST-ITEMS, CHR(4))
                 vBasePhrase:SCREEN-VALUE = vBasePhrase.
          run FindTargetValue.
        END.    
        ELSE vBasePhrase = "":U.    
      END. /* When radio-buttons */
      WHEN "List-Items":U THEN DO:      
        IF tDispType = "c":U AND (entry(1,CurObj:PRIVATE-DATA,CHR(4)) = "CB":U) THEN
           ASSIGN tCharSav    = ENTRY(2,CurObj:PRIVATE-DATA,CHR(4))
                  vBasePhrase = "":U
                  tChar       = "":U.
         ELSE IF CAN-QUERY(CurObj, "List-Items":U) THEN /* GUI */
            ASSIGN  tCharSav    = CurObj:LIST-ITEMS
                    vBasePhrase = "":U
                    tChar       = "":U.
         ELSE  /* 12/99 tomn: Not sure if this is the best thing to do, but we were
               ** running into problems with LIST-ITEMS above when object was defined
               ** with LIST-ITEM-PAIRS...
               */
            ASSIGN tCharSav    = "":U
                   vBasePhrase = "":U
                   tChar       = "":U.

        DO tInt2 = 1 to NUM-ENTRIES(tCharSav):
          {adetran/vt/_prpty.i items tTblObj.ObjNLbl entry(tInt2,tCharSav) Curobj}
          IF AVAILABLE tTblObj THEN tChar = tChar + tTblObj.ObjOLbl + CHR(4).
                               ELSE tChar = tChar + entry(tInt2,tCharSav) + CHR(4).
        END.
        ASSIGN vBasePhrase:LIST-ITEMS   = trim(tChar,CHR(4)) 
               vBasePhrase              = entry(1,vBasePhrase:LIST-ITEMS, CHR(4))
               vBasePhrase:SCREEN-VALUE = vBasePhrase.
        RUN FindTargetValue. 
      END. /* When List-Items */
      WHEN "List-Item-Pairs":U THEN DO:      
          IF tDispType = "c":U AND (entry(1,CurObj:PRIVATE-DATA,CHR(4)) = "CB":U) THEN
             ASSIGN tCharSav    = ENTRY(2,CurObj:PRIVATE-DATA,CHR(4))
                    vBasePhrase = "":U
                    tChar       = "":U.
           ELSE IF CAN-QUERY(CurObj, "LIST-ITEM-PAIRS":U) THEN /* GUI */
              ASSIGN  tCharSav    = CurObj:LIST-ITEM-PAIRS
                      vBasePhrase = "":U
                      tChar       = "":U.
         ELSE  /* 12/99 tomn: Not sure if this is the best thing to do, but we were
               ** running into problems with LIST-ITEM-PAIRS above when object was
               ** defined with LIST-ITEMS...
               */
            ASSIGN tCharSav    = "":U
                   vBasePhrase = "":U
                   tChar       = "":U.

          DO tInt2 = 1 to NUM-ENTRIES(tCharSav):
            {adetran/vt/_prpty.i items tTblObj.ObjNLbl entry(tInt2,tCharSav) Curobj}
            IF AVAILABLE tTblObj THEN tChar = tChar + tTblObj.ObjOLbl + CHR(4).
                                 ELSE tChar = tChar + entry(tInt2,tCharSav) + CHR(4).
          END.
          ASSIGN vBasePhrase:LIST-ITEMS   = trim(tChar,CHR(4)) 
                 vBasePhrase              = entry(1,vBasePhrase:LIST-ITEMS, CHR(4))
                 vBasePhrase:SCREEN-VALUE = vBasePhrase.
          RUN FindTargetValue. 
        END. /* When List-Item-Pairs */
    END CASE. /* Case based on ObjectType:SCREEN-VALUE */
       
    ASSIGN TempSource = TRIM(TempSource)
           TempString = TempSource.                     
                  
    IF TempSource <> "":U THEN DO:
      IF NUM-ENTRIES(TempSource," ":U) = 1 THEN vBasePhrase:LIST-ITEMS = TempSource.
      ELSE DO:  /* TempSource is more than one word */
        TempString = TempString + CHR(4) + REPLACE(TempSource," ":U, CHR(4)).
        ASSIGN TempString = REPLACE(TempString,CHR(4) + CHR(4), CHR(4))
               vBasePhrase:LIST-ITEMS = TRIM(TempString,CHR(4)).
      END. /* More than 1 word */  
    END.
                                   
    IF vBasePhrase:LIST-ITEMS = ? THEN DO:
      ASSIGN vBasePhrase:LIST-ITEMS   = "(None)":U
             vBasePhrase:SCREEN-VALUE = "(None)":U
             vBasePhrase              = "":U 
             vTranslation:sensitive   = FALSE
             BtnSave:sensitive        = FALSE
             UseWordIdx:sensitive     = FALSE. 
      RUN OpenQry.   
      RETURN.
    END.  /* If vBasePhrase:LIST-ITEMS is unknown */
    ELSE ASSIGN vTranslation:sensitive = true
                BtnSave:sensitive      = true
                UseWordIdx:sensitive   = true.

    IF vBasePhrase:num-items > 0 THEN 
      ASSIGN vBasePhrase              = vBasePhrase:ENTRY(1)
             vBasePhrase:SCREEN-VALUE = vBasePhrase.
    IF vBasePhrase <> "":U THEN run OpenQry.
  END. /* Do with frame {&FRAME-NAME} */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindTargetValue PropsWin 
PROCEDURE FindTargetValue :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  tmp-flnm = IF SUBSTRING(pFileName, 1, 1, "CHARACTER":U) = ".":U THEN
                SUBSTRING(pFileName, 3, -1, "CHARACTER":U)        ELSE pFileName.
  DO WITH FRAME {&FRAME-NAME}:
    FIND FIRST kit.XL_Instance 
      WHERE kit.XL_Instance.StringKey BEGINS SUBSTRING(vBasePhrase, 1, 63, "RAW":U)
        AND kit.XL_Instance.ProcedureName = tmp-flnm
        AND COMPARE(kit.XL_INSTANCE.StringKey, "=":U,
                    SUBSTRING(vBasePhrase, 1, 63, "RAW":U), "CAPS":U)
        USE-INDEX SrcProc
      NO-LOCK NO-ERROR.
    IF AVAILABLE(kit.XL_Instance) THEN DO:
      /* Save off initial Target phrase value for later comparison,
      ** and update Property dialog with new Target phrase value.
      */
      ASSIGN
        cOrigTargetPhrase         = kit.XL_Instance.TargetPhrase
        vTranslation:SCREEN-VALUE = kit.XL_Instance.TargetPhrase.

      /* Someone must have changed the translation value in multi-user mode */
      IF AVAILABLE tTblObj AND tTblObj.ObjNLbl NE kit.XL_Instance.TargetPhrase THEN
      DO:
        ASSIGN tTblObj.ObjNLbl = kit.XL_Instance.TargetPhrase.
        RUN setActiveTrans.
      END.  /* AVAILABLE tTblObj */
    END.  /* AVAILABLE kit.XL_Instance */
    ELSE
      vTranslation:SCREEN-VALUE = "":U.  /* No translation */

    IF (vTranslation:SCREEN-VALUE = "":U) THEN DO:
         tmp-string = REPLACE(vBasePhrase, "~&":U, "":U).
      /* It hasn't been translated yet, try a guess */
      FIND FIRST kit.XL_GlossEntry WHERE
         kit.XL_GlossEntry.ShortSrc BEGINS SUBSTRING(tmp-string, 1, 63, "RAW":U) AND
         kit.XL_GlossEntry.SourcePhrase MATCHES tmp-string NO-LOCK NO-ERROR.
      IF available kit.XL_GlossEntry THEN 
          vTranslation:screen-value  = kit.XL_GlossEntry.TargetPhrase.
      /* This is only a guess so make it red until it is accepted */
      vTranslation:fgcolor = 12.
    END.
    ELSE /* saved before */              
       ASSIGN vTranslation:fgcolor = 0.
        
    IF VALID-EVENT(PropsWin,"ENTRY":U) THEN APPLY "ENTRY":U TO vTranslation.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-ww PropsWin 
PROCEDURE gen-ww :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER hpar      AS WIDGET-HANDLE                     NO-UNDO.
  DEFINE VARIABLE        fgp       AS HANDLE                            NO-UNDO.
  DEFINE VARIABLE        gen-rec   AS LOGICAL                           NO-UNDO.
  DEFINE VARIABLE        h         AS HANDLE                            NO-UNDO.
  DEFINE VARIABLE        mh        AS HANDLE                            NO-UNDO.
  DEFINE VARIABLE        this-seq  AS INTEGER                           NO-UNDO.

  FIND LAST ww WHERE ww.wndw = CurWin NO-ERROR.
  IF AVAILABLE ww THEN this-seq = ww.sq.
  ELSE DO:  /* New CurWin */
    /* Remove existing ww's */
    FOR EACH ww:
      DELETE ww.
    END.
    
    /* Create a record for the window itself */
    CREATE ww.
    ASSIGN ww.wndw   = CurWin
           ww.sq     = 0
           ww.cl     = 0
           ww.rw     = 0
           ww.is-frm = NO
           ww.fldgrp = ?
           ww.hndl   = CurWin.
    IF VALID-HANDLE(CurWin:MENU-BAR) THEN
      RUN gen-ww(CurWin:MENU-BAR).
    IF VALID-HANDLE(CurWin:POPUP-MENU) THEN DO:
      mh = CurWin:POPUP-MENU.
      IF mh:TITLE NE "":U AND mh:TITLE NE ? THEN DO:
        CREATE ww.
        ASSIGN ww.wndw   = CurWin
               ww.sq     = 0
               ww.cl     = 0
               ww.rw     = 0
               ww.is-frm = NO
               ww.fldgrp = ?
               ww.hndl   = mh.
      END.
      RUN gen-ww(mh).
    END.
  END.  /* If window itself */

  /* Generate records for all children of this parent */
  h = IF hpar:TYPE = "BROWSE":U THEN hpar:FIRST-COLUMN ELSE hpar:FIRST-CHILD.
  DO WHILE VALID-HANDLE(h):
    IF h:TYPE = "FRAME":U THEN DO:  /* Get a new unque sq for this frame */
      DO WHILE CAN-FIND(FIRST ww WHERE ww.wndw = CurWin AND
                                       ww.sq = this-seq):
        this-seq = this-seq + 1.
      END.
    END.  /* If child is a frame  */

    /* Don't generate records for thing with no text to translate */
    gen-rec = TRUE.
    IF LOOKUP(h:TYPE,"LITERAL,FIELD-GROUP":U) > 0
                                                          THEN gen-rec = FALSE.
    IF tDispType = "C":U THEN DO:
      IF ENTRY(1,h:PRIVATE-DATA,CHR(4)) = "ED":U AND
                                     h:LABEL = ?          THEN gen-rec = FALSE.
      ELSE IF ENTRY(1,h:PRIVATE-DATA,CHR(4)) = "SL":U
                         AND h:LABEL = ? AND h:Help = ?   THEN gen-rec = FALSE. 
      ELSE IF CAN-DO("RC,IM":U, ENTRY(1,h:PRIVATE-DATA,CHR(4)))
                                                          THEN gen-rec = FALSE.
    END.  /* If character mode */
    ELSE DO: /* GUI */
      IF h:TYPE = "EDITOR":U AND (h:LABEL = ? OR h:LABEL = "":U)
                AND (h:TOOLTIP = ? OR h:TOOLTIP = "":U) THEN gen-rec = FALSE. 
      ELSE IF h:TYPE = "IMAGE":U 
                AND (h:TOOLTIP = ? OR h:TOOLTIP = "":U) THEN gen-rec = FALSE. 
      ELSE IF h:TYPE = "RECTANGLE":U 
                AND (h:TOOLTIP = ? OR h:TOOLTIP = "":U) THEN gen-rec = FALSE. 
      ELSE IF h:TYPE = "LITERAL":U 
                AND (h:TOOLTIP = ? OR h:TOOLTIP = "":U) THEN gen-rec = FALSE. 
      ELSE IF h:TYPE = "SLIDER":U AND (h:LABEL = ? OR h:LABEL = "":U)
                AND h:Help = ?
                AND (h:TOOLTIP = ? OR h:TOOLTIP = "":U) THEN gen-rec = FALSE. 
      ELSE IF h:TYPE BEGINS "MENU":U AND (h:LABEL = ? OR h:LABEL = "":U)
                THEN gen-rec = FALSE. 
      IF h:TYPE = "FILL-IN":U AND h:LABEL = ? AND h:HELP = ? 
                AND (h:TOOLTIP = ? OR h:TOOLTIP = "":U) THEN gen-rec = FALSE. 
    END.  /* GUI */
    
    /* Make sure things of the same Field Group have the same sequence # */
    fgp = h:PARENT.
    IF fgp:TYPE NE "FIELD-GROUP":U THEN fgp = ?.
    FIND FIRST ww WHERE ww.fldgrp = fgp NO-ERROR.
    IF AVAILABLE ww AND fgp NE ? THEN this-seq = ww.sq.
      
    IF gen-rec THEN DO:
      CREATE ww.
      ASSIGN ww.wndw   = CurWin
             ww.sq     = this-seq
             ww.cl     = IF h:TYPE NE "FRAME":U AND CAN-QUERY(h,"COLUMN":U)
                         THEN INTEGER(h:COLUMN) ELSE 0
             ww.rw     = IF h:TYPE NE "FRAME":U AND CAN-QUERY(h,"ROW":U)
                         THEN INTEGER(h:ROW) ELSE 0
             ww.is-frm = h:TYPE = "FRAME":U
             ww.fldgrp = fgp
             ww.hndl   = h.
    END.  /* If ok to generate */
    
    IF VALID-HANDLE(CurWin:POPUP-MENU) THEN DO:
      mh = CurWin:POPUP-MENU.
      IF mh:TITLE NE "":U AND mh:TITLE NE ? THEN DO:
        CREATE ww.
        ASSIGN ww.wndw = CurWin
               ww.sq     = this-seq
               ww.cl     = 0
               ww.rw     = 0
               ww.is-frm = NO
               ww.fldgrp = ?
               ww.hndl   = mh.
      END.
      RUN gen-ww(mh).
    END.

    IF CAN-QUERY(h, "FIRST-CHILD":U) THEN RUN gen-ww (h).
    ELSE IF CAN-QUERY(h, "FIRST-COLUMN":U) THEN RUN gen-ww (h).

    ASSIGN h = IF CAN-QUERY(h, "NEXT-SIBLING":U) THEN
                  h:NEXT-SIBLING
               ELSE IF CAN-QUERY(h, "NEXT-COLUMN":U) THEN
                  h:NEXT-COLUMN
               ELSE
                  ?.
  END.  /* While a valid child of hpar */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetLabelObject PropsWin 
PROCEDURE GetLabelObject :
DEFINE INPUT-OUTPUT PARAM pCurObj AS HANDLE NO-UNDO.
  
  DEFINE VAR textH   AS HANDLE.
  DEFINE VAR parentH AS HANDLE.

  IF pCurObj:TYPE <> "LITERAL":U THEN RETURN.
  ASSIGN parentH = pCurObj:PARENT.
         textH   = parentH:FIRST-CHILD.
  DO WHILE VALID-HANDLE(textH):
    IF     CAN-QUERY(textH, "SIDE-LABEL-HANDLE":U)
       AND textH:SIDE-LABEL-HANDLE = pCurObj THEN LEAVE.
    textH = textH:NEXT-SIBLING.
  END.
  IF VALID-HANDLE(textH) THEN pCurObj = textH.
  RETURN.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HidePropWin PropsWin 
PROCEDURE HidePropWin :
/*------------------------------------------------------------------------------
  Purpose:     Hide properties window.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  ASSIGN PropsWin:HIDDEN = YES.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE MenuLbl PropsWin 
PROCEDURE MenuLbl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 define input parameter pTranWin as widget-handle no-undo.
 define variable tWhMenu         as widget-handle no-undo.

  IF tDispType = "":U THEN DO:  /* Hasn't been initialized */
    find first kit.xl_project no-lock no-error.
    IF AVAILABLE kit.xl_project THEN
       tDispType = kit.xl_project.DisplayType.
  END.

/* *** not implemented yet (tomn 10/99)...
  /* If glLockProcs Option specified, set flag to lock all translations
  ** for this resource procedure.
  */
  IF yes /*glLockProcs*/ THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    ASSIGN tmppos  = R-INDEX(pFileName, "\":U)
           tmpdir  = IF tmppos GT 0 THEN
                      SUBSTRING(pFileName, 1, tmppos - 1, "CHARACTER":U)
                     ELSE
                       ".":U
           tmpfile = SUBSTRING(pFileName, tmppos + 1, -1, "CHARACTER":U).
    FIND kit.XL_Procedure WHERE kit.XL_Procedure.Directory = tmpdir
                            AND kit.XL_Procedure.Filename  = tmpfile
      EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF AVAILABLE kit.XL_Procedure AND NOT LOCKED kit.XL_Procedure THEN
    DO:
      ASSIGN kit.XL_Procedure.CurrentStatus = kit.XL_Procedure.CurrentStatus +
                                              CHR(4) + "LOCKED":U.
    END.
    ELSE DO:
      ThisMessage = "Unable to lock translations for this procedure.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
    END.  /* NOT AVAILABLE kit.XL_Procedure */
  END.  /* Lock all translations for this resource procedure */

  FIND CURRENT kit.XL_Procedure NO-LOCK NO-ERROR.  /* Downgrade lock */
*** */

  IF valid-handle(pTranWin:Menu-Bar) THEN DO:
    ASSIGN tWhMenu  = pTranWin:menu-bar
           tmp-flnm = IF SUBSTRING(pFileName, 1, 1, "CHARACTER":U) = ".":U
                      THEN SUBSTRING(pFileName, 3, -1, "CHARACTER":U)
                      ELSE pFileName.
    do while tWhMenu ne ?:
      IF tWhMenu:type = "menu":U THEN   
         RUN FindLbl(tWhMenu).             
      ELSE IF tWhMenu:type = "sub-menu":U THEN   
        run FindLbl(tWhMenu).             
      ELSE IF tWhMenu:type = "Menu-Item":U THEN DO:
        {adetran/vt/_props.i tWhMenu:Label tWhMenu:name label}
      END.                               
      
      ASSIGN tWhMenu = IF CAN-QUERY(tWhMenu,"NEXT-SIBLING":U) THEN
                          tWhMenu:next-sibling
                       ELSE ?.
    END. /* DO WHILE tWhMenu is valid */
  END. /* IF There is a menu-bar */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQry PropsWin 
PROCEDURE OpenQry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  tmp-string = REPLACE(vBasePhrase ,"&":U,"":U).
  IF UseWordIdx:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
    OPEN QUERY LookupBrowser FOR EACH kit.XL_GlossEntry
         WHERE XL_GlossEntry.SourcePhrase CONTAINS tmp-string NO-LOCK.
  END.
  ELSE  {&OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Properties PropsWin 
PROCEDURE Properties :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF NOT VALID-HANDLE(CurObj) THEN RETURN.
  DO WITH FRAME {&FRAME-NAME}:
    RUN adecomm/_setcurs.p ("WAIT":U).

    RUN GetLabelObject (INPUT-OUTPUT CurObj).

    IF tDispType = "":U THEN DO:
      FIND FIRST kit.xl_project NO-LOCK NO-ERROR.
      IF avail kit.xl_project THEN tDispType = kit.xl_project.DisplayType.
    END.
    IF tDispType = "c":U AND CAN-DO("RC,IM":U,ENTRY(1,CurObj:PRIVATE-DATA,CHR(4))) THEN DO:
      IF ENTRY(1,CurObj:Private-data,CHR(4)) = "RC":U THEN 
         ThisMessage = "You can't translate a rectangle.".
      ELSE
         ThisMessage = "You can't translate an image.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).
      RETURN.
    END.
    /* Note that rectangles and images can have tooltips to translate */
    ELSE IF CAN-DO("LITERAL":U, CurObj:TYPE) THEN DO:
      ThisMessage = "You can't translate a literal.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w*":U, "ok":U, ThisMessage).
      RETURN.
    END.
    result = BtnSave:LOAD-IMAGE-UP("adetran/images/check":U).
    DISPLAY TargetLabel ChoiceLabel WITH FRAME DEFAULT-FRAME IN WINDOW PropsWin.
    ENABLE ObjectType BtnClose BtnMovePrev BtnMoveNext BtnFrames BtnExpose
           BtnSwitch BtnHelp vBasePhrase vTranslation BtnSave LookUpBrowser 
           UseWordIdx
       WITH FRAME {&FRAME-NAME} IN WINDOW PropsWin.

    RUN FindObjectType.

    ASSIGN PropsWin:HIDDEN = FALSE
           tSTFlg          = FALSE
           MENU-ITEM mSource:CHECKED   IN MENU MENU-BAR-C-Win   = FALSE
           MENU-ITEM mSource:SENSITIVE IN MENU MENU-BAR-C-Win = TRUE
           MENU-ITEM mTarget:CHECKED   IN MENU MENU-BAR-C-Win   = TRUE
           MENU-ITEM mTarget:SENSITIVE IN MENU MENU-BAR-C-Win = FALSE.
    RUN SetSensitivity.
    IF VALID-EVENT(PropsWin,"ENTRY":U) THEN
      APPLY "ENTRY":U TO vTranslation IN FRAME {&FRAME-NAME}.
    RUN adecomm/_setcurs.p ("":U).
    APPLY "ENTRY":U TO PropsWin.
    RUN REFRESH IN hLongStr (INPUT vBasePhrase:SCREEN-VALUE,
                             INPUT vTranslation:SCREEN-VALUE,
                             INPUT hProps).
  END.  /* Do WITH FRAME {&FRAME-NAME} */
  RUN PropsWinState IN hMain (YES). /* check MENU-ITEM in VT menubar */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize PropsWin 
PROCEDURE Realize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  PropsWin:hidden = true.

  ENABLE ObjectType BtnClose BtnMovePrev BtnMoveNext BtnFrames BtnExpose
         BtnSwitch BtnHelp vBasePhrase vTranslation BtnSave LookUpBrowser
         UseWordIdx
    with frame {&frame-name} in window PropsWin.
  VIEW frame {&frame-name} in window PropsWin.
  
  IF NOT CAN-FIND(FIRST ww WHERE ww.wndw = CurWin) THEN
    RUN gen-ww (CurWin).

  RUN FindObjectType.
  PropsWin:hidden = false.
  run adecomm/_setcurs.p ("":U).

  IF valid-event(PropsWin,"entry":U) THEN
     apply "entry":U to vTranslation in frame {&frame-name}.
  IF PropsWin:MOVE-TO-TOP() THEN.
  IF UseWordIdx:CHECKED IN FRAME {&FRAME-NAME}
    THEN RUN Openqry.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ResetCursor PropsWin 
PROCEDURE ResetCursor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  CurrentPointer = false.
  do with frame {&frame-name}:
    ASSIGN result = BtnHelp:load-image("adetran/images/help":U)
           result = ObjectType:load-mouse-pointer("arrow":U)
           result = BtnClose:load-mouse-pointer("arrow":U)
           result = BtnMovePrev:load-mouse-pointer("arrow":U)
           result = BtnMoveNext:load-mouse-pointer("arrow":U)
           result = BtnFrames:load-mouse-pointer("arrow":U)
           result = BtnSwitch:load-mouse-pointer("arrow":U)
           result = BtnExpose:load-mouse-pointer("arrow":U)
           result = vBasePhrase:load-mouse-pointer("arrow":U)
           result = vTranslation:load-mouse-pointer("arrow":U)
           result = BtnSave:load-mouse-pointer("arrow":U)
           result = LookUpBrowser:load-mouse-pointer("arrow":U)
           result = UseWordIdx:load-mouse-pointer("arrow":U).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetEditButtons PropsWin 
PROCEDURE SetEditButtons :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  do with frame {&frame-name}:
    ASSIGN Menu-Item mCut:sensitive in menu MENU-BAR-C-Win =
                IF vTranslation:selection-Text <> "":U THEN true ELSE false
           Menu-Item mCopy:sensitive in menu MENU-BAR-C-Win =
                IF vTranslation:selection-Text <> "":U THEN true ELSE false
           Menu-Item mPaste:sensitive in menu MENU-BAR-C-Win =
                IF clipboard:num-formats > 0         THEN true ELSE false.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetSensitivity PropsWin 
PROCEDURE SetSensitivity :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  do with frame {&frame-name}:
    define var NextObj    as widget-handle no-undo.
    define var PrevObj    as widget-handle no-undo.
    define var FrameGroup as widget-handle no-undo.
    define var FrameCnt   as integer       no-undo.
    define var LastFrame  as widget-handle no-undo.

    ASSIGN BtnMoveNext:sensitive = TRUE 
           BtnMovePrev:sensitive = TRUE.

    /* Count the number of frames  */
    FrameGroup = CurWin:first-child.
    do while FrameGroup ne ?:
      FrameCnt  = FrameCnt + 1.
      IF FrameCnt = 1 THEN LastFrame = FrameGroup.
      FrameGroup = FrameGroup:next-sibling.
    END.

    run SetEditButtons.

    IF vBasePhrase:screen-value = "(None)":U THEN
      ASSIGN Menu-Item mCopy:sensitive in menu MENU-BAR-C-Win = false
             Menu-Item mCut:sensitive in menu MENU-BAR-C-Win = false
             Menu-Item mPaste:sensitive in menu MENU-BAR-C-Win = false
             BtnSave:sensitive = false
             vTranslation:sensitive = false
             UseWordIdx:sensitive = false.
    ELSE
      ASSIGN Menu-Item mCopy:sensitive in menu MENU-BAR-C-Win = true
             Menu-Item mCut:sensitive in menu MENU-BAR-C-Win = true
             BtnExpose:sensitive = true
             BtnFrames:sensitive = IF FrameCnt > 1 THEN true
                                                   ELSE false
             Menu-Item mNextFrame:sensitive in menu MENU-BAR-C-Win = BtnFrames:sensitive
             BtnMoveNext:sensitive = true
             BtnMovePrev:sensitive = true
             Menu-Item mPaste:sensitive in menu MENU-BAR-C-Win = true
             BtnSave:sensitive = true
             BtnSwitch:sensitive = true
             vBasePhrase:sensitive = true
             vTranslation:sensitive = true
             UseWordIdx:sensitive = true.
  END. /* DO WITH FRAME {&FRAME-NAME} */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetUpLbl PropsWin 
PROCEDURE SetUpLbl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  define input parameter pFrmGrp as widget-handle no-undo.

  IF tDispType = "":U THEN DO:
    find first kit.xl_project no-lock no-error.
    IF avail kit.xl_project THEN tDispType = kit.xl_project.DisplayType.
  END.

  IF pFileName <> pFileSav THEN
    ASSIGN TotFrame  = 0
           TotObject = 0
           pFileSav  = pFileName.

  ASSIGN TotFrame = TotFrame + 1
          tmp-flnm = IF SUBSTRING(pFileName, 1, 1, "CHARACTER":U) = ".":U
                     THEN SUBSTRING(pFileName, 3, -1, "CHARACTER":U)
                     ELSE pFileName.
  {adetran/vt/_props.i pFrmGrp:title pFrmGrp:name title}
  run FindLbl(pFrmGrp).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ShutDown PropsWin 
PROCEDURE ShutDown :
/*------------------------------------------------------------------------------
  Purpose:     Shutdown a running .RC 
  Parameters:  pHdl - procedure handle of RC procedure being shutdown
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pHdl   AS WIDGET-HANDLE                       NO-UNDO.
  DEFINE VARIABLE        tWinWh AS WIDGET-HANDLE                       NO-UNDO.

  ASSIGN ObjectGroup = ?
         tWinWh      = pHdl:CURRENT-WINDOW
         tmp-flnm    = IF SUBSTRING(pFileName, 1, 1, "CHARACTER":U) = ".":U
                          THEN SUBSTRING(pFileName, 3, -1, "CHARACTER":U)
                          ELSE pFileName.
  IF AutoTrans THEN DO:  /* Automatically translate guesses */
    AUTO-TRANS:
    FOR EACH tTblObj WHERE tTblObj.ObjWName = pFileName AND
                           tTblObj.FoundIn = "GLOSS":U EXCLUSIVE-LOCK TRANSACTION:
      IF tTblObj.ObjOLbl = "":U THEN NEXT AUTO-TRANS.
      IF can-find(kit.xl_invalid where kit.xl_invalid.Targetphrase MATCHES
                                       tTblObj.ObjNLbl) THEN DO:
        ThisMessage = tTblObj.ObjNLbl + " is an invalid transltion.".
        run adecomm/_s-alert.p (input-output ErrorStatus, "w*":U, "ok":U, ThisMessage).
        NEXT AUTO-TRANS.
      END.  /* The translation is invalid */
    
      /* Now, add the entry to the XL_Instance table */
      FIND FIRST kit.XL_Instance WHERE
                 kit.XL_Instance.ProcedureName = tmp-flnm AND
                 COMPARE(REPLACE(kit.XL_Instance.SourcePhrase,"~&":U,"":U), "=":U,
                         REPLACE(tTblObj.ObjOLbl,"~&":U,"":U), "CAPS":U)
        EXCLUSIVE-LOCK NO-ERROR.
      /* *** tomn: need locking test here?  Display failures/conflicts? */
      IF AVAILABLE kit.XL_Instance THEN DO:  /* It should always happen */
        ASSIGN NewTrans                     = (kit.XL_Instance.ShortTarg = "":U)
               kit.XL_Instance.TargetPhrase = tTblObj.ObjNLbl
               kit.XL_Instance.ShortTarg    = SUBSTRING(tTblObj.ObjNLbl,1,63,"RAW":U).
        IF kit.XL_Instance.ShortTarg = ? THEN kit.XL_Instance.ShortTarg = "":U.
        IF NOT LOCKED kit.XL_Project THEN find first kit.XL_Project EXCLUSIVE-LOCK no-error.
        IF avail kit.XL_Project THEN DO:
          IF NewTrans AND kit.XL_Instance.ShortTarg NE "":U THEN
            kit.XL_Project.TranslationCount = kit.XL_Project.TranslationCount + 1.
          ELSE IF NOT NewTrans AND kit.XL_Instance.ShortTarg = "":U THEN
            kit.XL_Project.TranslationCount = kit.XL_Project.TranslationCount - 1.
        END.
        run OpenQuery in hTrans.
        tModFlag = true.
      END.
      tTblObj.FoundIn = "INST":U.
    END. /* For EACH tTblObj fromt the glossary */

    FIND CURRENT kit.XL_Project NO-LOCK NO-ERROR.  /* Downgrade lock */
  END. /* If AutoTrans */

/* *** not implemented yet (tomn 10/99)...
  /* If glLockProcs Option specified, set flag to unlock all translations
  ** for this resource procedure.
  */
  IF yes /*glLockProcs*/ THEN DO TRANSACTION ON ERROR UNDO, LEAVE:
    ASSIGN tmppos  = R-INDEX(pFileName, "\":U)
           tmpdir  = IF tmppos GT 0 THEN
                      SUBSTRING(pFileName, 1, tmppos - 1, "CHARACTER":U)
                     ELSE
                       ".":U
           tmpfile = SUBSTRING(pFileName, tmppos + 1, -1, "CHARACTER":U).
    FIND kit.XL_Procedure WHERE kit.XL_Procedure.Directory = tmpdir
                            AND kit.XL_Procedure.Filename  = tmpfile
      EXCLUSIVE-LOCK NO-WAIT NO-ERROR.
    IF AVAILABLE kit.XL_Procedure AND NOT LOCKED kit.XL_Procedure THEN
    DO:
      IF INDEX(kit.XL_Procedure.CurrentStatus, CHR(4)) GT 0 THEN
        ASSIGN kit.XL_Procedure.CurrentStatus = 
                 ENTRY(1, kit.XL_Procedure.CurrentStatus, CHR(4)).
    END.
    ELSE DO:
      ThisMessage = "Unable to unlock translations for this procedure.".
      RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "w":U, "ok":U, ThisMessage).
    END.  /* NOT AVAILABLE kit.XL_Procedure */
  END.  /* Unlock all translations for this resource procedure */

  FIND CURRENT kit.XL_Procedure NO-LOCK NO-ERROR.  /* Downgrade lock */
*** */

  run DeleteWindows in hMain (pHdl).
  run UpdStatus in hProcs.
  FOR EACH ww:
    DELETE ww.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Store-Long-String PropsWin 
PROCEDURE Store-Long-String :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER src AS CHARACTER                                 NO-UNDO.
  DEFINE INPUT PARAMETER trg AS CHARACTER                                 NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN vBasePhrase:SCREEN-VALUE  = src
           vTranslation              = trg
           vTranslation:SCREEN-VALUE = trg.
    APPLY "CHOOSE":U TO MENU-ITEM mSave IN MENU MENU-BAR-C-Win.
  END.  /* Do with frame */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SwitchLbl PropsWin 
PROCEDURE SwitchLbl :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER pWH    AS WIDGET-HANDLE                       NO-UNDO.
  DEFINE INPUT PARAMETER pSTFlg AS LOGICAL  /* source/target */        NO-UNDO.
  DEFINE VARIABLE vChildWidget  AS WIDGET-HANDLE                       NO-UNDO.
  DEFINE VARIABLE vNextSibling  AS WIDGET-HANDLE                       NO-UNDO.

  IF CAN-QUERY(pWH,"FIRST-CHILD":U) THEN vChildWidget = pWH:FIRST-CHILD.

  DO WHILE vChildWidget <> ?:
    ASSIGN vNextSibling = IF CAN-QUERY(vChildWidget,"NEXT-SIBLING":U) THEN
                             vChildWidget:NEXT-SIBLING
                          ELSE
                             ?.
    IF vchildwidget:TYPE = "BROWSE":U THEN DO:  /* Working on a browse - do columns */
      ASSIGN tBrColWH = vChildWidget:FIRST-COLUMN.
      DO WHILE tBrColWH <> ?:
        ASSIGN tInt = R-INDEX(CurWin:TITLE,".":U).
        /* Try to find tTblObj based on Old-Label */
        FIND tTblObj WHERE (SUBSTRING(tTblObj.ObjWName,1,(R-INDEX(tTblObj.ObjWName,".":U))) =
                            SUBSTRING(CurWin:TITLE,1,tInt)) AND
                           (tTblObj.ObjType = "COLABEL":U)  AND
                           (tTblObj.ObjOLbl = tBrColWH:LABEL) NO-ERROR.
        IF AVAILABLE tTblObj THEN tBrColWH:LABEL = tTblObj.ObjNLbl.
        ELSE DO:  /* OK, now try to find it based on NEW Label */
          FIND tTblObj WHERE (SUBSTRING(tTblObj.ObjWName,1,(R-INDEX(tTblObj.ObjWName,".":U))) =
                              SUBSTRING(CurWin:TITLE,1,tInt)) AND
                             (tTblObj.ObjType = "COLABEL":U)  AND
                             (tTblObj.ObjNLbl = tBrColWH:LABEL) NO-ERROR.
          IF AVAILABLE tTblobj THEN tBrColWH:LABEL = tTblObj.ObjOLbl.
        END.
        tBrColWH = tBrColWH:NEXT-COLUMN.  /* Get next browse column */
      END.  /* DO WHILE tBrCol <> ? */
    END.  /* If we are working with a browse */
    ELSE IF (tDispType = "c":U AND ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "BU":U) or
            (tDispType = "c":U AND ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "TB":U) THEN DO:
      /* Here we are working with a Button or toggle-box in character mode */
      ASSIGN tChar    = ENTRY(2,vChildWidget:PRIVATE-DATA,CHR(4))
             tChar    = REPLACE(tChar,"&":U,"":U)
             tCharSav = tChar.
      /* Try to find tTblObj based on OLD Label */
      {adetran/vt/_prpty.i label tTblObj.ObjOLbl tChar vChildWidget}
      IF AVAILABLE tTblobj THEN DO:
        ASSIGN tmpChar = IF ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "TB":U
                         THEN ENTRY(3,vChildWidget:PRIVATE-DATA,CHR(4)) ELSE "":U 
               tChar   = tTblObj.ObjNLbl.
        RUN DispCBtn(ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)),
                     INPUT vChildWidget:WIDTH-CHAR,
                     INPUT tmpChar,
                     INPUT-OUTPUT tChar).
        ASSIGN vChildWidget:SCREEN-VALUE = tChar
               vChildWidget:PRIVATE-DATA =
                      (IF ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "TB":U THEN
                          ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) + CHR(4) + tTblObj.ObjNLbl +
                          CHR(4) + ENTRY(3,vChildWidget:PRIVATE-DATA,CHR(4))
                       ELSE ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) + CHR(4) + tTblObj.ObjNLbl).
      END. /* If we found tTblObj based on OLD Label */
      ELSE DO:  /* Try to find it based on NEW Label */
        {adetran/vt/_prpty.i label tTblObj.ObjNLbl tChar vChildWidget}
        IF AVAILABLE tTblobj THEN DO:
          ASSIGN tmpChar = IF ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "TB":U
                           THEN ENTRY(3,vChildWidget:PRIVATE-DATA,CHR(4)) ELSE "":U
                 tChar = tTblObj.ObjOLbl.
          run DispCBtn(ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)),
                       INPUT vChildWidget:WIDTH-CHAR,
                       INPUT tmpChar,
                       INPUT-OUTPUT tChar).
          ASSIGN vChildWidget:SCREEN-VALUE = tChar
                 vChildWidget:PRIVATE-DATA =
                        (if ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) = "TB":U THEN
                            ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) + CHR(4) + tTblObj.ObjOLbl +
                            CHR(4) + ENTRY(3,vChildWidget:PRIVATE-DATA,CHR(4))
                         ELSE ENTRY(1,vChildWidget:PRIVATE-DATA,CHR(4)) + CHR(4) + tTblObj.ObjOLbl).
        END. /* If found tTblObj based on NEW Label */
      END. /* Else try NEW Label */
    END.  /* If Character mode button or toggle-box */
    ELSE IF CAN-QUERY(vChildWidget,"LABEL":U) THEN DO:  /* Does the widget have a label? */
      IF pSTFlg THEN /* Want to look at the source labels */
      DO:
         /* Find tTblObj based on OLD label */
         {adetran/vt/_prpty.i label tTblObj.ObjOLbl vChildWidget:LABEL vChildWidget}
         IF AVAILABLE tTblobj THEN .
         ELSE
         DO:
            {adetran/vt/_prpty.i label tTblObj.ObjNLbl vChildWidget:LABEL vChildWidget}
            IF AVAILABLE tTblObj THEN vChildwidget:LABEL = tTblObj.ObjOLbl.
         END.
      END. /* Source */
      ELSE
      DO:
        {adetran/vt/_prpty.i label tTblObj.ObjNLbl vChildWidget:LABEL vChildWidget}
        IF AVAILABLE tTblObj THEN .
        ELSE
        DO:
            {adetran/vt/_prpty.i label tTblObj.ObjOLbl vChildWidget:LABEL vChildWidget}
            IF AVAILABLE tTblObj THEN vChildwidget:LABEL = tTblObj.ObjNLbl.
        END.
      END.
    END.  /* IF widget has a label */

    IF vChildWidget:TYPE = "TEXT":U THEN DO:  /* If widget is a text widget */
      {adetran/vt/_prpty.i text tTblObj.ObjOLbl vChildWidget:SCREEN-VALUE vChildWidget}
      IF NOT AVAILABLE tTblObj THEN
        /* Now try again assuming screen-value has been truncated */
        FIND FIRST tTblObj WHERE tTblObj.ObjWName = CurWin:TITLE AND
                                 tTblObj.ObjName  = vChildWidget:NAME  AND
                                 tTblObj.ObjType  = "TEXT":U AND
                                 tTblObj.ObjOLbl BEGINS vChildWidget:SCREEN-VALUE
                              NO-ERROR.
      IF AVAILABLE tTblobj THEN vChildwidget:SCREEN-VALUE = tTblObj.ObjNLbl.
      ELSE DO:  /* Could find tTBlObj based on OLD label, now try NEW label */
        {adetran/vt/_prpty.i text tTblObj.ObjNLbl vChildWidget:SCREEN-VALUE vChildWidget}
        IF NOT AVAILABLE tTblObj THEN
          /* Now try again assuming screen-value has been truncated */
          FIND FIRST tTblObj WHERE tTblObj.ObjWName = CurWin:TITLE AND
                                   tTblObj.ObjName  = vChildWidget:NAME  AND
                                   tTblObj.ObjType  = "TEXT":U AND
                                   tTblObj.ObjNLbl BEGINS vChildWidget:SCREEN-VALUE
                                NO-ERROR.
        IF AVAILABLE tTblobj THEN vChildWidget:SCREEN-VALUE = tTblObj.ObjOLbl.
      END. /* Else try NEW */
    END.  /* Have a TEXT widget */

    tChar = "":U.
    IF can-query(vChildWidget,"list-items":U) THEN DO:  /* If the widget has a list of items */
      DO tInt2 = 1 TO NUM-ENTRIES(vChildWidget:LIST-ITEMS):  /* Loop through the items */
        {adetran/vt/_prpty.i items tTblObj.ObjOLbl ENTRY(tInt2,vChildWidget:LIST-ITEMS) vChildWidget}
        IF AVAILABLE tTblobj THEN ASSIGN  tChar = tChar +  tTblObj.ObjNLbl + ",":U.
        ELSE DO:  /* Couldn't find the item based on OLD label, now try NEW label */
          {adetran/vt/_prpty.i items tTblObj.ObjNLbl ENTRY(tInt2,vChildWidget:LIST-ITEMS) vChildWidget}
          IF AVAILABLE tTblobj THEN tChar = tChar + tTblObj.ObjOLbl + ",":U.
          ELSE /* Couldn't find it at all, don't translate it */
            tChar = tChar + ENTRY(tInt2,vChildWidget:LIST-ITEMS) + ",":U. 
        END. /* Else try NEW label */
      END.  /* DO 1 to num-items */
      vChildWidget:LIST-ITEMS = SUBSTRING(tChar, 1, LENGTH(tChar) - 1).
      IF vChildWidget:TYPE = "COMBO-BOX":U THEN  /* This seems like a bug, why not do this for SL' too? */
        vChildWidget:SCREEN-VALUE = ENTRY(1,vChildWidget:LIST-ITEMS).
    END.  /* If the widget has a list of items */

    tChar = "":U.
    IF can-query(vChildWidget,"list-item-pairs":U) THEN DO:  /* If the widget has a list of item pairs */
      DO tInt2 = 1 TO NUM-ENTRIES(vChildWidget:LIST-ITEM-PAIRS):  /* Loop through the item pairs */
        {adetran/vt/_prpty.i items tTblObj.ObjOLbl ENTRY(tInt2,vChildWidget:LIST-ITEM-PAIRS) vChildWidget}
        IF AVAILABLE tTblobj THEN ASSIGN  tChar = tChar +  tTblObj.ObjNLbl + ",":U.
        ELSE DO:  /* Couldn't find the item based on OLD label, now try NEW label */
          {adetran/vt/_prpty.i items tTblObj.ObjNLbl ENTRY(tInt2,vChildWidget:LIST-ITEM-PAIRS) vChildWidget}
          IF AVAILABLE tTblobj THEN tChar = tChar + tTblObj.ObjOLbl + ",":U.
          ELSE /* Couldn't find it at all, don't translate it */
            tChar = tChar + ENTRY(tInt2,vChildWidget:LIST-ITEM-PAIRS) + ",":U. 
        END. /* Else try NEW label */
      END.  /* DO 1 to num-items */
      vChildWidget:LIST-ITEM-PAIRS = SUBSTRING(tChar, 1, LENGTH(tChar) - 1).
      IF vChildWidget:TYPE = "COMBO-BOX":U THEN  /* This seems like a bug, why not do this for SL' too? */
        vChildWidget:SCREEN-VALUE = ENTRY(2,vChildWidget:LIST-ITEM-PAIRS).
    END.  /* If the widget has a list of item pairs */
   
    tChar = "":U.
    IF CAN-QUERY(vChildWidget,"RADIO-BUTTONS":U) THEN DO: /* If a radio-set */
      tCharSav = vChildWidget:RADIO-BUTTONS.
      DO tInt2 = 1 TO NUM-ENTRIES(tCharSav):  /* Loop through the labels & values */
        IF tInt2 MOD 2 = 1 THEN DO:
          {adetran/vt/_prpty.i items tTblObj.ObjOLbl ENTRY(tInt2,tCharSav) vChildWidget}
          IF AVAILABLE tTblobj THEN tChar = tChar +  tTblObj.ObjNLbl + ",":U. 
          ELSE DO:  /* Couldn't find the item based on OLD label, now try NEW label */
            {adetran/vt/_prpty.i items tTblObj.ObjNLbl ENTRY(tInt2,vChildWidget:Radio-Buttons) vChildWidget}
            IF AVAILABLE tTblobj THEN tChar = tChar + tTblObj.ObjOLbl + ",":U.
            ELSE /* Couldn't find it at all, don't translate it */
               tChar = tChar + ENTRY(tInt2,vChildWidget:Radio-Buttons) + ",":U.
          END. /* Else try NEW label */  
        END. /* If a button */                  
        ELSE  /* Don't translate the values */
          tChar = tChar + ENTRY(tInt2,tCharSav) + ",":U.
      END.  /* DO 1 to NUM-ITEMS */
      vChildWidget:Radio-Buttons = trim(tChar,",":U).
    END.  /* If a radio-set */

    tChar = "":U.
    IF CAN-QUERY(vChildWidget,"TOOLTIP":U) THEN DO: /* If has tooltip */
       tCharSav = vChildWidget:TOOLTIP.
       {adetran/vt/_prpty.i Tooltip tTblObj.ObjOLbl tCharSav vChildWidget}
       IF AVAILABLE tTblobj THEN tChar = tTblObj.ObjNLbl.
       ELSE DO:  /* Couldn't find the item based on OLD label, now try NEW label */
          {adetran/vt/_prpty.i Tooltip tTblObj.ObjNLbl tCharSav vChildWidget}
          IF AVAILABLE tTblobj THEN tChar = tTblObj.ObjOLbl.
          ELSE /* Couldn't find it at all, don't translate it */
               tChar = vChildWidget:TOOLTIP.
       END. /* Else try NEW label */  
       vChildWidget:TOOLTIP = tChar.
    END.  /* If a tooltip */

    RUN SwitchLbl(vChildWidget,pSTFlg).  /* Push again */
    vChildWidget = vNextSiblIng.
  END.  /* WHILE vChildWidget NE ? */
END PROCEDURE.  /* SwitchLbl */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setActiveTrans PropsWin 
PROCEDURE setActiveTrans :
/*------------------------------------------------------------------------------
  Purpose:     Update the active window (i.e., in the resource procedure) with
               the current translation value.
  Parameters:  <none>
  Notes:       This also switches the tSTFlg field to "Target".
------------------------------------------------------------------------------*/
  DEFINE VARIABLE  nInt     AS INTEGER             NO-UNDO.
  DEFINE VARIABLE  nChar    AS CHARACTER           NO-UNDO.

  DO WITH FRAME DEFAULT-FRAME:
    ASSIGN tSTFlg = FALSE.

    CASE ObjectType:SCREEN-VALUE:
      WHEN "Text":U THEN DO:
        {adetran/vt/_prpty.i Text tTblObj.ObjOLbl vBasePhrase curobj}
        IF AVAILABLE tTblObj THEN
          ASSIGN tTblObj.ObjNLbl = vTranslation:SCREEN-VALUE
                 tTblObj.FoundIN = "INST":U.
        ELSE DO:  /* Create a record */
          CREATE tTblObj.
          ASSIGN tTblObj.ObjWName = PFileName
                 tTblObj.ObjName  = CurObj:NAME
                 tTblObj.ObjType  = "Text":U
                 tTblObj.ObjOLbl  = vBasePhrase
                 tTblObj.ObjNLbl  = vTranslation:SCREEN-VALUE
                 tTblObj.FoundIn  = "INST":U.
        END.  /* Else create an tTblObj Record */
        CurObj:SCREEN-VALUE  = vTranslation:SCREEN-VALUE.
      END.  /* WHEN Text */
      WHEN "Label":U THEN DO:
        IF CurObj:Type = "Browse":U THEN DO:
          {adetran/vt/_prpty.i colabel tTblObj.ObjOLbl vBasePhrase curobj}
          IF AVAILABLE tTblObj THEN
            ASSIGN tTblObj.ObjNLbl = vTranslation:SCREEN-VALUE
                   tTblObj.FoundIN = "INST":U.
          ELSE DO:  /* Create a record */
            CREATE tTblObj.
            ASSIGN tTblObj.ObjWName = PFileName
                   tTblObj.ObjName  = CurObj:name
                   tTblObj.ObjType  = "colabel":U
                   tTblObj.ObjOLbl  = vBasePhrase
                   tTblObj.ObjNLbl  = vTranslation:SCREEN-VALUE
                   tTblObj.FoundIN  = "INST":U.
          END.  /* Else create a record */
          tBrCOlWH = CurObj:FIRST-COLUMN.
          DO WHILE tBrColWH <> ?:
            IF tBrColWH:LABEL = vBasePhrase THEN
              tBrColWH:LABEL = vTranslation:SCREEN-VALUE.
            tBrColWH = tBrCOlWH:NEXT-COLUMN.
          END. /* Do while tBrColWH <> ? */
        END.  /* If a browse */
        ELSE DO:  /* not a browse */
          {adetran/vt/_prpty.i label tTblObj.ObjOLbl vBasePhrase curobj}
          IF AVAILABLE tTblObj THEN
            ASSIGN tTblObj.ObjNLbl = vTranslation:SCREEN-VALUE
                   tTblObj.FoundIN = "INST":U.
          ELSE
          DO:  /* IF we don't have a record, create one */
            CREATE tTblObj.
            ASSIGN tTblObj.ObjWName = PFileName
                   tTblObj.ObjName  = CurObj:name
                   tTblObj.ObjType  = "Label":U
                   tTblObj.ObjOLbl  = vBasePhrase
                   tTblObj.ObjNLbl  = vTranslation:SCREEN-VALUE
                   tTblObj.FoundIN  = "INST":U.
          END. /* Need to create a tTblObj record */

          IF (tDispType = "c":U AND (ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) = "BU":U)) OR
             (tDispType = "c":U AND entry(1,CurObj:Private-data,CHR(4)) = "TB":U) THEN
          DO:  
            ASSIGN tmpChar = IF ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) = "TB":U
                             THEN ENTRY(3,CurObj:PRIVATE-DATA,CHR(4)) ELSE "":U
                   tChar   = vTranslation:SCREEN-VALUE.
            RUN DispCBtn(ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)),
                         INPUT CurObj:WIDTH-CHAR,
                         INPUT tmpChar,
                         INPUT-OUTPUT tChar).
            ASSIGN CurObj:SCREEN-VALUE = tChar
                   CurObj:PRIVATE-DATA =
                   (if ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) = "TB":U THEN
                       ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) + CHR(4) + tTblObj.ObjNLbl +
                          CHR(4) + ENTRY(3,CurObj:PRIVATE-DATA,CHR(4))
                    ELSE ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) + CHR(4) + tTblObj.ObjNLbl).
          END. /* If char mode button or toggle box */
          ELSE DO:
            tParent = curobj:PARENT.
            IF NOT AVAILABLE tTblObj AND tParent:TYPE = "BROWSE":U THEN DO:
              /* We have a browse column */
              FIND tTblObj WHERE tTblObj.ObjWName = CurWin:Title
                             AND tTblObj.ObjName  = CurObj:NAME
                             AND tTblObj.ObjType  = "colabel":U 
                NO-ERROR.
            END.  /* If a browse column */
            IF AVAILABLE tTblObj THEN
              ASSIGN tTblObj.ObjNLbl = vTranslation:SCREEN-VALUE
                     tTblObj.FoundIN = "INST":U.
            ELSE
            DO:  /* IF we don't have a record, create one */
              CREATE tTblObj.
              ASSIGN tTblObj.ObjWName = PFileName
                     tTblObj.ObjName  = CurObj:name
                     tTblObj.ObjType  = "Label":U
                     tTblObj.ObjOLbl  = vBasePhrase
                     tTblObj.ObjNLbl  = vTranslation:SCREEN-VALUE
                     tTblObj.FoundIN  = "INST":U.
            END. /* Need to create a tTblObj record */

            ASSIGN CurObj:LABEL = vTranslation:SCREEN-VALUE.
          END.  /* Else must be gui and not a browse, button or toggle box */
        END. /* ELSE not a browse */
      END.  /* When a label */
      WHEN "Private-Data":U THEN CurObj:PRIVATE-DATA  = vTranslation:SCREEN-VALUE.
      WHEN "Help":U         THEN CurObj:HELP          = vTranslation:SCREEN-VALUE.
      WHEN "Format":U       THEN CurObj:FORMAT        = vTranslation:SCREEN-VALUE.
      WHEN "Tooltip":U      THEN DO: 
         {adetran/vt/_prpty.i Tooltip tTblObj.ObjOLbl vBasePhrase curobj}
         IF AVAILABLE tTblObj THEN
           ASSIGN tTblObj.ObjNLbl = vTranslation:SCREEN-VALUE
                  tTblObj.FoundIN = "INST":U.
           ELSE DO:
             CREATE tTblObj.
             ASSIGN tTblObj.ObjWName = PFileName
                    tTblObj.ObjName  = CurObj:NAME
                    tTblObj.ObjType  = "Tooltip":U
                    tTblObj.ObjOLbl  = vBasePhrase
                    tTblObj.ObjNLbl  = vTranslation:SCREEN-VALUE
                    tTblObj.FoundIN  = "INST":U.
           END.
           CurObj:TOOLTIP = vTranslation:SCREEN-VALUE.
      END.
      WHEN "Title":U        THEN DO:
         {adetran/vt/_prpty.i Title tTblObj.ObjOLbl vBasePhrase curobj}
         IF AVAILABLE tTblObj THEN
           ASSIGN tTblObj.ObjNLbl = vTranslation:SCREEN-VALUE
                  tTblObj.FoundIN = "INST":U.
           ELSE DO:
             CREATE tTblObj.
             ASSIGN tTblObj.ObjWName = PFileName
                    tTblObj.ObjName  = CurObj:NAME
                    tTblObj.ObjType  = "Title":U
                    tTblObj.ObjOLbl  = vBasePhrase
                    tTblObj.ObjNLbl  = vTranslation:SCREEN-VALUE
                    tTblObj.FoundIN  = "INST":U.
           END.
           CurObj:TITLE = vTranslation:SCREEN-VALUE.
        END.
      WHEN "Radio-Buttons":U THEN DO:
        tCharSav = Curobj:Radio-Buttons.
        {adetran/vt/_prpty.i items tTblObj.ObjOLbl vBasePhrase curobj}
        IF AVAILABLE tTblObj THEN
          ASSIGN tTblObj.ObjNLbl = vTranslation:SCREEN-VALUE
                 tTblObj.FoundIN = "INST":U.
        ELSE DO:
          CREATE tTblObj.
          ASSIGN tTblObj.ObjWName = PFileName
                 tTblObj.ObjName  = CurObj:NAME
                 tTblObj.ObjType  = "items":U
                 tTblObj.ObjOLbl  = vBasePhrase
                 tTblObj.ObjNLbl  = vTranslation:SCREEN-VALUE
                 tTblObj.FoundIN  = "INST":U.
        END.
        tInt2 = LOOKUP(vBasePhrase,vBasePhrase:list-items,CHR(4)).
        if tInt2 > 0 THEN
          ASSIGN tInt = (tInt2 * 2) - 1  /* This is too weird for me - BUG? */
                 tCharSav = Replace(tCharSav,ENTRY(tInt,tCharSav),vTranslation:SCREEN-VALUE)
                 CurObj:Radio-Buttons = tCharSav.
      END.
      WHEN "List-Items":U THEN DO:
        IF tDispType = "c":U and ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) = "CB":U THEN
          ASSIGN tCharSav = ENTRY(2,CurObj:PRIVATE-DATA,CHR(4)).
        ELSE tCharSav = CurObj:List-Items.
        {adetran/vt/_prpty.i items tTblObj.ObjOLbl vBasePhrase curobj}
        IF AVAILABLE tTblObj THEN
          ASSIGN tTblObj.ObjNLbl = vTranslation:SCREEN-VALUE
                 tTblObj.FoundIN = "INST":U.  
        ELSE DO:
          CREATE tTblObj.
          assign tTblObj.ObjWName = PFileName
                 tTblObj.ObjName  = CurObj:Name
                 tTblObj.ObjType  = "items":U
                 tTblObj.ObjOLbl  = vBasePhrase
                 tTblObj.ObjNLbl  = vTranslation:SCREEN-VALUE
                 tTblObj.FoundIN  = "INST":U.
        end.
        assign tInt2 = lookup(vBasePhrase,vBasePhrase:list-items, CHR(4))
               nChar = "":U.
        if tInt2 > 0 THEN DO:
          do nInt = 1 to NUM-ENTRIES(tCharSav):
            nChar = nChar + (IF nInt = tInt2 THEN vTranslation:SCREEN-VALUE
                                             ELSE ENTRY(nInt,tCharsav)) + ",":U.
          end.
          assign nChar = SUBSTRING(nChar, 1, LENGTH(nChar) - 1).
          if tDispType = "c":U THEN DO:
            CurObj:PRIVATE-DATA = ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) + CHR(4) + nChar.
            if ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) = "SE":U THEN CurObj:list-items = nChar.
          end.
          ELSE CurObj:List-Items = nChar.
        end. /* If tInt2 > 0 */
      end.  /* WHEN List-Items */
      WHEN "List-Item-Pairs":U THEN DO:
        IF tDispType = "c":U and ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) = "CB":U THEN
          ASSIGN tCharSav = ENTRY(2,CurObj:PRIVATE-DATA,CHR(4)).
        ELSE tCharSav = CurObj:LIST-ITEM-PAIRS.
        {adetran/vt/_prpty.i items tTblObj.ObjOLbl vBasePhrase curobj}
        IF AVAILABLE tTblObj THEN
          ASSIGN tTblObj.ObjNLbl = vTranslation:SCREEN-VALUE
                 tTblObj.FoundIN = "INST":U.  
        ELSE DO:
          CREATE tTblObj.
          assign tTblObj.ObjWName = PFileName
                 tTblObj.ObjName  = CurObj:Name
                 tTblObj.ObjType  = "items":U
                 tTblObj.ObjOLbl  = vBasePhrase
                 tTblObj.ObjNLbl  = vTranslation:SCREEN-VALUE
                 tTblObj.FoundIN  = "INST":U.
        end.
        assign tInt2 = lookup(vBasePhrase,vBasePhrase:list-items, CHR(4))
               nChar = "":U.
        if tInt2 > 0 THEN DO:
          do nInt = 1 to NUM-ENTRIES(tCharSav):
            nChar = nChar + (IF nInt = tInt2 THEN vTranslation:SCREEN-VALUE
                                             ELSE ENTRY(nInt,tCharsav)) + ",":U.
          end.
          assign nChar = SUBSTRING(nChar, 1, LENGTH(nChar) - 1).
          if tDispType = "c":U THEN DO:
            CurObj:PRIVATE-DATA = ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) + CHR(4) + nChar.
            if ENTRY(1,CurObj:PRIVATE-DATA,CHR(4)) = "SE":U THEN CurObj:LIST-ITEM-PAIRS = nChar.
          end.
          ELSE CurObj:LIST-ITEM-PAIRS = nChar.
        end. /* If tInt2 > 0 */
      end.  /* WHEN List-Item-Pairs */
    end case.  /* On ObjectType:SCREEN-VALUE */
  END.  /* DO WITH FRAME DEFAULT-FRAME */
END PROCEDURE.  /* updateTrans */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME FindWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS FindWindow 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_find.w
Author:       SLK
Created:      7/98 
Copied:       from adetran/vt/_find.w
Purpose:      Translation Manager's FIND translation program
Background:   This .w is RUN persistent as a HIDDEN window.  When
              invoked via the pm/_pmmain.p's menu or FIND button, the
              HIDDEN property is changed to FALSE AND it is exposed.
              The 'Close' button just rehides the windows.
Notes:        The FIND program is only enabled when 'CurrentMode'
              is equal to 2 or 3 (Translation or Glossary tab).
              When CurrentMode=2 THEN it FINDs translation data
              AND when 3, it FINDs glossary data.  In both cases, it
              positions the users on the found row (IF available).  

              Created procedures 
                 findtsrc.i   FIND [CURRENT,FIRST,LAST] source
                 findtsn.i    FIND NEXT source
                 findtsp.i    FIND PREV source
                 findttrg.i   FIND [CURRENT,FIRST,LAST,NEXT,PREV] target
                 replace.i  
              since we exceeded action segment
Includes:     pm/findtsrc.i pm/findtsp.i pm/findtsn.i 
              pm/findttrg.i pm/_replace.i
*/ 


{ adetran/pm/tranhelp.i } /* definitions for help context strings */
DEFINE SHARED VARIABLE _hReplace         AS HANDLE                NO-UNDO. 
DEFINE SHARED VARIABLE _MainWindow       AS WIDGET-HANDLE         NO-UNDO.  
DEFINE SHARED VARIABLE CurrentMode       AS INTEGER               NO-UNDO.  
DEFINE SHARED VARIABLE _hGloss           AS HANDLE                NO-UNDO.
DEFINE SHARED VARIABLE _hTrans           AS HANDLE                NO-UNDO.
DEFINE SHARED VARIABLE stringROWID       AS ROWID                 NO-UNDO.
DEFINE SHARED VARIABLE instanceROWID     AS ROWID                 NO-UNDO.
DEFINE SHARED VARIABLE translationROWID  AS ROWID                 NO-UNDO.
DEFINE SHARED VARIABLE glossDetROWID     AS ROWID                 NO-UNDO.
DEFINE SHARED VARIABLE _Lang             AS CHARACTER             NO-UNDO.
DEFINE SHARED VARIABLE s_Glossary        AS CHARACTER             NO-UNDO.

DEFINE VARIABLE ThisMessage              AS CHARACTER             NO-UNDO.
DEFINE VARIABLE ErrorStatus              AS LOGICAL               NO-UNDO.
DEFINE VARIABLE tVal                     AS CHARACTER FORMAT "X(90)":U 
                                         CASE-SENSITIVE        NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS FindValue BtnNext BtnPrev IgnoreSpaces ~
BtnClose PhraseType MatchCase BtnReplace UseWildCards BtnHelp PhraseLabel ~
OptionsLabel IMAGE-1 RECT-1 RECT-2 
&Scoped-Define DISPLAYED-OBJECTS FindValue IgnoreSpaces PhraseType ~
MatchCase UseWildCards PhraseLabel OptionsLabel 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR FindWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnClose 
     LABEL "&Close":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnNext 
     LABEL "&Next":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnPrev 
     LABEL "&Previous":L 
     SIZE 15 BY 1.14.

DEFINE BUTTON BtnReplace 
     LABEL "&Replace...":L 
     SIZE 15 BY 1.14.

DEFINE VARIABLE FindValue AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Find What" 
     VIEW-AS FILL-IN 
     SIZE 39 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE OptionsLabel AS CHARACTER FORMAT "X(256)":U INITIAL " Options" 
      VIEW-AS TEXT 
     SIZE 8.2 BY .67 NO-UNDO.

DEFINE VARIABLE PhraseLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Find" 
      VIEW-AS TEXT 
     SIZE 6.8 BY .67 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "adetran/images/FIND":U
     SIZE 3.2 BY .67.

DEFINE VARIABLE PhraseType AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Source", "S":U,
"&Target", "T":U
     SIZE 15 BY 2.29 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18.2 BY 4.38.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.4 BY 4.48.

DEFINE VARIABLE IgnoreSpaces AS LOGICAL INITIAL no 
     LABEL "&Ignore Leading Spaces":L 
     VIEW-AS TOGGLE-BOX
     SIZE 26.4 BY .67 NO-UNDO.

DEFINE VARIABLE MatchCase AS LOGICAL INITIAL no 
     LABEL "Cas&e Sensitive":L 
     VIEW-AS TOGGLE-BOX
     SIZE 25.4 BY .67 NO-UNDO.

DEFINE VARIABLE UseWildCards AS LOGICAL INITIAL yes 
     LABEL "&Use Wildcards":L 
     VIEW-AS TOGGLE-BOX
     SIZE 26.4 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     FindValue AT ROW 1.52 COL 13 COLON-ALIGNED
     BtnNext AT ROW 1.57 COL 55
     BtnPrev AT ROW 2.76 COL 55
     IgnoreSpaces AT ROW 3.95 COL 27
     BtnClose AT ROW 4 COL 55
     PhraseType AT ROW 4.05 COL 8 NO-LABEL
     MatchCase AT ROW 4.71 COL 27
     BtnReplace AT ROW 5.24 COL 55
     UseWildCards AT ROW 5.52 COL 27
     BtnHelp AT ROW 6.48 COL 55
     PhraseLabel AT ROW 2.86 COL 8.2 NO-LABEL
     OptionsLabel AT ROW 2.86 COL 24.8 COLON-ALIGNED NO-LABEL
     IMAGE-1 AT ROW 1 COL 1
     RECT-1 AT ROW 3.1 COL 6.8
     RECT-2 AT ROW 3.1 COL 25.6
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.4 BY 6.81
         BGCOLOR 8 FONT 4
         DEFAULT-BUTTON BtnNext.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW FindWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Find"
         HEIGHT             = 7.05
         WIDTH              = 72
         MAX-HEIGHT         = 7.05
         MAX-WIDTH          = 77.2
         VIRTUAL-HEIGHT     = 7.05
         VIRTUAL-WIDTH      = 77.2
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

&IF '{&WINDOW-SYSTEM}' NE 'TTY' &THEN
IF NOT FindWindow:LOAD-ICON("adetran/images/props%":U) THEN
    MESSAGE "Unable to load icon: adetran/images/props%"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW FindWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
   L-To-R                                                               */
/* SETTINGS FOR FILL-IN PhraseLabel IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(FindWindow)
THEN FindWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME FindWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FindWindow FindWindow
ON END-ERROR OF FindWindow /* Find */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently RUN window being used AS a modeless dialog box,
     respond by closing the window. */
  APPLY "WINDOW-CLOSE":U TO {&WINDOW-NAME}.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FindWindow FindWindow
ON WINDOW-CLOSE OF FindWindow /* Find */
DO:
  FindWindow:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnClose FindWindow
ON CHOOSE OF BtnClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  FindWindow:HIDDEN = TRUE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp FindWindow
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  RUN adecomm/_adehelp.p ("tran":u,"context":U,{&Find_DlgBx}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnNext FindWindow
ON CHOOSE OF BtnNext IN FRAME DEFAULT-FRAME /* Next */
DO:

  RUN refresh.ip.
  /* Split - action segment limit */
  IF CurrentMode = 3 THEN RUN FindNextGloss.ip.
  ELSE                    RUN FindNextTran.ip.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnPrev FindWindow
ON CHOOSE OF BtnPrev IN FRAME DEFAULT-FRAME /* Previous */
DO:
   RUN refresh.ip.
   IF CurrentMode = 3 THEN RUN FindPrevGloss.ip.
   ELSE                    RUN FindPrevTran.ip.
END.  /* Trigger */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnReplace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnReplace FindWindow
ON CHOOSE OF BtnReplace IN FRAME DEFAULT-FRAME /* Replace... */
DO: 
   RUN refresh.ip.
   CASE CurrentMode:
   WHEN 2 THEN
   DO: 
     IF     AVAILABLE xlatedb.XL_string_info 
        AND AVAILABLE xlatedb.XL_Instance 
        AND AVAILABLE xlatedb.XL_translation THEN                             
        RUN Realize IN _hReplace (xlatedb.XL_string_info.original_string,xlatedb.XL_translation.trans_String).  
     ELSE 
        RUN Realize IN _hReplace ("","").      
   END.
   WHEN 3 THEN
   DO:             
      IF AVAILABLE xlatedb.XL_GlossDet THEN
        RUN Realize IN _hReplace (xlatedb.XL_GlossDet.SourcePhrase,xlatedb.XL_GlossDet.TargetPhrase).  
      ELSE
        RUN Realize IN _hReplace ("","").     
   END.                                    
   OTHERWISE
   DO:      
     RUN Realize IN _hReplace ("","").   
   END.
   END CASE.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FindValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FindValue FindWindow
ON LEAVE OF FindValue IN FRAME DEFAULT-FRAME /* Find What */
DO:
  IF FindValue:screen-value <> "" THEN BtnReplace:sensitive = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK FindWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes AND FRAMEs.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface AND wait for the exit condition.            */
/* (NOTE: HANDLE ERROR AND END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
   ASSIGN
     PhraseLabel:screen-value  = "Find"
     OptionsLabel:screen-value = "Options"
     PhraseLabel:width         = font-table:get-text-width-chars(PhraseLabel:screen-value,4)
     OptionsLabel:width        = font-table:get-text-width-chars(OptionsLabel:screen-value,4)
     FindWindow:parent         = _MainWindow:handle
     UseWildCards:CHECKED      = TRUE.

  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextGloss.ip FindWindow 
PROCEDURE FindNextGloss.ip :
DO WITH FRAME DEFAULT-FRAME:

  ASSIGN FindValue
         tVal = FindValue.
      CASE PhraseType:SCREEN-VALUE:
        WHEN "S":u THEN DO:
          {adetran/pm/_replace.i xlatedb.xl_glossDet SourcePhrase NEXT}
        END.
        WHEN "T":u THEN DO:
          {adetran/pm/_replace.i xlatedb.xl_glossDet TargetPhrase NEXT}
        END. /* Target */
      END CASE.  /* PhraseType:SCREEN-VALUE */

      IF AVAILABLE xlatedb.XL_GlossDet THEN DO:
        RUN Repo IN _hGloss (INPUT ROWID(xlatedb.XL_GlossDet),INPUT 0).
        glossDetROWID = ROWID(xlatedb.XL_GlossDet).
      END.  /* IF available xlatedb.XL_GlossDet */
      ELSE DO: /* Not available xlatedb.XL_GlossDet */
        ThisMessage = "Search Item Was Not Found.".
        RUN adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).    
        FIND xlatedb.XL_GlossDet WHERE ROWID(xlatedb.XL_GlossDet) = glossDetROWID 
             no-lock NO-ERROR.
      END.  /* Else Not available xlatedb.XL_GlossDet */
  END.  /* DO with frame default-frame */
END PROCEDURE.  /* FindNextGloss */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextTran.ip FindWindow 
PROCEDURE FindNextTran.ip :
DO WITH FRAME DEFAULT-FRAME:

  ASSIGN FindValue
         tVal = FindValue.
      CASE PhraseType:SCREEN-VALUE:
        WHEN "S":u THEN 
        DO:
          {adetran/pm/findtsn.i SourcePhrase NEXT}
        END.
        WHEN "T":u THEN 
        DO:
          {adetran/pm/findttrg.i TargetPhrase NEXT}
        END. /* Target */
      END CASE.  /* PhraseType:SCREEN-VALUE */

      IF     AVAILABLE xlatedb.XL_string_info 
         AND AVAILABLE xlatedb.XL_Instance 
         AND (    (PhraseType:SCREEN-VALUE = "T":U 
              AND AVAILABLE xlatedb.XL_Translation) OR
              (PhraseType:SCREEN-VALUE = "S":U)) THEN 
      DO:
        ASSIGN
           stringROWID      = ROWID(xlatedb.XL_string_info)
           instanceROWID    = ROWID(xlatedb.XL_Instance)
           translationROWID = IF AVAILABLE xlatedb.XL_translation THEN
                                 ROWID(xlatedb.XL_translation)
                              ELSE
                                 ?.
        RUN Repo IN _hTrans (INPUT stringROWID,
                             INPUT instanceROWID,
                             INPUT translationROWID,
                             ?).
      END.  /* If available xlatedb.xl_string_info AND xlatedb.XL_Instance */
      ELSE DO:  /* Not available xl_string_info AND xl_instance */
        ThisMessage = "Search Item Was Not Found.". 
        RUN adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).          
        FIND xlatedb.XL_string_info WHERE 
           ROWID(xlatedb.XL_string_info) = stringROWID NO-LOCK NO-ERROR.
        FIND xlatedb.XL_instance WHERE 
           ROWID(xlatedb.XL_instance) = instanceROWID NO-LOCK NO-ERROR.
        FIND xlatedb.XL_translation WHERE 
           ROWID(xlatedb.XL_translation) = translationROWID NO-LOCK NO-ERROR.

        IF NOT AVAILABLE xlatedb.XL_string_info OR
           NOT AVAILABLE xlatedb.XL_instance THEN DO:
          IF PhraseType:SCREEN-VALUE = "S":U THEN 
          DO:
            /* action segment limit */
            RUN FindNextTranSource.ip.
          END.
          ELSE DO:
            /* action segment limit */
            RUN FindNextTranTarget.ip.
          END.
        END.
      END. /* Else not available */
  END.  /* DO with frame default-frame */
END PROCEDURE.  /* FindNextTran */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextTranSource.ip FindWindow 
PROCEDURE FindNextTranSource.ip :
DO WITH FRAME DEFAULT-FRAME:
   {adetran/pm/findtsrc.i SourcePhrase FIRST}
   {adetran/pm/findtsp.i SourcePhrase PREV}
  END. /* Do with FRAME DEFAULT-FRAME */
END PROCEDURE. /* FindNextTranSource.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindNextTranTarget.ip FindWindow 
PROCEDURE FindNextTranTarget.ip :
DO WITH FRAME DEFAULT-FRAME:
     {adetran/pm/findttrg.i TargetPhrase FIRST}
     {adetran/pm/findttrg.i TargetPhrase PREV}          
  END. /* Do with FRAME DEFAULT-FRAME */
END PROCEDURE. /* FindNextTranTarget.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevGloss.ip FindWindow 
PROCEDURE FindPrevGloss.ip :
DO WITH FRAME DEFAULT-FRAME:

  ASSIGN FindValue
         tVal = FindValue.
      CASE PhraseType:SCREEN-VALUE:
        WHEN "S":u THEN DO:
          {adetran/pm/_replace.i xlatedb.xl_glossDet SourcePhrase PREV}
        END.
        WHEN "T":u THEN DO:
          {adetran/pm/_replace.i xlatedb.xl_glossDet TargetPhrase PREV}
        END.
      END CASE.                                                      
     
      IF AVAILABLE xlatedb.XL_GlossDet THEN DO:
        RUN Repo IN _hGloss (INPUT ROWID(xlatedb.XL_GlossDet),INPUT 0).
        glossDetROWID = ROWID(xlatedb.XL_GlossDet).
      END.
      ELSE DO:
        ThisMessage = "Search Item Was Not Found.". 
        RUN adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).    
        FIND xlatedb.XL_GlossDet WHERE ROWID(xlatedb.XL_GlossDet) = glossDetROWID 
             no-lock NO-ERROR.
      END.  /* Else not available */
  END. /* Do with FRAME DEFAULT-FRAME */
END PROCEDURE. /* FindPrevGloss.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevTran.ip FindWindow 
PROCEDURE FindPrevTran.ip :
DO WITH FRAME DEFAULT-FRAME:
  ASSIGN FindValue
         tVal = FindValue.
      CASE PhraseType:SCREEN-VALUE:
        WHEN "S":U THEN DO:
          {adetran/pm/findtsp.i SourcePhrase PREV}
        END.
        WHEN "T":u THEN DO:
          {adetran/pm/findttrg.i TargetPhrase PREV}
        END. /* target */
      END CASE.

      IF     AVAILABLE xlatedb.XL_String_Info 
         AND AVAILABLE xlatedb.XL_instance 
         AND ((PhraseType:SCREEN-VALUE = "T":U
               AND AVAILABLE xlatedb.XL_Translation) OR 
               (PhraseType:SCREEN-VALUE = "S":U)) THEN 
      DO:
        ASSIGN
           stringROWID = ROWID(xlatedb.XL_string_info)
           instanceROWID = ROWID(xlatedb.XL_Instance)
           translationROWID = IF AVAILABLE xlatedb.XL_translation THEN
                                 ROWID(xlatedb.XL_translation)
                              ELSE
                                 ?.
        RUN Repo IN _hTrans (INPUT stringROWID,
                            INPUT instanceROWID,
                            INPUT translationROWID,
                            INPUT ?).
      END. /* Item found */
      ELSE DO:
        ThisMessage = "Search Item Was Not Found.".
        RUN adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).
        FIND xlatedb.XL_string_info WHERE 
           ROWID(xlatedb.XL_string_info) = stringROWID NO-LOCK NO-ERROR.
        FIND xlatedb.XL_instance WHERE 
           ROWID(xlatedb.XL_instance) = instanceROWID NO-LOCK NO-ERROR.
        FIND xlatedb.XL_translation WHERE 
           ROWID(xlatedb.XL_translation) = translationROWID NO-LOCK NO-ERROR.
        IF NOT AVAILABLE xlatedb.XL_string_info OR
           NOT AVAILABLE xlatedb.XL_instance THEN
        DO:
          IF PhraseType:SCREEN-VALUE = "S":U THEN DO:
            /* action segment limit */
            RUN FindPrevTranSource.ip.
          END.
          ELSE DO:
            /* action segment limit */
            RUN FindPrevTranTarget.ip.
          END.
        END.
      END.
  END. /* Do with FRAME DEFAULT-FRAME */
END PROCEDURE. /* FindPrevTran.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevTranSource.ip FindWindow 
PROCEDURE FindPrevTranSource.ip :
DO WITH FRAME DEFAULT-FRAME:
   {adetran/pm/findtsrc.i SourcePhrase LAST}
   {adetran/pm/findtsn.i SourcePhrase NEXT}
  END. /* Do with FRAME DEFAULT-FRAME */
END PROCEDURE. /* FindPrevTranSource.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FindPrevTranTarget.ip FindWindow 
PROCEDURE FindPrevTranTarget.ip :
DO WITH FRAME DEFAULT-FRAME:
     {adetran/pm/findttrg.i TargetPhrase LAST}
     {adetran/pm/findttrg.i TargetPhrase NEXT}          
  END. /* Do with FRAME DEFAULT-FRAME */
END PROCEDURE. /* FindPrevTranTarget.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FndRec FindWindow 
PROCEDURE FndRec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe FindWindow 
PROCEDURE HideMe :
{&WINDOW-NAME}:HIDDEN = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize FindWindow 
PROCEDURE Realize :
FindWindow:HIDDEN = TRUE.
  ENABLE
    FindValue
    PhraseType
    IgnoreSpaces
    MatchCase
    UseWildCards
    BtnNext 
    BtnPrev
    BtnClose
    BtnHelp     
  WITH FRAME {&FRAME-name} IN WINDOW FindWindow.
  
  ASSIGN
    FindValue:AUTO-ZAP     = TRUE
    FindWindow:HIDDEN      = FALSE.

  RUN refresh.ip.
  APPLY "ENTRY":U TO FindValue IN FRAME {&FRAME-name}. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh.ip FindWindow 
PROCEDURE refresh.ip :
DO: 
     IF CurrentMode = 2 THEN
     DO:
        IF stringROWID <> ? THEN
           FIND xlatedb.xl_string_info WHERE 
              stringROWID = ROWID(xlatedb.xl_string_info) NO-LOCK NO-ERROR. 
        IF instanceROWID <> ? THEN
           FIND xlatedb.xl_instance WHERE 
              instanceROWID = ROWID(xlatedb.xl_instance) NO-LOCK NO-ERROR. 
        IF translationROWID <> ? THEN
           FIND xlatedb.xl_translation WHERE 
              translationROWID = ROWID(xlatedb.xl_translation) NO-LOCK NO-ERROR. 
     END.
     ELSE IF CurrentMode = 3 AND glossDetROWID <> ? THEN
        FIND xlatedb.XL_GlossDet WHERE 
           glossDetROWID = ROWID(xlatedb.XL_GlossDet) NO-LOCK NO-ERROR.       
  END.
END PROCEDURE. /* Refresh.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetColSearch FindWindow 
PROCEDURE SetColSearch :
  /* Sets the FIND dialog so it can perform spcial column searching for
     source phrase and target phrase. See _trans.p START-SEARCH event
     handling. -jep 04/23/1999. */
  DEFINE INPUT PARAMETER pType  AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER pValue AS CHARACTER NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN PhraseType:SCREEN-VALUE = pType
           UseWildCards:CHECKED    = TRUE.
  
    /* UseWildCards uses MATCHES. So if pValue is one of the MATCHES
       wildcards (* or .), then prepend tilde so the MATCHES looks for the
       literal * or period. Otherwise, append asterisk (*) so MATCHES searches
       for strings that begin with pValue. */
  
    IF pValue = "*":u OR pValue = ".":U THEN
      FindValue:SCREEN-VALUE = "~~":u + pValue.
    ELSE
      FindValue:SCREEN-VALUE = pValue + "*":u.
  END.

END PROCEDURE. /* SetColSearch */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

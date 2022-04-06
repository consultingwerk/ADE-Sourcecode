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

Procedure:    adetran/vt/_find.w
Author:       F. Chang
Created:      1/95 
Updated:      9/95
Purpose:      Visual Translator's find program
Background:   This .w is run persistent as a hidden window.  When
              invoked via the vt/_main.p's menu or find button, the
              hidden property is changed to false and it is exposed.
              The 'Close' button just rehides the windows.
Notes:        The find program is only enabled when 'CurrentMode'
              is equal to 2 or 3 (Translation or glossary tab).
              When CurrentMode=2 then it finds translation data
              and when 3, it finds glossary data.  In both cases, it
              positions the users on the found row (if available).  
Includes:     vt/_find.i
*/ 


{ adetran/vt/vthlp.i } /* definitions for help context strings */ 
define shared var hReplace as handle no-undo.                       

/* fhc */
define shared var MainWindow as widget-handle no-undo.  
DEFINE SHARED VAR CurrentMode as integer no-undo.  
define SHARED VAR hGloss as handle no-undo.
define SHARED VAR hTrans as handle no-undo.
define shared variable tInstRec as recid no-undo. 
define shared variable tGlssRec as recid no-undo.

define variable ThisMessage as char no-undo.
define variable ErrorStatus as logical no-undo.
DEFINE VARIABLE tValCS          AS CHAR FORMAT "X(60)":U CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE FindValueBegins AS CHAR FORMAT "X(60)":U NO-UNDO.
DEFINE VARIABLE tValBeginsCS    AS CHAR FORMAT "X(60)":U CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE iWildLoc        AS INT  NO-UNDO.


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 FindValue BtnNext BtnPrev ~
PhraseLabel OptionsLabel RECT-1 RECT-2 IgnoreSpaces BtnClose PhraseType ~
MatchCase BtnReplace UseWildCards BtnHelp 
&Scoped-Define DISPLAYED-OBJECTS FindValue PhraseLabel OptionsLabel ~
IgnoreSpaces PhraseType MatchCase UseWildCards 

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
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnNext 
     LABEL "&Next":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnPrev 
     LABEL "&Previous":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnReplace 
     LABEL "&Replace...":L 
     SIZE 15 BY 1.125.

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
     FILENAME "adetran/images/find":U
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
     PhraseLabel AT ROW 2.86 COL 8.2 NO-LABEL
     OptionsLabel AT ROW 2.86 COL 24.8 COLON-ALIGNED NO-LABEL
     IgnoreSpaces AT ROW 3.95 COL 27
     BtnClose AT ROW 4 COL 55
     PhraseType AT ROW 4.05 COL 8 NO-LABEL
     MatchCase AT ROW 4.71 COL 27
     BtnReplace AT ROW 5.24 COL 55
     UseWildCards AT ROW 5.52 COL 27
     BtnHelp AT ROW 6.48 COL 55
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
   Other Settings: COMPILE
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

IF NOT FindWindow:LOAD-ICON("adetran/images/props%":U) THEN
    MESSAGE "Unable to load icon: adetran/images/props%"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

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
     In a persistently run window being used as a modeless dialog box,
     respond by closing the window. */
  APPLY "WINDOW-CLOSE":U TO {&WINDOW-NAME}.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FindWindow FindWindow
ON WINDOW-CLOSE OF FindWindow /* Find */
DO:
  FindWindow:hidden = true.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnClose FindWindow
ON CHOOSE OF BtnClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  FindWindow:hidden = true.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp FindWindow
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  run adecomm/_adehelp.p ("vt":u,"context":U,{&VT_Find_Dialog_Box}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnNext FindWindow
ON CHOOSE OF BtnNext IN FRAME DEFAULT-FRAME /* Next */
DO:
  ASSIGN
    FindValue                          /* Straight value */
    tValCS          = FindValue        /* Case-sensitive straight value */
                                       /* Truncated value */
    FindValueBegins = IF LENGTH(FindValue, "CHARACTER":U) > 50 THEN
                        SUBSTRING(FindValue, 1, 50, "CHARACTER":U)
                      ELSE
                        FindValue
    iWildLoc        = IF (INDEX(FindValueBegins, "*":U) = 0 AND
                          INDEX(FindValueBegins, ".":U) = 0) THEN
                        0
                      ELSE IF (INDEX(FindValueBegins, "*":U) = 0 OR
                               INDEX(FindValueBegins, ".":U) = 0) THEN
                        MAXIMUM(INDEX(FindValueBegins, "*":U), INDEX(FindValueBegins, ".":U))
                      ELSE
                        MINIMUM(INDEX(FindValueBegins, "*":U), INDEX(FindValueBegins, ".":U))
    FindValueBegins = SUBSTR(FindValueBegins, 1, iWildLoc - 1, "CHARACTER":U)
    tValBeginsCS    = FindValueBegins  /* Case-sensitive truncated value */
    .
  CASE CurrentMode:
    WHEN 2 THEN DO: /* Translation */
      CASE PhraseType:SCREEN-VALUE:
        WHEN "S":u THEN
          RUN nextInstanceSource. 
        WHEN "T":u THEN
          RUN nextInstanceTarget.
      END CASE.  /* PhraseType:SCREEN-VALUE */

      /* Ask if they want to start at the top again */
      IF NOT AVAILABLE kit.XL_Instance THEN
      DO:
        ThisMessage = "Search Item Was Not Found. Start search from first record?". 
        run adecomm/_s-alert.p (input-output ErrorStatus, "q*":u, "yes-no":u, ThisMessage).          
        IF ErrorStatus THEN
        DO:
           CASE PhraseType:SCREEN-VALUE:
             WHEN "S":u THEN
                RUN firstInstanceSource.
             WHEN "T":u THEN
                RUN firstInstanceTarget.
          END CASE.
        END.
      END.

      IF AVAILABLE kit.XL_Instance THEN DO:
        RUN Repo in hTrans (INPUT RECID(kit.XL_Instance),INPUT 0).
        tInstRec = RECID(kit.XL_Instance).
      END.  /* If available kit.XL_Instance */
      ELSE DO:  /* Not available kit instnace */
        ThisMessage = "Search Item Was Not Found.". 
        run adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).          
        FIND kit.XL_Instance WHERE RECID(kit.XL_Instance) = tInstRec 
             no-lock NO-ERROR.
        IF NOT AVAILABLE kit.XL_Instance THEN DO:
          IF PhraseType:SCREEN-VALUE = "S":U THEN DO:
            RUN firstInstanceSource.
            RUN prevInstanceSource.
          END.
          ELSE DO:
            RUN firstInstanceTarget.
            RUN prevInstanceTarget.
          END.
        END.
      END. /* Else not available */
    END.  /* Translation case */

    WHEN 3 THEN DO: /* Glossary */
      CASE PhraseType:SCREEN-VALUE:
        WHEN "S":u THEN
          RUN nextGlossSource.
        WHEN "T":u THEN
          RUN nextGlossTarget.
      END CASE.  /* PhraseType:SCREEN-VALUE */

      /* Ask if they want to start at the top again */
      IF NOT AVAILABLE kit.XL_GlossEntry THEN
      DO:
        ThisMessage = "Search Item Was Not Found. Start search from first record?". 
        run adecomm/_s-alert.p (input-output ErrorStatus, "q*":u, "yes-no":u, ThisMessage).          
        IF ErrorStatus THEN
        DO:
           CASE PhraseType:SCREEN-VALUE:
             WHEN "S":u THEN
                RUN firstGlossSource.
             WHEN "T":u THEN
                RUN firstGlossTarget.
          END CASE.
        END.
      END.

      IF AVAILABLE kit.XL_GlossEntry THEN DO:
        RUN Repo in hGloss (INPUT RECID(kit.XL_GlossEntry),INPUT 0).
        tGlssRec = RECID(kit.XL_GlossEntry).
      END.  /* IF available kit.XL_GlossEntry */
      ELSE DO: /* Not available kit.XL_GlossEntry */
        ThisMessage = "Search Item Was Not Found.".
        run adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).    
        FIND kit.XL_GlossEntry WHERE RECID(kit.XL_GlossEntry) = tGlssRec 
             no-lock NO-ERROR.
        IF NOT AVAILABLE kit.XL_Instance THEN DO:
          IF PhraseType:SCREEN-VALUE = "S":U THEN DO:
            RUN firstGlossSource.
            RUN prevGlossSource.
          END.
          ELSE DO:
            RUN firstGlossTarget.
            RUN prevGlossTarget.
          END.
        END.
      END.  /* Else Not available kit.XL_GlossEntry */
    END.  /* Glossary Case */
  END CASE.  /* Case based on MODE */
END.  /* Trigger */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnPrev FindWindow
ON CHOOSE OF BtnPrev IN FRAME DEFAULT-FRAME /* Previous */
DO:
  ASSIGN
    FindValue                          /* Straight value */
    tValCS          = FindValue        /* Case-sensitive straight value */
                                       /* Truncated value */
    FindValueBegins = IF LENGTH(FindValue, "CHARACTER":U) > 50 THEN
                        SUBSTRING(FindValue, 1, 50, "CHARACTER":U)
                      ELSE
                        FindValue
    iWildLoc        = IF (INDEX(FindValueBegins, "*":U) = 0 AND
                          INDEX(FindValueBegins, ".":U) = 0) THEN
                        0
                      ELSE IF (INDEX(FindValueBegins, "*":U) = 0 OR
                               INDEX(FindValueBegins, ".":U) = 0) THEN
                        MAXIMUM(INDEX(FindValueBegins, "*":U), INDEX(FindValueBegins, ".":U))
                      ELSE
                        MINIMUM(INDEX(FindValueBegins, "*":U), INDEX(FindValueBegins, ".":U))
    FindValueBegins = SUBSTR(FindValueBegins, 1, iWildLoc - 1, "CHARACTER":U)
    tValBeginsCS    = FindValueBegins  /* Case-sensitive truncated value */
    .
  CASE CurrentMode:
    WHEN 2 THEN DO: /* Translation */
      CASE PhraseType:SCREEN-VALUE:
        WHEN "S":U THEN
          RUN prevInstanceSource. 
        WHEN "T":u THEN
          RUN prevInstanceTarget.
      END CASE.

      /* Ask if they want to start at the top again */
      IF NOT AVAILABLE kit.XL_Instance THEN
      DO:
        ThisMessage = "Search Item Was Not Found. Start search from last record?". 
        run adecomm/_s-alert.p (input-output ErrorStatus, "q*":u, "yes-no":u, ThisMessage).          
        IF ErrorStatus THEN
        DO:
           CASE PhraseType:SCREEN-VALUE:
             WHEN "S":u THEN
                RUN lastInstanceSource.
             WHEN "T":u THEN
                RUN lastInstanceTarget.
          END CASE.
        END.
      END.

      IF AVAILABLE kit.XL_Instance THEN DO:
        RUN Repo in hTrans (INPUT RECID(kit.XL_Instance),INPUT 0).
        tInstRec = RECID(kit.XL_Instance).
      END.
      ELSE DO:
        ThisMessage = "Search Item Was Not Found.".
        run adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).
        FIND kit.XL_Instance WHERE RECID(kit.XL_Instance) = tInstRec no-lock NO-ERROR.
        IF NOT AVAILABLE kit.XL_Instance THEN DO:
          IF PhraseType:SCREEN-VALUE = "S":U THEN DO:
            RUN lastInstanceSource.
            RUN nextInstanceSource.
          END.
          ELSE DO:
            RUN lastInstanceTarget.
            RUN nextInstanceTarget.
          END.
        END.
      END.
    END.
    WHEN 3 THEN DO: /* Glossary */
      CASE PhraseType:SCREEN-VALUE:
        WHEN "S":u THEN
          RUN prevGlossSource.
        WHEN "T":u THEN
          RUN prevGlossTarget.
      END CASE.                                                      

      /* Ask if they want to start at the top again */
      IF NOT AVAILABLE kit.XL_GlossEntry THEN
      DO:
        ThisMessage = "Search Item Was Not Found. Start search from last record?". 
        run adecomm/_s-alert.p (input-output ErrorStatus, "q*":u, "yes-no":u, ThisMessage).          
        IF ErrorStatus THEN
        DO:
           CASE PhraseType:SCREEN-VALUE:
             WHEN "S":u THEN
                RUN lastGlossSource.
             WHEN "T":u THEN
                RUN lastGlossTarget.
          END CASE.
        END.
      END.

      IF AVAILABLE kit.XL_GlossEntry THEN DO:
        RUN Repo in hGloss (INPUT RECID(kit.XL_GlossEntry),INPUT 0).
        tGlssRec = RECID(kit.XL_GlossEntry).
      END.
      ELSE DO:
        ThisMessage = "Search Item Was Not Found.". 
        run adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).    
        FIND kit.XL_GlossEntry WHERE RECID(kit.XL_GlossEntry) = tGlssRec 
             no-lock NO-ERROR.
        IF NOT AVAILABLE kit.XL_Instance THEN DO:
          IF PhraseType:SCREEN-VALUE = "S":U THEN DO:
            RUN lastGlossSource.
            RUN nextGlossSource.
          END.
          ELSE DO:
            RUN lastGlossTarget.
            RUN nextGlossTarget.
          END.
        END.
      END.  /* Else not available */
    END.  /* When Glossary */
  END CASE.   /* Based on CurrentMode */
END.  /* Trigger */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnReplace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnReplace FindWindow
ON CHOOSE OF BtnReplace IN FRAME DEFAULT-FRAME /* Replace... */
DO: 
   CASE CurrentMode:
   WHEN 2 THEN
   DO: 
     IF AVAILABLE kit.XL_Instance  THEN                             
        run Realize in hReplace (kit.XL_Instance.SourcePhrase,kit.XL_Instance.TargetPhrase).  
     ELSE 
        run Realize in hReplace ("","").      
   END.
   WHEN 3 THEN
   DO:             
      IF AVAILABLE kit.XL_GlossEntry THEN
        run Realize in hReplace (kit.XL_GlossEntry.SourcePhrase,kit.XL_GlossEntry.TargetPhrase).  
      ELSE
        run Realize in hReplace ("","").     
   END.                                    
   OTHERWISE
   DO:      
     run Realize in hReplace ("","").   
   END.
   END CASE.
     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FindValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FindValue FindWindow
ON LEAVE OF FindValue IN FRAME DEFAULT-FRAME /* Find What */
DO:
  if FindValue:screen-value <> "" then BtnReplace:sensitive = true.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK FindWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   
   assign
     PhraseLabel:screen-value  = "Find"
     OptionsLabel:screen-value = "Options"
     PhraseLabel:width         = font-table:get-text-width-chars(PhraseLabel:screen-value,4)
     OptionsLabel:width        = font-table:get-text-width-chars(OptionsLabel:screen-value,4)
     FindWindow:parent         = MainWindow:handle
     UseWildCards:CHECKED      = TRUE.
   
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FndRec FindWindow 
PROCEDURE FndRec :
/*------------------------------------------------------------------------------
  Purpose:     Finds the specified rowid in the specified file.
  Parameters:  INPUT rowid value, INPUT file name
  Notes:       Called by _sort.w after file is sorted to ensure that subsequent
               FIND NEXT/PREV commands will be in sync with the corresponding
               query.
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER prRowid AS ROWID     NO-UNDO.
  DEFINE INPUT PARAMETER pFile   AS CHARACTER NO-UNDO.

  CASE pFile:
    WHEN "kit.XL_Instance" THEN
    DO:
      FIND kit.XL_Instance WHERE ROWID(kit.XL_Instance) = prRowid NO-LOCK.
      tInstRec = RECID(kit.XL_Instance).
    END.
    WHEN "kit.XL_GlossEntry" THEN
    DO:
      FIND kit.XL_GlossEntry WHERE ROWID(kit.XL_GlossEntry) = prRowid NO-LOCK.
      tGlssRec = RECID(kit.XL_GlossEntry).
    END.
    OTHERWISE DO:
      ThisMessage = REPLACE("File $ is not valid for this procedure.", "$", pFile). 
      run adecomm/_s-alert.p (input-output ErrorStatus, "e*":u, "ok":u, ThisMessage).          
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe FindWindow 
PROCEDURE HideMe :
{&WINDOW-NAME}:hidden = true.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize FindWindow 
PROCEDURE Realize :
FindWindow:hidden = true.
  Enable
    FindValue
    PhraseType
    IgnoreSpaces
    MatchCase
    UseWildCards
    BtnNext 
    BtnPrev
    BtnClose
    BtnHelp     
  with frame {&frame-name} in window FindWindow.
  
  assign
    FindValue:auto-zap     = true
    FindWindow:hidden      = false.

  if CurrentMode = 2 and tInstRec <> ? then
     find kit.xl_instance where tInstRec = recid(kit.xl_instance) no-lock no-error. 
  else
  if CurrentMode = 3 and tInstRec <> ? then
     find kit.XL_GlossEntry where tGlssRec = recid(kit.XL_GlossEntry) no-lock no-error.       
  
  apply "entry":u to FindValue in frame {&frame-name}. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SetColSearch FindWindow 
PROCEDURE SetColSearch :
  /* Sets the FIND dialog so it can perform special column searching for
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartColSearch FindWindow 
PROCEDURE StartColSearch :
  /* Starts the FIND dialog special column searching for source phrase and
     target phrase by applying choose to the Goto button.
     See _trans.p START-SEARCH event handling. -jep 04/23/1999. */

  DO WITH FRAME {&FRAME-NAME}:
    IF BtnNext:SENSITIVE = FALSE THEN BtnNext:SENSITIVE = TRUE.
    APPLY "CHOOSE":U TO BtnNext.
  END.
    
END PROCEDURE. /* SetColSearch */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE firstInstanceSource FindWindow 
PROCEDURE firstInstanceSource :
  /* "Find" code to search for the first record in the XL_Instance
     table whose SourcePhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_Instance SourcePhrase FIRST StringKey}
  END.
    
END PROCEDURE. /* firstInstanceSource */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nextInstanceSource FindWindow 
PROCEDURE nextInstanceSource :
  /* "Find" code to search for the next record in the XL_Instance
     table whose SourcePhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_Instance SourcePhrase NEXT StringKey}
  END.
    
END PROCEDURE. /* nextInstanceSource */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE firstInstanceTarget FindWindow 
PROCEDURE firstInstanceTarget :
  /* "Find" code to search for the first record in the XL_Instance
     table whose TargetPhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_Instance TargetPhrase FIRST ShortTarg}
  END.
    
END PROCEDURE. /* firstInstanceTarget */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nextInstanceTarget FindWindow 
PROCEDURE nextInstanceTarget :
  /* "Find" code to search for the next record in the XL_Instance
     table whose TargetPhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_Instance TargetPhrase NEXT ShortTarg}
  END.
    
END PROCEDURE. /* nextInstanceTarget */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE firstGlossSource FindWindow 
PROCEDURE firstGlossSource :
  /* "Find" code to search for the first record in the XL_GlossEntry
     table whose SourcePhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_GlossEntry SourcePhrase FIRST ShortSrc}
  END.
    
END PROCEDURE. /* firstGlossSource */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nextGlossSource FindWindow 
PROCEDURE nextGlossSource :
  /* "Find" code to search for the next record in the XL_GlossEntry
     table whose SourcePhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_GlossEntry SourcePhrase NEXT ShortSrc}
  END.
    
END PROCEDURE. /* nextGlossSource */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE firstGlossTarget FindWindow 
PROCEDURE firstGlossTarget :
  /* "Find" code to search for the first record in the XL_GlossEntry
     table whose TargetPhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_GlossEntry TargetPhrase FIRST ShortTarg}
  END.
    
END PROCEDURE. /* firstGlossTarget */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE nextGlossTarget FindWindow 
PROCEDURE nextGlossTarget :
  /* "Find" code to search for the next record in the XL_GlossEntry
     table whose TargetPhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_GlossEntry TargetPhrase NEXT ShortTarg}
  END.
    
END PROCEDURE. /* nextGlossTarget */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lastInstanceSource FindWindow 
PROCEDURE lastInstanceSource :
  /* "Find" code to search for the last record in the XL_Instance
     table whose SourcePhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_Instance SourcePhrase LAST StringKey}
  END.
    
END PROCEDURE. /* lastInstanceSource */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prevInstanceSource FindWindow 
PROCEDURE prevInstanceSource :
  /* "Find" code to search for the prev record in the XL_Instance
     table whose SourcePhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_Instance SourcePhrase PREV StringKey}
  END.
    
END PROCEDURE. /* prevInstanceSource */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lastInstanceTarget FindWindow 
PROCEDURE lastInstanceTarget :
  /* "Find" code to search for the last record in the XL_Instance
     table whose TargetPhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_Instance TargetPhrase LAST ShortTarg}
  END.
    
END PROCEDURE. /* lastInstanceTarget */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prevInstanceTarget FindWindow 
PROCEDURE prevInstanceTarget :
  /* "Find" code to search for the prev record in the XL_Instance
     table whose TargetPhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_Instance TargetPhrase PREV ShortTarg}
  END.
    
END PROCEDURE. /* prevInstanceTarget */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lastGlossSource FindWindow 
PROCEDURE lastGlossSource :
  /* "Find" code to search for the last record in the XL_GlossEntry
     table whose SourcePhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_GlossEntry SourcePhrase LAST ShortSrc}
  END.
    
END PROCEDURE. /* lastGlossSource */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prevGlossSource FindWindow 
PROCEDURE prevGlossSource :
  /* "Find" code to search for the prev record in the XL_GlossEntry
     table whose SourcePhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_GlossEntry SourcePhrase PREV ShortSrc}
  END.
    
END PROCEDURE. /* prevGlossSource */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE lastGlossTarget FindWindow 
PROCEDURE lastGlossTarget :
  /* "Find" code to search for the last record in the XL_GlossEntry
     table whose TargetPhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_GlossEntry TargetPhrase LAST ShortTarg}
  END.
    
END PROCEDURE. /* lastGlossTarget */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE prevGlossTarget FindWindow 
PROCEDURE prevGlossTarget :
  /* "Find" code to search for the prev record in the XL_GlossEntry
     table whose TargetPhrase field matches the search criteria. (tomn 10/99) */

  DO WITH FRAME DEFAULT-FRAME:
    {adetran/vt/_find.i kit.XL_GlossEntry TargetPhrase PREV ShortTarg}
  END.
    
END PROCEDURE. /* prevGlossTarget */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME ReplaceWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS ReplaceWindow 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_replace.w
Author:       F. Chang
Created:      1/95 
Updated:      9/95
                11/96 SLK Changed for FONT
Purpose:      Visual Translator's replace program
Background:   This .w is run persistent as a hidden window.  When
              invoked via the vt/_main.p's menu or replace button, the
              hidden property is changed to false and it is exposed.
              The 'Close' button just rehides the windows.
Notes:        The replace program is only enabled when 'CurrentMode'
              is equal to 2 or 3 (Translation or glossary tab).
              When CurrentMode=2 then it finds translation data
              and when 3, it finds glossary data.  In both cases, it
              positions the users on the found row (if available).  
Includes:     vt/_find.i 
              
*/ 


{ adetran/vt/vthlp.i } /* definitions for help context strings */  
define var hReplace as handle no-undo.

/* fhc */
define variable ThisMessage as char no-undo.
define variable ErrorStatus as logical no-undo.
define shared var MainWindow as widget-handle no-undo.  
define SHARED VAR hGloss as handle no-undo.
DEFINE SHARED VAR CurrentMode as integer no-undo.   
define SHARED VAR hTrans as handle no-undo.
DEFINE VARIABLE tValCS          AS CHAR FORMAT "X(60)":U CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE FindValueBegins AS CHAR FORMAT "X(60)":U NO-UNDO.
DEFINE VARIABLE tValBeginsCS    AS CHAR FORMAT "X(60)":U CASE-SENSITIVE NO-UNDO.
DEFINE VARIABLE iWildLoc        AS INT  NO-UNDO.

DEFINE BUFFER bGloss FOR kit.XL_GlossEntry.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 FindValue BtnReplace OptionsLabel ~
FindLabel BtnReplaceAll RECT-4 RECT-2 FindType IgnoreSpaces BtnClose ~
MatchCase UseWildCards BtnHelp Replace ReplaceValue 
&Scoped-Define DISPLAYED-OBJECTS FindValue OptionsLabel FindLabel FindType ~
IgnoreSpaces MatchCase UseWildCards Replace ReplaceValue 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR ReplaceWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnClose 
     LABEL "&Close":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnReplace 
     LABEL "&Replace":L 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnReplaceAll 
     LABEL "Replace &All":L 
     SIZE 15 BY 1.125.

DEFINE VARIABLE FindLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Find" 
      VIEW-AS TEXT 
     SIZE 4 BY .67 NO-UNDO.

DEFINE VARIABLE FindValue AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Find What" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE OptionsLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Match" 
      VIEW-AS TEXT 
     SIZE 8.6 BY .67 NO-UNDO.

DEFINE VARIABLE Replace AS CHARACTER FORMAT "X(256)":U 
     LABEL "Re&place What" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE ReplaceValue AS CHARACTER FORMAT "X(256)":U 
     LABEL "Replace &With" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "adetran/images/find":U
     SIZE 3.8 BY .67.

DEFINE VARIABLE FindType AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Source", "S":U,
"&Target", "T":U
     SIZE 14 BY 2.14 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39.2 BY 3.05.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 17 BY 3.1.

DEFINE VARIABLE IgnoreSpaces AS LOGICAL INITIAL no 
     LABEL "&Ignore Leading Spaces" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .76 NO-UNDO.

DEFINE VARIABLE MatchCase AS LOGICAL INITIAL no 
     LABEL "Cas&e Sensitive":L 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .86 NO-UNDO.

DEFINE VARIABLE UseWildCards AS LOGICAL INITIAL no 
     LABEL "&Use Wildcards" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     FindValue AT ROW 1.48 COL 31 COLON-ALIGNED
     BtnReplace AT ROW 1.48 COL 75
     OptionsLabel AT ROW 2.62 COL 31.4 COLON-ALIGNED NO-LABEL
     FindLabel AT ROW 2.67 COL 16.2 NO-LABEL
     BtnReplaceAll AT ROW 2.71 COL 75
     FindType AT ROW 3.43 COL 16 NO-LABEL
     IgnoreSpaces AT ROW 3.43 COL 35
     BtnClose AT ROW 3.95 COL 75
     MatchCase AT ROW 4.24 COL 35
     UseWildCards AT ROW 5.05 COL 35
     BtnHelp AT ROW 5.19 COL 75
     Replace AT ROW 6.71 COL 31 COLON-ALIGNED
     ReplaceValue AT ROW 7.91 COL 31 COLON-ALIGNED
     IMAGE-1 AT ROW 1 COL 1
     RECT-4 AT ROW 2.95 COL 15
     RECT-2 AT ROW 2.95 COL 33.8
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.4 BY 8.33
         BGCOLOR 8 FONT 4
         DEFAULT-BUTTON BtnReplace.

 

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
  CREATE WINDOW ReplaceWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Replace"
         HEIGHT             = 8.43
         WIDTH              = 90.6
         MAX-HEIGHT         = 12.14
         MAX-WIDTH          = 90.6
         VIRTUAL-HEIGHT     = 12.14
         VIRTUAL-WIDTH      = 90.6
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

IF NOT ReplaceWindow:LOAD-ICON("adetran/images/props%":U) THEN
    MESSAGE "Unable to load icon: adetran/images/props%"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW ReplaceWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FILL-IN FindLabel IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(ReplaceWindow)
THEN ReplaceWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME ReplaceWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ReplaceWindow ReplaceWindow
ON END-ERROR OF ReplaceWindow /* Replace */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window being used as a modeless dialog box,
     respond by closing the window. */
  APPLY "WINDOW-CLOSE":U TO {&WINDOW-NAME}.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ReplaceWindow ReplaceWindow
ON WINDOW-CLOSE OF ReplaceWindow /* Replace */
DO:
  ReplaceWindow:hidden = true.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnClose ReplaceWindow
ON CHOOSE OF BtnClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  ReplaceWindow:hidden = true.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp ReplaceWindow
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  run adecomm/_adehelp.p ("vt":u,"context":U,{&Replace_Dialog_box}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnReplace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnReplace ReplaceWindow
ON CHOOSE OF BtnReplace IN FRAME DEFAULT-FRAME /* Replace */
DO:
   DEFINE VARIABLE tab-rec AS RECID                        NO-UNDO.
   ASSIGN
     Replace
     ReplaceValue
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
     WHEN 2 THEN DO: /* Translation Tab */
       CASE FindType:SCREEN-VALUE:
         WHEN "S":U THEN DO:
           {adetran/vt/_find.i kit.XL_Instance SourcePhrase NEXT StringKey}
         END.
         WHEN "T":U THEN DO:
           {adetran/vt/_find.i kit.XL_Instance TargetPhrase NEXT ShortTarg}         
         END.
       END CASE.  /* Case on FindType */

       IF NOT AVAILABLE kit.XL_Instance THEN
       DO:
          ASSIGN ThisMessage = "Replace Item Was Not Found. Start replace from first item?".
          RUN  adecomm/_s-alert.p (input-output ErrorStatus, "q*":u, "yes-no":u, ThisMessage).
          IF ErrorStatus THEN
          DO:
             CASE FindType:SCREEN-VALUE:
               WHEN "S":U THEN DO:
                  {adetran/vt/_find.i kit.XL_Instance SourcePhrase FIRST StringKey}
               END.
               WHEN "T":U THEN DO:
                  {adetran/vt/_find.i kit.XL_Instance TargetPhrase FIRST ShortTarg}         
               END.
             END CASE.  /* Case on FindType */
          END. /* ErrorStatus */
       END. /* Find first? */

       IF AVAILABLE kit.XL_Instance THEN DO:
         tab-rec = RECID(kit.XL_Instance).
         RUN Ref in hTrans (tab-rec).
         RUN replace-string (INPUT "INST":U, INPUT "ASK":U, INPUT tab-rec).
       END.
       ELSE DO:
         FIND FIRST kit.XL_Instance NO-LOCK NO-ERROR.
         FIND PREV kit.XL_Instance  NO-LOCK NO-ERROR.
         ThisMessage = "Replace Item Was Not Found.".
         run adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).
       END.
     END.  /* Translation Tab */
     WHEN 3 THEN DO:  /* Glossary Tab */
       CASE FindType:SCREEN-VALUE:
         WHEN "S":U THEN DO:
           {adetran/vt/_find.i kit.XL_GlossEntry SourcePhrase NEXT ShortSrc}
         END.
         WHEN "T":U THEN DO:
           {adetran/vt/_find.i kit.XL_GlossEntry TargetPhrase NEXT ShortTarg}         
         END.
       END CASE.  /* Case on FindType */

       IF NOT AVAILABLE kit.XL_GlossEntry THEN
       DO:
          ASSIGN ThisMessage = "Replace Item Was Not Found. Start replace from first item?".
          RUN  adecomm/_s-alert.p (input-output ErrorStatus, "q*":u, "yes-no":u, ThisMessage).
          IF ErrorStatus THEN
          DO:
             CASE FindType:SCREEN-VALUE:
               WHEN "S":U THEN DO:
                  {adetran/vt/_find.i kit.XL_GlossEntry SourcePhrase FIRST ShortSrc}
               END.
               WHEN "T":U THEN DO:
                  {adetran/vt/_find.i kit.XL_GlossEntry TargetPhrase FIRST ShortTarg}         
               END.
             END CASE.  /* Case on FindType */
          END. /* ErrorStatus */
       END. /* Find first? */

       IF AVAILABLE kit.XL_GlossEntry THEN DO:
         tab-rec = RECID(kit.XL_GlossEntry).
         RUN Ref in hGloss (tab-rec).
         RUN replace-string (INPUT "GLOSS":U, INPUT "ASK":U, INPUT tab-rec).
       END.
       ELSE DO:
         FIND FIRST kit.XL_GlossEntry NO-LOCK NO-ERROR.   
         FIND PREV  kit.XL_GlossEntry NO-LOCK NO-ERROR.   
         ThisMessage = "Replace Item Was Not Found.".
         run adecomm/_s-alert.p (input-output ErrorStatus, "i*":u, "ok":u, ThisMessage).          
       END.     
     END. /* when "3" Glossary */
   END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnReplaceAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnReplaceAll ReplaceWindow
ON CHOOSE OF BtnReplaceAll IN FRAME DEFAULT-FRAME /* Replace All */
DO:
   DEFINE VARIABLE enough-is-enough AS LOGICAL             NO-UNDO.
   DEFINE VARIABLE tab-rec          AS RECID               NO-UNDO.
   ASSIGN
     Replace
     ReplaceValue
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
      WHEN 2 THEN
      DO: /* Translation Tab */
         FIND FIRST kit.XL_Instance NO-LOCK NO-ERROR.
         FIND PREV kit.XL_Instance  NO-LOCK NO-ERROR.

         REPEAT WHILE NOT enough-is-enough:     
            CASE FindType:SCREEN-VALUE:
               WHEN "S":U THEN
               DO:
                  {adetran/vt/_find.i kit.XL_Instance SourcePhrase NEXT StringKey}
               END.
               WHEN "T":U THEN
               DO:
                  {adetran/vt/_find.i kit.XL_Instance TargetPhrase NEXT ShortTarg}         
               END.
            END CASE.  /* Case on FindType */

            /* From the top? */
            IF NOT AVAILABLE kit.XL_Instance THEN
            DO:
               ASSIGN ThisMessage = "Replace Item Was Not Found. Start replace from first item?".
               RUN  adecomm/_s-alert.p (input-output ErrorStatus, "q*":u, "yes-no":u, ThisMessage).
               IF ErrorStatus THEN
               DO:
                  CASE FindType:SCREEN-VALUE:
                     WHEN "S":U THEN DO:
                        {adetran/vt/_find.i kit.XL_Instance SourcePhrase FIRST StringKey}
                     END.
                     WHEN "T":U THEN DO:
                        {adetran/vt/_find.i kit.XL_Instance TargetPhrase FIRST ShortTarg}         
                     END.
                  END CASE.  /* Case on FindType */
               END. /* ErrorStatus */
            END. /* Find first? */
      
            IF AVAILABLE kit.XL_Instance THEN
            DO:
               tab-rec = RECID(kit.XL_Instance).
               RUN replace-string (INPUT "INST":U, INPUT "DONT-ASK":U, INPUT tab-rec).
            END.
            ELSE enough-is-enough = true.
          END. /* REPEAT */
        END.  /* Translation Tab */
     WHEN 3 THEN
     DO:  /* Glossary Tab */
        FIND FIRST kit.XL_GlossEntry NO-LOCK NO-ERROR.   
        FIND PREV  kit.XL_GlossEntry NO-LOCK NO-ERROR.   
      
        REPEAT WHILE NOT enough-is-enough:
           CASE FindType:SCREEN-VALUE:
              WHEN "S":U THEN
              DO:
                   {adetran/vt/_find.i kit.XL_GlossEntry SourcePhrase NEXT ShortSrc}
              END.
              WHEN "T":U THEN
              DO:
                   {adetran/vt/_find.i kit.XL_GlossEntry TargetPhrase NEXT ShortTarg}         
              END.
           END CASE.  /* Case on FindType */
      
           IF NOT AVAILABLE kit.XL_GlossEntry THEN
           DO:
              ASSIGN ThisMessage = "Replace Item Was Not Found. Start replace from first item?".
              RUN  adecomm/_s-alert.p (input-output ErrorStatus, "q*":u, "yes-no":u, ThisMessage).
              IF ErrorStatus THEN
              DO:
                 CASE FindType:SCREEN-VALUE:
                    WHEN "S":U THEN
                    DO:
                        {adetran/vt/_find.i kit.XL_GlossEntry SourcePhrase FIRST ShortSrc}
                    END.
                    WHEN "T":U THEN
                    DO:
                        {adetran/vt/_find.i kit.XL_GlossEntry TargetPhrase FIRST ShortTarg}         
                    END.
                 END CASE.  /* Case on FindType */
              END. /* ErrorStatus */
           END. /* Find first? */
      
           IF AVAILABLE kit.XL_GlossEntry THEN
           DO:
              tab-rec = RECID(kit.XL_GlossEntry).
              IF AVAILABLE kit.XL_GlossEntry THEN
              DO:
                 tab-rec = RECID(kit.XL_GlossEntry).
                 RUN replace-string (INPUT "GLOSS":U, INPUT "ASK":U, INPUT tab-rec).
              END.
           END.
           ELSE enough-is-enough = true.
       END.  /* REPEAT */
     END. /* when "3" Glossary */
   END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FindValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FindValue ReplaceWindow
ON ANY-PRINTABLE OF FindValue IN FRAME DEFAULT-FRAME /* Find What */
DO:
  if FindValue:screen-value <> "" then assign
    BtnReplace:sensitive    = true
    BtnReplaceAll:sensitive = true.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FindValue ReplaceWindow
ON LEAVE OF FindValue IN FRAME DEFAULT-FRAME /* Find What */
DO:
  if FindValue:screen-value <> "" then assign
    BtnReplace:sensitive    = true
    BtnReplaceAll:sensitive = true.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Replace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Replace ReplaceWindow
ON ANY-PRINTABLE OF Replace IN FRAME DEFAULT-FRAME /* Replace What */
DO:
  if FindValue:screen-value <> "" then assign
    BtnReplace:sensitive    = true
    BtnReplaceAll:sensitive = true.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Replace ReplaceWindow
ON LEAVE OF Replace IN FRAME DEFAULT-FRAME /* Replace What */
DO:
  if FindValue:screen-value <> "" then assign
    BtnReplace:sensitive    = true
    BtnReplaceAll:sensitive = true.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK ReplaceWindow 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:


   assign
     FindLabel:screen-value    = "Find"
     OptionsLabel:screen-value = "Options"
     FindLabel:width           = font-table:get-text-width-chars(FindLabel:screen-value,4)
     OptionsLabel:width        = font-table:get-text-width-chars(OptionsLabel:screen-value,4)
     ReplaceWindow:parent      = MainWindow:handle
     UseWildCards:CHECKED      = TRUE.
   
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE FndRec ReplaceWindow 
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
      FIND kit.XL_Instance WHERE ROWID(kit.XL_Instance) = prRowid NO-LOCK.
    WHEN "kit.XL_GlossEntry" THEN
      FIND kit.XL_GlossEntry WHERE ROWID(kit.XL_GlossEntry) = prRowid NO-LOCK.
    OTHERWISE DO:
      ThisMessage = REPLACE("File $ is not valid for this procedure.", "$", pFile). 
      run adecomm/_s-alert.p (input-output ErrorStatus, "e*":u, "ok":u, ThisMessage).          
    END.
  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe ReplaceWindow 
PROCEDURE HideMe :
{&WINDOW-NAME}:hidden = true.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize ReplaceWindow 
PROCEDURE Realize :
define input parameter pFindValue as char no-undo. 
define input parameter pReplaceValue as char no-undo.

  ReplaceWindow:hidden = true.
  Enable 
    FindValue
    Replace
    ReplaceValue
    FindType
    IgnoreSpaces
    MatchCase
    UseWildCards
    BtnClose
    BtnHelp
  with frame {&frame-name} in window ReplaceWindow.
  
  assign
    FindValue:SCREEN-VALUE    = pFindValue
    Replace:screen-value      = pReplaceValue
    ReplaceValue:SCREEN-VALUE = ""
    FindValue:auto-zap        = true
    ReplaceWindow:hidden      = false.
    
  IF FindValue:SCREEN-VALUE IN FRAME {&Frame-Name} = "" THEN
     apply "entry":u to FindValue in frame {&frame-name}.
  ELSE                      
  DO:                           
     apply "entry":u to ReplaceValue in frame {&frame-name}.
     ASSIGN BtnReplace:SENSITIVE = TRUE
            BtnReplaceAll:SENSITIVE = TRUE. 
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE replace-string ReplaceWindow 
PROCEDURE replace-string :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER rec-typ  AS CHARACTER                    NO-UNDO.
  DEFINE INPUT PARAMETER ask      AS CHARACTER                    NO-UNDO.
  DEFINE INPUT PARAMETER tab-rec  AS RECID                        NO-UNDO.
  
  DEFINE VARIABLE        NewTrans AS LOGICAL                      NO-UNDO.
  
  IF rec-typ = "INST":U THEN DO TRANSACTION:  /* An instance record */
    FIND kit.XL_Instance WHERE RECID(kit.XL_Instance) = tab-rec EXCLUSIVE-LOCK.
    IF ask = "ASK":U THEN DO:
      IF kit.XL_Instance.TargetPhrase MATCHES "*":U + Replace + "*":U THEN DO:
        ThisMessage = "Do you want to replace ~"" + replace + "~" in: " + 
                       Kit.XL_Instance.TargetPhrase + "?":U.
        RUN adecomm/_s-alert.p (input-output ErrorStatus, "q*":U, "yes-no":U, ThisMessage).
      END.  /* If the string exists */
      ELSE DO:  /* The string to replace isn't there */
        ThisMessage = Replace + " isn't contained in " +
                      Kit.XL_Instance.TargetPhrase + ".":U.
        RUN adecomm/_s-alert.p (input-output ErrorStatus, "w*":U, "ok":U, ThisMessage).
        ErrorStatus = no.
      END.
    END.  /* The user should be asked */
    IF ask NE "ASK":U THEN ErrorStatus = TRUE.
    IF ErrorStatus THEN DO:  /* Switch-em */
      IF kit.XL_instance.TargetPhrase = "" AND replace = "" THEN
        ASSIGN NewTrans                     = YES
               kit.XL_Instance.TargetPhrase = replacevalue
               kit.XL_Instance.ShortTarg    = SUBSTRING(replacevalue,1,63,"RAW":U).
      ELSE IF LENGTH(replace, "RAW":U) > 0 THEN
        ASSIGN NewTrans                     = (kit.XL_Instance.ShortTarg = "":U)
               kit.XL_Instance.TargetPhrase = REPLACE(kit.XL_Instance.TargetPhrase,
                                                replace, replacevalue)
               kit.XL_Instance.ShortTarg    = SUBSTRING(kit.XL_Instance.TargetPhrase,
                                                1,63,"RAW":U).
      if kit.XL_Instance.ShortTarg = ? THEN kit.XL_Instance.ShortTarg = "".
      IF NOT AVAILABLE kit.XL_Project THEN
        FIND FIRST kit.XL_Project EXCLUSIVE-LOCK NO-ERROR.
      IF AVAILABLE kit.XL_Project THEN DO:
        IF NewTrans AND kit.XL_Instance.ShortTarg NE "":U THEN
          kit.XL_Project.TranslationCount = kit.XL_Project.TranslationCount + 1.
        ELSE IF NOT NewTrans AND kit.XL_Instance.ShortTarg = "":U THEN
          kit.XL_Project.TranslationCount = kit.XL_Project.TranslationCount - 1.
      END.
      RUN Ref in hTrans (tab-rec).
    END.  /* Switch-em */
  END.
  ELSE DO TRANSACTION:  /* A glossary record */
    FIND kit.XL_GlossEntry WHERE RECID(kit.XL_GlossEntry) = tab-rec EXCLUSIVE-LOCK.
    IF ask = "ASK":U THEN DO:
      IF kit.XL_GlossEntry.TargetPhrase MATCHES "*":U + Replace + "*":U THEN DO:
        ThisMessage = "Do you want to replace ~"" + replace + "~" in: " + 
                      kit.XL_GlossEntry.TargetPhrase + "?":U.
        RUN adecomm/_s-alert.p (input-output ErrorStatus, "q*":U, "yes-no":U, ThisMessage).
      END.  /* If the string exists */
      ELSE DO:  /* The string to replace isn't there */
        ThisMessage = Replace + " isn't contained in " +
                      Kit.XL_GlossEntry.TargetPhrase + ".":U.
        RUN adecomm/_s-alert.p (input-output ErrorStatus, "w*":U, "ok":U, ThisMessage).
        ErrorStatus = no.
      END.
    END.  /* The user should be asked */
    IF ASK NE "ASK":U THEN ErrorStatus = TRUE.
    IF ErrorStatus THEN DO:  /* Do it */
      IF kit.XL_GlossEntry.TargetPhrase = "" AND replace = "" THEN
        ASSIGN kit.XL_GlossEntry.TargetPhrase = replacevalue
               kit.XL_GlossEntry.ShortTarg    = SUBSTRING(kit.XL_GlossEntry.TargetPhrase,
                                                     1, 63, "RAW":U).
      ELSE IF LENGTH(replace, "RAW":U) > 0 THEN
        ASSIGN kit.XL_GlossEntry.TargetPhrase = REPLACE(kit.XL_GlossEntry.TargetPhrase,
                                                replace, replacevalue)
               kit.XL_GlossEntry.ShortTarg    = SUBSTRING(kit.XL_GlossEntry.TargetPhrase,
                                                     1, 63, "RAW":U).
      RUN Ref in hGloss (tab-rec).
    END.  /* Do it */
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



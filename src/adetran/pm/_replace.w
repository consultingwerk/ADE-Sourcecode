&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
/* Procedure Description
"Basic Window Template

Use this template to create a new window. Alter this default template or create new ones to accomodate your needs for different default sizes and/or attributes."
*/
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

Procedure:    adetran/pm/_replace.w
Author:       F. Chang
Created:      1/95 
Updated:      9/95
                11/96 SLK Changed for FONT
                07/98 SLK Added handling REPLACE for translations
Purpose:      Translation Manager Glossary replace program
Background:   This .w is run persistent AS a HIDDEN window.  When
              invoked via the pm/_pmmain.p's menu, the HIDDEN
              property is changed to FALSE and it is exposed.
              The 'Close' button just rehides the windows.
Notes:        The replace program is only enabled when 'CurrentMode'
              is equal to 2 or 3 (Translation or glossary tab).
              When CurrentMode=2 THEN it finds translation data
              and when 3, it finds glossary data.  In both cases, it
              positions the users on the found row (if available).  

                1. In CurrentMode=2, it uses a query that is a 3-way join
                   for XL_String_Info, XL_Instance, XL_Translation.
                   XL_Translation is an outer join.
                2. In CurrentMode=3, it uses a query with an assumed where
                   clause:
                      ...where xlatedb.XL_GlossDet.GlossaryName = s_Glossary
                      
                      s_Glossary is SHARED variable with the currently selected
                      glossary name. 

Includes:     pm/_replace.i 
              pm/_replav.i
*/ 

{ adetran/pm/tranhelp.i } /* definitions for help context strings */  

/* fhc */             
DEFINE SHARED VARIABLE _hGloss                  AS HANDLE               NO-UNDO.
DEFINE SHARED VARIABLE _hTrans                  AS HANDLE               NO-UNDO.
DEFINE SHARED VARIABLE _Lang                    AS CHARACTER            NO-UNDO.
DEFINE SHARED VARIABLE _SuppressReplaceAsk        AS LOGICAL              NO-UNDO.
DEFINE SHARED VARIABLE CurrentMode              AS INTEGER              NO-UNDO. 
DEFINE SHARED VARIABLE s_Glossary               AS CHARACTER            NO-UNDO.
DEFINE SHARED VARIABLE stringROWID              AS ROWID                NO-UNDO.
DEFINE SHARED VARIABLE instanceROWID            AS ROWID                NO-UNDO.
DEFINE SHARED VARIABLE translationROWID         AS ROWID                NO-UNDO.
DEFINE SHARED VARIABLE glossDetROWID            AS ROWID                NO-UNDO.


DEFINE        VARIABLE _hReplace                AS HANDLE               NO-UNDO.
DEFINE        VARIABLE ErrorStatus              AS LOGICAL              NO-UNDO.
DEFINE        VARIABLE tChar                    AS CHAR                 NO-UNDO.
DEFINE        VARIABLE tVal                     AS CHAR CASE-SENSITIVE  NO-UNDO.
DEFINE        VARIABLE ThisMessage              AS CHAR                 NO-UNDO.

DEFINE BUFFER bGloss FOR xlatedb.XL_GlossDet.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 RECT-4 RECT-2 BtnReplace FindValue ~
BtnReplaceAll FindType IgnoreSpaces BtnClose MatchCase UseWildCards BtnHelp ~
Replace ReplaceValue FindLabel OptionsLabel 
&Scoped-Define DISPLAYED-OBJECTS FindValue FindType IgnoreSpaces MatchCase ~
UseWildCards Replace ReplaceValue FindLabel OptionsLabel 

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
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnHelp 
     LABEL "&Help":L 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnReplace 
     LABEL "&Replace":L 
     SIZE 15 BY 1.12.

DEFINE BUTTON BtnReplaceAll 
     LABEL "Replace &All":L 
     SIZE 15 BY 1.12.

DEFINE VARIABLE FindLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Find" 
      VIEW-AS TEXT 
     SIZE 4 BY .65 NO-UNDO.

DEFINE VARIABLE FindValue AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Find What" 
     VIEW-AS FILL-IN 
     SIZE 40 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE OptionsLabel AS CHARACTER FORMAT "X(256)":U INITIAL "Match" 
      VIEW-AS TEXT 
     SIZE 9 BY .65 NO-UNDO.

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
     SIZE 3.86 BY .65.

DEFINE VARIABLE FindType AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "&Source", "S",
"&Target", "T"
     SIZE 14 BY 2.15 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 39.14 BY 3.04.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 17 BY 3.12.

DEFINE VARIABLE IgnoreSpaces AS LOGICAL INITIAL no 
     LABEL "&Ignore Leading Spaces" 
     VIEW-AS TOGGLE-BOX
     SIZE 29 BY .77 NO-UNDO.

DEFINE VARIABLE MatchCase AS LOGICAL INITIAL no 
     LABEL "Cas&e Sensitive":L 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .85 NO-UNDO.

DEFINE VARIABLE UseWildCards AS LOGICAL INITIAL no 
     LABEL "&Use Wildcards" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .77 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BtnReplace AT ROW 1.46 COL 75
     FindValue AT ROW 1.54 COL 31 COLON-ALIGNED
     BtnReplaceAll AT ROW 2.65 COL 75
     FindType AT ROW 3.42 COL 16 NO-LABEL
     IgnoreSpaces AT ROW 3.42 COL 35
     BtnClose AT ROW 3.85 COL 75
     MatchCase AT ROW 4.23 COL 35
     UseWildCards AT ROW 5.04 COL 35
     BtnHelp AT ROW 5.04 COL 75
     Replace AT ROW 6.69 COL 31 COLON-ALIGNED
     ReplaceValue AT ROW 7.77 COL 31 COLON-ALIGNED
     FindLabel AT ROW 2.62 COL 16.14 NO-LABEL
     OptionsLabel AT ROW 2.62 COL 35 NO-LABEL
     IMAGE-1 AT ROW 1 COL 1
     RECT-4 AT ROW 2.96 COL 15
     RECT-2 AT ROW 2.96 COL 33.86
    WITH 1 DOWN NO-BOX OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.6 BY 8.19
         BGCOLOR 8 FONT 4
         DEFAULT-BUTTON BtnReplace.


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
  CREATE WINDOW ReplaceWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Replace"
         HEIGHT             = 8.31
         WIDTH              = 90.86
         MAX-HEIGHT         = 12.15
         MAX-WIDTH          = 91.14
         VIRTUAL-HEIGHT     = 12.15
         VIRTUAL-WIDTH      = 91.14
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
IF NOT ReplaceWindow:LOAD-ICON("adetran/images/props%":U) THEN
    MESSAGE "Unable to load icon: adetran/images/props%"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
&ENDIF
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW ReplaceWindow
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
                                                                        */
/* SETTINGS FOR FILL-IN FindLabel IN FRAME DEFAULT-FRAME
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN OptionsLabel IN FRAME DEFAULT-FRAME
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
     In a persistently run window being used AS a modeless dialog box,
     respond by closing the window. */
  APPLY "WINDOW-CLOSE":U TO {&WINDOW-NAME}.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ReplaceWindow ReplaceWindow
ON WINDOW-CLOSE OF ReplaceWindow /* Replace */
DO:
  ReplaceWindow:HIDDEN = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnClose
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnClose ReplaceWindow
ON CHOOSE OF BtnClose IN FRAME DEFAULT-FRAME /* Close */
DO:
  ReplaceWindow:HIDDEN = TRUE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp ReplaceWindow
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME {&FRAME-NAME} DO:
  run adecomm/_adehelp.p ("tran","context",{&Replace_Dlgbx}, ?).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnReplace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnReplace ReplaceWindow
ON CHOOSE OF BtnReplace IN FRAME DEFAULT-FRAME /* Replace */
DO:
  RUN refresh.ip.
  /* Split - action segment limit */
  IF CurrentMode = 3 THEN RUN ReplaceGloss.ip.
  ELSE                    RUN ReplaceTran.ip.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnReplaceAll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnReplaceAll ReplaceWindow
ON CHOOSE OF BtnReplaceAll IN FRAME DEFAULT-FRAME /* Replace All */
DO:
  RUN refresh.ip.
  /* Split - action segment limit */
  IF CurrentMode = 3 THEN RUN ReplaceAllGloss.ip.
  ELSE                    RUN ReplaceAllTran.ip.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME FindValue
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FindValue ReplaceWindow
ON ANY-PRINTABLE OF FindValue IN FRAME DEFAULT-FRAME /* Find What */
DO:
  IF FindValue:SCREEN-VALUE <> "" THEN ASSIGN
    BtnReplace:SENSITIVE    = TRUE
    BtnReplaceAll:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL FindValue ReplaceWindow
ON LEAVE OF FindValue IN FRAME DEFAULT-FRAME /* Find What */
DO:
  IF FindValue:SCREEN-VALUE <> "" THEN ASSIGN
    BtnReplace:SENSITIVE    = TRUE
    BtnReplaceAll:SENSITIVE = TRUE.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME Replace
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Replace ReplaceWindow
ON ANY-PRINTABLE OF Replace IN FRAME DEFAULT-FRAME /* Replace What */
DO:
  IF FindValue:SCREEN-VALUE <> "" THEN ASSIGN
    BtnReplace:SENSITIVE    = TRUE
    BtnReplaceAll:SENSITIVE = TRUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Replace ReplaceWindow
ON LEAVE OF Replace IN FRAME DEFAULT-FRAME /* Replace What */
DO:
  IF FindValue:SCREEN-VALUE <> "" THEN ASSIGN
    BtnReplace:SENSITIVE    = TRUE
    BtnReplaceAll:SENSITIVE = TRUE.  
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
/* (NOTE: HANDLE ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
   ASSIGN
     FindLabel:SCREEN-VALUE    = "Find"
     OptionsLabel:SCREEN-VALUE = "Options"
     FindLabel:width           = font-table:get-text-width-chars(FindLabel:SCREEN-VALUE,4)
     OptionsLabel:width        = font-table:get-text-width-chars(OptionsLabel:SCREEN-VALUE,4)
     UseWildCards:CHECKED      = TRUE.
   
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe ReplaceWindow 
PROCEDURE HideMe :
{&WINDOW-NAME}:HIDDEN = TRUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize ReplaceWindow 
PROCEDURE Realize :
DEFINE INPUT PARAMETER pFindValue AS CHARACTER NO-UNDO. 
DEFINE INPUT PARAMETER pReplaceValue AS CHARACTER NO-UNDO.

  ReplaceWindow:HIDDEN = TRUE.
  ENABLE 
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
    
  ASSIGN
    FindValue:SCREEN-VALUE    = pFindValue
    Replace:SCREEN-VALUE      = pReplaceValue
    ReplaceValue:SCREEN-VALUE = ""
    FindValue:AUTO-ZAP        = TRUE
    ReplaceWindow:HIDDEN      = FALSE.
    
  RUN refresh.ip.
  IF FindValue:SCREEN-VALUE IN FRAME {&Frame-Name} = "" THEN
     APPLY "entry" to FindValue in frame {&frame-name}.
  ELSE                      
  DO:                           
     APPLY "entry" to ReplaceValue in frame {&frame-name}.
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
  DEFINE INPUT PARAMETER rec-typ          AS CHARACTER             NO-UNDO.
  DEFINE INPUT PARAMETER ask              AS CHARACTER             NO-UNDO.
  DEFINE INPUT PARAMETER stringROWID      AS ROWID                 NO-UNDO.
  DEFINE INPUT PARAMETER instanceROWID    AS ROWID                 NO-UNDO.
  DEFINE INPUT PARAMETER translationROWID AS ROWID                 NO-UNDO.
  DEFINE VARIABLE ThisMessage             AS CHARACTER             NO-UNDO.

  IF rec-typ = "GLOSS":U THEN 
  DO:
     FIND xlatedb.XL_GlossDet WHERE ROWID(xlatedb.XL_GlossDet) = stringROWID EXCLUSIVE-LOCK.
     IF ask = "ASK":U AND NOT _SuppressReplaceAsk THEN 
     DO:
       IF xlatedb.XL_GlossDet.TargetPhrase MATCHES "*":U + Replace + "*":U THEN DO:
         ThisMessage = "Do you want to replace ~"" + replace + "~" in: " + 
                       xlatedb.XL_GlossDet.TargetPhrase + "?":U.
         RUN adecomm/_s-alert.p (INPUT-OUTPUT ErrorStatus, "q*":U, "yes-no":U, ThisMessage).
       END.  /* If the string exists */
       ELSE DO:  /* The string to replace isn't there */
         ThisMessage = Replace + " isn't contained in " +
                       xlatedb.XL_GlossDet.TargetPhrase + ".":U.
         RUN adecomm/_s-alert.p (INPUT-output ErrorStatus, "w*":U, "ok":U, ThisMessage).
         ErrorStatus = no.
       END.
     END.  /* The user should be asked */
     IF ASK NE "ASK":U THEN ErrorStatus = TRUE.
     IF ErrorStatus THEN DO:  /* Do it */
       IF xlatedb.XL_GlossDet.TargetPhrase = "" AND replace = "" THEN
         ASSIGN xlatedb.XL_GlossDet.TargetPhrase = replacevalue
                xlatedb.XL_GlossDet.ShortTarg    = SUBSTRING(xlatedb.XL_GlossDet.TargetPhrase,
                                                      1, 63, "RAW":U).
       ELSE IF LENGTH(replace, "RAW":U) > 0 THEN
         ASSIGN xlatedb.XL_GlossDet.TargetPhrase = REPLACE(xlatedb.XL_GlossDet.TargetPhrase,
                                                 replace, replacevalue)
                xlatedb.XL_GlossDet.ShortTarg    = SUBSTRING(xlatedb.XL_GlossDet.TargetPhrase,
                                                      1, 63, "RAW":U).
       RUN Ref in _hGloss (stringROWID).
     END.  /* Do it */
  END.  /* Glossary*/
  ELSE
  DO:
     FIND xlatedb.XL_Translation WHERE 
        ROWID(xlatedb.XL_Translation) = translationROWID 
     EXCLUSIVE-LOCK NO-ERROR.

     IF ask = "ASK":U AND NOT _SuppressReplaceAsk THEN 
     DO:
       IF NOT AVAILABLE xlatedb.XL_Translation THEN
       DO:
         FIND FIRST xlatedb.XL_String_Info WHERE
            ROWID(xlatedb.XL_String_Info) = stringROWID NO-LOCK NO-ERROR.
         ThisMessage = xlatedb.XL_String_Info.original_string 
                       + " isn't translated yet, therefore "
                       + Replace + " isn't contained in the translation.".
         RUN adecomm/_s-alert.p (INPUT-output ErrorStatus, 
             "w*":U, "ok":U, ThisMessage).
         ErrorStatus = no.
       END. /* No translation */
       ELSE IF xlatedb.XL_Translation.trans_string MATCHES 
          "*":U + Replace + "*":U THEN
       DO:
          ThisMessage = "Do you want to replace ~"" + replace + "~" in: " + 
                       xlatedb.XL_Translation.trans_string + "?":U.
          RUN adecomm/_s-alert.p (INPUT-output ErrorStatus, 
                "q*":U, "yes-no":U, ThisMessage).
       END.  /* If the string exists */
       ELSE 
       DO:  /* The string to replace isn't there */
             ThisMessage = Replace + " isn't contained in " +
                       xlatedb.XL_Translation.trans_string + ".":U.
             RUN adecomm/_s-alert.p (INPUT-output ErrorStatus, 
                "w*":U, "ok":U, ThisMessage).
             ErrorStatus = no.
       END. /* Translation but the string to replace is not there */
     END.  /* The user should be asked */

     IF ASK NE "ASK":U THEN ErrorStatus = TRUE.
     IF ErrorStatus THEN 
     DO:  /* Do it */
       IF xlatedb.XL_Translation.trans_string = "" AND replace = "" THEN
         ASSIGN xlatedb.XL_Translation.trans_string = replacevalue.
       ELSE IF LENGTH(replace, "RAW":U) > 0 THEN
         ASSIGN xlatedb.XL_Translation.trans_string = REPLACE(xlatedb.XL_Translation.trans_string,
                                                 replace, replacevalue).
       RUN Repo IN _hTrans (INPUT stringROWID,
                            INPUT instanceROWID,
                            INPUT translationROWID,
                            ?).
     END. /* Do it */
  END. /* Translation */
END PROCEDURE. /* replace-string */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReplaceGloss.ip ReplaceWindow 
PROCEDURE ReplaceGloss.ip :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE stringROWID AS ROWID                               NO-UNDO. 
  DO WITH FRAME DEFAULT-FRAME:
     ASSIGN FindValue
            Replace
            ReplaceValue
            tVal         = FindValue.
         CASE FindType:SCREEN-VALUE:
           WHEN "S":U THEN 
           DO:
             {adetran/pm/_replace.i xlatedb.XL_GlossDet SourcePhrase NEXT}
           END.
           WHEN "T":U THEN 
           DO:
             {adetran/pm/_replace.i xlatedb.XL_GlossDet TargetPhrase NEXT}
           END.
         END CASE.  /* Case on FindType */
             
         IF AVAIL xlatedb.XL_GlossDet THEN 
         DO:
           ASSIGN stringROWID = ROWID(xlatedb.XL_GlossDet).
           RUN Ref in _hGloss (stringROWID).
           RUN replace-string (INPUT "GLOSS":U, 
                               INPUT "ASK":U, 
                               INPUT stringROWID,
                               INPUT ?,
                               INPUT ?).
         END. /* Found item */
         ELSE 
         DO:
           FIND FIRST xlatedb.XL_GlossDet where
                      xlatedb.XL_GlossDet.GlossaryName = s_Glossary
                    NO-LOCK NO-ERROR.
           FIND PREV  xlatedb.XL_GlossDet where
                      xlatedb.XL_GlossDet.GlossaryName = s_Glossary
                   NO-LOCK NO-ERROR.
           MESSAGE "Replace Item Was Not Found." VIEW-AS ALERT-BOX INFORMATION.
         END. /* Glossary Item not found */
  END. /* DO WITH FRAME DEFAULT-FRAME */
END PROCEDURE. /* replace.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReplaceTran.ip ReplaceWindow 
PROCEDURE ReplaceTran.ip :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE stringROWID AS ROWID                               NO-UNDO. 
  DEFINE VARIABLE instanceROWID AS ROWID                             NO-UNDO.
  DEFINE VARIABLE translationROWID AS ROWID                          NO-UNDO.                                                 

  DO WITH FRAME DEFAULT-FRAME:
     ASSIGN FindValue
            Replace
            ReplaceValue
            tVal         = FindValue.
         CASE FindType:SCREEN-VALUE:
           WHEN "S":U THEN 
           DO:
             {adetran/pm/findtsn.i SourcePhrase NEXT}
           END.
           WHEN "T":U THEN 
           DO:
             {adetran/pm/findttrg.i TargetPhrase NEXT}
           END.
         END CASE.  /* Case on FindType */
             
         IF AVAILABLE xlatedb.XL_String_Info AND AVAILABLE xlatedb.XL_Instance THEN 
         DO:
           IF NOT AVAILABLE xlatedb.XL_Translation THEN
              FIND FIRST xlatedb.XL_Translation WHERE 
                     xlatedb.XL_Translation.sequence_num = xlatedb.XL_Instance.sequence_num
                 AND xlatedb.XL_Translation.instance_num = xlatedb.XL_Instance.instance_num
              NO-LOCK NO-ERROR.
           ASSIGN
                 stringROWID = ROWID(xlatedb.XL_String_Info)
                 instanceROWID = ROWID(xlatedb.XL_Instance)
                 translationROWID = IF AVAILABLE xlatedb.XL_Translation THEN
                                       ROWID(xlatedb.XL_Translation)
                                    ELSE
                                       ?.
           RUN replace-string (INPUT "TRANS":U, 
                                  INPUT "ASK":U, 
                                  INPUT stringROWID,
                                  INPUT instanceROWID,
                                  INPUT translationROWID).
         END. /* Found item */
         ELSE 
         DO:
           FIND FIRST xlatedb.XL_String_Info NO-LOCK NO-ERROR.
           FIND PREV  xlatedb.XL_String_Info NO-LOCK NO-ERROR.
           FIND FIRST xlatedb.XL_Instance WHERE
              xlatedb.XL_String_Info.sequence_num = xlatedb.XL_Instance.sequence_num
           NO-LOCK NO-ERROR.
           FIND PREV  xlatedb.XL_Instance WHERE 
              xlatedb.XL_String_Info.sequence_num = xlatedb.XL_Instance.sequence_num
           NO-LOCK NO-ERROR.

           MESSAGE "Replace Item Was Not Found." VIEW-AS ALERT-BOX INFORMATION.
         END. /* Glossary Item not found */
  END. /* DO WITH FRAME DEFAULT-FRAME */
END PROCEDURE. /* replace.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReplaceAllTran.ip ReplaceWindow 
PROCEDURE ReplaceAllTran.ip :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE enough-is-enough          AS LOGICAL                 NO-UNDO.
  DEFINE VARIABLE stringROWID               AS ROWID                   NO-UNDO.
  DEFINE VARIABLE instanceROWID             AS ROWID                   NO-UNDO.
  DEFINE VARIABLE translationROWID          AS ROWID                   NO-UNDO.

  DO WITH FRAME DEFAULT-FRAME:
     ASSIGN FindValue
            Replace
            ReplaceValue
            tVal         = FindValue.
          FIND FIRST xlatedb.XL_String_Info NO-LOCK NO-ERROR.
          FIND PREV xlatedb.XL_String_Info NO-LOCK NO-ERROR.
          FIND FIRST xlatedb.XL_Instance WHERE
             xlatedb.XL_Instance.sequence_num = xlatedb.XL_String_Info.sequence_num
             NO-LOCK NO-ERROR.
          FIND PREV xlatedb.XL_Instance WHERE
             xlatedb.XL_Instance.sequence_num = xlatedb.XL_String_Info.sequence_num
          NO-LOCK NO-ERROR.
          REPEAT WHILE NOT enough-is-enough:

            CASE FindType:SCREEN-VALUE:
              WHEN "S":U THEN 
              DO:
                {adetran/pm/findtsn.i SourcePhrase NEXT}
              END.
              WHEN "T":U THEN 
              DO:
                {adetran/pm/findttrg.i TargetPhrase NEXT}
              END.
            END CASE.
            IF AVAILABLE xlatedb.XL_String_Info AND AVAILABLE xlatedb.XL_Instance THEN
            DO:
                 FIND FIRST xlatedb.XL_Translation WHERE 
                        xlatedb.XL_Translation.sequence_num = xlatedb.XL_Instance.sequence_num
                    AND xlatedb.XL_Translation.instance_num = xlatedb.XL_Instance.instance_num
                 NO-LOCK NO-ERROR.
                 ASSIGN
                    stringROWID      = ROWID(xlatedb.XL_String_Info)
                    instanceROWID    = ROWID(xlatedb.XL_Instance)
                    translationROWID = IF AVAILABLE xlatedb.XL_Translation THEN
                                          ROWID(xlatedb.XL_Translation)
                                       ELSE
                                          ?.
                 RUN replace-string (INPUT "TRANS":U, 
                                     INPUT "ASK":U, 
                                     INPUT stringROWID,
                                     INPUT instanceROWID,
                                     INPUT translationROWID).
            END. /* Item Found */
            ELSE 
               ASSIGN enough-is-enough = TRUE.
          END. /* REPEAT */
   END. /* DO WITH FRAME DEFAULT-FRAME */
END PROCEDURE. /* replaceAll.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ReplaceAllGloss.ip ReplaceWindow 
PROCEDURE ReplaceAllGloss.ip :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE enough-is-enough          AS LOGICAL                 NO-UNDO.
  DEFINE VARIABLE stringROWID AS ROWID                               NO-UNDO. 

  DO WITH FRAME DEFAULT-FRAME:
     ASSIGN FindValue
            Replace
            ReplaceValue
            tVal         = FindValue.
          FIND FIRST xlatedb.XL_GlossDet WHERE 
                   xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
          FIND PREV xlatedb.XL_GlossDet WHERE 
                   xlatedb.XL_GlossDet.GlossaryName = s_Glossary NO-LOCK NO-ERROR.
          REPEAT WHILE NOT enough-is-enough:
            CASE FindType:SCREEN-VALUE:
              WHEN "S":U THEN 
              DO:
                {adetran/pm/_replace.i  xlatedb.XL_GlossDet SourcePhrase NEXT}
              END.
              WHEN "T":U THEN 
              DO:
                {adetran/pm/_replace.i  xlatedb.XL_GlossDet TargetPhrase NEXT}
              END.
            END CASE.
            IF AVAILABLE xlatedb.XL_GlossDet THEN 
            DO:
              ASSIGN stringROWID = ROWID(xlatedb.XL_GlossDet).
              RUN replace-string (INPUT "GLOSS":U, 
                                  INPUT "ASK":U, 
                                  INPUT stringROWID,
                                  INPUT ?,
                                  INPUT ?).
            END.
            ELSE enough-is-enough = TRUE.
          END. /* REPEAT */
   END. /* DO WITH FRAME DEFAULT-FRAME */
END PROCEDURE. /* replaceAll.ip */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE refresh.ip FindWindow 
PROCEDURE refresh.ip:
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


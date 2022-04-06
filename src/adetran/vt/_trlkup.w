&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          kit              PROGRESS
*/
&Scoped-define WINDOW-NAME TransLkUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS TransLkUp 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/vt/_trlkup.w
Author:       F. Chang
Created:      1/95 
Updated:      9/95
Purpose:      Visual Translator's Translation Lookup (Glossary)
Background:   This is a persistent procedure that is run from
              vt/_main.p *only* after a database is connected.
              Once connected, this procedure controls a hidden
              glossary lookup window that is invoked from the
              translation tab folder via a double-click of ALT/G.
Notes:        This window is used by translator who are using
              the edit-mode of the translation tab.  This 
              functionality is approximately the same as what you
              would find in the Properties Window when you are 
              doing a match on a 'SourcePhrase' or token.
Procedures:   Key procedures include: 
                 Realize       makes the window visable and opens
                               the query.
                 OpenQry       opens the query normally
                 OpenWIQry     opens the query with word-indexing  
Called By:    vt/_trans.p
Run By:       vt/_main.p
*/

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{ adetran/vt/vthlp.i } /* definitions for help context strings */ 
define var hlkup as handle no-undo.
define shared var GlossaryOnTop as logical no-undo.
define shared var hTrans  as handle no-undo.                          
define shared var MainWindow as widget-handle no-undo.  
define var rc as integer init 0.    
define var ThisMessage as char no-undo.
define var ErrorStatus as logical no-undo.
DEFINE BUFFER GlossEnt FOR kit.XL_GlossEntry.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME DEFAULT-FRAME
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES kit.XL_GlossEntry

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 kit.XL_GlossEntry.TargetPhrase 
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1 
&Scoped-define FIELD-PAIRS-IN-QUERY-BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY BROWSE-1 FOR EACH kit.XL_GlossEntry ~
      WHERE kit.XL_GlossEntry.ShortSrc BEGINS SUBSTRING(tmp-strng, 1, 63, "RAW":U) AND ~
            kit.XL_GlossEntry.SourcePhrase MATCHES  tmp-strng NO-LOCK.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 kit.XL_GlossEntry
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 kit.XL_GlossEntry


/* Definitions for FRAME DEFAULT-FRAME                                  */
&Scoped-define OPEN-BROWSERS-IN-QUERY-DEFAULT-FRAME ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 BtnOk SourcePhrase BtnCancel ~
ChoiceLabel BROWSE-1 BtnHelp UseWordIdx 
&Scoped-Define DISPLAYED-OBJECTS SourcePhrase ChoiceLabel UseWordIdx 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR TransLkUp AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON BtnCancel 
     LABEL "Close" 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnHelp 
     LABEL "&Help" 
     SIZE 15 BY 1.125.

DEFINE BUTTON BtnOk 
     LABEL "OK" 
     SIZE 15 BY 1.125.

DEFINE VARIABLE SourcePhrase AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Source" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 43 BY 1
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE ChoiceLabel AS CHARACTER FORMAT "X(256)":U INITIAL "&Choices:" 
      VIEW-AS TEXT 
     SIZE 7 BY .62 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 54 BY 5.67.

DEFINE VARIABLE UseWordIdx AS LOGICAL INITIAL no 
     LABEL "Use &Word Indexing" 
     VIEW-AS TOGGLE-BOX
     SIZE 43 BY 1 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      kit.XL_GlossEntry SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 TransLkUp _STRUCTURED
  QUERY BROWSE-1 NO-LOCK DISPLAY
      kit.XL_GlossEntry.TargetPhrase FORMAT "X(55)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS SIZE 43 BY 3.24
         BGCOLOR 15 FONT 4.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME DEFAULT-FRAME
     BtnOk AT ROW 1.52 COL 58
     SourcePhrase AT ROW 1.86 COL 10 COLON-ALIGNED
     BtnCancel AT ROW 2.81 COL 58
     ChoiceLabel AT ROW 2.86 COL 3 COLON-ALIGNED NO-LABEL
     BROWSE-1 AT ROW 2.86 COL 12
     BtnHelp AT ROW 4.05 COL 58
     UseWordIdx AT ROW 6.05 COL 12
     RECT-1 AT ROW 1.52 COL 3
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 73 BY 6.86
         BGCOLOR 8 FGCOLOR 0 FONT 4
         DEFAULT-BUTTON BtnOk CANCEL-BUTTON BtnCancel.

 

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
  CREATE WINDOW TransLkUp ASSIGN
         HIDDEN             = YES
         TITLE              = "Glossary"
         HEIGHT             = 6.86
         WIDTH              = 73
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 22
         VIRTUAL-WIDTH      = 80
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

IF NOT TransLkUp:LOAD-ICON("adetran/images/props%":U) THEN
    MESSAGE "Unable to load icon: adetran/images/props%"
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW TransLkUp
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME DEFAULT-FRAME
  VISIBLE,,RUN-PERSISTENT                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(TransLkUp)
THEN TransLkUp:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _TblList          = "kit.XL_GlossEntry"
     _Options          = "NO-LOCK"
     _OrdList          = "kit.XL_GlossEntry.ShortTarg|yes"
     _Where[1]         = "XL_GlossEntry.SourcePhrase MATCHES 
 replace(SourcePhrase:screen-value in FRAME {&FRAME-NAME},""&"","""")"
     _FldNameList[1]   > kit.XL_GlossEntry.TargetPhrase
"XL_GlossEntry.TargetPhrase" ? "X(55)" "Character" ? ? ? ? ? ? no ?
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME TransLkUp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TransLkUp TransLkUp
ON END-ERROR OF TransLkUp /* Glossary */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  RUN HideMe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TransLkUp TransLkUp
ON WINDOW-CLOSE OF TransLkUp /* Glossary */
DO:  
  RUN HideMe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 TransLkUp
ON DEFAULT-ACTION OF BROWSE-1 IN FRAME DEFAULT-FRAME
DO:
  APPLY "CHOOSE":u TO BtnOk.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnCancel TransLkUp
ON CHOOSE OF BtnCancel IN FRAME DEFAULT-FRAME /* Close */
DO:
  RUN HideMe.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnHelp TransLkUp
ON CHOOSE OF BtnHelp IN FRAME DEFAULT-FRAME /* Help */
OR HELP OF FRAME DEFAULT-FRAME 
DO:
  RUN adecomm/_adehelp.p ("vt":u,"context":u,{&Gloss_win}, ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME BtnOk
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BtnOk TransLkUp
ON CHOOSE OF BtnOk IN FRAME DEFAULT-FRAME /* OK */
DO:
  if browse-1:num-selected-rows < 1 then
  do:  
    ThisMessage = "You have not selected a glossary entry.".
    RUN adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).          
    return no-apply.
  end.
                            
  if (avail kit.XL_GlossEntry) and
     can-find(kit.xl_invalid where kit.xl_Invalid.TargetPhrase MATCHES
              kit.XL_GlossEntry.TargetPhrase) then
  do: 
    ThisMessage = "This translation is invalid.".
    RUN adecomm/_s-alert.p (input-output ErrorStatus, "w*":u, "ok":u, ThisMessage).          
  end. 
  else
  do:              
    if avail kit.XL_GlossEntry then do:
         RUN UpdateInstance in hTrans (kit.XL_GlossEntry.TargetPhrase).
    end.
    else                                                            
         RUN UpdateInstance in hTrans ("").
  end.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME SourcePhrase
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL SourcePhrase TransLkUp
ON VALUE-CHANGED OF SourcePhrase IN FRAME DEFAULT-FRAME /* Source */
DO:
  RUN adecomm/_setcurs.p("wait":u).
  RUN OpenQry.
  RUN adecomm/_setcurs.p("").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME UseWordIdx
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL UseWordIdx TransLkUp
ON VALUE-CHANGED OF UseWordIdx IN FRAME DEFAULT-FRAME /* Use Word Indexing */
DO:
  RUN Openqry.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK TransLkUp 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.
     

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:  
/*
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:  
*/
DO ON STOP  UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  assign
    ChoiceLabel:screen-value  = "Choices:"
    ChoiceLabel:width         = font-table:get-text-width-chars (trim(ChoiceLabel:screen-value),4)
    ChoiceLabel:column        = (browse-1:column - ChoiceLabel:width) - .5
    SourcePhrase:DELIMITER    = CHR(3)
    TransLkUp:parent          = MainWindow:handle.
   
  RUN AlwaysOnTop.
  
  IF NOT THIS-PROCEDURE:PERSISTENT THEN
    WAIT-FOR CLOSE OF THIS-PROCEDURE focus TargetPhrase.
END.
{adecomm/_adetool.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AlwaysOnTop TransLkUp 
PROCEDURE AlwaysOnTop :
RUN adecomm/_topmost.p (input TransLkUp:hWnd, input GlossaryOnTop, output rc).
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE HideMe TransLkUp 
PROCEDURE HideMe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   translkup:hidden = true.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenQry TransLkUp 
PROCEDURE OpenQry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE tmp-strng AS CHARACTER                              NO-UNDO.
  
  tmp-strng = REPLACE(TRIM(SourcePhrase:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                        "&":U, "":U).

  IF UseWordIdx:CHECKED IN FRAME {&FRAME-NAME} THEN
    OPEN QUERY BROWSE-1 FOR EACH kit.XL_GlossEntry
          WHERE XL_GlossEntry.SourcePhrase CONTAINS tmp-strng NO-LOCK.
  ELSE {&open-query-browse-1}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Realize TransLkUp 
PROCEDURE Realize :
DEFINE INPUT PARAMETER pSource AS CHARACTER          NO-UNDO.
  DEFINE INPUT PARAMETER pTarget AS CHARACTER          NO-UNDO.
  DEFINE VARIABLE CurGlossRec    AS RECID              NO-UNDO.  
  DEFINE VARIABLE i              AS INTEGER            NO-UNDO.
  DEFINE VARIABLE iLoc           AS INTEGER            NO-UNDO.
  DEFINE VARIABLE num-words      AS INTEGER            NO-UNDO.
  DEFINE VARIABLE stupid         AS LOGICAL            NO-UNDO.
  DEFINE VARIABLE TempString     AS CHARACTER          NO-UNDO.
  DEFINE VARIABLE word-string    AS CHARACTER          NO-UNDO.
  DEFINE VARIABLE working-string AS CHARACTER          NO-UNDO.

  DO WITH FRAME {&FRAME-NAME}: 
    ASSIGN pSource    = TRIM(pSource)
           TempString = pSource
           working-string = TRIM(pSource).

    /* using INDEX instead of 
     *     num-words  = NUM-ENTRIES(pSource, " ":U).   
     * because some clients have leading/trailing and in between xtra spaces 
     */
    DO WHILE TRUE:
       ASSIGN
          iLoc = INDEX(working-string," ":U)
          word-string = IF iLoc = 0 THEN
                           working-string
                        ELSE
                           SUBSTRING(working-string,1,iLoc - 1)
          TempString = TempString + CHR(3) + word-string.
       IF iLoc = 0 THEN LEAVE.
       ASSIGN working-string = TRIM(SUBSTRING(working-string,iLoc + 1)).
    END.
    
    ASSIGN SourcePhrase               = TempString
           SourcePhrase:LIST-ITEMS    = TRIM(SourcePhrase)
           SourcePhrase:SCREEN-VALUE  = SourcePhrase:ENTRY(1)
           FRAME {&FRAME-NAME}:HIDDEN = FALSE 
           translkup:HIDDEN           = FALSE
           /* Ensure the window cannot be resized or maximized. */
           {&WINDOW-NAME}:MAX-WIDTH   = {&WINDOW-NAME}:WIDTH
           {&WINDOW-NAME}:MAX-HEIGHT  = {&WINDOW-NAME}:HEIGHT
           CurGlossRec                = ?.
           
    ENABLE
      SourcePhrase   
      ChoiceLabel
      browse-1
      UseWordIdx
      BtnOK
      BtnCancel
      BtnHelp
    WITH FRAME {&FRAME-NAME} IN WINDOW translkup.

    FIND FIRST GlossEnt WHERE GlossEnt.ShortSrc BEGINS SUBSTRING(REPLACE(SourcePhrase:ENTRY(1),
                                   "&":U,"":U), 1, 63, "RAW":U) AND
                              GlossEnt.TargetPhrase MATCHES TRIM(pTarget) NO-LOCK NO-ERROR.
    IF AVAILABLE GlossEnt THEN CurGlossRec = RECID(GlossEnt).
  
    RUN OpenQry.
    
    APPLY "ENTRY":U TO BtnOK.

    IF CurGlossRec NE ? THEN DO:
      Stupid = BROWSE-1:SET-REPOSITIONED-ROW(3, "CONDITIONAL":U).
      REPOSITION BROWSE-1 TO RECID CurGlossRec NO-ERROR.
    END.           
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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

  File: _ttmaint.w

  Description: Temp-table maintenance dialog-box

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Ross Hunter

  Created: 12/1996
  
  Modified by
    gfs    03/12/99 - Disallow TTs with same name as data object tables
    hd     07/15/98 - Removed _TT._TABLE-TYPE = "U". 
    hd     07/11/98 - Exclude _TT._TABLE-TYPE = "U" - User Fields. 
                      Using a preprocessor for the WHERE clause, because 
                      there currently is a bug that prevents freeform 
                      queries to exceed two lines. That is perhaps the reason 
                      the "W" and "D" tables not were excluded from the 
                      query. 
                                            
                      There was a lot of logic that assumed that 
                      gen-tt-def only should generate code for the current _TT
                      But it actually had a for each. 
                      I took away the for each in gen-tt-def.
                  
    dma on 04/01/98 - Exclude _TT._TABLE-TYPE = "W" - WebSpeed temp-table 
                      from being displayed.
    jep on 03/12/98 - Exclude _TT._TABLE-TYPE = "D" - DataObject RowObject
                      temp-table from being displayed.
    gfs on 01/09/97 - Added help context for help button
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

DEFINE VARIABLE err-status  AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE row-recid   AS RECID                              NO-UNDO.
DEFINE VARIABLE stupid      AS LOGICAL                            NO-UNDO.
DEFINE VARIABLE ThisMessage AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE tblsToAvoid AS CHARACTER                          NO-UNDO.
DEFINE VARIABLE inpLine     AS CHARACTER EXTENT 4                 NO-UNDO.
DEFINE VARIABLE i           AS INTEGER                            NO-UNDO.
DEFINE VARIABLE tblList     AS CHARACTER                          NO-UNDO.
define variable wintitle    as character NO-UNDO init "Temp-Table Maintenance".
DEFINE VARIABLE pressed_ok   AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE tmp-dbname   AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE tmp-tblname  AS CHARACTER                    NO-UNDO.
DEFINE STREAM test.         /* Used for syntax checking                 */

DEFINE BUFFER x_TT FOR _TT.
&SCOP whereclause WHERE _TT._p-recid = RECID(_p) AND~
                   NOT CAN-DO("D,W":U,_TT._TABLE-TYPE)~
                   BY IF _TT._NAME NE ? THEN _TT._NAME ELSE _TT._LIKE-TABLE

DEFINE BUFFER x_U FOR _U.
DEFINE BUFFER x_C FOR _C.
DEFINE BUFFER x_Q FOR _Q.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DIALOG-BOX
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME Dialog-Frame
&Scoped-define BROWSE-NAME BROWSE-1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES _TT

/* Definitions for BROWSE BROWSE-1                                      */
&Scoped-define FIELDS-IN-QUERY-BROWSE-1 (IF _TT._NAME NE ? THEN _TT._NAME ELSE _TT._LIKE-TABLE) + (IF _TT._TABLE-TYPE = "T":U THEN " LIKE ":U ELSE " FOR ":U) + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE   
&Scoped-define ENABLED-FIELDS-IN-QUERY-BROWSE-1   
&Scoped-define SELF-NAME BROWSE-1
&Scoped-define OPEN-QUERY-BROWSE-1 OPEN QUERY {&SELF-NAME} FOR EACH _TT {&whereclause}.
&Scoped-define TABLES-IN-QUERY-BROWSE-1 _TT
&Scoped-define FIRST-TABLE-IN-QUERY-BROWSE-1 _TT


/* Definitions for DIALOG-BOX Dialog-Frame                              */
&Scoped-define OPEN-BROWSERS-IN-QUERY-Dialog-Frame ~
    ~{&OPEN-QUERY-BROWSE-1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS BROWSE-1 btn_add btn_remove RADIO-SET-1 ~
RADIO-SET-2 tog-no-undo tbl-name additnl-fields chk-syntax RECT-2 RECT-3 ~
RECT-4 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 RADIO-SET-2 tog-no-undo ~
tbl-name additnl-fields tt-label prp-label af-label 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON btn_add 
     LABEL "&Add..." 
     SIZE 15 BY 1.14.

DEFINE BUTTON btn_remove 
     LABEL "&Remove" 
     SIZE 15 BY 1.14.

DEFINE BUTTON chk-syntax 
     LABEL "&Check Syntax" 
     SIZE 16 BY 1.14.

DEFINE VARIABLE additnl-fields AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 46 BY 2.95
     FONT 2 NO-UNDO.

DEFINE VARIABLE af-label AS CHARACTER FORMAT "X(256)":U INITIAL "Additional &Fields:" 
      VIEW-AS TEXT 
     SIZE 16 BY .62 NO-UNDO.

DEFINE VARIABLE prp-label AS CHARACTER FORMAT "X(256)":U INITIAL " Properties:" 
      VIEW-AS TEXT 
     SIZE 12 BY .62 NO-UNDO.

DEFINE VARIABLE tbl-name AS CHARACTER FORMAT "X(256)":U 
     LABEL "&Table Name" 
     VIEW-AS FILL-IN 
     SIZE 46 BY 1 NO-UNDO.

DEFINE VARIABLE tt-label AS CHARACTER FORMAT "X(256)":U INITIAL "Temp-Tables:" 
      VIEW-AS TEXT 
     SIZE 14 BY .62 NO-UNDO.

DEFINE VARIABLE RADIO-SET-1 AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NEW GLOBAL SHARED", "NEW GLOBAL SHARED",
"NEW SHARED", "NEW SHARED",
"SHARED", "SHARED",
"(Local)", ""
     SIZE 29 BY 2.95 NO-UNDO.

DEFINE VARIABLE RADIO-SET-2 AS CHARACTER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Temp-Table", "T",
"Buffer", "B"
     SIZE 22 BY 1.62 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 66 BY 9.14.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE .2 BY 4.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 29 BY .14.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62 BY 4.

DEFINE VARIABLE tog-no-undo AS LOGICAL INITIAL no 
     LABEL "NO-UNDO" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .76 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY BROWSE-1 FOR 
      _TT SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS BROWSE-1 Dialog-Frame _FREEFORM
  QUERY BROWSE-1 DISPLAY
      (IF _TT._NAME NE ? THEN _TT._NAME ELSE _TT._LIKE-TABLE) +
      (IF _TT._TABLE-TYPE = "T":U THEN " LIKE ":U ELSE " FOR ":U) +
       _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE FORMAT "X(100)"
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-LABELS NO-ROW-MARKERS NO-COLUMN-SCROLLING SIZE 50 BY 3.86
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME Dialog-Frame
     BROWSE-1 AT ROW 2 COL 3
     btn_add AT ROW 2.14 COL 54
     btn_remove AT ROW 3.43 COL 54
     RADIO-SET-1 AT ROW 7.48 COL 8 NO-LABEL
     RADIO-SET-2 AT ROW 7.19 COL 43 NO-LABEL
     tog-no-undo AT ROW 9.62 COL 43
     tbl-name AT ROW 11.24 COL 19 COLON-ALIGNED
     additnl-fields AT ROW 12.33 COL 21 NO-LABEL
     chk-syntax AT ROW 13.14 COL 4
     tt-label AT ROW 1.33 COL 1 COLON-ALIGNED NO-LABEL
     prp-label AT ROW 6.14 COL 2 COLON-ALIGNED NO-LABEL
     af-label AT ROW 12.33 COL 19.4 RIGHT-ALIGNED NO-LABEL
     RECT-2 AT ROW 6.38 COL 3
     RECT-3 AT ROW 6.91 COL 38
     RECT-4 AT ROW 8.91 COL 38
     RECT-5 AT ROW 6.91 COL 5
     SPACE(2.00) SKIP(4.62)
     WITH
     &if DEFINED(IDE-IS-RUNNING) = 0  &then  
     VIEW-AS DIALOG-BOX TITLE wintitle
     &else
     NO-BOX
     &endif
    KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         .

{adeuib/ide/dialoginit.i "FRAME Dialog-Frame:handle"}
&if DEFINED(IDE-IS-RUNNING) <> 0  &then
   dialogService:View(). 
&endif
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
/* BROWSE-TAB BROWSE-1 1 Dialog-Frame */
ASSIGN 
       FRAME Dialog-Frame:SCROLLABLE       = FALSE
       FRAME Dialog-Frame:HIDDEN           = TRUE.
&if DEFINED(IDE-IS-RUNNING) = 0  &then  
ASSIGN 
       additnl-fields:RETURN-INSERTED IN FRAME Dialog-Frame  = TRUE.
&endif
/* SETTINGS FOR FILL-IN af-label IN FRAME Dialog-Frame
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN prp-label IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tt-label IN FRAME Dialog-Frame
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE BROWSE-1
/* Query rebuild information for BROWSE BROWSE-1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH _TT {&whereclause}.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE BROWSE-1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME Dialog-Frame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON GO OF FRAME Dialog-Frame /* Temp-Table Maintenance */
DO:
  IF row-recid ne ? THEN RUN assign-record.
  /* 
   * Before we commit the dialog, check each table name against the
   * list of tables to avoid. Present an error for each match and
   * reposition the dialog to the table name field so that the user
   * can easily rename the table.
   */
  FOR EACH _TT:
    IF LOOKUP(_TT._NAME,tblsToAvoid) > 0 THEN DO:
      MESSAGE "You may not use """ _TT._NAME """ for a table name because it is already used in a corresponding data object."
        VIEW-AS ALERT-BOX INFORMATION.
      REPOSITION BROWSE-1 TO RECID RECID(_TT) NO-ERROR.
      RUN Display-Record.
      APPLY "ENTRY":U TO tbl-name.
      RETURN NO-APPLY.
    END.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL Dialog-Frame Dialog-Frame
ON WINDOW-CLOSE OF FRAME Dialog-Frame /* Temp-Table Maintenance */
DO:
  APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME BROWSE-1
&Scoped-define SELF-NAME BROWSE-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BROWSE-1 Dialog-Frame
ON VALUE-CHANGED OF BROWSE-1 IN FRAME Dialog-Frame
DO:
  IF row-recid NE ? THEN DO:
    RUN assign-record.
    ASSIGN row-recid = ?.
  END.  /* IF ROW-RECID NE ? */
  IF SELF:NUM-SELECTED-ROWS > 0 THEN DO WITH FRAME {&FRAME-NAME}:
    stupid = SELF:FETCH-SELECTED-ROW(1).
    ASSIGN row-recid      = RECID(_TT)
           stupid = SELF:SET-REPOSITIONED-ROW(MAX(1,SELF:FOCUSED-ROW),
                                                    "CONDITIONAL":U).
    RUN display-record.  
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_add Dialog-Frame
ON CHOOSE OF btn_add IN FRAME Dialog-Frame /* Add... */
DO:
    run chooseAddHandler.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btn_remove
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btn_remove Dialog-Frame
ON CHOOSE OF btn_remove IN FRAME Dialog-Frame /* Remove */
DO:
  DEFINE VARIABLE i AS INTEGER                                  NO-UNDO.
  
  IF BROWSE-1:NUM-SELECTED-ROWS = 0 THEN DO:
    ThisMessage = "You haven't selected a Temp-Table to remove.".
    RUN adecomm/_s-alert.p (INPUT-OUTPUT err-status, "W":U, "OK":U, ThisMessage).
    RETURN.
  END.
  RUN adecomm/_setcurs.p ("WAIT":U).
  DO i = BROWSE-1:NUM-SELECTED-ROWS TO 1 by -1:
    stupid = BROWSE-1:FETCH-SELECTED-ROW(i).
    DELETE _TT.
  END.
  stupid = BROWSE-1:DELETE-SELECTED-ROWS() NO-ERROR.
  row-recid = ?.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
  IF BROWSE-1:NUM-SELECTED-ROWS > 0 THEN DO:
    stupid = BROWSE-1:FETCH-SELECTED-ROW(1).
    ASSIGN row-recid = RECID(_TT).
    RUN display-record.
  END.
  ELSE RUN clear-screen.
  RUN adecomm/_setcurs.p ("":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME chk-syntax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL chk-syntax Dialog-Frame
ON CHOOSE OF chk-syntax IN FRAME Dialog-Frame /* Check Syntax */
DO:
  DEFINE VARIABLE def-line AS CHARACTER                         NO-UNDO.
  DEFINE VARIABLE tmpfile  AS CHARACTER                         NO-UNDO.
  
  IF CAN-FIND(FIRST _TT WHERE _TT._p-recid = RECID(_P)) THEN DO:
    RUN assign-record.
    RUN adecomm/_tmpfile.p ("T2":U, ".p":U, OUTPUT tmpfile).
    
    OUTPUT STREAM test TO VALUE(tmpfile) NO-MAP.
    
    /* TABLE-TYPE "D" is RowObject in DataObject, "W" is used by WebSpeed 
       for storing unmapped fields - we don't include either here. */
     
     /*HD 07/11/98  
    I'm assuming that the comments above are right ? 
    The code actually included "W" twice !    
    I don't understand the original intention, so the original code is
    kept inside the comments.
    get-tt-def also did FOR EACH _TT and it DID include 'W' and 'D' !     
    */ 
    FOR EACH _TT WHERE _TT._p-recid = RECID(_P) 
      AND NOT CAN-DO("D,W":U,_TT._TABLE-TYPE):
      IF RECID(_TT) = row-recid THEN RUN assign-record.
      ASSIGN _TT._START-BYTE = SEEK(test).
      RUN gen-tt-def (OUTPUT def-line).    /* Generate tt definition */
      PUT STREAM test UNFORMATTED def-line.
    END.
    
    OUTPUT STREAM test CLOSE.
    COMPILE VALUE(tmpfile) NO-ERROR.
    OS-DELETE VALUE(tmpfile).
  END.

  IF NOT COMPILER:ERROR THEN
    MESSAGE "Syntax is correct." VIEW-AS ALERT-BOX INFORMATION.
  ELSE DO: /* Else a syntax error */
    
    FIND LAST _TT WHERE _TT._p-recid = RECID(_P) AND
                        _TT._START-BYTE < COMPILER:FILE-OFFSET.
    IF AVAILABLE _TT THEN DO:
     
    
      RUN gen-tt-def (OUTPUT def-line).
      row-recid = RECID(_TT).
    
    END.
    ELSE def-line = "":U.
    
    MESSAGE ERROR-STATUS:GET-MESSAGE(1) + ".":U SKIP(1)
            def-line
            VIEW-AS ALERT-BOX ERROR.
  END.
  stupid = BROWSE-1:FETCH-SELECTED-ROW(1).
  IF row-recid NE RECID(_TT) THEN DO:
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
    stupid = BROWSE-1:FETCH-SELECTED-ROW(1).
    ASSIGN row-recid = RECID(_TT).
    RUN display-record.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-1 Dialog-Frame
ON VALUE-CHANGED OF RADIO-SET-1 IN FRAME Dialog-Frame
DO:
  IF NOT AVAILABLE _TT THEN RETURN.
  IF SELF:SCREEN-VALUE = "NEW GLOBAL SHARED":U AND
     RADIO-SET-2:SCREEN-VALUE = "B":U THEN DO:
    MESSAGE "It is illegal to have a NEW GLOBAL SHARED buffer."
       VIEW-AS ALERT-BOX ERROR.
    SELF:SCREEN-VALUE = _TT._SHARE-TYPE.
    RETURN NO-APPLY.
  END.
  ELSE _TT._SHARE-TYPE = SELF:SCREEN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME RADIO-SET-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RADIO-SET-2 Dialog-Frame
ON VALUE-CHANGED OF RADIO-SET-2 IN FRAME Dialog-Frame
DO:
  ASSIGN _TT._TABLE-TYPE          = SELF:SCREEN-VALUE
         additnl-fields:SENSITIVE = (SELF:SCREEN-VALUE = "T":U).

  /* Make sure the name is different from the FOR table and there are no
     additional fields if it is a buffer */
  IF SELF:SCREEN-VALUE = "B":U THEN DO:
    IF tbl-name:SCREEN-VALUE = "":U THEN
      ASSIGN tbl-name:SCREEN-VALUE       = "X_":U + _TT._LIKE-TABLE
             _TT._NAME                   = tbl-name:SCREEN-VALUE
             additnl-fields:SCREEN-VALUE = "":U
             _TT._ADDITIONAL_FIELDS      = "":U
             RADIO-SET-1:SCREEN-VALUE    =
                   IF RADIO-SET-1:SCREEN-VALUE = "NEW GLOBAL SHARED":U THEN
                                           "NEW SHARED":U ELSE
                                           RADIO-SET-1:SCREEN-VALUE
             _TT._SHARE-TYPE             = RADIO-SET-1:SCREEN-VALUE.
             
    ASSIGN tog-no-undo:CHECKED   = NO
           tog-no-undo:SENSITIVE = NO.
  END.
  ELSE DO:
    IF tbl-name:SCREEN-VALUE = "X_":U + _TT._LIKE-TABLE THEN
      ASSIGN tbl-name:SCREEN-VALUE = "":U
             _TT._NAME             = ?.
             
    ASSIGN tog-no-undo:CHECKED   = (_TT._UNDO-TYPE = "NO-UNDO":U)
           tog-no-undo:SENSITIVE = YES.
  END.
  {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tbl-name
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tbl-name Dialog-Frame
ON LEAVE OF tbl-name IN FRAME Dialog-Frame /* Table Name */
DO:
  IF (SELF:SCREEN-VALUE = "" AND _TT._NAME NE ?) OR
     (SELF:SCREEN-VALUE NE _TT._NAME) THEN DO:
    IF SELF:SCREEN-VALUE NE "":U THEN DO:
    /* Check to make sure that this name in not a duplicate */
      IF CAN-FIND(FIRST _TT WHERE RECID(_TT) NE row-recid AND
                  _TT._p-recid EQ RECID(_P) AND
                  (_TT._NAME = SELF:SCREEN-VALUE OR
                   (_TT._NAME = ? AND _TT._LIKE-TABLE = SELF:SCREEN-VALUE)))
      THEN DO:  /* Give error message and send them back to correct it */
        MESSAGE "You may not enter a duplicate table name."
          VIEW-AS ALERT-BOX ERROR.
        RETURN NO-APPLY.
      END.
    END.
    /* User has changed the name, update _tt and redisplay browse */
    FIND x_TT WHERE RECID(x_TT) = row-recid.
    x_TT._NAME = IF SELF:SCREEN-VALUE NE "":U THEN SELF:SCREEN-VALUE ELSE ?.
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
  END.
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
                 &CONTEXT = {&Temp_Table_Dlg_Box} }

/* For shortcut intended on the editor field */
ON ALT-F OF FRAME {&FRAME-NAME}
  APPLY "ENTRY" TO additnl-fields.
  
/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
  FIND _P WHERE _P._WINDOW-HANDLE = _h_win.
  /* 
   * For SDO,SDB & SDV, users cannot create TTs with the same name as
   * used in the SMO's, so build a list of table names to avoid so that
   * we can disallow them
   */
  IF _P._DATA-OBJECT NE "" THEN DO:
    /* Read .i for table names */
    ASSIGN FILE-INFO:FILE-NAME = ENTRY(1,_P._DATA-OBJECT,".":U) + ".i":U.
    IF FILE-INFO:FULL-PATHNAME NE ? THEN DO:
      INPUT FROM VALUE(FILE-INFO:FULL-PATHNAME).
      REPEAT ON ERROR UNDO, LEAVE:
        IMPORT inpLine. /* read a line */
        tblsToAvoid = (IF INDEX(tblsToAvoid,ENTRY(1,inpLine[4],".":U)) = 0 THEN 
                         tblsToAvoid + ENTRY(1,inpLine[4],".":U) + "," 
                       ELSE tblsToAvoid). /* extract the table name */
      END.   
      INPUT CLOSE.
    END.
  END.
  ELSE DO:
    /* See if it's a SmartDataObject */
    FIND x_U WHERE x_U._WINDOW-HANDLE = _h_win AND 
      x_U._TYPE    = "Query":U                 AND
      x_U._SUBTYPE = "SmartDataObject":U       NO-ERROR.
    IF AVAILABLE (x_U) THEN DO:
      FIND x_C WHERE RECID(x_C) = x_U._x-recid NO-ERROR.
      IF AVAILABLE (x_C) THEN
        FIND x_Q WHERE RECID(x_Q) = x_C._q-recid NO-ERROR.
      IF AVAILABLE (x_Q) THEN 
      /* Run through table list and pluck out the table names w/o db */
      ASSIGN tblList = REPLACE(x_Q._TblList,"...","").
      DO i = 1 TO NUM-ENTRIES(tblList):
        CASE NUM-ENTRIES(ENTRY(i,tblList),".":U):
          /* Is it in the form "db.table"? */
          WHEN 2 THEN tblsToAvoid = tblsToAvoid + 
                        ENTRY(2,ENTRY(i,tblList),".":U) + ",":U.
          /* Is it in the form "db.table1 OF db.table2"? */
          WHEN 3 THEN tblsToAvoid = tblsToAvoid + 
                        ENTRY(1,ENTRY(2,ENTRY(i,tblList),".":U)," ":U) + ",":U.
        END CASE.
      END. /* DO i = 1 TO NUM-ENTRIES(tblList) */
    END. /* IF AVAILABLE (x_U) */
  END. /* ELSE _P._DATA-OBJECT is blank */
  IF tblsToAvoid NE "" THEN tblsToAvoid = RIGHT-TRIM(tblsToAvoid,",":U).
  
  DO WITH FRAME {&FRAME-NAME}:
    DO PRESELECT EACH _TT {&whereclause}:      
      FIND FIRST _TT NO-ERROR.
      IF NOT AVAILABLE _TT THEN RUN clear-screen.
      ELSE row-recid = RECID(_TT).
    END. /* DO Preselect */
    IF row-recid ne ? THEN DO:
      FIND _TT WHERE RECID(_TT) = row-recid.
      IF BROWSE-1:NUM-SELECTED-ROWS > 0 THEN DO:
        ASSIGN stupid    = BROWSE-1:FETCH-SELECTED-ROW(1)
               row-recid = RECID(_TT).
      END. /* If one is selected choose it */
    END.  /* Else we have at least one _TT record */
    RUN enable_UI.
    IF AVAILABLE _TT THEN RUN display-record.
    ELSE RUN clear-screen.
    /* Whole thing is a transaction to handle cancel action               */
    &scoped-define CANCEL-EVENT U2
    {adeuib/ide/dialogstart.i btn_ok btn_cancel wintitle}
    DO TRANSACTION:
      &if DEFINED(IDE-IS-RUNNING) = 0  &then
        WAIT-FOR GO OF FRAME {&FRAME-NAME}. 
    &ELSE
        WAIT-FOR "choose" of btn_ok in frame {&FRAME-NAME} or "u2" of this-procedure.       
        if cancelDialog THEN UNDO, LEAVE.  
    &endif  
      
    END.  /* Transaction */
  END.  /* DO WITH FRAME {&FRAME-NAME} */
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
  DO WITH FRAME {&FRAME-NAME}: 
    FIND FIRST _TT WHERE RECID(_TT) = row-recid.
    ASSIGN _TT._NAME             = IF tbl-name:SCREEN-VALUE = ""
                                      THEN ? 
                                      ELSE tbl-name:SCREEN-VALUE
           _TT._ADDITIONAL_FIELDS = additnl-fields:SCREEN-VALUE
           _TT._SHARE-TYPE        = RADIO-SET-1:SCREEN-VALUE
           _TT._TABLE-TYPE        = RADIO-SET-2:SCREEN-VALUE
           _TT._UNDO-TYPE         = IF tog-no-undo:CHECKED THEN "NO-UNDO":U
                                                           ELSE "":U.
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
             additnl-fields:SCREEN-VALUE = "":U
             BROWSE-1:SENSITIVE          = FALSE
             btn_remove:SENSITIVE        = FALSE
             chk-syntax:SENSITIVE        = FALSE
             RADIO-SET-1:SENSITIVE       = FALSE
             RADIO-SET-1:SCREEN-VALUE    = "NEW GLOBAL SHARED":U
             RADIO-SET-2:SENSITIVE       = FALSE
             RADIO-SET-2:SCREEN-VALUE    = "T":U
             tbl-name:SENSITIVE          = FALSE
             tbl-name:SCREEN-VALUE       = "":U
             tog-no-undo:SENSITIVE       = FALSE
             tog-no-undo:CHECKED         = TRUE.
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
    ASSIGN RADIO-SET-1:SCREEN-VALUE    = _TT._SHARE-TYPE
           RADIO-SET-2:SCREEN-VALUE    = _TT._TABLE-TYPE
           tog-no-undo:CHECKED         = (_TT._UNDO-TYPE = "NO-UNDO":U)
           tbl-name:SCREEN-VALUE       = IF _TT._NAME NE ? THEN _TT._NAME ELSE "":U
           additnl-fields:SCREEN-VALUE = _TT._ADDITIONAL_FIELDS
           additnl-fields:SENSITIVE    = (_TT._TABLE-TYPE = "T":U)
           tog-no-undo:SENSITIVE       = (_TT._TABLE-TYPE = "T":U).
    RUN sensitize.
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
  DISPLAY RADIO-SET-1 RADIO-SET-2 tog-no-undo tbl-name additnl-fields tt-label 
          prp-label af-label 
      WITH FRAME Dialog-Frame.
  ENABLE BROWSE-1 btn_add btn_remove RADIO-SET-1 RADIO-SET-2 tog-no-undo 
         tbl-name additnl-fields chk-syntax RECT-2 RECT-3 RECT-4 RECT-5 
      WITH FRAME Dialog-Frame.
  VIEW FRAME Dialog-Frame.
  {&OPEN-BROWSERS-IN-QUERY-Dialog-Frame}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE gen-tt-def Dialog-Frame 
PROCEDURE gen-tt-def :
/*------------------------------------------------------------------------------
  Purpose:  Fill up a character parameter with the temp-table definition    
  Parameters:  def-line
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER def-line AS CHARACTER                         NO-UNDO.
  
  DEFINE VAR addl_fields AS CHARACTER NO-UNDO.
  
  /* 07/10/98 HD This was called within a for each _TT   
  FOR EACH _TT WHERE _TT._p-recid = RECID(_P):
  */  
    CASE _TT._TABLE-TYPE:
      WHEN "T":U THEN DO:
        addl_fields = REPLACE(_TT._ADDITIONAL_FIELDS, CHR(10),
                             CHR(10) + "       ":U).
        def-line = def-line +
                   "DEFINE ":U + (IF _TT._SHARE-TYPE NE "" THEN
                   (_TT._SHARE-TYPE + " ":U) ELSE "") + "TEMP-TABLE " +
                   (IF _TT._NAME = ? THEN _TT._LIKE-TABLE ELSE _TT._NAME) +
                   (IF _TT._UNDO-TYPE = "NO-UNDO":U THEN " NO-UNDO":U ELSE "":U) +
                   " LIKE ":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE +
                   (IF _TT._ADDITIONAL_FIELDS NE "":U THEN (CHR(10) + "       ":U +
                    addl_fields + ".":U) ELSE ".") + CHR(10).
      END.
      
      WHEN "B":U THEN DO:
        def-line = def-line +
                   "DEFINE ":U + (IF _TT._SHARE-TYPE NE "" THEN
                   (_TT._SHARE-TYPE + " ":U) ELSE "") + "BUFFER " + _TT._NAME + 
                   " FOR ":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE + ".":U +
                   CHR(10).
      END.
      
      /** This is not necessary because this procedure never deals with "D,W,U" */
          
      WHEN "D":U OR WHEN "W":U THEN DO:    
        addl_fields = REPLACE(_TT._ADDITIONAL_FIELDS, CHR(10),
                             CHR(10) + "       ":U).
        IF _TT._NAME = "RowObject":U THEN
        DO: /* In case dataobject include file path contains spaces, we enclose
               its file reference in quotes. - jep */
            addl_fields = REPLACE(addl_fields, '~{', '~{"').
            addl_fields = REPLACE(addl_fields, '~}', '"~}').
        END.
        def-line = def-line + 
                   "DEFINE TEMP-TABLE " + _TT._NAME +
                   (IF _TT._ADDITIONAL_FIELDS NE "":U THEN (CHR(10) + "       ":U +
                    addl_fields + ".":U) ELSE ".") + CHR(10).
      END.
     
    END CASE.
  /** See comment at block start
  END.
  **/  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE chooseAddHandler Dialog-Frame 
PROCEDURE chooseAddHandler :
    &if DEFINED(IDE-IS-RUNNING) <> 0  &then
         dialogService:SetCurrentEvent(this-procedure,"OpenTableDialog").
         run runChildDialog in hOEIDEService (dialogService) .
    &else  
         run OpenTableDialog. 
    &endif  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE OpenTableDialog Dialog-Frame 
PROCEDURE OpenTableDialog  :

  IF row-recid NE ? THEN DO:
    RUN assign-record.
  END.
  IF BROWSE-1:NUM-SELECTED-ROWS in frame {&frame-name} > 0 THEN
     BROWSE-1:SET-REPOSITIONED-ROW(
                      MIN(MAX(1, BROWSE-1:FOCUSED-ROW + 1),
                          BROWSE-1:NUM-ITERATIONS),
                      "CONDITIONAL":U).

  CREATE _TT.
  ASSIGN _TT._p-recid = RECID(_P).
  RUN
       &if DEFINED(IDE-IS-RUNNING) <> 0  &then
       adeuib/ide/_dialog_tblsel.p 
       &else  
       adecomm/_tblsel.p 
       &endif                
           (FALSE, "_ttmaint.w":U ,
            INPUT-OUTPUT tmp-dbname,
            INPUT-OUTPUT tmp-tblname,
            OUTPUT pressed_ok).       
  IF NOT pressed_ok THEN DELETE _TT.

  ELSE DO:
    ASSIGN _TT._LIKE-DB                = tmp-dbname
           _TT._LIKE-TABLE             = tmp-tblname
           additnl-fields:SENSITIVE    = TRUE
           BROWSE-1:SENSITIVE          = TRUE
           btn_remove:SENSITIVE        = TRUE
           chk-syntax:SENSITIVE        = TRUE
           RADIO-SET-1:SENSITIVE       = TRUE
           RADIO-SET-2:SENSITIVE       = TRUE
           tbl-name:SENSITIVE          = TRUE
           tog-no-undo:SENSITIVE       = TRUE
           row-recid                   = RECID(_TT)
           _TT._NAME                   = _TT._LIKE-TABLE.
    RUN display-record.
    
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
    APPLY "ENTRY" TO tbl-name IN FRAME {&FRAME-NAME}.
  END.
END PROCEDURE.
  
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE sensitize Dialog-Frame 
PROCEDURE sensitize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DO WITH FRAME {&FRAME-NAME}:
    ASSIGN additnl-fields:SENSITIVE = (row-recid NE ?)
            btn_remove:SENSITIVE    = (row-recid NE ?)
            chk-syntax:SENSITIVE    = (row-recid NE ?)
            RADIO-SET-1:SENSITIVE   = (row-recid NE ?) 
            RADIO-SET-2:SENSITIVE   = (row-recid NE ?) 
            tbl-name:SENSITIVE      = (row-recid NE ?) 
            tog-no-undo:SENSITIVE   = (row-recid NE ?).
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

 

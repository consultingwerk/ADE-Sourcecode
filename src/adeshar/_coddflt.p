/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _coddflt.p

Description:
    Generate the default code sections for the UIB.  There are 15 default
    code templates:
        _DEFINITIONS         - the introductory section
        _DEFINE-QUERY        - The default FreeForm Query definition
        _DEFAULT-ENABLE      - The default Enabling procedure (excl. proc name)
        _DEFAULT-DISABLE     - The default Disabling procedure (excl. proc name)
        _DISPLAY-FIELDS      - Display fields of a browse (incl. ENABLED fields)
        _MAIN-BLOCK          - The default Main Code Block
        _INCLUDED-LIB        - Included Method Libraries Code Block 
        _CONTROL             - Default Trigger code                             
        _OPEN-QUERY          - OPEN QUERY statement of a query
        _PROCEDURE           - Default Procedure code
        _LOCAL-METHOD        - Template for Local SmartMethod.
        _OCX-EVENTPROC-TOP   - The top portion of an OCX event procedure
        _OCX-EVENTPROC-MID   - The middle portion of an OCX event procedure
        _OCX-EVENTPROC-END   - THe bottom part of an OCX event procedure
        _CONTROL-LOAD        - The VBX load internal procedure.
        _FUNCTION            - Default code for User Defined Function
        _DATA.VALIDATE       - Data Object Field Validation Procedure.
        _DATA.OUTPUT         - Data Object Field Output Procedure.
        _WEB.INPUT           - WEB INPUT procedure.
        _WEB.OUTPUT          - WEB OUTPUT procedure.
        _WEB-HTM-OFFSETS     - WEB HTM offsets procedure.
        
    and 4 ADM code templates
        _ADM-CREATE-OBJECTS  - Create Objects
        _ADM-SEND-RECORDS    - Send all records that we have access to
        _ADM-ROW-AVAILABLE   - Receive request to find records
        _DATA.CALCULATE      - Data Object Field Calculation Procedure
    
    We can also take the name of a procedure to run in this space.
    The call is made to this procedure:
       RUN VALUE(p_template) (INPUT INTEGER(RECID(_P), OUTPUT p_code).
    This will populate the code section with exactly what would appear
    in the Code Section Editor.  That is, for a procedure, it would include
    the "END PROCEDURE." at the bottom ,but not the "PROCEDURE name :" 
    at the top.                                             
       
Input Parameters:
    p_template - the type of code to generate (see list above).
    p_recid    - the RECID(_U) for the window (or dialog-box) [or widget] 
                 or the RECID(_BC) if a browse-column
 
Output Parameters:
    p_code     - the text created for this widget.

Author: Wm.T.Wood

Date Created: February 10, 1993
Last Modified:
  tsm 07/06/99 Only output format for browse columns when the format is not blank
  slk 06/11/98 Added _DATA.CALCULATE.
  jep 03/16/98 Changed _PDO.VALIDATION to _DATA.VALIDATION. Ditto for .OUTPUT.
  gfs 02/10/98 Changed disable-autozap to disable-auto-zap
  gfs 02/05/98 Changed use-autozap to disable-autozap
  gfs 02/04/98 Add support for browse column attrs. USE-AUTOZAP and AUTO-RETURN
  J. Palazzo Jan, 1997 Added _FUNCTION to support User Defined Functions
  Ross Hunter May 9, 1995 to support Freeform Queries
  Wm.T.Wood March, 1995 Strip out all the fancy parts of _DEFINITIONS and
        _MAIN-CODE-BLOCK because we now read those in from templates.
  J. Palazzo March, 1995 Added _LOCAL-METHOD template.        
  John Sadd April 8, 1994 to support Persistent Procedures.
  John Sadd April 15, 1994 to use {&WINDOW-NAME} not _U._NAME in M-B.
  John Sadd April 21, 1994 to use WAIT-FOR CLOSE OF T-P etc.
  John Sadd May 12, 1994 to set CURRENT-WINDOW as well as T-P:C-W
	(bug number 94-05-10-065).
  Wm.T.Wood June 21, 1994 to set CURRENT-WINDOW only if NOT T-P:P
	(bug number 94-06-08-004 CG3: CURRENT-WINDOW setting not needed)
  Wm.T.Wood July 7, 1994: Add ACTIVE-WINDOW as parent to dialog-boxes	
  Wm.T.Wood July 18, 1994: Don't DELETE PROCEDURE in disable_UI for dialogs
        (bug #94-07-18-021 default-code for dial:disable_UI)
  Wm.T.Wood July 24, 1994 Set CURRENT-WINDOW even if Persistent (PROGRESS
        "stacks" C-W.  Closing a window causes last C-W to become active.)
	
----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER     p_template  AS CHAR       NO-UNDO.
DEFINE INPUT  PARAMETER     p_recid     AS RECID      NO-UNDO.
DEFINE OUTPUT PARAMETER     p_code      AS CHAR       NO-UNDO.


{adeuib/uniwidg.i}           /* Definition of Universal Widget TEMP-TABLE    */
{adeuib/layout.i}
{adeuib/sharvars.i}  
{adecomm/adefext.i}          /* Define file extensions (including &UIB_NAME) */
{adeuib/triggers.i}
{adeuib/brwscols.i}          /* Brows column temptable definitions           */

/* FUNCTION PROTOTYPES */
FUNCTION db-fld-name RETURNS CHARACTER
  (INPUT rec-type AS CHARACTER, INPUT rec-recid AS RECID) IN _h_func_lib.
FUNCTION db-tbl-name RETURNS CHARACTER
  (INPUT db-tbl AS CHARACTER) IN _h_func_lib.

/* Standard End-of-line character - adjusted in 7.3A to be just chr(10) */
&Scoped-define EOL CHR(10)
&Scoped-define COMMENT-LINE ------------------------------------------------------------------------------
DEFINE VAR  comment-ln  AS CHAR       NO-UNDO INITIAL
  "------------------------------------------------------------------------------".

DEFINE VAR  cnt         AS INTEGER    NO-UNDO.
DEFINE VAR  col-hdl     AS HANDLE     NO-UNDO.
DEFINE VAR  file_name   AS CHAR       NO-UNDO.
DEFINE VAR  db_tbl      AS CHARACTER  NO-UNDO.
DEFINE VAR  db-list     AS CHAR       NO-UNDO.
DEFINE VAR  doit        AS LOGICAL    NO-UNDO.
DEFINE VAR  heading     AS CHAR       NO-UNDO.
DEFINE VAR  i           AS INTEGER    NO-UNDO.
DEFINE VAR  in_window   AS CHAR       NO-UNDO.
DEFINE VAR  j           AS INTEGER    NO-UNDO.
DEFINE VAR  per-pos     AS INTEGER    NO-UNDO.
DEFINE VAR  q_label     AS CHAR       NO-UNDO.
DEFINE VAR  tbllist     AS CHAR       NO-UNDO.
DEFINE VAR  tmp_name    AS CHAR       NO-UNDO.
DEFINE VAR  tmp_code    AS CHAR       NO-UNDO.
DEFINE VAR  tmp_line    AS CHAR       NO-UNDO.
DEFINE VAR  tmp_string  AS CHAR       NO-UNDO.
DEFINE VAR  token       AS CHAR       NO-UNDO.
DEFINE VAR  tmp_viewas  AS CHARACTER  NO-UNDO.

DEFINE BUFFER b_U      FOR _U.
DEFINE BUFFER f_U      FOR _U.
DEFINE BUFFER x_U      FOR _U.
DEFINE BUFFER x_F      FOR _F.
DEFINE BUFFER f_L      FOR _L.
DEFINE BUFFER x_L      FOR _L.
DEFINE BUFFER r_L      FOR _L.
DEFINE BUFFER nr_L     FOR _L.

DEFINE BUFFER xx_U     FOR _U.

/* Define a TEMP-TABLE to store fields to display for each database table
   in the frame */
DEFINE TEMP-TABLE ttList NO-UNDO
    FIELD dbtbl  AS CHAR 
    FIELD line   AS CHAR
    FIELD code   AS CHAR
  INDEX dbtbl IS PRIMARY UNIQUE dbtbl.


/* Find the Current Record and Procedure , and get some information about it. */
IF p_recid <> ? THEN DO:
  FIND _U WHERE RECID(_U) = p_recid NO-ERROR.
  IF NOT AVAILABLE _U THEN DO:
    FIND _BC WHERE RECID(_BC) = p_recid NO-ERROR.
    FIND b_U WHERE RECID(b_U) = _BC._x-recid.
  END.
  FIND _P WHERE _P._WINDOW-HANDLE = IF AVAILABLE _U THEN _U._WINDOW-HANDLE
                                                    ELSE b_U._WINDOW-HANDLE.
END.

IF (NUM-ENTRIES(p_template, ".") > 1) THEN
    ASSIGN p_template = "_":U + p_template.

/* Now create the code segment. */
p_code = "".

CASE p_template:

 /**************************************************************************/
  /*                             _DEFINITIONS                              */  
 /**************************************************************************/
  WHEN "_DEFINITIONS":U THEN DO:
    p_code = 
"/*------------------------------------------------------------------------" 
+ {&EOL} + {&EOL} +
"  File: " + {&EOL} + {&EOL} +
"  Description: " + {&EOL} + {&EOL} +
"  Input Parameters:" + {&EOL} + 
"      <none>" + {&EOL} + {&EOL} + 
"  Output Parameters:" + {&EOL} + 
"      <none>" + {&EOL} + {&EOL} + 
"  Author: " + {&EOL} + {&EOL} + 
"  Created: " + STRING(TODAY) + " - " + STRING(TIME,"hh:mm am") 
+ {&EOL} + {&EOL} +
"------------------------------------------------------------------------*/"
+ {&EOL} +
"/*          This .W file was created with the Progress " +
 "{&UIB_NAME}" + ".       */"
+ {&EOL} + 
"/*----------------------------------------------------------------------*/"
+ {&EOL} + {&EOL} +
"/* ***************************  Definitions  ************************** */"
+ {&EOL} + {&EOL} +
"/* Parameters Definitions ---                                           */"
+ {&EOL} + {&EOL} +
"/* Local Variable Definitions ---                                       */"
+ {&EOL}.
  END.	/* WHEN _DEFINITIONS */

 /**************************************************************************/
 /*                              _MAIN-BLOCK                               */  
 /**************************************************************************/
  WHEN "_MAIN-BLOCK":U THEN DO:
    p_code = 
 "/* ***************************  Main Block  *************************** */" +
       {&EOL} + {&EOL}.

    /* The main block differs depending on the type of window */
    IF (_U._TYPE = "WINDOW") THEN DO:
      p_code = p_code +
 "/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */" + {&EOL} +
        "CURRENT-WINDOW = ~{&WINDOW-NAME}." + {&EOL} + {&EOL} + 
 "/* Best default for GUI applications is...                              */" +
      {&EOL} +
      "PAUSE 0 BEFORE-HIDE." +
      {&EOL} + {&EOL} + 
 "/* Now enable the interface and wait for the exit condition.            */" +
  {&EOL} +
 "/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */" +
  {&EOL} +
      "MAIN-BLOCK:" + {&EOL} + 
      "DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK" + {&EOL} + 
      "   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:" + {&EOL} + 
      "  RUN enable_UI." + {&EOL} +
      "  WAIT-FOR WINDOW-CLOSE OF ~{&WINDOW-NAME}." + {&EOL} + 
      "END." + {&EOL}. 
   END.		/* GUI-based Window */

    /* All dialog boxes */
    ELSE IF _U._TYPE = "DIALOG-BOX"
    THEN p_code  = p_code +
 "/* Parent the dialog-box to the ACTIVE-WINDOW, if there is no parent.   */" +
      {&EOL} +
      "IF VALID-HANDLE(ACTIVE-WINDOW) AND FRAME ~{&FRAME-NAME}:PARENT eq ?" + 
      {&EOL} + 
      "THEN FRAME ~{&FRAME-NAME}:PARENT = ACTIVE-WINDOW." +
      {&EOL}  + {&EOL} +
 "/* Now enable the interface and wait for the exit condition.            */" +
  {&EOL} +
 "/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */" +
      {&EOL} +
      "MAIN-BLOCK:" + {&EOL} + 
      "DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK" + {&EOL} + 
      "   ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:" + {&EOL} + 
      "  RUN enable_UI." + {&EOL} + 
      "  WAIT-FOR GO OF FRAME ~{&FRAME-NAME}." + {&EOL} + 
      "END." + {&EOL} + 
      "RUN disable_UI." + {&EOL} + {&EOL}.
  END. /* When _DEFAULT-MAIN-BLOCK ... */

 /**************************************************************************/
 /*                          _INCLUDED-LIB                                 */  
 /**************************************************************************/
  WHEN "_INCLUDED-LIB":U THEN DO:
    ASSIGN p_code =
"/* ************************* Included-Libraries *********************** */"
    + {&EOL} .
  END.

 /**************************************************************************/
 /*                          _DEFAULT-DISABLE                              */  
 /**************************************************************************/
  WHEN "_DEFAULT-DISABLE":U THEN DO:
    FIND _C WHERE RECID(_C) eq _U._x-recid.
    p_code = 
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:     DISABLE the User Interface" + {&EOL} + 
    "  Parameters:  <none>" + {&EOL} + 
    "  Notes:       Here we clean-up the user-interface by deleting"  + {&EOL} + 
    "               dynamic widgets we have created and/or hide "     + {&EOL} +
    "               frames.  This procedure is usually called when"   + {&EOL} + 
    "               we are ready to ~"clean-up~" after running."      + {&EOL} + 
    "{&COMMENT-LINE}*/" +  {&EOL}.
    FIND _LAYOUT WHERE _LAYOUT._LO-NAME = "{&Master-Layout}".
    IF (NOT _C._SUPPRESS-WINDOW) AND _LAYOUT._GUI-BASED AND      
       CAN-DO (_P._allow, "WINDOW") 
    THEN p_code = p_code +
          "  /* Delete the WINDOW we created */" + {&EOL} +
          "  IF SESSION:DISPLAY-TYPE = ~"GUI~":U AND" +
          " VALID-HANDLE(" + _U._NAME + ")" + {&EOL} +
          "  THEN DELETE WIDGET " + _U._NAME + "." +  {&EOL} +
	  "  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE."
	  + {&EOL}.
    ELSE DO:
      /* We are in TTY mode or SUPPRESS WINDOW mode, so hide of all the frames.
         Make a list of these frames in f_list. */
      p_code = p_code + "  /* Hide all frames. */" + {&EOL}.
      FOR EACH f_U WHERE f_U._WINDOW-HANDLE = _U._HANDLE AND
                         f_U._STATUS        <> "DELETED":U AND
                         CAN-DO("FRAME,DIALOG-BOX":U, f_U._TYPE) BY f_U._NAME:
        p_code = p_code + "  HIDE FRAME " + f_U._NAME + "." + {&EOL}.
      END.
      IF _U._TYPE ne "DIALOG-BOX":U 
      THEN p_code = p_code +
      "  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE."
      + {&EOL}.
    END.
    p_code = p_code + "END PROCEDURE." .
  END. /* WHEN _DEFAULT-DISABLE... */
  
 /**************************************************************************/ 
 /*                          _DEFAULT-ENABLE                               */  
 /**************************************************************************/ 
  WHEN "_DEFAULT-ENABLE":U THEN DO:   
    RUN create_DEFAULT-ENABLE.
 END. /* WHEN _DEFAULT-ENABLE... */

 /**************************************************************************/
 /*                          standard TRIGGER                              */  
 /**************************************************************************/
  WHEN "_CONTROL":U THEN DO:
    p_code = "DO:":U + {&EOL} + 
             "  ":U + {&EOL} + 
             "END.":U.
  END. /* WHEN _CONTROL... */

 /**************************************************************************/
 /*                          _DEFINE-QUERY                                 */  
 /**************************************************************************/
  WHEN "_DEFINE-QUERY":U THEN DO:
    FIND _C WHERE RECID(_C) = _U._x-recid.
    FIND _Q WHERE RECID(_Q) = _C._q-recid.

    p_code = "DEFINE QUERY ":U + _U._NAME + " FOR":U + {&EOL}.
    IF _Q._TblList ne "" THEN DO:
      DO i = 1 TO NUM-ENTRIES (_Q._TblList):
         ASSIGN tmp_string = TRIM(ENTRY(i,_Q._TblList))
                token      = ENTRY(1,tmp_string," ":U).
                
         IF NUM-ENTRIES(token,".":U) > 1 THEN token = db-tbl-name(token).
         p_code = p_code + "                " + token +
                 IF i < NUM-ENTRIES(_Q._TblList) THEN "," + {&EOL}
                 ELSE " SCROLLING.":U.
      END.  /* i = 1 to NUM-ENTRIES */
    END. /* IF some table have been identified */
    ELSE p_code = p_code + "<table-list>.".

  END. /* WHEN _DEFINE-QUERY... */
  
 /**************************************************************************/
 /*                          _DISPLAY-FIELDS (of a BROWSE)                 */  
 /**************************************************************************/
  WHEN "_DISPLAY-FIELDS":U THEN DO:
    ASSIGN p_code     = ""
           tmp_string = FILL(" ":U,6)
           i          = 1.
 
    FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
      IF NOT CAN-DO("_<CALC>,_<SDO>", _BC._DBNAME) THEN
        tmp_string = db-fld-name("_BC":U, RECID(_BC)).
      ELSE IF _BC._table > '' AND _BC._table <> 'RowObject':U THEN
        tmp_string = _BC._table + '.':U + _bc._name.  
      ELSE tmp_string = _BC._DISP-NAME.
      IF _U._SHARED  AND _BC._DBNAME NE "_<CALC>" THEN DO:
        IF NUM-ENTRIES(tmp_string,".") = 3 THEN
        OVERLAY(tmp_string,INDEX(tmp_string,"."),1,"CHARACTER":U) = "_".
        ELSE tmp_string = REPLACE(tmp_string,".","_.").
      END.
      /* If user specifically cleared the label text, then write it out as
         well. (dma) */
      IF /* _BC._LABEL NE "":U AND */ _BC._LABEL <> ? AND
         (_BC._LABEL NE _BC._DEF-LABEL OR
         ((_BC._LABEL-ATTR NE _BC._DEF-LABEL-ATTR) AND
          _BC._LABEL-ATTR NE "":U AND 
          _BC._LABEL-ATTR NE ? 
         )) THEN
      DO:
         ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                          _BC._LABEL,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                          "~{","~~~{"), "~;","~~~;")
                tmp_string = tmp_string + " COLUMN-LABEL """ + q_label + """".
         IF _BC._LABEL-ATTR NE "":U AND _BC._LABEL-ATTR <> ? THEN
            tmp_string = tmp_string + ":":U + _BC._LABEL-ATTR.
      END.
      IF _BC._FORMAT NE "":U AND _BC._FORMAT NE ? AND
         (_BC._FORMAT NE _BC._DEF-FORMAT OR
         ((_BC._FORMAT-ATTR NE _BC._DEF-FORMAT-ATTR) AND
          _BC._FORMAT-ATTR NE "":U AND
          _BC._FORMAT-ATTR NE ?
         )) THEN
      DO:
        tmp_string = tmp_string + " FORMAT """ + _BC._FORMAT + """".
        IF _BC._FORMAT-ATTR NE "":U AND _BC._FORMAT-ATTR <> ? THEN
           tmp_string = tmp_string + ":":U + _BC._FORMAT-ATTR.
      END.
      IF LENGTH(tmp_string,"RAW":U) > 55 THEN DO:
        ASSIGN p_code = p_code + "      " + tmp_string + {&EOL}.
        tmp_string = FILL(" ":U,5).
      END.
      IF _BC._WIDTH NE _BC._DEF-WIDTH THEN
        tmp_string = tmp_string + " WIDTH " + TRIM(STRING(_BC._WIDTH)).
      IF LENGTH(tmp_string,"RAW":U) > 55 THEN DO:
        ASSIGN p_code = p_code + "      " + tmp_string + {&EOL}.
        tmp_string = FILL(" ":U,5).
      END.
      IF _BC._FGCOLOR NE ? THEN
        tmp_string = tmp_string + " COLUMN-FGCOLOR " + 
                                  TRIM(STRING(_BC._FGCOLOR,">>9")).
      IF _BC._BGCOLOR NE ? THEN
        tmp_string = tmp_string + " COLUMN-BGCOLOR " +
                                  TRIM(STRING(_BC._BGCOLOR,">>9")).
      IF _BC._FONT NE ? THEN
        tmp_string = tmp_string + " COLUMN-FONT " + TRIM(STRING(_BC._FONT,">>9")).
      IF LENGTH(tmp_string,"RAW":U) > 60 THEN DO:
        ASSIGN p_code = p_code + "      " + tmp_string + {&EOL}.
        tmp_string = FILL(" ":U,5).
      END.
      IF _BC._LABEL-FGCOLOR NE ? THEN
        tmp_string = tmp_string + " LABEL-FGCOLOR " + 
                                  TRIM(STRING(_BC._LABEL-FGCOLOR,">>9")).
      IF _BC._LABEL-BGCOLOR NE ? THEN
        tmp_string = tmp_string + " LABEL-BGCOLOR " +
                                  TRIM(STRING(_BC._LABEL-BGCOLOR,">>9")).
      IF _BC._LABEL-FONT NE ? THEN
         tmp_string = tmp_string + " LABEL-FONT " + TRIM(STRING(_BC._LABEL-FONT,">>9")).

      IF _BC._VIEW-AS-TYPE NE "" AND
         _BC._VIEW-AS-TYPE NE ?  AND
         _BC._VIEW-AS-TYPE NE "FILL-IN":U THEN DO:

         IF _BC._VIEW-AS-TYPE = "Toggle-box":U THEN
            ASSIGN tmp_viewas = " VIEW-AS TOGGLE-BOX":U.

         ELSE DO:
            ASSIGN tmp_viewas = " VIEW-AS COMBO-BOX":U.

            ASSIGN tmp_viewas = tmp_viewas +
                                (IF _BC._VIEW-AS-SORT EQ YES THEN " SORT":U ELSE "") +                                
                                (IF _BC._VIEW-AS-INNER-LINES NE 0 THEN " INNER-LINES ":U + STRING(_BC._VIEW-AS-INNER-LINES) ELSE "").

            IF _BC._VIEW-AS-ITEMS = ? THEN DO:
                ASSIGN tmp_viewas = tmp_viewas + CHR(10) + FILL(" ",21) + ' LIST-ITEM-PAIRS ':U.

                DO i = 1 TO NUM-ENTRIES(_BC._VIEW-AS-ITEM-PAIRS,_BC._VIEW-AS-DELIMITER) BY 2:
                    ASSIGN tmp_viewas = tmp_viewas + """"  + /* first item of pair (quoted) */
                                        ENTRY(i,_BC._VIEW-AS-ITEM-PAIRS,_BC._VIEW-AS-DELIMITER) + '",' +
                                        /* Quote the second item only if it's a CHAR field */
                                        (IF _BC._DATA-TYPE = "Character":U THEN '"' + 
                                         ENTRY(i + 1,_BC._VIEW-AS-ITEM-PAIRS,_BC._VIEW-AS-DELIMITER) + '"'
                                         ELSE ENTRY(i + 1,_BC._VIEW-AS-ITEM-PAIRS,_BC._VIEW-AS-DELIMITER)) +
                                        (IF i + 1 < NUM-ENTRIES(_BC._VIEW-AS-ITEM-PAIRS,_BC._VIEW-AS-DELIMITER) THEN ",":U + CHR(10) + FILL(" ",38) 
                                         ELSE "").
                END.  /* DO i = 1 to Num-Entries */

                ASSIGN tmp_viewas = tmp_viewas + CHR(10).
            END.

            ELSE DO:

                ASSIGN tmp_viewas = tmp_viewas + CHR(10) + FILL(" ",21) + ' LIST-ITEMS ':U.

                DO i = 1 TO NUM-ENTRIES(_BC._VIEW-AS-ITEMS,_BC._VIEW-AS-DELIMITER):
                     ASSIGN tmp_viewas = tmp_viewas + """"  + 
                            ENTRY(i,_BC._VIEW-AS-ITEMS,_BC._VIEW-AS-DELIMITER) +
                        (IF i < NUM-ENTRIES(_BC._VIEW-AS-ITEMS,_BC._VIEW-AS-DELIMITER) THEN
                           """," ELSE """ ").
                END.

                ASSIGN tmp_viewas = tmp_viewas + CHR(10).
            END.

            ASSIGN tmp_viewas = tmp_viewas + FILL(" ",22) +
                                _BC._VIEW-AS-TYPE + " " +
                                (IF _BC._VIEW-AS-MAX-CHARS NE 0 THEN " MAX-CHARS ":U + STRING(_BC._VIEW-AS-MAX-CHARS) ELSE "") +
                                (IF _BC._VIEW-AS-AUTO-COMPLETION EQ YES THEN " AUTO-COMPLETION ":U ELSE "") +
                                (IF _BC._VIEW-AS-UNIQUE-MATCH EQ YES THEN " UNIQUE-MATCH ":U ELSE "").
         END.

         ASSIGN tmp_string = tmp_string + tmp_viewas.
      END.

      IF tmp_string NE "" THEN
        p_code = p_code + "      " + tmp_string + {&EOL}.        
    END.  /* FOR EACH _BC */
  
    IF CAN-FIND (FIRST _BC WHERE _BC._x-recid = RECID(_U) AND _BC._ENABLED) THEN DO:
      p_code = p_code + "  ENABLE" + {&EOL}.
     
      FOR EACH _BC WHERE _BC._x-recid = RECID(_U) AND _BC._ENABLED:
        tmp_string = IF CAN-DO("_<CALC>,_<SDO>",_BC._DBNAME)
                     THEN _BC._DISP-NAME
                     ELSE db-fld-name("_BC":U, RECID(_BC)).
        IF _BC._HELP NE "":U AND _BC._HELP NE ? AND
           (_BC._HELP NE _BC._DEF-HELP OR
           ((_BC._HELP-ATTR NE _BC._DEF-HELP-ATTR) AND
             _BC._HELP-ATTR NE "":U AND
             _BC._HELP-ATTR NE ?
           )) THEN 
        DO:
          tmp_string = tmp_string + " HELP """ + _BC._HELP + """".
          IF _BC._HELP-ATTR NE "":U AND _BC._HELP-ATTR <> ? THEN
             tmp_string = tmp_string + ":":U + _BC._HELP-ATTR.
        END.
        IF _BC._DISABLE-AUTO-ZAP THEN
          tmp_string = tmp_string + " DISABLE-AUTO-ZAP".
        IF _BC._AUTO-RETURN THEN
          tmp_string = tmp_string + " AUTO-RETURN ".
        
        p_code = p_code + FILL(" ":U,6) + tmp_string + {&EOL}.
      END. /* FOR EACH ENABLED FIELD */
    END.  /* Browse has a columns to enable. */
  END. /* WHEN _CONTROL... */

 /**************************************************************************/
 /*                          _OPEN-QUERY                                   */  
 /**************************************************************************/
  WHEN "_OPEN-QUERY":U THEN DO:
    FIND _C WHERE RECID(_C) = _U._x-recid.
    FIND _Q WHERE RECID(_Q) = _C._q-recid.

    IF _Q._TblList ne "" THEN DO:
      /* Get all CR/LF into tilde-LINE FEED */
      p_code = REPLACE (
		    REPLACE (TRIM(_Q._4GLQury),
			     CHR(13), ""),
		    CHR(10), " ~~" + CHR(10) ).

      /* Suppress temp-table db names */
      DO i = 1 TO NUM-ENTRIES(_tt_log_name):
        p_code = REPLACE(p_code, " ":U + ENTRY(i,_tt_log_name) + ".":U, " ":U).
      END.

      IF _suppress_dbname OR _U._SHARED THEN DO:
      /* Need to adjust dbname and/or table name                               */
        db-list = "".
        DO i = 1 TO NUM-DBS:                      /* Build list of DB names    */
          db-list = db-list + (IF LENGTH(db-list,"RAW":U) = 0
                               THEN ldbname(i) ELSE ("," + ldbname(i))) +
                               ",":U + pdbname(i).
        END.
      
        IF _suppress_dbname AND (NOT _U._SHARED OR _U._TYPE = "FRAME":U) THEN DO:
          /* sports.customer --> customer AND 
             sports.customer.name --> customer.name    */
          DO i = 1 TO NUM-DBS:
            ASSIGN p_code = REPLACE(p_code," " + ldbname(i) + ".", " ").
            IF ldbname(i) NE pdbname(i) THEN
              ASSIGN p_code = REPLACE(p_code," " + pdbname(i) + ".", " ").
          END.  /* FOR EACH CONNECTED DATABASE */
        END.  /* If only suppressed */

        ELSE IF _U._SHARED AND NOT _suppress_dbname AND
                _U._TYPE = "BROWSE":U THEN DO:
          /* sports.customer --> sports_customer AND                          */
          /* sports.customer.name --> sports_customer.name                    */
          DO i = 2 TO NUM-ENTRIES(p_code," ") - 1: /* Not the EACH or NO-LOCK */
	     token = ENTRY(i,p_code," ").
	     IF CAN-DO(db-list,ENTRY(1,token,".")) THEN DO:  /* Token starts with 
	                                                        dbname         */
              ASSIGN per-pos  = INDEX(token,".")
		   OVERLAY(token,per-pos,1,"CHARACTER":U) = "_"                   
		   ENTRY(i,p_code," ") = token.
            END.  /* If token begins with a DB-NAME */
            ELSE DO:   /* See if token starts with a table name               */
              DO j = 1 TO NUM-ENTRIES(_Q._TblList," "):
                IF ENTRY(j,_Q._TblList," ") NE "OF" AND
                   ENTRY(2,ENTRY(j,_Q._TblList," "),".") = ENTRY(1,token,".")
                 THEN ASSIGN ENTRY(1,token,".") =
                                   ENTRY(1,ENTRY(j,_Q._TblList," "),".") + "_" +
                                   ENTRY(1,token,".")
		               ENTRY(i,p_code," ") = token.
              END.
            END.  /* See if token starts with a table name */
          END.  /* For each token */
        END. /* IF shared but not suppressed */

        ELSE IF _suppress_dbname AND _U._SHARED THEN DO:
	   /* sports.customer --> customer_ AND                               */
	   /* sports.customer.name --> customer_.name                         */
          DO i = 2 TO NUM-ENTRIES(p_code," ") - 1:  /* Not the EACH or
                                                                     NO-LOCK */
            token = ENTRY(i,p_code," ").
            IF CAN-DO(db-list,ENTRY(1,token,".")) THEN DO:
              /* Token starts with dbname */
              ASSIGN token = ENTRY(2,token,".") + "_" + 
                                  (IF NUM-ENTRIES(token,".") = 3
                                                 THEN "." + ENTRY(3,token,".")
                                                 ELSE "")
                     ENTRY(i,p_code," ") = token.
            END.  /* If token begins with a DB-NAME */
            ELSE DO:   /* See if token starts with a table name             */
              DO j = 1 TO NUM-ENTRIES(_Q._TblList," "):
                IF ENTRY(j,_Q._TblList," ") NE "OF" AND
                ENTRY(2,ENTRY(j,_Q._TblList," "),".") = ENTRY(1,token,".") THEN 
                ASSIGN ENTRY(1,token,".")  = ENTRY(1,token,".") + "_"
                       ENTRY(i,p_code," ") = token.
              END.
            END.  /* See if token starts with a table name */
          END.  /* For each token */
        END.  /* IF both suppress_db and SHARED */
      END. /* IF either suppressed_db OR SHARED */
    END.  /* If _Q._TblList is non empty */
  END. /* WHEN _OPEN-QUERY... */

 /**************************************************************************/
 /*                          standard PROCEDURE                            */  
 /**************************************************************************/
  WHEN "_PROCEDURE":U THEN DO:
    p_code =   
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:     " + {&EOL} + 
    "  Parameters:  <none>" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    "{&COMMENT-LINE}*/" + {&EOL} + 
      {&EOL} + 
    "END PROCEDURE.".
  END. /* WHEN _PROCEDURE... */

 /**************************************************************************/
 /*                          standard FUNCTION IMPLEMENTATION              */  
 /**************************************************************************/
  WHEN "_FUNCTION":U THEN DO:
    p_code =   
    "<code-block>" + {&EOL} +
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:  " + {&EOL} + 
    "    Notes:  Function Implementation." + {&EOL} + 
    "{&COMMENT-LINE}*/" + {&EOL} + 
    {&EOL} +
    "END FUNCTION.".
  END. /* WHEN _FUNCTION... */

 /**************************************************************************/
 /*                          standard FUNCTION EXTERNAL PROTOTYPE          */  
 /**************************************************************************/
  WHEN "_FUNCTION-EXTERNAL":U THEN DO:
    p_code =   
    "<code-block>" + "  /* External Prototype. */".
  END. /* WHEN _FUNCTION-EXTERNAL... */

 /**************************************************************************/
 /*                          OCX-EVENTPROC-TOP                             */  
 /**************************************************************************/
  WHEN "_OCX-EVENTPROC-TOP":U THEN DO:
    p_code =   
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:     " + {&EOL} + 
    "  Parameters:  ".
  END. /* WHEN _PROCEDURE... */
 
 /**************************************************************************/
 /*                          OCX-EVENTPROC-MID                             */  
 /**************************************************************************/
  WHEN "_OCX-EVENTPROC-MID":U THEN DO:
    p_code =    
    "  Notes:       " + {&EOL} + 
    "{&COMMENT-LINE}*/" + {&EOL} + {&EOL}.
  END. /* WHEN _PROCEDURE... */
 
 /**************************************************************************/
 /*                          OCX-EVENTPROC-END                             */  
 /**************************************************************************/
  WHEN "_OCX-EVENTPROC-END":U THEN DO:
    p_code =    
    {&EOL} + {&EOL} + "END PROCEDURE.".
  END. /* WHEN _PROCEDURE... */
  
 /**************************************************************************/
 /*                          CONTROL-LOAD                                  */  
 /**************************************************************************/
  WHEN "_CONTROL-LOAD":U THEN DO:
  
    RUN adeuib/_ldicont.p(p_recid, "NORMAL":U, output tmp_code).
    
    p_code = tmp_code + {&EOL} + "END PROCEDURE.".
  END. /* WHEN _CONTROL-LOAD... */

 /**************************************************************************/
 /*                          WEB.INPUT PROCEDURE                           */  
 /**************************************************************************/
  WHEN "_WEB.INPUT":U /* jep / wtw */ THEN DO:
    p_code =   
    "/*" + comment-ln + {&EOL} +
    "  Purpose:     Assigns form field data value to frame screen value." + {&EOL} + 
    "  Parameters:  p-field-value" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    comment-ln + "*/" + {&EOL} + 
    "  DEFINE INPUT PARAMETER p-field-value AS CHARACTER NO-UNDO." + {&EOL} +
    "  " + {&EOL} +
    "  DO WITH FRAME ~{&FRAME-NAME~}:" + {&EOL} +
    "  " + {&EOL} +
    "  END." + {&EOL} +
    "  " + {&EOL} +
    "END PROCEDURE.".
  END. /* WHEN _WEB.INPUT... */

 /**************************************************************************/
 /*                          WEB.OUTPUT PROCEDURE                            */  
 /**************************************************************************/
  WHEN "_WEB.OUTPUT":U /* jep / wtw */ THEN DO:
    p_code =   
    "/*" + comment-ln + {&EOL} +
    "  Purpose:     Output the value of the field to the WEB stream" + {&EOL} + 
    "               in place of the HTML field definition." + {&EOL} + 
    "  Parameters:  p-field-defn" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    comment-ln + "*/" + {&EOL} + 
    "  DEFINE INPUT PARAMETER p-field-defn AS CHARACTER NO-UNDO." + {&EOL} +
    "  " + {&EOL} +
    "  DO WITH FRAME ~{&FRAME-NAME~}:" + {&EOL} +
    "  " + {&EOL} +
    "  END." + {&EOL} +
    "  " + {&EOL} +
    "END PROCEDURE.".
  END. /* WHEN _WEB.OUTPUT... */

 /**************************************************************************/
 /*                           _WEB-HTM-OFFSETS                             */
 /**************************************************************************/
  WHEN "_WEB-HTM-OFFSETS":U THEN DO:
    /* The actual code is generated by another procedure */
    RUN adeweb/_offproc.p (INTEGER(RECID(_P)), OUTPUT p_code).
  END. /* WHEN "_WEB-HTM-OFFSETS" ... */

 /**************************************************************************/
 /*                          standard LOCAL-METHOD                       */  
 /**************************************************************************/
  WHEN "_LOCAL-METHOD":U THEN DO:
    p_code =   
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:     Override standard ADM method" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    "{&COMMENT-LINE}*/" + {&EOL} 
    + {&EOL} +
    "  /* Code placed here will execute PRIOR to standard behavior. */" + {&EOL}
    + {&EOL} +    
    "  /* Dispatch standard ADM method.                             */" + {&EOL} +
    "  RUN dispatch IN THIS-PROCEDURE ( INPUT '_SMART-METHOD':U ) ." + {&EOL}
    + {&EOL} +
    "  /* Code placed here will execute AFTER standard behavior.    */" + {&EOL}
    + {&EOL} +
    "END PROCEDURE.".
  END. /* WHEN _LOCAL-METHOD... */

 /**************************************************************************/
 /*                          _ADM-CREATE-OBJECTS                           */  
 /**************************************************************************/  
  WHEN "_ADM-CREATE-OBJECTS":U THEN DO:
    /* The actual code is generated by another procedure */
    RUN adeuib/_adm-crt.p (p_recid, "NORMAL":U, OUTPUT p_code).
          
    /* Add a header and footer to it */
    p_code = 
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:     Create handles for all SmartObjects used in this procedure." + {&EOL} + 
    "               After SmartObjects are initialized, then SmartLinks are added." + {&EOL} +
    "  Parameters:  <none>" + {&EOL} + 
    "{&COMMENT-LINE}*/" + {&EOL} + 
    p_code + {&EOL}.
   
 
    /* Close the Procedure. On the off chance that p_code is ?, catch that. */      
    IF p_code eq ? 
    THEN p_code = "  /* UIB could not create this procedure because p_code was ? */" + {&EOL}.             
    p_code = p_code + "END PROCEDURE.".
  END. /* WHEN "_ADM-CREATE-OBJECTS" ... */

 /**************************************************************************/
 /*                          _ADM-ROW-AVAILABLE                            */  
 /**************************************************************************/
  WHEN "_ADM-ROW-AVAILABLE":U THEN DO:  
    /* The actual code is generated by another procedure */
    RUN adeuib/_adm-row.p (INTEGER(RECID(_P)), OUTPUT p_code).
  END. /* WHEN "_ADM-ROW-AVAILABLE"... */

 /**************************************************************************/
 /*                          _ADM-SEND-RECORDS                             */  
 /**************************************************************************/
  WHEN "_ADM-SEND-RECORDS":U THEN DO:
    /* Get a list of all tables found by this procedure (i.e. tables external
       to the procedure, or found in either frames, browse, or query. */
    tbllist = _P._xTblList.
    /* Now add in the frame and browse queries */
    FOR EACH x_U WHERE x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                   AND x_U._STATUS eq "NORMAL":U
                   AND CAN-DO("BROWSE,DIALOG-BOX,FRAME,QUERY", x_U._TYPE):
      FIND _C WHERE RECID(_C) eq x_U._x-recid.
      FIND _Q WHERE RECID(_Q) eq _C._q-recid.
      RUN addtables (_Q._TblList, INPUT-OUTPUT tblList).
    END.
    p_code =   
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:     Send record ROWID's for all tables used by" + {&EOL} + 
    "               this file." + {&EOL} +
    "  Parameters:  see template/snd-head.i" + {&EOL} + 
    "{&COMMENT-LINE}*/" + {&EOL} .
    IF tblList eq "" THEN DO:
      p_code = p_code + {&EOL} +
      "  /* SEND-RECORDS does nothing because there are no External" + {&EOL} + 
      "     Tables specified for this " + _P._TYPE + ", and there are no" + {&EOL} +
      "     tables specified in any contained Browse, Query, or Frame. */" +
      {&EOL} + {&EOL}. 
    END.
    ELSE DO:
       p_code = p_code + {&EOL} +
      "  /* Define variables needed by this internal procedure.               */" + {&EOL} +            
      "  ~{src/adm/template/snd-head.i}" + 
      {&EOL} + {&EOL} +
      "  /* For each requested table, put it's ROWID in the output list.      */" + {&EOL}
      . 

      cnt = NUM-ENTRIES (tblList).
      DO i = 1 TO cnt:
        db_tbl = ENTRY(i,tblList).
        IF NUM-ENTRIES(db_tbl,".":U) > 1 THEN db_tbl = db-tbl-name(db_tbl).
        p_code = p_code +
        "  ~{src/adm/template/snd-list.i """ + db_tbl + """}" + {&EOL} .
      END.

      p_code = p_code + {&EOL} +
      "  /* Deal with any unexpected table requests before closing.           */" + {&EOL} +            
      "  ~{src/adm/template/snd-end.i}"  + {&EOL} + {&EOL}. 

    END.         
    /* Close the procedure. */
    p_code = p_code +  "END PROCEDURE.".
  END. /* WHEN _ADM-SEND-RECORDS... */

 /**************************************************************************/
 /*                          DATA.VALIDATE PROCEDURE                        */
 /**************************************************************************/
  WHEN "_DATA.VALIDATE":U THEN DO:
    p_code =   
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:     Field column validation code." + {&EOL} + 
    "  Parameters:  p-field-value" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    "{&COMMENT-LINE}*/" + {&EOL} + 
      {&EOL} + 
    "  DEFINE INPUT  PARAMETER p-field-value AS CHARACTER NO-UNDO." + {&EOL} +
      {&EOL} +
    "END PROCEDURE.".
  END. /* WHEN _PDO.VALIDATE */

 /**************************************************************************/
 /*                          DATA.OUTPUT PROCEDURE                          */
 /**************************************************************************/
  WHEN "_DATA.OUTPUT":U THEN DO:
    p_code =   
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:     Field column processing before going to calling object." + {&EOL} + 
    "  Parameters:  p-field-value" + {&EOL} + 
    "  Notes:       " + {&EOL} + 
    "{&COMMENT-LINE}*/" + {&EOL} + 
      {&EOL} + 
    "  DEFINE INPUT  PARAMETER p-field-value AS CHARACTER NO-UNDO." + {&EOL} +
      {&EOL} +
    "END PROCEDURE.".
  END. /* WHEN _PDO.OUTPUT */


 /*************************************************************************/
 /*                          DATA.CALCULATE PROCEDURE                     */  
 /*************************************************************************/
  WHEN "_DATA.CALCULATE":U THEN DO:
    ASSIGN p_code     = "":U
           tmp_string = "ASSIGN ":U + {&EOL}.
    /* Find the _U for the SmartData */
    FIND FIRST xx_U WHERE xx_U._TYPE = "QUERY":U
                      AND xx_U._SUBTYPE = "SmartDataObject":U
                      AND xx_U._WINDOW-HANDLE = _U._WINDOW-HANDLE
    NO-ERROR.
    FOR EACH _BC WHERE _BC._x-recid = RECID(xx_U)
                   AND _BC._DBNAME EQ "_<CALC>":U
                    BY _BC._DISP-NAME:
         tmp_string = tmp_string 
         /* dma
                      + FILL(" ":U,9) + "rowObject.":U + _BC._DISP-NAME + " = STRING(":U + _BC._NAME + ")":U + {&EOL}.
         */
                      + FILL(" ":U,9) + "rowObject.":U + _BC._DISP-NAME + " = (":U + _BC._NAME + ")":U + {&EOL}.
    END. /* EACH _BC */

    IF tmp_string = "ASSIGN ":U + {&EOL} THEN 
       tmp_string = "":U.
    ELSE tmp_string = tmp_string + FILL(" ":U,6) + ".":U.

    IF tmp_string NE "":U THEN
        p_code = p_code + FILL(" ":U,6) + tmp_string + {&EOL}.        
          
    /* Add a header and footer to it */
    p_code = 
    "/*{&COMMENT-LINE}" + {&EOL} +
    "  Purpose:     Calculate all the Calculated Expressions found in the" + {&EOL} + 
    "               SmartDataObject." + {&EOL} +
    "  Parameters:  <none>" + {&EOL} + 
    "{&COMMENT-LINE}*/" + {&EOL} + 
    p_code + {&EOL}.
   
 
    /* Close the Procedure. On the off chance that p_code is ?, catch that. */      
    IF p_code eq ? 
    THEN p_code = "  /* UIB could not create this procedure because p_code was ? */" + {&EOL}.             
    p_code = p_code + "END PROCEDURE.".
  END. /* WHEN _DATA.CALCULATE */

 /**************************************************************************/
 /*                            OTHERWISE CASE                              */  
 /**************************************************************************/

  OTHERWISE DO:
    /* Is the template a file that we can run? */   
    p_code = "".
    RUN adecomm/_rsearch.p (INPUT TRIM(p_template,"_":U), OUTPUT file_name).   
    IF file_name eq ? THEN
      RUN adeshar/_coddflt.p ("_PROCEDURE", p_recid, OUTPUT p_code).
    ELSE DO ON ERROR UNDO, LEAVE:
      RUN VALUE(file_name) (INPUT INTEGER(RECID(_P)), OUTPUT p_code).
    END. 
  END.

END CASE.


/* ************************* Internal Tables ****************************** */

/* addtables - add the list of tables to the output list.
               Note that the input list has the form 
               "db.table,db.table2 OF db.table,db.table2 WHERE db.table etc).  
               So we want only the first ENTRY of each element of the list. */
PROCEDURE addtables:
  DEFINE INPUT        PARAMETER list2add  AS CHAR NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER oTblList AS CHAR NO-UNDO.
  
  DEFINE VAR cnt AS INTEGER NO-UNDO.
  DEFINE VAR i   AS INTEGER NO-UNDO.
  DEFINE VAR tbl AS CHAR NO-UNDO.
  
  cnt = NUM-ENTRIES(list2add).
  DO i = 1 TO cnt:
    tbl = ENTRY (1, TRIM(ENTRY(i,list2add)), " ":U).
    /* Only add it if it isn't already in the list */
    IF oTblList eq "" THEN oTblList = tbl.
    ELSE IF NOT CAN-DO (oTblList, tbl) 
    THEN oTblList = oTblList + "," + tbl.
  END.
END PROCEDURE.     

/* create_DEFAULT-ENABLE - creates the code for an "enable_UI" procedure. */
PROCEDURE create_DEFAULT-ENABLE:
  /* Initialize the code (p_code); set the "in_window" phrase so that if
     we have a window we do "IN WINDOW xyz" */ 
  FIND _C WHERE RECID(_C) eq _U._x-recid.
  ASSIGN p_code    = ""
         in_window = (IF _U._TYPE EQ "WINDOW":U AND _C._SUPPRESS-WINDOW EQ NO
                      THEN " IN WINDOW ":U + _U._NAME
                      ELSE "":U)
         heading   =
  "/*{&COMMENT-LINE}" + {&EOL} +
  "  Purpose:     ENABLE the User Interface"                         + {&EOL} + 
  "  Parameters:  <none>"                                            + {&EOL} + 
  "  Notes:       Here we display/view/enable the widgets in the"    + {&EOL} +
  "               user-interface.  In addition, OPEN all queries"    + {&EOL} +
  "               associated with each FRAME and BROWSE."            + {&EOL} +
  "               These statements here are based on the ~"Other "   + {&EOL} + 
  "               Settings~" section of the widget Property Sheets." + {&EOL} +
  "{&COMMENT-LINE}*/" + {&EOL} .
  
  /* If there's a VBX then run the procedure to load them, but
   * only if we are not in the "SmartWorld". For those objects,
   * the control_load is run during initialization. Otherwise
   * control_load is called for those "Not So Smart" windows
   * as part of backward compatibility.
   */
   
  FIND FIRST f_U WHERE f_U._TYPE = "{&WT-CONTROL}":U
                     AND f_U._STATUS <> "DELETED":U
                     AND f_U._WINDOW-HANDLE = _U._HANDLE NO-ERROR.
 
  IF AVAILABLE f_U THEN DO:
  
    IF (   _P._TYPE = "WINDOW":U
        OR _P._TYPE = "DIALOG-BOX":U)
       AND NOT CAN-DO(_P._ALLOW, "Smart":U) THEN DO:

       p_code = p_code + "  RUN control_load.":U + {&EOL}.
    END.   
  END. 

  /* For each frame (or dialog-box) write:
       {&OPEN-QUERY-frame-name}
       GET FIRST frame-name.
       DISPLAY <some vars> WITH FRAME frame_name [IN WINDOW window].
       IF AVAILABLE <table>
       THEN DISPLAY <some fields> WITH FRAME frame_name [IN WINDOW window].
       RUN load_controls. (If there any VBX controls)
       ENABLE ALL EXCEPT <some vars> WITH FRAME frame_name [IN WINDOW window].
       {&OPEN-BROWSERS-IN-QUERY-frame-name}
     Enable the frames top-down, left-to-right */
  FOR EACH f_U WHERE f_U._WINDOW-HANDLE =  _U._HANDLE AND
                     CAN-DO("FRAME,DIALOG-BOX", f_U._TYPE) AND
                     f_U._STATUS        <> "DELETED":U,
      EACH f_L WHERE RECID(f_L) = f_U._lo-recid
               BY f_U._TYPE BY f_L._ROW BY f_L._COL:

    /* Open the default frame query (before we display fields) */
    FIND _C WHERE RECID(_C) eq f_U._x-recid.
    FIND _Q WHERE RECID(_Q) eq _C._q-recid.
    IF (_Q._OpenQury AND (_Q._TblList NE "" OR
                         CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(f_U) AND
                                             _TRG._tEVENT = "OPEN_QUERY":U)))
    THEN p_code = p_code + {&EOL} + 
                  "  ~{&OPEN-QUERY-" + f_U._NAME + "}" + {&EOL} + 
                  "  GET FIRST " +  f_U._NAME + "." + {&EOL}
                  .

    /* Suppress DISPLAY and ENABLE for the layouts that this frame has been     */
    /* removed from                                                             */
    IF CAN-FIND(FIRST r_L WHERE r_L._u-recid = RECID(f_U) AND r_L._REMOVE-FROM-LAYOUT)
    THEN DO:
      ASSIGN p_code = p_code + {&EOL} + "  " 
             i      = 0.
      FOR EACH r_L WHERE r_L._u-recid = RECID(f_U) AND r_L._REMOVE-FROM-LAYOUT:
        FIND _LAYOUT WHERE _LAYOUT._LO-NAME = r_L._LO-NAME.   
        ASSIGN i      = i + 1
               p_code = p_code 
                        + (IF i = 1 THEN "IF NOT ("
                                    ELSE ({&EOL} + "  AND NOT ("))  
                        + (IF _LAYOUT._LO-NAME = "{&Master-Layout}":U OR 
                               _LAYOUT._EXPRESSION eq "":U                                 
                           THEN "~{&LAYOUT-VARIABLE} = ~"" + _LAYOUT._LO-NAME + "~":U"
                           ELSE _LAYOUT._EXPRESSION) 
                        + ")":U.
      END.  /* FOR EACH r_L */
      p_code = p_code + " THEN DO:" + {&EOL} + "  ".
    END.  /* If removed from a layout anywhere */
    
    /* Display and Enable variables. */
    ASSIGN tmp_code = ""  /* Store ENABLE vars */
           tmp_line = "".
    FOR EACH x_U WHERE 
      x_U._parent-recid =  RECID(f_U) AND  x_U._STATUS <> "DELETED":U AND
      NOT CAN-DO("WINDOW,FRAME,DIALOG-BOX,VBX,QUERY,TEXT,MENU,SUB-MENU,MENU-ITEM":U,
                 x_U._TYPE),
     EACH x_L WHERE x_L._u-recid = RECID(x_U) AND x_L._LO-NAME = "{&Master-Layout}":U 
         BY x_U._TAB-ORDER BY x_U._NAME:
     IF (x_U._DISPLAY OR x_U._ENABLE) THEN DO:
       /* only do browsers if they have a query with some tables */
       doit = TRUE.
       IF x_U._TYPE eq "BROWSE":U THEN DO:
         FIND _C WHERE RECID(_C) = x_U._x-recid.
         FIND _Q WHERE RECID(_Q) = _C._q-recid.
         IF _Q._TblList eq "" OR
            NOT CAN-FIND(FIRST _BC WHERE _BC._x-recid = RECID(x_U)) THEN doit = FALSE.
         IF NOT doit THEN DO: /* Look for freeform stuff */
           doit = CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(x_U) AND
                           _TRG._tEVENT = "OPEN_QUERY":U).
         END.
       END.
       IF doit THEN DO:
         FIND x_F WHERE RECID(x_F) = x_U._x-recid NO-ERROR.
         IF x_U._TABLE EQ ? OR (AVAILABLE x_F AND x_F._DISPOSITION = "LIKE":U) THEN
           ASSIGN db_tbl   = "" 
                  tmp_name = x_U._NAME.
         ELSE ASSIGN db_tbl   = IF x_U._BUFFER = x_U._TABLE THEN
                                   db-tbl-name( (IF LDBNAME(x_U._DBNAME) NE ? THEN
                                                  LDBNAME(x_U._DBNAME) ELSE x_U._DBNAME) +
                                                 "." + x_U._TABLE)
                                ELSE x_U._BUFFER
                     tmp_name = db_tbl + "." + 
                                (IF x_F._DISPOSITION = "FIELD" AND x_F._LIKE-FIELD NE ""
                                 THEN x_F._LIKE-FIELD ELSE x_U._NAME).
          /* Add when clause if removed from some layout.  */
          IF CAN-FIND(FIRST r_L WHERE r_L._u-recid = RECID(x_U) AND
                                      r_L._REMOVE-FROM-LAYOUT) THEN DO:
            i = 0.
            FOR EACH r_L WHERE r_L._u-recid = RECID(x_U) AND 
                               r_L._REMOVE-FROM-LAYOUT:
              FIND _LAYOUT WHERE _LAYOUT._LO-NAME = r_L._LO-NAME.
              ASSIGN i      = i + 1
                     tmp_name = tmp_name 
                                + (IF i = 1 THEN " WHEN NOT ("
                                            ELSE " AND NOT (") 
                                + (IF _LAYOUT._LO-NAME = "{&Master-Layout}":U OR 
                                      _LAYOUT._EXPRESSION eq "":U                                 
                                   THEN "~{&LAYOUT-VARIABLE} = ~"" + _LAYOUT._LO-NAME + "~":U"
                                   ELSE _LAYOUT._EXPRESSION)
                                + ")".        
            END. /* FOR EACH r_L... */
          END.  /* If removed from a layout anywhere */
          /* NOTE: We never DISPLAY BROWSE,BUTTONS,IMAGE,RECTANGES or 
             SmartObjects.  However  when property sheets are redone, 
             this might be relaxed.  Make sure that the list of 
             NON-DISPLAYable widgets is consistent between _coddflt.p 
             and _proprty.p.  */
          IF x_U._DISPLAY AND 
             NOT CAN-DO ("BROWSE,BUTTON,IMAGE,RECTANGLE,SmartObject":U,
                         x_U._TYPE)
          THEN DO:
            /* Find the List to store this value in */
            FIND ttList WHERE ttList.dbtbl eq db_tbl NO-ERROR.
            IF NOT AVAILABLE ttList THEN DO:
              CREATE ttList.
              ASSIGN ttList.dbtbl = db_tbl.
            END.  
            /* Reset the line if its size is too big. */
            IF LENGTH(ttList.line + tmp_name,"RAW":U) > 70
            THEN ASSIGN ttList.code = (IF ttList.code NE "" THEN
                                      ttList.code + {&EOL} ELSE "") +
                                      "          " + ttList.line
                        ttList.line = "".                          
            ttList.line = ttList.line + tmp_name + " ".
          END.
          IF x_U._ENABLE AND x_U._TYPE ne "SmartObject":U THEN DO:
            IF LENGTH(tmp_line + tmp_name,"RAW":u) > 70
            THEN ASSIGN tmp_code = (IF tmp_code NE "" THEN 
                                     tmp_code + {&EOL} ELSE "") +
                                     "         " + tmp_line
                        tmp_line = "".
            tmp_line = tmp_line + tmp_name + " ".  
          END.
        END. /* IF visible or not enable */
      END. /* If doit is true */
    END. /* For each x_U...*/
    /* DISPLAY what needs displaying. */
    FOR EACH ttList:
      ttList.code = (IF ttlist.code ne "" THEN ttList.code + {&EOL} + "          " 
                                          ELSE "" ) + ttList.line.
      IF ttList.code NE "" THEN DO:
        IF ttList.dbtbl ne "" 
        THEN p_code = p_code + 
                      "  IF AVAILABLE " + ttList.dbtbl + " THEN " + {&EOL} +
                      "    DISPLAY ".
        ELSE p_code = p_code + "  DISPLAY ".
        p_code = p_code + LEFT-TRIM(ttList.code) + {&EOL} + 
                 "      WITH FRAME " + f_U._NAME + in_window + "." + {&EOL}. 
      END.
      /* Remove the list before we start on fields in the next frame */
      DELETE ttList.
    END.
    /* ENABLE what is in the (tmp_code + tmp_line) list;
       if there are any variables. */
    tmp_code = (IF tmp_code NE "" THEN tmp_code + {&EOL} + "         " 
                                  ELSE "") + tmp_line.
    IF tmp_code NE "" THEN
      p_code = p_code + 
        (IF CAN-FIND(FIRST r_L WHERE r_L._u-recid = RECID(f_U) AND
                           r_L._REMOVE-FROM-LAYOUT)
           THEN "    " ELSE "  ") +
        "ENABLE " + LEFT-TRIM(tmp_code) + {&EOL} + 
        "      WITH FRAME " + f_U._NAME + in_window + "." + {&EOL}. 
    /* Show the frame if necessary.  There are two cases when we need an
       explicit view: (1) The frame was HIDDEN; or (2) there was no
       implicit view [no DISPLAY or ENABLE tmp_code].  However, the
       DISPLAYS may not occur if they have an IF AVAILABLE dbtbl, so
       don't count on DISPLAY occuring [i.e. only look at the ENABLE tmp_code]. */
    IF f_U._DISPLAY AND (f_U._HIDDEN OR (tmp_code eq ""))
    THEN p_code = p_code + 
               "  VIEW FRAME " + f_U._NAME + in_window + "." + {&EOL}. 
    /* IF frame is removed from any layout close exclusion block */
    IF CAN-FIND(FIRST r_L WHERE r_L._u-recid = RECID(f_U) AND r_L._REMOVE-FROM-LAYOUT)
    THEN  p_code = p_code + "  END." + {&EOL}.
    
    /* Open any browse queries that should be open */
    p_code = p_code + 
               "  ~{&OPEN-BROWSERS-IN-QUERY-" + f_U._NAME + "}" + {&EOL}.
               
    /* Stuff above may have turned an insensitive frame into a sensitive frame.
       Turn it back! */
    IF NOT f_U._SENSITIVE THEN
      p_code = p_code + "  FRAME " + f_U._NAME + ":SENSITIVE = NO." + {&EOL}.
  END. /* for each f_U... */

  /* Now show the window */
  IF CAN-DO (_P._allow, "WINDOW":U) AND _U._DISPLAY THEN 
    p_code = p_code + "  VIEW ":U + _U._NAME + ".":U + {&EOL}.

  p_code = heading + p_code + "END PROCEDURE.":U.
END PROCEDURE.

/* _coddflt.p - end of file */

/*********************************************************************
* Copyright (C) 2002 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _genproc.i

Description:
    Include file containing the internal procedures.  The reason
    for breaking this out into an include file is to make _gen4gl.p fit in
    the Windows Progress editor.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Date Modified:
    02/01/94 by RPR (added attributes to 'OPEN QUERY')
    03/08/96 GFS added support for Win95 slider
    09/22/94 GFS added XFTR support
    12/02/94 GFS added ENABLED-FIELDS-IN-QUERY-<frame-name> PREPROCESSOR
    01/29/98 GFS changed refs to _F._SCROLLBAR-V to x_U._SCROLLBAR-V
    01/98 SLK added SmartData support
                <FIRST|SECOND...>-TABLE-IN-QUERY-<&QUERY-NAME}
                DATA-FIELDS like Viewer's DISPLAYED-FIELDS minus "hidden" fields
    02/98 SLK generate <smartdata>.i with temp-table definition
    03/11/98 SLK Added MANDATORY-FIELDS
    04/01/98 SLK  Added support for SmartData CalcField Check Syntax
                   Uses skip_queries to output DEFINE TEMP-TABLE rowObject
    04/06/98 SLK Output do.i into directory even if not in PROPATH
                 Output do.i into tempfile for PREVIEW and SYNTAX
    06/02/98 SLK Added ipx_BC for USER-LIST for a SDO
    08/21/98 SLK Removed ipx_BC for USER-LIST for a SDO
    10/08/98 GFS Added support fir LIST-ITEM-PAIRS
    02/25/99 JEP Db-Aware preprocessor start and end around open-query's only.
    04/21/99 TSM Added PRINT status for File/Print option
    06/08/99 TSM Added support for editable combo-boxes
    06/10/99 TSM Added support for Auto-Completion for combo-boxes
    06/18/99 TSM Added support for Max-chars for combo-boxes
    02/01/01 JEP Added gentitle parameter to put_color_font_title. (Issue 273)
    02/12/02 DMA Separated ENABLED-TABLES from DISPLAY-TABLES in Standard
                 List Definitions section
    02/27/02 GAG Supported # of tables in query was raised to 18 (core max)
---------------------------------------------------------------------------- */
/* ************************************************************************* */
/*                                                                           */
/*     COMMON PROCEDURES FOR DEFINING VIEW-AS SUPPORT, COLOR and FONT        */
/*                                                                           */
/* ************************************************************************* */


/* This procedure puts out a HELP message if any                            */
PROCEDURE put_help_msg.
  IF (x_U._HELP NE "" AND x_U._HELP NE ? AND 
      (x_U._TABLE = ? OR x_U._HELP-SOURCE = "E":U)) OR
     (AVAILABLE _F AND _F._DISPOSITION = "LIKE":U) OR
     (x_U._HELP = "" AND x_U._HELP-SOURCE = "E":U AND x_U._TABLE NE ?) THEN DO:
    ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                      x_U._HELP,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                      "~{","~~~{"), "~;","~~~;").
        
     PUT STREAM P_4GL UNFORMATTED " HELP" SKIP
       "          """ q_label """"
          IF x_U._HELP-ATTR NE "" AND x_U._HELP-ATTR NE ?
           THEN ":" + x_U._HELP-ATTR ELSE "".
  END.
END.

/* This procedure is called when local variable has been defined with a      */
/* DEFINE VAR or when a database field is realized in a DEFINE FRAME.        */
/* This sets the VIEW-AS PHRASE.  It operates on the current x_U/_F records  */
/*  INPUT indent = the new line indenting (eg. "     ")                      */
PROCEDURE put_view-as.
  /* This is the indent to use on a new line */
  DEF INPUT PARAMETER  indent  AS CHAR                             NO-UNDO.
  DEF VARIABLE         tmp-str AS CHAR                             NO-UNDO.  
  
  /* Specify special combo-box attributes                                    */
     IF x_U._TYPE EQ "COMBO-BOX" THEN DO:
       PUT STREAM P_4GL UNFORMATTED SKIP indent
                 "VIEW-AS COMBO-BOX ".
       IF _F._SORT        THEN PUT STREAM P_4GL UNFORMATTED "SORT ".
       IF _F._INNER-LINES > 0 THEN PUT STREAM P_4GL UNFORMATTED "INNER-LINES " _F._INNER-LINES.
       IF NUM-ENTRIES(_F._LIST-ITEMS) > 0 THEN DO:
          PUT STREAM P_4GL UNFORMATTED SKIP indent "LIST-ITEMS ".
          DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)):
             PUT STREAM P_4GL UNFORMATTED """"  + 
                        ENTRY(i,_F._LIST-ITEMS,CHR(10)) +
                        IF i < NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)) THEN
                           """," ELSE """ ".
          END.  /* DO i = 1 to Num-Entries */
       END.
       ELSE IF NUM-ENTRIES(_F._LIST-ITEM-PAIRS) > 0 THEN DO:
         PUT STREAM P_4GL UNFORMATTED  SKIP indent "LIST-ITEM-PAIRS ".
         DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)):
           PUT STREAM P_4GL UNFORMATTED """"  + /* first item of pair (quoted) */
                        ENTRY(1,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))) + '",' +
                        /* Quote the second item only if it's a CHAR field */
                        (IF _F._DATA-TYPE = "Character":U THEN '"' + 
                           ENTRY(2,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))) + '"'
                         ELSE ENTRY(2,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10)))) +
                        (IF i < NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)) THEN ",":U + CHR(10) + FILL(" ",21) 
                         ELSE "").
         END.  /* DO i = 1 to Num-Entries */
       END.
       IF X_U._SUBTYPE NE ? THEN
         PUT STREAM P_4GL UNFORMATTED SKIP indent x_U._SUBTYPE.
       ELSE PUT STREAM P_4GL UNFORMATTED SKIP indent.
       PUT STREAM P_4GL UNFORMATTED 
           IF x_U._SUBTYPE NE "DROP-DOWN-LIST" AND 
             _F._MAX-CHARS NE 0 AND _F._MAX-CHARS NE ?
           THEN " MAX-CHARS " + STRING(_F._MAX-CHARS) ELSE "".
       IF _F._AUTO-COMPLETION THEN DO:
         PUT STREAM P_4GL UNFORMATTED " AUTO-COMPLETION":U.
         IF _F._UNIQUE-MATCH THEN
           PUT STREAM P_4GL UNFORMATTED " UNIQUE-MATCH":U.
       END.  /* if auto completion */
     END.

     /* Specify special editor attributes                                    */
     ELSE IF x_U._TYPE EQ "EDITOR" THEN
       PUT STREAM P_4GL UNFORMATTED SKIP indent
                 "VIEW-AS EDITOR"
                  IF NOT _F._WORD-WRAP THEN " NO-WORD-WRAP"    ELSE ""
                  IF _F._MAX-CHARS NE 0 AND _F._MAX-CHARS NE ?
                                       THEN " MAX-CHARS " + STRING(_F._MAX-CHARS) ELSE ""
                  IF _F._SCROLLBAR-H   THEN " SCROLLBAR-HORIZONTAL" ELSE ""
                   IF x_U._SCROLLBAR-V   THEN " SCROLLBAR-VERTICAL" ELSE ""
                  IF _F._LARGE         THEN " LARGE" ELSE "" 
                  IF x_L._NO-BOX       THEN " NO-BOX" ELSE "" SKIP.


     /* Specify special fill-in attributes                                  */      
     /* NOTE: We treat a Variable Text string like as a FILL-IN             */
     ELSE IF x_U._TYPE EQ "FILL-IN" THEN DO:
       IF x_U._SUBTYPE EQ "TEXT" 
       THEN PUT STREAM P_4GL UNFORMATTED SKIP indent " VIEW-AS TEXT " SKIP.
       ELSE PUT STREAM P_4GL UNFORMATTED SKIP indent
                 "VIEW-AS FILL-IN"
                  IF _F._NATIVE THEN " NATIVE " ELSE " " SKIP.
     END.

     /* Specify special radio-set attributes                                  */
     ELSE IF x_U._TYPE EQ "RADIO-SET" THEN
       PUT STREAM P_4GL UNFORMATTED SKIP indent
                 "VIEW-AS RADIO-SET"
                  IF _F._HORIZONTAL 
                  THEN (" HORIZONTAL" + IF _F._EXPAND THEN " EXPAND " ELSE "") 
                  ELSE  " VERTICAL"
                  SKIP.

     /* Initialize a selection-list with its LIST-ITEMS OR LIST-ITEM-PAIRS */
     ELSE IF x_U._TYPE EQ "SELECTION-LIST" THEN DO:
       PUT STREAM P_4GL UNFORMATTED SKIP indent
           "VIEW-AS SELECTION-LIST "
           IF _F._MULTIPLE THEN "MULTIPLE " ELSE "SINGLE ".
       IF NOT _F._DRAG    THEN PUT STREAM P_4GL UNFORMATTED "NO-DRAG ".
       IF _F._SORT        THEN PUT STREAM P_4GL UNFORMATTED "SORT ".
       IF _F._SCROLLBAR-H THEN
         PUT STREAM P_4GL UNFORMATTED SKIP indent "SCROLLBAR-HORIZONTAL ".
       IF x_U._SCROLLBAR-V THEN
         PUT STREAM P_4GL UNFORMATTED "SCROLLBAR-VERTICAL ".
       IF NUM-ENTRIES(_F._LIST-ITEMS) > 0 THEN DO:
         PUT STREAM P_4GL UNFORMATTED  SKIP indent "LIST-ITEMS ".
         DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)):
           PUT STREAM P_4GL UNFORMATTED """"  + 
                        ENTRY(i,_F._LIST-ITEMS,CHR(10)) +
                        IF i < NUM-ENTRIES(_F._LIST-ITEMS,CHR(10)) THEN
                           """," ELSE """ ".
         END.  /* DO i = 1 to Num-Entries */
       END.
       ELSE IF NUM-ENTRIES(_F._LIST-ITEM-PAIRS) > 0 THEN DO:
         PUT STREAM P_4GL UNFORMATTED  SKIP indent "LIST-ITEM-PAIRS ".
         DO i = 1 TO NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)):
           PUT STREAM P_4GL UNFORMATTED """"  + 
                        ENTRY(1,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))) + '","' +  
                        ENTRY(2,ENTRY(i,_F._LIST-ITEM-PAIRS,CHR(10))) +
                        IF i < NUM-ENTRIES(_F._LIST-ITEM-PAIRS,CHR(10)) THEN
                           ("""," + CHR(10) + FILL(" ",21)) ELSE """ ".
         END.  /* DO i = 1 to Num-Entries */
       END.
     END.

     /* Specify special slider attributes                                     */
     ELSE IF x_U._TYPE EQ "SLIDER" THEN DO:
       PUT STREAM P_4GL UNFORMATTED SKIP indent
                 "VIEW-AS SLIDER MIN-VALUE " _F._MIN-VALUE " MAX-VALUE " _F._MAX-VALUE
                  (IF _F._HORIZONTAL       THEN " HORIZONTAL "       ELSE " VERTICAL ").

       IF _F._LARGE-TO-SMALL AND _F._NO-CURRENT-VALUE THEN
          PUT STREAM P_4GL UNFORMATTED SKIP indent "LARGE-TO-SMALL NO-CURRENT-VALUE ".
       ELSE PUT STREAM P_4GL UNFORMATTED                  
                   (IF _F._LARGE-TO-SMALL   THEN "LARGE-TO-SMALL "   ELSE "")
                   (IF _F._NO-CURRENT-VALUE THEN "NO-CURRENT-VALUE " ELSE "").
       CASE _F._TIC-MARKS:
          WHEN "TOP/LEFT" THEN 
            IF _F._HORIZONTAL THEN PUT STREAM P_4GL UNFORMATTED SKIP indent "TIC-MARKS TOP ". 
            ELSE PUT STREAM P_4GL UNFORMATTED SKIP indent "TIC-MARKS LEFT ".
          WHEN "BOTTOM/RIGHT" THEN 
            IF _F._HORIZONTAL THEN PUT STREAM P_4GL UNFORMATTED SKIP indent "TIC-MARKS BOTTOM ".
            ELSE PUT STREAM P_4GL UNFORMATTED SKIP indent "TIC-MARKS RIGHT ".
          WHEN "BOTH" THEN 
            PUT STREAM P_4GL UNFORMATTED SKIP indent "TIC-MARKS BOTH ".
          /* If there are no tick marks, TIC-MARKS NONE will make sure new */
          /* sliders are sized correctly. jfranck */
          OTHERWISE
            PUT STREAM P_4GL UNFORMATTED SKIP indent "TIC-MARKS NONE ".
       END CASE.
       IF _F._TIC-MARKS NE "NONE" AND _F._FREQUENCY NE 0 THEN 
          PUT STREAM P_4GL UNFORMATTED "FREQUENCY " _F._FREQUENCY.
     END.        
            

     /* Specify Literal text                                                */
     ELSE IF x_U._TYPE EQ "TEXT" THEN
       PUT STREAM P_4GL UNFORMATTED " VIEW-AS TEXT " SKIP.

     /* Specify special toggle box                                          */
     ELSE IF x_U._TYPE EQ "TOGGLE-BOX" THEN DO:
       PUT STREAM P_4GL UNFORMATTED SKIP indent "VIEW-AS TOGGLE-BOX" SKIP.
     END.  /* Toggle box */

     /* Specify the special RADIO-SET stuff                                    */
     IF x_U._TYPE = "RADIO-SET" THEN DO:
       tmp-str = REPLACE(TRIM(_F._LIST-ITEMS),
                         "," + &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN"
                               &THEN CHR(13) + &ENDIF CHR(10),
                         "," + &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN"
                               &THEN CHR(13) + &ENDIF CHR(10) + indent + indent).
       PUT STREAM P_4GL UNFORMATTED 
           SKIP indent "RADIO-BUTTONS " SKIP indent indent.
       /* WTW - The buttons are an editted string (like trigger code).        */
       PUT STREAM P_4GL UNFORMATTED tmp-str.
     END.

     RUN put_size (INPUT indent, INPUT "DEF":U).
     RUN put_tooltip (INPUT x_U._TOOLTIP, INPUT x_U._TOOLTIP-ATTR).
END PROCEDURE.

/* This sets the COLOR and FONT of a field level widget.       */
/* It operates on the current x_U / _F records.                */ 
/*  INPUT indent = the new line indenting (eg. "     ")        */
PROCEDURE put_color_font.
  /* This is the indent to use on a new line */
  DEF INPUT PARAMETER indent AS CHAR.
    
  /* does this widget have color or fonts (ignore this if we are in tty).    */
  IF NOT tty_win AND (x_L._FGCOLOR NE ? OR x_L._BGCOLOR NE ? OR x_L._FONT NE ?) THEN 
    PUT STREAM P_4GL UNFORMATTED SKIP indent 
      IF x_L._BGCOLOR NE ? THEN ("BGCOLOR " + STRING(x_L._BGCOLOR) + " ")
                                    ELSE ""
    IF x_L._FGCOLOR NE ? THEN ("FGCOLOR " + STRING(x_L._FGCOLOR) + " ")
                                    ELSE ""
    IF x_L._FONT NE ?    THEN ("FONT " + STRING(x_L._FONT))
                                    ELSE "".
END PROCEDURE.

/* This sets the COLOR, FONT, and TITLE of a frame level widget. */
/* It operates on the current _U / _C records.                   */ 
/*  INPUT indent = the new line indenting (eg. "     ")          */
/*  INPUT gentitle = Yes when title should generate, otherwise   */
/*                   No to suppress title and not generate it.   */
PROCEDURE put_color_font_title.
  /* This is the indent to use on a new line */
  DEF INPUT PARAMETER indent    AS CHAR.
  DEF INPUT PARAMETER gentitle  AS LOGICAL.
  
  DEFINE BUFFER frame_L FOR _L.

  /* This is a work around for the fact that there is core bug that attempts to
     change the font of a browser at run time when the frame has a different font */
  IF _U._TYPE = "BROWSE" THEN DO:
    FIND frame_L WHERE frame_L._u-recid = _U._PARENT-RECID AND
                       frame_L._LO-NAME = "MASTER LAYOUT".
  END.
    
  IF NOT tty_win THEN DO:
    /* does this widget have color or fonts (ignore this if we are in tty).  */
    IF (_L._FGCOLOR NE ? OR _L._BGCOLOR NE ? OR _L._FONT NE ? OR
        (_U._TYPE = "BROWSE" AND frame_L._FONT NE ?)) THEN 
      PUT STREAM P_4GL UNFORMATTED SKIP indent 
      IF _L._BGCOLOR NE ? THEN ("BGCOLOR " + STRING(_L._BGCOLOR) + " ")
                                     ELSE ""
      IF _L._FGCOLOR NE ? THEN ("FGCOLOR " + STRING(_L._FGCOLOR) + " ")
                                     ELSE ""
      IF _L._FONT NE ?    THEN ("FONT " +    STRING(_L._FONT))
      ELSE IF _L._FONT = ? AND _U._TYPE = "BROWSE" AND frame_L._FONT NE ? THEN
                               ("FONT " +    STRING(frame_L._FONT))
                                     ELSE "".
    /* Now the title - if necessary */
    IF gentitle THEN DO:
      IF (NOT _L._NO-BOX AND _C._TITLE AND _U._TYPE NE "BROWSE":U) OR
         _U._TYPE = "DIALOG-BOX" THEN DO:
        ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                            _U._LABEL,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                            "~{","~~~{"), "~;","~~~;").
        PUT STREAM P_4GL UNFORMATTED SKIP indent "TITLE"
                  IF _L._TITLE-BGCOLOR NE ? 
                  THEN (" BGCOLOR " + STRING(_L._TITLE-BGCOLOR)) ELSE "" 
                  IF _L._TITLE-FGCOLOR NE ? 
                  THEN (" FGCOLOR " + STRING(_L._TITLE-FGCOLOR)) ELSE ""
                  (" ~"" + q_label + "~"" +
                   IF _U._LABEL-ATTR NE "" THEN ":" + _U._LABEL-ATTR ELSE "").
      END.
      IF _U._TYPE = "BROWSE":U AND NOT _L._NO-BOX AND _C._TITLE THEN DO:
        ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                            _U._LABEL,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                            "~{","~~~{"), "~;","~~~;").
        PUT STREAM P_4GL UNFORMATTED  SKIP indent "TITLE"
                  IF _L._BGCOLOR NE ? 
                  THEN (" BGCOLOR " + STRING(_L._BGCOLOR)) ELSE ""
                  IF _L._FGCOLOR NE ? 
                  THEN (" FGCOLOR " + STRING(_L._FGCOLOR)) ELSE ""
                  (" ~"" + q_label + "~"" +
                   IF _U._LABEL-ATTR NE "" THEN ":" + _U._LABEL-ATTR ELSE "").
      END.
    END. /* if gentitle */
  END. /* if not tty_win */
  ELSE IF (NOT _L._NO-BOX AND _C._TITLE) OR _U._TYPE = "DIALOG-BOX" THEN DO:
    IF gentitle THEN DO:
      ASSIGN q_label = REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                          _U._LABEL,"~~","~~~~"), "~"","~~~""), "~\","~~~\"),
                            "~{","~~~{"), "~;","~~~;").
      PUT STREAM P_4GL UNFORMATTED 
                  SKIP "        TITLE ~"" q_label "~"" +
                   IF _U._LABEL-ATTR NE "" THEN ":" + _U._LABEL-ATTR ELSE "".
    END. /* if gentitle */
  END.
END PROCEDURE.


   
/* Put out the query preprocessor variables --
   For each browser, frame (or dialog-box) write:
         Scope-define FIELDS-IN-QUERY-NAME <some vars>
         Scope-define OPEN-BROWSERS-IN-QUERY-NAME queries
         Scope-define OPEN-QUERY-NAME query
         Scope-define FIRST-TABLE-IN-QUERY-NAME <some tables>
         Scope-define TABLES-IN-QUERY-NAME <some tables>
   For the SmartData write:
         Scope-define FIRST-TABLE-IN-QUERY-NAME <some tables>
         Scope-define DATA-FIELDS <non-hidden fields in temp table>
   The current _U and _C records point to the current frame.
*/
PROCEDURE put_query_preproc_vars:
  DEFINE VAR bf_cnt           AS INTEGER   NO-UNDO.
  DEFINE VAR bef_cnt          AS INTEGER   NO-UNDO.
  DEFINE VAR bf_len           AS INTEGER   NO-UNDO.
  DEFINE VAR bef_len          AS INTEGER   NO-UNDO.
  DEFINE VAR buf-disp-flds    AS CHARACTER NO-UNDO.
  DEFINE VAR buf-enabl-flds   AS CHARACTER NO-UNDO.
  DEFINE VAR cName            AS CHARACTER NO-UNDO.
  DEFINE VAR cPath            AS CHARACTER NO-UNDO.
  DEFINE VAR cRelName         AS CHARACTER NO-UNDO.
  DEFINE VAR cReturnValue     AS CHARACTER NO-UNDO.
  DEFINE VAR cOpenQuery       AS CHARACTER NO-UNDO.
  DEFINE VAR cQueryString     AS CHARACTER NO-UNDO.
  DEFINE VAR lSaveAs          AS LOGICAL   NO-UNDO.
  DEFINE VAR lSaveUntitled    AS LOGICAL   NO-UNDO.
  DEFINE VAR tables_in_query  AS CHARACTER NO-UNDO.
  DEFINE VAR enabled-tables   AS CHARACTER NO-UNDO.
  DEFINE VAR tmp_cnt          AS INTEGER   NO-UNDO.
  DEFINE VAR tmp_cnt2         AS INTEGER   NO-UNDO.  
  DEFINE VAR tmp_code         AS CHARACTER NO-UNDO.
  DEFINE VAR tmp_code2        AS CHARACTER NO-UNDO.
  DEFINE VAR tmp_file         AS CHARACTER NO-UNDO.
  DEFINE VAR tmp_line         AS CHARACTER NO-UNDO.
  DEFINE VAR tmp_line2        AS CHARACTER NO-UNDO.
  DEFINE VAR tmp_item         AS CHARACTER NO-UNDO.
  DEFINE VAR cur-ent          AS CHARACTER NO-UNDO.
  DEFINE VAR db_name          AS CHARACTER NO-UNDO.
  DEFINE VAR lOk              AS CHARACTER NO-UNDO.
  DEFINE VAR TuneOpts         AS CHARACTER NO-UNDO.
  DEFINE VAR j                AS INTEGER   NO-UNDO.
  DEFINE VAR jj               AS INTEGER   NO-UNDO.
  DEFINE VAR n-ent            AS INTEGER   NO-UNDO.
  DEFINE VAR per-pos          AS INTEGER   NO-UNDO.
  DEFINE VAR qt               AS CHARACTER NO-UNDO.
  DEFINE VAR tc               AS CHARACTER NO-UNDO.
  DEFINE VAR token            AS CHARACTER NO-UNDO.
  DEFINE VAR web_file         AS LOGICAL   NO-UNDO.
  DEFINE VAR cRoot            AS CHARACTER NO-UNDO.
  DEFINE VAR cEnabledFields   AS CHARACTER NO-UNDO.
  DEFINE VAR cRelDirectory    AS CHARACTER  NO-UNDO.
  DEFINE VAR cTempTableDef    AS CHARACTER  NO-UNDO.
  

  DEFINE BUFFER ipU for _U.
  DEFINE BUFFER ipF for _F.
  DEFINE BUFFER ipL for _L.
  DEFINE BUFFER ipC for _C.
  DEFINE BUFFER ipQ for _Q.
  DEFINE BUFFER r_L for _L.
  DEFINE BUFFER nr_L for _L.
  DEFINE BUFFER r_LAYOUT for _LAYOUT.
  
  /* Create a comma-delimeted list of tables in the default query (based on
     _C._TblList which has the form "db.table,db.table2 OF db.table,db.table2
     WHERE db.table etc).  So we want only the first ENTRY of each element
     of the list. */
     
  /* First see if the query is freeform.  If so use the _TRG record to determine
     the tables in the query, otherwise use _Q._TblList                       */
  FIND _TRG WHERE _TRG._wRECID = RECID(_U) AND
                  _TRG._tEVENT = "OPEN_QUERY":U NO-ERROR.
  
  IF AVAILABLE _TRG THEN DO:
      ASSIGN tables_in_query = _Q._TblList.
      RUN build_table_list (INPUT _TRG._tCODE, INPUT " ":U, 
                          INPUT NO, /* If this flag is set to yes, temp-tables
                                       do not work. */
                          INPUT-OUTPUT tables_in_query).
  END.
  ELSE tables_in_query = _Q._TblList.
  DO i = 1 TO NUM-ENTRIES(tables_in_query):
     ENTRY(i,tables_in_query) = ENTRY (1, TRIM (ENTRY (i,tables_in_query)), " ").
  END.

  /* The ipC record can look at two types of queries: Frames, Browses and SmartData.
     FRAMES -- look at other _U records to get FIELDS-IN-QUERY
               create a OPEN-BROWSERS-IN-QUERY for any browsers in the frame
     BROWSE -- Only create a FIELDS-IN-QUERY (use _FldList to build this). 
     SMARTDATA -- Only create a FIELDS-IN-QUERY (use _FldList to build this). */
  IF _U._TYPE eq "BROWSE":U THEN DO:
    ASSIGN tmp_code  = "&Scoped-define FIELDS-IN-QUERY-":U + _U._NAME + " ":U 
           tmp_line2 = "&Scoped-define ENABLED-FIELDS-IN-QUERY-":U + _U._NAME +
                                     " ":U
           enabled-tables = "".
    /* IF FREEFORM just put the verbatum stuff in (don't worry about options etc.) */
    FIND _TRG WHERE _TRG._wRECID = RECID(_U) AND _TRG._tEVENT = "DISPLAY":U NO-ERROR.
    IF AVAILABLE _TRG THEN DO:
      IF _TRG._tCODE NE "" THEN DO:
        ASSIGN tmp_line  = REPLACE(REPLACE(REPLACE(REPLACE(_TRG._tCODE,CHR(13)," ":U),
                                       CHR(10)," ":U),CHR(9)," ":U),"  ":U," ":U)
               i         = INDEX(tmp_line," ENABLE ":U) - 1.
        IF i > 0 THEN DO:
          ASSIGN tmp_code  = tmp_code + TRIM(SUBSTRING(tmp_line,1, i))
                 tmp_line2 = tmp_line2 + TRIM(SUBSTRING(tmp_line,i + 8)).
          /* Glean ENABLED-TABLES in query */
          DO j = 3 TO NUM-ENTRIES(tmp_line2," ":U):
            tmp_item = ENTRY(j,tmp_line2," ":U).
            IF NUM-ENTRIES(tmp_item,".":U) > 1 THEN DO:  /* We have a table */
              tmp_item = ENTRY(1, tmp_item, ".":U) + 
                         (IF NUM-ENTRIES(tmp_item,".":U) = 2 THEN "":U
                          ELSE ".":U + ENTRY(2,tmp_item,".":U)).   
              IF enabled-tables eq "":U THEN enabled-tables = tmp_item.
              ELSE IF NOT CAN-DO(enabled-tables, tmp_item) THEN
                enabled-tables = enabled-tables + ",":U + tmp_item.                   
            END.  /* If we have a table */
          END.  /* DO j = 3 to num-entries */
        END. /* IF i > 0  (There are enabled fields ) */
        ELSE  ASSIGN tmp_code = tmp_code + TRIM(tmp_line).

        /* Remove FORMAT (FORM), LABEL, COLUMN-LABEL and WIDTH stuff*/
        ASSIGN j        = 1
               n-ent    = NUM-ENTRIES(tmp_code, " ":U)
               tc       = "".
        DO WHILE j <= n-ent:
          IF ENTRY(j,tmp_code," ":U) = "" THEN DO: END.
          ELSE IF NOT CAN-DO(
       "FORMAT,FORM,LABEL,COLUMN-LABEL,WIDTH,WIDTH-CHARS,WIDTH-PIXELS,~
COLUMN-FGC*,COLUMN-BGC*,COLUMN-FONT,LABEL-FGC*,LABEL-BGC*,LABEL-FONT",
             ENTRY(j,tmp_code," ":U))
            THEN tc = tc + " " + ENTRY(j,tmp_code," ":U).
          ELSE DO:
            qt = substring(ENTRY(j + 1, tmp_code, " ":U),1,1,"CHARACTER":U).
            IF qt = "'":U OR qt = '"' THEN DO:
              IF ENTRY(j + 1, tmp_code, " ":U) = qt
                THEN j = j + 1. /* lone quote, skip to next token */
              FIND-UNQUOTE:  /* This is like LABEL "Hello, There!" */
              REPEAT jj = (j + 1) TO n-ent:
                cur-ent = ENTRY(jj, tmp_code, " ":U).
                IF cur-ent = "" THEN NEXT. /* skip NULLs */
                IF SUBSTRING(cur-ent,LENGTH(cur-ent,"CHARACTER":U),1,
                    "CHARACTER":U) = qt /* Chunk ends in a quote */
                       OR
                   INDEX(cur-ent, qt + ":":U) > 1 /* End quote has string attrs */
                  /* Note: we used to check if it was at the end of cur-ent,
                     but this was wrong because people are putting string
                     attributes after the end quote.  Now if it is anywhere
                     in cur-rent, we assume that we are on the last chunk of
                     the quote.  Check FIND-UNQUOTE2 below.                 */
                  THEN LEAVE FIND-UNQUOTE.
              END. /* Looking for end of quote */                     
              j = jj.
            END.  /* If expression starts with a quote */
            ELSE j = j + 1.  /* No quote but skip token anyway.
                                This is like a 25 as in WIDTH 25 */
          END. /* Have something to be stripped */
          j = j + 1.
        END.  /* While j <= n-ent */         
        tmp_code = TRIM(tc).
 
        /* Remove HELP stuff*/
        ASSIGN j        = 1                      
               n-ent    = NUM-ENTRIES(tmp_line2, " ":U)
               tc       = "".
        DO WHILE j <= n-ent:
          IF NOT CAN-DO("HELP", ENTRY(j,tmp_line2," ":U))
            THEN tc = tc + " " + ENTRY(j,tmp_line2," ":U).
          ELSE DO:
            qt = substring(ENTRY(j + 1, tmp_line2, " ":U),1,1,"RAW":U).
            FIND-UNQUOTE2:
            REPEAT jj = (j + 1) TO n-ent:
              cur-ent = ENTRY(jj, tmp_line2, " ":U).
              IF SUBSTRING(cur-ent,LENGTH(cur-ent,"CHARACTER":U),1,
                      "CHARACTER":U) = qt /* Chunk ends in a quote */
                            OR
                 INDEX(cur-ent, (qt + ":":U)) > 1 /* End quote has string attrs */
                THEN LEAVE FIND-UNQUOTE2.
            END. /* Looking for end of quote */                     
            j = jj.
          END.
          j = j + 1.
        END.           
        tmp_line2 = TRIM(tc).
        
        ASSIGN tmp_code  = REPLACE(tmp_code,"    ":U, " ~~":U + CHR(10)) + "   ":U
               tmp_line2 = REPLACE(tmp_line2,"    ":U, " ~~":U + CHR(10)) + "   ":U.
        PUT STREAM P_4GL UNFORMATTED tmp_code SKIP tmp_line2 SKIP .
        RUN put_tbllist (enabled-tables, FALSE,
                         "ENABLED-TABLES-IN-QUERY-":U + _U._NAME,
                         "&1-ENABLED-TABLE-IN-QUERY-":U + _U._NAME,
                         18, " ":U).
      END.
    END.
    ELSE DO:  /* Run through the _BC records */
      FOR EACH _BC WHERE _BC._x-recid = RECID(_U):
        IF NOT CAN-DO("_<CALC>,_<SDO>", _BC._DBNAME) THEN
          tmp_item = db-fld-name("_BC":U, RECID(_BC)).
        ELSE tmp_item = REPLACE(_BC._DISP-NAME,CHR(10)," ").
        IF _U._SHARED  AND _BC._DBNAME NE "_<CALC>" THEN DO:
          IF NUM-ENTRIES(tmp_item, ".") = 3 THEN
            OVERLAY(tmp_item,INDEX(tmp_item,"."),1,"CHARACTER":U) = "_".
          ELSE tmp_item = REPLACE(tmp_item,".","_.").
        END.
        IF LENGTH(tmp_code + tmp_item, "CHARACTER":U) > 75 THEN DO:
          PUT STREAM P_4GL UNFORMATTED tmp_code "~~" SKIP.
          tmp_code = "":U.
        END.
        /* Get next item */
        ASSIGN tmp_code = tmp_code + tmp_item + " ".
        IF _BC._ENABLED THEN DO:  /* Enabled fields and tables */
          ASSIGN tmp_line2 = tmp_line2 + tmp_item + " ":U.
          IF NOT CAN-DO("_<CALC>,_<SDO>", _BC._DBNAME) THEN DO:
            tmp_item = db-tbl-name(_BC._DBNAME + ".":U + _BC._TABLE).
            IF enabled-tables eq "":U THEN enabled-tables = tmp_item.
            ELSE IF NOT CAN-DO(enabled-tables, tmp_item) THEN
              enabled-tables = enabled-tables + ",":U + tmp_item.   
          END. /* If not a calc field */    
        END. /* If an enabled field */
      END. /* FOR EACH _BC */
      /* Finish putting out the last line. */
      IF tmp_code ne "" THEN PUT STREAM P_4GL UNFORMATTED tmp_code SKIP.
      cur-ent = tmp_line2.
      /* Break up tmp_line2 if longer than 75 */
      DO WHILE tmp_line2 NE "":
        IF LENGTH(tmp_line2,"RAW":U) > 75 THEN DO:
          ASSIGN i = R-INDEX(tmp_line2, " ":U, 76).
          IF TRIM(SUBSTRING(tmp_line2,i + 1)) NE "" THEN
            PUT STREAM P_4GL UNFORMATTED SUBSTRING(tmp_line2,1,i) + "~~" SKIP.
          ELSE 
            PUT STREAM P_4GL UNFORMATTED SUBSTRING(tmp_line2,1,i)  SKIP.
          ASSIGN tmp_line2 = SUBSTRING(tmp_line2,i + 1).
        END.
        ELSE DO:
          PUT STREAM P_4GL UNFORMATTED tmp_line2 SKIP.
          ASSIGN tmp_line2 = "".
        END.
      END.
      IF tmp_line2 ne "" THEN PUT STREAM P_4GL UNFORMATTED tmp_line2 SKIP.
      RUN put_tbllist (enabled-tables, FALSE,
                       "ENABLED-TABLES-IN-QUERY-":U + _U._NAME,
                       "&1-ENABLED-TABLE-IN-QUERY-":U + _U._NAME,
                       18, " ":U).
    END.  /* Use the _BC records */
  END. /* IF...BROWSE... */
  ELSE DO: /* A frame or dialog-box */
    ASSIGN tmp_line         = "&Scoped-define FIELDS-IN-QUERY-":U + _U._NAME + " ":U
           tmp_line2        = "&Scoped-define ENABLED-FIELDS-IN-QUERY-":U + _U._NAME +
                                    " ":U
           buf-disp-flds    = "&Scoped-define BUFFER-FIELDS-IN-QUERY-":U + _U._NAME
           buf-enabl-flds   = "&Scoped-define ENABLED-BUFFER-FIELDS-IN-QUERY-":U + _U._NAME
           enabled-tables   = ""
           tmp_cnt          = 0
           tmp_cnt2         = 0
           bf_cnt           = 0
           bf_len           = LENGTH(buf-disp-flds, "RAW":U)
           bef_cnt          = 0
           bef_len          = LENGTH(buf-enabl-flds, "RAW":U).

    FOR EACH ipU WHERE ipU._parent-recid =  RECID(_U) AND ipU._STATUS <> "DELETED" 
        AND NOT CAN-DO("WINDOW,FRAME,DIALOG-BOX,BROWSE,TEXT,MENU,SUB-MENU,MENU-ITEM",
                       ipU._TYPE),
        EACH ipL WHERE ipL._u-recid = RECID(ipU) AND ipL._LO-NAME = "MASTER LAYOUT":U
                 BY ipU._TAB-ORDER BY ipU._NAME:
     /* FIELDS-IN-QUERY list only looks at those fields that are in the
        queries table-list */
      FIND ipF WHERE RECID(ipF) = ipU._x-recid NO-ERROR.
      IF ipU._TABLE ne ? AND ipF._DISPOSITION NE "LIKE":U AND 
         ipU._BUFFER EQ ipU._TABLE AND
         CAN-DO(tables_in_query, ipU._DBNAME + ".":U + ipU._TABLE) THEN DO:
        FIND _F WHERE RECID(_F) = ipU._x-recid.
        tmp_item = (IF _F._DISPOSITION = "LIKE":U THEN ipU._NAME
                    ELSE (IF LDBNAME(ipU._DBNAME) NE ? AND  NOT _suppress_dbname AND
                            NOT CAN-DO(_tt_log_name, LDBNAME(ipU._DBNAME))
                    THEN (LDBNAME(ipU._DBNAME) + "." + ipU._TABLE)
                    ELSE ipU._TABLE) + "." + 
                   (IF _F._DISPOSITION = "FIELD" AND _F._LIKE-FIELD NE ""
                       THEN _F._LIKE-FIELD ELSE ipU._NAME)).

        /* See if this field has been removed from any layout.               */
        /* If so, then add "WHEN {&window-name}-layout NE `layout-name` .    */
        /* NOTE: if layout-var is empty, then we already know there are no   */
        /* alternate layouts.  So do this check first.                       */
        /* Also NOTE use of single quotes (so that the FIELD-IN-QUERY can be */
        /* quoted itself later.                                              */
        IF layout-var ne "" AND
           CAN-FIND(FIRST r_L WHERE r_L._u-recid = RECID(ipU) 
                                AND r_L._REMOVE-FROM-LAYOUT) THEN DO:
          i = 0.
          FOR EACH r_L WHERE r_L._u-recid = RECID(ipU) AND r_L._REMOVE-FROM-LAYOUT:
            FIND r_LAYOUT WHERE r_LAYOUT._LO-NAME = r_L._LO-NAME.
            ASSIGN i = i + 1
                   tmp_item = tmp_item + 
                              (IF i = 1 THEN " WHEN (" ELSE " AND (" ) +
                               layout-var + " NE '" +  
                               REPLACE( REPLACE( REPLACE( REPLACE( REPLACE(
                               r_L._LO-NAME,
                               "~~","~~~~"), "~"","~~~""), "~\","~~~\"), "~{","~~~{"), 
                               "~;","~~~;") + 
                               "':U)".
          END.   /* For each layout where removed */                          
        END.  /* If removed from any layout... */
        IF ipU._DISPLAY THEN DO: /* GET DISPLAY = YES FIELDS */
          IF LENGTH(tmp_line + tmp_item, "RAW":U) > 75 THEN
            ASSIGN tmp_code = tmp_code +
                              (IF tmp_code eq "" THEN "" ELSE "~~" + CHR(10)) +
                              tmp_line
                   tmp_line = "".
          ASSIGN tmp_cnt  = tmp_cnt + 1
                 tmp_line = tmp_line + tmp_item + " ".
        END.  /* IF _DISPLAY */
        IF ipU._ENABLE THEN DO: /* GET ENABLED-ONLY FIELDS */
          IF LENGTH(tmp_line2 + tmp_item, "RAW":U) > 75 THEN
            ASSIGN tmp_code2 = tmp_code2 +
                               (IF tmp_code2 eq "" THEN "" ELSE "~~" + CHR(10)) +
                              tmp_line2
                   tmp_line2 = "".

          ASSIGN tmp_cnt2  = tmp_cnt2 + 1
                 tmp_line2 = tmp_line2 + tmp_item + " "
                 tmp_item  = ENTRY(1,tmp_item,".":U) +
                             IF NUM-ENTRIES(tmp_item,".":U) = 2
                             THEN "" ELSE (".":U + ENTRY(2,tmp_item,".":U)).
          IF enabled-tables eq "":U THEN enabled-tables = tmp_item.
          ELSE IF NOT CAN-DO(enabled-tables, tmp_item) THEN
            enabled-tables = enabled-tables + ",":U + tmp_item.                   
        END.  /* IF field is ENABLED */
 
      END. /* IF..IN QUERY */
      ELSE IF ipU._TABLE ne ? AND ipF._DISPOSITION NE "LIKE":U AND
              ipU._BUFFER NE ipU._TABLE THEN DO:
        /* An extra buffer has been defined and some of its fields are present in this frame */
        ASSIGN token         = ipU._BUFFER + "." + ipU._NAME
               bf_len        = bf_len + LENGTH(token,"RAW":U)
               buf-disp-flds = buf-disp-flds + " " + token
               bf_cnt        = bf_cnt + 1.
        IF bf_len > 65 THEN
          ASSIGN bf_len = 0
                 buf-disp-flds = buf-disp-flds + " ~~" + CHR(10).
        IF ipU._ENABLE THEN
          ASSIGN buf-enabl-flds = buf-enabl-flds + " " + token
                 bef_len        = bef_len + LENGTH(token, "RAW":U)
                 bef_cnt        = bef_cnt + 1.
        IF bef_len > 65 THEN
          ASSIGN bef_len = 0
                 buf-enabl-flds = buf-enabl-flds + " ~~" + CHR(10).
      END.  /* If buffer fields are present */
    END. /* FOR EACH ipU */ 

    /* Put out the lines (if and only if we had any items to display). Note we
       put out all the code we have generated so far.  PLUS we put out any 
       uncompleted lines. */
    IF tmp_cnt > 0 THEN DO:
      IF tmp_code ne "" THEN
        PUT STREAM P_4GL UNFORMATTED tmp_code (IF tmp_line ne "" THEN "~~" ELSE "")
            SKIP.
      IF tmp_line ne "" THEN 
        PUT STREAM P_4GL UNFORMATTED tmp_line SKIP.
    END.
    IF tmp_cnt2 > 0 THEN DO:                        
      IF tmp_code2 ne "" THEN 
        PUT STREAM P_4GL UNFORMATTED tmp_code2 (IF tmp_line2 ne "" THEN "~~" ELSE "") 
            SKIP.
      IF tmp_line2 ne "" THEN 
        PUT STREAM P_4GL UNFORMATTED tmp_line2 SKIP.
        
      RUN put_tbllist (enabled-tables, FALSE,
                       "ENABLED-TABLES-IN-QUERY-":U + _U._NAME,
                       "&1-ENABLED-TABLE-IN-QUERY-":U + _U._NAME,
                       18, " ":U).
    END.
    
    /* ### Here is my patch for the Bug number: 20000107-061. Alex */
    IF bf_cnt > 0 AND buf-disp-flds <> ? THEN
      PUT STREAM P_4GL UNFORMATTED buf-disp-flds SKIP. 
    
    IF bef_cnt > 0 AND buf-enabl-flds <> ? THEN
      PUT STREAM P_4GL UNFORMATTED buf-enabl-flds SKIP.
    
    /* ### MESSAGE buf-enabl-flds buf-disp-flds VIEW-AS ALERT-BOX.     */
    
    /* For SmartData */
    IF _U._TYPE = "QUERY":U AND _U._SUBTYPE = "SmartDataObject":U THEN 
    DO:

      /* ENABLED-FIELDS */
      PUT STREAM P_4GL UNFORMATTED "&Scoped-Define ENABLED-FIELDS ".
      tmp_code = "":U.
      FOR EACH _BC WHERE _BC._x-recid = RECID(_U) 
                        AND _BC._ENABLED BY _BC._SEQUENCE:
        tmp_item = _BC._DISP-NAME.
        IF LENGTH(tmp_code + tmp_item, "raw":U) > 75 THEN DO:
           PUT STREAM P_4GL UNFORMATTED tmp_code "~~" SKIP.
           tmp_code = "".
        END.
        tmp_code = tmp_code + " " + tmp_item.
      END.
      ASSIGN cEnabledFields = REPLACE(tmp_code,"~~","").
      PUT STREAM P_4GL UNFORMATTED tmp_code SKIP.
      

      /* ENABLED-FIELDS-IN-<dbname>... */
      RUN put_tblFldList 
          (_Q._TblList,
          "ENABLED-FIELDS-IN-", 
          " " /* Space delimited */
          ).

      /* DATA-FIELDS */
      PUT STREAM P_4GL UNFORMATTED "&Scoped-Define DATA-FIELDS ".
      tmp_code = "":U.
      FOR EACH _BC WHERE _BC._x-recid = RECID(_U) BY _BC._SEQUENCE:
        tmp_item = _BC._DISP-NAME.
        IF LENGTH(tmp_code + tmp_item, "raw":U) > 75 THEN DO:
           PUT STREAM P_4GL UNFORMATTED tmp_code "~~" SKIP.
           tmp_code = "".
        END.
        tmp_code = tmp_code + " " + tmp_item.
      END.
      PUT STREAM P_4GL UNFORMATTED tmp_code SKIP.
      
      /* Now DATA-FIELDS-IN-<tbl-name> */
      RUN put_tblFldList 
          (_Q._TblList,
          "DATA-FIELDS-IN-", 
          " " /* Space delimited */
          ).
     
      

      /* MANDATORY-FIELDS */
      PUT STREAM P_4GL UNFORMATTED "&Scoped-Define MANDATORY-FIELDS ".
      tmp_code = "":U.
      FOR EACH _BC WHERE _BC._x-recid = RECID(_U) 
                        AND _BC._MANDATORY BY _BC._SEQUENCE:
        tmp_item = _BC._DISP-NAME.
        IF LENGTH(tmp_code + tmp_item, "raw":U) > 75 THEN DO:
           PUT STREAM P_4GL UNFORMATTED tmp_code "~~" SKIP.
           tmp_code = "".
        END.
        tmp_code = tmp_code + " " + tmp_item.
      END.
      PUT STREAM P_4GL UNFORMATTED tmp_code SKIP.

      /* APPLICATION-SERVICE */
      PUT STREAM P_4GL UNFORMATTED "&Scoped-Define APPLICATION-SERVICE " +
              (IF _P._partition ne "(None)" THEN _P._partition ELSE "")
              SKIP.

      /* ASSIGN-LIST 
       * There is ADM code that's dependent on the exact format
       * of the ASSIGN-LIST preprocessor which has the assignments of data object
       * column names which have been changed. 
       * Be aware if you're ever in this code that generates ASSIGN-LIST.
       */
      PUT STREAM P_4GL UNFORMATTED "&Scoped-Define ASSIGN-LIST ":U.
      tmp_code = "":U.
      FOR EACH _BC WHERE _BC._x-recid = RECID(_U) 
                       AND _BC._DBNAME <> "_<CALC>":U
                       AND _BC._DISP-NAME <> _BC._NAME 
                AND _BC._DISP-NAME <> ?
                AND _BC._DISP-NAME <> "":U
                AND _BC._NAME <> "":U
                AND _BC._NAME <> ?
                BY _BC._SEQUENCE:
        ASSIGN tmp_item = " rowObject." + _BC._DISP-NAME + " = " +
                               db-fld-name("_BC":U, RECID(_BC)).
        IF LENGTH(tmp_code + tmp_item, "raw":U) > 75 THEN DO:
           PUT STREAM P_4GL UNFORMATTED tmp_code "~~" SKIP.
           tmp_code = "".
        END.
        tmp_code = tmp_code + " " + tmp_item.
      END. /* FOR EACH _BC */

      /* Note that LIST-1 etc. is part of put_win_preproc_vars */

      PUT STREAM P_4GL UNFORMATTED tmp_code SKIP.

      IF NOT skip_queries THEN DO:

         /* We will not attempt to generate this when we are checking CALC
          * Field Syntax.
          * DATA-FIELD-DEFS 
          * Generate the <smartdata>.i with temp table definition
          *        FIELD a LIKE customer.name
          *           ...
          */
         ASSIGN
           tmp_file      = ""
           lSaveAs       = (IF _save_mode eq "" THEN FALSE ELSE
                             ENTRY(1,_save_mode) eq "T":U)
           lSaveUntitled = (IF _save_mode eq "" THEN FALSE ELSE
                             ENTRY(2,_save_mode) eq "T":U).

         /* Handle Save As cases where local file is being saved remotely or 
            remote file is being saved locally.  Strip off the file path, 
            since it will invariably be invalid. */
         IF lSaveAs AND _save_file ne "" AND _save_file ne ? AND
           ((    _remote_file AND _P._broker-url eq "") OR
            (NOT _remote_file AND _P._broker-url ne "")) THEN DO:
           RUN adecomm/_osprefx.p (_save_file, OUTPUT cPath, OUTPUT cName).
           _save_file = cName.
         END.

         IF (NOT lSaveAs AND _P._broker-url ne "") OR 
            (    lSaveAs AND _remote_file        ) OR lSaveUntitled THEN DO:
           web_file = TRUE.
           RUN adecomm/_tmpfile.p ("ws":U, ".tmp":U, OUTPUT tmp_file).
         END.

         /* Save the SmartData include file <smartdata>.i to a temporary file
            unless saving or exporting. In that case, use the real .i name. */         
         IF NOT CAN-DO("EXPORT,SAVE,SAVEAS,PRINT",p_status) OR
           (p_status = "PRINT":U AND _save_file = ?) OR
           /* To handle CHECK-SYNTAX of untitled, remote Web object */
           (web_file AND p_status = "SAVE:CHECK":U) THEN DO:
           ASSIGN
             sdo_temp-file    = _comp_temp_file + ".i":U
             sdo_temp-fileInW = sdo_temp-file.
             
           IF (web_file AND p_status = "SAVE:CHECK":U) THEN DO:
             RUN adecomm/_osprefx.p (sdo_temp-fileInW, OUTPUT cPath, 
                                     OUTPUT sdo_temp-fileInW).
                                     
             /* web-tmp-file is used in adeuib/uibmproa.i [choose_check_syntax]
                to identify the remote [file].ab.i file to delete after check
                syntax. */
             web-tmp-file = sdo_temp-fileInW.
           END.
         END.
         ELSE DO:
           /* ALWAYS save the .i in the same directory as the .w
            * BUT within the .w, output a relative path if available 
            *    _save_file = .w filename
            *    sdo_temp-file = .i filename
            *    sdo_temp-fileInW = .i filename in the .w
            */
         /* SONIA */
           RUN adecomm/_osfext.p  (_save_file, OUTPUT cTemp).
           ASSIGN sdo_temp-file = (SUBSTRING(_save_file,1,LENGTH(_save_file) 
                                      - LENGTH(cTemp)) + ".i":U).
           RUN adecomm/_relname.p (_save_file, "MUST-BE-REL":U,
                                   OUTPUT sdo_temp-fileInW).
           /* If ?, it means that the user is attempting to save the include 
            * file into a directory that is not part of the PROPATH, therefore 
            * use the fully pathed directory given for saving!  Output fully 
            * pathed directory into .w, else everything is relative. */
           ASSIGN sdo_temp-fileInW = IF sdo_temp-fileInW = ? THEN 
                                    (SUBSTRING(_save_file,1,LENGTH(_save_file) 
                                      - LENGTH(cTemp)) + ".i":U) ELSE
                                    (SUBSTRING(sdo_temp-fileInW,1,LENGTH(sdo_temp-fileInW) 
                                      - LENGTH(cTemp)) + ".i":U).
         END. /* Export and Save */

         /*
         message "[_genproc.i] put_query_preproc_vars #1" skip
           "p_status" p_status skip
           "_save_file" _save_file skip
           "_save_mode" _save_mode skip
           "_remote_file" _remote_file skip
           "sdo_temp-file" sdo_temp-file skip
           "sdo_temp-fileInW" sdo_temp-fileInW skip
           "tmp_file" tmp_file skip
           "web_file" web_file skip
           "lSaveAs" lsaveas skip
           "lSaveUntitled" lsaveuntitled skip
           "_comp_temp_file " _comp_temp_file skip
           view-as alert-box.
         */
         

         /* Remove X:/ (where X is the MS-DOS drive letter) if it can be found in
            the propath - IZ 9617                                                 */
         IF sdo_temp-fileInW MATCHES ".:*":U THEN DO:
           IF LOOKUP( SUBSTRING(sdo_temp-fileInW,1, 2, "CHARACTER") + "~/":U ,PROPATH) > 0 OR
              LOOKUP( SUBSTRING(sdo_temp-fileInW,1, 2, "CHARACTER") + "~\":U ,PROPATH) > 0 THEN
             sdo_temp-fileInW = TRIM(SUBSTRING(sdo_temp-fileInW, 4, -1, "CHARACTER")).
         END.


         OUTPUT STREAM P_4GLSDO TO 
           VALUE(IF web_file THEN tmp_file ELSE sdo_temp-file).
         PUT STREAM P_4GL UNFORMATTED 
           '&Scoped-Define DATA-FIELD-DEFS "' sdo_temp-fileInW '"' SKIP.
         tmp_code = "":U.
         
         FOR EACH _BC WHERE _BC._x-recid = RECID(_U) BREAK BY _BC._SEQUENCE:
           IF _BC._DBNAME <> "_<CALC>":U THEN
             tmp_item = "  FIELD ":U + _BC._DISP-NAME + " LIKE ":U +
                          dbtt-fld-name(RECID(_BC)).
           ELSE
             tmp_item = "  FIELD ":U + _BC._DISP-NAME + " AS ":U + CAPS(_BC._DATA-TYPE).

           PUT STREAM P_4GLSDO UNFORMATTED tmp_item.
           /* valid field-options FORMAT and LABEL */
           ASSIGN tmp_code = "     ":U
                  tmp_item = "":U.
           IF _BC._INHERIT-VALIDATION AND _BC._DBNAME <> "_<CALC>":U THEN
              tmp_item = tmp_item + ' VALIDATE '.
           IF _BC._FORMAT NE ? AND 
              _BC._FORMAT NE "":U AND
              _BC._FORMAT NE _BC._DEF-FORMAT THEN 
              tmp_item = tmp_item + ' FORMAT "':U + TRIM(_BC._FORMAT) + '"':U.
           IF _BC._LABEL NE ? AND 
              _BC._LABEL NE "":U AND
              _BC._LABEL NE _BC._DEF-LABEL THEN
              tmp_item = tmp_item + ' LABEL "':U + TRIM(_BC._LABEL) + '"':U.
           IF _BC._HELP NE ? AND 
              _BC._HELP NE "":U AND
              _BC._HELP NE _BC._DEF-HELP THEN 
              tmp_item = tmp_item + ' HELP "':U + TRIM(_BC._HELP) + '"':U.
              
           PUT STREAM P_4GLSDO UNFORMATTED tmp_item.
           IF NOT LAST(_BC._SEQUENCE) THEN 
             PUT STREAM P_4GLSDO UNFORMATTED "~~":U.
           PUT STREAM P_4GLSDO UNFORMATTED SKIP.
         END. /* FOR EACH _BC */
         OUTPUT STREAM P_4GLSDO CLOSE.
         
         /* Save SmartData file to a WebSpeed agent, except for PREVIEW and PRINT case. */
         IF web_file AND p_status NE "PREVIEW":U AND p_status NE "PRINT":U THEN DO:
           RUN adeweb/_webcom.w (RECID(_P), 
                                 (IF _P._broker-url = "" OR lSaveAs THEN 
                                   _BrokerURL ELSE _P._broker-url), 
                                 sdo_temp-fileInW,
                                 "SAVE":U, 
                                 OUTPUT cRelName, 
                                 INPUT-OUTPUT tmp_file).
           IF RETURN-VALUE BEGINS "ERROR:":U THEN DO:
             cReturnValue = SUBSTRING(RETURN-VALUE,8,-1,"CHARACTER":U).
             RUN adecomm/_s-alert.p (INPUT-OUTPUT lOK, "error":U, "ok":U,
               SUBSTITUTE("&1 could not be saved for the following reason:^^&2",
               sdo_temp-fileInW, cReturnValue)).
           END.
           OS-DELETE VALUE(tmp_file).
         END.
         /* Generate Data Logic procedure for SDO */
         FIND ipU WHERE ipU._HANDLE = _P._WINDOW-HANDLE.
         FIND ipC WHERE RECID(ipC) = ipU._x-recid.
         IF ipC._DATA-LOGIC-PROC-NEW  AND IPC._DATA-LOGIC-PROC > "" THEN
         DO:
              ASSIGN ipC._DATA-LOGIC-PROC = REPLACE(ipC._DATA-LOGIC-PROC,"~\":U,"/")
                     cRelDirectory        = SUBSTRING(ipC._DATA-LOGIC-PROC,1,R-INDEX(ipC._DATA-LOGIC-PROC,"/") - 1)
                     NO-ERROR.
              IF NUM-ENTRIES(ipC._DATA-LOGIC-PROC,"/") > 1 THEN 
                 cRoot = SUBSTRING(ipC._DATA-LOGIC-PROC,1,R-INDEX(ipC._DATA-LOGIC-PROC,"/":U) - 1).
              ELSE
                 cRoot = ".".   
              FILE-INFO:FILE-NAME = cRoot NO-ERROR.
              ASSIGN cRoot = REPLACE(FILE-INFO:FULL-PATHNAME,"~\":U,"/")
                     cRoot = SUBSTRING(croot,1,R-INDEX(croot,crelDirectory) - 2)
                     cRoot = RIGHT-TRIM(cRoot,"/":U)
                     NO-ERROR.
              /* Strip off the db name from the table list */
              DO i = 1 TO NUM-ENTRIES(tables_in_query):
                 IF NUM-ENTRIES(TRIM(ENTRY(i,tables_in_query)),".") = 2 THEN
                    ENTRY(i,tables_in_query) = ENTRY(2, TRIM(ENTRY(i,tables_in_query)), ".").
              END.
              /* generate temp Table or Buffer Define statement */
              FOR EACH _TT WHERE _TT._p-recid = RECID(_P) :  
                 CASE _TT._TABLE-TYPE:        
                    WHEN "T":U THEN
                    DO:
                        cTempTableDef = cTempTableDef +  "DEFINE ":U 
                                      + (IF _TT._SHARE-TYPE NE ""  THEN (_TT._SHARE-TYPE + " ":U) ELSE "") 
                                      + "TEMP-TABLE " 
                                      + (IF _TT._NAME = ? THEN _TT._LIKE-TABLE ELSE _TT._NAME) 
                                      + (IF _TT._UNDO-TYPE = "NO-UNDO":U THEN " NO-UNDO":U ELSE "":U) 
                                      + " LIKE ":U + _TT._LIKE-DB + ".":U + _TT._LIKE-TABLE 
                                      + (IF _TT._ADDITIONAL_FIELDS NE "":U 
                                         THEN (CHR(10) + "       ":U + REPLACE(_TT._ADDITIONAL_FIELDS, CHR(10),CHR(10) + "       ":U) + ".":U) 
                                         ELSE ".") + CHR(10).
                    END.
              
                    WHEN "B":U THEN
                    DO:
                       cTempTableDef = cTempTableDef 
                                        + "&IF '~{&DB-REQUIRED~}' = 'TRUE' OR DEFINED~(DB-REQUIRED~) = 0  &THEN" 
                                        + CHR(10) + "DEFINE ":U 
                                        + (IF _TT._SHARE-TYPE NE "" THEN (_TT._SHARE-TYPE + " ":U) ELSE "") 
                                        + "BUFFER " + _TT._NAME +  " FOR ":U + _TT._LIKE-DB + ".":U 
                                        + _TT._LIKE-TABLE + ".":U +   CHR(10)
                                        + "&ENDIF":U + CHR(10).
                    END.
                 END CASE.
              END.                 


              RUN adeuib/_gendatalog.p          
                 (INPUT ipC._DATA-LOGIC-PROC,           /* Rel pathed file name  */
                  INPUT cRoot + "/":U,                  /* Root folder */
                  INPUT ipC._DATA-LOGIC-PROC-TEMPLATE,   /* Template File */
                  INPUT tables_in_query,                 /* Tables */
                  INPUT cEnabledFields ,                 /* Enabled Fields */
                  INPUT "" ,                             /* Validation Fields */                          
                  INPUT sdo_temp-fileInW,                /* Definition IncludeName */
                  NO,                                    /* Create missing dir */
                  NO,                                     /* Suppress Validation */
                  cTempTableDef                          /* Temp table definition */
                  ).
         END. 
         
      END. /* If not skip_queries */

    END. /* SmartData */

    /* Open any browse/query that should be open in the FRAME. */
    tmp_code = "".
    FOR EACH ipU WHERE ipU._parent-recid = RECID(_U)
                   AND ipU._STATUS <> "DELETED" 
                   AND ipU._TYPE eq "BROWSE":U
               BY ipU._NAME:
       FIND ipC WHERE RECID(ipC) = ipU._x-recid.
       FIND ipQ WHERE RECID(ipQ) = ipC._q-recid.
       IF ipQ._OpenQury AND
         (ipQ._TblList NE "" OR CAN-FIND(_TRG WHERE _TRG._wRECID = RECID(ipU) AND
                                              _TRG._tEVENT = "OPEN_QUERY":U)) THEN
       DO:
         /* create a new line in the output and preface it with a tilda for
            indirection to the open query for the browse.  */
         tmp_code = tmp_code + "~~" + CHR(10) + "    ~~~{&OPEN-QUERY-" + ipU._NAME + "}".
       END. /* If open valid query */
    END. /* For each browse */

    /*  Put out the preprocessor variable */
    IF tmp_code ne "" 
    THEN PUT STREAM P_4GL UNFORMATTED 
            "&Scoped-define OPEN-BROWSERS-IN-QUERY-" + _U._NAME + " " + tmp_code 
             SKIP.
  END. /* IF...query is a...FRAME or DIALOG-BOX...*/
  
  /* Now put out the Open Query and related TABLE  names (if there is one) */
  FIND _TRG WHERE _TRG._wRECID = RECID(_U) AND
                  _TRG._tEVENT = "OPEN_QUERY":U NO-ERROR.
  IF AVAILABLE _TRG THEN DO:
    PUT STREAM P_4GL UNFORMATTED 
       "&Scoped-define SELF-NAME " + _U._NAME SKIP.
    
    ASSIGN tmp_item = RIGHT-TRIM(_TRG._tCODE).
    DO i = 1 TO NUM-ENTRIES(tmp_item,CHR(10)):
      /* Remove white space at end of each line */
      ENTRY(i,tmp_item,CHR(10)) = RIGHT-TRIM(ENTRY(i,tmp_item,CHR(10))).
    END.
    ASSIGN _TRG._tCODE = tmp_item
           tmp_item    = REPLACE(REPLACE(RIGHT-TRIM(tmp_item,".:":U),CHR(10)," ":U),
                              ",":U,", ~~" + CHR(10) + FILL(" ":U,6)).
    /* IF we had a freeform qury (from _TRG) then load _Q._TblList FROM tmp_item */
    run build_table_list (INPUT tmp_item, INPUT ",":U, 
                          INPUT NO, /* If this flag is set to yes, temp-tables
                                       do not work. */
                          INPUT-OUTPUT _Q._TblList). 
  END. 
  ELSE IF _Q._TblList ne "" THEN DO:
    RUN adeshar/_coddflt.p (INPUT "_OPEN-QUERY", INPUT RECID(_U),
                            OUTPUT tmp_item).

    /* If there are any query-tining options prepare them for output */
    IF tmp_item NE "" THEN 
      ASSIGN TuneOpts = REPLACE(REPLACE(TRIM(_Q._TuneOptions),CHR(13),""),
                       CHR(10)," ~~" + CHR(10) + "              ")
             /* Add Tuning Options to the Open Query line. */
             tmp_item = tmp_item +
                  (IF TuneOpts NE "" THEN " QUERY-TUNING (" + TuneOpts + ")"
                                     ELSE "").
  END.      
  
  IF tmp_item NE "" THEN
  DO:
    IF LEFT-TRIM(tmp_item) BEGINS "OPEN QUERY" THEN
      ASSIGN 
        cOpenQuery   = LEFT-TRIM(tmp_item)
                       /* remove open query */
        cQueryString = LEFT-TRIM(SUBSTR(cOpenQuery,11)) 
                       /* Find first blank to remove query name */
        cQueryString = SUBSTR(cQueryString,INDEX(cQueryString," ":U) + 1).
    
    ELSE IF (tmp_item BEGINS "FOR EACH":U OR
             tmp_item BEGINS "FOR FIRST":U OR
             tmp_item BEGINS "FOR LAST":U) THEN 
      ASSIGN 
        cQueryString = tmp_item
        cOpenQuery   = "OPEN QUERY " + _U._name + " " + cQueryString.

    ELSE IF (tmp_item BEGINS "EACH":U OR
             tmp_item BEGINS "FIRST":U OR
             tmp_item BEGINS "LAST":U) THEN 
      ASSIGN
        cQueryString = (IF LOOKUP ("Preselect":U, _Q._OptionList, " ":U) eq 0
                        THEN " FOR ":U ELSE " PRESELECT ":U )
                        + tmp_item
        cOpenQuery   = "OPEN QUERY " + _U._name + cQueryString.
 
    ELSE  
       /* If we don't understand the query we cannot generate the query string*/
       cOpenQuery = tmp_item.
    
     /* From 9.1D we generate a query-string-query-main outside the db-required 
        preporcessor. The fact that the open-query-query-main was put inside 
        db-required made it difficult to use 'one-hit-appserver-requests' at 
        initialization since any query manipulation then would require this info 
        to be retrieved from the server.
        We skip this if QueryString is blank, which would be the case when we 
        could not extract this info (This may happen if we have a Free Form 
        query with definitions or comments.). */ 
    IF cQueryString <> '':U THEN
      PUT STREAM P_4GL UNFORMATTED 
       "&Scoped-define QUERY-STRING-" + _U._NAME + " " +
           TRIM(cQueryString) SKIP.

    /* Db-Required Start Preprocessor block. */
    IF _P._DB-AWARE THEN
        PUT STREAM P_4GL UNFORMATTED '~{&DB-REQUIRED-START~}' SKIP.

    PUT STREAM P_4GL UNFORMATTED 
       "&Scoped-define OPEN-QUERY-" +  _U._NAME + " " +
            cOpenQuery + "." SKIP.
    /* Db-Required End Preprocessor block. */
    IF _P._DB-AWARE THEN
        PUT STREAM P_4GL UNFORMATTED '~{&DB-REQUIRED-END~}' SKIP.
  END.
    
  /* Now put the TABLES-IN-QUERY.  BROWSE and SMARTDATA 
   * Incresed count from 1 to 10... although put_tbllist still as restriction to 3
   */
  RUN put_tbllist (_Q._TblList,
                     _U._SHARED AND _U._TYPE = "BROWSE":U,
                     "TABLES-IN-QUERY-" + _U._NAME,
                     "&1-TABLE-IN-QUERY-" + _U._NAME, 
                     18,  /* Only put the first table. */
                     " " /* Space delimited */
                     ).
  /* Skip a line before next section */
  PUT STREAM P_4GL UNFORMATTED SKIP(1).
END. /* put_query_preproc_vars */


/* put_tbllist: Put out the contents of pc_TblList variable.  Note that the
   list can beof the form
       sports.Customer,sports.Order OF sports.Customer.
   A bunch of preprocessor variables are created:
       p_tables_var -- all tables
       p_ith_var -- ith table in the list. (up to pi_max)
            This variable has the form "&1-ENABLED-TABLE".  The &1 is replaced with
            FIRST,SECOND,THIRD,FOURTH,FIFTH,SIXTH,SEVENTH,EIGHTH,NINTH,TENTH
            (up to 10 variables).
   Note:
       pl_shared -- the tables are shared, so replace "." with "_"
                    [i.e. sports.customer becomes buffer sports_customer]
*/
PROCEDURE put_tbllist:
  define input parameter pc_tbllist as char no-undo.
  define input parameter pl_shared as logical no-undo.
  define input parameter p_table_var as char no-undo.
  define input parameter p_ith_var as char no-undo.
  define input parameter p_imax as integer no-undo.
  define input parameter p_delim as char no-undo.
  
  DEFINE VAR cnt       AS INTEGER NO-UNDO.
  DEFINE VAR i         AS INTEGER NO-UNDO.
  DEFINE VAR tmp_code  AS CHAR NO-UNDO.
  DEFINE VAR more_code AS CHAR NO-UNDO.
  DEFINE VAR tmp_item  AS CHAR NO-UNDO.

  /* Do we need this section at all */
  cnt = NUM-ENTRIES(pc_TblList).
  IF cnt > 0 THEN DO:    
    /* we support 18 items, (max supported tables in a join) */
    IF p_imax > 18 THEN p_imax = 18.                         
    tmp_code = "&Scoped-define " + p_table_var + " ".
    DO i = 1 TO cnt:
      tmp_item = ENTRY (1, TRIM (ENTRY (i,pc_TblList)), " ").
      IF NUM-ENTRIES(tmp_item,".") > 1 THEN
         tmp_item = db-tbl-name(tmp_item).
      IF pl_shared THEN DO:
        IF _suppress_dbname THEN tmp_item = tmp_item + "_".
                            ELSE tmp_item = REPLACE(tmp_item,".","_").
      END.
      IF i <= p_imax THEN
        more_code = more_code 
            + "&Scoped-define " 
            + SUBSTITUTE(p_ith_var, ENTRY(i,
                "FIRST,SECOND,THIRD,FOURTH,FIFTH,SIXTH,SEVENTH,EIGHTH,NINTH,TENTH,":U + 
                "ELEVENTH,TWELFTH,THIRTEENTH,FOURTEENTH,FIFTEENTH,SIXTEENTH,SEVENTEENTH,EIGHTEENTH":U)) + " " 
            + tmp_item
            + CHR(10).
      
      IF LENGTH(tmp_code + tmp_item, "raw":U) > 75 THEN DO:
        PUT STREAM P_4GL UNFORMATTED tmp_code "~~" SKIP.
        tmp_code = "".
      END.
      tmp_code = tmp_code + tmp_item + (IF i < cnt THEN p_delim  ELSE "").
    END.
    /* Finish putting out the line. */
    IF tmp_code ne "" THEN PUT STREAM P_4GL UNFORMATTED tmp_code SKIP.    
    /* Put out the additional code for NTH-enabled-table. */
    IF more_code ne "" THEN PUT STREAM P_4GL UNFORMATTED more_code.    
  END.
END PROCEDURE.


/* put_tblFldList: 
   Using the contents of pc_TblList variable, generate a list of fields
   for each table in the table list.  This will be called for two purposes:
   ENABLED-FIELDS-IN-<table-name> and DATA-FIELDS-IN-<table-name
   
   The p_ith_var (second parameter) determines which purpose it is being
   used for.
     
   A bunch of preprocessor variables are created:
       "&ENABLED-FIELDS-IN-Customer".  (for each table)
   or
       "&DATA-FIELDS-IN-Customer".  (for each table)
       
  Parameters:
       pc_tbllist    - table list where it  can be of the form
                       sports.Customer,sports.Order OF sports.Customer.
       p_delim       - delimeter to be used to separate the fields.

  RUN put_tblFldList 
          (_Q._TblList,
          "&ENABLED-FIELDS-IN-", 
          " " /* Space delimited */
          ).

                     "TABLES-IN-QUERY-" + _U._NAME,
*/
PROCEDURE put_tblFldList:
  DEFINE INPUT PARAMETER pc_tbllist AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER p_ith_var  AS CHARACTER  NO-UNDO.
  DEFINE INPUT PARAMETER p_delim    AS CHARACTER  NO-UNDO.
  
  DEFINE VARIABLE cnt               AS INTEGER    NO-UNDO.
  DEFINE VARIABLE i                 AS INTEGER    NO-UNDO.
  DEFINE VARIABLE more_code         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tblName           AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE db                AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tmp_code          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE tmp_item          AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hasFlds           AS LOGICAL    NO-UNDO.

  /* Do we need this section at all */
  ASSIGN cnt = NUM-ENTRIES(pc_TblList).
  IF cnt > 0 THEN DO:    
    DO i = 1 TO cnt:
      ASSIGN hasFlds    = NO
             more_code  = "&Scoped-define " + p_ith_var
             tmp_item   = ENTRY (1, TRIM (ENTRY (i,pc_TblList)), " ")
             db         = ENTRY(1,tmp_item,".":U)
             tmp_item   = IF NUM-ENTRIES(tmp_item,".") > 1 THEN
                             db-tbl-name(tmp_item) ELSE tmp_item
             tblName    = IF NUM-ENTRIES(tmp_item,".") > 1 THEN
                             ENTRY(2,tmp_item,".") ELSE tmp_item

             more_code  = more_code + tmp_item + " ".

      IF NUM-ENTRIES(tmp_item,".") = 1 THEN DO:
        FIND FIRST _TT WHERE _TT._p-recid = RECID(_P)
                         AND _TT._NAME = tmp_item NO-ERROR.
        IF AVAILABLE _TT THEN db = "Temp-Tables":U.
      END.  /* if tmp_item has one item */

      FOR EACH _BC WHERE _BC._x-recid = RECID(_U)
                     AND _BC._DBNAME  = db
                     AND _BC._TABLE   = tblName
                     AND (_BC._ENABLED OR p_ith_var BEGINS "DATA-FIELDS")
                     BY _BC._SEQUENCE:
         IF LENGTH(more_code + _BC._DISP-NAME, "raw":U) > 75 THEN DO:
           PUT STREAM P_4GL UNFORMATTED more_code "~~" SKIP.
           more_code = "".
         END.
         ASSIGN hasFlds   = YES
                more_code = more_code + _BC._DISP-NAME + p_delim.
      END.

      /* Finish putting out the line. */
      IF more_code NE "" AND hasFlds THEN 
      PUT STREAM P_4GL UNFORMATTED more_code SKIP.    
    END. /* each table */
  END. /* some tables to work with */
END PROCEDURE. /* put_tblFldList */


/* Put the list of links supported by the current object.   This is the
   fixed list for SmartObjects, and a list of used internal links, for 
   SmartContainers. */
PROCEDURE put_links: 
  DEFINE VAR Precid    AS RECID NO-UNDO.
  DEFINE VAR cPrecid   AS CHAR NO-UNDO.
  DEFINE VAR cXrecid   AS CHAR NO-UNDO.
  DEFINE VAR cLinkName AS CHAR NO-UNDO.
  DEFINE VAR links     AS CHAR NO-UNDO.

  /* Container objects contain many possible internal links. */
  IF (NOT CAN-DO (_P._Allow, "Smart")) OR
     (_P._adm-version >= "ADM2":U AND CAN-DO(_P._Allow,"Smart":U))
  THEN links = _P._links.
  ELSE DO:
    ASSIGN Precid  = RECID(_P)
           cPrecid = STRING(Precid).
    /* Find all the instances where the container can pass through a TARGET.
       (that is, where the container is a SOURCE for internal links). Also
       find the instances where the container can pass through a SOURCE.
       NOTE: the only pass through links are Navigation, Record and TableIO. */
    FOR EACH _admlinks WHERE (_admlinks._p-recid eq Precid)
                         AND CAN-DO ("NAVIGATION,RECORD,TABLEIO",
                                     _admlinks._link-type)
                         AND ( _admlinks._link-source eq cPrecid OR
                               _admlinks._link-dest eq cPrecid ):
      /* Is the container a SOURCE or a TARGET */
      IF _admlinks._link-source eq cPrecid
      THEN ASSIGN cXrecid   = _admlinks._link-dest
                  cLinkName = _admlinks._link-type + "-Target".
      ELSE ASSIGN cXrecid   = _admlinks._link-source
                  cLinkName = _admlinks._link-type + "-Source".
      FIND x_U WHERE RECID(x_U) eq INTEGER(cXrecid).
      /* Don't record deleted links. */
      IF x_U._STATUS ne "DELETED" THEN DO:
        IF NOT CAN-DO(links, cLinkName) 
        THEN links = links + (IF links eq "" THEN "" ELSE ",") + cLinkName.
      END. /* IF not deleted */
    END. /* FOR EACH link...*/
  END. /* IF...a SmartContainer...*/
  
  /* Now put out the ADM Supported Links */
  IF links ne "" THEN PUT STREAM P_4GL UNFORMATTED 
    "&Scoped-define ADM-SUPPORTED-LINKS " TRIM(links) SKIP (1).

END PROCEDURE.

/* Put the list of tables FOUND in any way in this procedure, that are not
   in the external tables list. */
PROCEDURE put_tbllist_internal: 
  DEFINE VAR cnt       AS INTEGER NO-UNDO.
  DEFINE VAR i         AS INTEGER NO-UNDO.
  DEFINE VAR tbls-in-q AS CHAR    NO-UNDO.
  DEFINE VAR tbllist   AS CHAR    NO-UNDO.
  DEFINE VAR tmp_code  AS CHAR    NO-UNDO.
  DEFINE VAR tmp_item  AS CHAR    NO-UNDO.
  
  /* Now add the tables found by all Browses and Frames */
  FOR EACH x_U WHERE x_U._WINDOW-HANDLE eq _P._WINDOW-HANDLE
                 AND x_U._STATUS eq "NORMAL":U
                 AND CAN-DO("BROWSE,DIALOG-BOX,FRAME,QUERY", x_U._TYPE)
               BY x_U._NAME BY x_U._TYPE:
      FIND _C WHERE RECID(_C) eq x_U._x-recid.
      FIND _Q WHERE RECID(_Q) eq _C._q-recid.

    FIND _TRG WHERE _TRG._wRECID = RECID(x_U) AND
                    _TRG._tEVENT = "OPEN_QUERY":U NO-ERROR.
    IF AVAILABLE _TRG THEN DO:
        ASSIGN tbls-in-q = _Q._TblList.
        RUN build_table_list (INPUT _TRG._tCODE, INPUT ",":U, 
                            INPUT NO, /* If this flag is set to yes, temp-tables
                                         do not work. */
                            INPUT-OUTPUT tbls-in-q).
    END.
    ELSE tbls-in-q = _Q._TblList.
    
    cnt = NUM-ENTRIES(tbls-in-q).
    DO i = 1 TO cnt:
      tmp_item = ENTRY (1, TRIM (ENTRY (i,tbls-in-q)), " ").
      IF NOT CAN-DO (_P._xTblList, tmp_item) THEN DO:
        IF NUM-ENTRIES(tmp_item,".":U) > 1 THEN
          tmp_item = db-tbl-name(tmp_item).
        IF NOT CAN-DO(tblList, tmp_item) THEN
          tblList = tblList + tmp_item + ",".
      END.  /* If not in the external table list */
    END.  /* DO i 1 to cnt */
  END.  /* For each thing that can have a query */
  
  /* Do we need this section at all?  Note that there is an extra "," at the
     end of tbllist. */
  cnt = NUM-ENTRIES(tbllist) - 1.
  IF cnt > 0 THEN DO:                                
    PUT STREAM P_4GL UNFORMATTED
      "/* Internal Tables (found by Frame, Query & Browse Queries)             */"
      SKIP.
    tmp_code = "&Scoped-define INTERNAL-TABLES ".
    DO i = 1 TO cnt:
      tmp_item = ENTRY (i,tblList).
      IF LENGTH(tmp_code + tmp_item, "raw":U) > 75 THEN DO:
        PUT STREAM P_4GL UNFORMATTED tmp_code "~~" SKIP.
        tmp_code = "".
      END.
      tmp_code = tmp_code + tmp_item + (IF i < cnt THEN " ":U ELSE "").
    END.
    /* Finish putting out the line. */
    IF tmp_code ne "" THEN PUT STREAM P_4GL UNFORMATTED tmp_code SKIP.
    /* Skip line before next section */
    PUT STREAM P_4GL UNFORMATTED SKIP (1).  
  END.
END PROCEDURE.

/* Put out the window preprocessor variables --
   For each window (or dialog-box) write:
         Scoped-define ENABLED-FIELDS    <some db-fields>
         Scoped-define ENABLED-OBJECTS   <some non-db objects>
         Scoped-define DISPLAYED-FIELDS  <some db-fields>
         Scoped-define DISPLAYED-OBJECTS <some non-db objects>
         Scoped-define DISPLAY <some vars>
         Scoped-define LIST-1  <some vars>
         Scoped-define LIST-2  <some vars>
         Scoped-define LIST-3  <some vars>
  _h_win points to the current window/dialog-box.
*/
PROCEDURE put_win_preproc_vars:
  &IF {&MaxUserLists} ne 6 &THEN
  &MESSAGE [_gen4gl.p] *** FIX NOW *** User-List not being generated correctly (wood)
  &ENDIF   
  &Scope MaxLists 10
  /*  The extent of all these arrays should be MaxUserLists + 4  */
  DEFINE VAR tmp_code         AS CHAR    NO-UNDO EXTENT {&MaxLists}.
  DEFINE VAR tmp_line         AS CHAR    NO-UNDO EXTENT {&MaxLists}.
  DEFINE VAR displayed-tables AS CHARACTER NO-UNDO.
  DEFINE VAR enabled-tables   AS CHAR    NO-UNDO.
  DEFINE VAR emptyList        AS LOGICAL INITIAL YES NO-UNDO EXTENT {&MaxLists}.
  DEFINE VAR frm-recid        AS RECID   NO-UNDO.
  DEFINE VAR sdoName          AS CHAR    NO-UNDO.
  DEFINE VAR name             AS CHAR    NO-UNDO.
  DEFINE VAR add2list         AS LOGICAL NO-UNDO.
  DEFINE VAR sdoAdd2list      AS LOGICAL NO-UNDO.
  DEFINE VAR i                AS INTEGER NO-UNDO.
  DEFINE VAR list-cnt         AS INTEGER NO-UNDO.
  DEFINE VAR tblname          AS CHAR    NO-UNDO.
  DEFINE VAR widg2display     AS CHAR    NO-UNDO.
  DEFINE VAR widg2enable      AS CHAR    NO-UNDO.

  DEFINE BUFFER ipU for _U.
  DEFINE BUFFER ipx_BC for _BC.

  /* First take a quick pass through enabled non-tabable objects and give them
     a high tab-order number to establish a consistent sequence             */
  i = 100000.
  FOR EACH ipU WHERE ipU._STATUS ne "DELETED":U 
                 AND ipU._WINDOW-HANDLE eq _h_win
                 AND CAN-DO("TEXT,IMAGE,RECTANGLE,LABEL",ipU._TYPE)
                 AND _ENABLE
                  BY ipU._NAME:
    ASSIGN i              = i + 1
           ipU._TAB-ORDER = i.
  END.

  /* Find the RECID of the first frame */
  IF frame_name_f ne "" THEN DO:
    FIND ipU WHERE ipU._NAME eq frame_name_f 
               AND CAN-DO("FRAME,DIALOG-BOX":U, ipU._TYPE)
               AND ipU._WINDOW-HANDLE eq _h_win  
               AND ipU._STATUS BEGINS u_status.
    frm-recid = RECID(ipU).
  END.
  
  /* Find the widgets that can be ENABLEd or DISPLAYed (i.e. that have these on their
     property sheet */
  FIND _prop WHERE _prop._NAME eq "DISPLAY" NO-ERROR.
  IF NOT AVAILABLE _prop THEN RETURN.  /* Called from Freeze frame */
  widg2display = _prop._WIDGETS.
  FIND _prop WHERE _prop._NAME eq "ENABLE".
  widg2enable = _prop._WIDGETS.
  
  /* Create an alphabetic list of variables in each of the user defined
     lists of variables */ 
  DO i = 1 TO {&MaxUserLists}:
    tmp_line[i] = "&Scoped-define " + ENTRY(i, _P._LISTS) + " ".
  END.
  ASSIGN tmp_line[{&MaxUserLists} + 1] = "&Scoped-Define ENABLED-FIELDS "
         tmp_line[{&MaxUserLists} + 2] = "&Scoped-Define ENABLED-OBJECTS "
         tmp_line[{&MaxUserLists} + 3] = "&Scoped-Define DISPLAYED-FIELDS "
         tmp_line[{&MaxUserLists} + 4] = "&Scoped-Define DISPLAYED-OBJECTS "
         .
 
  /* If there is no frame, then don't bother with Enabled/Displayed Fields and
     Objects */
  list-cnt =  (IF frame_name_f ne "" THEN {&MaxLists} ELSE {&MaxUserLists}).

  /* Look for all variables in the window that have the list checked. */
  FOR EACH ipU WHERE ipU._STATUS ne "DELETED":U 
                 AND ipU._WINDOW-HANDLE eq _h_win
                  BY ipU._TAB-ORDER BY ipU._NAME:
    FIND _F WHERE RECID(_F) = ipU._x-recid NO-ERROR.
    
    /* ### Here is my patch for the Bug number: 20000107-061. Alex */
    IF ipU._BUFFER = ? THEN ASSIGN ipU._BUFFER = ipU._TABLE.
    /* ### */
    name = (IF ipU._TABLE EQ ? OR (AVAILABLE _F AND _F._DISPOSITION = "LIKE":U) THEN ipU._NAME
            ELSE 
            (IF LDBNAME(ipU._DBNAME) NE ? THEN
                db-tbl-name(LDBNAME(ipU._DBNAME) + "." + ipU._BUFFER) + "." +
                (IF _F._DISPOSITION = "FIELD" AND _F._LIKE-FIELD NE "" THEN _F._LIKE-FIELD ELSE ipU._NAME)
            ELSE ipU._BUFFER + "." + ipU._NAME)
            ).

    DO i = 1 TO list-cnt:
      /* Add the variable to the line IFF it has LIST-i checked, or if it
         is in the first-frame, and has ENABLE or DISPLAY, and the widget is
         the right "type". */
      IF i <= {&MaxUserLists} THEN 
        add2list = ipU._User-List[i].
        
      /* Enabled fields */
      ELSE IF i eq {&MaxUserLists} + 1 THEN
        add2list = (ipU._parent-recid eq frm-recid) AND 
                   ipU._ENABLE AND NOT ((ipU._DBNAME eq ? OR _F._DISPOSITION = "LIKE":U) OR
                   (ipU._DBNAME eq "Temp-Tables":U) AND 
                     (ipU._TABLE eq "{&WS-TEMPTABLE}":U)) AND
                   CAN-DO(widg2enable, ipU._TYPE).
                   
      /* Enabled objects */
      ELSE IF i eq {&MaxUserLists} + 2 THEN
        add2list = (ipU._parent-recid eq frm-recid) AND 
                   ipU._ENABLE AND ((ipU._DBNAME eq ? OR _F._DISPOSITION = "LIKE":U) OR 
                   (ipU._DBNAME eq "Temp-Tables":U) AND 
                     (ipU._TABLE eq "{&WS-TEMPTABLE}":U)) AND
                   CAN-DO(widg2enable, ipU._TYPE).
                   
      /* Displayed fields */
      ELSE IF i eq {&MaxUserLists} + 3 THEN
        add2list = (ipU._parent-recid eq frm-recid) AND 
                   ipU._DISPLAY AND NOT ((ipU._DBNAME eq ? OR _F._DISPOSITION = "LIKE":U) OR
                   (ipU._DBNAME eq "Temp-Tables":U) AND 
                     (ipU._TABLE eq "{&WS-TEMPTABLE}":U)) AND
                   CAN-DO(widg2enable, ipU._TYPE).
                   
      /* Displayed objects */
      ELSE 
        add2list = (ipU._parent-recid eq frm-recid) AND 
                   ipU._DISPLAY AND ((ipU._DBNAME eq ? OR _F._DISPOSITION = "LIKE":U) OR
                   (ipU._DBNAME eq "Temp-Tables":U) AND 
                     (ipU._TABLE eq "{&WS-TEMPTABLE}":U)) AND
                   CAN-DO(widg2display, ipU._TYPE).
                   
      IF add2list THEN DO:
        emptyList[i] = NO.
        /* Add the name to the existing line (unless that line is full,
           in which case, skip to the next line */             
        IF LENGTH(tmp_line [i] + name, "CHARACTER":U) > 75 THEN DO:
          tmp_code[i] = tmp_code[i] + tmp_line[i] + "~~" + CHR(10).
          tmp_line[i] = "".
        END.
        tmp_line[i] = tmp_line[i] + name + " ".

        /* Add to the DISPLAYED-TABLES list */
        IF NUM-ENTRIES(name,".":U) > 1 AND ((i = {&MaxUserLists} + 3) OR 
          (i = {&MaxUserLists} + 4 AND ipU._DBNAME eq "Temp-Tables":U AND 
          ipU._TABLE eq "{&WS-TEMPTABLE}":U)) THEN DO:
          tblname = ENTRY(1,name,".":U) +
                      (IF NUM-ENTRIES(name,".":U) = 3 THEN
                        ".":U + ENTRY(2,name,".":U) ELSE "":U).

          IF displayed-tables = "" THEN displayed-tables = tblname.
          ELSE IF NOT CAN-DO(displayed-tables, tblname) THEN
            displayed-tables = displayed-tables + ",":U + tblname.
        END.  /* populate displayed-tables */

        /* Add to the ENABLED-TABLES list */
        IF NUM-ENTRIES(name,".":U) > 1 AND ((i = {&MaxUserLists} + 1) OR 
          (i = {&MaxUserLists} + 2 AND ipU._DBNAME eq "Temp-Tables":U AND 
          ipU._TABLE eq "{&WS-TEMPTABLE}":U)) THEN DO:
          tblname = ENTRY(1,name,".":U) +
                      (IF NUM-ENTRIES(name,".":U) = 3 THEN
                        ".":U + ENTRY(2,name,".":U) ELSE "":U).

          IF enabled-tables = "" THEN enabled-tables = tblname.
          ELSE IF NOT CAN-DO(enabled-tables, tblname) THEN
            enabled-tables = enabled-tables + ",":U + tblname.
        END.  /* populate enabled-tables */
      END. /* IF in UserList */
    END. /* DO... */
  END. /* FOR EACH ipU */ 
  
  /* Add any remaining line into the code, and output it. */
  DO i = 1 TO {&MaxLists}:
    IF tmp_line[i] ne "" THEN tmp_code[i] = tmp_code[i] + tmp_line[i].
  END.
  
  /* Write Standard Lists - Note: there is no ENABLE or DISABLE if there
     is no frame */
  IF frame_name_f ne "" AND ((emptyList[{&MaxUserLists} + 1] eq NO) OR 
                            (emptyList[{&MaxUserLists} + 2] eq NO) OR
                            (emptyList[{&MaxUserLists} + 3] eq NO) OR 
                            (emptyList[{&MaxUserLists} + 4] eq NO))
  THEN DO:
    PUT STREAM P_4GL UNFORMATTED SKIP
    "/* Standard List Definitions                                            */"
    SKIP.
    DO i = {&MaxUserLists} + 1 TO {&MaxLists}:
      IF NOT emptyList[i] THEN DO:
        PUT STREAM P_4GL UNFORMATTED tmp_code[i] SKIP.
        IF (i = {&MaxUserLists} + 1) AND enabled-tables NE "" THEN
          RUN put_tbllist (enabled-tables, FALSE,
                           "ENABLED-TABLES":U, "&1-ENABLED-TABLE", 18, " ":U).
        IF (i = {&MaxUserLists} + 3) AND displayed-tables NE "" THEN
          RUN put_tbllist (displayed-tables, FALSE,
                           "DISPLAYED-TABLES":U, "&1-DISPLAYED-TABLE", 18, " ":U).
      END.  /* IF NOT emptylist */
    END.
    PUT STREAM P_4GL UNFORMATTED SKIP (1).
  END. 
  
  /* Write Custom Lists */ 
  PUT STREAM P_4GL UNFORMATTED SKIP
   "/* Custom List Definitions                                              */"
   SKIP
   "/* " _P._LISTS FILL(" ", 68 - LENGTH(_P._LISTS,"RAW")) " */"
   SKIP.
  DO i = 1 TO {&MaxUserLists}:
    IF NOT emptyList[i] THEN PUT STREAM P_4GL UNFORMATTED tmp_code[i] SKIP.
  END.
  
END PROCEDURE. /* put_win_preproc_vars */


/* Put out the pre-processors needed for each of the contained
   data objects in an SBO */
PROCEDURE put_contained_tables:
  DEFINE BUFFER   _U-Parent FOR _U.
  DEFINE BUFFER   _U-Object FOR _U.
  DEFINE BUFFER   x_S       FOR _S.
  DEFINE VARIABLE iCount    AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cFile     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hSDO      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cObjName  AS CHARACTER  NO-UNDO.

  FIND _U-Parent WHERE RECID(_U-Parent) = _P._u-recid.
  FOR EACH _U-Object WHERE _U-Object._PARENT-RECID = RECID(_U-Parent)
                       AND _U-Object._STATUS <> "DELETED":U:
    IF _U-Object._TYPE = "SmartObject":U AND
       _U-Object._SUBTYPE = "SmartDataObject":U THEN
    DO:
      FIND x_S WHERE RECID(x_S) = _U-Object._x-recid.
      hSDO = x_S._HANDLE.

      iCount = iCount + 1.
      cObjName = DYNAMIC-FUNCTION("getObjectName":U IN hSDO).
      PUT STREAM P_4GL UNFORMATTED "&Scoped-Define UpdTable":U
        + STRING(iCount) + " " + cObjName SKIP.

      cFile = DYNAMIC-FUNCTION("getDataFieldDefs":U IN hSDO).
      cFile = REPLACE(cFile,"~\","~/").
      PUT STREAM P_4GL UNFORMATTED "&Scoped-Define SDOInclude":U
        + STRING(iCount) + " " +  cFile SKIP.
    END.
  END.
END PROCEDURE. /* put_contained_tables */

/* _genproc.i - end of file */





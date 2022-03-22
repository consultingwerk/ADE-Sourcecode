/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _rdradi.p

Description:
    Procedure to read in static radio set information.

Input Parameters:
   from_schema - TRUE if processing schema picker output ELSE false

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified on 11/20/96 by gfs added tooltip from qs
            02/12/98 by gfs added drop-target and no-tab-stop attrs.
            07/16/98 by hd  Don't run adecomm/_s-schem.p for _TT._TABLE_TYPE = "W" 
            10/13/98 by gfs Added tooltip attr
            06/07/99 by tsm Added context-help-id attribute
---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER from_schema AS LOGICAL                      NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */

{adeuib/analyze.i &TYPE = "RADIO-SET" }  /* Analyzer Names                  */

DEFINE SHARED STREAM   _P_QS2.
DEFINE SHARED VARIABLE _inp_line AS  CHAR	EXTENT 100	NO-UNDO.

DEFINE VARIABLE current-file-pos AS INTEGER                     NO-UNDO.
DEFINE VARIABLE eof_flag         AS LOGICAL	INITIAL FALSE	NO-UNDO.
DEFINE VARIABLE i                AS INTEGER                     NO-UNDO.
DEFINE VARIABLE ldummy           AS LOGICAL                     NO-UNDO.
DEFINE VARIABLE scrn-value       AS CHAR			NO-UNDO.
DEFINE VARIABLE radio-btns       AS CHAR			NO-UNDO.
DEFINE VARIABLE tmp-label        AS CHAR                        NO-UNDO.

/* Standard End-of-line character */
&Scoped-define EOL  CHR(10)

{adeuib/readinit.i &p_type="RADIO-SET"
                   &p_basetype="RADIO-SET" }

/* Changes to the Universal widget record */
ASSIGN _F._DATA-TYPE  = IF {&ARS_data-type} = "1"  THEN "Character" ELSE
                        IF {&ARS_data-type} = "2"  THEN "Date"      ELSE
                        IF {&ARS_data-type} = "3"  THEN "Logical"   ELSE
                        IF {&ARS_data-type} = "4"  THEN "Integer"   ELSE
                        IF {&ARS_data-type} = "41" THEN "INT64"     ELSE
                        IF {&ARS_data-type} = "5"  THEN "Decimal"   ELSE
                        IF {&ARS_data-type} = "7"  THEN "RECID" 
                        ELSE "Integer"
       _F._HORIZONTAL  = ({&ARS_orientation} eq "h")
       _F._EXPAND      = ({&ARS_expand} eq "Y")
       _U._LABEL       = ?
       _L._NO-LABELS   = YES /* UIB doesn't support labels on multiline widgets */       
       _F._UNDO        = IF _U._TABLE = ? THEN ({&ARS_undo} eq "y") ELSE TRUE
       _U._TOOLTIP     = {&ARS_TOOLTIP}
       _U._TOOLTIP-ATTR = {&ARS_TOOLTIP-ATTR}
       _U._DROP-TARGET = {&ARS_drop-target} = "y"
       _U._NO-TAB-STOP = {&ARS_no-tab-stop} = "y"
       _U._CONTEXT-HELP-ID = INTEGER({&ARS_context-help-id})
       _U._WIDGET-ID   = INTEGER({&ARS_widget-id})
       .
IF from_schema THEN _F._DICT-VIEW-AS = _suppress_dict_view-as.
 
/* Set initial data to unknown if Analyzer is telling us that it is the default */
/* For this data type */
IF ({&ARS_data-type} = "1" AND _F._INITIAL-DATA = "")    OR
   ({&ARS_data-type} = "2" AND _F._INITIAL-DATA = "?")   OR
   ({&ARS_data-type} = "3" AND _F._INITIAL-DATA = "no")  OR
   ({&ARS_data-type} = "4" AND _F._INITIAL-DATA = "0")   OR
   ({&ARS_data-type} = "5" AND (_F._INITIAL-DATA = "0" OR _F._INITIAL-DATA = "0.00"))
   THEN _F._INITIAL-DATA = ?.
   
ELSE DO: /* If a date change string to the correct format */
  {adeuib/datefrmt.i _F._INITIAL-DATA}
END.
   
/* Read the Radio-Buttons. */
ASSIGN scrn-value = "".

READ-ALL-BTNS:
REPEAT ON ENDKEY UNDO, RETRY:
  IF RETRY THEN DO:
    eof_flag = TRUE.
    LEAVE READ-ALL-BTNS.
  END.
/* ksu 02/23/94 LENGTH use raw mode */
  current-file-pos = SEEK(_P_QS2).
  IMPORT STREAM _P_QS2 _inp_line.
  IF _inp_line[1] NE "RB" THEN LEAVE READ-ALL-BTNS.
  IMPORT STREAM _P_QS2 _inp_line.
  scrn-value = scrn-value + (IF LENGTH(scrn-value, "raw":U) > 0 THEN "," +
	   {&EOL} ELSE "") + "~"" + _inp_line[1] + 
	   (IF _inp_line[2] NE ? THEN "~":" + _inp_line[2] + ", " ELSE "~", ") +
           (IF _inp_line[3] = ? THEN "?"
            ELSE IF _F._DATA-TYPE = "CHARACTER" THEN "~"" + _inp_line[3] + "~""
            ELSE _inp_line[3]).
  IF _F._DATA-TYPE = "CHARACTER" AND _inp_line[4] NE ? THEN
            scrn-value = scrn-value + ":" + _inp_line[4].
END.
IF NOT eof_flag THEN SEEK STREAM _P_QS2 TO current-file-pos.
ASSIGN _F._LIST-ITEMS = scrn-value.

/* Create the widget */
CREATE VALUE(IF parent_U._WIN-TYPE OR SESSION:WINDOW-SYSTEM BEGINS "MS-WIN"
             THEN "RADIO-SET" ELSE "EDITOR")  _U._HANDLE
    ASSIGN 
        {adeuib/std_attr.i &MODE = "READ" }
      TRIGGERS:
        {adeuib/std_trig.i}
      END TRIGGERS.

/* Assign Handles that we now know . */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

IF _U._LAYOUT-UNIT THEN
  ASSIGN _U._HANDLE:COL          = 1 + (_L._COL - 1) * _cur_col_mult
         _U._HANDLE:ROW          = 1 + (_L._ROW - 1) * _cur_row_mult
         _U._HANDLE:WIDTH-CHARS  = _L._WIDTH * _cur_col_mult
         _U._HANDLE:HEIGHT-CHARS = _L._HEIGHT * _cur_row_mult.
ELSE
  ASSIGN _U._HANDLE:X             = _X
         _U._HANDLE:Y             = _Y
         _U._HANDLE:WIDTH-PIXELS  = _WIDTH-P
         _U._HANDLE:HEIGHT-PIXELS = _HEIGHT-P.

/* Create multiple layout records if necessary */
{adeuib/crt_mult.i}
/* Now get the _L for the current layout instead of the master layout */
FIND _L WHERE RECID(_L) = _U._lo-recid.


/* Explicitly set NO-LABELS for static Radio sets */
_L._NO-LABELS = YES.
         
         
IF _L._WIN-TYPE OR SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" THEN DO:
  RUN adeuib/_rbtns.p( scrn-value, "INTEGER", ",":U, OUTPUT radio-btns).
  ASSIGN _U._HANDLE:HORIZONTAL    = _F._HORIZONTAL
         _U._HANDLE:EXPAND        = _F._EXPAND
         _U._HANDLE:RADIO-BUTTONS = radio-btns.
         
  /* Restore commas in labels before realization */
  DO i = 1 TO NUM-ENTRIES(radio-btns) BY 2:
    tmp-label = ENTRY(i,radio-btns).
    IF INDEX(tmp-label,CHR(3)) > 0 THEN
      ldummy = _U._HANDLE:REPLACE(REPLACE(tmp-label,CHR(3),",":U),"":U,
                          tmp-label).                    
  END.
END.
ELSE DO:
  ASSIGN _U._HANDLE:WORD-WRAP            = FALSE
         _U._HANDLE:SCROLLBAR-HORIZONTAL = FALSE
         _U._HANDLE:SCROLLBAR-VERTICAL   = FALSE
         _U._HANDLE:READ-ONLY            = TRUE.
  RUN adeuib/_ttyradi.p (_U._HANDLE, _F._HORIZONTAL, scrn-value).
END.

/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_h_frame"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = FALSE}

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values.  */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .


/* Avoid ugly message for unmapped webobjects when disconnected 
   BUG 98-060-02-018
*/
IF AVAIL _TT AND _TT._TABLE-TYPE = "W" THEN
DO:
 /* nothing */
END.
    /* If radio-set is associated with a db field grep the label for documentation */
    /* of trigger code blocks                                                      */
ELSE IF _U._DBNAME NE ? THEN RUN adecomm/_s-schem.p (_U._DBNAME, _U._TABLE, _U._NAME,
                            "FIELD:LABEL", OUTPUT _U._LABEL).

/* Were the radio-buttons the last item in the file? Let the calling program
   know this so that it won't continue processing the file */
IF eof_flag THEN RETURN "EOF".
ELSE RETURN "". /* for 4GL RETURN-VALUE */




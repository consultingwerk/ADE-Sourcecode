/***********************************************************************
* Copyright (C) 2005-2006 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*----------------------------------------------------------------------------

File: _rdcomb.p

Description:
    Procedure to read in static COMBO-BOX information.
    Adapted from _rdfill.p from R. Ryan 12/10/93
    Wood (5/7/93) Note that we treat TEXT as a subclass of FILL-IN for v7.

Input Parameters:
   pcSubtype -  "TEXT" or "" (for regular COMBO-BOXs).
   from_schema - TRUE if processing schema picker output ELSE false

Output Parameters:
   <None>

Author: RPR

Date Created: 12/93

Modified on 11/20/96 by gfs added tooltip from qs
            02/12/98 by gfs added drop-target and no-tab-stop attrs.
            10/08/98 by gfs added support for LIST-ITEM-PAIRS
            10/13/98 by gfs added tooltip translation attr
            06/07/99 by tsm added context-help-id attribute
            06/08/99 by tsm added support for editable combo-box
            06/10/99 by tsm added auto-completion and unique-match attributes
            06/18/99 by tsm added max-chars attribute
---------------------------------------------------------------------------- */
/* DEFINE INPUT PARAMETER pcSubtype   AS CHAR                      NO-UNDO.  */
                                      
DEFINE INPUT PARAMETER from_schema AS LOGICAL                      NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "COMBO-BOX" } /* Analyzer Names for Combo-box      */


DEFINE SHARED  STREAM    _P_QS2.
                        /* This is the input stream with "Quick Save"        */
                        /* formatted data                                    */

DEFINE SHARED  VARIABLE  _inp_line  AS  CHAR     EXTENT 100           NO-UNDO.
                        /* This is the input line buffer for the _P_QS data  */
                        /* data stream                                       */
                        
DEFINE VARIABLE tmp-label          AS  CHAR                           NO-UNDO.
DEFINE VAR i          AS INTEGER   NO-UNDO.
DEFINE VAR num10s     AS INTEGER   NO-UNDO.
DEFINE VAR tmpstr     AS CHARACTER NO-UNDO.
DEFINE VAR tmpstrattr AS CHARACTER NO-UNDO.
DEFINE VAR listPairs  AS LOGICAL   NO-UNDO.

{adeuib/readinit.i &p_type="COMBO-BOX"
                   &p_basetype="COMBO-BOX" }

IF from_schema THEN _F._DICT-VIEW-AS = _suppress_dict_view-as.

IF NOT parent_L._WIN-TYPE THEN    /* parent_L is the Master layout of the parent */
  ASSIGN _L._HEIGHT   = 1         /* We will create non-master _L's later        */
         _L._WIN-TYPE = NO.

IF from_schema AND LENGTH(v_label, "raw":U) = 16 AND f_side_labels THEN DO:
  /* Label got truncated due to WITH 1 COLUMN */
  RUN adeuib/_fldlbl.p (_U._DBNAME, _U._TABLE, _U._NAME, f_side_labels,
                       OUTPUT v_label, OUTPUT _U._LABEL-ATTR).
END.

ASSIGN _U._SUBTYPE             = IF {&ACB_sub-type} = "SI" THEN "SIMPLE" ELSE
                                 IF {&ACB_sub-type} = "DD" THEN "DROP-DOWN" ELSE
                                 "DROP-DOWN-LIST"
       _F._DATA-TYPE           = IF {&ACB_data-type} = "1"  THEN "Character" ELSE
                                 IF {&ACB_data-type} = "2"  THEN "Date"      ELSE
                                 IF {&ACB_data-type} = "3"  THEN "Logical"   ELSE
                                 IF {&ACB_data-type} = "4"  THEN "Integer"   ELSE
                                 IF {&ACB_data-type} = "41" THEN "INT64"     ELSE
                                 IF {&ACB_data-type} = "5"  THEN "Decimal"   ELSE
                                 IF {&ACB_data-type} = "7"  THEN "RECID"     ELSE
                                 "WIDGET-HANDLE"
       _U._ALIGN               = IF f_side_labels       THEN "C" ELSE "L"
       _F._FORMAT              = {&ACB_format} 
       _F._FORMAT-ATTR         = IF {&ACB_format-sa} ne ? 
                                 THEN {&ACB_format-sa} ELSE ""
       _F._FORMAT-SOURCE       = IF from_schema OR _U._DBNAME NE ? THEN "D" ELSE "E"
       _U._HELP-SOURCE         = IF from_schema OR _U._DBNAME NE ? THEN "D" ELSE "E"
       _L._NO-LABELS           = ({&ACB_no-label} eq "Y")
       /* If no-labels then don't show the label */
       _U._LABEL               = IF NOT _L._NO-LABELS 
                                 THEN (IF v_label = ? THEN _U._NAME ELSE v_label)                                 
                                 ELSE ""
       _U._LABEL-SOURCE        = IF (from_schema OR _U._DBNAME NE ?) 
                                    THEN "D" ELSE "E"
       _F._INNER-CHARS         = INTEGER({&ACB_inner-chars})
       _F._INNER-LINES         = INTEGER({&ACB_inner-lines})
       _F._SORT                = ({&ACB_sort} eq "y")
       _F._NUM-ITEMS           = INTEGER({&ACB_num-items})
       _F._UNDO                = IF _U._TABLE = ? THEN ({&ACB_undo} eq "y") ELSE TRUE
       _U._TOOLTIP             = {&ACB_TOOLTIP}
       _U._TOOLTIP-ATTR        = {&ACB_TOOLTIP-ATTR}
       _U._DROP-TARGET         = {&ACB_drop-target} = "y"
       _U._NO-TAB-STOP         = {&ACB_no-tab-stop} = "y"
       _U._CONTEXT-HELP-ID     = INTEGER({&ACB_context-help-id})
       _F._AUTO-COMPLETION     = {&ACB_auto-completion} = "y"
       _F._UNIQUE-MATCH        = {&ACB_unique-match} = "y"
       _F._MAX-CHARS           = INTEGER({&ACB_max-chars})
       _U._WIDGET-ID           = INTEGER({&ACB_widget-id})    
       .

/* For DB fields where we are supposed to use the Default name, 
  (LABEL-SOURCE = "D"), the UIB stores the label locally in _U._LABEL.  This
  will not have been set if the there is no label in the frame. (Note: we
  are assuming here that the frame has column-labels. */
IF (_U._DBNAME NE ?) AND _L._NO-LABELS AND (_U._LABEL eq "") THEN DO:
  /* It is not clear why this code was put in here (despite the comment above,
     but it causes and error when data source is an SDO.  I am fixing the bug 
     by setting the label to v_label in that case.  DRH 8/22/02 */
  IF _U._DBNAME = "Temp-tables":U THEN _U._LABEL = v_label.
  ELSE RUN adeuib/_fldlbl.p (_U._DBNAME, _U._TABLE, _U._NAME, NO,
                       OUTPUT _U._LABEL, OUTPUT _U._LABEL-ATTR).
END. /* IF DB name ne ? , No Labels and Label is blank */

IF parent_U._WIN-TYPE THEN DO:
  CREATE COMBO-BOX _U._HANDLE
       ASSIGN
            {adeuib/std_attr.i &MODE = "READ" }
            SUBTYPE = _U._SUBTYPE
         TRIGGERS:
              {adeuib/std_trig.i}
         END TRIGGERS.
END.  /* if GUI */
ELSE DO:
  CREATE TEXT _U._HANDLE
       ASSIGN
            {adeuib/std_attr.i &MODE = "READ" }
         TRIGGERS:
              {adeuib/std_trig.i}
         END TRIGGERS.
END.  /* else do - tty */

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

IF parent_U._WIN-TYPE THEN
  ASSIGN _U._HANDLE:DELIMITER = CHR(10)
         _U._HANDLE:DATA-TYPE = _F._DATA-TYPE
         _U._HANDLE:FORMAT    = _F._FORMAT.

IF NOT _U._LAYOUT-UNIT THEN
  ASSIGN _U._HANDLE:X        = _X
         _U._HANDLE:Y        = _Y.
ELSE
  ASSIGN _U._HANDLE:COL      = 1 + (_L._COL - 1) * _cur_col_mult
         _U._HANDLE:ROW      = 1 + (_L._ROW - 1) * _cur_row_mult.

IF NOT _U._LAYOUT-UNIT
THEN _U._HANDLE:WIDTH-PIXELS = _WIDTH-P.
ELSE _U._HANDLE:WIDTH        = _L._WIDTH * _cur_col_mult.

/* Set the height, if known. */
IF _U._SUBTYPE = "SIMPLE":U AND _L._HEIGHT ne ? THEN 
  _U._HANDLE:HEIGHT = _L._HEIGHT * _L._ROW-MULT. 

/* Get the list-items and display them.  */
/* Get items (could be LIST-ITEMS or LIST-ITEM-PAIRS */
IF {&ACB_list-item-pairs} = "y":U THEN DO:
  IMPORT STREAM _P_QS2 UNFORMATTED _inp_line[1].
  /* We need to replace ? with "?" for list items pairs that do not have string attributes so
     that they are handled properly below */
  ASSIGN tmpstr = REPLACE(_inp_line[1], '?', '"?"')
         _U._HANDLE:DELIMITER = ",":U /* PAIRS must be comma separated */
         _F._LIST-ITEM-PAIRS  = ""
         tmpstr = RIGHT-TRIM(TRIM(TRIM(REPLACE(tmpstr,""" """,CHR(10))), "~""))
         listPairs            = TRUE.
  /* We need to skip the string attributes in the analyzer output - for now, until the 
     AppBuilder has support for adding string attributes to combo-box list item pairs */
  DO i = 1 TO NUM-ENTRIES(tmpstr,CHR(10)) BY 2:
      ASSIGN tmpstrattr = tmpstrattr + ENTRY(i, tmpstr, CHR(10)) + CHR(10).
  END.  /* do i to num-entries */
  tmpstr = RIGHT-TRIM(tmpstrattr, CHR(10)).
  DO i = 1 TO LENGTH(tmpstr,"RAW":U):
    /* Count CHR(10)'s and replace with comma. Every other
       CHR(10) stays. */
    IF SUBSTRING(tmpstr,i,1) = CHR(10) THEN DO:
      ASSIGN num10s = num10s + 1.
      IF num10s MOD 2 = 0 THEN ASSIGN _F._LIST-ITEM-PAIRS = _F._LIST-ITEM-PAIRS + ",":U + CHR(10).
      ELSE ASSIGN _F._LIST-ITEM-PAIRS = _F._LIST-ITEM-PAIRS + ",":U.
    END.
    ELSE ASSIGN _F._LIST-ITEM-PAIRS = _F._LIST-ITEM-PAIRS + SUBSTRING(tmpstr,i,1).
  END.
END.
ELSE DO:
  IMPORT STREAM _P_QS2 UNFORMATTED _inp_line[1]. 
  /* We need to replace ? with "?" for list items that do not have string attributes so
     that they are handled properly below */
  ASSIGN tmpstr    = REPLACE(_inp_line[1], '?', '"?"')
         tmpstr    = TRIM(TRIM(REPLACE(tmpstr,""" """,CHR(10))), "~"")
         listPairs = FALSE.
  /* We need to skip the string attributes in the analyzer output - for now, until the 
     AppBuilder has support for adding string attributes to combo-box list items */
  DO i = 1 TO NUM-ENTRIES(tmpstr,CHR(10)) BY 2:
      ASSIGN _F._LIST-ITEMS = _F._LIST-ITEMS + ENTRY(i, tmpstr, CHR(10)) + CHR(10).
  END.  /* do i to num-entries */
  _F._LIST-ITEMS = RIGHT-TRIM(_F._LIST-ITEMS, CHR(10)).
END.

/* Create multiple layout records if necessary */
{adeuib/crt_mult.i}
/* Now get the _L for the current layout instead of the master layout */
FIND _L WHERE RECID(_L) = _U._lo-recid.

/* If a date change string to the correct format */
{adeuib/datefrmt.i _F._INITIAL-DATA}
        
IF listPairs THEN DO:
  IF _L._WIN-TYPE THEN
    ASSIGN _U._HANDLE:LIST-ITEM-PAIRS = REPLACE(RIGHT-TRIM(_F._LIST-ITEM-PAIRS),CHR(10),"")
           _U._HANDLE:SCREEN-VALUE = IF _F._INITIAL-DATA NE "" AND _F._INITIAL-DATA NE ?
                                     THEN _F._INITIAL-DATA
                                     ELSE ENTRY(2,_F._LIST-ITEM-PAIRS,",").   
  ELSE RUN adeuib/_sim_lbl.p (_U._HANDLE).
END. /* If we are using List-Pairs */
ELSE DO: /* Not using list-pairs */
  IF _L._WIN-TYPE THEN
    ASSIGN _U._HANDLE:LIST-ITEMS   = _F._LIST-ITEMS
           _U._HANDLE:SCREEN-VALUE = IF _F._INITIAL-DATA NE "" AND _F._INITIAL-DATA NE ?
                                     THEN _F._INITIAL-DATA
                                     ELSE ENTRY(1,_F._LIST-ITEMS,CHR(10)).
  ELSE RUN adeuib/_sim_lbl.p (_U._HANDLE).
END.  /* Not using List-Pairs */

/* Add a label to the current widget */
{ adeuib/addlabel.i }

/* Move the label into the proper place.  Note that _showlbl "fixes" up
   invalid alignment so we set it to "L" which is always correct.  [Colon
   alignment can't accept a column position < 1 [fill-in:COL < 3]. 
   We will again change the alignment when we read in the UIB settings.  */
_U._ALIGN = IF _U._HANDLE:COL < 3 OR NOT f_side_labels THEN "L" ELSE "C".
RUN adeuib/_showlbl.p (INPUT _U._HANDLE). 

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .

/* Hardcode combo-box height to 1 PPU */
IF _U._SUBTYPE NE "SIMPLE":U THEN ASSIGN _L._HEIGHT = 1.






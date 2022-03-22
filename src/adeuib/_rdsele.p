/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdsele.p

Description:
    Procedure to read in static selection-list information.

Input Parameters:
   from_schema - TRUE if processing schema picker output ELSE false

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified on 11/20/96 by gfs added tooltip from qs
            01/29/98 by gfs replaced refs to _F._SCROLLBAR-V to _U._SCROLLBAR-V
            02/12/98 by gfs added no-tab-stop and drop-target attrs.
            07/16/98 by hd  don't run adecomm/_s-schem.p for web unmapped fields
            10/08/98 by gfs added support for LIST-ITEM-PAIRS
            10/13/98 by gfs added tooltip attrs
            06/07/99 by tsm added context-help-id attribute
---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER from_schema AS LOGICAL                      NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "SELECTION-LIST" }  /* Analyzer Names              */

DEFINE SHARED  STREAM    _P_QS2.
DEFINE SHARED  VARIABLE  _inp_line AS  CHAR     EXTENT 100            NO-UNDO.

DEFINE VAR dummy      AS LOGICAL   NO-UNDO.
DEFINE VAR i          AS INTEGER   NO-UNDO.
DEFINE VAR num10s     AS INTEGER   NO-UNDO.
DEFINE VAR tmpstr     AS CHARACTER NO-UNDO.
DEFINE VAR tmpstrattr AS CHARACTER NO-UNDO.

{adeuib/readinit.i &p_type ="SELECTION-LIST"
                   &p_basetype ="SELECT" }

ASSIGN _F._DATA-TYPE       = "Character":U
       _F._DRAG            = ({&ASE_no-drag} eq "n")
       _F._INNER-CHARS     = INTEGER({&ASE_inner-chars})
       _F._INNER-LINES     = INTEGER({&ASE_inner-lines})
       _F._MULTIPLE        = ({&ASE_multiple} eq "m")
       _F._NUM-ITEMS       = INTEGER({&ASE_num-items})
       _F._SCROLLBAR-H     = ({&ASE_scrollbar-h} eq "y")
       _U._SCROLLBAR-V     = ({&ASE_scrollbar-v} eq "y")
       _F._SORT            = ({&ASE_sort} eq "y")
       _F._UNDO            = IF _U._TABLE = ? THEN ({&ASE_undo} eq "y") ELSE TRUE
       _U._TOOLTIP         = {&ASE_TOOLTIP}
       _U._TOOLTIP-ATTR    = {&ASE_TOOLTIP-ATTR}
       _U._DROP-TARGET     = {&ASE_drop-target} = "y"
       _U._NO-TAB-STOP     = {&ASE_no-tab-stop} = "y"
       _U._CONTEXT-HELP-ID = INTEGER({&ASE_context-help-id})
       _U._WIDGET-ID       = INTEGER({&ASE_widget-id})
       .
IF from_schema THEN _F._DICT-VIEW-AS = _suppress_dict_view-as.

CREATE SELECTION-LIST _U._HANDLE
    ASSIGN {adeuib/std_attr.i &MODE = "READ" }
           DELIMITER       = CHR(10)     /* This allows commas in list-items */
           SCROLLBAR-H     = _F._SCROLLBAR-H
           SCROLLBAR-V     = _U._SCROLLBAR-V 
      TRIGGERS:
           {adeuib/std_trig.i}
      END TRIGGERS.

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

IF _U._LAYOUT-UNIT THEN
  ASSIGN _U._HANDLE:COL          = ((_L._COL - 1) * _cur_col_mult) + 1
         _U._HANDLE:ROW          = ((_L._ROW - 1) * _cur_row_mult) + 1
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
         
/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_h_frame"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = FALSE}

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .

/* Get items (could be LIST-ITEMS or LIST-ITEM-PAIRS */
IF {&ASE_list-item-pairs} = "y":U THEN DO:
  IMPORT STREAM _P_QS2 UNFORMATTED _inp_line[1].
  /* We need to replace ? with "?" for list items pairs that do not have string attributes so
     that they are handled properly below */
  ASSIGN tmpstr = REPLACE(_inp_line[1], '?', '"?"')
         _U._HANDLE:DELIMITER = ",":U /* PAIRS must be comma separated */
         _F._LIST-ITEM-PAIRS  = ""
         tmpstr = RIGHT-TRIM(TRIM(REPLACE(tmpstr,""" """,CHR(10)),"~""),"~" ").  
  /* We need to skip the string attributes in the analyzer output - for now, until the 
     AppBuilder has support for adding string attributes to selection list items pairs */
  DO i = 1 TO NUM-ENTRIES(tmpstr, CHR(10)) BY 2:
    ASSIGN tmpstrattr = tmpstrattr + ENTRY(i, tmpstr, CHR(10)) + CHR(10).
  END.
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
  ASSIGN _U._HANDLE:LIST-ITEM-PAIRS = REPLACE(RIGHT-TRIM(_F._LIST-ITEM-PAIRS),CHR(10),"").
END.
ELSE DO:
  IMPORT STREAM _P_QS2 UNFORMATTED _inp_line[1].
  /* We need to replace ? with "?" for list items that do not have string attributes so
     that they are handled properly below */
  ASSIGN tmpstr = REPLACE(_inp_line[1], '?', '"?"')
         tmpstr = RIGHT-TRIM(TRIM(REPLACE(tmpstr,""" """,_U._HANDLE:DELIMITER),"~""),"~" ").
  /* We need to skip the string attributes in the analyzer output - for now, until the 
     AppBuilder has support for adding string attributes to selection list items */
  DO i = 1 TO NUM-ENTRIES(tmpstr,_U._HANDLE:DELIMITER) BY 2:
    ASSIGN _F._LIST-ITEMS = _F._LIST-ITEMS + ENTRY(i, tmpstr, _U._HANDLE:DELIMITER) + 
                            _U._HANDLE:DELIMITER.
  END.
  ASSIGN _F._LIST-ITEMS = RIGHT-TRIM(_F._LIST-ITEMS, _U._HANDLE:DELIMITER)
        dummy           = _U._HANDLE:ADD-LAST(_F._LIST-ITEMS).
END.

/* Set an initial value */
IF _U._HANDLE:LOOKUP(_F._INITIAL-DATA) = 0 THEN 
  _U._HANDLE:SCREEN-VALUE = _U._HANDLE:ENTRY(1).
ELSE 
  _U._HANDLE:SCREEN-VALUE = _F._INITIAL-DATA.


/* Explicitly set NO-LABELS for static Selection Lists */
_L._NO-LABELS = YES.


/* Avoid ugly message for unmapped webobjects when disconnected 
   BUG 98-060-02-018
*/
IF AVAIL _TT AND _TT._TABLE-TYPE = "W" THEN
DO:
 /* nothing */
END.  

/* else If selection list is associated with a db field grep the label for documentation */
/* of trigger code blocks    */
ELSE IF _U._DBNAME NE ? THEN RUN adecomm/_s-schem.p (_U._DBNAME, _U._TABLE, _U._NAME,
                            "FIELD:LABEL", OUTPUT _U._LABEL).



 





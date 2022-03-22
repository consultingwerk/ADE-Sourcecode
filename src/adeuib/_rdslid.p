/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdslid.p

Description:
    Procedure to read in static slider information.

Input Parameters:
   from_schema - TRUE if processing schema picker output ELSE false

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified by gfs on 03/06/95 - added new attributes for Win95 slider
            gfs on 11/20/96 - added tooltip from qs
            gfs on 02/12/98 - added drop-target and no-tab-stop attrs.
            hd  on 07/16/98 - Don't run adecomm/_s-schem.p for _TT._TABLE_TYPE = "W" 
            gfs on 10/13/98 - Added tooltip attrs
            tsm on 06/07/99 - Added context-help-id attribute
------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER from_schema AS LOGICAL                      NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "SLIDER" }  /* Analyzer Names                      */

DEFINE SHARED STREAM   _P_QS2.
DEFINE SHARED VARIABLE _inp_line  AS  CHAR     EXTENT 100            NO-UNDO.

{adeuib/readinit.i &p_type="SLIDER"
                   &p_basetype="SLIDER" }

/*Enumerated list of tic-marks options written by the analyzer 1-6*/
DEFINE VARIABLE tic-list AS CHARACTER NO-UNDO INITIAL "TOP,BOTTOM,LEFT,RIGHT,BOTH,NONE".

ASSIGN _F._DATA-TYPE        = "Integer":U
       _F._HORIZONTAL       = ({&ASL_orientation} eq "h")
       _F._MAX-VALUE        = INTEGER({&ASL_max-value})
       _F._MIN-VALUE        = INTEGER({&ASL_min-value})
       _F._UNDO             = IF _U._TABLE = ? THEN ({&ASL_undo} eq "y") ELSE TRUE
       _F._TIC-MARKS        = IF INT({&ASL_tic-marks}) = 0 THEN "NONE" ELSE ENTRY(INT({&ASL_tic-marks}),tic-list)
       _F._FREQUENCY        = INTEGER({&ASL_frequency})
       _F._NO-CURRENT-VALUE = (IF {&ASL_no-current-value} = "Y" THEN TRUE ELSE FALSE)
       _F._LARGE-TO-SMALL   = (IF {&ASL_large-to-small} = "a" THEN FALSE ELSE TRUE) 
       _L._WIN-TYPE         = _cur_win_type
       _U._TOOLTIP          = {&ASL_TOOLTIP}
       _U._TOOLTIP-ATTR     = {&ASL_TOOLTIP-ATTR}
       _U._DROP-TARGET      = {&ASL_drop-target} = "y"
       _U._NO-TAB-STOP      = {&ASL_no-tab-stop} = "y"
       _U._CONTEXT-HELP-ID  = INTEGER({&ASL_context-help-id})
       _U._WIDGET-ID        = INTEGER({&ASL_widget-id})
       .
IF from_schema THEN _F._DICT-VIEW-AS = _suppress_dict_view-as.

IF NOT parent_L._WIN-TYPE THEN 
  ASSIGN _L._HEIGHT   = IF _F._HORIZONTAL THEN 2 ELSE
                           MAX(2,INTEGER(_L._HEIGHT)).
IF NOT parent_L._WIN-TYPE AND NOT _F._HORIZONTAL THEN
  ASSIGN _L._WIDTH  = MAX(9,INTEGER(_L._WIDTH)).

CREATE SLIDER _U._HANDLE
    ASSIGN {adeuib/std_attr.i &MODE = "READ" }
           HORIZONTAL       = _F._HORIZONTAL 
           MAX-VALUE        = _F._MAX-VALUE
           MIN-VALUE        = _F._MIN-VALUE
           TIC-MARKS        = _F._TIC-MARKS
           FREQUENCY        = _F._FREQUENCY
           LARGE-TO-SMALL   = _F._LARGE-TO-SMALL
           NO-CURRENT-VALUE = _F._NO-CURRENT-VALUE
      TRIGGERS:
        {adeuib/std_trig.i}
      END TRIGGERS.

IF _F._TIC-MARKS = "TOP" OR _F._TIC-MARKS = "LEFT" THEN
  _F._TIC-MARKS = "TOP/LEFT".
IF _F._TIC-MARKS = "BOTTOM" OR _F._TIC-MARKS = "RIGHT" THEN
  _F._TIC-MARKS = "BOTTOM/RIGHT".                                      
  
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



/* Explicitly set NO-LABELS for static Sliders */
_L._NO-LABELS = YES.
         
/* Avoid ugly message for unmapped webobjects when disconnected. 
   BUG 98-060-02-018
   WEbobjects cannot have sliders, but who knows what may happen in the future
*/
IF AVAIL _TT AND _TT._TABLE-TYPE = "W" THEN
DO:
 /* nothing */
END.

/* If slider is associated with a db field grep the label for documentation of      */
/* trigger code blocks                                                              */
ELSE IF _U._DBNAME NE ? THEN RUN adecomm/_s-schem.p (_U._DBNAME, _U._TABLE, _U._NAME,
                            "FIELD:LABEL", OUTPUT _U._LABEL).





/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdtogg.p

Description:
    Procedure to read in static toggle-box information.

Input Parameters:
   from_schema - TRUE if processing schema picker output ELSE false

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified on 11/20/96 by gfs added tooltip from qs
            02/12/98 by gfs added no-tab-stop and drop-target attrs.
            10/13/98 by gfs added tooltip attrs
            06/07/99 by tsm added context-help-id attribute
---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER from_schema AS LOGICAL                      NO-UNDO.

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "TOGGLE-BOX" }  /* Analyzer Names                  */

DEFINE SHARED STREAM   _P_QS2.
DEFINE SHARED VARIABLE _inp_line  AS  CHAR     EXTENT 100            NO-UNDO.

{adeuib/readinit.i &p_type="TOGGLE-BOX"
                   &p_basetype="TOGGLE" }

IF NOT parent_L._WIN-TYPE THEN    /* parent_L is the Master layout of the parent */
  ASSIGN _L._HEIGHT   = 1         /* We will create non-master _L's later        */
         _L._WIN-TYPE = NO.

ASSIGN _F._DATA-TYPE    = "Logical":U
       _U._LABEL        = v_label
       _U._LABEL-ATTR   = IF {&ApC_label-sa} <> ? THEN {&ApC_label-sa} ELSE ""
       _F._UNDO         = IF _U._TABLE = ? THEN ({&ATB_undo} eq "y") ELSE TRUE
       _U._TOOLTIP      = {&ATB_TOOLTIP}
       _U._TOOLTIP-ATTR = {&ATB_TOOLTIP-ATTR}
       _U._DROP-TARGET  = {&ATB_drop-target} = "y"
       _U._NO-TAB-STOP  = {&ATB_no-tab-stop} = "y"
       _F._INITIAL-DATA = IF {&AC_initial} begins "y" THEN "yes" ELSE "no"
       _U._CONTEXT-HELP-ID = INTEGER({&ATB_context-help-id})
       _U._WIDGET-ID    = INTEGER({&ATB_widget-id})    
       .
IF from_schema THEN _F._DICT-VIEW-AS = _suppress_dict_view-as.

CREATE VALUE(IF parent_U._WIN-TYPE THEN "TOGGLE-BOX" ELSE "TEXT") _U._HANDLE
    ASSIGN 
        {adeuib/std_attr.i &MODE = "READ" }
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

/* Show the current label */
RUN adeuib/_sim_lbl.p (_U._HANDLE).
 
/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_h_frame"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = FALSE}

IF _U._HANDLE:TYPE = "TOGGLE-BOX" THEN 
  _U._HANDLE:CHECKED = CAN-DO("YES,TRUE",_F._INITIAL-DATA).

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .




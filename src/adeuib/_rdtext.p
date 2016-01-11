/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdtext.p

Description:
    Procedure to read in static text information.

Input Parameters:
   from_schema - TRUE if processing schema picker output ELSE false

Output Parameters: <None>

Author: D. Ross Hunter

Date Created: 1992

Modified on 11/20/96 by gfs added tooltip from qs
            10/13/98 by gfs added tooltip attrs
---------------------------------------------------------------------------- */
DEFINE INPUT PARAMETER from_schema AS LOGICAL                      NO-UNDO.


{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "LITERAL" }  /* Analyzer Names for                 */

DEFINE SHARED  STREAM    _P_QS2.
DEFINE SHARED  VARIABLE  _inp_line AS  CHAR     EXTENT 100            NO-UNDO.

{adeuib/readinit.i &p_type="TEXT"
                   &p_basetype="TEXT" }

IF NOT parent_L._WIN-TYPE THEN    /* parent_L is the Master layout of the parent */
  ASSIGN _L._HEIGHT   = 1         /* We will create non-master _L's later        */
         _L._WIN-TYPE = NO.

ASSIGN _F._DATA-TYPE           = "Character":U
       _F._INITIAL-DATA        = {&ALI_literal}
       _U._LABEL               = "~"" + _F._INITIAL-DATA + "~"" 
       _U._TOOLTIP             = {&ALI_TOOLTIP}
       _U._TOOLTIP-ATTR        = {&ALI_TOOLTIP-ATTR}
       _U._SENSITIVE           = NO
       _U._WIDGET-ID           = INTEGER({&ALI_widget-id})
       .
IF from_schema THEN _F._DICT-VIEW-AS = _suppress_dict_view-as.

IF parent_U._LAYOUT-NAME = "Master Layout" THEN  /* Normal case */
  CREATE TEXT _U._HANDLE
      ASSIGN {adeuib/std_attr.i &MODE = "READ" }
             FORMAT       = "X(" + (IF _F._INITIAL-DATA = "" THEN "8" ELSE STRING(LENGTH(_F._INITIAL-DATA, "raw":U))) + ")"
             SCREEN-VALUE = _F._INITIAL-DATA
             AUTO-RESIZE   = NO     /* Don't want resizing automatically */
      TRIGGERS:
           {adeuib/std_trig.i}
      END TRIGGERS.
ELSE /* TEXT widget are inert in alternative layouts */
  CREATE TEXT _U._HANDLE
      ASSIGN {adeuib/std_attr.i &MODE = "READ" }
             SELECTABLE  = FALSE
             MOVABLE     = FALSE
             RESIZABLE   = FALSE
             FORMAT       = "X(" + (IF _F._INITIAL-DATA = "" THEN "8" ELSE STRING(LENGTH(_F._INITIAL-DATA, "raw":U))) + ")"
             SCREEN-VALUE = _F._INITIAL-DATA
             AUTO-RESIZE   = NO     /* Don't want resizing automatically */
      TRIGGERS:
         ON MOUSE-SELECT-DOWN PERSISTENT RUN text_message IN _h_uib.     
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



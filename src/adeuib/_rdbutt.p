/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
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

File: _rdbutt.p

Description:
    Procedure to read in static button information.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified on 11/20/96 by gfs added tooltip from qs
            02/12/98 by gfs added no-tab-stop and drop-target attrs.
            07/21/98 by gfs added flat-button
            10/13/98 by gfs added tooltip translation attr
            06/07/99 by tsm added context-help-id attribute
---------------------------------------------------------------------------- */
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "BUTTON" }  /* Analyzer Names for Buttons          */

DEFINE SHARED  STREAM    _P_QS2.
DEFINE SHARED  VARIABLE  _inp_line AS  CHAR     EXTENT 100            NO-UNDO.

DEFINE SHARED VAR _can_butt         AS CHAR                           NO-UNDO.
DEFINE SHARED VAR _def_butt         AS CHAR                           NO-UNDO.

DEFINE VARIABLE ldummy              AS LOGICAL NO-UNDO.

{adeuib/readinit.i &p_type="BUTTON"
                   &p_basetype="BUTTON" }

IF NOT parent_L._WIN-TYPE THEN    /* parent_L is the Master layout of the parent */
  ASSIGN _L._HEIGHT   = 1         /* We will create non-master _L's later        */
         _L._WIN-TYPE = NO.

ASSIGN _U._LABEL           = v_label
       _U._LABEL-ATTR      = IF {&ApC_label-sa} <> ? THEN {&ApC_label-sa} ELSE ""
       _L._NO-LABELS       = FALSE
       _F._IMAGE-FILE      = {&ABU_image-up}
       _F._IMAGE-DOWN-FILE = {&ABU_image-down}
       _F._IMAGE-INSENSITIVE-FILE = {&ABU_image-insent}
       _F._AUTO-GO         = ({&ABU_auto-go} eq "Y")
       _F._AUTO-ENDKEY     = ({&ABU_auto-end-key} eq "Y")
       _F._DEFAULT         = ({&ABU_default} eq "Y")
       _U._TOOLTIP         = {&ABU_TOOLTIP}
       _U._TOOLTIP-ATTR    = {&ABU_TOOLTIP-ATTR}
       _L._CONVERT-3D-COLOR = ({&ABU_convert-3d-clr} eq "N")
       _L._NO-FOCUS        = ({&ABU_focus} eq "Y")
       _F._FLAT            = ({&ABU_flat} eq "Y")
       _U._DROP-TARGET     = ({&ABU_drop-target} eq "Y")
       _U._NO-TAB-STOP     = ({&ABU_no-tab-stop} eq "Y")
       _U._CONTEXT-HELP-ID = INTEGER({&ABU_context-help-id}).

CREATE VALUE (IF parent_U._WIN-TYPE THEN "BUTTON" ELSE "TEXT") _U._HANDLE
    ASSIGN 
           {adeuib/std_attr.i &MODE = "READ" }
      TRIGGERS:
           {adeuib/std_trig.i}
      END TRIGGERS.

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

/* Change button style depending if it is DEFAULT in GUI-mode. */
IF _cur_win_type AND _F._DEFAULT THEN _U._HANDLE:DEFAULT = yes.

IF _U._LAYOUT-UNIT THEN 
  ASSIGN _U._HANDLE:COL       = 1 + (_L._COL - 1) * _cur_col_mult
         _U._HANDLE:ROW       = 1 + (_L._ROW - 1) * _cur_row_mult
         _U._HANDLE:WIDTH     = _L._WIDTH * _cur_col_mult
         _U._HANDLE:HEIGHT    = _L._HEIGHT * _cur_row_mult.
ELSE
  ASSIGN _U._HANDLE:X         = _X
         _U._HANDLE:Y         = _Y
         _U._HANDLE:WIDTH-P   = _WIDTH-P
         _U._HANDLE:HEIGHT-P  = _HEIGHT-P.

/* Create multiple layout records if necessary */
{adeuib/crt_mult.i}

/* Now get the _L for the current layout instead of the master layout */
FIND _L WHERE RECID(_L) = _U._lo-recid.

/* Show the current label */
RUN adeuib/_sim_lbl.p (_U._HANDLE).

/* Add the images (before setting the button visible), and only on GUI windows. */
IF _L._WIN-TYPE THEN DO:
  IF _F._IMAGE-FILE = ?  
  THEN _F._IMAGE-FILE = "".
  ELSE ldummy = _U._HANDLE:LOAD-IMAGE-UP(_F._IMAGE-FILE).

  /* We do not "need" to load the INSENSITIVE image because the UIB will never show
     it. However, having a DOWN image does affect the drawing of button 3-D 
     borders under MS-WINDOWS, so we need to do that */
  IF _F._IMAGE-DOWN-FILE = ? THEN _F._IMAGE-DOWN-FILE = "".
  ELSE ldummy = _U._HANDLE:LOAD-IMAGE-DOWN(_F._IMAGE-DOWN-FILE).
  IF _F._IMAGE-INSENSITIVE-FILE = ? THEN _F._IMAGE-INSENSITIVE-FILE = "".
  /* don't worry about insensitive image...
   *ELSE ldummy = _U._HANDLE:LOAD-IMAGE-INSENSITVE(_F._IMAGE-INSENSITIVE-FILE).
   */ 
END. /* IF gui ... */
                 
{adeuib/onframe.i
   &_whFrameHandle = "_h_frame"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = FALSE}

/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .

IF _U._NAME = _can_butt OR _U._NAME = _def_butt THEN DO:
  IF _U._NAME = _can_butt THEN ASSIGN parent_C._cancel-btn-recid = RECID(_U).
  IF _U._NAME = _def_butt THEN ASSIGN parent_C._default-btn-recid = RECID(_U).
END.



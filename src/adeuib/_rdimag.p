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

File: _rdimag.p

Description:
    Procedure to read in static image information.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified on 11/20/96 by gfs added tooltip from qs
            10/13/98 by gfs added tooltip attr
            06/03/99 by tsm added stretch-to-fit, retain-shape and 
                            transparent image attributes
---------------------------------------------------------------------------- */
&IF DEFINED(ADEICONDIR) = 0 &THEN
  {adecomm/icondir.i}     /* defines adeicon/                                */
&ENDIF

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */
{adeuib/analyze.i &TYPE = "IMAGE" }  /* Analyzer Names                       */

DEFINE SHARED  STREAM    _P_QS2.
DEFINE SHARED  VARIABLE  _inp_line AS  CHAR     EXTENT 100            NO-UNDO.

DEFINE VARIABLE loaded      AS     LOGICAL INITIAL FALSE              NO-UNDO.

{adeuib/readinit.i &p_type="IMAGE"
                   &p_basetype="IMAGE" }

IF NOT parent_L._WIN-TYPE THEN DO:
  MESSAGE "Character mode terminals can't support images."
          VIEW-AS ALERT-BOX WARNING.
  DELETE _U.
  DELETE _F.
  DELETE _L.
  RETURN.
END.
ASSIGN _F._IMAGE-FILE       = {&AIM_image}  
       _U._TOOLTIP          = {&AIM_TOOLTIP}
       _U._TOOLTIP-ATTR     = {&AIM_TOOLTIP-ATTR}
       _L._CONVERT-3D-COLOR = ({&AIM_convert-3d-clr} eq "Y")
       _F._STRETCH-TO-FIT   = ({&AIM_stretch-to-fit} eq "Y")
       _F._RETAIN-SHAPE     = ({&AIM_retain-shape} eq "Y")
       _F._TRANSPARENT      = ({&AIM_transparent} eq "Y")
       _iTabOrder           = _iTabOrder + 1
       _U._TAB-ORDER        = _iTabOrder.

CREATE IMAGE _U._HANDLE
    ASSIGN 
           {adeuib/std_attr.i &MODE = "READ"
                              &NO-FONT = YES}
      TRIGGERS:
           {adeuib/std_trig.i}
      END TRIGGERS.

/* Assign Handles that we now know */
ASSIGN { adeuib/std_uf.i &SECTION = "HANDLES" } .

IF _U._LAYOUT-UNIT THEN 
  ASSIGN _U._HANDLE:COL           = 1 + (_L._COL - 1) * _cur_col_mult
         _U._HANDLE:ROW           = 1 + (_L._ROW - 1) * _cur_row_mult
         _U._HANDLE:HEIGHT-CHARS  = _L._HEIGHT * _cur_row_mult
         _U._HANDLE:WIDTH-CHARS   = _L._WIDTH * _cur_col_mult.
ELSE
  ASSIGN _U._HANDLE:X             = _X
         _U._HANDLE:Y             = _Y
         _U._HANDLE:HEIGHT-PIXELS = _HEIGHT-P
         _U._HANDLE:WIDTH-PIXELS  = _WIDTH-P.

/* Place object within frame boundary. */
{adeuib/onframe.i
   &_whFrameHandle = "_h_frame"
   &_whObjHandle   = "_U._HANDLE"
   &_lvHidden      = FALSE}

/* Read the image before we display it in order to avoid any flashing. */
IF _F._IMAGE-FILE NE ? AND _F._IMAGE-FILE NE "" THEN
  loaded = _U._HANDLE:LOAD-IMAGE(_F._IMAGE-FILE).
  
IF loaded NE yes AND _U._HANDLE:LOAD-IMAGE({&ADEICON-DIR} + "blank") NE yes THEN
  MESSAGE "Default image ""blank"" not found."
	VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
           
/* Make sure the Universal Widget Record is "correct" by reading the actually
   instantiated values. */
ASSIGN  {adeuib/std_uf.i &section = "GEOMETRY"} .


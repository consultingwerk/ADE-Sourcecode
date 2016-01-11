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

File: _rdrect.p

Description:
    Procedure to read in static rectangle information.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1992

Modified on 11/20/96 by gfs added tooltip from qs
            10/13/98 by gfs added tooltip attr
---------------------------------------------------------------------------- */

{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/sharvars.i}     /* Shared variables                                  */

{adeuib/analyze.i &TYPE = "RECTANGLE" }  /* Analyzer Names                   */

DEFINE SHARED STREAM    _P_QS2.
DEFINE SHARED VARIABLE  _inp_line  AS  CHAR     EXTENT 100             NO-UNDO.

{adeuib/readinit.i &p_type="RECTANGLE" 
                   &p_basetype="RECT" }

ASSIGN _L._EDGE-PIXELS  = INTEGER({&ARC_edge-pixels})
       _L._FILLED       = {&ARC_no-fill} eq "n"
       _L._GRAPHIC-EDGE = (_L._EDGE-PIXELS > 0 AND _L._EDGE-PIXELS < 7)
       _U._TOOLTIP      = {&ARC_TOOLTIP}
       _U._TOOLTIP-ATTR = {&ARC_TOOLTIP-ATTR}
       .
       
CREATE RECTANGLE _U._HANDLE
    ASSIGN {adeuib/std_attr.i &MODE = "READ" 
                              &NO-FONT = YES}
           EDGE-PIXELS = _L._EDGE-PIXELS
           FILLED      = _L._FILLED
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


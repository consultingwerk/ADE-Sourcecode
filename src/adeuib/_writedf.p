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

File: _writedf.p

Description:
    Write out the definitions necessary to assure proper syntax checking of 
    a query.  It is called from _query2.p.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: D. Ross Hunter

Date Created: 1993

Last modified:
    04/09/97 by jep - Changed p_status to "CHECK-SYNTAX" from "RUN" for
                      for correct call to _gendefs.p.
    10/05/94 by GFS - Added XFTR.I

---------------------------------------------------------------------------- */
{adeuib/uniwidg.i}      /* Universal Widget TEMP-TABLE definition            */
{adeuib/layout.i}       /* Layout temp-table definitions                     */
{adeuib/triggers.i}     /* Trigger TEMP-TABLE definition                     */
{adeuib/xftr.i}         /* XFTR TEMP-TABLE definition                        */
{adeuib/brwscols.i}     /* Brose columns temptable definitions               */
{adeuib/sharvars.i}

{adeshar/genshar.i NEW} /* Shared variables for _gendefs.p */

DEFINE SHARED STREAM P_4GL.

DEFINE VARIABLE cancel_btn   AS CHAR                                  NO-UNDO.
DEFINE VARIABLE curr_browse  AS CHAR                                  NO-UNDO.
DEFINE VARIABLE default_btn  AS CHAR                                  NO-UNDO.
DEFINE VARIABLE define_type  AS CHAR                                  NO-UNDO.
DEFINE VARIABLE frame_layer  AS WIDGET-HANDLE                         NO-UNDO.
DEFINE VARIABLE i            AS INTEGER                               NO-UNDO.
DEFINE VARIABLE iteration_ht AS DECIMAL                               NO-UNDO.
DEFINE VARIABLE ok2continue  AS LOGICAL                               NO-UNDO.
DEFINE VARIABLE p_status     AS CHAR     INITIAL "CHECK-SYNTAX"       NO-UNDO.
DEFINE VARIABLE q_label      AS CHAR                                  NO-UNDO.
DEFINE VARIABLE stack_lbl_rw AS INTEGER                               NO-UNDO.
DEFINE VARIABLE tmp_string   AS CHAR                                  NO-UNDO.
DEFINE VARIABLE tmp_name     AS CHAR                                  NO-UNDO.

DEFINE BUFFER x_F   FOR _F.
DEFINE BUFFER x_U   FOR _U.
DEFINE BUFFER x_L   FOR _L.
DEFINE BUFFER xx_U  FOR _U.

FIND _U WHERE _U._HANDLE = _h_win.
FIND _P WHERE _P._u-recid = RECID(_U).

/* Notify others of BEFORE and AFTER the partial check syntax.  Provide
   opportunity for developer to cancel. */
RUN adecomm/_adeevnt.p (INPUT  "UIB":U,
                        INPUT  "BEFORE-CHECK-SYNTAX-PARTIAL",
                        INPUT  STRING(_P._u-recid),
                        INPUT  _P._SAVE-AS-FILE,
                        OUTPUT ok2continue).
IF NOT ok2continue THEN RETURN.

/* Clean out _TRG._toffsets */
FOR EACH _TRG WHERE _TRG._pRECID = RECID(_P):
  _TRG._tOFFSET = ?.
END.

RUN adeshar/_gendefs.p (INPUT p_status, INPUT YES).

/* Notify others that the partial check syntax has ended. */
RUN adecomm/_adeevnt.p (INPUT  "UIB":U,
                        INPUT  "CHECK-SYNTAX-PARTIAL",
                        INPUT  STRING(_P._u-recid),
                        INPUT  _P._SAVE-AS-FILE,
                        OUTPUT ok2continue).

{adeuib/_genpro2.i}

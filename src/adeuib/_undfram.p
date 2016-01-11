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

File: _undfram.p

Description: Undelete a FRAME or a BROWSE widget.

Input Parameters:  uRecId - RecID of object of interest.

Output Parameters: <None>

Author: Ravi-Chandar Ramalingam

Date Created: 26 February 1993

----------------------------------------------------------------------------*/

{adeuib/uniwidg.i}
{adeuib/layout.i}         /* Layout temp-table definitions                   */
{adeuib/frameown.i NEW}  /* Frame owner temp table definition                */
{adeuib/sharvars.i}

DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.
DEFINE VARIABLE temp-cur-window AS WIDGET-HANDLE.
DEFINE VARIABLE _HEIGHT-P       AS INTEGER INITIAL ?.
DEFINE VARIABLE _WIDTH-P        AS INTEGER INITIAL ?.
DEFINE VARIABLE _X              AS INTEGER INITIAL ?.
DEFINE VARIABLE _Y              AS INTEGER INITIAL ?.

/* import_mode must be defined for _rdfram.i to compile but not used here   */
DEFINE VARIABLE import_mode     AS CHARACTER                           NO-UNDO.

FIND _U WHERE RECID(_U) = uRecId.
FIND _L WHERE RECID(_L) = _U._lo-recid.
FIND _C WHERE RECID(_C) = _U._x-recid.

ASSIGN temp-cur-window = CURRENT-WINDOW
       CURRENT-WINDOW  = IF _h_win:TYPE = "FRAME":U 
                         THEN _h_win:PARENT ELSE _h_win
      _cur_win_type    = _L._WIN-TYPE.

{adeuib/_rdfram.i}

{adeuib/rstrtrg.i} /* Restore triggers */

CURRENT-WINDOW = temp-cur-window.

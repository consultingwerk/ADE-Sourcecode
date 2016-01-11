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
/**************************************************************************
    Procedure:  _getctrl.p

    Purpose:    Wrapper to call GetControlsOfLib in VBXland
    
    Syntax :    RUN adeuib/_getctrl.p (INPUT  fullName,
                                       OUTPUT cList,
                                       OUTPUT s).

    Parameters: 
    INPUT fullName (char)
    
    OUTPUT cList (char)
           s     (int)

    Authors: Gerry Seidl
    Date   : 7/31/95
**************************************************************************/
{adeuib/sharvars.i} /* UIB Shared Information */

DEFINE INPUT  PARAMETER fullName AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER cList    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER s        AS INTEGER   NO-UNDO.

/* [gfs 12/17/96 - commented out this call because _h_controls was changed
                   to a COM-HANDLE. This will be ported later.
RUN GetControlsOfLib in _h_controls (INPUT  fullName,
                                     OUTPUT cList, 
                                     OUTPUT s).
*/

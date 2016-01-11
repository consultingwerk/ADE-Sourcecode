/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

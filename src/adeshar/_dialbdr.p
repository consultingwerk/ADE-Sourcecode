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

File: _dialbdr.p

Description:
    We show dialog boxes in the UIB as NO-BOX Frames in Windows. At runtime  
    they will be dialog boxes with a border.  We need to draw the no-box 
    frame smaller than the size of the dialog box so that the user sees  
    only the usable area of the dialog box.   
    
    This procedure makes a dummy dialog box and computes the dialog border
    from it to store in the shared variables:
    	_dialog_border_width
    	_dialog_border_height

Input Parameters:
   <none>
Output Parameters:
   <none>

Author: Wm.T.Wood

Date Created: April 29, 1993

----------------------------------------------------------------------------*/

{adeuib/dialvars.i}    /* Dialog box border variables */

DEFINE FRAME dlg 
    i AS CHAR TO 20
    WITH VIEW-AS DIALOG-BOX.
    
ASSIGN _dialog_border_width  = FRAME dlg:BORDER-LEFT +  FRAME dlg:BORDER-RIGHT
       _dialog_border_height = FRAME dlg:BORDER-TOP +  FRAME dlg:BORDER-BOTTOM.

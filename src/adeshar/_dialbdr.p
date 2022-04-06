/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

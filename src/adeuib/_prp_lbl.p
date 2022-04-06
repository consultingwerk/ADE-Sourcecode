/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _prp_lbl.p

Description:
    Display property sheet as a dialog box for the fill-in field associated
    with a label (i.e. do the fill-in not the label).

Input Parameters:
   h_self : The handle of the widget we are editing.  If UNKNOWN then
            use SELF.

Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: September 21, 1992 

----------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h_self   AS WIDGET                             NO-UNDO.

{adeuib/uniwidg.i}              /* Universal widget definition              */

DEFINE BUFFER linked_U FOR _U.
  
/* Find the related fill-in and edit it */
IF h_self eq ? THEN h_self = SELF.
FIND _U WHERE _U._HANDLE = h_self.
FIND linked_U WHERE RECID(linked_U) = _U._l-recid.
run adeuib/_proprty.p (INPUT linked_U._HANDLE).

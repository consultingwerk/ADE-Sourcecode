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

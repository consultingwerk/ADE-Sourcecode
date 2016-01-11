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

File: _prmprop.p

Description:
   Set up the parameters properties window so the user can view or modify the 
   information on a parameter.  Since this window is non-modal, we just do the
   set up here.  All triggers must be global.

Author: Donna McMann

Date Created: 05/10/99                                                                                  
----------------------------------------------------------------------------*/


{as4dict/dictvar.i shared}
{as4dict/uivar.i shared}
{adecomm/cbvar.i shared}
{as4dict/parm/parmvar.i shared}
{as4dict/FLD/uptfld.i }

 Define var ronote             as character NO-UNDO. /* virtual file note */
 Define var fldstoff1        like  b_Parm._Fld-stoff NO-UNDO.              


/*----------------------------Mainline code----------------------------------*/

/* Don't want Cancel if moving to next parameter - only when window opens */
if s_win_parm = ? then
   s_btn_Close:label in frame parmprops = "Cancel".

/* Open the window if necessary */
run as4dict/_openwin.p
   (INPUT   	  "AS/400 Parameter Properties",
    INPUT   	  frame parmprops:HANDLE,
    INPUT         {&OBJ_parm},
    INPUT-OUTPUT  s_win_parm).

/* We haven't finished fiddling with frame yet so to set status line
   don't use display statement.
*/
s_Status:screen-value in frame parmprops = "". /* clears from last time */

find as4dict.p__File where as4dict.p__File._File-number = s_ProcForNo.         

s_Parm_ReadOnly = (s_ReadOnly OR s_DB_ReadOnly). 
 {as4dict/parm/parmprop.i &Frame    = "frame parmprops"
      	       	       &ReadOnly = "s_Parm_ReadOnly"}








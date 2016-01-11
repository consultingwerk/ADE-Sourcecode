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

File: userbtns.i

Description:   
   Adds an OK and Cancel button and the rectangle that underlies them,
   to a frame.  

Text-Parameters:
    &OTHER      other buttons for both TTY AND GUI frames
    &OTHERGUI   other buttons for GUI frames ONLY
    &OTHERTTY   other buttons for TTY frames ONLY
    
Author: Laura Stern

Date Created: 11/17/92 

Modified:
    hutegger    94-09-12    added text-parameters which can get omitted
    
----------------------------------------------------------------------------*/

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
   {adecomm/okform.i
      &BOX    = rect_btns
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &OTHER  = " {&OTHER}{&OTHERGUI}"
      &HELP   = btn_Help}
&ELSE
   {adecomm/okform.i
      &STATUS = no
      &OK     = btn_OK
      &CANCEL = btn_Cancel
      &OTHER  = " {&OTHER}{&OTHERTTY}"}
&ENDIF


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

File: _dbprop.p

Description:
   Display database properties for the current db in the prop window.

Author: Laura Stern

Date Created: 12/04/92

History:
    tomn    01/10/96    Added codepage to DB Properties form (s_Db _Cp)
    
----------------------------------------------------------------------------*/
&GLOBAL-DEFINE WIN95-BTN YES

{adedict/dictvar.i shared}
{adedict/uivar.i shared}
{adedict/DB/dbvar.i shared}

find dictdb._db where recid(dictdb._db) = s_DbRecId no-lock no-error.

assign
   s_Db_PName  = s_DbCache_Pname[s_DbCache_ix]
   s_Db_Holder = s_DbCache_Holder[s_DbCache_ix]
   s_Db_Type   = s_DbCache_Type[s_DbCache_ix]
   s_Db_Cp     = if available dictdb._db then dictdb._db._db-xl-name else "".

/* Run time layout for button area.  Only do this the first time. */
if frame dbprops:private-data <> "alive" then
do:
   /* okrun.i widens frame by 1 for margin */
   assign
      frame dbprops:private-data = "alive"
      s_win_Db:width = s_win_Db:width + 1.  

   {adecomm/okrun.i  
      &FRAME = "frame dbprops" 
      &BOX   = "s_rect_Btns"
      &OK    = "s_btn_OK" 
      &HELP  = "s_btn_Help"
   }
end.

display s_CurrDb
	s_Db_Pname
	s_Db_Holder
        s_Db_Type
        s_Db_Cp
	with frame dbprops.

enable s_btn_OK s_btn_Help with frame dbprops.  
apply "entry" to s_btn_OK in frame dbprops.








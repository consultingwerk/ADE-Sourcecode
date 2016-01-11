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

File: _btnup.p

Description:
   Toggle whichever one of the browse window "show object" buttons is pushed 
   in to be un-pushed.  This means bring the "up" button to the top of 
   the z order stack so that this is the one users see.

Author: Laura Stern

Date Created: 09/22/92 
           
Modified to work with PROGRESS/400 Data Dictionary   D. McMann
          04/05/99 D. McMann Added stored procedure support   
         
----------------------------------------------------------------------------*/

{as4dict/dictvar.i shared}
{as4dict/brwvar.i shared}

case s_CurrObj:
   when {&OBJ_DB} then
      s_Res = s_Icn_Dbs:LOAD-IMAGE("adeicon/db-u").
   when {&OBJ_TBL} then
      s_Res = s_Icn_Tbls:LOAD-IMAGE("adeicon/table-u").
   when {&OBJ_SEQ} then
      s_Res = s_Icn_Seqs:LOAD-IMAGE("adeicon/seq-u").
   when {&OBJ_FLD} then
      s_Res = s_Icn_Flds:LOAD-IMAGE("adeicon/flds-u").
   when {&OBJ_IDX} then
      s_Res = s_Icn_Idxs:LOAD-IMAGE("adeicon/index-u").
   when {&OBJ_PROC} then
      s_Res = s_Icn_Proc:LOAD-IMAGE("adeicon/asproc-u").
   when {&OBJ_PARM} then
      s_Res = s_Icn_Parm:LOAD-IMAGE("adeicon/asparm-u").
   
end.




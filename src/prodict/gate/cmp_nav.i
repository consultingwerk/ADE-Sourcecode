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

/*--------------------------------------------------------------------

File: prodict/gate/cmp_nav.i

Description:
    
    generates message for "onject not available"

        
Text-Parameters:
    &nr        Index-Number for error-array (can be ommited)
    &object    {Sequence|Table|Field|Index|Index-Field}  
    &obj       {seq|tbl|fld|idx|idf} for s_ttb_{&obj}
    &objm      {seq|tbl|fld|idx|idf} for l_{&objm}-msg

Output-Parameters:
    none
    
Included in:
    gate/_gat_cmp.p
    gate/_gat_fld.i
    gate/_gat_idf.i
    gate/_gat_idx.i
    gate/_gat_tbl.i

History:
    hutegger    95/03   creation
    
--------------------------------------------------------------------*/        
/*h-*/

       l_sev-msg = l_sev-msg + "    {&object} "
                 + s_ttb_{&obj}.ds_name {&plus} + ": " + chr(10) + chr(9)
                 + l_msg[l_{&objm}-msg[1{&nr}]]        + chr(10).

/*------------------------------------------------------------------*/

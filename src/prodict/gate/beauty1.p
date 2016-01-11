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

File: prodict/gate/beauty1.p

Description:  This routine is called bu gate/beauty.i.  The reason this code is
              not part of beauty.i is because we do not want to reference the
              database directly because this will cause the schema to get 
              cached.  Schema adjustments would not be seen.

Textual-Parameter:

Output-Parameters:
    none
    
History:
    96/07   kkelley     Routine was written because we do not want to 
                        reference DICTDB directly in gate/beauty.i
            
--------------------------------------------------------------------*/
/*h-*/
define  input parameter  o_for-db    as character    no-undo.
define output parameter  o_drec_db   as recid        no-undo.

/*----------------------------- Main Code --------------------------*/

FIND DICTDB._Db WHERE DICTDB._Db._Db-name = o_for-db no-lock no-error.
if not available DICTDB._Db
 then FIND DICTDB._Db WHERE DICTDB._Db._Db-name = ? no-lock.

assign o_drec_db = RECID(DICTDB._DB).

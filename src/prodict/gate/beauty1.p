/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

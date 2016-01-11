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

/* _odb_md3.p - returns list of ODBC objects in pik_count,pik_list */

/* redundant!!!!
 *      got replaced by odb_get.p
 *                      (hutegger 95/03)
 */
 
/*
This is used primarily for the Progress automated test
scripts, but it was reasoned that it is useful enough in
general to leave in the /prodict directory for future use.
*/


&SCOPED-DEFINE DATASERVER YES
{ prodict/dictvar.i }
&UNDEFINE DATASERVER

{ prodict/user/userhue.i } /* userpik.i needs color def vars from userhue.i */
{ prodict/user/userpik.i }
{ prodict/gate/odb_ctl.i }


DEFINE VARIABLE driver-prefix AS CHARACTER NO-UNDO.
DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
DEFINE VARIABLE object-type   AS CHARACTER NO-UNDO.
DEFINE VARIABLE object-name   AS CHARACTER NO-UNDO.
DEFINE VARIABLE object-prog   as CHARACTER NO-UNDO.

/*
{prodict/gate/gatework.i
  &new        = " "
  &options    = "initial ""*"" "
  &SelVarType = "VARIABLE l"
  } / * Defines WORKFILE: gate-work */

RUN STORED-PROC DICTDBG.CloseAllProcs.
FIND DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db NO-LOCK.

RUN STORED-PROC DICTDBG.SQLTables(?,?,?,?).

FOR EACH DICTDBG.SQLTables_buffer:
    if DICTDBG.SQLTables_buffer.type = "SYSTEM TABLE" or 
          TRIM(DICTDBG.SQLTables_buffer.name) BEGINS "_SEQP_" then 
       NEXT.
     
    if TRIM(DICTDBG.SQLTables_buffer.name) BEGINS "_SEQT_" then do:
        assign 
            object-type = "SEQUENCE"
            object-name = SUBSTR(DICTDBG.SQLTables_buffer.name,7,-1,"character").
    end. 
    else if TRIM(DICTDBG.SQLTables_buffer.name) BEGINS "_BUFFER_" and 
            DICTDBG.SQLTables_buffer.type = "VIEW" then do:
        assign 
            object-type = "BUFFER"
            object-name = SUBSTR(DICTDBG.SQLTables_buffer.name,9,-1,"character").
    end. 
    else do:
        assign 
            object-type = DICTDBG.SQLTables_buffer.type
            object-name = DICTDBG.SQLTables_buffer.name.
    end.
 
    object-prog = object-name.
    RUN prodict/gate/_gat_xlt.p (TRUE,drec_db,INPUT-OUTPUT object-prog).


    create gate-work.

    assign 
         gate-work.gate-type = object-type
         gate-work.gate-name = object-name
         gate-work.gate-qual = ( IF DICTDBG.SQLTables_buffer.qualifier = ?
                               THEN ""
                               ELSE TRIM(DICTDBG.SQLTables_buffer.qualifier)
                            )
         gate-work.gate-user = TRIM(DICTDBG.SQLTables_buffer.owner)
         gate-work.gate-prog = object-prog.

end. 

CLOSE STORED-PROC DICTDBG.SQLTables.

RETURN.

/**********************************************************************
* Copyright (C) 2000,2006 by Progress Software Corporation. All rights*
* reserved.  Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                            *
*                                                                     *
**********************************************************************/

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
DEFINE VARIABLE is_db2        AS LOGICAL   NO-UNDO.

/*
{prodict/gate/gatework.i
  &new        = " "
  &options    = "initial ""*"" "
  &SelVarType = "VARIABLE l"
  } / * Defines WORKFILE: gate-work */

RUN STORED-PROC DICTDBG.CloseAllProcs.
FIND DICTDB._Db WHERE RECID(DICTDB._Db) = drec_db NO-LOCK.

ASSIGN is_db2 = INDEX(UPPER(_Db._Db-misc2[8]), "DB2") > 0.

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
    ELSE IF is_db2 AND TRIM(DICTDBG.SQLTables_buffer.name) BEGINS "P_BUFFER_" and 
            DICTDBG.SQLTables_buffer.type = "VIEW" THEN DO:
        /* 20060425-009 - for DB2, look for P_BUFFER */
        assign 
            object-type = "BUFFER"
            object-name = SUBSTR(DICTDBG.SQLTables_buffer.name,10,-1,"character").
    END.
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

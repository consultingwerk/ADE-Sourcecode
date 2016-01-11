/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _dmpseqs.p - dump _Sequence file into _Seqvals.d */
/*
in:  user_env[2] = Name of file to dump to.
     user_env[5] = "<internal defaults apply>" or "<target-code-page>"

History:
    hutegger    94/02/24    code-page - support and trailer-info added
    mcmann      08/08/02    Eliminated any sequences whose name begins "$" - Peer Direct
    
*/
/*h-*/

{ prodict/user/uservar.i }
{ prodict/dictvar.i }

DEFINE VARIABLE i       AS INTEGER   NO-UNDO.
DEFINE VARIABLE tmpfile AS CHARACTER NO-UNDO.

FIND FIRST _Db WHERE RECID(_Db) = drec_db NO-LOCK.

IF NOT CAN-FIND(FIRST DICTDB._Sequence OF _Db WHERE NOT
                DICTDB._Sequence._Seq-name BEGINS "$") THEN DO:
   MESSAGE "There are no sequences to dump." SKIP
      	   "The output file has not been modified."
      	    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   RETURN.
END.

run adecomm/_setcurs.p ("WAIT").

RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
OUTPUT TO VALUE(tmpfile) NO-MAP NO-ECHO.

FOR EACH _Sequence OF _Db WHERE NOT _Sequence._Seq-name BEGINS "$":
  PUT UNFORMATTED
    'EXPORT '
    _Sequence._Seq-Num
    ' "'
    _Sequence._Seq-Name
    '" CURRENT-VALUE(' _Sequence._Seq-Name ',' LDBNAME(user_dbname) ').' SKIP.
END.
OUTPUT CLOSE.

IF  user_env[5] = " "
 OR user_env[5] = ?  THEN assign user_env[5] = "<internal defaults apply>".
 
IF user_env[5] = "<internal defaults apply>"
 then OUTPUT TO VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
 else OUTPUT TO VALUE(user_env[2]) NO-ECHO NO-MAP
             CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].
RUN VALUE(tmpfile).

  {prodict/dump/dmptrail.i
    &entries      = " "
    &seek-stream  = "OUTPUT"
    &stream       = " "
    }  /* adds trailer with code-page-entrie to end of file */
    
OUTPUT CLOSE.

OS-DELETE VALUE(tmpfile).

/* auditing of application data */
AUDIT-CONTROL:LOG-AUDIT-EVENT(10213, 
                              PDBNAME("dictdb") + "._sequence" /* db-name.table-name */, 
                              "" /* detail */).

run adecomm/_setcurs.p ("").
MESSAGE "Dump of sequence values completed." 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
RETURN.

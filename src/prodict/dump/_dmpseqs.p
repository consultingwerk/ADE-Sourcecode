/*********************************************************************
* Copyright (C) 2005,2007,2014 by Progress Software Corporation. All *
* rights reserved.  Prior versions of this work may contain portions *
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
    fernando    06/19/07    Support for large files    
*/
using Progress.Lang.*.
routine-level on error undo, throw.

/*h-*/

{ prodict/user/uservar.i }
{ prodict/dictvar.i }

DEFINE VARIABLE tmpfile AS CHARACTER NO-UNDO.
define variable lApplAlertBox as logical no-undo.
DEFINE VARIABLE cMsg          AS CHARACTER NO-UNDO.

/* check if LDBNAME(dbname) is a keyword; if yes, throw error and return */
IF  KEYWORD(LDBNAME(user_dbname)) <> ? THEN DO:
    message QUOTER(LDBNAME(user_dbname)) " used as logical database name is a reserved keyword. Please try again. "
            VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
    RETURN.
END.    

lApplAlertBox = SESSION:APPL-ALERT-BOXES.

if user_env[6] eq "no-alert-boxes":u then
    SESSION:APPL-ALERT-BOXES  = No.
else
    /* Set explicitly to Yes since this was the previous behaviour 
       for the MESSAGE statements used in this procedure. */
    SESSION:APPL-ALERT-BOXES  = Yes.

FIND FIRST _Db WHERE RECID(_Db) = drec_db NO-LOCK.

IF NOT CAN-FIND(FIRST DICTDB._Sequence OF _Db WHERE NOT
                DICTDB._Sequence._Seq-name BEGINS "$") THEN DO:
   cMsg =  "There are no sequences to dump." + "~n" +
           "The output file has not been modified." .           
   if user_env[6] = "dump-silent" then
              undo, throw new AppError(cMsg).
   else
              MESSAGE cMsg.
   RETURN.
END.

run adecomm/_setcurs.p ("WAIT").

RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
OUTPUT TO VALUE(tmpfile) NO-MAP NO-ECHO.

FOR EACH _Sequence OF _Db WHERE NOT _Sequence._Seq-name BEGINS "$"
                          and (   user_env[33] = ""
                               or (user_env[33] = "Tenant" and
                                   _Sequence._Seq-attributes[1])
                               or (user_env[33] = "Shared" and
                                   _Sequence._Seq-attributes[1] = false)
                               ):
                             
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

cMsg = "Dump of sequence values completed." .
if user_env[6] = "dump-silent" then 
   .
else
MESSAGE cMsg .


RETURN.
finally:
    session:appl-alert-boxes = lApplAlertBox.
    user_env[33] = "".
end.    

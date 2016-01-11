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
run adecomm/_setcurs.p ("").
MESSAGE "Dump of sequence values completed." 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
RETURN.

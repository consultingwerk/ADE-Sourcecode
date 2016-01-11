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
        
*/
/*h-*/

{ as4dict/dictvar.i shared}
{ as4dict/dump/dumpvar.i shared}

DEFINE VARIABLE i       AS INTEGER   NO-UNDO.
DEFINE VARIABLE tmpfile AS CHARACTER NO-UNDO.

/*  The following variable is simply a placeholder to replace the */
/*  seq-num value which is displayed in a PROGRESS format dump.   */
/*  This dump format will be the same as a PROGRESS format dump, so  */
/*  a user may use the output of this dump in any LOAD SEQUENCE   */
/*  CURRENT VALUES selection.  Note, however, that the information */
/*  is dumped from the P__SEQ file, not the schema, as in all the  */
/*  PROGRESS/400 dumps. Seqnumber is simply incremented each time  */
/*  and displyed in the dump, taking the place of _seq-num.        */
DEFINE VARIABLE seqnumber AS INTEGER NO-UNDO.

FIND FIRST as4dict.P__Db /* WHERE RECID(_Db) = drec_db */ NO-LOCK.

IF NOT CAN-FIND(FIRST as4dict.p__Seq) THEN DO:
   MESSAGE "There are no sequences to dump." SKIP
      	   "The output file has not been modified."
      	    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   RETURN.
END.

run adecomm/_setcurs.p ("WAIT").

RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".adm", OUTPUT tmpfile).
OUTPUT TO VALUE(tmpfile) NO-MAP NO-ECHO.

seqnumber = 0.
FOR EACH as4dict.p__Seq:
  PUT UNFORMATTED
/*  'EXPORT '
    as4dict.p__Seq._Seq-Num 
    ' "'                */
    'EXPORT ' 
    seqnumber
    ' "'
    as4dict.p__Seq._Seq-Name 
    '" CURRENT-VALUE(' as4dict.p__Seq._Seq-Name ',' LDBNAME(user_dbname) ').' SKIP. 
    seqnumber = seqnumber + 1.
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

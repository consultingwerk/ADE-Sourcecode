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

File: prodict/load_df.p

    End-user entry point for Admin Tool's "Load .df file" utility
      
Input Parameters:
    df-file-name    The name of the .df file to be loaded into DICTDB
    
Output Parameters:
    none
    
Used/Modified Shared Objects:
    defines several NEW SHARED objects
    
History:
    Mario B.    99/03/18    Added user_env[19] to signal _lodsddl.p that it is
                            being called by this code.  If so, _lodsddl.p
                            eliminates the display of any "remaining"
                            alert-boxes not dealt with by prior modifications
                            designed to handle this issue.  
    tomn        08/29/95    Added check for codepage spec in .df file
                            trailer; Leaves as UNDEFINED if none specified
    mcmann      07/13/98    Added check for both cpstream and codepage
    mcmann      03/14/01    Added ability to pass in two entries in input parameter
                            to allow user to commit when errors are found.

----------------------------------------------------------------------------*/
/*h-*/

/*==========================  DEFINITIONS ===========================*/

DEFINE INPUT PARAMETER df-file-name AS CHARACTER NO-UNDO.

{ prodict/user/uservar.i NEW }
{ prodict/dictvar.i NEW }

DEFINE VAR save_ab       AS LOGICAL        NO-UNDO.
DEFINE VAR codepage AS CHARACTER      NO-UNDO FORMAT "X(20)".
DEFINE VAR lvar     AS CHAR EXTENT 10 NO-UNDO.
DEFINE VAR lvar#    AS INT            NO-UNDO.
DEFINE VAR i        AS INT            NO-UNDO.


/*========================= MAINLINE CODE ============================*/

/*check runtime create privileges*/
FOR EACH _File
  WHERE _File._File-number >= -4 AND _File._File-number <= -1:
  IF CAN-DO(_File._Can-write,USERID("DICTDB"))
           AND CAN-DO(_File._Can-create,USERID("DICTDB")) THEN NEXT.
  MESSAGE "You do not have permission to load table definitions.".
  RETURN.
END. 

FIND FIRST _Db WHERE _Db._Db-local.
ASSIGN
  user_dbname = LDBNAME("DICTDB")
  user_dbtype = DBTYPE("DICTDB")
  drec_db     = RECID(_Db)  
  user_env[6] = "f"
  user_env[8] = user_dbname
  user_env[19] = THIS-PROCEDURE:FILE-NAME
  codepage    = "".  
  
/* If user wants to commit even if there are errors in the df, they can
   pass in a string composed of "df-file-name,yes"  If user_env[15] is
   set to yes, the _lodsddl.p will handle for committing with errors.
*/   
IF NUM-ENTRIES(df-file-name) > 1 THEN
    ASSIGN user_env[2] = ENTRY(1,df-file-name)
           user_env[15] = ENTRY(2,df-file-name).
ELSE
    ASSIGN user_env[2] = df-file-name.

RUN read-cp.  /* get codepage out of the .df file trailer (tomn 8/28/95) */ 
user_env[10] = codepage.

SESSION:APPL-ALERT-BOXES = NO.
save_ab = SESSION:APPL-ALERT-BOXES.
DEFINE VAR counter AS INT NO-UNDO INITIAL 1.

/*Fernando: 20020129-017 check how many message the client issued before running the 
  load process. Counter will be pointing to the next position in the message queue */
REPEAT:
 IF _msg(counter) > 0 THEN
      ASSIGN counter = counter + 1.
 ELSE
     LEAVE.
END.

DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  user_path = "*".
  RUN "prodict/dump/_lodv5df.p".
  IF user_path = "*" THEN RUN "prodict/dump/_lodsddl.p".
  
  IF user_path = "*R" then UNDO, LEAVE.
END.
             
/*Fernando: 20020129-017 if there was a message from the client after the load process started, 
search for error number 151 (defined as ERROR_ROLLBACK)  and write to the error log file. The error
would be the first entry in message queue ( _msg(1) ).
Variable counter will be pointing to the next to what would be the last message we captured
If _msg(counter) is 0, it means that no new messages were issued */
IF  _msg(counter) > 0 AND _msg(1) = {&ERROR_ROLLBACK} THEN
DO:
        OUTPUT TO VALUE (LDBNAME("DICTDB") + ".e") APPEND.
        PUT UNFORMATTED TODAY " " STRING(TIME,"HH:MM") " : "
           "Load of " user_env[2] " into database " 
           LDBNAME("DICTDB") " was unsuccessful." SKIP " All the changes were backed out..." 
           SKIP " Progress Recent Message(s): (" _msg(1) ") " .
            IF _msg(2) > 0 THEN 
                PUT UNFORMATTED "(" _msg(2) ")." SKIP(1).
            
        OUTPUT CLOSE.
END.


SESSION:APPL-ALERT-BOXES = save_ab.
RETURN.

/*====================== INTERNAL PROCEDURES =========================*/

PROCEDURE read-cp.
  /* Read trailer of file and find codepage */
  /* (partially stolen from lodtrail.i)     */
  
  DEFINE VARIABLE i     AS INT            NO-UNDO.

  INPUT FROM VALUE(user_env[2]) NO-ECHO NO-MAP.
  SEEK INPUT TO END.
  SEEK INPUT TO SEEK(INPUT) - 11. /* position to beginning of last line */

  READKEY PAUSE 0.
  ASSIGN
    lvar# = 0
    lvar  = ""
    i     = 0.
  DO WHILE LASTKEY <> 13 AND i <> ?: /* get byte count (last line) */
    i = (IF LASTKEY > 47 AND LASTKEY < 58 
          THEN i * 10 + LASTKEY - 48
          ELSE ?).
    READKEY PAUSE 0.
  END.
  IF i > 0 then run get_psc. /* get it */
  ELSE RUN find_psc. /* look for it */
  INPUT CLOSE.
  DO i = 1 TO lvar#:
    IF lvar[i] BEGINS "cpstream=" OR lvar[i] BEGINS "codepage=" THEN codepage = TRIM(SUBSTRING(lvar[i],10,-1,"character":U)).
  END.
END PROCEDURE.

PROCEDURE get_psc:
  /* using the byte count, we scoot right down there and look for
   * the beginning of the trailer ("PSC"). If we don't find it, we
   * will go and look for it.
   */
   
  DEFINE VARIABLE rc AS LOGICAL INITIAL no.
  _psc:
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    SEEK INPUT TO i. /* skip to beginning of "PSC" in file */
    READKEY PAUSE 0. IF LASTKEY <> ASC("P") THEN LEAVE _psc. /* not there!*/
    READKEY PAUSE 0. IF LASTKEY <> ASC("S") THEN LEAVE _psc.
    READKEY PAUSE 0. IF LASTKEY <> ASC("C") THEN LEAVE _psc.
    ASSIGN rc = yes. /* found it! */
    RUN read_bits (INPUT i). /* read trailer bits */
  END.
  IF NOT rc THEN RUN find_psc. /* look for it */
END PROCEDURE.

PROCEDURE find_psc:
  /* If the bytecount at the end of the file is wrong, we will jump
   * back the maximum number of bytes in a trailer and start looking
   * from there. If we still don't find it then tough luck.
   * NOTE: Variable p holds the number of bytes to roll back. AS of
   * 7/21/94, the max size of a trailer (.d) is 204 bytes, if you add
   * anything to this trailer, you must change this number to reflect
   * the number of bytes you added. I'll use 256 to add a little padding. (gfs)
   */
  DEFINE VARIABLE p AS INTEGER INITIAL 256. /* really 204, added extra just in case */
  DEFINE VARIABLE l AS INTEGER.             /* last char position */
  
  SEEK INPUT TO END.
  ASSIGN l = SEEK(INPUT). /* EOF */
  SEEK INPUT TO SEEK(INPUT) - MINIMUM(p,l). /* take p, or size of file */
  IF SEEK(INPUT) = ? THEN RETURN.
  _scan:
  REPEAT ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
    READKEY PAUSE 0.
    p = SEEK(INPUT). /* save off where we are looking */
    IF LASTKEY = ASC("P") THEN DO:
       READKEY PAUSE 0.
       IF LASTKEY <> ASC("S") THEN NEXT.
       ELSE DO: /* found "PS" */
         READKEY PAUSE 0.
         IF LASTKEY <> ASC("C") THEN NEXT.
         ELSE DO: /* found "PSC"! */
           RUN read_bits (INPUT p - 1).
           LEAVE.
         END. /* IF "C" */
       END. /* IF "S" */    
    END. /* IF "P" */
    ELSE IF p >= l THEN LEAVE _scan. /* at EOF, so give up */
  END. /* repeat */
END.

PROCEDURE read_bits:
  /* reads trailer given a starting position 
   */ 
  DEFINE INPUT PARAMETER i as INTEGER. /* "SEEK TO" location */
    
  SEEK INPUT TO i.
  REPEAT:
    IMPORT lvar[lvar# + 1].
    lvar# = lvar# + 1.
  END.
END PROCEDURE. 

/*========================== END OF load_df.p ==========================*/



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

/* lodtrail.i

function:
    reads a trailer with codepage-information 
    assigns 
      codepage   "UNDEFINED" or "<codepage according to trailer>"
      cerror     "no-convert" or "<translated 'a'>" or ? (:= conv-error)
      
text-parameters:
    &entries        ev. additional entries
    &file           input-file-name
    
included in:
  prodict/dump/_loddata.p    
  prodict/dump/_lodsddl.p    
  prodict/dump/_lodseqs.p    
  prodict/dump/_loduser.p    
  prodict/dump/_lodview.p    
    
Needs:
  DEF VAR codepage AS CHAR.
  DEF VAR lvar     AS CHAR EXTENT 10.
  DEF VAR lvar#    AS INT.
  
  NOTE: IF YOU MODIFY THE TRAILER: PLEASE FIX THE BYTECOUNT BELOW in Find_PSC. 
  ALSO, prodict/user/userload.i USES SIMILAR ROUTINES TO THESE. PLEASE CHECK 
  THEM AS WELL.
  
history:
    mcmann      98/07/09    Added both cpstream and codepate for check
    gfs         94/07/25    make a better effort to find "PSC" 
    hutegger    94/03/02    creation
    hutegger    94/03/30    94-03-30-012 - changed default-value of 
                            codepage-variable to SESSION:STREAM
    
*/
/*h-*/

/*assign codepage = SESSION:STREAM.*/   /* according to LisaB: 94-03-30-012 */
                                        /* in case no codepage-parameter    */
                                        /* the input ought to be converted  */
                                        /* SESSION:STREAM                   */ 
                                        /*      <hutegger> 94/03            */
ASSIGN codepage = 
  IF user_env[10] = "" THEN
    SESSION:STREAM 
  ELSE user_env[10].  /* set in _usrload */
/*-------------------------------------------------- start of tail read 
  **** THIS IS THE OLD ROUTINE ****
  **** THE code BELOW REPLACE IT **
  
  INPUT FROM VALUE({&file}) NO-ECHO NO-MAP.
  SEEK INPUT TO END.
  SEEK INPUT TO SEEK(INPUT) - 11.
  READKEY PAUSE 0.
  ASSIGN
    lvar# = 0
    lvar  = ""
    i     = 0.
  DO WHILE LASTKEY <> 13 AND i <> ?:
    i = (IF LASTKEY > 47 AND LASTKEY < 58 
          THEN i * 10 + LASTKEY - 48
          ELSE ?).
    READKEY PAUSE 0.
  END.
  IF i > 0 
    THEN _psc: 
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      SEEK INPUT TO i.
      READKEY PAUSE 0. IF LASTKEY <> ASC("P") THEN LEAVE _psc.
      READKEY PAUSE 0. IF LASTKEY <> ASC("S") THEN LEAVE _psc.
      READKEY PAUSE 0. IF LASTKEY <> ASC("C") THEN LEAVE _psc.
      SEEK INPUT TO i.
      SET ^. /* skip end-of-line */
      REPEAT:
        IMPORT lvar[lvar# + 1].
        lvar# = lvar# + 1.
      END.
    END.
    INPUT CLOSE.
    DO i = 1 TO lvar#:
      {&entries}
      /*IF lvar[i] BEGINS "<name>="   THEN <variable>  = SUBSTRING(lvar[i],<l>).*/
      IF lvar[i] BEGINS "cpstream=" OR lvar[i] BEGINS "codepage=" THEN 
        ASSIGN codepage    = SUBSTRING(lvar[i],10).
    END.
---------------------------------------------------- end of tail read */

/**** START OF NEW ROUTINE ****/
RUN read-trailer.

IF codepage        <> "UNDEFINED" AND
   codepage        <> ""          AND
   SESSION:CHARSET <> ?
THEN ASSIGN cerror = CODEPAGE-CONVERT("a",SESSION:CHARSET,codepage).
ELSE ASSIGN cerror = "no-convert".
 
 
/********************* INTERNAL PROCEDURES *****************************/

PROCEDURE read-trailer.
  /* Read trailer of file and find codepage */
  /* (partially stolen from lodtrail.i)     */
  
  DEFINE VARIABLE i     AS INT            NO-UNDO.

  INPUT FROM VALUE({&file}) NO-ECHO NO-MAP.
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
    {&entries}
    IF lvar[i] BEGINS "cpstream=" OR lvar[i] BEGINS "codepage="
      THEN codepage = SUBSTRING(lvar[i],10).
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
  ASSIGN l = SEEK(INPUT). /* store off EOF */
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

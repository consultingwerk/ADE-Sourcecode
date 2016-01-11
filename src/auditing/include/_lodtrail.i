/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/* _lodtrail.i

function:
    reads a trailer with codepage-information 
    assigns 
      codepage   "UNDEFINED" or "<codepage according to trailer>"
      cerror     "no-convert" or "<translated 'a'>" or ? (:= conv-error)
      
text-parameters:
    &entries        ev. additional entries
    &file           input-file-name
    
Needs:
  DEF VAR codepage AS CHAR.
  DEF VAR lvar     AS CHAR EXTENT 10.
  DEF VAR lvar#    AS INT.
  
  NOTE: IF YOU MODIFY THE TRAILER: PLEASE FIX THE BYTECOUNT BELOW in Find_PSC. 
  ALSO, prodict/user/userload.i USES SIMILAR ROUTINES TO THESE. PLEASE CHECK 
  THEM AS WELL.
  
  History:
  fernando    06/20/07   Support for large files
  
*/
ASSIGN codepage = SESSION:STREAM.

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
  
  DEFINE VARIABLE tempi AS DECIMAL          NO-UNDO.
  DEFINE VARIABLE j     AS INTEGER          NO-UNDO.

  INPUT FROM VALUE({&file}) NO-ECHO NO-MAP.
  SEEK INPUT TO END.

  i = SEEK(INPUT) - 11.
  SEEK INPUT TO i. /* position to possible beginning of last line */

  READKEY PAUSE 0.

  /* Now we need to deal with a large offset, which is a variable size
     value in the trailer, for large values.
     Now go back one character at a time until we find a new line or we have
     gone back too far.
     For the non-large offset format, the previous char will be a
     newline character, so we will  detect that right away and read the
     value as usual. Unless the file has CRLF (Windows), in which case
     we will go back 1 character to read the value properly - to
     account for the extra byte.
     For larger values, we will read as many digits as needed.
     The loop below could stop after 10 digits, but I am letting it go
     up to 50 to try to catch a bad value.
  */
  DO WHILE LASTKEY <> 13 AND j <= 50:
      ASSIGN j = j + 1
             i = i - 1.
      SEEK INPUT TO i.
      READKEY PAUSE 0.
  END.

  /* now we can start reading it */
  READKEY PAUSE 0.
  ASSIGN
    lvar# = 0
    lvar  = ""
    i     = 0.

  DO WHILE LASTKEY <> 13 AND i <> ?: /* get byte count (last line) */
      IF LASTKEY > 47 AND LASTKEY < 58 THEN DO:
          /* check if can fit the value into an int64 type. We need
             to manipulate it with a decimal so that we don't get fooled
             by a value that overflows. This is so that we catch a
             bad offset in the file.
           */
          ASSIGN tempi = i /* first move it to a decimal */
                 tempi = tempi * 10 + LASTKEY - 48. /* get new value */
          i = INT64(tempi) NO-ERROR. /* see if it fits into an int64 */
          
          /* check if the value overflows becoming negative or an error happened. 
             If so, something is wrong (too many digits or invalid values),
             so forget this.
          */
          IF  i < 0 OR
              ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
              ASSIGN i = 0.
              LEAVE. /* we are done with this */
          END.

      END.
      ELSE 
          ASSIGN i = ?. /* bad character */

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
  DEFINE VARIABLE p AS INT64 INITIAL 256. /* really 204, added extra just in case */
  DEFINE VARIABLE l AS INT64.             /* LAST char position */
  
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
  DEFINE INPUT PARAMETER pi as INT64. /* "SEEK TO" location */
    
  SEEK INPUT TO pi.
  REPEAT:
    IMPORT lvar[lvar# + 1].
    lvar# = lvar# + 1.
  END.
END PROCEDURE. 

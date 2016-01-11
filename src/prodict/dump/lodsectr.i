/*************************************************************/  
/* Copyright (c) 1984-2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/* lodsectr.i

Author: Kenneth S. McIntosh

Created: May 10, 2005

Purpose:
    Loads trailer information for secure load utility

Preconditions:    
    Needs the stream to be open
    
Text Parameters:
    {1}         Error Variable
    {2}         Input File Name
    {3}         Trailer Location
    {3}         Buffer Handle for loading trailer information
    
Note:  Data items in the input must be named the same as the buffer fields.
    
Included in:
  prodict/dump/_dmpsec.p    
  
History:
  Nov 04, 2005 fernando    Try to find trailer info if byte count is incorrect. 20051104-046
  Mar 05, 2007 fernando    Check if trailer start seems correct - OE00135015
  Jun 20, 2007 fernando    Support for large files
*/

RUN readTrailer.

/********************* INTERNAL PROCEDURES *****************************/

PROCEDURE readTrailer.
  DEFINE VARIABLE iCount   AS INTEGER     NO-UNDO.

  DEFINE VARIABLE cInput   AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hField   AS HANDLE      NO-UNDO.

  DEFINE VARIABLE EndPos   AS INT64       NO-UNDO.
  DEFINE VARIABLE m        AS INT64       NO-UNDO.

  DEFINE VARIABLE j        AS INTEGER     NO-UNDO.

  /* 20051104-046
  
     var p holds the number of bytes to roll back if the bytecound at the end of
     the file is wrong. We will jump back the maximum number of bytes in a trailer
     and start looking from there. 256 is actually a little bigger than the maximum
     size but I am making it 256 just to add a little padding.
  */
  DEFINE VARIABLE p        AS INTEGER     NO-UNDO INITIAL 256.

  INPUT FROM VALUE({2}) NO-ECHO NO-MAP.
  SEEK INPUT TO END.
  ASSIGN EndPos = SEEK(INPUT) /* store odd EOF */
         m = EndPos - 11.

  SEEK INPUT TO m. /* position to possible beginning of last line */

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
             m = m - 1.
      SEEK INPUT TO m.
      READKEY PAUSE 0.
  END.

  IMPORT UNFORMATTED cInput.

  {3} = INT64(CINPUT) NO-ERROR.

  /* If the above failed it could be because the value is too big
     for some reason. This file must be corrupted somehow. But as long as
     the seal info later is correct, that would be fine.
     We will try to find the trailer info in the method below
  */
  IF ERROR-STATUS:NUM-MESSAGES  > 0 THEN
     ASSIGN m = ?.
  ELSE DO:
     SEEK INPUT TO {3}.
     m = SEEK(INPUT).
  END.

  /* OE00135015
     If the location of the trailer seems ok based on the size of the file, still want to
     check if bytecount was incorrect due to carriage return difference between Windows
     and UNIX. If we are not looking at the beginning of the trailer info, set m = ?
     so that we run the code below that will try to find the trailer.
  */
  IF m NE ? AND m < EndPos THEN DO:
      DO ON ENDKEY UNDO, LEAVE:
          IMPORT UNFORMATTED cInput.
          cInput = TRIM(cInput).
      END.
      IF cInput NE "PSC" THEN
          ASSIGN m = ?.
  END.

  /* 20051104-046 
     Check if we can find the trailer info in case the bytecount is incorrect.
     If we can't, we will continue to execute the code below and we will
     set the error code.
  */
  IF m = ? OR m >= EndPos THEN DO:
     SEEK INPUT TO END.
     SEEK INPUT TO SEEK(INPUT) - MINIMUM(p,EndPos).

     REPEAT ON ERROR UNDO, LEAVE ON ENDKEY UNDO,LEAVE:
         IMPORT UNFORMATTED cInput.
         IF cInput = "PSC":U THEN
             LEAVE.
     END.
  END.
  
  REPEAT ON ERROR UNDO, LEAVE:
    {1} = TRUE.
    IMPORT UNFORMATTED cInput.
    cInput = TRIM(cInput).
    IF cInput = "." THEN DO:
      {1} = FALSE.
      LEAVE.
    END.

    IF cInput = "PSC" OR
       NUM-ENTRIES(cInput,"=") < 2 THEN NEXT.

    hField = {4}:BUFFER-FIELD(ENTRY(1,cInput,"=")) NO-ERROR.
    /* Ignore data there is no field for... */
    IF NOT VALID-HANDLE(hField) THEN NEXT.

    hField:BUFFER-VALUE = SUBSTRING(cInput,INDEX(cInput,"=") + 1,-1,"CHARACTER").

    {1} = FALSE.
  END.
  INPUT CLOSE.
  
END PROCEDURE.

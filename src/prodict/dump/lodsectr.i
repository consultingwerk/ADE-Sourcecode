/*************************************************************/  
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
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
*/

RUN readTrailer.

/********************* INTERNAL PROCEDURES *****************************/

PROCEDURE readTrailer.
  DEFINE VARIABLE iNumRecs AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iCount   AS INTEGER     NO-UNDO.

  DEFINE VARIABLE cInput   AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hField   AS HANDLE      NO-UNDO.

  DEFINE VARIABLE EndPos   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE m        AS INTEGER     NO-UNDO.

  /* 20051104-046
  
     var p holds the number of bytes to roll back if the bytecound at the end of
     the file is wrong. We will jump back the maximum number of bytes in a trailer
     and start looking from there. 256 is actually a little bigger than the maximum
     size but I am making it 256 just to add a little padding.
  */
  DEFINE VARIABLE p        AS INTEGER     NO-UNDO INITIAL 256.

  INPUT FROM VALUE({2}) NO-ECHO NO-MAP.
  SEEK INPUT TO END.
  EndPos = SEEK(INPUT). /* store odd EOF */

  SEEK INPUT TO SEEK(INPUT) - 11. /* position to beginning of last line */

  IMPORT UNFORMATTED cInput.
  
  {3} = INTEGER(cInput).

  SEEK INPUT TO {3}.

  m = SEEK(INPUT).

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

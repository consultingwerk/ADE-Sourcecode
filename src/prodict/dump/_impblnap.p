/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/* prodict/dump/_impblnap.p */

/*
Purpose: Import procedure responsible for executing the actual 
         IMPORT statement on behalf of the secure load utility 
         (prodict/dump/_lodsec.p) - for audit policy tables.

Parameters:
  phBuffer     = Handle to the buffer to be loaded.

  plOmitLob    = Logical telling whether to OMIT LOB values from the input.

Author: Kenneth S. McIntosh
Created: May 11, 2005

History:
    11/02/2005  fernando   Split from _impbln.p so that rcode doesn't depend
                           on audit policy tables when loading audit data - 20051026-060.

*/

/* Define input streams */
{prodict/dump/loadvars.i "SHARED"}

DEFINE INPUT  PARAMETER phBuffer  AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER plOmitLob AS LOGICAL     NO-UNDO.

IF NOT phBuffer:AVAILABLE THEN RETURN ERROR.

CASE phBuffer:NAME:
  WHEN "_aud-audit-policy" THEN DO:
    FIND DICTDB2._aud-audit-policy 
        WHERE ROWID(DICTDB2._aud-audit-policy) = phBuffer:ROWID
        EXCLUSIVE-LOCK NO-ERROR.
    IMPORT STREAM loadPol DICTDB2._aud-audit-policy NO-ERROR.
  END.
  WHEN "_aud-event-policy" THEN DO:
    FIND DICTDB2._aud-event-policy 
        WHERE ROWID(DICTDB2._aud-event-policy) = phBuffer:ROWID
        EXCLUSIVE-LOCK NO-ERROR.
    IMPORT STREAM loadEvtPol DICTDB2._aud-event-policy NO-ERROR.
  END.
  WHEN "_aud-field-policy" THEN DO:
    FIND DICTDB2._aud-field-policy 
        WHERE ROWID(DICTDB2._aud-field-policy) = phBuffer:ROWID
        EXCLUSIVE-LOCK NO-ERROR.
    IMPORT STREAM loadFldPol DICTDB2._aud-field-policy NO-ERROR.
  END.
  WHEN "_aud-file-policy" THEN DO:
    FIND DICTDB2._aud-file-policy 
        WHERE ROWID(DICTDB2._aud-file-policy) = phBuffer:ROWID
        EXCLUSIVE-LOCK NO-ERROR.
    IMPORT STREAM loadFilPol DICTDB2._aud-file-policy NO-ERROR.
  END.
END CASE.

/* return an error if we could not load the record */
IF ERROR-STATUS:ERROR THEN
   RETURN ERROR-STATUS:GET-MESSAGE(1).
ELSE
   RETURN "".

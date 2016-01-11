/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/* prodict/dump/_exptbln.p */

/*
Purpose: Export procedure responsible for executing the actual 
         EXPORT statement on behalf of the secure dump utility 
         (prodict/dump/_dmpsec.p).

Parameters:
  phBuffer     = Handle to the buffer to be dumped.

  plOmitLob    = Logical telling whether to OMIT LOB values from the output.

Author: Kenneth S. McIntosh
Created: May 2, 2005

History:

  fernando     Nov 02,2005  Split file from _exptbln.p, audit policy tables only
                            so that rcode doesn't depend on audit data tables - 20051026-060.
*/

/* Define output streams */
{prodict/dump/dumpvars.i "SHARED" "STREAMS"}

DEFINE INPUT  PARAMETER phBuffer  AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER plOmitLob AS LOGICAL     NO-UNDO.

IF NOT phBuffer:AVAILABLE THEN RETURN ERROR.

CASE phBuffer:NAME:
  WHEN "_aud-audit-policy" THEN DO:
    FIND DICTDB2._aud-audit-policy 
        WHERE ROWID(DICTDB2._aud-audit-policy) = phBuffer:ROWID
        NO-LOCK NO-ERROR.
    EXPORT STREAM dumpPol DICTDB2._aud-audit-policy.
  END.
  WHEN "_aud-event-policy" THEN DO:
    FIND DICTDB2._aud-event-policy 
        WHERE ROWID(DICTDB2._aud-event-policy) = phBuffer:ROWID
        NO-LOCK NO-ERROR.
    EXPORT STREAM dumpEvtPol DICTDB2._aud-event-policy.
  END.
  WHEN "_aud-field-policy" THEN DO:
    FIND DICTDB2._aud-field-policy 
        WHERE ROWID(DICTDB2._aud-field-policy) = phBuffer:ROWID
        NO-LOCK NO-ERROR.
    EXPORT STREAM dumpFldPol DICTDB2._aud-field-policy.
  END.
  WHEN "_aud-file-policy" THEN DO:
    FIND DICTDB2._aud-file-policy 
        WHERE ROWID(DICTDB2._aud-file-policy) = phBuffer:ROWID
        NO-LOCK NO-ERROR.
    EXPORT STREAM dumpFilPol DICTDB2._aud-file-policy.
  END.
END CASE.

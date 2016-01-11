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
  fernando     Nov 02,2005  Split file so that rcode doesn't depend on audit policy
                            tables when loading audit data records - 20051026-060.
  fernando     Nov 10,2005  Adding _db-detail and _client-session   20051110-020                     
*/

/* Define output streams */
{prodict/dump/dumpvars.i "SHARED" "STREAMS"}

DEFINE INPUT  PARAMETER phBuffer  AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER plOmitLob AS LOGICAL     NO-UNDO.

IF NOT phBuffer:AVAILABLE THEN RETURN ERROR.

CASE phBuffer:NAME:
  WHEN "_aud-audit-data-value" THEN DO:
    FIND DICTDB2._aud-audit-data-value 
 
       WHERE ROWID(DICTDB2._aud-audit-data-value) = phBuffer:ROWID
        NO-LOCK NO-ERROR.
    IF plOmitLob THEN
      EXPORT STREAM dumpAudDVal DICTDB2._aud-audit-data-value NO-LOBS.
    ELSE 
      EXPORT STREAM dumpAudDVal DICTDB2._aud-audit-data-value.
  END.
  WHEN "_aud-audit-data" THEN DO:
    FIND DICTDB2._aud-audit-data 
        WHERE ROWID(DICTDB2._aud-audit-data) = phBuffer:ROWID
        NO-LOCK NO-ERROR.
    EXPORT STREAM dumpAudD DICTDB2._aud-audit-data.
  END.
  WHEN "_client-session" THEN DO:
      FIND DICTDB2._client-session 
          WHERE ROWID(DICTDB2._client-session) = phBuffer:ROWID
          NO-LOCK NO-ERROR.
      EXPORT STREAM dumpCliSess DICTDB2._client-session.
  END.
  WHEN "_Db-detail" THEN DO:
      FIND DICTDB2._Db-detail 
          WHERE ROWID(DICTDB2._Db-detail) = phBuffer:ROWID
          NO-LOCK NO-ERROR.
      EXPORT STREAM dumpDbDet DICTDB2._Db-detail.
  END.
END CASE.

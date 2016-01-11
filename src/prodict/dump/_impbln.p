/*************************************************************/
/* Copyright (c) 1984-2006 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/

/* prodict/dump/_impbln.p */

/*
Purpose: Import procedure responsible for executing the actual 
         IMPORT statement on behalf of the secure load utility 
         (prodict/dump/_lodsec.p). 
         
         This is for audit data tables only - for audit policy
         tables, see adecomm/_impblna.p.

Parameters:
  phBuffer     = Handle to the buffer to be loaded.

  plOmitLob    = Logical telling whether to OMIT LOB values from the input.
  
  isTemp       = buffer is for a temp-table, just for _db-detail and _client-session

Author: Kenneth S. McIntosh
Created: May 11, 2005

History:
   11/02/2005  fernando  Split file - moved audit tables to _impblnap.p so
                         that rcode doesn't depend on audit policy tables - 20051026-060.
   11/10/2005  fernando  Adding _db-detail and _client-session 20051110-020                   
   05/02/2006  fernando  Moved code to internal procedure and call this as a persistent procedure
                         so that a new temp-table is not instantiated everytime for each record
                         imported. (20060503-008)
*/

/* Define input streams */
{prodict/dump/loadvars.i "SHARED"}

DEFINE TEMP-TABLE ttDbDet   LIKE DICTDB2._Db-detail.
DEFINE TEMP-TABLE ttCliSess LIKE DICTDB2._Client-session.


PROCEDURE import-data:

DEFINE INPUT  PARAMETER phBuffer  AS HANDLE      NO-UNDO.
DEFINE INPUT  PARAMETER plOmitLob AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER isTemp    AS LOGICAL     NO-UNDO.


IF NOT phBuffer:AVAILABLE THEN RETURN ERROR.

CASE phBuffer:NAME:
  WHEN "_aud-audit-data-value" THEN DO:
    FIND DICTDB2._aud-audit-data-value 
       WHERE ROWID(DICTDB2._aud-audit-data-value) = phBuffer:ROWID
        EXCLUSIVE-LOCK NO-ERROR.
    IF plOmitLob THEN
      IMPORT STREAM loadAudDVal DICTDB2._aud-audit-data-value NO-LOBS NO-ERROR.
    ELSE 
      IMPORT STREAM loadAudDVal DICTDB2._aud-audit-data-value NO-ERROR.
  END.
  WHEN "_aud-audit-data" THEN DO:
    FIND DICTDB2._aud-audit-data 
        WHERE ROWID(DICTDB2._aud-audit-data) = phBuffer:ROWID
        EXCLUSIVE-LOCK NO-ERROR.
    IMPORT STREAM loadAudD DICTDB2._aud-audit-data NO-ERROR.
  END.
  WHEN "_client-session" THEN DO:
    IF isTemp THEN DO:
        CREATE ttCliSess.
        IMPORT STREAM loadCliSess ttCliSess NO-ERROR.
        phBuffer:BUFFER-COPY(BUFFER ttCliSess:HANDLE) NO-ERROR.
        DELETE ttCliSess.
    END.
    ELSE DO:
        FIND DICTDB2._client-session 
            WHERE ROWID(DICTDB2._client-session) = phBuffer:ROWID
            EXCLUSIVE-LOCK NO-ERROR.
        IMPORT STREAM loadCliSess DICTDB2._client-session NO-ERROR.
    END.
  END.
  WHEN "_Db-detail" THEN DO:
    IF isTemp THEN DO:
        CREATE ttDbDet.
        IMPORT STREAM loadDbDet ttDbDet NO-ERROR.
        phBuffer:BUFFER-COPY(BUFFER ttDbDet:HANDLE) NO-ERROR.
        DELETE ttDbDet.
    END.
    ELSE DO:
        FIND DICTDB2._Db-detail 
            WHERE ROWID(DICTDB2._Db-detail) = phBuffer:ROWID
            EXCLUSIVE-LOCK NO-ERROR.
        IMPORT STREAM loadDbDet DICTDB2._Db-detail NO-ERROR.
    END.
  END.

END CASE.

/* return an error if we could not load the record */
IF ERROR-STATUS:ERROR THEN
   RETURN ERROR-STATUS:GET-MESSAGE(1).
ELSE
   RETURN "".

END PROCEDURE.

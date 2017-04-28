/* Copyright © 2006 Progress Software Corporation.  All Rights Reserved. */
/*------------------------------------------------------------------------
    File        : inicfdbsqp.p
    Purpose     : Updates the seq_<DBNAME>_DBVersion sequence for DICTDB

    Author(s)   : pjudge
    Created     : 8/16/2006
    Notes       : - Updates the INITIAL and MAX-VAL fields on the sequence
  ----------------------------------------------------------------------*/
define input parameter pcDbName                as character no-undo.
define input parameter piDbVersion             as integer no-undo.
  
define variable hBuffer                as handle no-undo.
define variable lOk                    as logical no-undo.
define variable cQuery                 as character no-undo.
define variable cSeqName               as character no-undo.

/* Make sure we're connected */
lOk = connected(pcDbName).
if not lOk then
    return error 'Database ' + pcDbName + ' not connected'.
        
/* Create a buffer on the sequence table */
create buffer hBuffer for table pcDbName + '._sequence':u.

/* We're only concerned with the value in the _seq-max field as this
   comes from the delta file. */
cSeqName = "seq_":U + pcDbName + "_DBVersion":U.

/* We need to find a record with the sequence name seq_<dbname>_DBVersion */
cQuery = 'where ':u + pcDbName + '._Sequence._Seq-name = ':u + quoter(cSeqName).
lOk = yes.

do transaction:
    hBuffer:find-first(cQuery, exclusive-lock) no-error.
    if error-status:error or error-status:num-messages gt 0 then
        lOk = no.        
    else
        hBuffer::_seq-max = piDbVersion.
    
    hBuffer:buffer-release().
end.    /* transaction */                    
delete object hBuffer no-error.
hBuffer = ?.

error-status:error = not lOk.
if lOk then    
    return.
else
   return error 'Unable to set sequence ' + cSeqName + ' MAX-VAL in db ' + pcDbname + ' to ' + string(piDbVersion, '999999':u).
 /* - E - O - F - */ 
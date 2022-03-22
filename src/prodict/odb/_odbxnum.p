/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* Get the next available _idx-num. This program is required since we don't
   get a number from the dbmgr like we get from the PROGRESS dbmgr.
*/
DEFINE INPUT PARAMETER file_recid AS RECID NO-UNDO.
DEFINE OUTPUT PARAMETER index-num AS INTEGER NO-UNDO.

index-num = 0.

FOR EACH DICTDB._Index WHERE DICTDB._Index._File-recid = file_recid NO-LOCK:
  IF DICTDB._Index._idx-num <> ? AND DICTDB._Index._idx-num > index-num THEN
    index-num = DICTDB._Index._idx-num.
END.
index-num = index-num + 1.
RETURN.



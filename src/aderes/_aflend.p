/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _aflend.p
*
*    Completes the end of the fastload relationship startup. Updates
*    the permissions and CRCs from the referenced table.
*
*    This function must be called before the call to run the integration
*    point function for table security.
*/

{ aderes/j-define.i }

/* First check to see if there are any aliases */
FIND FIRST qbf-rel-buf WHERE qbf-rel-buf.sid <> ? NO-ERROR.
IF NOT AVAILABLE qbf-rel-buf THEN RETURN.

FOR EACH qbf-rel-buf WHERE qbf-rel-buf.sid <> ?:
  {&FIND_TABLE2_BY_ID} qbf-rel-buf.sid.

  ASSIGN
    qbf-rel-buf.crc    = qbf-rel-buf2.crc
    qbf-rel-buf.cansee = qbf-rel-buf2.cansee
    .
END.

/* _aflend.p - end of file */


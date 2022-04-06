/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* row-get.i - 8/07/96 */
  &IF DEFINED(queryfind) = 0 &THEN   
      RUN send-records IN record-source-hdl
          (INPUT tbl-list, OUTPUT rowid-list) NO-ERROR.
      IF ERROR-STATUS:ERROR THEN RETURN.  /* send-records not defined. */
  &ENDIF

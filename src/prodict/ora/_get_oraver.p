/***********************************************************************
* Copyright (C) 2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/

DEFINE OUTPUT PARAMETER j AS INTEGER NO-UNDO.

DEFINE VARIABLE h         AS INTEGER   NO-UNDO.

ASSIGN j = 0.

RUN STORED-PROC DICTDBG.send-sql-statement
    h = PROC-HANDLE NO-ERROR 
    ("select value from nls_database_parameters where parameter = 'NLS_RDBMS_VERSION' ").

IF NOT ERROR-STATUS:ERROR AND h <> ? THEN DO:
   FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = h:
       j = INTEGER(ENTRY(1,DICTDBG.proc-text-buffer.proc-text,".")).
   END.
   CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = h. 
END.



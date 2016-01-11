/***********************************************************************
* Copyright (C) 2011 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/


{ prodict/ora/oravar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE ora_lang            AS CHARACTER  NO-UNDO.

Assign 
      ora_lang = UPPER( "'" +   ENTRY(1,user_env[41],"_") + "'" ).

DEFINE OUTPUT PARAMETER i AS INTEGER NO-UNDO.
DEFINE VARIABLE h         AS INTEGER   NO-UNDO.




RUN STORED-PROC DICTDBG.send-sql-statement
    h = PROC-HANDLE NO-ERROR 
    (" select  count (*)  from V$NLS_VALID_VALUES where PARAMETER ='SORT' 
    and VALUE  like " + ora_lang ).

IF NOT ERROR-STATUS:ERROR AND h <> ? THEN DO:
   FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = h:
       i = INTEGER(ENTRY(1,proc-text-buffer.proc-text,".")).
   END.
   
   CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = h. 
   
END.

/* Procedure getOwner
   We get called when oracle owner is null, so we check if we are using external
   authentication, in which case we try to get user name from database.
   Fix for OE00170689.
 */

DEFINE OUTPUT PARAMETER  ora_owner AS CHARACTER no-undo INIT ?.
DEFINE VARIABLE h         AS INTEGER   NO-UNDO.

   RUN STORED-PROC DICTDBG.send-sql-statement 
       h = PROC-HANDLE NO-ERROR 
       ("SELECT USER FROM DUAL").

   IF NOT ERROR-STATUS:ERROR AND h <> ? THEN DO: 
     FOR EACH DICTDBG.proc-text-buffer WHERE PROC-HANDLE = h:
           ora_owner = TRIM(proc-text).
     END.

     CLOSE STORED-PROC DICTDBG.send-sql-statement WHERE PROC-HANDLE = h.
   END. 


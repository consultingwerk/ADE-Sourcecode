/*********************************************************************
* Copyright (C) 2000,2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
Created 02/02/00
        Donna McMann copied from prodict/misc/runload.i so that
        Oracle can do bulk inserts during load.  If any changes
        are made in prodict/misc/runload.i they should also be
        evaluated for this procedure.
  
   {1} - Name of the table to load
   {2} - tolerable load rate (%).  
   {3} - set size, status will be displayed after each set
   {4} - either table name or specific field names to load.
   {5} - expected # load records.  If {2} is either 0 or 100%, then
      	 this is ignored.
         
   History
   fernando    06/20/07  Support for large files      
   kmayur      06/21/11  increased extent of user_env - OE00195067
*/
   
/* Will be "y" or "n" to indicate whether to disable triggers or not */
DEFINE INPUT PARAMETER p_Disable AS CHARACTER NO-UNDO.

DEFINE SHARED STREAM   loaderr.
DEFINE SHARED VARIABLE errs    AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE recs    AS INT64. /*UNDO*/
DEFINE SHARED VARIABLE xpos    AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE ypos    AS INTEGER NO-UNDO.

DEFINE        VARIABLE errbyte AS INT64   NO-UNDO.
DEFINE        VARIABLE errline AS INTEGER NO-UNDO.
DEFINE        VARIABLE nxtstop AS INT64   NO-UNDO.
DEFINE        VARIABLE err%    AS INTEGER NO-UNDO.
DEFINE        VARIABLE ans999  AS LOGICAL NO-UNDO.
DEFINE        VARIABLE stopped AS LOGICAL NO-UNDO INIT FALSE.
DEFINE        VARIABLE j       AS INTEGER NO-UNDO.
DEFINE        VARIABLE h1      AS INTEGER NO-UNDO.
DEFINE        VARIABLE h2      AS INTEGER NO-UNDO.
DEFINE        VARIABLE gave-err AS LOGICAL NO-UNDO INITIAL FALSE.

DEFINE SHARED VARIABLE user_env    AS CHARACTER NO-UNDO EXTENT 41.

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
  IF TERMINAL <> "" THEN DO:
    DEFINE STREAM run_load.
    OUTPUT STREAM run_load TO TERMINAL.
  END.
&ENDIF

ASSIGN
  recs = 0
  errs = 0
  err% = {2}.

IF p_Disable  = "y" THEN
  DISABLE TRIGGERS FOR LOAD OF DICTDB2.{1}.

/* Go through all load records.  When IMPORT hits the end of file or 
   ".", ENDKEY will be generated which will kick us out of this "top"
   loop.
*/
top:
DO WHILE TRUE TRANSACTION:
  /* Issue the start command to the DataServer */
  RUN STORED-PROC DICTDBG.send-sql-statement h1 = PROC-HANDLE ("--Bulk-insert Start").
  CLOSE STORED-PROC DICTDBG.send-sql-statement h2 = PROC-STATUS WHERE PROC-HANDLE = h1. 
  ASSIGN nxtstop = recs + {3}.

  /* Go through set of {3} at a time */
  bottom:
  REPEAT FOR DICTDB2.{1}
    WHILE recs < nxtstop ON ENDKEY UNDO,LEAVE BOTTOM:
    IF RETRY THEN DO:
      ASSIGN gave-err = TRUE
             errs = errs + 1.
      IF ERROR-STATUS:NUM-MESSAGES > 0 THEN
      DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
          PUT STREAM loaderr UNFORMATTED
            ">> ERROR READING LINE #" errline 
            " (Offset=" errbyte  "): " ERROR-STATUS:GET-MESSAGE(j) SKIP.
      END.
      ELSE IF p_Disable = "n" THEN
      DO:
         PUT STREAM loaderr UNFORMATTED
	    ">> ERROR READING LINE #" errline
	    " (Offset=" errbyte  "): Unknown error caused by database"
	    " trigger." SKIP.
      END.
      IF (err% = 0) OR
         (err% <> 100 AND errs > ({5} * {2}) / 100) THEN DO:
      	 PUT STREAM loaderr UNFORMATTED
      	    "** Tolerable load error rate is: {2}%." SKIP
      	    "** Loading table {1} is stopped after " errs " error(s)." SKIP.        
         /* DataServer Needs to know that this processing is being aborted */
         RUN STORED-PROC DICTDBG.send-sql-statement h1 = PROC-HANDLE ("--Bulk-insert Abort").
         CLOSE STORED-PROC DICTDBG.send-sql-statement h2 = PROC-STATUS WHERE PROC-HANDLE = h1.                	 
         UNDO TOP, LEAVE TOP.
      END.
      NEXT.
    END.

    CREATE {1}.
    ASSIGN
      errbyte = SEEK(INPUT)
      errline = errline + 1
      recs    = recs + 1.

    IMPORT {4} NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
      IF TERMINAL <> "" AND user_env[6] = "s" THEN DO:
         ASSIGN gave-err = TRUE.
         DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
       	    ans999 = yes.
            MESSAGE ERROR-STATUS:GET-MESSAGE(j) SKIP(1)
      	         "Press OK to continue or Cancel to stop processing."
      	       VIEW-AS ALERT-BOX ERROR BUTTONS OK-CANCEL UPDATE ans999.
            IF NOT ans999 THEN DO:
      	      ASSIGN stopped = TRUE.
              /* User wants to stop so DataServer must be notified of abort */
              RUN STORED-PROC DICTDBG.send-sql-statement h1 = PROC-HANDLE ("--Bulk-insert Abort").
              CLOSE STORED-PROC DICTDBG.send-sql-statement h2 = PROC-STATUS WHERE PROC-HANDLE = h1.               
              UNDO top, LEAVE top.
            END.
      	 END.
      END.
      UNDO bottom, RETRY bottom.
    END.   /* ERROR raised */

    VALIDATE {1} NO-ERROR. 

    IF ERROR-STATUS:ERROR THEN DO:
      IF TERMINAL <> "" AND user_env[6] = "s" THEN DO:
         ASSIGN gave-err = TRUE.
         DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
       	    ans999 = yes.
            MESSAGE ERROR-STATUS:GET-MESSAGE(j) SKIP(1)
      	         "Press OK to continue or Cancel to stop processing."
      	       VIEW-AS ALERT-BOX ERROR BUTTONS OK-CANCEL UPDATE ans999.
            IF NOT ans999 THEN DO:
      	      ASSIGN stopped = TRUE.
              /* User wants to stop so DataServer must be notified of abort */
              RUN STORED-PROC DICTDBG.send-sql-statement h1 = PROC-HANDLE ("--Bulk-insert Abort").
              CLOSE STORED-PROC DICTDBG.send-sql-statement h2 = PROC-STATUS WHERE PROC-HANDLE = h1.               
              MESSAGE "validate error" h2 VIEW-AS ALERT-BOX.
              UNDO top, LEAVE top.
            END.
      	 END.
      END.
      UNDO bottom, RETRY bottom.
    END.   /* ERROR raised */
  END. /* end bottom repeat */
  /* Before transaction is ended, DataServer needs send any leftover records in 
     buffer so Commit will get all records.
  */   
  RUN STORED-PROC DICTDBG.send-sql-statement h1 = PROC-HANDLE ("--Bulk-insert End").
  CLOSE STORED-PROC DICTDBG.send-sql-statement h2 = PROC-STATUS WHERE PROC-HANDLE = h1. 
  /* If an error occurred on final end, make sure the DataServer gets a
     rollback by undoing top and user is notified that a problem occurred
     and all records were rolled back.
  */
  IF h2 <> 0 THEN DO.
     IF NOT gave-err THEN
     MESSAGE "An error was received during the bulk insert for {1}," SKIP
             "all records are being backed out." SKIP
          VIEW-AS ALERT-BOX ERROR.
     ASSIGN gave-err = TRUE.
     UNDO top, LEAVE top. 
  END.
  ELSE 
      LEAVE TOP.
END. /* top */

IF stopped THEN 
    RETURN "stopped".
ELSE 
    RETURN.









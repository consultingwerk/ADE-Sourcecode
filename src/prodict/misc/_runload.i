/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation ("PSC"),       *
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
* The Initial Developer of the Original Code is PSC.  The Original   *
* Code is Progress IDE code released to open source December 1, 2000.*
*                                                                    *
* The contents of this file are subject to the Possenet Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.possenet.org/license.html                               *
*                                                                    *
* Software distributed under the License is distributed on an "AS IS"*
* basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. You*
* should refer to the License for the specific language governing    *
* rights and limitations under the License.                          *
*                                                                    *
* Contributors:                                                      *
*                                                                    *
*********************************************************************/

/*
NOTE:
  Do not change any text in this program.  _dctlrec.p must
  be able to parse the error log this program outputs.
*/
/*
History:
 
  laurief    6/9/98   Added user_env[6] to determine whether load errors
                      are displayed to screen.
  Mario B.  08/04/99  If triggers causes error, output to .e file
                      BUG# 19990803-032
  
   {1} - Name of the table to load
   {2} - tolerable load rate (%).  
   {3} - set size, status will be displayed after each set
   {4} - either table name or specific field names to load.
   {5} - expected # load records.  If {2} is either 0 or 100%, then
      	 this is ignored.
         
  D. McMann  11/19/02  Added check for num-messages after import to catch
                       warning messages.       
  D. McMann  03/06/03  Added support for NO-LOBS in import.
*/
   
/* Will be "y" or "n" to indicate whether to disable triggers or not */
DEFINE INPUT PARAMETER p_Disable AS CHARACTER NO-UNDO.

DEFINE SHARED STREAM   loaderr.
DEFINE SHARED VARIABLE errs    AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE recs    AS INTEGER. /*UNDO*/
DEFINE SHARED VARIABLE xpos    AS INTEGER NO-UNDO.
DEFINE SHARED VARIABLE ypos    AS INTEGER NO-UNDO.

DEFINE        VARIABLE errbyte AS INTEGER NO-UNDO.
DEFINE        VARIABLE errline AS INTEGER NO-UNDO.
DEFINE        VARIABLE nxtstop AS INTEGER NO-UNDO.
DEFINE        VARIABLE err%    AS INTEGER NO-UNDO.
DEFINE        VARIABLE ans999  AS LOGICAL NO-UNDO.
DEFINE        VARIABLE stopped AS LOGICAL NO-UNDO INIT FALSE.
DEFINE        VARIABLE j       AS INTEGER NO-UNDO.

DEFINE SHARED VARIABLE user_env    AS CHARACTER NO-UNDO EXTENT 35.

/* Need a little dialog instead of using PUT SCREEN for GUI because
   here, xpos and ypos will be based on fill-in height whereas frame is
   USE-TEXT so the rows won't line up. 
*/
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

  nxtstop = recs + {3}.

  /* Go through set of {3} at a time */
  bottom:
  REPEAT FOR DICTDB2.{1}
    WHILE recs < nxtstop ON ENDKEY UNDO,LEAVE top:

    IF RETRY THEN DO:
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
      	 RETURN.
      END.
      NEXT.
    END.

    CREATE {1}.
    ASSIGN
      errbyte = SEEK(INPUT)
      errline = errline + 1
      recs    = recs + 1.

    IMPORT {4} {6} NO-ERROR.

    IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
      IF SUBSTRING(ERROR-STATUS:GET-MESSAGE(1), 1, 7) = "WARNING" THEN DO:
        errs = errs + 1.      
        DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
          PUT STREAM loaderr UNFORMATTED
             ERROR-STATUS:GET-MESSAGE(j) SKIP.
        END.
      END.
      ELSE DO: 
       IF TERMINAL <> "" AND user_env[6] = "s" THEN DO:
         DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
       	    ans999 = yes.
            MESSAGE ERROR-STATUS:GET-MESSAGE(j) SKIP(1)
      	         "Press OK to continue or Cancel to stop processing."
      	       VIEW-AS ALERT-BOX ERROR BUTTONS OK-CANCEL UPDATE ans999.
            IF NOT ans999 THEN DO:
      	       stopped = TRUE.
      	       UNDO top, LEAVE top.
            END.
      	 END.
        END.
        UNDO bottom, RETRY bottom.
      END.
    END.   /* ERROR raised */

    VALIDATE {1} NO-ERROR . 

    IF ERROR-STATUS:ERROR OR ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:
      IF TERMINAL <> "" AND user_env[6] = "s" THEN DO:
         DO j = 1 TO  ERROR-STATUS:NUM-MESSAGES:
       	    ans999 = yes.
            MESSAGE ERROR-STATUS:GET-MESSAGE(j) SKIP(1)
      	         "Press OK to continue or Cancel to stop processing."
      	       VIEW-AS ALERT-BOX ERROR BUTTONS OK-CANCEL UPDATE ans999.
            IF NOT ans999 THEN DO:
      	       stopped = TRUE.
      	       UNDO top, LEAVE top.
            END.
      	 END.
      END.
      UNDO bottom, RETRY bottom.
    END.   /* ERROR raised */
  END. /* end bottom repeat */
END. /* top */

IF stopped 
   THEN RETURN "stopped".
   ELSE RETURN.









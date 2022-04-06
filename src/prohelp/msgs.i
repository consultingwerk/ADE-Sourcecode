/*********************************************************************
* Copyright (C) 2000,2011 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/***************************************************************************
Procedure: prohelp/msgs.i

Syntax:

Purpose: Several procedures that manipulate files in the msgdata and indata
	directories that are a part of the messages help.

Description:

Author: Ravi-Chandar Ramalingam

Date Created: 12/28/92, for revision history, see RCS record.
/*
Modified    : 
10/24/11 rkamboj  Replaced " http://www.progress.com/services/techsupport " link 
                      with "http://progresslink.progress.com/supportlink"
*/
***************************************************************************/

/*-----------------------------------------------------------------------------
  PROCEDURE: GetIndataFileName
*/
PROCEDURE GetIndataFileName.
  DEFINE VARIABLE indata-directory AS CHARACTER INITIAL "prohelp/indata/".
  DEFINE OUTPUT PARAMETER indata-file AS CHARACTER.
  DEFINE VARIABLE ops as character initial "unix".

  IF OPSYS = "UNIX" THEN ops = "unix".
  ELSE IF LOOKUP(OPSYS, "MSDOS,OS2,WIN32") > 0 THEN ops = "dos".
  ELSE IF OPSYS = "BTOS" THEN ops = "btos".
  ELSE IF OPSYS = "VMS" THEN ops = "vms".

  indata-file = SEARCH(indata-directory +  ops + "msg").
END PROCEDURE.


/*-----------------------------------------------------------------------------
  PROCEDURE: GetOSMessageDescription
*/
PROCEDURE GetOSMessageDescription.
  DEFINE INPUT PARAMETER msg-num AS INTEGER.
  DEFINE OUTPUT PARAMETER description AS CHARACTER INITIAL ?.
  DEFINE VARIABLE msg-file AS CHARACTER.
  DEFINE VARIABLE i AS INTEGER INITIAL 0.
  DEFINE VARIABLE position AS INTEGER INITIAL 0.
  DEFINE VARIABLE msgnumber AS CHARACTER FORMAT "x(6)".
  DEFINE VARIABLE xtext AS CHARACTER FORMAT "x(78)".
  DEFINE VARIABLE exline AS CHARACTER EXTENT 9 FORMAT "x(78)".
  DEFINE VARIABLE eol AS CHARACTER.

  eol = &IF "{&OPSYS}" = "UNIX" &THEN CHR(10) &ELSE CHR(13) + CHR(10) &ENDIF.

  RUN GetIndataFileName(OUTPUT msg-file).
  IF msg-file <> ? THEN
    DO: /* Process OS Message File */
      INPUT FROM value(msg-file) NO-ECHO.
      position = msg-num - 1.
      /* skip messages until the one that we are interested in */
      DO i = 1 TO position ON ENDKEY UNDO, LEAVE:
        IMPORT  ^.
      END.
      IF i = (position + 1) THEN
        DO:
          IMPORT msgnumber xtext exline ^.
        END.
      INPUT CLOSE.

      IF integer(msgnumber) = msg-num AND xtext <> "Unused" THEN
        DO: /* Process Description */
          i = 1.
          REPEAT:
            IF i <= 9 THEN
              DO:
                IF i = 1 THEN
                  description = exline[i].
                ELSE
                  description = description + eol + exline[i].
                i = i + 1.
              END.
            ELSE
              LEAVE.
          END. /* repeat */

      description = xtext + " (" + msgnumber + ")"
			+ eol + eol + description.
      END. /* Process Description */
    END. /* Process OS Message File */
END PROCEDURE.


/*-----------------------------------------------------------------------------
  PROCEDURE: GetMessageDataFileName
*/
PROCEDURE GetMessageDataFileName.
  DEFINE VARIABLE msgdata-directory AS CHARACTER INITIAL "prohelp/msgdata/msg".
  DEFINE INPUT PARAMETER msg-num AS INTEGER.
  DEFINE OUTPUT PARAMETER msg-file AS CHARACTER.
  DEFINE VARIABLE file-number AS INTEGER.
  DEFINE VARIABLE currentMessage AS INTEGER INITIAL 0.
  file-number = TRUNCATE((msg-num - 1) / 50, 0) + 1.
  msg-file = SEARCH(msgdata-directory + string(file-number)).  
END PROCEDURE. /* GetMessageDataFileName */


/*-----------------------------------------------------------------------------
  PROCEDURE: GetMessageDescription
*/
PROCEDURE GetMessageDescription.
  DEFINE INPUT  PARAMETER msg-num      AS INTEGER.
  DEFINE OUTPUT PARAMETER description  AS CHARACTER INITIAL ?.
  
  DEFINE VARIABLE msg-file       AS CHARACTER.
  DEFINE VARIABLE i              AS INTEGER INITIAL 0.
  DEFINE VARIABLE position       AS INTEGER INITIAL 0.
  DEFINE VARIABLE msgnumber      AS CHARACTER FORMAT "x(6)" NO-UNDO.
  DEFINE VARIABLE xtext          AS CHARACTER FORMAT "x(78)" NO-UNDO.
  DEFINE VARIABLE exline         AS CHARACTER EXTENT 9 FORMAT "x(78)" NO-UNDO.
  DEFINE VARIABLE category       AS CHARACTER FORMAT "xx" NO-UNDO.
  DEFINE VARIABLE category-array AS CHARACTER FORMAT "x(30)" EXTENT 7 NO-UNDO.
  DEFINE VARIABLE category-codes AS CHARACTER.
  DEFINE VARIABLE category-index AS INTEGER.
  DEFINE VARIABLE knowbase       AS CHARACTER FORMAT "X(78)" NO-UNDO.
  DEFINE VARIABLE eol            AS CHARACTER.  
  DEFINE VARIABLE templine       AS CHARACTER.

  eol = CHR(10).

  category-codes = "C,D,I,M,O,P,S".
  category-array[1] = "Compiler".
  category-array[2] = "Database".
  category-array[3] = "Index".
  category-array[4] = "Miscellaneous".
  category-array[5] = "Operating System".
  category-array[6] = "Program/Execution".
  category-array[7] = "Syntax".
  RUN GetMessageDataFileName(msg-num, OUTPUT msg-file).

  IF msg-file <> ? THEN
  DO: /* Process Message File */
    INPUT FROM value(msg-file) NO-ECHO.
    
    ASSIGN position = msg-num
           position = (msg-num MODULO 50) WHEN (msg-num MODULO 50) > 0.
    
    /* skip messages until the one that we are interested in */
    DO i = 1 TO position ON ENDKEY UNDO, LEAVE:
        IMPORT msgnumber xtext exline category knowbase.
        category-index = LOOKUP(category, category-codes).
    END.
    INPUT CLOSE.   

    IF xtext = "" THEN RETURN.

    IF integer(msgnumber) = msg-num AND xtext <> "Reserved for Seq " THEN
    DO: /* Process Description */
      ASSIGN i = 1.
      
      REPEAT:
        IF i <= 9 THEN
          DO:
            IF i = 1 THEN
              description = exline[i].
            ELSE
              description = description + eol + exline[i].
            i = i + 1.
          END.
        ELSE
          LEAVE.
      END. /* repeat */

      IF exline[1] = "syserr" THEN
        description = 
	"An unexpected system error has occurred. Please do the following:"       + eol +
        "1. If the error occurred while running an existing application or"       + eol +
        "   during database admin functions, the error may be due to a"           + eol +
        "   hardware/system problem, r-code corruption, or data corruption."      + eol +
        "   Note what was processing during the time the error occurred."         + eol +
        "   Check your system error logs and Progress database log file for"      + eol +
        "   any additional errors."                                               + eol +
        "2. If the error occurred while running a new application or procedure,"  + eol +
        "   try to reproduce and isolate the code that results in the error."     + eol +
        "3. Search the on-line Progress knowledgebase for information on the"     + eol +
        "   error.  The kbase can be accessed via the Progress web site at:"      + eol +
        "   http://www.progress.com   or"                                         + eol +
      /*  "   http://www.progress.com/services/techsupport/online.html"             + eol + */
        "   http://progresslink.progress.com/supportlink"                         + eol +
        "4. If the above does not lead to resolution, please contact your"        + eol +
        "   dealer (VAR) who sold you PROGRESS, or the Progress Technical"        + eol +
        "   Support center for your region.".

      description = xtext + eol + eol + description.

      /* Category */
      IF category-index <> 0 THEN
	description = description + eol + eol + category-array[category-index].

      /* Knowledge Base */
      IF knowbase <> ? AND knowbase NE "" THEN
        description = description + eol + eol + knowbase + ".".

    END. /* Process Description */
  END. /* Process Message File */
END PROCEDURE.

/*************************************************************/
/* Copyright (c) 1984-2005,2008 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: adecomm/rptvar.i

  Description: Defines and initializes common variables used in audit reports.
               
  Author: Kenneth S. McIntosh

  Created: August 9,2005
  
  History:
     fernando  Dec  23, 2008  Support for Encryption reports
  
------------------------------------------------------------------------*/

&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  &GLOBAL-DEFINE DATA-WIDTH 75
&ELSE 
  &GLOBAL-DEFINE DATA-WIDTH 84
&ENDIF

DEFINE VARIABLE txtReport    AS CHARACTER   NO-UNDO FORMAT "x(50)"
       EXTENT 15 
       INITIAL ["Track Audit Policy Changes",
                "Track Database Schema Changes",
                "Track Audit Data Administration (Dump/Load)",
                "Track Application Data Administration (Dump/Load)",
                "Track User Account Changes",
                "Track Security Permissions Changes",
                "Track SQL Permissions Changes",
                "Track Authentication System Changes",
                "Client Session Authentication Report",
                "Database Administration Report (Utilities)",
                "Database Access Report (Login/Logout/etc...)",
                "Custom Audit Data Filter",
                "Track Encryption Policy Changes",
                "Track Key Store Changes",
                "Database Encryption Administration (Utilities)"].

DEFINE VARIABLE rsDetail     AS LOGICAL     NO-UNDO
                                VIEW-AS RADIO-SET HORIZONTAL
                                RADIO-BUTTONS "Detail", TRUE, "Summary", FALSE
                                INITIAL TRUE.
DEFINE VARIABLE tbAppend     AS LOGICAL     NO-UNDO.
DEFINE VARIABLE fiFileName   AS CHARACTER   NO-UNDO FORMAT "x(50)".
DEFINE VARIABLE cbPrinter    AS CHARACTER   NO-UNDO VIEW-AS COMBO-BOX
                                                    INNER-LINES 5
                                                    SIZE 35 BY 1.
DEFINE VARIABLE cDefaultFile AS CHARACTER   NO-UNDO.

DEFINE VARIABLE fiPgLength   AS INTEGER     NO-UNDO.

CASE piReport:
  WHEN 1  THEN cDefaultFile = "aud_pol".
  WHEN 2  THEN cDefaultFile = "db_schema".
  WHEN 3  THEN cDefaultFile = "aud_data_admin".
  WHEN 4  THEN cDefaultFile = "app_data_admin".
  WHEN 5  THEN cDefaultFile = "user_maint".
  WHEN 6  THEN cDefaultFile = "sec_perm".
  WHEN 7  THEN cDefaultFile = "dba_sql".
  WHEN 8  THEN cDefaultFile = "auth_sys".
  WHEN 9  THEN cDefaultFile = "client_sess".
  WHEN 10 THEN cDefaultFile = "db_util".
  WHEN 11 THEN cDefaultFile = "db_access".
  WHEN 12 THEN cDefaultFile = "cust_audit".
  WHEN 13 THEN cDefaultFile = "enc_pol".
  WHEN 14 THEN cDefaultFile = "enc_keystore".
  WHEN 15 THEN cDefaultFile = "enc_admin".
END CASE.

/*===========================Functions=====================================*/
FUNCTION unquote RETURNS CHARACTER
    ( INPUT pcRawString AS CHARACTER,
      INPUT pcQuoteChar AS CHARACTER ):
  /* Removes extraneous quotes from command-line string */
  DEFINE VARIABLE iChar       AS INTEGER     NO-UNDO.

  DEFINE VARIABLE cTempString AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lNewQuote   AS LOGICAL     NO-UNDO.
  
  IF pcQuoteChar EQ ? OR pcQuoteChar EQ "" THEN
    pcQuoteChar = "~"".

  pcRawString = REPLACE(pcRawString,"~"~"~"~"","~"~"").
  CHAR-BLK:
  DO iChar = 1 TO LENGTH(pcRawString):
    IF iChar = 1 AND
       SUBSTRING(pcRawString,1,1) = pcQuoteChar THEN DO:
      lNewQuote = TRUE.
      NEXT CHAR-BLK.
    END.
    IF SUBSTRING(pcRawString,iChar,1)     EQ pcQuoteChar AND
       (SUBSTRING(pcRawString,iChar + 1,1) NE pcQuoteChar AND
        (iChar > 1 AND 
         SUBSTRING(pcRawString,iChar - 1,1) NE pcQuoteChar)) THEN DO:
      IF NOT lNewQuote THEN DO: 
        lNewQuote = TRUE.
        NEXT CHAR-BLK.
      END.
      ELSE DO:
        lNewQuote = FALSE.
        NEXT CHAR-BLK.
      END.
    END.
    ELSE
      cTempString = cTempString + SUBSTRING(pcRawString,iChar,1).
  END.

  RETURN cTempString.
END FUNCTION.

FUNCTION formatCommandLine RETURNS CHARACTER
    ( INPUT pcCommandLine AS CHARACTER ):

  DEFINE VARIABLE cRunOpt    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cOptions   AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE lNextEntry AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE iOption    AS INTEGER     NO-UNDO.

  cRunOpt = unQuote(pcCommandLine,
                    "~"").
  cOptions = ?.
  IF INDEX(cRunOpt,"-P") > 0 THEN DO:
    DO iOption = 1 TO NUM-ENTRIES(cRunOpt," "):
      IF ENTRY(iOption,cRunOpt," ") EQ "-P" THEN DO:
        lNextEntry = TRUE.
        NEXT.
      END.
      ELSE IF lNextEntry THEN DO:
        cOptions = cOptions + " <password_omitted>". 
        lNextEntry = FALSE.
        NEXT.
      END.
          
      IF cOptions EQ ? THEN
        cOptions = ENTRY(iOption,cRunOpt," ").
      ELSE
        cOptions = cOptions + " " + ENTRY(iOption,cRunOpt," ").
    END.
    cRunOpt = cOptions.
  END.

  RETURN cRunOpt.
END FUNCTION.

FUNCTION padLine RETURNS CHARACTER
    ( INPUT pcLine   AS CHARACTER,
      INPUT piLength AS INTEGER ):
  DEFINE VARIABLE cLine    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE iRepeats AS INTEGER     NO-UNDO.

  iRepeats = TRUNC((piLength - LENGTH(pcLine,"CHARACTER")) / 2,0).
  cLine = FILL(" ",iRepeats) + pcLine. 
  
  RETURN cLine.

END FUNCTION.

FUNCTION truncateLine RETURNS CHARACTER
    ( INPUT-OUTPUT pcLine   AS CHARACTER,
      INPUT        piLength AS INTEGER ):

  DEFINE VARIABLE iNextWord AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iCount    AS INTEGER     NO-UNDO.

  DEFINE VARIABLE cWord     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cLine     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTempLine AS CHARACTER   NO-UNDO.

  cTempLine = pcLine.

  DO iCount = 1 TO NUM-ENTRIES(pcLine," "):
    cWord = ENTRY(iCount,pcLine," ").
    IF (LENGTH(cLine,"CHARACTER") + 
        LENGTH(cWord,"CHARACTER") + 1) >= piLength THEN
      LEAVE.
    cLine     = cLine + (IF cLine NE "" THEN " " ELSE "") + cWord.
    cTempLine = (IF iCount = NUM-ENTRIES(pcLine," ") THEN ""
                 ELSE SUBSTRING(cTempLine,INDEX(cTempLine," ") + 1)).
  END.
  
  pcLine = cTempLine.
  RETURN cLine.
END FUNCTION.

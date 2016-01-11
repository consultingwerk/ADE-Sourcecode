/*************************************************************/  
/* Copyright (c) 1984-2005,2007 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
    File        : _imp-audevent.p
    
    Purpose     : Imports audit events from a .d into a dataset. This is similar
                  to the load .d in the Data Admin tool. One can only load
                  events with event id >= 32000 so we filter other id's out
                  in case they are in the .d file. The rationale is that one
                  will only need to dump/load the application-level events,
                  and not the system ones (provided by Progress).
                  
    Author(s)   : Fernando de Souza
    Created     : Feb 23,2005
    Notes       :        
    
    History:
    fernando    06/20/07   Support for large files

  ----------------------------------------------------------------------*/

/*********************************************************************/
/* local definitions                                                 */
/*********************************************************************/
{auditing/ttdefs/_audeventtt.i}

DEFINE DATASET dsttAuditEvent FOR ttAuditEvent.

DEFINE VARIABLE nErrors   AS INTEGER             NO-UNDO.
DEFINE VARIABLE iRecs     AS INT64               NO-UNDO.
DEFINE VARIABLE code-page AS CHARACTER           NO-UNDO.
DEFINE VARIABLE maptype   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE maxErrors AS INT64               NO-UNDO INIT -1.
DEFINE VARIABLE errorMsg  AS CHARACTER           NO-UNDO.

DEFINE VARIABLE iProcessed AS INT64              NO-UNDO.

/*********************************************************************/
/* parameters                                                        */
/*********************************************************************/
DEFINE INPUT        PARAMETER pcFileName         AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER perror%            AS INTEGER   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET FOR dsttAuditEvent.
DEFINE OUTPUT       PARAMETER pnumRecords        AS INT64     NO-UNDO.


/*********************************************************************/
/* Main block                                                        */
/*********************************************************************/

/* load the trail info so we know how may records there are to import */
RUN auditing/ui/_loadtrail.p (INPUT pcFileName,
                              OUTPUT iRecs,
                              OUTPUT maptype,
                              OUTPUT code-page).

IF RETURN-VALUE <> "":U THEN DO:
    RETURN RETURN-VALUE.
END.

/* figure out the maximum number of errors */
IF iRecs = ? THEN DO:
    /* if .d didn't have number of records, then percentage is the actual
       maximum  number of errors. This is what the Data Admin tool does.
    */
    ASSIGN maxErrors = perror%.
END.
ELSE DO:
    IF perror% = 0 THEN
        ASSIGN maxErrors = 0.
    ELSE IF perror% < 100 THEN
        ASSIGN maxErrors = iRecs * (perror% / 100).
END.

/* now figure out how to read the file */
IF code-page = "":U AND maptype = "NO-MAP":U THEN
   INPUT FROM VALUE(pcFileName) NO-MAP NO-ECHO NO-CONVERT.
ELSE IF code-page = "":U THEN DO:
    INPUT FROM VALUE(pcFileName) MAP VALUE(maptype) NO-ECHO NO-CONVERT.
END.
ELSE IF maptype = "NO-MAP":U THEN DO:
    INPUT FROM VALUE(pcFileName) NO-ECHO NO-MAP  
        CONVERT SOURCE code-page TARGET SESSION:CHARSET.
END.
ELSE DO:
    INPUT FROM VALUE(pcFileName) NO-ECHO MAP VALUE(maptype)
        CONVERT SOURCE code-page TARGET SESSION:CHARSET.
END.

/* turn on tracking changes */
TEMP-TABLE ttAuditEvent:TRACKING-CHANGES = YES.

/* go through the file and import it */
REPEAT TRANSACTION ON ENDKEY UNDO, LEAVE:

    /* keep track of how many records we've processed */
    iProcessed = iProcessed + 1.

    CREATE ttAuditEvent.
    IMPORT ttAuditEvent NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN errorMsg = ERROR-STATUS:GET-MESSAGE (1)
               errorMsg = REPLACE(errorMsg,"ttAuditEvent":U,"Audit Event":U).

        MESSAGE errorMsg VIEW-AS ALERT-BOX ERROR.
        ASSIGN nErrors = nErrors + 1.
        DELETE ttAuditEvent.

        IF maxErrors >= 0 AND nErrors > maxErrors THEN
            LEAVE.
    END.
    ELSE DO:

       /* can't have any event ids less then 32000, so remove any, when we find one */
       IF ttAuditEvent._event-id < 32000 THEN
          DELETE ttAuditEvent.
       ELSE
          pnumRecords = pnumRecords + 1.
    END.

    IF iRecs NE ? AND iProcessed >= iRecs THEN
       LEAVE.  /* loaded them all */
END.

INPUT CLOSE.

/* if number of error was hit, then need to reject all the changes */
IF maxErrors >= 0 THEN DO:
    IF nErrors > maxErrors THEN DO:
        DATASET dsttAuditEvent:REJECT-CHANGES.
        ASSIGN pnumRecords = 0
               TEMP-TABLE ttAuditEvent:TRACKING-CHANGES = NO.
        RETURN "Encountered too many errors while importing file.":U.
    END.
END.

RETURN.

/*************************************************************/
/* Copyright (c) 1984-2006,2008-2010 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------

  File: adecomm/_auddat.p

  Description: This program is the heart of the audit report.  It
               takes a number of input parameters, creates a 
               proDataSet with the expected audit data or client
               authentication data, then generates a file with either
               formatted text or xml. 

  Input Parameters:
      piReport    The specific report that's being run
      pcFileName  Filename to save .xml output to
      pcFilter    Filter Criterea for the selected report
      pcDbName    Logical Name of Database to report against
      plDetail    Display Detail or Summary report
      plReprint   Reuse existing data or generate it from scratch

  Output Parameters:
      <none>

  Author: Kenneth S. McIntosh

  Created: June 9,2005
  History:
      kmcintos Aug 1, 2005   Fixed a number of initial bugs with xml 
                             audit reports.
      kmcintos Aug 17, 2005  Added ELSE condition to userid check for 
                             Database Admin report 20050803-020.
      kmcintos Sep 1, 2005   Changed to use shared buffers for dataset
                             20050901-009.
      kmcintos Sept 19, 2005 Fixed client session buffer name parameter
                             passed to createDataset 20050919-006.
      kmcintos Sept 19, 2005 Added processing for events 10500-10611 
                             20050919-021.
      fernando Oct  31, 2005 Support for auditing streamed mode
      fernando Nov  03, 2005 Support for dump/load audit events                
      kmcintos Jan  03, 2006 Fixed printing bug and reformatted for readability
                             20051116-043.
      fernando Apr  10, 2006 Adjust reports - _event-detail may now be empty 20060404-014
      fernando Sep  21, 2006 Fixing issue with client session report
      fernando Aug  11, 2008 Fixing _Transaction-id format
      fernando Dec  23, 2008 Support for encryption events
      fernando Jun  18, 2009 Support for encryption events
      fernando 01/05/2010    Expanding transaction id format
------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER piReport   AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pcFileName AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcFilter   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pcDbName   AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER plDetail   AS LOGICAL     NO-UNDO.
DEFINE INPUT  PARAMETER plReprint  AS LOGICAL     NO-UNDO.

DEFINE SHARED STREAM reportStream.

DEFINE VARIABLE cLine        AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcDateFormat AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcNumSep     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE gcNumDec     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE i            AS INTEGER     NO-UNDO.

DEFINE VARIABLE ghDDBuff     AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghAEBuff     AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghADBuff     AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghADVBuff    AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghCSBuff     AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghAPBuff     AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghFileBuff   AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghFieldBuff  AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghIndexBuff  AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghSRoleBuff  AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghSGRBuff    AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghUserBuff   AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghAFEBuff    AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghAFIBuff    AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghAEVBuff    AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghFilTrgBuff AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghFldTrgBuff AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghIdxFldBuff AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghSeqBuff    AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghDbOptBuff  AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghDbDtlBuff  AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghSecASBuff  AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghSecADBuff  AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghTabAuth    AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghColAuth    AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghSeqAuth    AS HANDLE      NO-UNDO.
DEFINE VARIABLE ghDbAuth     AS HANDLE      NO-UNDO.
DEFINE VARIABLE cTemp1       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTemp2       AS CHARACTER   NO-UNDO.
DEFINE VARIABLE cTemp3       AS CHARACTER   NO-UNDO.

DEFINE VARIABLE glWriteXml   AS LOGICAL     NO-UNDO.
DEFINE VARIABLE glImmedDisp  AS LOGICAL     NO-UNDO.

ASSIGN gcDateFormat             = SESSION:DATE-FORMAT
       gcNumSep                 = SESSION:NUMERIC-SEPARATOR
       gcNumDec                 = SESSION:NUMERIC-DECIMAL-POINT
       SESSION:DATE-FORMAT      = "mdy"
       SESSION:NUMERIC-FORMAT   = "American"
       glImmedDisp              = SESSION:IMMEDIATE-DISPLAY.

{adecomm/aud-tts.i}
{adecomm/aud-evts.i}
{adecomm/rptvar.i}

/*=================================Forms===================================*/

/* For general long text strings.  line is formatted as appropriate. */
FORM cLine FORMAT "x(90)" NO-LABEL
  WITH FRAME reportLine NO-ATTR-SPACE DOWN WIDTH 90
                        NO-BOX USE-TEXT STREAM-IO.

FORM SKIP(1) WITH FRAME skipFrame NO-ATTR-SPACE DOWN
                                  NO-BOX USE-TEXT STREAM-IO.

FORM SKIP(1)  
     "Working on:"       VIEW-AS TEXT SKIP
     "   "               VIEW-AS TEXT 
     audData._event-name FORMAT "x(45)" 
                         NO-LABEL VIEW-AS TEXT SKIP(1)
  WITH FRAME statusFrame SIDE-LABELS VIEW-AS DIALOG-BOX
                         &IF "{&WINDOW-SYSTEM}" NE "TTY" &THEN 
                           THREE-D &ENDIF
                         TITLE "Generating Report".

FORM SKIP(1) 
     audData._audit-data-guid FORMAT "x(45)" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._transaction-id  FORMAT "->>>>>>>>>9" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._transaction-seq FORMAT ">>>>>ZZZ"
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._audit-date-time FORMAT "99/99/9999 HH:MM:SS AM" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._event-name      FORMAT "x(50)" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._event-type      FORMAT "x(50)" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._db-guid         FORMAT "x(45)" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._db-description  FORMAT "x(50)" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._database-connection-id
                              FORMAT "x(50)" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._client-session-uuid
                              FORMAT "x(50)" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._Audit-data-security-level-name
                              FORMAT "x(50)" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
     audData._data-sealed     FORMAT "x(50)" 
                              COLON 28 
                              VIEW-AS TEXT SKIP
  WITH FRAME summaryFrame SIDE-LABELS STREAM-IO
                          NO-ATTR-SPACE USE-TEXT NO-BOX DOWN.

FORM audDataValue._field-name       COLON 11 SKIP
     audDataValue._data-type-name   COLON 11 SKIP
     audDataValue._old-string-value COLON 11 SKIP
     audDataValue._new-string-value COLON 11 SKIP(1)
    WITH FRAME detailFrame
               SIDE-LABELS STREAM-IO NO-ATTR-SPACE 
               NO-BOX DOWN.

/*===========================Mainline code=================================*/

glWriteXml = INDEX(pcFileName,".xml") > 0.

IF plReprint = FALSE THEN DO:

  DISPLAY "Creating secondary buffers for query..."
          @ audData._event-name
      WITH FRAME statusFrame.
      
  RUN createSecondaryBuffers ( INPUT pcDbName,
                               INPUT piReport ). 

  DISPLAY "Creating dataset..." @ audData._event-name
        WITH FRAME statusFrame.
  RUN buildDataset ( INPUT  piReport,
                     INPUT  pcFileName,
                     INPUT  pcDbName,
                     INPUT  pcFilter,
                     OUTPUT ghDataSet ).

  DISPLAY "Fetching Data..." @ audData._event-name 
      WITH FRAME statusFrame.

  ghDataSet:FILL().

END.
ELSE DO:
    /* check if we have to populate the AudDataValue table, in case we are 
       reprinting with details, and the last time we printed only summary 
       information.
         
       We do add the AudDataValue table to the dataset when printing summary 
       only, so we do read any aud-data-value records related but we do NOT 
       process the data in the _aud-audit-data._Event-detail field (which is 
       the default place for recording the audit data). Now, if we are printing
       details, we have to read ALL the data values to report them, so we need
       to read the _Event-detail, to make sure we display all the correct info.
       
       This is an unusual case (printing summary to screen and then details to 
       a file), but we allow it, and therefore we have to deal with it. This is
       so that we try not to slow down the generation of the report when we are
       only reporting summary information with the time we would spend 
       processing the _Event-detail field and creating AudDataValue records.
    */
    IF ((plDetail OR glWriteXml) /*XML is always detailed */ AND 
        VALID-HANDLE(ghDataSet) AND 
        ghDataSet:PRIVATE-DATA = "no") THEN DO:

        /* remember we are doing detail now */
        ghDataSet:PRIVATE-DATA = "yes".

        /* fill with data from the _event-detail field */
        FOR EACH bAudData NO-LOCK:
            RUN audDataValueFromEventDetail 
                ( INPUT BUFFER bAudData:HANDLE, 
                  INPUT DATASET-HANDLE ghDataSet BY-REFERENCE ).
        END.

    END.

END.

IF glWriteXml THEN DO:
  DISPLAY "Writing XML file..." @ audData._event-name
      WITH FRAME statusFrame.
  ghDataSet:WRITE-XML("FILE",pcFileName,TRUE,"UTF-8",?,TRUE,TRUE).
END.
ELSE DO:
  /* OE00125768 -don't print report if custom report to terminal
     (in which case file name is blank)
  */
  IF NOT (piReport EQ 12 AND pcFileName EQ "") THEN DO:
      DISPLAY "Building report file..." @ audData._event-name
          WITH FRAME statusFrame.
      RUN printReport.
  END.
END.

DISPLAY "Restoring default settings..." @ audData._event-name
    WITH FRAME statusFrame.
    
SESSION:DATE-FORMAT = gcDateFormat.
SESSION:SET-NUMERIC-FORMAT(gcNumSep,gcNumDec).
SESSION:IMMEDIATE-DISPLAY = glImmedDisp.

HIDE FRAME statusFrame.

RETURN "".

/*==========================Internal Procedures==============================*/

PROCEDURE printReport:
  DEFINE VARIABLE cTruncLine   AS CHARACTER   NO-UNDO.
  
  DEFINE VARIABLE iAudDataRecs AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iAudDVRecs   AS INTEGER     NO-UNDO.
  
  DISPLAY STREAM reportStream WITH FRAME skipFrame.
  DISPLAY STREAM reportStream WITH FRAME skipFrame.
  
  cLine = FILL(" ",10) + FILL("*",20) + "Summary Information" +
          FILL("*",20) + FILL(" ",10).

  DISPLAY STREAM reportStream WITH FRAME skipFrame.
  IF NOT plDetail THEN DO:
    DISPLAY STREAM reportStream cLine WITH FRAME reportLine.
    DISPLAY STREAM reportStream WITH FRAME skipFrame.
  END.

  DISPLAY STREAM reportStream WITH FRAME skipFrame.
  /* display records in chronological order and by transaction id in descending order */
  FOR EACH audData NO-LOCK
      BY _audit-date-time DESC
      BY _Transaction-id DESC
      BY _Transaction-sequence DESC:
    DISPLAY "Processing event " + audData._event-name 
            @ audData._event-name
        WITH FRAME statusFrame.
    
    iAudDataRecs = iAudDataRecs + 1.
    
    DISPLAY audData._event-name WITH FRAME statusFrame.

    IF plDetail THEN DO:
      cLine = FILL(" ",10) + FILL("*",20) + "Summary Information" +
              FILL("*",20) + FILL(" ",10).

      DISPLAY STREAM reportStream cLine WITH FRAME reportLine.
      DISPLAY STREAM reportStream WITH FRAME skipFrame.
    END.

    cLine = audData._formatted-event-context.
    cTruncLine = cLine.
    DO WHILE cTruncLine NE "":
      cTruncLine = truncateLine(INPUT-OUTPUT cLine,{&DATA-WIDTH}).
      DISPLAY STREAM reportStream "   " + cTruncLine @ cLine 
          WITH FRAME reportLine.
      IF cTruncLine NE "" THEN
        DOWN STREAM reportStream WITH FRAME reportLine.
    END.
    DISPLAY STREAM reportStream WITH FRAME skipFrame.

    IF plDetail THEN DO:
      cLine = FILL(" ",10) + FILL("*",23) + "Event Details:" +
              FILL("*",22) + FILL(" ",10).
      DISPLAY STREAM reportStream cLine WITH FRAME reportLine.
      DOWN STREAM reportStream WITH FRAME reportLine.

      DISPLAY STREAM reportStream audData._audit-data-guid
                                  audData._transaction-id
                                  audData._transaction-seq
                                  audData._audit-date-time
                                  audData._event-name
                                  audData._event-type
                                  audData._db-guid
                                  audData._db-description
                                  audData._database-connection-id
                                  audData._client-session-uuid
                                  audData._Audit-data-security-level-name
                                  audData._data-sealed
            WITH FRAME summaryFrame.
      
      DISPLAY STREAM reportStream WITH FRAME skipFrame.
      
      IF CAN-FIND(FIRST audDataValue OF audData) THEN DO:
        cLine = FILL(" ",5) + FILL("*",20) + "Changed Fields" + 
                FILL("*",20) + FILL(" ",5).
        DISPLAY STREAM reportStream cLine WITH FRAME reportLine.
        DOWN STREAM reportStream WITH FRAME reportLine.
        DISPLAY STREAM reportStream WITH FRAME skipFrame.
      END.

      FOR EACH audDataValue WHERE audDataValue._audit-data-guid EQ 
                                  audData._audit-data-guid NO-LOCK:
        iAudDVRecs = iAudDVRecs + 1.
        DISPLAY STREAM reportStream audDataValue._field-name
                                    audDataValue._data-type-name
                                    audDataValue._old-string-value
                                    audDataValue._new-string-value
            WITH FRAME detailFrame.
        DISPLAY STREAM reportStream WITH FRAME skipFrame.
      END.
    END. /* If Detail Report */
    cLine = FILL("-",{&DATA-WIDTH}).
    DISPLAY STREAM reportStream cLine WITH FRAME reportLine.
    DOWN STREAM reportStream WITH FRAME reportLine.
    DISPLAY STREAM reportStream WITH FRAME skipFrame.
    
  END. /* FOR EACH audData */
  IF iAudDataRecs > 0 THEN DO:
    cLine = STRING(iAudDataRecs) + " Audit Data records processed".
    DISPLAY STREAM reportStream cLine WITH FRAME reportLine.
    DOWN STREAM reportStream WITH FRAME reportLine.
    cLine = STRING(iAudDVRecs) + " Audit Data Value records processed".
    DISPLAY STREAM reportStream cLine WITH FRAME reportLine.
    DOWN STREAM reportStream WITH FRAME reportLine.
    DISPLAY STREAM reportStream WITH FRAME skipFrame.
  END.
  ELSE DO:
    cLine = "No Audit Data records were found that match your criteria".
    DISPLAY STREAM reportStream cLine WITH FRAME reportLine.
    DOWN STREAM reportStream WITH FRAME reportLine.
  END.
  HIDE FRAME statusFrame.
END PROCEDURE.

PROCEDURE buildDataset:
  DEFINE INPUT  PARAMETER piReport   AS INTEGER     NO-UNDO.
  DEFINE INPUT  PARAMETER pcFileName AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcDbName   AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcFilter   AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT PARAMETER phDataSet  AS HANDLE      NO-UNDO.

  DEFINE VARIABLE lWhere     AS LOGICAL     NO-UNDO.
  DEFINE VARIABLE lAudQry    AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE iEvent     AS INTEGER     NO-UNDO.

  DEFINE VARIABLE cQuery     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cEvent     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cBaseQry   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cEventList AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTblList   AS CHARACTER   NO-UNDO
      INITIAL "bAudData,bAudDataValue".
  DEFINE VARIABLE cTopTbl    AS CHARACTER   NO-UNDO.

  DEFINE VARIABLE hQuery     AS HANDLE      NO-UNDO.
  
  ASSIGN lAudQry    = TRUE.
  CASE piReport:
    WHEN 1 THEN 
      ASSIGN cEventList = "{&AUD_POL_MNT}".
    WHEN 2 THEN 
      ASSIGN cEventList = "{&SCH_CHGS}".
    WHEN 3 THEN
      ASSIGN cEventList = "{&AUD_ARCHV}".
    WHEN 4 THEN
      ASSIGN cEventList = "{&DATA_ADMIN}".
    WHEN 5 THEN
      ASSIGN cEventList = "{&USER_MAINT}".
    WHEN 6 THEN
      ASSIGN cEventList = "{&SEC_PERM_MNT}".
    WHEN 7 THEN
      ASSIGN cEventList = "{&DBA_MAINT}".
    WHEN 8 THEN
      ASSIGN cEventList = "{&AUTH_SYS}".
    WHEN 9 THEN
        ASSIGN lAudQry    = FALSE
               cTblList   = "bClientSess".
    WHEN 10 THEN
      ASSIGN cEventList = "{&DB_ADMIN}".
    WHEN 11 THEN
      ASSIGN cEventList = "{&DB_ACCESS}".
    WHEN 13 THEN
      ASSIGN cEventList = "{&ENC_POL_MNT}".
    WHEN 14 THEN
      ASSIGN cEventList = "{&ENC_KEY_MNT}".
    WHEN 15 THEN
      ASSIGN cEventList = "{&ENC_ADMIN}".
  END CASE.

  cTopTbl   = ENTRY(1,cTblList).

  /* the code below was calling the method on the temp-table handle, but it should
     have been on the buffer-handle of the temp-table. However, table is static, so
     can use the statement instead.
  */
  EMPTY TEMP-TABLE audData NO-ERROR.
  EMPTY TEMP-TABLE audDataValue NO-ERROR.
  EMPTY TEMP-TABLE clientSess NO-ERROR.

  RUN createDataSet ( INPUT  cTblList,
                      INPUT  pcDbName,
                      INPUT  pcFilter,
                      OUTPUT phDataSet ).

  /* If this is one of the 'canned' audit queries, append the list of 
     event-ids to the query */
  IF (lAudQry = TRUE) AND
     (piReport NE 12) THEN DO: 
    /* Get the handle to the top query in the prodataset.  This serves
       the _aud-audit-data table */
    hQuery = phDataSet:GET-BUFFER-HANDLE(cTopTbl):DATA-SOURCE:QUERY.
    cBaseQry = hQuery:PREPARE-STRING.

    cQuery = ENTRY(1,cBaseQry).
    lWhere = (INDEX(cQuery,"WHERE") = 0).

    /* If the _aud-audit-data section of the query contains no 'WHERE', i.e.
       if the user didn't specify any date range criteria, add the 'WHERE' 
       up front */
    IF lWhere THEN
      cQuery = cQuery + " WHERE ".
    ELSE 
      cQuery = cQuery + " AND (".

    DO iEvent = 1 TO NUM-ENTRIES(cEventList):
      cEvent = ENTRY(iEvent,cEventList).
    
      cQuery = cQuery + 
               (IF INDEX(cEvent,"-") > 0 THEN
                  " (_event-id >= " + ENTRY(1,cEvent,"-") + " AND " +
                  "  _event-id <= " + ENTRY(2,cEvent,"-") + ")"
                ELSE 
                  " _event-id = " + cEvent) +
               (IF iEvent LT NUM-ENTRIES(cEventList) THEN 
                  " OR" 
                ELSE 
                  "").
    END.
    IF NOT lWhere THEN cQuery = cQuery + ")".
  
    ENTRY(1,cBaseQry) = cQuery.
    hQuery:QUERY-PREPARE(cBaseQry).
  END.

END PROCEDURE.

PROCEDURE createDataSet:
  DEFINE INPUT  PARAMETER pcTables  AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcDbName  AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER pcFilter  AS CHARACTER   NO-UNDO.
  DEFINE OUTPUT PARAMETER phDataSet AS HANDLE      NO-UNDO.

  DEFINE VARIABLE iTable        AS INTEGER     NO-UNDO.

  DEFINE VARIABLE hDataRelation AS HANDLE      NO-UNDO EXTENT 2.

  /* Individual Temp-Table buffer handles */
  DEFINE VARIABLE htADBuff      AS HANDLE      NO-UNDO.
  DEFINE VARIABLE htADVBuff     AS HANDLE      NO-UNDO.
  DEFINE VARIABLE htCSBuff      AS HANDLE      NO-UNDO.

  /* Individual DB Buffer handles - for the Data-Sources */
  DEFINE VARIABLE hADBuff       AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hCSBuff       AS HANDLE      NO-UNDO EXTENT 3.
  DEFINE VARIABLE hAEBuff       AS HANDLE      NO-UNDO EXTENT 3.
  DEFINE VARIABLE hADVBuff      AS HANDLE      NO-UNDO EXTENT 3.
  DEFINE VARIABLE hDDBuff       AS HANDLE      NO-UNDO EXTENT 3.

  /* Data-Source handles*/
  DEFINE VARIABLE hClientSess   AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hAudData      AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hAudDataVal   AS HANDLE      NO-UNDO.

  DEFINE VARIABLE cTableHdls    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTable        AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTopFilter    AS CHARACTER   NO-UNDO.

  /* Individual Data-Source Query handles */
  DEFINE VARIABLE hCSQuery      AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hADQuery      AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hADVQuery     AS HANDLE      NO-UNDO.

  CREATE DATASET phDataSet IN WIDGET-POOL "datasetPool".
  phDataSet:NAME = "dictRepDataSet".

  /* remember if we are doing detail mode now */
  phDataSet:PRIVATE-DATA = STRING(plDetail).

  DO iTable = 1 TO NUM-ENTRIES(pcTables):
    cTable = ENTRY(iTable,pcTables).
    CASE cTable:
      WHEN "bAudData" THEN DO:
        htADBuff = BUFFER bAudData:HANDLE.
        phDataSet:ADD-BUFFER(htADBuff).

        /* If the query begins with WHERE it came from the custom filter
           in which case it's already formatted */
        IF pcFilter BEGINS "WHERE" OR pcFilter EQ "" THEN
          cTopFilter = " " + pcFilter.
        ELSE
          cTopFilter = (IF pcFilter EQ "All" THEN 
                          "" 
                        ELSE
                          " WHERE (DATE(_aud-audit-data._audit-date-time) >= " +
                          ENTRY(1,pcFilter)                                   + 
                          " AND DATE(_aud-audit-data._audit-date-time) <= "  +
                          ENTRY(2,pcFilter) + ") ").
        
        CREATE DATA-SOURCE hAudData IN WIDGET-POOL "datasetPool".

        CREATE BUFFER hADBuff    FOR TABLE pcDbName + "._aud-audit-data"
                                         IN WIDGET-POOL "datasetPool". 
        CREATE BUFFER hDDBuff[1] FOR TABLE pcDbName + "._db-detail"
                                         IN WIDGET-POOL "datasetPool".
        CREATE BUFFER hCSBuff[1] FOR TABLE pcDbName + "._client-session"
                                         IN WIDGET-POOL "datasetPool".
        CREATE BUFFER hAEBuff[1] FOR TABLE pcDbName + "._aud-event"
                                         IN WIDGET-POOL "datasetPool".

        hAudData:ADD-SOURCE-BUFFER(hADBuff,"_audit-data-guid").
        hAudData:ADD-SOURCE-BUFFER(hDDBuff[1],"_db-guid").
        hAudData:ADD-SOURCE-BUFFER(hCSBuff[1],"_client-session-uuid").
        hAudData:ADD-SOURCE-BUFFER(hAEBuff[1],"_event-id").

        htADBuff:ATTACH-DATA-SOURCE(hAudData,
                                    "_db-detail._db-description,_db-description," +
                                    "_client-session._client-name,_client-name," +
                                    "_aud-event._event-description,_event-description," +
                                    "_aud-event._event-name,_event-name," + 
                                    "_aud-event._event-type,_event-type").
        CREATE QUERY hADQuery IN WIDGET-POOL "datasetPool".
        hADQuery:SET-BUFFERS(hADBuff,
                             hDDBuff[1],
                             hCSBuff[1],
                             hAEBuff[1]).
        hAudData:QUERY = hADQuery.
        hADQuery:PRIVATE-DATA = 
            "FOR EACH _aud-audit-data" + cTopFilter + ", "   +
            "FIRST _db-detail OUTER-JOIN "                   +
            "WHERE _db-detail._db-guid EQ "                  +
            "_aud-audit-data._db-guid, "                     +
            "FIRST _client-session OUTER-JOIN "              + 
            "WHERE _client-session._client-session-uuid EQ " +
            "_aud-audit-data._client-session-uuid, "         +
            "FIRST _aud-event OUTER-JOIN "                   +
            "WHERE _aud-event._event-id EQ "                 +
            "_aud-audit-data._event-id SHARE-LOCK "          +
            "BY _audit-date-time "                           + 
            "BY _transaction-id "                            +
            "BY _transaction-sequence".
        hADQuery:QUERY-PREPARE(hADQuery:PRIVATE-DATA).

        /* Setup Callback Procedures */
        htADBuff:SET-CALLBACK-PROCEDURE("AFTER-ROW-FILL",
                                        "audDataAfterRowFill",
                                        THIS-PROCEDURE).
      END.
      WHEN "bAudDataValue" THEN DO:

        htADVBuff = BUFFER bAudDataValue:HANDLE.
        phDataSet:ADD-BUFFER(htADVBuff).

        IF iTable > 1 THEN DO:
          hDataRelation[1] = phDataSet:ADD-RELATION(htADBuff,htADVBuff,
                                                    "_audit-data-guid,_audit-data-guid").
          hDataRelation[1]:NESTED = TRUE.
        END.

        CREATE DATA-SOURCE hAudDataVal IN WIDGET-POOL "datasetPool".

        CREATE BUFFER hADVBuff[1] FOR TABLE pcDbName + 
                                            "._aud-audit-data-value"
                                            IN WIDGET-POOL "datasetPool".
        hAudDataVal:ADD-SOURCE-BUFFER(hADVBuff[1],"_audit-data-guid").
        htADVBuff:ATTACH-DATA-SOURCE(hAudDataVal).

        CREATE QUERY hADVQuery IN WIDGET-POOL "datasetPool".
        hADVQuery:SET-BUFFERS(hADVBuff[1]).
        hAudDataVal:QUERY = hADVQuery.

        hADVQuery:PRIVATE-DATA = "FOR EACH _aud-audit-data-value SHARE-LOCK " +
                                 "WHERE _aud-audit-data-value._audit-data-guid EQ " +
                                 "bAudData._audit-data-guid".
        hADVQuery:QUERY-PREPARE(hADVQuery:PRIVATE-DATA).

        /* Setup Callback Procedures */
        htADVBuff:SET-CALLBACK-PROCEDURE("AFTER-ROW-FILL",
                                        "audDataValueAfterRowFill",
                                        THIS-PROCEDURE).
      END.
      WHEN "bClientSess" THEN DO:
        htCSBuff = BUFFER bClientSess:HANDLE.
        phDataSet:ADD-BUFFER(htCSBuff).
        
        cTopFilter = (IF pcFilter EQ "All" THEN 
                        "" 
                      ELSE
                        " WHERE (DATE(_client-session._auth-date-time) >= " +
                        ENTRY(1,pcFilter)                                   + 
                        " AND DATE(_client-session._auth-date-time) <= "  +
                        ENTRY(2,pcFilter) + ") ").

        IF iTable > 1 THEN DO:
          hDataRelation[2] = phDataSet:ADD-RELATION(htADBuff,htCSBuff,
                                                    "_client-session-uuid," +
                                                    "_client-session-uuid").
          hDataRelation[2]:NESTED = TRUE.

        END.

        CREATE DATA-SOURCE hClientSess IN WIDGET-POOL "datasetPool".

        CREATE BUFFER hCSBuff[2] FOR TABLE pcDbName + 
                                           "._client-session"
                                           IN WIDGET-POOL "datasetPool".
        CREATE BUFFER hDDBuff[2] FOR TABLE pcDbName + 
                                           "._db-detail"
                                           IN WIDGET-POOL "datasetPool".

        hClientSess:ADD-SOURCE-BUFFER(hCSBuff[2],"_client-session-uuid").
        hClientSess:ADD-SOURCE-BUFFER(hDDBuff[2],"_db-guid").
        htCSBuff:ATTACH-DATA-SOURCE(hClientSess,
                                    "_db-detail._db-description,_db-description").

        CREATE QUERY hCSQuery IN WIDGET-POOL "datasetPool".
        hCSQuery:SET-BUFFERS(hCSBuff[2],
                             hDDBuff[2]).
        hClientSess:QUERY = hCSQuery.

        IF iTable > 1 THEN
          hCSQuery:PRIVATE-DATA = "FOR EACH _client-session " +
                                  "WHERE _client-session._client-session-uuid EQ " +
                                  "bAudData._client-session-uuid, " +
                                  "FIRST _db-detail OUTER-JOIN " +
                                  "WHERE _db-detail._db-guid EQ " +
                                  "_client-session._db-guid " +
                                  "SHARE-LOCK".
        ELSE
          hCSQuery:PRIVATE-DATA = "FOR EACH _client-session SHARE-LOCK " + 
                                  cTopFilter + "," +
                                  "FIRST _db-detail OUTER-JOIN " +
                                  "WHERE _db-detail._db-guid EQ " +
                                  "_client-session._db-guid " +
                                  "SHARE-LOCK".
                                  
        hCSQuery:QUERY-PREPARE(hCSQuery:PRIVATE-DATA).

        /* Setup Callback Procedures */
        htCSBuff:SET-CALLBACK-PROCEDURE("AFTER-ROW-FILL",
                                        "clientSessAfterRowFill",
                                        THIS-PROCEDURE).
      END.
    END CASE.
  END.
END PROCEDURE.

PROCEDURE clientSessAfterRowFill:
  DEFINE INPUT PARAMETER DATASET-HANDLE phDataSet.

  DEFINE VARIABLE hCSBuff    AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hDDBuff    AS HANDLE      NO-UNDO.

  DEFINE VARIABLE iSecLevel  AS INTEGER     NO-UNDO.

  hCSBuff = phDataSet:GET-BUFFER-HANDLE("bClientSess").

  iSecLevel = INTEGER(hCSBuff::_audit-data-security-level).
  
  IF hCSBuff::_db-description EQ ? OR
     hCSBuff::_db-description EQ "" THEN
    hCSBuff::_db-description = "Original database not available".

  CASE iSecLevel:
    WHEN 1 THEN
      hCSBuff::_audit-data-security-level-name = "Message Digest".
    WHEN 2 THEN
      hCSBuff::_audit-data-security-level-name = "DB Passkey".
    OTHERWISE
      hCSBuff::_audit-data-security-level-name = "No Additional Security".
  END CASE.
END PROCEDURE.

PROCEDURE audDataAfterRowFill:
  DEFINE INPUT PARAMETER DATASET-HANDLE phDataSet.

  DEFINE VARIABLE iSecLevel   AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iEntry      AS INTEGER     NO-UNDO.
  
  DEFINE VARIABLE cEventId    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cContext    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cAudTbl     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cGuid       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cAppTbl     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cAppFld     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cEvtId      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cPolName    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRunOpt     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cCommand    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cEntity     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cToEntity   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cUser       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cVerb       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cOwner      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cEvent      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cIndex      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRole       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cRoleDesc   AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cGrantee    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cGrantor    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cSeqName    AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cUserId     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cTable      AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cPerm       AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cOption     AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE cType       AS CHARACTER   NO-UNDO.
  
  DEFINE VARIABLE hADBuff     AS HANDLE      NO-UNDO.
  DEFINE VARIABLE hDBBuff     AS HANDLE      NO-UNDO.
  
  DEFINE VARIABLE lPolName    AS LOGICAL     NO-UNDO.

  hADBuff = phDataSet:GET-BUFFER-HANDLE("bAudData").
  hDBBuff = hADBuff:DATA-SOURCE:GET-SOURCE-BUFFER(1).

  iSecLevel = INTEGER(hADBuff::_audit-data-security-level).
  
  CASE iSecLevel:
    WHEN 1 THEN
      hADBuff::_audit-data-security-level-name = "Message Digest".
    WHEN 2 THEN
      hADBuff::_audit-data-security-level-name = "DB Passkey".
    OTHERWISE
      hADBuff::_audit-data-security-level-name = "No Additional Security".
  END CASE.

  hADBuff::_data-sealed = (hDBBuff::_data-seal NE "" AND 
                           hDBBuff::_data-seal NE ?).
     
  /* Need to find the context and event group records and populate the
     fields for these. These are recursive joins back on the same table */

  /* read context if any exists */
  IF hADBuff::_Application-context-id <> "" THEN DO:
    ghADBuff:FIND-FIRST("WHERE _audit-data-guid = ~'" +
                        hADBuff::_Application-context-id + "~'",
                        NO-LOCK) NO-ERROR.
    IF ghADBuff:AVAILABLE THEN
      hADBuff::_application-context-summary = ghADBuff::_Event-context.
  END.

  /* read audit event group if any exists */
  IF hADBuff::_audit-event-group <> "" THEN DO:
    ghADBuff:FIND-FIRST("WHERE _audit-data-guid = ~'" +
                          hADBuff::_audit-event-group + "~'",
                        NO-LOCK) NO-ERROR.
    IF ghADBuff:AVAILABLE THEN
      hADBuff::_audit-event-group-name = ghADBuff::_Event-context.
  END.

  /* Need to nicely re-format event context for more meaningful display
     on a report this is just a sample - custom code is required to handle
     the various known context formats */
  ASSIGN cEventId = STRING(hADBuff::_event-id)
         cUserId  = (IF hADBuff::_user-id NE "" AND 
                         hADBuff::_user-id NE ? THEN 
                        " by " + hADBuff::_user-id ELSE "").

  /* these may error out */
  ASSIGN cContext = ENTRY(2,hADBuff::_event-context,CHR(6))
         cTable   = ENTRY(1,hADBuff::_Event-context,CHR(6)) NO-ERROR.

  /* Default to same as unformatted event context for cases where hit
     an unknown format */
  CASE cEventId:
    WHEN "100" THEN DO: /* _user create */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.
        ghUserBuff:FIND-BY-ROWID(TO-ROWID(cContext),
                                 NO-LOCK) NO-ERROR.
        IF ghUserBuff:AVAILABLE THEN
          cContext = " for " + ghUserBuff::_userid.
        ELSE cContext = "".
      END.
      ELSE cContext = "".

      hADBuff::_formatted-event-context = 
            "New User Record created" + cContext + cUserId.
    END.
    WHEN "101" THEN /* _user update */
      hADBuff::_formatted-event-context = 
            "User account for " + cContext +
            " modified" + cUserId NO-ERROR.
    WHEN "102" THEN /* _user delete */
      hADBuff::_formatted-event-context = 
            "User " + cContext +
            " deleted" + cUserId NO-ERROR.
    WHEN "210" THEN /* sql grant dba */
      hADBuff::_formatted-event-context = 
            "SQL user " + cContext +
            " granted DBA" + cUserId NO-ERROR.
    WHEN "211" THEN /* sql dba updated */
      hADBuff::_formatted-event-context = 
            "SQL user " + cContext +
            "'s DBA permissions modified" + cUserId NO-ERROR.
    WHEN "212" THEN /* sql revoke dba */
      hADBuff::_formatted-event-context = 
            "SQL user " + cContext +
            "'s DBA permissions revoked" + cUserId NO-ERROR.
    WHEN "300" THEN DO: /* Audit policy create _aud-audit-policy or
                                               _aud-file-policy  or
                                               _aud-field-policy or
                                               _aud-event-policy record */
      cTable = ENTRY(NUM-ENTRIES(cTable,"."),cTable,".").
      CASE cTable:
        WHEN "_aud-audit-policy"  THEN DO: /* Create Audit Policy */
          cAudTbl = "Audit Policy".
          IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
            cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.
            
            ghAPBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
            IF ghAPBuff:AVAILABLE THEN
              cContext = " ~"" + ghAPBuff::_audit-policy-name + "~" ".
            ELSE cContext = " record ".
          END.
          ELSE cContext = " record ".
        END. /* Create Audit Policy */
        WHEN "_aud-file-policy" THEN DO: /* Create Table Policy */
          cAudTbl = "Table Policy".
          IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
            cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.
            
            ghAFIBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
            IF ghAFIBuff:AVAILABLE THEN DO:
              cContext = " for table ~"" + ghAFIBuff::_owner + "." +
                         ghAFIBuff::_file-name + "~" ".
              ghAPBuff:FIND-FIRST("WHERE _audit-policy-guid EQ ~'" +
                                  ghAFIBuff::_audit-policy-guid + "~'",
                                  NO-LOCK) NO-ERROR.
              IF ghAPBuff:AVAILABLE THEN
                cPolName = ", in policy ~"" + ghAPBuff::_audit-policy-name + 
                           "~"" + (IF cUserId NE "" THEN ", " ELSE " ").
              ELSE cPolName = " (Audit Policy GUID=~"" + 
                              ghAFIBuff::_audit-policy-guid + "~") ".
            END.
            ELSE cContext = " record ".
          END.
          ELSE cContext = " record ".
        END. /* Create Table Policy */
        WHEN "_aud-field-policy" THEN DO:  /* Create Field Policy */
          cAudTbl = "Field Policy".
          IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
            cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.
            
            ghAFEBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
            IF ghAFEBuff:AVAILABLE THEN DO:
              cContext = " for field ~"" + ghAFEBuff::_file-name + "." +
                         ghAFEBuff::_field-name + "~" ".
              ghAPBuff:FIND-FIRST("WHERE _audit-policy-guid EQ ~'" +
                                  ghAFEBuff::_audit-policy-guid + "~'",
                                  NO-LOCK) NO-ERROR.
              IF ghAPBuff:AVAILABLE THEN
                cPolName = ", in policy ~"" + 
                           ghAPBuff::_audit-policy-name + "~"" +
                           (IF cUserId NE "" THEN ", " ELSE " ").
              ELSE cPolName = " (Audit Policy GUID=~"" + 
                              ghAFEBuff::_audit-policy-guid + "~") ".
            END.
            ELSE cContext = " record ".
          END.
          ELSE cContext = " record ".
        END.  /* Create Field Policy */
        WHEN "_aud-event-policy" THEN DO:  /* Create Event Policy */
          cAudTbl = "Event Policy".
          IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
            cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.
            
            ghAEVBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
            IF ghAEVBuff:AVAILABLE THEN DO:
              ghAEBuff:FIND-FIRST("WHERE _event-id EQ " + 
                                  STRING(ghAEVBuff::_event-id),
                                  NO-LOCK) NO-ERROR.
              IF ghAEBuff:AVAILABLE THEN
                cEvent = ghAEBuff::_event-name.
              ELSE cEvent = STRING(ghAEVBuff::_event-id).

              cContext = " for event ~"" + cEvent + "~" ".
              ghAPBuff:FIND-FIRST("WHERE _audit-policy-guid EQ ~'" +
                                  ghAFEBuff::_audit-policy-guid + "~'",
                                  NO-LOCK) NO-ERROR.
              IF ghAPBuff:AVAILABLE THEN
                cPolName = ", in policy ~"" + 
                           ghAPBuff::_audit-policy-name + "~"" +
                           (IF cUserId NE "" THEN ", " ELSE " ").
              ELSE cPolName = " (Audit Policy GUID=~"" + 
                              ghAFIBuff::_audit-policy-guid + "~") ".
            END.
            ELSE cContext = " record ".
          END.
          ELSE cContext = " record ".
        END.  /* Create Event Policy */
      END CASE.
        
      hADBuff::_formatted-event-context = 
          cAudTbl + cContext + "created" + cPolName + cUserId.
    END. /* Audit policy table create events */
    WHEN "301" THEN DO: /* Modify record in audit policy type table */
      cTable = ENTRY(NUM-ENTRIES(cTable,"."),cTable,".").

      CASE cTable:
        WHEN "_aud-audit-policy" THEN DO: /* Modify Audit Policy */
          cPolName = ENTRY(1,cContext,CHR(7)) NO-ERROR.
          cContext = "Audit Policy ~"" + cPolName + "~" modified".
        END. /* Modify Audit Policy */
        WHEN "_aud-file-policy" THEN DO: /* Modify File Policy */
          ASSIGN cAppTbl  = ENTRY(3,cContext,CHR(7)) + "." + 
                            ENTRY(2,cContext,CHR(7))
                 cGuid = ENTRY(1,cContext,CHR(7)) NO-ERROR.

          ghAPBuff:FIND-FIRST("WHERE _audit-policy-guid = ~'" +
                              cGuid + "~'",NO-LOCK) NO-ERROR.
          IF ghAPBuff:AVAILABLE THEN
            cPolName = ", in policy ~"" + 
                       ghAPBuff::_audit-policy-name + "~", ".
          ELSE cPolName = " (Audit Policy GUID=~"" + cGuid + "~") ".

          cContext = "Table Policy for ~"" + cAppTbl + "~"" + 
                     cPolName + "modified".
        END. /* Modify File Policy */
        WHEN "_aud-field-policy" THEN DO:  /* Modify Field Policy */
          ASSIGN cAppTbl  = ENTRY(3,cContext,CHR(7)) + "." + 
                            ENTRY(2,cContext,CHR(7))
                 cAppFld  = ENTRY(4,cContext,CHR(7))
                 cGuid = ENTRY(1,cContext,CHR(7)) NO-ERROR.

          ghAPBuff:FIND-FIRST("WHERE _audit-policy-guid = ~'" +
                              cGuid + "~'",NO-LOCK) NO-ERROR.
          IF ghAPBuff:AVAILABLE THEN
            cPolName = ", in policy ~"" + 
                       ghAPBuff::_audit-policy-name + "~", ".
          ELSE cPolName = " (Audit Policy GUID=~"" + cGuid + "~") ".

          cContext = "Field Policy for ~"" + cAppTbl + "." + 
                     cAppFld + "~"" + cPolName + "modified".
        END.  /* Modify Field Policy */
        WHEN "_aud-event-policy" THEN DO: /* Modify Event Policy */
          ASSIGN cGuid    = ENTRY(1,cContext,CHR(7))
                 cEventId = ENTRY(2,cContext,CHR(7)) NO-ERROR.

          ghAEBuff:FIND-FIRST("WHERE _event-id = " + cEventId,
                              NO-LOCK) NO-ERROR.
          ghAPBuff:FIND-FIRST("WHERE _audit-policy-guid = ~'" +
                              cGuid + "~'",NO-LOCK) NO-ERROR.

          IF ghAPBuff:AVAILABLE THEN
            cPolName = ", in policy ~"" + 
                       ghAPBuff::_audit-policy-name + "~", ".
          ELSE cPolName = " (Audit Policy GUID=~"" + cGuid + "~") ".

          cContext = "Event Policy for audit event ~"" +
                     (IF ghAEBuff:AVAILABLE THEN ghAEBuff::_event-name
                      ELSE cEventId) + "~"" + cPolName + "modified".
        END. /* Modify Event Policy */
      END CASE.

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Modify record in audit policy type table */
    WHEN "302" THEN DO: /* Delete record from audit policy type table */
      cTable = ENTRY(NUM-ENTRIES(cTable,"."),cTable,".").

      CASE cTable:
        WHEN "_aud-audit-policy" THEN /* Delete Audit Policy */
          cContext = "Audit Policy ~"" + ENTRY(1,cContext,CHR(7)) +
                     "~" deleted".
        WHEN "_aud-file-policy" THEN DO: /* Delete File Policy */
          ASSIGN cAppTbl  = ENTRY(3,cContext,CHR(7)) + "." + 
                            ENTRY(2,cContext,CHR(7))
                 cGuid = ENTRY(1,cContext,CHR(7)).

          ghAPBuff:FIND-FIRST("WHERE _audit-policy-guid = ~'" +
                              cGuid + "~'",NO-LOCK) NO-ERROR.
          IF ghAPBuff:AVAILABLE THEN
            ASSIGN lPolName = TRUE 
                   cPolName = " from policy ~"" + 
                              ghAPBuff::_audit-policy-name + "~"".
          ELSE cPolName = " (Audit Policy GUID=~"" + cGuid + "~")".

          cContext = "Table Policy for ~"" + cAppTbl + "~"" + 
                     (IF NOT lPolName THEN cPolName ELSE "" ) + " deleted".
        END. /* Delete File Policy */
        WHEN "_aud-field-policy" THEN DO: /* Delete Field Policy */
          ASSIGN cAppTbl  = ENTRY(3,cContext,CHR(7)) + "." + 
                            ENTRY(2,cContext,CHR(7))
                 cAppFld  = ENTRY(4,cContext,CHR(7))
                 cGuid    = ENTRY(1,cContext,CHR(7)) NO-ERROR.

          ghAPBuff:FIND-FIRST("WHERE _audit-policy-guid = ~'" +
                              cGuid + "~'",NO-LOCK) NO-ERROR.
          IF ghAPBuff:AVAILABLE THEN
            ASSIGN lPolName = TRUE 
                   cPolName = " from policy ~"" + 
                              ghAPBuff::_audit-policy-name + "~"".
          ELSE cPolName = " (Audit Policy GUID=~"" + cGuid + "~")".

          cContext = "Field Policy for ~"" + cAppTbl + "." +
                     cAppFld + "~"" + 
                     (IF NOT lPolName THEN cPolName ELSE "" ) + " deleted".
        END. /* Delete Field Policy */
        WHEN "_aud-event-policy" THEN DO: /* Delete Event Policy */
          ASSIGN cGuid = ENTRY(1,cContext,CHR(7))
                 cEventId = ENTRY(2,cContext,CHR(7)) NO-ERROR.

          ghAEBuff:FIND-FIRST("WHERE _event-id = " + cEventId,
                              NO-LOCK) NO-ERROR.
          ghAPBuff:FIND-FIRST("WHERE _audit-policy-guid = ~'" +
                              cGuid + "~'",NO-LOCK) NO-ERROR.

          IF ghAPBuff:AVAILABLE THEN
            ASSIGN lPolName = TRUE 
                   cPolName = " from policy ~"" + 
                              ghAPBuff::_audit-policy-name + "~"".
          ELSE cPolName = " (Audit Policy GUID=~"" + cGuid + "~")".

          cContext = "Event Policy for audit event ~"" +
                     (IF ghAEBuff:AVAILABLE THEN ghAEBuff::_event-name
                      ELSE cEventId) + "~"" + 
                     (IF NOT lPolName THEN cPolName ELSE "" ) + " deleted".
        END.  /* Delete Event Policy */
      END CASE.

      hADBuff::_formatted-event-context = 
          cContext + (IF lPolName THEN cPolName ELSE "" ) + cUserId.
    END. /* Delete record from audit policy type table */
    WHEN "400" THEN DO: /* SQL Table Privilege Created */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.
         
        ghTabAuth:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghTabAuth:AVAILABLE THEN
          cContext = " granted to " + ghTabAuth::_grantee + 
                     " for table " + ghTabAuth::_tblowner + "." +
                     ghTabAuth::_tbl + 
                     (IF ghTabAuth::_grantor > "" THEN 
                        " by " + ghTabAuth::_grantor 
                      ELSE cUserId).
      END.
      ELSE cContext = " created" + cUserId.

      hADBuff::_formatted-event-context = 
           "SQL Table privilege" + cContext.
    END.
    WHEN "401" THEN DO: /* SQL Table Privilege Modified */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7)) + "." +
                          ENTRY(2,cContext,CHR(7))
               cGrantee = ENTRY(3,cContext,CHR(7)) NO-ERROR.

        cContext = cGrantee + "~'s SQL Table privilege, for table " +
                   cAppTbl + ", modified".
      END.
      ELSE cContext = "SQL Table privilege modified".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END.
    WHEN "402" THEN DO: /* SQL Table Privilege Deleted */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7)) + "." +
                          ENTRY(2,cContext,CHR(7))
               cGrantee = ENTRY(3,cContext,CHR(7)) NO-ERROR.
        
        cContext = cGrantee + "~'s SQL Table privilege, for table " +
                   cAppTbl + ", revoked".
      END.
      ELSE cContext = "SQL Table privilege revoked".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END.
    WHEN "410" THEN DO: /* SQL Column Privilege Created */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.
         
        ghColAuth:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghColAuth:AVAILABLE THEN
          cContext = " granted to " + ghColAuth::_grantee + 
                     " for column " + ghColAuth::_tblowner + "." +
                     ghColAuth::_tbl + "." + ghColAuth::_col +
                     (IF ghColAuth::_grantor > "" THEN 
                        " by " + ghColAuth::_grantor 
                      ELSE cUserId).
      END.
      ELSE cContext = " created" + cUserId.

      hADBuff::_formatted-event-context = 
           "SQL Column privilege" + cContext. 
    END.
    WHEN "411" THEN DO: /* SQL Column Privilege Modified */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        ASSIGN cAppFld  = ENTRY(1,cContext,CHR(7)) + "." +
                          ENTRY(2,cContext,CHR(7)) + "." +
                          ENTRY(3,cContext,CHR(7))
               cGrantee = ENTRY(4,cContext,CHR(7)) NO-ERROR.

        cContext = cGrantee + "~'s SQL Column privilege, for column " +
                   cAppFld + ", modified".
      END.
      ELSE cContext = "SQL Column privilege modified".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END.
    WHEN "412" THEN DO: /* SQL Column Privilege Deleted */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        ASSIGN cAppFld  = ENTRY(1,cContext,CHR(7)) + "." +
                          ENTRY(2,cContext,CHR(7)) + "." + 
                          ENTRY(3,cContext,CHR(7))
               cGrantee = ENTRY(4,cContext,CHR(7)) NO-ERROR.
        
        cContext = cGrantee + "~'s SQL Column privilege, for column " +
                   cAppFld + ", revoked".
      END.
      ELSE cContext = "SQL Column privilege revoked".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END.
    WHEN "420" THEN DO: /* SQL Sequence Privilege Created */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.
         
        ghSeqAuth:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghSeqAuth:AVAILABLE THEN
          cContext = " granted to " + ghSeqAuth::_grantee + 
                     " for sequence " + ghSeqAuth::_Seqowner + "." +
                     ghSeqAuth::_seq-name +
                     (IF ghSeqAuth::_grantor > "" THEN 
                        " by " + ghSeqAuth::_grantor 
                      ELSE cUserId).
      END.
      ELSE cContext = " created" + cUserId.

      hADBuff::_formatted-event-context = 
           "SQL Sequence privilege" + cContext. 
    END.
    WHEN "421" THEN DO: /* SQL Sequence Privilege Modified */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        ASSIGN cSeqName = ENTRY(1,cContext,CHR(7)) + "." +
                          ENTRY(2,cContext,CHR(7)) + "."
               cGrantee = ENTRY(3,cContext,CHR(7)) NO-ERROR.

        cContext = cGrantee + "~'s SQL Sequence privilege, for sequence " +
                   cSeqName + ", modified".
      END.
      ELSE cContext = "SQL Sequence privilege modified".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END.
    WHEN "422" THEN /* SQL Sequence Privilege Deleted */
      hADBuff::_formatted-event-context = hADBuff::_event-context.
    WHEN "500" THEN DO: /* Create _sec-authentication-system */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:

        cContext = ENTRY(1,cContext,CHR(7)).
        ghSecASBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghSecASBuff:AVAILABLE THEN
          cContext = "Security Authentication System, with Domain Type ~"" +
                     ghSecASBuff::_domain-type + "~:, created".
        ELSE cContext = "Security Authentication System created".
      END.
      ELSE cContext = "Security Authentication System created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Create _sec-authentication-system */
    WHEN "501" THEN DO: /* Update _sec-authentication-system */
      cContext = "Security Authentication System " +
                 cContext + " has been modified".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Update _sec-authentication-system */
    WHEN "502" THEN DO: /* Delete _sec-authentication-system */
      cContext = "Security Authentication System " +
                 cContext + " has been deleted".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END.
    WHEN "505" THEN DO: /* Create _sec-authentication-domain */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)).
        ghSecADBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghSecADBuff:AVAILABLE THEN
          cContext = "Security Authentication Domain " +
                     ghSecADBuff::_domain-name + " created".
        ELSE cContext = "Security Authentication Domain created".
      END.
      ELSE cContext = "Security Authentication Domain created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Create _sec-authentication-domain */
    WHEN "506" THEN DO: /* Update _sec-authentication-domain */
      cContext = "Security Authentication Domain " +
                 cContext + " has been modified".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Update _sec-authentication-domain */
    WHEN "507" THEN DO: /* Delete _sec-authentication-domain */
      cContext = "Security Authentication Domain " +
                 cContext + " has been deleted".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Delete _sec-authentication-domain */
    WHEN "510" THEN DO: /* Create security role record 
                           (_sec-role) Not Implemented */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.

        ghSRoleBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghSRoleBuff:AVAILABLE THEN
          cContext = "New Security Role ~"" + ghSRoleBuff::_role-description +
                     "~" (" + ghSRoleBuff::_role-name + ") created".
        ELSE cContext = "New Security Role Created".
      END.
      ELSE cContext = "New Security Role Created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Create security role record */
    WHEN "511" THEN DO: /* Update security role record 
                           (_sec-role) Not Implemented */
      cRole = cContext NO-ERROR.
             
      ghSRoleBuff:FIND-FIRST("WHERE _role-name = ~"" +
                             cRole + "~"",NO-LOCK) NO-ERROR.
      IF ghSRoleBuff:AVAILABLE THEN
        cRoleDesc = "~"" + ghSRoleBuff::_role-description + 
                    "~" (" + cRole + ") ".
      ELSE 
        cRoleDesc = "~"" + cRole + "~"".
        
      hADBuff::_formatted-event-context = 
          "Role " + cRoleDesc + " modified" + cUserId.
    END. /* Update security role record */
    WHEN "512" THEN DO: /* Delete security role record 
                           (_sec-role) Not Implemented */
      hADBuff::_formatted-event-context = 
        "Role ~"" + cRole + "~" " + "deleted" + cUserId.
    END. /* Delete security role record */
    WHEN "515" THEN DO: /* Create security permissions record 
                           (_sec-granted-role) */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.

        ghSGRBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghSGRBuff:AVAILABLE THEN DO:
          ghSRoleBuff:FIND-FIRST("WHERE _role-name EQ ~"" +
                                 ghSGRBuff::_role-name + "~"",NO-LOCK) NO-ERROR.
          IF ghSRoleBuff:AVAILABLE THEN
            cPerm = ghSRoleBuff::_role-description + " (" + 
                    ghSRoleBuff::_role-name + ")".
          ELSE cPerm = ghSGRBuff::_role-name.

          cContext = cPerm + " granted to " + ghSGRBuff::_grantee + 
                     " by " + ghSGRBuff::_grantor.
        END.
        ELSE cContext = "New permission record created" + cUserId.
      END.
      ELSE cContext = "New permission record created" + cUserId.
      hADBuff::_formatted-event-context = cContext.
    END. /* Create security permissions record  */
    WHEN "516" THEN DO: /* Update security permissions record 
                           (_sec-granted-role) */
      ASSIGN cRole    = ENTRY(1,cContext,CHR(7))
             cGrantee = ENTRY(2,cContext,CHR(7))
             cGrantor = ENTRY(3,cContext,CHR(7)) NO-ERROR.
             
      ghSRoleBuff:FIND-FIRST("WHERE _role-name = ~'" +
                             cRole + "~'",NO-LOCK) NO-ERROR.
      IF ghSRoleBuff:AVAILABLE THEN
        cRoleDesc = "~"" + ghSRoleBuff::_role-description + 
                    "~" (" + cRole + ") ".
      ELSE cRole.

      hADBuff::_formatted-event-context = 
          cGrantee + "~'s " + cRoleDesc + 
          " permission (Granted by: " + cGrantor + 
          ") has been modified" + cUserId.
    END. /* Update security permissions record */
    WHEN "517" THEN DO: /* Delete security permissions record 
                           (_sec-granted-role) */
      ASSIGN cRole    = ENTRY(1,cContext,CHR(7))
             cGrantee = ENTRY(2,cContext,CHR(7))
             cGrantor = ENTRY(3,cContext,CHR(7)) NO-ERROR.
             
      ghSRoleBuff:FIND-FIRST("WHERE _role-name = ~'" +
                             cRole + "~'",NO-LOCK) NO-ERROR.
      IF ghSRoleBuff:AVAILABLE THEN
        cRoleDesc = "~"" + ghSRoleBuff::_role-description + 
                    "~" (" + cRole + ") ".
      ELSE cRole.

      hADBuff::_formatted-event-context = 
          cGrantee + "~'s " + cRoleDesc + 
          " permission (Granted by: " + cGrantor + 
          ") has been revoked" + cUserId.
    END. /* Delete security permissions record */
    WHEN "5000" THEN DO: /* Schema - Create DB Table */
      cOwner   = ENTRY(2,cContext,CHR(7)) NO-ERROR.
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.
        
        ghFileBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghFileBuff:AVAILABLE THEN
          cContext = "Table " + ghFileBuff::_owner + "." +
                     ghFileBuff::_file-name + " created".
        ELSE cContext = "New table created".
      END.
      ELSE cContext = "New table created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Create DB Table */
    WHEN "5001" THEN DO: /* Schema - Create Table Trigger */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.

        ghFilTrgBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghFilTrgBuff:AVAILABLE THEN DO:
          ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " +
                                STRING(ghFilTrgBuff::_file-recid),
                                NO-LOCK) NO-ERROR.
          IF ghFileBuff:AVAILABLE THEN
            cAppTbl = " for table " + ghFileBuff::_owner + "." +
                      ghFileBuff::_file-name.
          ELSE cAppTbl = " (Table RECID=~"" + 
                         STRING(ghFilTrgBuff::_file-recid) + "~")".

          cContext = ghFilTrgBuff::_event + " trigger added to table" + 
                     cAppTbl.
        END.
        ELSE cContext = "New table trigger created".
      END.
      ELSE cContext = "New table trigger created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Create Table Trigger */
    WHEN "5002" THEN DO: /* Schema - Create Table Field */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.

        ghFieldBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghFieldBuff:AVAILABLE THEN DO:
          ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " +
                                STRING(ghFieldBuff::_file-recid),
                                NO-LOCK) NO-ERROR.
          IF ghFileBuff:AVAILABLE THEN
            cAppTbl = ghFileBuff::_owner + "." +
                      ghFileBuff::_file-name.
          ELSE cAppTbl = "(Table RECID=~"" + 
                         STRING(ghFieldBuff::_file-recid) + "~")".

          cContext = "Field ~"" + ghFieldBuff::_field-name + 
                     "~" created in table " + cAppTbl.
        END.
        ELSE cContext = "New field created".
      END.
      ELSE cContext = "New field created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Create Table Field */
    WHEN "5003" THEN DO: /* Schema - Create Field Trigger */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.

        ghFldTrgBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghFldTrgBuff:AVAILABLE THEN DO:
          ghFieldBuff:FIND-FIRST("WHERE RECID(_field) EQ " +
                                 STRING(ghFldTrgBuff::_field-recid),
                                 NO-LOCK) NO-ERROR.
          IF ghFieldBuff:AVAILABLE THEN DO:
            ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " +
                                  STRING(ghFieldBuff::_file-recid),
                                  NO-LOCK) NO-ERROR.
            IF ghFileBuff:AVAILABLE THEN
              cAppFld = ghFileBuff::_owner + "." + 
                        ghFileBuff::_file-name + "." + 
                        ghFieldBuff::_field-name.
            ELSE cAppFld = ghFieldBuff::_field-name + 
                           " in table (Table RECID=~"" + 
                           STRING(ghFieldBuff::_file-recid) + "~")".
          END. /* Field record still exists */
          ELSE cAppFld = " (Field RECID=~"" + 
                         STRING(ghFldTrgBuff::_field-recid) + "~") ".

          cContext = ghFldTrgBuff::_event + " trigger added for field " + 
                     cAppFld.
        END. /* Field Trigger record still exists */
        ELSE cContext = "New field trigger added for field (Field ROWID=~"" +
                        cContext + "~")".
      END. /* Context info available */
      ELSE cContext = "New field trigger created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Create Field Trigger */
    WHEN "5004" THEN DO: /* Schema - Create Table Index */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.

        ghIndexBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghIndexBuff:AVAILABLE THEN DO:
          ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " +
                                STRING(ghIndexBuff::_file-recid),
                                NO-LOCK) NO-ERROR.
          cIndex = ghFileBuff::_owner + "." + ghFileBuff::_file-name + "." +
                   ghIndexBuff::_index-name.
          cContext = "Index " + cIndex + " created".
        END.
        ELSE cContext = "New index (Index ROWID=~"" +
                        cContext + "~") created".
      END.
      ELSE cContext = "New index created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Create Table Index */
    WHEN "5005" THEN DO: /* Schema - Add Field to Index */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.

        ghIdxFldBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghIdxFldBuff:AVAILABLE THEN DO:
          ghIndexBuff:FIND-FIRST("WHERE RECID(_index) EQ " +
                                STRING(ghIdxFldBuff::_index-recid),
                                NO-LOCK) NO-ERROR.
          IF ghIndexBuff:AVAILABLE THEN DO:
            ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " +
                                  STRING(ghIndexBuff::_file-recid),
                                  NO-LOCK) NO-ERROR.
            cIndex = ghFileBuff::_owner + "." +
                     ghFileBuff::_file-name + "." +
                     ghIndexBuff::_index-name.
          END.
          ELSE cIndex = "(Index RECID=~"" + 
                        STRING(ghIdxFldBuff::_index-recid) + "~")".

          ghFieldBuff:FIND-FIRST("WHERE RECID(_field) EQ " +
                                 STRING(ghIdxFldBuff::_field-recid),
                                 NO-LOCK) NO-ERROR.
          IF ghFieldBuff:AVAILABLE THEN
            cAppFld = ghFieldBuff::_field-name.
          ELSE DO: 
            IF cIndex BEGINS "(" THEN
              ASSIGN cIndex  = RIGHT-TRIM(cIndex,")") + ", Field RECID=~"" +
                               STRING(ghIdxFldBuff::_field-recid) + "~")"
                     cAppFld = "".
            ELSE 
              cAppFld = " (Field RECID=~"" + 
                        STRING(ghIdxFldBuff::_field-recid) + "~") ".
          END.

          cContext = "Index field" + cAppFld + "added to index " + cIndex.
        END.
        ELSE cContext = "New index field added (Index-Field ROWID=~"" +
                        cContext + "~")".
      END.
      ELSE cContext = "New index field added".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END. /* Add Field to Index */
    WHEN "5010" THEN DO: /* Schema - Modify DB Table */
      ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7))
             cOwner   = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      hADBuff::_formatted-event-context = 
        "Table " + cOwner + "." + cAppTbl + " modified" + cUserId.
    END. /* Modify DB Table */
    WHEN "5011" THEN DO: /* Schema - Modify Table Trigger  */
      ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7))
             cEvent   = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " + cAppTbl,
                            NO-LOCK) NO-ERROR.
      IF ghFileBuff:AVAILABLE THEN
        cAppTbl = ghFileBuff::_owner + "." + 
                  ghFileBuff::_file-name.
      ELSE cAppTbl = "(Table RECID=~"" + cAppTbl + "~")".

      hADBuff::_formatted-event-context = 
        cEvent + " trigger, for table " + cAppTbl + ", modified" + cUserId.
    END. /* Modify Table Trigger  */
    WHEN "5012" THEN DO: /* Schema - Modify Table Field */
      ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7))
             cAppFld  = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " + cAppTbl,
                            NO-LOCK) NO-ERROR.
      IF ghFileBuff:AVAILABLE THEN
        cAppFld = ghFileBuff::_owner + "." + 
                  ghFileBuff::_file-name + "." +
                  cAppFld.
      ELSE cAppFld = cAppFld + ", in table (Table RECID=~"" + cAppTbl + "~"),".

      hADBuff::_formatted-event-context = 
        "Field " + cAppFld + " modified" + cUserId.
    END. /* Modify Table Field */
    WHEN "5013" THEN DO: /* Schema - Modify Field Trigger */
      ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7))
             cAppFld  = ENTRY(2,cContext,CHR(7))
             cEvent   = ENTRY(3,cContext,CHR(7)) NO-ERROR.

      ghFieldBuff:FIND-FIRST("WHERE RECID(_field) EQ " + cAppFld,
                             NO-LOCK) NO-ERROR.
      IF ghFieldBuff:AVAILABLE THEN DO:
        ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " + cAppTbl,
                              NO-LOCK) NO-ERROR.
        cAppFld = ghFileBuff::_owner + "." + ghFileBuff::_file-name + 
                  "." + ghFieldBuff::_field-name.
      END.
      ELSE cAppFld = "(Table RECID=~"" + cAppTbl + "~", Field RECID=~"" +
                     cAppFld + "~")".
      
      hADBuff::_formatted-event-context = 
        cEvent + " field trigger for field " + cAppFld + " modified" + cUserId.
    END. /* Modify Field Trigger */
    WHEN "5014" THEN DO: /* Schema - Modify Table Index */
      ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7))
             cIndex   = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " + cAppTbl,
                            NO-LOCK) NO-ERROR.
      IF ghFileBuff:AVAILABLE THEN
        cIndex  = ghFileBuff::_owner + "." + 
                  ghFileBuff::_file-name + "." + cIndex.
      ELSE cIndex = cIndex + ", in table (Table RECID=~"" + cAppTbl + "~"),".

      hADBuff::_formatted-event-context = 
        "Index " + cIndex + " modified" + cUserId.
    END. /* Modify Table Index */
    WHEN "5015" THEN DO: /* Schema - Modify Index Field */
      ASSIGN cIndex   = ENTRY(1,cContext,CHR(7))
             cAppFld  = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      ghIndexBuff:FIND-FIRST("WHERE RECID(_index) EQ " + cIndex,
                             NO-LOCK) NO-ERROR.
      IF ghIndexBuff:AVAILABLE THEN DO:
        ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " +
                              STRING(ghIndexBuff::_file-recid),NO-LOCK)
                             NO-ERROR.
        cIndex = ghFileBuff::_owner + "." + 
                 ghFileBuff::_file-name + 
                 "." + ghIndexBuff::_index-name.
      END.
      ELSE cIndex  = "(Index RECID=~"" + cIndex + "~")".

      ghFieldBuff:FIND-FIRST("WHERE RECID(_field) EQ " + cAppFld,
                             NO-LOCK) NO-ERROR.
      IF ghFieldBuff:AVAILABLE THEN
        cAppFld = ghFieldBuff::_field-name.
      ELSE DO:
        IF cIndex BEGINS "(" THEN
          ASSIGN cIndex  = RIGHT-TRIM(cIndex,")") + 
                           ", Field RECID=~"" + cAppFld + ")"
                 cAppFld = "".
        ELSE cAppFld = "(Field RECID=~"" + cAppFld + "~")".
      END.
      hADBuff::_formatted-event-context = 
        "Index Field " + cAppFld + ", in index " + cIndex + 
        ", modified" + cUserId.
    END. /* Modify Index Field */
    WHEN "5020" THEN DO: /* Schema - Delete DB Table */
      ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7))
             cOwner   = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      hADBuff::_formatted-event-context = 
        "Table " + cOwner + "." + cAppTbl + " deleted" + cUserId.
    END. /* Delete DB Table */
    WHEN "5021" THEN DO: /* Schema - Delete Table Trigger */
      ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7))
             cEvent   = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " + cAppTbl,
                            NO-LOCK) NO-ERROR.
      IF ghFileBuff:AVAILABLE THEN
        cAppTbl = ghFileBuff::_owner + "." + 
                  ghFileBuff::_file-name.
      ELSE cAppTbl = "(Table RECID=~"" + cAppTbl + "~")".
      
      hADBuff::_formatted-event-context = 
        cEvent + " table trigger, for table " + cAppTbl + ", deleted" + 
        cUserId.
    END. /* Delete Table Trigger */
    WHEN "5022" THEN DO: /* Schema - Delete Table Field */
      ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7))
             cAppFld  = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " + cAppTbl,
                            NO-LOCK) NO-ERROR.
      IF ghFileBuff:AVAILABLE THEN
        ASSIGN cAppFld = ghFileBuff::_owner + "." + ghFileBuff::_file-name + 
                         cAppFld
               cAppTbl = "".
      ELSE cAppTbl = " from table (Table RECID=~"" + cAppTbl + "~")".

      hADBuff::_formatted-event-context = 
        "Field " + cAppFld + " deleted" + cAppTbl + cUserId.
    END. /* Delete Table Field */
    WHEN "5023" THEN DO: /* Schema - Delete Field Trigger */
      ASSIGN cAppTbl = ENTRY(1,cContext,CHR(7))
             cAppFld = ENTRY(2,cContext,CHR(7))
             cEvent  = ENTRY(3,cContext,CHR(7)) NO-ERROR.

      ghFieldBuff:FIND-FIRST("WHERE RECID(_field) EQ " + cAppFld,
                             NO-LOCK) NO-ERROR.
      ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " + cAppTbl,
                            NO-LOCK) NO-ERROR.
      IF ghFileBuff:AVAILABLE THEN DO:
        IF ghFieldBuff:AVAILABLE THEN
          cAppFld = ghFileBuff::_owner + "." + 
                    ghFileBuff::_file-name + "." + 
                    ghFieldBuff::_field-name + ", ".
        ELSE
          cAppFld = "(Field RECID=~"" + cAppFld + "~"), in table " + 
                    ghFileBuff::_owner + "." + ghFileBuff::_file-name.
      END.
      ELSE
        cAppFld = "(Table RECID=~"" + cAppTbl + "~", Field RECID=~"" +
                  cAppFld + "~")".

      hADBuff::_formatted-event-context = 
        cEvent + " field trigger, for field " + cAppFld + ", deleted" + 
        cUserId.
    END. /* Delete Field Trigger */
    WHEN "5024" THEN DO: /* Schema - Delete Table Index */
      ASSIGN cAppTbl  = ENTRY(1,cContext,CHR(7))
             cIndex   = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " + cAppTbl,
                            NO-LOCK) NO-ERROR.
      IF ghFileBuff:AVAILABLE THEN
        ASSIGN cIndex  = ghFileBuff::_owner + "." + ghFileBuff::_file-name + 
                         "." + cIndex
               cAppTbl = "".
      ELSE cAppTbl = " from table (Table RECID=~"" + cAppTbl + "~")".

      hADBuff::_formatted-event-context = 
        "Index " + cIndex + " deleted" + cAppTbl + cUserId.
    END. /* Delete Table Index */
    WHEN "5025" THEN DO: /* Schema - Delete Index Field */
      ASSIGN cIndex   = ENTRY(1,cContext,CHR(7))
             cAppFld  = ENTRY(2,cContext,CHR(7)) NO-ERROR.

      ghIndexBuff:FIND-FIRST("WHERE RECID(_index) EQ " + cIndex,
                             NO-LOCK) NO-ERROR.
      IF ghIndexBuff:AVAILABLE THEN DO:
        ghFileBuff:FIND-FIRST("WHERE RECID(_file) EQ " +
                              STRING(ghIndexBuff::_file-recid),NO-LOCK)
                             NO-ERROR.
        IF ghFileBuff:AVAILABLE THEN
          cIndex = ghFileBuff::_owner + "." + 
                   ghFileBuff::_file-name + "." + 
                   ghIndexBuff::_index-name.
        ELSE cIndex = ghIndexBuff::_index-name + 
                      " (Table RECID=~"" + 
                      STRING(ghIndexBuff::_file-recid) + "~")".
      END.
      ELSE
        cIndex = "(Index RECID=~"" + cIndex + "~")".

      ghFieldBuff:FIND-FIRST("WHERE RECID(_field) EQ " + cAppFld,
                             NO-LOCK) NO-ERROR.
      IF ghFieldBuff:AVAILABLE THEN
        cAppFld = ghFieldBuff::_field-name.
      ELSE cAppFld = "(Field RECID=~"" + cAppFld + "~")".

      hADBuff::_formatted-event-context = 
        "Index Field " + cAppFld + " removed from index " + cIndex + cUserId.
    END. /* Delete Index Field */
    WHEN "5030" THEN DO: /* Schema - Create DB Sequence */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.

        ghSeqBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
        IF ghSeqBuff:AVAILABLE THEN
          cContext = "New Sequence ~"" + ghSeqBuff::_seq-owner + "." +
                     ghSeqBuff::_seq-name + "~" created".
        ELSE cContext = "New Sequence created".
      END.
      ELSE cContext = "New Sequence created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END.
    WHEN "5031" THEN DO: /* Schema - Modify DB Sequence */
      ghSeqBuff:FIND-FIRST("WHERE _seq-name EQ ~'" +
                           cContext,NO-LOCK) NO-ERROR.
      IF ghSeqBuff:AVAILABLE THEN
        cContext = ghSeqBuff::_seq-owner + "." + ghSeqBuff::_seq-name.
      
      hADBuff::_formatted-event-context = 
        "Sequence " + cContext + " modified" + cUserId.
    END.
    WHEN "5032" THEN /* Schema - Delete DB Sequence */
      hADBuff::_formatted-event-context = 
        "Sequence " + cContext + " deleted" + cUserId.
    WHEN "5040" THEN DO: /* Schema - DB Property Created */
      IF (ENTRY(1,cContext,CHR(7)) > "?") = TRUE THEN DO:
        cContext = ENTRY(1,cContext,CHR(7)) NO-ERROR.

        IF cTable EQ "PUB._db-option" OR
           cTable EQ "_db-option" THEN DO:
          ghDbOptBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
          IF ghDbOptBuff:AVAILABLE THEN
            cContext = "Database option ~"" + ghDbOptBuff::_db-option-code +
                       "~" added (Option Type: " + 
                       STRING(ghDbOptBuff::_db-option-type) + ")".
          ELSE cContext = "New Database Option added".
        END.
        ELSE DO:
          ghDbDtlBuff:FIND-BY-ROWID(TO-ROWID(cContext),NO-LOCK) NO-ERROR.
          IF ghDbDtlBuff:AVAILABLE THEN
            cContext = "New Database Identification record created, with " +
                       "database identifier ~"" + ghDbDtlBuff::_db-guid +
                       "~" (DB Passkey Assigned: " +
                       (IF STRING(ghDbDtlBuff::_db-mac-key) NE "020000" THEN 
                          "Yes" ELSE "No") + ")".
          ELSE cContext = "New Database Identification record created".
        END.
      END.
      ELSE IF cTable EQ "PUB._db-option" OR
              cTable EQ "_db-option" THEN
        cContext = "New Database Option added".
      ELSE cContext = "New Database Identification record created".

      hADBuff::_formatted-event-context = cContext + cUserId.
    END.
    WHEN "5041" THEN DO: /* Schema - DB Property Updated */
      IF cTable EQ "PUB._db-option" OR
         cTable EQ "_db-option" THEN DO:
        ASSIGN cType   = ENTRY(1,cContext,CHR(7)) 
               cOption = ENTRY(2,cContext,CHR(7)) NO-ERROR.

        IF cType EQ "1" THEN
          cContext = "Auditing Option " + cOption + " has been modified".
        ELSE IF cType EQ "2" THEN
          cContext = "Security Option " + cOption + " has been modified".
        ELSE 
          cContext = "Database Option " + cOption + " (Option Type: " +
                     cType + ") has been modified".
        
      END.
      ELSE DO:
        ASSIGN cGuid    = cContext
               cContext = "Database Identification record, with DB " +
                          "Identifier ~"" + cGuid + "~", has been modified".

        ghDbDtlBuff:FIND-FIRST("WHERE _db-guid = ~'" +
                               cGuid + "~'",NO-LOCK) NO-ERROR.
        IF ghDbDtlBuff:AVAILABLE THEN
          cContext = cContext + " (DB Passkey Assigned: " +
                     (IF STRING(ghDbDtlBuff::_db-mac-key) NE "020000" THEN 
                        "Yes" ELSE "No") + ")".
      END.
        
      hADBuff::_formatted-event-context = cContext + cUserId.
    END.
    WHEN "10000" THEN DO: /* Enable Auditing */
      cRunOpt = unQuote(hADBuff::_event-detail,
                        "~"").
      
      ASSIGN cUser = (IF hADBuff::_user-id NE "" THEN hADBuff::_user-id
                      ELSE (IF INDEX(cRunOpt,"-U") > 0 THEN
                              ENTRY(LOOKUP("-U",cRunOpt," ") + 1,cRunOpt," ")
                              ELSE ""))
             cUser = (IF cUser NE "" THEN " by " ELSE "") + cUser.

      hADBuff::_formatted-event-context = 
         "Auditing Enabled for " + ENTRY(2,cRunOpt," ") + cUser.
    END.
    WHEN "10001" THEN DO: /* Disable Auditing */
      cRunOpt = unQuote(hADBuff::_event-detail,
                        "~"").
      
      ASSIGN cUser = (IF hADBuff::_user-id NE "" THEN hADBuff::_user-id
                      ELSE (IF INDEX(cRunOpt,"-U") > 0 THEN
                              ENTRY(LOOKUP("-U",cRunOpt," ") + 1,cRunOpt," ")
                              ELSE ""))
             cUser = (IF cUser NE "" THEN " by " ELSE "") + cUser.

      hADBuff::_formatted-event-context = 
         "Auditing Disabled for " + ENTRY(2,cRunOpt," ") + cUser.
    END.
    WHEN "10010" THEN /* Commit Audit Policy Changes */
      hADBuff::_formatted-event-context = 
          "Audit Policy changes committed".
    WHEN "10100" OR /* Start DB - _mprosrv */
    WHEN "10101"    /* Stop DB - _mprshut */ THEN DO:
        
        /* detail info may be empty, in which case, we have nothing to add other than the event itself */
        IF hADBuff::_event-detail = "" THEN DO:
            IF cEventId EQ "10100"  THEN
                cRunOpt = "Started".
            ELSE
                cRunOpt = "Shut down".

            hADBuff::_formatted-event-context = "Database " + cRunOpt.

        END.
        ELSE DO:
        
              cRunOpt = unQuote(hADBuff::_event-detail, "~"").

              IF cEventId EQ "10101" THEN
                 hADBuff::_formatted-event-context = "Database " + cRunOpt.
              ELSE DO:
        
                     hADBuff::_formatted-event-context = "Database " + ENTRY(1, cRunOpt, ".").
                  
                     ASSIGN i = INDEX (cRunOpt, ".")
                                  hADBuff::_formatted-event-context = hADBuff::_formatted-event-context +
                                            ", with effective parameters " + QUOTER (TRIM(SUBSTRING(cRunOpt, i + 2))).
              END.
        END.
    END.
    WHEN "10202" OR /* Binary Dump - proutil dump */
    WHEN "10203" OR /* Binary Load - proutil load */
    WHEN "10205" OR /* Table Move - proutil tablemove */ 
    WHEN "10206" OR /* Index Move - proutil idxmove */
    WHEN "10208" OR /* Index Rebuild - proutil idxbuild */
    WHEN "10209"    /* Area Truncate - proutil truncate area */ THEN DO:
      cRunOpt = formatCommandLine(hADBuff::_event-detail).

      cUser = (IF hADBuff::_user-id NE "" THEN hADBuff::_user-id
               ELSE (IF INDEX(cRunOpt,"-U") > 0 THEN
                       ENTRY(LOOKUP("-U",cRunOpt," ") + 1,cRunOpt," ")
                     ELSE "")).

      IF cEventId EQ "10202" OR
         cEventId EQ "10205" OR
         cEventId EQ "10206" THEN
        ASSIGN cCommand  = "Binary Dump" 
                            WHEN cEventId EQ "10202"
               cCommand  = "Table Move"  
                            WHEN cEventId EQ "10205"
               cCommand  = "Index Move"  
                            WHEN cEventId EQ "10206"
               iEntry    = LOOKUP("-C",cRunOpt," ") + 2
               cEntity   = ENTRY(iEntry,cRunOpt," ")
               cToEntity = ENTRY(iEntry + 1,cRunOpt," ")
               cVerb     = " dumping " + cEntity + " to " 
                                    WHEN cEventId EQ "10202"
               cVerb     = " moving "  + cEntity + " to " 
                                    WHEN cEventId EQ "10205"
               cVerb     = " moving "  + cEntity + " to " 
                                    WHEN cEventId EQ "10206" NO-ERROR.
      ELSE IF cEventId EQ "10203" OR 
              cEventId EQ "10208" THEN
        ASSIGN cCommand = "Binary Load"   
                            WHEN cEventId EQ "10203"
               cCommand = "Index Rebuild" 
                            WHEN cEventId EQ "10208"
               iEntry   = LOOKUP("-C",cRunOpt," ") + 2
               cEntity  = ENTRY(iEntry,cRunOpt," ") NO-ERROR.
      ELSE IF cEventId EQ "10209" THEN
        ASSIGN cCommand = "Truncate Area"
               iEntry   = LOOKUP("-C",cRunOpt," ") + 3
               cEntity  = ENTRY(iEntry,cRunOpt," ") NO-ERROR.

      IF cUser NE "" THEN
        hADBuff::_formatted-event-context = 
          cUser + " performed a " + cCommand + " operation on the database" +
          cVerb + cToEntity + ".".
      ELSE
       hADBuff::_formatted-event-context = cCommand + " operation performed on the database. "  + cRunOpt.

      hADBuff::_event-detail            = cRunOpt.
    END.
    WHEN "10211" THEN DO: /* SQL Table Dump */
      cRunOpt = formatCommandLine(hADBuff::_event-detail).

      hADBuff::_event-detail            = cRunOpt.

      IF INDEX(hADBuff::_event-context,CHR(7)) > 0 THEN
        hADBuff::_formatted-event-context = 
            "Table " + ENTRY(2,hADBuff::_event-context,CHR(7)) +
            " dumped from sql." NO-ERROR.
      ELSE hADBuff::_formatted-event-context = hADBuff::_event-context.
    END.
    WHEN "10212" THEN DO: /* SQL Table Load */
      cRunOpt = formatCommandLine(hADBuff::_event-detail).

      hADBuff::_event-detail            = cRunOpt.

      IF INDEX(hADBuff::_event-context,CHR(7)) > 0 THEN
        hADBuff::_formatted-event-context = 
            "Table " + ENTRY(2,hADBuff::_event-context,CHR(7)) +
            " loaded from sql." NO-ERROR.
      ELSE hADBuff::_formatted-event-context = hADBuff::_event-context.
    END.
    WHEN "10213" OR       /* Application Data Dump */
    WHEN "10214" THEN DO: /* Application Data Load */

        cUser = IF hADBuff::_user-id NE "" THEN hADBuff::_user-id ELSE "".
        
        IF cEventId = "10213" THEN
            cVerb = " dumped" + (IF cUser NE "" THEN " data " ELSE " ") + "from database ".
        ELSE
            cVerb = " loaded" + (IF cUser NE "" THEN " data " ELSE " ") + "into database ".

        IF cUser NE "" THEN
            cVerb = cUser + cVerb.
        ELSE
            cVerb = "Data" + cVerb.

        cCommand = SUBSTRING(hADBuff::_event-context,INDEX(hADBuff::_event-context, ".") + 1).

        hADBuff::_formatted-event-context = cVerb + QUOTER(ENTRY(1,hADBuff::_event-context,".")) +
            ", table " + QUOTER(REPLACE(cCommand,CHR(7),", ")).

    END.
    WHEN "10301" THEN DO: /* Dump Audit Data */
        cRunOpt = formatCommandLine(hADBuff::_event-detail).

        cUser = (IF hADBuff::_user-id NE "" THEN hADBuff::_user-id
                 ELSE (IF INDEX(cRunOpt,"-U") > 0 THEN
                         ENTRY(LOOKUP("-U",cRunOpt," ") + 1,cRunOpt," ")
                      ELSE "")).

        hADBuff::_event-detail            = cRunOpt.

        IF cUser NE "" THEN
            hADBuff::_formatted-event-context = 
                      cUser + " dumped audit data from database " +
                      QUOTER(hADBuff::_event-context).
        ELSE
            hADBuff::_formatted-event-context = 
                      "Audit data dumped from database " +
                      QUOTER(hADBuff::_event-context).

        /* event detail may be empty */
        IF  hADBuff::_Event-Detail NE "" THEN DO:
        
            IF LOOKUP("auditarchive", hADBuff::_Event-Detail, " ") > 0 THEN DO:
               i = INDEX(hADBuff::_Event-Detail,"auditarchive") + 12.
    
               hADBuff::_formatted-event-context = hADBuff::_formatted-event-context +
                        ', through the "audit archive" utility'.
    
               cCommand = TRIM(SUBSTRING(hADBuff::_Event-Detail,i)).
               IF cCommand NE "" THEN
                   hADBuff::_formatted-event-context = hADBuff::_formatted-event-context +
                   ", with options " + QUOTER(cCommand).
               ELSE
                   hADBuff::_formatted-event-context = hADBuff::_formatted-event-context +
                   ", with no optional parameters".
    
            END.
    
            IF ENTRY(1,hADBuff::_Event-Detail," ") = "Data" AND
               ENTRY(2,hADBuff::_Event-Detail," ") = "Administration" THEN DO:
    
               hADBuff::_formatted-event-context = hADBuff::_formatted-event-context +
                        ', through the "Data Administration" tool'.
    
               /* log the date range if specified */
               IF NUM-ENTRIES(hADBuff::_Event-Detail," ") = 4 THEN
                   hADBuff::_formatted-event-context = hADBuff::_formatted-event-context +
                         " (date range: " + ENTRY(3,hADBuff::_Event-Detail," ") +
                         " " + ENTRY(4,hADBuff::_Event-Detail," ")  + ").".
            END.
        END.
    END.
    WHEN "10302" THEN DO: /* Load Audit Data */
        cRunOpt = formatCommandLine(hADBuff::_event-detail).

        cUser = (IF hADBuff::_user-id NE "" THEN hADBuff::_user-id
                 ELSE (IF INDEX(cRunOpt,"-U") > 0 THEN
                         ENTRY(LOOKUP("-U",cRunOpt," ") + 1,cRunOpt," ")
                      ELSE "")).

        hADBuff::_event-detail            = cRunOpt.

        IF cUser NE "" THEN
            hADBuff::_formatted-event-context = 
                      cUser + " loaded audit data into database " +
                      QUOTER(hADBuff::_event-context).
        ELSE
            hADBuff::_formatted-event-context = 
                      "Audit data loaded into database " +
                      QUOTER(hADBuff::_event-context).

        /* event detail may be empty */
        IF  hADBuff::_Event-Detail NE "" THEN DO:
            IF ENTRY(1,hADBuff::_Event-Detail," ") = "Data" AND
               ENTRY(2,hADBuff::_Event-Detail," ") = "Administration" THEN
               hADBuff::_formatted-event-context = hADBuff::_formatted-event-context +
                        ', through the "Data Administration" tool'.
            ELSE
               hADBuff::_formatted-event-context = hADBuff::_formatted-event-context +
                         ', through the "audit archive" utility'.
        END.
    END.
    WHEN "10303" OR           /* Dump Audit Policy */
    WHEN "10304" THEN DO:     /* Load Audit Policy */ 

      ASSIGN cCommand = REPLACE(SUBSTRING(hADBuff::_event-context,INDEX(hADBuff::_event-context,".") + 1), CHR(7), ", ").

      IF hADBuff::_event-detail NE "" THEN DO:
      
          IF cEventId = "10303" THEN
              cVerb = " of database " + ENTRY(1,hADBuff::_event-detail) + " dumped".
          ELSE
              cVerb = " loaded into database " + ENTRY(1,hADBuff::_event-detail).
      END.
      ELSE DO:
          IF cEventId = "10303" THEN
              cVerb = " dumped".
          ELSE
              cVerb = " loaded".
     END.
     
     hADBuff::_formatted-event-context = "Audit Policy " + 
               QUOTER(cCommand) + cVerb + ", from " + QUOTER(ENTRY(1, hADBuff::_event-context, ".")).

      IF NUM-ENTRIES(hADBuff::_event-detail) > 1 THEN
         cVerb = ", in " + ENTRY(2,hADBuff::_event-detail) + " format".
      ELSE
         cVerb = "".

      hADBuff::_formatted-event-context = hADBuff::_formatted-event-context + cVerb.

    END.
    WHEN "10500" THEN
      hADBuff::_formatted-event-context = "User " +
          hADBuff::_event-context + " successfully set as Database User".
    WHEN "10501" THEN 
      hADBuff::_formatted-event-context = "Failed to set User " +
          hADBuff::_event-context + " as Database User".
    WHEN "10510" THEN
      hADBuff::_formatted-event-context = "User " +
          hADBuff::_event-context + " successfully logged in to the Database".
    WHEN "10511" THEN
      hADBuff::_formatted-event-context = "User " +
          hADBuff::_event-context + " successfully logged out of the Database".
    WHEN "10512" THEN
      hADBuff::_formatted-event-context = "User " +
          hADBuff::_event-context + ": Attempted login failed!".
    WHEN "10520" THEN DO:
      hADBuff::_formatted-event-context = "SQL User: " + 
            (IF hADBuff::_user-id NE ? AND hADBuff::_user-id NE "" THEN
                hADBuff::_user-id + " s" ELSE "S") + 
                  "uccessfully logged in to the Database".
    END.
    WHEN "10521" THEN
      hADBuff::_formatted-event-context = "SQL User: " +
            (IF hADBuff::_user-id NE ? AND hADBuff::_user-id NE "" THEN
                hADBuff::_user-id + " s" ELSE "S")
                + "uccessfully logged out of the Database".
    WHEN "10522" THEN
      hADBuff::_formatted-event-context = "SQL User: " +
                                "Attempted login failed!".
    WHEN "10600" THEN
      hADBuff::_formatted-event-context = 
        (IF hADBuff::_user-id NE ? AND
            hADBuff::_user-id NE "" THEN "User " + hADBuff::_user-id + " s"
         ELSE "S") + "uccessfully connected to " +
        hADBuff::_event-context.
    WHEN "10601" THEN
      hADBuff::_formatted-event-context = 
        (IF hADBuff::_user-id NE ? AND
            hADBuff::_user-id NE "" THEN "User " + hADBuff::_user-id + " s"
         ELSE "S") + "uccessfully disconnected from " +
        hADBuff::_event-context.
    WHEN "10610" THEN DO:
       IF hADBuff::_user-id NE ? AND hADBuff::_user-id NE "" THEN
          hADBuff::_formatted-event-context = "SQL User: " + 
                                hADBuff::_user-id + 
                                " successfully connected to the database".
       ELSE
          hADBuff::_formatted-event-context =
                    "A SQL Client successfully connected to the database".
    END.
    WHEN "10611" THEN DO:
        IF hADBuff::_user-id NE ? AND hADBuff::_user-id NE "" THEN
           hADBuff::_formatted-event-context = "SQL User: " + 
                     hADBuff::_user-id +
                     " successfully disconnected from the database".
        ELSE
           hADBuff::_formatted-event-context =
                      "A SQL Client successfully disconnected from the database".
    END.
    WHEN "11000" OR WHEN "11001" THEN DO:

        /* detail may be empty if event level is not full  */
        IF cEventId = "11000" AND 
            hADBuff::_event-detail NE ? AND 
            hADBuff::_event-detail NE "" THEN DO:
           cRunOpt = unQuote(ENTRY(3,hADBuff::_event-detail,":"),"~"").
           IF cRunOpt NE "" AND cRunOpt NE ? THEN
              cRunOpt = " (Parameters: " + cRunOpt + ")".
        END.
        ELSE 
            cRunOpt = "".
    
        ASSIGN cUser = (IF hADBuff::_user-id NE "" THEN hADBuff::_user-id
                              ELSE (IF INDEX(cRunOpt,"-U") > 0 THEN
                                      ENTRY(LOOKUP("-U",cRunOpt," ") + 1,cRunOpt," ")
                                      ELSE ""))
                     cUser = (IF cUser NE "" THEN " by " ELSE "") + cUser.
    
        /* detail may be empty if event level is not full  */
        IF hADBuff::_event-detail NE "" AND hADBuff::_event-detail NE ? THEN DO:
            IF ENTRY(1,hADBuff::_event-detail,":") = "pass" THEN DO:
                IF cEventId = "11000" THEN
                   hADBuff::_formatted-event-context = "Encryption Enabled for".
                ELSE
                    hADBuff::_formatted-event-context = "Encryption Disabled for".
            END.
            ELSE DO:
                IF cEventId = "11000" THEN
                   hADBuff::_formatted-event-context = "Enable encryption utility failed for".
                ELSE
                   hADBuff::_formatted-event-context = "Disable encryption utility failed for".
            END.
        END.
        ELSE DO:
            /* we don't know if it passed or failed, just report on the execution */
            IF cEventId = "11000" THEN
               hADBuff::_formatted-event-context = "Encryption Enabled utility executed for".
            ELSE
               hADBuff::_formatted-event-context = "Encryption Disabled utility executed for".
        END.

        hADBuff::_formatted-event-context =  hADBuff::_formatted-event-context + " "
                                             + TRIM(hADBuff::_event-context) /* db-name */
                                             + cRunOpt + cUser.
    END.
    WHEN "11100" THEN DO:
        hADBuff::_formatted-event-context = "Created key store " + hADBuff::_event-context.
    END.
    WHEN "11101" THEN DO:
        hADBuff::_formatted-event-context = "Key store deleted " + hADBuff::_event-context + cUserId.
    END.
    WHEN "11102" THEN DO:
        hADBuff::_formatted-event-context = "Key store " + hADBuff::_event-context
                                             + " opened" + cUserId.
    END.
    WHEN "11103" THEN DO:
        hADBuff::_formatted-event-context = "Encryption key changed for key store " 
                                                + hADBuff::_event-context + cUserId.
    END.
    WHEN "11104" THEN DO:
        hADBuff::_formatted-event-context = "Cipher changed for key store " 
                                             + hADBuff::_event-context.

        IF hADBuff::_event-detail NE ? AND hADBuff::_event-detail NE ""  THEN
            hADBuff::_formatted-event-context =  hADBuff::_formatted-event-context + " to " + 
                                                 ENTRY(2,hADBuff::_event-detail,CHR(7)).
         
        hADBuff::_formatted-event-context =  hADBuff::_formatted-event-context + cUserId.
    END.
    WHEN "11105" THEN DO:
        hADBuff::_formatted-event-context = "Admin passphrase changed for key store " 
                                             + hADBuff::_event-context + cUserId.
    END.
    WHEN "11105" THEN DO:
        hADBuff::_formatted-event-context = "User passphrase changed for key store " 
                                             + hADBuff::_event-context + cUserId.
    END.
    WHEN "11106" THEN DO:
        hADBuff::_formatted-event-context = "Admin passphrase changed for key store " 
                                             + hADBuff::_event-context + cUserId.
    END.
    WHEN "11107" THEN DO:
        hADBuff::_formatted-event-context = "Database key store entry created for " 
                                             + ENTRY(1,hADBuff::_event-context, CHR(6)) 
                                             + cUserId.
    END.
    WHEN "11108" THEN DO:
        hADBuff::_formatted-event-context = "Database key store entry updated for " 
                                             + ENTRY(1,hADBuff::_event-context, CHR(6))
                                             + cUserId.
    END.
    WHEN "11109" THEN DO:
        hADBuff::_formatted-event-context = "Database key store entry deleted for " 
                                             + ENTRY(1,hADBuff::_event-context, CHR(6))
                                             + cUserId.
    END.
    WHEN "11110" THEN DO:
        hADBuff::_formatted-event-context = "Database key store entry read for " 
                                             + ENTRY(1,hADBuff::_event-context, CHR(6))
                                             + cUserId.
    END.
    WHEN "11111" THEN DO:
        hADBuff::_formatted-event-context = "Failed to open key store " 
                                             + hADBuff::_event-context + cUserId.
    END.
    WHEN "11112" THEN DO:
        hADBuff::_formatted-event-context = "Failed to create key store entry for " 
                                             + hADBuff::_event-context + cUserId.
    END.
    WHEN "11113" THEN DO:
        hADBuff::_formatted-event-context = "Failed to update key store entry for " 
                                             + ENTRY(1,hADBuff::_event-context, CHR(6))
                                             + cUserId.
    END.
    WHEN "11114" THEN DO:
        hADBuff::_formatted-event-context = "Failed to delete key store entry for " 
                                             + ENTRY(1,hADBuff::_event-context, CHR(6))
                                             + cUserId.
    END.
    WHEN "11200" THEN DO:
        hADBuff::_formatted-event-context = "Auto-start key store file " 
                                             + hADBuff::_event-context + " created" + cUserId.
    END.
    WHEN "11201" THEN DO:
        hADBuff::_formatted-event-context = "Auto-start key store file " 
                                             + hADBuff::_event-context + " deleted" + cUserId.
    END.
    WHEN "11202" THEN DO:
        hADBuff::_formatted-event-context = "Auto-start key store file " 
                                             + hADBuff::_event-context + " opened" + cUserId.
    END.
    WHEN "11203" THEN DO:
        hADBuff::_formatted-event-context = "Auto-start key store file " 
                                             + hADBuff::_event-context + " recovered" + cUserId.
    END.
    WHEN "11204" THEN DO:
        hADBuff::_formatted-event-context = "Auto-start key store file " 
                                             + hADBuff::_event-context + " updated" + cUserId.
    END.
    WHEN "11205" THEN DO:
        hADBuff::_formatted-event-context = "Failed to open auto-start key store file " 
                                             + hADBuff::_event-context + cUserId.
    END.
    WHEN "11206" THEN DO:
        hADBuff::_formatted-event-context = "Failed to update auto-start key store file " 
                                             + hADBuff::_event-context + cUserId.
    END.
    WHEN "11207" THEN DO:
        hADBuff::_formatted-event-context = "Failed to recover auto-start key store file " 
                                             + hADBuff::_event-context + cUserId.
    END.
    WHEN "11300" THEN DO:
        hADBuff::_formatted-event-context = "Encryption state scan started".

        /* if we have details, it has the object name */
        IF hADBuff::_event-detail NE "" AND hADBuff::_event-detail NE ? THEN
            hADBuff::_formatted-event-context = hADBuff::_formatted-event-context 
                                             + " for " + QUOTER(hADBuff::_event-detail).

        hADBuff::_formatted-event-context = hADBuff::_formatted-event-context 
                                            + " on " + hADBuff::_event-context + cUserId.
    END.
    WHEN "11301" THEN DO:
        hADBuff::_formatted-event-context = "Encryption state update started".

        /* if we have details, it has the object name */
        IF hADBuff::_event-detail NE "" AND hADBuff::_event-detail NE ? THEN
            hADBuff::_formatted-event-context = hADBuff::_formatted-event-context 
                                             + " for " + QUOTER(hADBuff::_event-detail).

        hADBuff::_formatted-event-context = hADBuff::_formatted-event-context 
                                            + " on " + hADBuff::_event-context + cUserId.
    END.
    WHEN "11400" THEN DO:
        cTemp1 = ENTRY(2, hADBuff::_event-context, CHR(6)).

        RUN audGetDataValueFromEventDetail(hADBuff, INPUT "_Dbpol-ciphername", OUTPUT cTemp2).

        /* shouldn't happen, but just in case */
        IF cTemp2 = "NULL_NULL_NULL" THEN
            cTemp2 = "".

        hADBuff::_formatted-event-context = "Database encryption policy version "
                                             + ENTRY(2, cTemp1, CHR(7)) 
                                             + (IF cTemp2 NE "" THEN " (cipher: " + cTemp2 + ")" ELSE "")
                                             + " created" + cUserId.
    END.
    WHEN "11401" THEN DO:
        cTemp1 = ENTRY(2, hADBuff::_event-context, CHR(6)).
        hADBuff::_formatted-event-context = "Database encryption policy version "
                                             + ENTRY(2, cTemp1, CHR(7)) + " updated" 
                                             + cUserId.
    END.
    WHEN "11402" THEN DO:
        cTemp1 = ENTRY(2, hADBuff::_event-context, CHR(6)).
        hADBuff::_formatted-event-context = "Database encryption policy version "
                                             + ENTRY(2, cTemp1, CHR(7)) + " deleted" 
                                             + cUserId.
    END.
    WHEN "11500" OR 
        WHEN "11501" OR
        WHEN "11502" THEN DO:

         IF cEventId = "11500" THEN
            cTemp3 = " created".
         ELSE IF cEventId = "11501" THEN
            cTemp3 = " updated".
         ELSE
            cTemp3 = " deleted".

        cTemp1 = ENTRY(2, hADBuff::_event-context, CHR(6)).

        hADBuff::_formatted-event-context = "Encryption policy version "
                                            +  ENTRY(3, cTemp1, CHR(7)). 

        cTemp2 = ENTRY(2,  cTemp1, CHR(7)) /* obj type */.
        CASE cTemp2:
            WHEN "T" THEN
                cTemp2 = "table".
            WHEN "I" THEN
                cTemp2 = "index".
            WHEN "L" THEN
                cTemp2 = "lob".
            WHEN "A" THEN
                cTemp2 = "area".
        END CASE.

        /* the object / area name */
        cTemp1 = ENTRY(1, cTemp1, CHR(7)).
        IF cTemp1 BEGINS "PUB." THEN
            cTemp1 = SUBSTRING(cTemp1,5).

        IF cTemp1 NE "" AND cTemp2 NE "" THEN DO:
            IF cTemp2 = "table" OR cTemp2 = "area" THEN
                cTemp1 = QUOTER(cTemp1).
            ELSE DO:
                CASE NUM-ENTRIES(cTemp1, "."):
                    WHEN 2 THEN
                        cTemp1 = QUOTER(ENTRY(2, cTemp1, ".")) + " of " + QUOTER(ENTRY(1, cTemp1, ".")).
                    WHEN 3 THEN
                        cTemp1 = QUOTER(ENTRY(3, cTemp1, ".")) + " of " 
                                 + QUOTER(ENTRY(1, cTemp1, ".") + "." + ENTRY(2, cTemp1, ".")).
                END CASE.
            END.
    
            hADBuff::_formatted-event-context = hADBuff::_formatted-event-context 
                                                 + " for " + cTemp2 /* obj type */
                                                 + " " + cTemp1 /* obj/area name */
                                                 + cTemp3. 
            
            cTemp2 = "".
    
            IF cEventId = "11500" THEN DO:
                /* get cipher name if creating new object policy */
                RUN audGetDataValueFromEventDetail(hADBuff, INPUT "_Objpol-ciphername", OUTPUT cTemp2).
        
                IF cTemp2 = ? THEN
                    cTemp2 = "".
    
                IF cTemp2 NE "" THEN DO:
                    IF cTemp2 = "NULL_NULL_NULL" THEN
                       cTemp2 = " (encryption disabled)".
                    ELSE
                       cTemp2 = " with cipher " + cTemp2.
                END.
            END.
        END.
        ELSE DO:
            /* must be template record deleted during disableencryption */
            cTemp2 = "".
            hADBuff::_formatted-event-context = "Template record for encryption policy" + cTemp3.
        END.

        hADBuff::_formatted-event-context =  hADBuff::_formatted-event-context + cTemp2 + cUserId.
    END.
    WHEN "11600" THEN DO:
        cTemp1 = ENTRY(2, hADBuff::_event-context, CHR(6)).

        hADBuff::_formatted-event-context = "Database passphrase policy version " 
                                             + ENTRY(2, cTemp1, CHR(7)) + " created" + cUserId.
    END.
    WHEN "11601" THEN DO:
        cTemp1 = ENTRY(2, hADBuff::_event-context, CHR(6)).
        hADBuff::_formatted-event-context = "Database passphrase policy version " 
                                             + ENTRY(2, cTemp1, CHR(7)) + " updated" + cUserId.
    END.
    WHEN "11602" THEN DO:
        cTemp1 = ENTRY(2, hADBuff::_event-context, CHR(6)).
        hADBuff::_formatted-event-context = "Database passphrase policy version " 
                                             + ENTRY(2, cTemp1, CHR(7)) + " deleted" + cUserId.
    END.
    OTHERWISE 
      hADBuff::_formatted-event-context = hADBuff::_event-context.
  END CASE.
  hADBuff::_event-context           = REPLACE(hADBuff::_event-context,
                                              CHR(7),
                                              "CHR(7)").
  hADBuff::_event-context           = REPLACE(hADBuff::_event-context,
                                              CHR(6),
                                              "CHR(6)").

  /* check if we need to process the _Event-detail field for streamed fields on db events */
  /* only do it if doing detailed report or XML (XML is always detailed) */
  IF plDetail OR glWriteXml THEN
     RUN audDataValueFromEventDetail
         ( INPUT hADBuff, 
           DATASET-HANDLE phDataSet BY-REFERENCE ).

END PROCEDURE.


PROCEDURE audDataValueFromEventDetail:
  /* Procedure:   audDataValueFromEventDetail
   * 
   * Description: Read the value of the _Event-detail field for db events, and 
                  create audit data children records in the bAudDataValue 
   *              temp-table.
  */ 

  DEFINE INPUT PARAMETER hADBuff AS HANDLE NO-UNDO. /* handle of bAudData 
                                                       buffer */
  DEFINE INPUT PARAMETER DATASET-HANDLE phDataSet.

  DEFINE VARIABLE hADVBuff   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iLoop      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE numEntries AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cEntry     AS CHARACTER NO-UNDO.

  /* This is (and should be) only called if plDetail is TRUE */

  /* don't do this for events on encryption policy tables */
  IF hADBuff::_event-id >= 11400 AND hADBuff::_event-id <= 11602  THEN
     RETURN.

  /* check if this _Event-detail contains info for a db event. We will check 
     if the data follows the format defined for db events of 4 entries 
     separated by chr(6).
     
     It may contain more than one entry separated by chr(7), but we just need 
     to check the first one to see if it's a db event.
  */
  IF NUM-ENTRIES(ENTRY(1,hADBuff::_Event-detail,CHR(7)),CHR(6)) = 4 THEN DO:

    hADVBuff = phDataSet:GET-BUFFER-HANDLE("bAudDataValue").

    /* when recording method is non-streamed, the database records the 
       string "?" instead of the unknown value in the old and/or new value 
       fields, so set literal-question so that the report contains the same 
       information regardless of the recording method.
    */
    IF NOT hADVBuff:BUFFER-FIELD('_old-string-value'):LITERAL-QUESTION THEN
      ASSIGN 
        hADVBuff:BUFFER-FIELD('_old-string-value'):LITERAL-QUESTION  = TRUE
        hADVBuff:BUFFER-FIELD('_new-string-value'):LITERAL-QUESTION  = TRUE.

    numEntries = NUM-ENTRIES(hADBuff::_Event-detail,CHR(7)).

    /* loop through all field changes - separated by chr(7) */
    REPEAT iLoop = 1 TO numEntries:
      
      cEntry = ENTRY(iLoop,hADBuff::_Event-detail,CHR(7)).

      /* If entry is empty, it must be that the last entry had chr(7) at the
         end as well.
           
         If not, then something is very wrong 
      */
      IF cEntry = ? OR cEntry = "" THEN
        LEAVE.

      hADVBuff:BUFFER-CREATE().
         
      ASSIGN hADVBuff::_audit-data-guid           = hADBuff::_audit-data-guid
             hADVBuff::_continuation-sequence     = 0
             hADVBuff::_audit-data-security-level = 
                                       hADBuff::_audit-data-security-level
             hADVBuff::_field-name = ENTRY(1,cEntry,CHR(6))
             hADVBuff::_data-type-code = ENTRY(2,cEntry,CHR(6))
             hADVBuff::_old-string-value = ENTRY(3,cEntry,CHR(6))
             hADVBuff::_new-string-value = ENTRY(4,cEntry,CHR(6)).

      /* if the new and/or old values are for an array, remove the chr(8) 
         character */
      IF INDEX(hADVBuff::_old-string-value,CHR(8)) > 0 AND 
         INDEX(hADVBuff::_old-string-value,"E[":U) > 0 THEN
        ASSIGN 
          hADVBuff::_old-string-value = REPLACE(hADVBuff::_old-string-value, 
                                                CHR(8), 
                                                " ":U).

      IF INDEX(hADVBuff::_new-string-value,CHR(8)) > 0 AND 
         INDEX(hADVBuff::_new-string-value,"E[":U) > 0 THEN
        ASSIGN 
          hADVBuff::_new-string-value = REPLACE(hADVBuff::_new-string-value,
                                                CHR(8), 
                                                " ":U).

      /* now call the procedure to populate data type and security level 
         descriptions */
      RUN audDataValueAfterRowFill ( DATASET-HANDLE phDataSet BY-REFERENCE ).

    END.

    /* clear _Event-detail since we have created records for each fields 
       change - This is so that we don't log it in case the user dumps it to 
       XML file, since the data value records we created and will be dumped.
    */
    hADBuff::_Event-detail = "".
  END.

END PROCEDURE.

PROCEDURE audGetDataValueFromEventDetail:
  /* Procedure:   audGetDataValueFromEventDetail
   * 
   * Description: Read the value of a specific field in the _Event-detail
   *              field
  */ 

  DEFINE INPUT PARAMETER hADBuff AS HANDLE NO-UNDO. /* handle of bAudData 
                                                       buffer */
  DEFINE INPUT  PARAMETER cFieldName AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER cOutValue  AS CHAR NO-UNDO.

  DEFINE VARIABLE hADVBuff   AS HANDLE    NO-UNDO.
  DEFINE VARIABLE iLoop      AS INTEGER   NO-UNDO.
  DEFINE VARIABLE numEntries AS INTEGER   NO-UNDO.
  DEFINE VARIABLE cEntry     AS CHARACTER NO-UNDO.

  /* We will check if the data follows the format defined for db events of 4 entries 
     separated by chr(6).
     
     It may contain more than one entry separated by chr(7), but we just need 
     to check the first one to see if it's a db event.
  */
  IF NUM-ENTRIES(ENTRY(1,hADBuff::_Event-detail,CHR(7)),CHR(6)) = 4 THEN DO:

    numEntries = NUM-ENTRIES(hADBuff::_Event-detail,CHR(7)).

    /* loop through all field changes - separated by chr(7) */
    REPEAT iLoop = 1 TO numEntries:
      
      cEntry = ENTRY(iLoop,hADBuff::_Event-detail,CHR(7)).

      /* If entry is empty, it must be that the last entry had chr(7) at the
         end as well.
           
         If not, then something is very wrong 
      */
      IF cEntry = ? OR cEntry = "" THEN
        LEAVE.
         
      IF ENTRY(1,cEntry,CHR(6)) = cFieldName THEN DO:
          cOutValue = ENTRY(4,cEntry,CHR(6)).
          LEAVE.
      END.
    END.
  END.

END PROCEDURE.

PROCEDURE audDataValueAfterRowFill:
  DEFINE INPUT PARAMETER DATASET-HANDLE phDataSet.

  DEFINE VARIABLE hADVBuff   AS HANDLE      NO-UNDO.

  DEFINE VARIABLE iSecLevel  AS INTEGER     NO-UNDO.
  DEFINE VARIABLE iDTypeCode AS INTEGER     NO-UNDO.

  hADVBuff = phDataSet:GET-BUFFER-HANDLE("bAudDataValue").

  iSecLevel = INTEGER(hADVBuff::_audit-data-security-level).
  CASE iSecLevel:
    WHEN 1 THEN
      hADVBuff::_audit-data-security-level-name = "Message Digest".
    WHEN 2 THEN
      hADVBuff::_audit-data-security-level-name = "DB Passkey".
    OTHERWISE
      hADVBuff::_audit-data-security-level-name = "No Additional Security".
  END CASE.

  iDTypeCode = INTEGER(hADVBuff::_data-type-code).
  CASE iDTypeCode:
    WHEN 1 THEN
      hADVBuff::_data-type-name = "Character".
    WHEN 2 THEN
      hADVBuff::_data-type-name = "Date".
    WHEN 3 THEN
      hADVBuff::_data-type-name = "Logical".
    WHEN 4 THEN
      hADVBuff::_data-type-name = "Integer".
    WHEN 5 THEN
      hADVBuff::_data-type-name = "Decimal".
    WHEN 7 THEN
      hADVBuff::_data-type-name = "Recid".
    WHEN 8 THEN
      hADVBuff::_data-type-name = "Raw".
    WHEN 11 THEN
      hADVBuff::_data-type-name = "Memptr".
    WHEN 13 THEN
      hADVBuff::_data-type-name = "Rowid".
    WHEN 18 THEN
      hADVBuff::_data-type-name = "Blob".
    WHEN 19 THEN
      hADVBuff::_data-type-name = "Clob".
    WHEN 34 THEN
      hADVBuff::_data-type-name = "Datetime".
    WHEN 39 THEN
      hADVBuff::_data-type-name = "Longchar".
    WHEN 40 THEN
      hADVBuff::_data-type-name = "Datetime-TZ".
    WHEN 41 THEN
        hADVBuff::_data-type-name = "Int64".
    OTHERWISE
      hADVBuff::_data-type-name = "Unknown".
  END CASE.

  /* for blob and clob fields, clear up the old and new value string in case
     they have garbage in them, since we don't support them (for now)
  */
  IF iDTypeCode = 18 OR iDTypeCode = 19 THEN
      ASSIGN hADVBuff::_old-string-value = ""
             hADVBuff::_new-string-value = "".

  /* if the new and/or old values are for an array, remove the chr(8) character for reporting */
  IF INDEX(hADVBuff::_old-string-value,CHR(8)) > 0 AND 
     INDEX(hADVBuff::_old-string-value,"E[":U) > 0 THEN
     ASSIGN hADVBuff::_old-string-value = REPLACE(hADVBuff::_old-string-value, 
                                                  CHR(8), 
                                                  " ":U).

  IF INDEX(hADVBuff::_new-string-value,CHR(8)) > 0 AND 
     INDEX(hADVBuff::_new-string-value,"E[":U) > 0 THEN
    ASSIGN hADVBuff::_new-string-value = REPLACE(hADVBuff::_new-string-value, 
                                                 CHR(8), 
                                                 " ":U).

END PROCEDURE.

PROCEDURE createSecondaryBuffers:
  DEFINE INPUT  PARAMETER pcDbName AS CHARACTER   NO-UNDO.
  DEFINE INPUT  PARAMETER piReport AS INTEGER     NO-UNDO.

  CASE piReport:
    WHEN 1 THEN DO:
      CREATE BUFFER ghAPBuff  FOR TABLE pcDbName + "._aud-audit-policy"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghAEBuff  FOR TABLE pcDbName + "._aud-event"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghAFIBuff FOR TABLE pcDbName + "._aud-file-policy"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghAFEBuff FOR TABLE pcDbName + "._aud-field-policy"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghAEVBuff FOR TABLE pcDbName + "._aud-event-policy"
                                             IN WIDGET-POOL "datasetPool".
    END.
    WHEN 2 THEN DO:
      CREATE BUFFER ghFileBuff   FOR TABLE pcDbName + "._file"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghFilTrgBuff FOR TABLE pcDbName + "._file-trig"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghFieldBuff  FOR TABLE pcDbName + "._field"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghFldTrgBuff FOR TABLE pcDbName + "._field-trig"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghIndexBuff  FOR TABLE pcDbName + "._index"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghIdxFldBuff FOR TABLE pcDbName + "._index-field"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSeqBuff    FOR TABLE pcDbName + "._sequence"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghDbOptBuff  FOR TABLE pcDbName + "._db-option"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghDbDtlBuff  FOR TABLE pcDbName + "._db-detail"
                                             IN WIDGET-POOL "datasetPool".
    END.
    WHEN 5 THEN
      CREATE BUFFER ghUserBuff FOR TABLE pcDbName + "._user"
                                             IN WIDGET-POOL "datasetPool".
    WHEN 6 THEN DO:
      CREATE BUFFER ghSRoleBuff  FOR TABLE pcDbName + "._sec-role"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSGRBuff    FOR TABLE pcDbName + "._sec-granted-role"
                                             IN WIDGET-POOL "datasetPool".
    END.
    WHEN 7 THEN DO:                                                         
      CREATE BUFFER ghTabAuth    FOR TABLE pcDbName + "._systabauth"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghColAuth    FOR TABLE pcDbName + "._syscolauth"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSeqAuth    FOR TABLE pcDbName + "._sysseqauth"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghDbAuth     FOR TABLE pcDbName + "._sysdbauth"
                                             IN WIDGET-POOL "datasetPool".
    END.
    WHEN 8 THEN DO:
      CREATE BUFFER ghSecASBuff  FOR TABLE pcDbName + 
                                           "._sec-authentication-system"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSecADBuff  FOR TABLE pcDbName + 
                                           "._sec-authentication-domain"
                                             IN WIDGET-POOL "datasetPool".
    END.
    WHEN 12 THEN DO:
      CREATE BUFFER ghAPBuff     FOR TABLE pcDbName + "._aud-audit-policy"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghAEBuff     FOR TABLE pcDbName + "._aud-event"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghAFIBuff    FOR TABLE pcDbName + "._aud-file-policy"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghAFEBuff    FOR TABLE pcDbName + "._aud-field-policy"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghAEVBuff    FOR TABLE pcDbName + "._aud-event-policy"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghFileBuff   FOR TABLE pcDbName + "._file"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghFilTrgBuff FOR TABLE pcDbName + "._file-trig"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghFieldBuff  FOR TABLE pcDbName + "._field"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghFldTrgBuff FOR TABLE pcDbName + "._field-trig"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghIndexBuff  FOR TABLE pcDbName + "._index"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghIdxFldBuff FOR TABLE pcDbName + "._index-field"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSeqBuff    FOR TABLE pcDbName + "._sequence"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghDbOptBuff  FOR TABLE pcDbName + "._db-option"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghDbDtlBuff  FOR TABLE pcDbName + "._db-detail"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghUserBuff   FOR TABLE pcDbName + "._user"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSRoleBuff  FOR TABLE pcDbName + "._sec-role"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSGRBuff    FOR TABLE pcDbName + "._sec-granted-role"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSecASBuff  FOR TABLE pcDbName + 
                                           "._sec-authentication-system"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSecADBuff  FOR TABLE pcDbName + 
                                           "._sec-authentication-domain"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghTabAuth    FOR TABLE pcDbName + "._systabauth"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghColAuth    FOR TABLE pcDbName + "._syscolauth"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghSeqAuth    FOR TABLE pcDbName + "._sysseqauth"
                                             IN WIDGET-POOL "datasetPool".
      CREATE BUFFER ghDbAuth     FOR TABLE pcDbName + "._sysdbauth"
                                             IN WIDGET-POOL "datasetPool".
    END.
  END CASE.

  IF piReport NE 9 THEN
  CREATE BUFFER ghADBuff FOR TABLE pcDbName + "._aud-audit-data"
                                             IN WIDGET-POOL "datasetPool".
END PROCEDURE.


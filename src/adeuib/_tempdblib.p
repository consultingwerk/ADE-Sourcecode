&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/* Copyright (C) 2005-2008,2013 by Progress Software Corporation. All     
   rights reserved.  Prior versions of this work may contain portions
   contributed by participants of Possenet. */
/*------------------------------------------------------------------------
    File        : adeuib/_tempdblib.p
    Purpose     : Procedure Library for Temp-DB Maintenance tool

    Syntax      :

    Description :

    Author(s)   : Don Bulua
    Created     : 05/01/2004
    Notes       :This procedure is run as a super procedure of _tempdb.w
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE VARIABLE ghSchema         AS HANDLE     NO-UNDO.
DEFINE VARIABLE gcSchemaTable    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSchemaPrefix   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSchemaDatabase AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcSchemaFlds     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE glLogFile        AS LOGICAL    NO-UNDO. /* Yes- LOG File, NO-Don't log file */
DEFINE VARIABLE gcLogFile        AS CHARACTER  NO-UNDO. /* Log file */
DEFINE VARIABLE glLogCompare     AS LOGICAL    NO-UNDO. /* Send Log info to compare screen */
DEFINE VARIABLE ghCompare        AS HANDLE     NO-UNDO. /* Handle of compare procedure */
DEFINE VARIABLE glDynamicsRunning AS LOGICAL   NO-UNDO.
DEFINE VARIABLE glNoMessage       AS LOGICAL   NO-UNDO. /* Disbales the output of messages */
DEFINE VARIABLE glAppend          AS LOGICAL    NO-UNDO. /* Flag to indicate start and end of cycle */
DEFINE VARIABLE glInclude         AS LOGICAL    NO-UNDO.


{protools/_schdef.i }  /* TableDetails, FieldDetails, IndexDetails temp table definitions */

{adeuib/_tempdbtt.i}  /* ttTempDB definition. Used to construct browse */
{src/adm2/globals.i}


DEFINE STREAM tempdbStream.
DEFINE STREAM tempDBLog.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-availFld) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD availFld Procedure 
FUNCTION availFld RETURNS LOGICAL
  ( INPUT pcTblName AS CHARACTER, INPUT pcFldName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-availIdx) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD availIdx Procedure 
FUNCTION availIdx RETURNS LOGICAL
   ( INPUT pcTblName AS CHARACTER, INPUT pcIdxName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-availTbl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD availTbl Procedure 
FUNCTION availTbl RETURNS LOGICAL
   (INPUT pcTblName AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbconn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD dbconn Procedure 
FUNCTION dbconn RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FileReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD FileReadOnly Procedure 
FUNCTION FileReadOnly RETURNS LOGICAL
  ( pcFile AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDumpName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getDumpName Procedure 
FUNCTION getDumpName RETURNS CHARACTER
  ( pcName AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFld) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getFld Procedure 
FUNCTION getFld RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInclude) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getInclude Procedure 
FUNCTION getInclude RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIndx) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getIndx Procedure 
FUNCTION getIndx RETURNS CHARACTER
 ( INPUT pcTable AS CHARACTER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getLogFile Procedure 
FUNCTION getLogFile RETURNS LOGICAL
  ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTbl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD getTbl Procedure 
FUNCTION getTbl RETURNS CHARACTER
 ( /* parameter-definitions */ )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCompareHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setCompareHandle Procedure 
FUNCTION setCompareHandle RETURNS LOGICAL
  ( phHandle AS HANDLE )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInclude) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setInclude Procedure 
FUNCTION setInclude RETURNS LOGICAL
  ( plInclude AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogCompare) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogCompare Procedure 
FUNCTION setLogCompare RETURNS LOGICAL
  ( plLog AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogFile Procedure 
FUNCTION setLogFile RETURNS LOGICAL
  ( plLog AS LOG )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setLogFileName Procedure 
FUNCTION setLogFileName RETURNS LOGICAL
  ( pcFileName AS CHAR)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNoMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD setNoMessage Procedure 
FUNCTION setNoMessage RETURNS LOGICAL
  ( plNoMessage AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 33.95
         WIDTH              = 47.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

ASSIGN glDynamicsRunning = DYNAMIC-FUNCTION("IsICFRunning":U) NO-ERROR.
  IF glDynamicsRunning = ? THEN glDynamicsRunning = NO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-checkDBReference) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkDBReference Procedure 
PROCEDURE checkDBReference :
/*------------------------------------------------------------------------------
  Purpose:     Checks whether there is a TEMP-DB reference in any
               persistent program.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER plok AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE h          AS HANDLE    NO-UNDO. /* procedure handle */
  DEFINE VARIABLE i          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE dbEntry    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lChoice    AS LOGICAL   NO-UNDO.
  
  ASSIGN h  = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(h):
    IF NOT (h:FILE-NAME BEGINS "adetran") THEN 
    DO i = 1 TO NUM-ENTRIES(h:DB-REFERENCES):
      ASSIGN dbentry = ENTRY(i,h:DB-REFERENCES).
      IF dbentry EQ "TEMP-DB":U THEN
      DO:
         MESSAGE "The database TEMP-DB is currently in use by running procedure '" h:FILE-NAME "'"  skip(1)
                 "Making schema changes to TEMP-DB at this time will cause PROGRESS to initiate" SKIP
                 "a session restart causing all unsaved work to be lost." SKIP
                 IF plOK THEN "Action cannot be completed." ELSE ""
                 VIEW-AS ALERT-BOX WARNING.
         RETURN "ERROR":U.
      END.
    END.
    h = h:NEXT-SIBLING.
  END.
  
RETURN "".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkModified) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkModified Procedure 
PROCEDURE checkModified :
/*------------------------------------------------------------------------------
  Purpose:     Checks whether the  editor is modfied and prompts to save
  Parameters:  phEditor  Handle of editor in Temp Maintenance UI
  RETURN-VALUE:  ""           Editor was not modified
                 "CANCEL"     The save was cancelled
                 "CANCEL-SAVE" The save was selected but error occurred
                 "SAVE-OK"    The save was OK.
                 "NO-SAVE"    The user choose not to save the file     
      Notes:   Called from loadFile,NewFile in _tempdbEdit.w, and WIndowClose and 
               exit-object in _tempdb.w
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phEditor AS HANDLE     NO-UNDO.

DEFINE VARIABLE lOk       AS LOGICAL    NO-UNDO.

/* If file is modified prompt for save or cancel */
 IF phEditor:MODIFIED THEN
 DO:
    MESSAGE "The file has been modified. Do you wish to save the changes?"
        VIEW-AS ALERT-BOX QUESTION BUTTONS YES-NO-CANCEL
        UPDATE lchoice AS LOGICAL.
    CASE lChoice:
        WHEN TRUE THEN
        DO:
            RUN SaveProcess IN TARGET-PROCEDURE.
            IF RETURN-VALUE = "ERROR":U THEN
                RETURN "CANCEL-SAVE":U.
            ELSE
                RETURN "SAVE-OK":U.
        END.
        WHEN FALSE THEN
            RETURN "NO-SAVE":U.
        WHEN ? THEN
            RETURN "CANCEL":U. /* Undoes Row change. */
    END CASE.
 END.
 RETURN "".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-CheckSyntax) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CheckSyntax Procedure 
PROCEDURE CheckSyntax :
/*------------------------------------------------------------------------------
  Purpose:     Check syntax of a file without overwriting original file
  Parameters:  phEditor   Handle of Editor widget
               pcFile     Relative path of include file. Used only if Editor handle is ?
               plMessage  Display message of compile 
       OUTPUT  plok       YES  COmpiled succesfully
                           NO  Erros in compile
                           ?  Compile aborted
               
  Notes:      Called from UI action, and when saving, rebuilding or comparing file
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phEditor  AS HANDLE  NO-UNDO.
  DEFINE INPUT  PARAMETER pcFile    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plMessage AS LOGICAL NO-UNDO.
  DEFINE OUTPUT PARAMETER plOK      AS LOGICAL NO-UNDO.

  DEFINE VARIABLE hWindow       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lSaveOK       AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lCompStop     AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cCompFile     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cErrorFile    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lErrorFound   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hWidget       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFrame        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iErrorRow     AS INTEGER    NO-UNDO.
  DEFINE VARIABLE iErrorCol     AS INTEGER    NO-UNDO.
  
  
   SESSION:SET-WAIT-STATE("GENERAL":U).

   DO ON STOP UNDO, LEAVE:
     RUN adecomm/_tmpfile.p ( INPUT "" , INPUT ".cmp":U , OUTPUT cCompFile ).
    
    /* Create another editor widget to use Save-file method as 
       this causes the slick editor widget to lose it's color coding */
     CREATE FRAME hFrame.

     CREATE EDITOR hWidget
       ASSIGN FRAME = hFrame .

    IF VALID-HANDLE(phEditor) THEN
       ASSIGN hWidget:SCREEN-VALUE = phEditor:SCREEN-VALUE.
    ELSE
       hWidget:INSERT-FILE(pcFile).
    
    lSaveOK = hWidget:SAVE-FILE(cCompFile)  NO-ERROR.
   
    IF NOT lSaveOK OR ERROR-STATUS:NUM-MESSAGES > 0 THEN 
    DO:
        MESSAGE cCompFile SKIP
                "Unable to create compile file. Compilation cancelled."
            VIEW-AS ALERT-BOX ERROR BUTTONS OK.
        STOP.
    END.
  
    IF lSaveOK THEN 
    DO:
      COMPILEBLOCK:  
      DO ON ERROR UNDO, LEAVE COMPILEBLOCK
         ON STOP  UNDO, LEAVE COMPILEBLOCK
         ON QUIT  UNDO, LEAVE COMPILEBLOCK:
       COMPILE VALUE(cCompFile) NO-ERROR.
      END.
      lCompStop = COMPILER:STOPPED.
      IF lCompStop then 
      DO: 
          ASSIGN plOK = ?.
          STOP.
      END.
      ASSIGN lErrorFound = COMPILER:ERROR.
      IF lErrorFound THEN
         ASSIGN plOK         = NO
                cErrorFile   = COMPILER:FILENAME
                iErrorRow    = COMPILER:ERROR-ROW
                iErrorCol    = COMPILER:ERROR-COLUMN.
      ELSE
            plOK = YES.
           
        /* Display preprocessor and error messages, if any. */
      IF plMessage THEN 
      DO:
         IF lErrorFound THEN 
         DO:
            RUN adecomm/_errmsgs.p (INPUT CURRENT-WINDOW ,
                                    INPUT cErrorFile ,
                                    INPUT cCompFile ).
            IF VALID-HANDLE(phEditor) THEN
               ASSIGN phEditor:CURSOR-LINE = iErrorRow WHEN iErrorRow <> 0
                      phEditor:CURSOR-CHAR = iErrorCol WHEN iErrorCol <> 0.
         END.
         ELSE MESSAGE "Syntax is correct."
              VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
      END.
    END.
  END.  /* End Stop Block */
  
  DELETE WIDGET hWidget.
  DELETE WIDGET hFrame.
  OS-DELETE VALUE(cCompFile).
  SESSION:SET-WAIT-STATE("":U).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compareFile Procedure 
PROCEDURE compareFile :
/*------------------------------------------------------------------------------
  Purpose:    Compares the selected include files with the TEMP-DB tables and
              outputs all selected tables to an output screen
  Parameters:  pcInclude   Relative pathed name of file to be compared
               pcTable     Name of table to compare it to.
  Notes:       Called from compareLoop in _tempdb.w
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcInclude AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcTable   AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER pcResult  AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE lOK         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cTempFile   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTables     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cBufHandles AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRetValue   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cMessage    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hTempFile   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hTempDB     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
 
 DEFINE VARIABLE cCurTable   AS CHARACTER  NO-UNDO.

 /* Check that the TEMP-DB database is connected */
 RUN ConnectDB(OUTPUT lok).
 IF NOT lok THEN RETURN.

 ASSIGN glNoMessage = TRUE. /* Disable any display of message statements. */

 /* Check table is not blank */
 IF pcTable = "" OR pcTable = ? THEN
 DO:
    RUN logFile IN TARGET-PROCEDURE ( INPUT "Invalid Table", INPUT "The table specified for sourceFile '" + pcInclude + "' is invalid" ).
    RETURN "ERROR":U.
 END.
  
 /* Check if existing file is found  */
 FILE-INFO:FILE-NAME = pcInclude.
 IF FILE-INFO:FULL-PATHNAME = ? THEN
 DO:
     RUN logFile IN TARGET-PROCEDURE 
         ( INPUT "Include File Error", 
           INPUT "Include File '" + pcInclude + "' cannot be found in Propath.").
     RETURN "ERROR":U.
 END.
 
 /* Syntax Check */
 RUN CheckSyntax IN TARGET-PROCEDURE (?,pcInclude, NO, OUTPUT lOK).
 IF NOT lOK THEN 
 DO:
    RUN constructSyntaxError IN TARGET-PROCEDURE (OUTPUT cMessage).
    RUN logFile IN TARGET-PROCEDURE 
           ( INPUT "Compile Error",
             INPUT cMessage ).
    RETURN "ERROR":U.
 END.

  
 COMPARE_BLOCK:
 DO ON ERROR UNDO, LEAVE:
   RUN ParseFile IN TARGET-PROCEDURE  (INPUT pcInclude, OUTPUT cTables).  /* Parse file to extract table names). */
   cRetValue = RETURN-VALUE.
   IF cRetValue = "ERROR":U THEN
   DO:
       RUN constructSyntaxError IN TARGET-PROCEDURE (OUTPUT cMessage).
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "ParseFile":U, INPUT cMessage + CHR(10) + "Could not compile file!").   
       LEAVE COMPARE_BLOCK.    
   END.
   ELSE IF cTables = "" THEN
   DO:
       cRetValue = RETURN-VALUE.
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "ParseFile":U, INPUT "Could not detect any DEFINE TEMP-TABLE statements." ).   
       LEAVE COMPARE_BLOCK.
   END.
   
    /* Write out the include file along with code to return the buffer handles */
   RUN makeInclude IN TARGET-PROCEDURE (pcInclude, INPUT cTables, OUTPUT cTempFile).

   /* Run temp file which will return the temp-table handles in a string */
   RUN VALUE(cTempFile) PERSISTENT SET hTempFile (INPUT cTables,OUTPUT cBufHandles) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN
   DO:
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "RUN":U + pcInclude,
             INPUT "Source file '" + pcInclude + "' could not be run without error." + CHR(10) +
                  "Please ensure the source file is runnable on it's own.").
       cRetValue = "ERROR":U.
       LEAVE COMPARE_BLOCK.
   END.
  
   /* Run db aware program and then delete to remove and db references */
   RUN adeuib/_tempdbawarelib.p PERSISTENT SET hTempdb.
   IF NOT VALID-HANDLE(hTempDB) THEN UNDO.
   RUN compareBuffer IN hTempdb (INPUT cBufHandles, INPUT pcTable, OUTPUT pcResult).
   DELETE PROCEDURE hTempDB.
   
   IF pcResult > ""  THEN
     RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "compareBuffer":U, INPUT pcResult ).   
   ELSE
      RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "compareBuffer":U, INPUT "Exact Match"  ).   
   
   RUN addFilter IN TARGET-PROCEDURE.
 END.
 ASSIGN glNoMessage = FALSE.
 /* Delete the running isntance of the data definition file */
 IF VALID-HANDLE(hTempFile) THEN
   DELETE PROCEDURE hTempFile.
 /* Delete the temporary file */
 OS-DELETE VALUE(cTempFile).

 RETURN cRetValue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-connectDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE connectDB Procedure 
PROCEDURE connectDB :
/*------------------------------------------------------------------------------
  Purpose:    Checks wheteher the TEMP-DB database is connected. If not,
              prompts user to connect. This is called prior to any action 
              requiring a DB connection.
  Parameters:  plOK  (OUTPUT) YES, TEMP-DB is connected and valid.
                               NO  TEMP-DB is either not connected or not valid.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER plOK AS LOGICAL     NO-UNDO.

  DEFINE VARIABLE cChoice  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lDummy   AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Db_Pname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Db_Lname AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Db_Type  AS CHARACTER NO-UNDO.

  RUN checkDBReference IN THIS-PROCEDURE (YES).
  IF RETURN-VALUE = "ERROR":U THEN
     RETURN.
  ASSIGN Db_Pname = "TEMP-DB":U
         Db_Lname = ?
         Db_Type  = "PROGRESS".

  IF NOT CONNECTED("TEMP-DB":U) THEN
  DO:
    RUN adeuib/_advisor.w (
         INPUT "This action requires a connection to the 'TEMP-DB' database"
               + CHR(10) + "Would you like to connect to this database?",
         INPUT  "Co&nnect.  Connect to '" + 'TEMP-DB' + "' now.,_CONNECT,
&Cancel.  Do not start this utility.,_CANCEL" ,
         INPUT FALSE,
         INPUT "",
         INPUT 0,
         INPUT-OUTPUT cChoice,
         OUTPUT ldummy ).
     
    IF cChoice = "_CONNECT":U THEN
       RUN adecomm/_dbconn.p
            (INPUT-OUTPUT  Db_Pname,
             INPUT-OUTPUT  Db_Lname,
             INPUT-OUTPUT  Db_Type).
  END.

  IF NOT CONNECTED("TEMP-DB":U) THEN
  DO:
     plOK = FALSE.
     RETURN.
  END.

  RUN adeuib/_TempDBCheck.p (OUTPUT plOK).       
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-constructSyntaxError) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE constructSyntaxError Procedure 
PROCEDURE constructSyntaxError :
/*------------------------------------------------------------------------------
  Purpose:     Used to construct the syntax error 
  Parameters:  pcMessage   Message constructed
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAMETER pcMsg  AS CHARACTER  NO-UNDO.

&SCOPED-DEFINE PP-4345      4345    
&SCOPED-DEFINE MAX-DISPLAY  512
&SCOPED-DEFINE EOL          CHR(10)

DEFINE VARIABLE Error_Num   AS INTEGER       NO-UNDO.
DEFINE VARIABLE CurMsg      AS CHARACTER     NO-UNDO.
DEFINE VARIABLE i           AS INTEGER    NO-UNDO.

DO ON STOP UNDO, LEAVE:
    /* Display compiler messages. */
    DO Error_Num = 1 TO ERROR-STATUS:NUM-MESSAGES:
      ASSIGN pcMsg = pcMsg + {&EOL}.
      
      ASSIGN CurMsg = ERROR-STATUS:GET-MESSAGE( Error_Num ).
      /* Exclude temp-file from message */
      IF ERROR-STATUS:GET-NUMBER( Error_Num ) <> {&PP-4345} THEN
      DO i = 1 TO NUM-ENTRIES(CurMsg," "):
         IF INDEX(ENTRY(i,CurMsg," ":U),".cmp":U) > 0  THEN
            ENTRY(i,CurMsg," ") = "".
      END.
      ASSIGN pcMsg = pcMsg + CurMsg.
      IF LENGTH(pcMsg) > {&MAX-DISPLAY} THEN LEAVE.
    END.
        
    /* Get rid of the leading EOL. */
    ASSIGN pcMsg   = TRIM( pcMsg , CHR(10) ).
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dumpFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dumpFile Procedure 
PROCEDURE dumpFile :
/*------------------------------------------------------------------------------
  Purpose:     Dumps a data definition file into a temporary directory. The
               file is based on the data structure extracted from the 
               buffer handles passed in a delimited string
  Parameters:  pcBufHandles  Delimited list of buffer handles, corresponding to
                             temp-table buffer handles
               pcTables      List of tables to use to build .df file
               pcDropTables  Delimited list of tables to drop              
       OUTPUT  pcDumpFile    DumpFile created. If no buffer is valid, 
                             returns blank
  Notes:       Called from RunInclude 
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcBufHandles AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTables     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcDropTables AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDumpFile   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE i           AS INTEGER    NO-UNDO.
DEFINE VARIABLE j           AS INTEGER    NO-UNDO.
DEFINE VARIABLE k           AS INTEGER    NO-UNDO.
DEFINE VARIABLE hBuffer     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hfield      AS HANDLE     NO-UNDO.
DEFINE VARIABLE lCreated    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cIdxInfo    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hTempdb     AS HANDLE     NO-UNDO.
DEFINE VARIABLE lFoundTable AS LOGICAL    NO-UNDO.


RUN adecomm/_tmpfile.p
      (INPUT "", INPUT ".df":U, OUTPUT pcDumpFile).

OUTPUT STREAM TempDBStream TO VALUE(pcDumpFile) NO-ECHO NO-MAP.
PUT STREAM TempDBStream UNFORMATTED "UPDATE DATABASE ~"?~"" SKIP(2).

DO i = 1 TO NUM-ENTRIES(pcDropTables):
   ASSIGN lCreated = YES.
  PUT STREAM TempDBStream UNFORMATTED "DROP TABLE ":U QUOTER(ENTRY(i,pcDropTables)) SKIP(1).
END.

BUFFER_LOOP:
DO i = 1 TO NUM-ENTRIES(pcBufHandles):
   hBuffer = WIDGET-HANDLE(TRIM(ENTRY(i,pcBufHandles))) NO-ERROR.
   /* Put Table Definitions statements */
   
   IF NOT VALID-HANDLE(hBuffer) THEN
       NEXT BUFFER_LOOP.
   /* Ensure the table is in the list of valid tables */
   IF LOOKUP(hBuffer:TABLE,pcTables) = 0 THEN
      NEXT BUFFER_LOOP.

   /* Only add the DROP TABLE if the table exists */
   RUN adeuib/_tempdbawarelib.p PERSISTENT SET hTempdb.
   IF NOT VALID-HANDLE(hTempDB) THEN RETURN.
   lFoundTable = DYNAMIC-FUNCTION("canFindTable":U IN hTempdb, hBuffer:TABLE ).
   DELETE PROCEDURE hTempDB.

   IF lFoundTable THEN
      PUT STREAM TempDBStream UNFORMATTED "DROP TABLE ":U QUOTER(hBuffer:TABLE) SKIP(1).
   
   PUT STREAM TempDBStream UNFORMATTED "ADD TABLE ":U QUOTER(hBuffer:TABLE) SKIP.
   PUT STREAM TempDBStream UNFORMATTED "  DUMP-NAME ":U QUOTER(getDumpName(hBuffer:TABLE))  SKIP(1).
   ASSIGN lCreated = YES.

   FIELD_LOOP:
   DO j = 1 TO hBuffer:NUM-FIELDS:
      hField =  hBuffer:BUFFER-FIELD(j) NO-ERROR.
      IF NOT VALID-HANDLE(hField) THEN
        NEXT FIELD_LOOP.

      PUT STREAM TempDBStream UNFORMATTED
        "ADD FIELD " QUOTER(hField:NAME) 
        " OF " QUOTER(hBuffer:TABLE) 
        " AS " hField:DATA-TYPE  SKIP.

      PUT STREAM TempDBStream UNFORMATTED "  FORMAT ":U QUOTER(hField:FORMAT) SKIP.
      PUT STREAM TempDBStream UNFORMATTED "  INITIAL ":U QUOTER(TRIM(hField:DEFAULT-STRING)) SKIP .
      IF hField:LABEL <> ? THEN
        PUT STREAM TempDBStream UNFORMATTED "  LABEL ":U QUOTER(hField:LABEL) SKIP .
      IF hField:COLUMN-LABEL <> ? THEN
        PUT STREAM TempDBStream UNFORMATTED "  COLUMN-LABEL ":U QUOTER(hField:COLUMN-LABEL) SKIP .
      IF hField:VALIDATE-EXPRESSION <> ? AND hField:VALIDATE-EXPRESSION <> "" THEN
        PUT STREAM TempDBStream UNFORMATTED "  VALEXP ":U QUOTER(hField:VALIDATE-EXPRESSION) SKIP .
      IF hField:VALIDATE-MESSAGE <> ? AND hField:VALIDATE-MESSAGE  <> "" THEN
        PUT STREAM TempDBStream UNFORMATTED "  VALMSG ":U QUOTER(hField:VALIDATE-MESSAGE) SKIP .
      IF hField:HELP <> ? AND hField:HELP  <> "" THEN
        PUT STREAM TempDBStream UNFORMATTED "  HELP ":U QUOTER(hField:HELP) SKIP .
      IF hField:EXTENT > 0 THEN
        PUT STREAM TempDBStream UNFORMATTED "  EXTENT ":U hField:EXTENT  SKIP.
      IF hField:DECIMALS <> ? AND hField:DATA-TYPE = "DECIMAL":U THEN
        PUT STREAM TempDBStream UNFORMATTED "  DECIMALS ":U hField:DECIMALS  SKIP.
      PUT STREAM TempDBStream UNFORMATTED "  ORDER ":U j * 10  SKIP.
      IF hField:MANDATORY THEN
        PUT STREAM TempDBStream UNFORMATTED "  MANDATORY ":U  SKIP.
      IF hField:CASE-SENSITIVE THEN
        PUT STREAM TempDBStream UNFORMATTED "  CASE-SENSITIVE ":U  SKIP.
      IF hField:DATA-TYPE = "CLOB":U THEN
      DO:
        PUT STREAM TempDBStream UNFORMATTED '  CLOB-CODEPAGE "UTF-8"' SKIP.
        PUT STREAM TempDBStream UNFORMATTED '  CLOB-COLLATION "BASIC"'  SKIP.
        PUT STREAM TempDBStream UNFORMATTED '  CLOB-TYPE 1'SKIP.
      END.

      PUT STREAM TempDBStream UNFORMATTED SKIP(1).
   END.
   PUT STREAM TempDBStream UNFORMATTED SKIP.
   
   /* Build Index information */
   ASSIGN j = 1.
   INDEX_LOOP:
   DO WHILE hBuffer:INDEX-INFORMATION(j) <> ?:
      ASSIGN cIdxInfo = hBuffer:INDEX-INFORMATION(j)
             j        = j + 1.
      IF NUM-ENTRIES(cIdxInfo) LE 5 THEN
          NEXT INDEX_LOOP.
      PUT STREAM TempDBStream UNFORMATTED 
          "ADD INDEX ":U QUOTER(ENTRY(1,cIdxInfo)) " ON ":U QUOTER(hBuffer:TABLE)  SKIP.
      IF TRIM(ENTRY(2,cIdxInfo)) = "1":U THEN
        PUT STREAM TempDBStream UNFORMATTED "  UNIQUE":U SKIP.
      IF TRIM(ENTRY(3,cIdxInfo)) = "1":U THEN
        PUT STREAM TempDBStream UNFORMATTED "  PRIMARY":U SKIP.
      IF TRIM(ENTRY(4,cIdxInfo)) = "1":U THEN
        PUT STREAM TempDBStream UNFORMATTED "  WORD":U SKIP.
      DO k = 5 TO NUM-ENTRIES(cIdxInfo) BY 2:
        PUT STREAM TempDBStream UNFORMATTED "  INDEX-FIELD ":U  QUOTER(ENTRY(k,cIdxInfo))
           IF TRIM(ENTRY(k + 1, cIdxInfo)) = "0":U THEN " ASCENDING ":U ELSE " DESCENDING ":U .
        PUT STREAM TempDBStream UNFORMATTED SKIP.
      END.
      PUT STREAM TempDBStream UNFORMATTED SKIP(1).
   END. /* End Do While INDEX_INFORMATION <> ? */


END.
/* Trailer */
PUT STREAM TempDBStream UNFORMATTED "." SKIP.

i = SEEK(TempDBStream).

PUT STREAM TempDBStream UNFORMATTED "PSC" SKIP.
PUT STREAM TempDBStream UNFORMATTED "cpstream=utf-8" SKIP.
PUT STREAM TempDBStream  UNFORMATTED "." SKIP
  STRING(i,"9999999999":U) SKIP. /* location of trailer */

OUTPUT STREAM TempDBStream CLOSE.

/* If nothing is outputted to the file, then set value to blank */
IF NOT lcreated THEN
DO:
    OS-DELETE VALUE(pcDumpFile).
    ASSIGN pcDumpFile = "".
END.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EntityImportCheck) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EntityImportCheck Procedure 
PROCEDURE EntityImportCheck :
/*------------------------------------------------------------------------------
  Purpose:     Checks whether to perform an entity import
  Parameters:  pcTables  Comma delimitred list of tables being imported
  Notes:       Retrieves default values from registry. Called from UI action
                and SaveProcess
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTables AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE lImport     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE cValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cSection    AS CHARACTER  NO-UNDO INIT "ProAB":U.
  DEFINE VARIABLE lPrompt     AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE cSep        AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPrefix     AS INTEGER  NO-UNDO.
  DEFINE VARIABLE cModule     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cModuleDF   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cEntityType AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDFType     AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lgenerateDF AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lOverwrite  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE lassociate  AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE hRDM        AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOK         AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cErr        AS CHARACTER  NO-UNDO.

  ASSIGN hRDM = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, 
                                  INPUT "RepositoryDesignManager":U).

  GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityImport":U VALUE cValue.
  lImport = IF cValue EQ ? THEN FALSE ELSE CAN-DO ("true,yes,on",cValue).
   
  GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityPrompt":U VALUE cValue.
  lPrompt = IF cValue EQ ? THEN TRUE ELSE CAN-DO ("true,yes,on",cValue).

  IF NOT lImport OR lImport = ? THEN
    RETURN.

  {set NoMessage True}.
  IF NOT lPrompt THEN
  DO:
     GET-KEY-VALUE SECTION  cSection KEY "TempDBEntitySeparator":U VALUE cValue.
     cSep          = IF cValue EQ ? THEN "" ELSE cValue.

     GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityPrefix":U VALUE cValue.
     iPrefix       = IF cValue EQ ? THEN 0 ELSE INT(cValue).

     GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityModule":U VALUE cValue.
     cModule       = cValue. 
     IF cModule = "" OR cModule = ? THEN
       ASSIGN cModule = DYNAMIC-FUNC("getCurrentProductModule":U IN hRdm) 
              cModule = IF INDEX(cModule,"//":U) > 0 
                        THEN SUBSTRING(cModule,1,INDEX(cModule,"//":U) - 1)
                        ELSE cModule.

     GET-KEY-VALUE SECTION  cSection KEY "TempDBEntityType":U VALUE cValue.
     cEntityType   = IF cValue = ? OR cValue = "" 
                     THEN "Entity":U ELSE cValue. 

     GET-KEY-VALUE SECTION  cSection KEY "TempDBGenerateDF":U VALUE cValue.
     lgenerateDF   = IF cValue EQ ? THEN TRUE ELSE CAN-DO ("true,yes,on",cValue).

     GET-KEY-VALUE SECTION  cSection KEY "TempDBDFModule":U VALUE cValue.
     cModuleDF     = IF cValue = ? OR cValue = "" 
                     THEN cModule ELSE cValue. 
     
     GET-KEY-VALUE SECTION  cSection KEY "TempDBDFType":U VALUE cValue.
     cDFType       = IF cValue = ? OR cValue = "" 
                     THEN "DataField":U ELSE cValue. 

     GET-KEY-VALUE SECTION  cSection KEY "TempDBOverwriteAttr":U VALUE cValue.
     lOverwrite    = IF cValue EQ ? THEN TRUE
                      ELSE CAN-DO ("true,yes,on",cValue).

     GET-KEY-VALUE SECTION  cSection KEY "TempDBAssociateDF":U VALUE cValue.
     lassociate    = IF cValue EQ ? THEN TRUE
                      ELSE CAN-DO ("true,yes,on",cValue).
     RUN EntityProcess (INPUT pcTables     ,INPUT cSep        ,INPUT iPrefix     ,
                        INPUT cModule      ,INPUT cModuleDF   ,INPUT cEntityType ,
                        INPUT cDFType      ,INPUT lGenerateDF ,INPUT lOverwrite  ,
                        INPUT lAssociate   , OUTPUT lOK         
                       ).

     IF RETURN-VALUE = "" THEN
     DO:
       {set NoMessage True}.
       RUN LogFile IN TARGET-PROCEDURE 
            ( INPUT "_tempdbEntity":U ,
              INPUT "Entity Import successfully generated for table(s) '" + pcTables + "'").
       STATUS DEFAULT "Entity Import Complete".
     END.
     ELSE DO:
       RUN LogFile IN TARGET-PROCEDURE 
            ( INPUT "_tempdbEntity":U ,
              INPUT "Entity Import failed for table(s) '" + pcTables + "'").
     END.

  END.
  ELSE DO:
     RUN adeuib/_tempdbEntity.w (INPUT pcTables, OUTPUT lOK,OUTPUT cErr).
     IF lOK THEN
     DO:
        {set NoMessage True}.
        RUN LogFile IN TARGET-PROCEDURE 
            ( INPUT "_tempdbEntity":U ,
              INPUT IF cErr > "" THEN cErr 
                    ELSE "Entity Import successfully generated for table(s) '" + pcTables + "'").
       STATUS DEFAULT "Entity Import Complete".
     END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-EntityProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE EntityProcess Procedure 
PROCEDURE EntityProcess :
/*------------------------------------------------------------------------------
  Purpose:     RUNS APIs to import entities
  Parameters:  
  Notes:       Called from entityImportCheck
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTables     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcSep        AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER piPrefix     AS INTEGER    NO-UNDO.
  DEFINE INPUT  PARAMETER pcModule     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcModuleDF   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcEntityType AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDFType     AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER plGenerateDF AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plOverwrite  AS LOGICAL    NO-UNDO.
  DEFINE INPUT  PARAMETER plAssociate  AS LOGICAL    NO-UNDO.
  DEFINE OUTPUT PARAMETER plOK         AS LOGICAL    NO-UNDO.
  
  
  DEFINE VARIABLE cButton  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cError   AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cMessage AS CHARACTER   NO-UNDO.
  DEFINE VARIABLE hRDM     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hTempdb  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE lOK      AS LOGICAL     NO-UNDO.

  /* Check that the TEMP-DB database is connected */
  RUN ConnectDB(OUTPUT lok).
  IF NOT lok THEN RETURN.

   /* The separator should be either blank, a single character or Upper. */
   IF LENGTH(pcSep, "CHARACTER":U) GT 1          AND
      pcSep                        NE "Upper":U  THEN
   DO:
       RUN showMessages IN gshSessionManager (INPUT  "AF^5^" + LC(PROGRAM-NAME(1)) + ":" + LC(PROGRAM-NAME(2)) + "^" 
                                                             + 'field separator' + '|':u
                                                             + 'The field separator should be either blank, a single character or ~'Upper~''
                                                             +  CHR(4) + "?" + CHR(4) + "?" + CHR(4) + PROGRAM-NAME(1) 
                                                             + CHR(4) + PROGRAM-NAME(2),
                                              INPUT  "ERR":U,
                                              INPUT  "OK":U,
                                              INPUT  "OK":U,
                                              INPUT  "OK":U,
                                              INPUT  "Entity Mnemonic Import Complete",
                                              INPUT  YES,
                                              INPUT  TARGET-PROCEDURE,
                                              OUTPUT cButton               ).
       RETURN ERROR "ERROR":U.
   END.    /* separator incorrect. */

   SESSION:SET-WAIT-STATE("GENERAL":U).

   ASSIGN hRDM = DYNAMIC-FUNCTION("getManagerHandle":U IN THIS-PROCEDURE, INPUT "RepositoryDesignManager":U).
   IF NOT VALID-HANDLE(hRDM) THEN 
       ASSIGN cError = "AF^29^" + LC(PROGRAM-NAME(1)) + ":" + LC(PROGRAM-NAME(2)) + "^" 
                                                               + '"Repository Design Manager"' 
                                                               + '"he handle to the Repository design Manager is invalid. Entity import failed"ï"'
                                                               +  CHR(4) + "?" + CHR(4) + "?" + CHR(4) + PROGRAM-NAME(1) 
                                                               + CHR(4) + PROGRAM-NAME(2).

   /* First import DataFields */
   IF cError EQ "":U AND plGenerateDF THEN
   DO:
       RUN generateDataFields IN hRDM ( INPUT "TEMP-DB":U,                    /* pcDataBaseName */
                                        INPUT pcTables,                    /* pcTableName */
                                        INPUT TRIM(pcModuleDF),  /* pcProductModuleCode */
                                        INPUT "":U,                           /* pcResultCode */
                                        INPUT NO,                             /* plGenerateFromDataObject */
                                        INPUT "":U,                           /* pcDataObjectFieldList */
                                        INPUT "":U,                           /* pcSdoObjectName */
                                        INPUT pcDFType,          /* pcObjectTypeCode  */
                                        INPUT (IF plOverwrite THEN "*":U ELSE "":U),
                                        INPUT "*":U /* pcFieldNames */  ) NO-ERROR.
       IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
           ASSIGN cError = RETURN-VALUE.
   END.    /* Display datafields */
   
   IF cError EQ "":U THEN
   DO:
       RUN generateEntityObject IN hRDM ( INPUT ("TEMP-DB":U + CHR(3) + pcTables),
                                          INPUT pcEntityType,
                                          INPUT TRIM(pcModule),
                                          INPUT NO,
                                          INPUT piPrefix,
                                          INPUT pcSep,
                                          INPUT "N",
                                          INPUT "":U,      /* pcDescFieldQualifiers */
                                          INPUT "":U,      /* pcKeyFieldQualifiers  */
                                          INPUT "":U,      /* pcObjFieldQualifiers  */
                                          INPUT NO,        /* version_data */
                                          INPUT NO,        /* deploy_data */
                                          INPUT NO,        /* reuse_deleted_keys */
                                          INPUT plAssociate         /* plAssociateDataFields   */  ) NO-ERROR.
       IF ERROR-STATUS:ERROR OR RETURN-VALUE NE "":U THEN
           ASSIGN cError = RETURN-VALUE.
   END.    /* Import the Entities */

   /*Lastly, refresh the Repository cache, so the new entities are available to the session.
    * The entity menmonic cache is dependant on the Repository cache.                        */
   IF cError EQ "":U THEN
       RUN clearClientCache IN gshRepositoryManager.            

   SESSION:SET-WAIT-STATE("":U).

   IF cError EQ "":U THEN
   DO:
     ASSIGN cMessage           = "The entity mnemonic import completed successfully for table(s) '":U + pcTables + "'".
     RUN adeuib/_tempdbawarelib.p PERSISTENT SET hTempdb.
     IF NOT VALID-HANDLE(hTempDB) THEN UNDO.
     RUN updateEntity IN hTempdb (INPUT pcTables).
     DELETE PROCEDURE hTempDB.
     plOK = YES.
  END.
  
  RUN showMessages IN gshSessionManager (INPUT  IF cError EQ "":U THEN cMessage ELSE cError,
                                         INPUT  IF cError EQ "":U THEN "MES":U ELSE "ERR":U,
                                         INPUT  "&OK":U,
                                         INPUT  "&OK":U,
                                         INPUT  "&OK":U,
                                         INPUT  "Entity Mnemonic Import ":U,
                                         INPUT  YES,
                                         INPUT  TARGET-PROCEDURE,
                                         OUTPUT cButton           ).

  ASSIGN ERROR-STATUS:ERROR = NO.
  RETURN cError.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFieldDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getFieldDetails Procedure 
PROCEDURE getFieldDetails :
/*------------------------------------------------------------------------------
  Purpose: This procedure accepts a temp-table with a record for the
           currently selected field.  It calls _getfld which poplulates
           the temp-table with the field details to display in the Field
           Detail window.     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR FieldDetails.

  CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME("TEMP-DB":U)).
  RUN protools/_getfld.p (INPUT "PROGRESS":U, INPUT "TEMP-DB", INPUT-OUTPUT TABLE FieldDetails).
  DELETE ALIAS tinydict.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIndexDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIndexDetails Procedure 
PROCEDURE getIndexDetails :
/*------------------------------------------------------------------------------
  Purpose: This procedure accepts a temp-table with a record for the
           currently selected field.  It calls _getidx which poplulates
           the temp-table with the index details to display in the Index
           Detail window.         
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR IndexDetails.
  DEFINE OUTPUT PARAMETER TABLE FOR IndxFldDetails.

  CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME("TEMP-DB":U)).
  RUN protools/_getidx.p (INPUT "PROGRESS":U, INPUT "TEMP-DB":U, INPUT-OUTPUT TABLE IndexDetails, OUTPUT TABLE IndxFldDetails).
  DELETE ALIAS tinydict.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getPref) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPref Procedure 
PROCEDURE getPref :
/*------------------------------------------------------------------------------
  Purpose:     gets the log file preferences.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE cValue    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cSection  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDel      AS CHARACTER  NO-UNDO INIT "|".
 DEFINE VARIABLE lUseLog   AS LOGICAL     NO-UNDO.

 ASSIGN cSection = "ProAB":U.
 GET-KEY-VALUE SECTION cSection KEY "TempDBUseLogFile":U VALUE cValue.
 lUseLog = IF cValue EQ ? THEN TRUE
            ELSE CAN-DO ("true,yes,on",cValue).

 IF lUseLog THEN
 DO:
    GET-KEY-VALUE SECTION cSection KEY "TempDBLogFile":U VALUE cValue.
    IF cValue = ? THEN 
       ASSIGN FILE-INFO:FILE-NAME = "."
              gcLogFile = FILE-INFO:FULL-PATHNAME  + "~\" + "Temp-dbLog.txt":U .
    ELSE 
       ASSIGN gcLogFile = cValue.
 
 END.
 .

{Set LogFile lUseLog}.
{set LogFileName gcLogFile}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTableDetails) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTableDetails Procedure 
PROCEDURE getTableDetails :
/*------------------------------------------------------------------------------
  Purpose: This procedure accepts a temp-table with a record for the
           currently selected table.  It calls _gettbl which poplulates
           the temp-table with the table details to display in the Table
           Detail window.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER TABLE FOR TableDetails.

  CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME("TEMP-DB":U)).
  RUN protools/_gettbl.p (INPUT "PROGRESS":U, INPUT "TEMP-DB":U, INPUT-OUTPUT TABLE TableDetails).
  DELETE ALIAS tinydict.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeObject) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeObject Procedure 
PROCEDURE initializeObject :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN SUPER.

RUN getPref.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-InsertDBFields) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InsertDBFields Procedure 
PROCEDURE InsertDBFields :
/*------------------------------------------------------------------------------
  Purpose:     Prompts user for fields and insert into editor
  Parameters:  phEditor  Handle of editor in main UI window
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phEditor AS HANDLE     NO-UNDO.

DEFINE VARIABLE lOK        AS LOGICAL  NO-UNDO.

RUN adecomm/_fldsel.p
    ( INPUT TRUE /* p_Multi */ ,
      INPUT ?    /* data type */ ,
      INPUT ? ,
      INPUT-OUTPUT gcSchemaPrefix ,
      INPUT-OUTPUT gcSchemaDatabase ,
      INPUT-OUTPUT gcSchemaTable ,
      INPUT-OUTPUT gcSchemaFlds ,
      OUTPUT lok )   NO-ERROR.
 
 /* Paste a space-delimited list of chosen fields */
 IF lok THEN 
 DO:
   IF phEditor:TEXT-SELECTED THEN 
     phEditor:REPLACE-SELECTION-TEXT(gcSchemaFlds). /* Text selected: replace it. */
   ELSE 
     phEditor:INSERT-STRING( gcSchemaFlds ).   
   
   APPLY "ENTRY" TO phEditor.
 END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insertDBTableDef) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insertDBTableDef Procedure 
PROCEDURE insertDBTableDef :
/*------------------------------------------------------------------------------
  Purpose:     Prompts user for table and inserts Table definition
               into editor
  Parameters:  phEditor  Editor Handle
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER phEditor AS HANDLE     NO-UNDO.
  
  DEFINE VARIABLE lOK  AS LOGICAL  NO-UNDO.
  DEFINE VARIABLE cDef AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lLOB AS LOGICAL    NO-UNDO.

  RUN adecomm/_tblsel.p
      ( INPUT FALSE /* p_Multi */ ,
        INPUT "_ttmaint.w"    /* data type */ ,
        INPUT-OUTPUT gcSchemaDatabase ,
        INPUT-OUTPUT gcSchemaTable ,
        OUTPUT lok )   NO-ERROR.
   
   /* Paste a space-delimited list of chosen fields */
   IF lok THEN 
   DO:
      CREATE ALIAS tinydict FOR DATABASE VALUE(gcSchemaDatabase).
      RUN protools/_getTblFldIdx.p 
          (INPUT "PROGRESS", INPUT ?, INPUT gcSchemaTable,
           OUTPUT TABLE TableDetails,
           OUTPUT TABLE FieldDetails,
           OUTPUT TABLE IndexDetails,
           OUTPUT TABLE IndxFldDetails).
      DELETE ALIAS tinydict.
      
      /* Construct temp-table definitions statemenet */
      FOR EACH FieldDetails BY tOrder:
          IF FieldDetails.datatype = "CLOB":U OR FieldDetails.datatype = "BLOB":U THEN
              lLOB = TRUE.
          ASSIGN cDef = cDef + "   FIELD " + FieldDetails.fldName 
             + " AS " + CAPS(FieldDetails.datatype) 
             + (IF FieldDetails.tLabel > "" THEN " LABEL ~"" + FieldDetails.tLabel + "~"" ELSE "")
             + (IF FieldDetails.tformat > "" THEN " FORMAT ~"" + FieldDetails.tformat + "~"" ELSE "")
             + (IF FieldDetails.initval > "" THEN " INITIAL ~"" + FieldDetails.initval + "~"" ELSE "") 
             + (IF FieldDetails.tdec > 0 THEN " DECIMALS " + STRING(FieldDetails.tdec) ELSE "") 
             + (IF FieldDetails.textent > 0 THEN " EXTENT " + STRING(FieldDetails.textent) ELSE "")  
             + (IF FieldDetails.casesensitive THEN " CASE-SENSITIVE " ELSE "")
             + CHR(10)
             + (IF FieldDetails.viewas > "" THEN FieldDetails.viewas + CHR(10) ELSE "") 
          NO-ERROR.
      END.
      /* Assign NO-UNDO if there is a clob or blob field */
      IF lLOB THEN 
         ASSIGN cDef = "DEFINE TEMP-TABLE ":U + gcSchemaTable + " NO-UNDO ":U + CHR(10) + cDef.
      ELSE
         ASSIGN cDef = "DEFINE TEMP-TABLE ":U + gcSchemaTable + CHR(10) + cDef.
      /* Construct Indexes */
      FOR EACH IndexDetails WHERE IndexDetails.lActive:
         IF IndexDetails.idxname = "default":U THEN
             NEXT.
         ASSIGN cDef = cDef + "      INDEX " + IndexDetails.idxName .
         IF IndexDetails.lPrimary OR IndexDetails.lUnique OR IndexDetails.lwordIndex THEN
             ASSIGN cDef = cDef + " IS ":U
                                + (IF IndexDetails.lPrimary THEN "PRIMARY ":U ELSE "")
                                + (IF IndexDetails.lUnique  THEN "UNIQUE ":U ELSE "")
                                + (IF IndexDetails.lwordIndex  THEN "WORD-INDEX ":U ELSE "").
         ASSIGN cDef = cDef + CHR(10).
         FOR EACH IndxFldDetails WHERE IndxFldDetails.idxname = IndexDetails.idxname BY idxseq:
             ASSIGN cDef = cDef + "        " + IndxFldDetails.fldname 
                                + (IF NOT IndxFldDetails.lAsc THEN " DESCENDING " ELSE "")
                                + CHR(10).
         END. /* End for each IndexDetails */
      END. /* End for each Index */
      ASSIGN cDef = cDef + "      .".

      IF phEditor:TEXT-SELECTED THEN 
        phEditor:REPLACE-SELECTION-TEXT( cDef ). /* Text selected: replace it. */
      ELSE 
        phEditor:INSERT-STRING( cDef ).   
      
      APPLY "ENTRY" TO phEditor. 
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-InsertNewFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE InsertNewFile Procedure 
PROCEDURE InsertNewFile :
/*------------------------------------------------------------------------------
  Purpose:     Prompts users for filename (for new file) and saves the file to disk
  Parameters:  phEditor     Widget handle of Editor containing source file
      OUTPUT   pcNewFIle    Name of New file created         
      OUTPUT   lOK         YES  File Saved 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phEditor   AS HANDLE     NO-UNDO.

DEFINE VARIABLE hProc      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hFileLabel AS HANDLE     NO-UNDO.
DEFINE VARIABLE lOK        AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cFileName  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRelFile   AS CHARACTER   NO-UNDO.

SYSTEM-DIALOG GET-FILE cFileName
     TITLE   "Get File"
     FILTERS "Includes(*.i)" "*.i":U,"Procedures(*.p)" "*.p":U,"All Source(*.p~;*.w~;*.i)" "*.*":U
     USE-FILENAME DEFAULT-EXTENSION "i":U
     UPDATE lOK .
    IF lOK <> TRUE THEN 
        RETURN "CANCEL":U.

IF lOK THEN
DO:
  /* Check that the file is in the PROPATH */
  RUN adecomm/_relname.p (cFileName, "MUST-BE-REL":U,
                          OUTPUT cRelFile).
  IF cRelFile = ? THEN
  DO:
      MESSAGE "The selected file '" cFileName "' is not located within your PROPATH." SKIP
              "Please ensure that any file selected can be located in your PROPATH."
              VIEW-AS ALERT-BOX WARNING.
      RETURN.
              
  END.


  {get EditorProc hProc}.
  {get FileLabel hFileLabel}.
   RUN NewFile IN hProc.
   phEditor:INSERT-FILE(cFileName) .  /* Load file into editor */
 
  /* Clear the undo state so that the insert of the file isn't cleared on undo. */
  ASSIGN phEditor:EDIT-CAN-UNDO = FALSE 
         phEditor:MODIFIED      = FALSE
         phEditor:CURSOR-LINE   = 1
         hFileLabel:SCREEN-VALUE = cFileName.

  RETURN "".
END.
ELSE
   RETURN "ERROR":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-insert_file) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE insert_file Procedure 
PROCEDURE insert_file :
/*--------------------------------------------------------------------------
    Purpose:        Ask the user for a file name and put its name or
                    contents in the phEditor editor widget.

    Run Syntax:     RUN insert_file ( INPUT p_Mode, INPUT phEditor ).

    Parameters:     INPUT  p_Mode       CHAR - "NAME" or "CONTENTS"
                    INPUT  phEditor     WIDGET-HANDLE
                    Edit Buffer handle to insert file into.
  ---------------------------------------------------------------------------*/

  DEFINE INPUT PARAMETER p_Mode   AS CHAR NO-UNDO .
  DEFINE INPUT PARAMETER phEditor AS WIDGET-HANDLE NO-UNDO .

  DEFINE VARIABLE Absolute_File  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE File_Name      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lOK            AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE Insert_File    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE Save-CW        AS HANDLE    NO-UNDO.
  DEFINE VARIABLE vTitle         AS CHARACTER NO-UNDO.  
  DEFINE VARIABLE File_Filters   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cKeyValue      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDirList       AS CHARACTER  NO-UNDO.
  
  IF phEditor:READ-ONLY THEN RETURN.

  GET-KEY-VALUE SECTION "ProAB":U KEY "CodeListDirectories" VALUE cKeyValue.
  IF cKeyValue eq ? THEN
    cKeyValue = "src/template,.".  /* templates AND current directory */

  ASSIGN 
    cDirList       = cKeyValue
    vTitle         = "Insert File " + IF p_Mode = "NAME" THEN "Name" ELSE "Contents" 
    save-cw        = current-window
  /*  current-window = h_sewin */ .

  /* Insert file name found on remote WebSpeed agent. */
  File_Filters = 
      "Includes & Procedures (*.i,*.p)|*.i,*.p|Windows & Export (*.w,*.wx)|*.w,*.wx|All Files|*.*":U.  
    RUN adecomm/_fndfile.p (INPUT vTitle,                   /* pTitle         */
                            INPUT "TEXT",                   /* pMode          */
                            INPUT File_Filters,             /* pFilters       */
                            INPUT-OUTPUT cDirList,         /* pDirList       */
                            INPUT-OUTPUT insert_File,       /* pFileName      */
                            OUTPUT Absolute_File,        /* pAbsoluteFileName */
                            OUTPUT lOK).                  /* pOK            */
  
  
/*   ASSIGN CURRENT-WINDOW = Save-CW. */
    
  IF lOK THEN DO:
    IF p_Mode eq "NAME":U THEN
    DO:
      /* Change backslash to forward slash for UNIX compatibility. */
      ASSIGN Insert_File = REPLACE(Insert_File, "~\":U, "/":U).
      
      IF ( phEditor:TEXT-SELECTED )
      THEN phEditor:REPLACE-SELECTION-TEXT(Insert_File). /* Text selected: replace it. */
      ELSE phEditor:INSERT-STRING(Insert_File). 
    END.
    ELSE DO:
      ASSIGN lOK = phEditor:INSERT-FILE( Insert_File ) NO-ERROR.
      IF ( lOK eq NO ) THEN
        MESSAGE (Insert_File) SKIP
                 "Unable to find or open file." SKIP(1)
                 "The file may not exist or may be too large" SKIP
                 "to insert into the current buffer."
                 VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    END.
    /* Write the added directory to the registry. */
    IF cDirList <> cKeyValue THEN 
       PUT-KEY-VALUE SECTION "ProAB":U KEY "CodeListDirectories" VALUE cDirList.
 
  END.
  APPLY "ENTRY":U TO phEditor .
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-loadFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE loadFile Procedure 
PROCEDURE loadFile :
/*------------------------------------------------------------------------------
  Purpose:     Loads the data definition file into the TEMP-DB database.
  Parameters:  pcLoadFile    Name of file to load 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcLoadFile AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER plError    AS LOGICAL   NO-UNDO.

  DEFINE VARIABLE hWindow     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hOrigWindow AS HANDLE     NO-UNDO.
  DEFINE VARIABLE iMsgCount   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDB         AS CHARACTER  NO-UNDO.

  DO ON ERROR UNDO, LEAVE
     ON STOP  UNDO, LEAVE:
  
    CREATE WINDOW hWindow.
    ASSIGN  hOrigWIndow    = CURRENT-WINDOW
            CURRENT-WINDOW = hWindow.

    ASSIGN cDB =  LDBNAME("DICTDB").

    CREATE ALIAS VALUE("DICTDB":U) FOR DATABASE "TEMP-DB":U.

   /* Check how many message the client issued before running the 
      load process. Counter will be pointing to the next position 
      in the message queue */
    REPEAT:
       IF _msg(iMsgCount) > 0 THEN
         ASSIGN iMsgCount = iMsgCount + 1.
       ELSE
          LEAVE.
    END.

    RUN prodict/load_df.p (INPUT pcLoadFile) NO-ERROR.
    ASSIGN plError = ( _msg(iMsgCount) > 0 ).
  END.
  IF cDB > "" AND cDB <> "TEMP-DB":U THEN
    CREATE ALIAS "DICTDB" FOR DATABASE VALUE(LDBNAME(cDB)) NO-ERROR.

  IF VALID-HANDLE(hWindow) THEN
      DELETE WIDGET hWindow.
  IF VALID-HANDLE(hOrigWindow) THEN
      CURRENT-WINDOW = hOrigWindow.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-logFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE logFile Procedure 
PROCEDURE logFile :
/*------------------------------------------------------------------------------
  Purpose:     Central point for logging actions to log file, or to
               write to compare window
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcSection AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcMessage AS CHARACTER  NO-UNDO.

DEFINE VARIABLE hParent AS HANDLE     NO-UNDO.

/* Write to log file if enabled, else display error message */
IF glLogFile THEN
   RUN WriteLog (INPUT pcSection, INPUT pcMessage).

IF NOT glNoMessage THEN
  MESSAGE pcMessage
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

/* Write out compare results to compare window */
IF glLogCompare THEN
DO:
   IF NOT VALID-HANDLE(ghCompare) THEN 
   DO:
      RUN adeuib/_tempdbcomp.w PERSISTENT SET ghCompare .
      {get ContainerHandle hParent}.
      RUN setParent IN ghCompare (hParent).
   END.
   RUN WriteToEditor IN ghCompare (pcMessage).
   
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-makeInclude) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE makeInclude Procedure 
PROCEDURE makeInclude :
/*------------------------------------------------------------------------------
  Purpose:     Used to construct a temporary file containing the passed include 
               file. Also constructs code to return the handles of the temp-table
               buffers in a comma delimited string. This file is later RUN to return 
               those values.
               
  Parameters:  pcFile   Include file
               pcTables Comma delimtied list of temp-table definitions within source 
                        file
       OUTPUT  pcTempFIle  Output file         
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFile     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTables   AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcTempFile AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTableName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i          AS INTEGER    NO-UNDO.

RUN adecomm/_tmpfile.p
      (INPUT "", INPUT ".ab", OUTPUT pcTempFile).

OUTPUT STREAM TempDBStream TO VALUE(pcTempFile) NO-MAP.

PUT STREAM TempDBStream UNFORMATTED 
 "DEFINE INPUT PARAMETER pcTempDBTablesAB      AS CHAR NO-UNDO." SKIP 
 "DEFINE OUTPUT PARAMETER pcTempDBBufHandlesAB AS CHAR NO-UNDO." SKIP(2)  
 
 "DEFINE VARIABLE hTempDBBufferAB  AS HANDLE  NO-UNDO." SKIP(2).

PUT STREAM TempDBStream UNFORMATTED "~{" pcFile "~}" SKIP(2).

DO i = 1 TO NUM-ENTRIES(pcTables):
   cTableName = ENTRY(i,pcTables).
   PUT STREAM TempDBStream UNFORMATTED 
  "hTempDBBufferAB = TEMP-TABLE " cTableName ":HANDLE:DEFAULT-BUFFER-HANDLE no-error." SKIP
  "IF VALID-HANDLE(hTempDBBufferAB) THEN " SKIP
 "    ASSIGN pcTempDBBufHandlesAB = pcTempDBBufHandlesAB + (IF pcTempDBBufHandlesAB = '' THEN '' ELSE ',')" SKIP
 "                                                     + STRING(hTempDBBufferAB)." SKIP
 " ELSE ASSIGN pcTempDBBufHandlesAB = pcTempDBBufHandlesAB + (IF pcTempDBBufHandlesAB = '' THEN '' ELSE ',')" SKIP
 "                                                       + '?'." SKIP .
END.


OUTPUT STREAM TempDBStream CLOSE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-ParseFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ParseFile Procedure 
PROCEDURE ParseFile :
/*------------------------------------------------------------------------------
  Purpose:    Parses file and extracts all temp-table definitions
  Parameters: pcFileName   Name of file to parse
      OUTPUT  pcTables    Comma delimited list of tables extracted
  
  Notes:     The code will search for the key word TEMP-TABLE not contained
             within comments. The name following that key word (excluding NEW,
             GLOBAL and SHARED) will be extracted. Since the temp-table following
             the TEMP-TABLE statement can be defined on another line, this will 
             also be considered.
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcTables    AS CHARACTER  NO-UNDO.

&SCOPED-DEFINE sourcefile pcFilename
&SCOPED-DEFINE streamname tempdbStream
&SCOPED-DEFINE tables pcTables
&SCOPED-DEFINE returnerror 'ERROR':U

{adeuib/parsedefs.i}

&UNDEFINE sourcefile 
&UNDEFINE streamname 
&UNDEFINE tables 
&UNDEFINE returnerror  
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rebuildFromFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildFromFile Procedure 
PROCEDURE rebuildFromFile :
/*------------------------------------------------------------------------------
  Purpose:     Rebuilds the TEMPDB database table from the specified include file.
  Parameters:  pcFile   SOurce file
  Notes:       Called from rebuildLoop in _tempdb.w and rebuildImport
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcFile    AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER plRebuild AS LOGICAL    NO-UNDO.

 DEFINE VARIABLE lOK         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cTables     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDropTables AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTempFile   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hFileLabel  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cDumpFile   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cMessage    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRetValue   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRelFile   AS CHARACTER  NO-UNDO.
 
 /* Check that the TEMP-DB database is connected */
 RUN ConnectDB(OUTPUT lok).
 IF NOT lok THEN RETURN.

 glNoMessage = FALSE.
 /* Check if existing file is found  */
 FILE-INFO:FILE-NAME = pcFile.
 IF FILE-INFO:FULL-PATHNAME = ? THEN
 DO:
     cMessage = "File '" + pcFile + "' cannot be found on disk".
     RUN LogFile IN TARGET-PROCEDURE 
         ( INPUT "RebuildFromFile":U,
           INPUT cMessage ).
     RETURN "ERROR-":U + cMessage.
 END.

 /* Check that file is in relative path. Otherwise cannot save file */
 RUN adecomm/_relname.p (pcFile,"MUST-BE-REL",OUTPUT cRelFile).
 IF cRelFile = ? THEN
  DO:
     cMessage = "File '" + pcFile + "' cannot be found in Propath.".
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "RebuildFromFile":U,
             INPUT cMessage ).
       RETURN "ERROR-":U + cMessage.
 END.

 /* Syntax Check */
 RUN CheckSyntax IN TARGET-PROCEDURE (INPUT "", INPUT pcFile, INPUT NO, OUTPUT lOK).
 IF NOT lOK THEN 
 DO:
    RUN constructSyntaxError IN TARGET-PROCEDURE (OUTPUT cMessage).
    RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "CheckSyntax":U,
             INPUT cMessage ).
    RETURN "ERROR-":U + cMessage .
 END.
 
REBUILD_BLOCK:
 DO ON ERROR UNDO, LEAVE:
     /* Parse file */  
   RUN ParseFile IN TARGET-PROCEDURE  (INPUT pcFile, OUTPUT cTables).  /* Parse file to extract table names). */
   cRetValue = RETURN-VALUE.
   IF cRetValue BEGINS "ERROR":U THEN
   DO:
       RUN constructSyntaxError IN TARGET-PROCEDURE (OUTPUT cMessage).
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "ParseFile":U, INPUT cMessage ).   
       cRetValue = "ERROR-" + cMessage.
       LEAVE REBUILD_BLOCK.    
   END.
   ELSE IF cTables = "" THEN
   DO:
       cMessage = "Could not detect any DEFINE TEMP-TABLE statements in file '" + pcFIle + "'". 
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "ParseFile":U, INPUT cMessage ).   
       cRetValue = "ERROR-" + cMessage.
       LEAVE REBUILD_BLOCK.
   END.
   
   /* Perform Rebuild verification and dump file only */
   RUN RunInclude IN TARGET-PROCEDURE  (INPUT cTables, INPUT pcFile, INPUT pcFile, OUTPUT cDropTables, OUTPUT cDumpFile).
   IF RETURN-VALUE BEGINS "ERROR":U THEN
   DO:
     cRetValue = RETURN-VALUE.
     LEAVE REBUILD_BLOCK.
   END.

   RUN RebuildTempDB IN TARGET-PROCEDURE (INPUT cTables, INPUT pcFile, INPUT cDropTables, INPUT cDumpFile).
   IF RETURN-VALUE BEGINS "ERROR":U THEN
   DO:
      cRetValue = RETURN-VALUE.
      LEAVE REBUILD_BLOCK.
   END.

   glNoMessage = TRUE.
   /* Log that file sucessfuly rebuilt */
   RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "Rebuild":U, 
             INPUT (IF NUM-ENTRIES(cTables) = 1 
                    THEN "Table '" + cTables + "' was "
                    ELSE "Tables '" + cTables + "' were ")
                    + "rebuilt from source file '" + pcFile + "'").  
   IF plRebuild THEN
      RUN rebuildBrowse IN TARGET-PROCEDURE NO-ERROR.
 END. /* End REBUILD_BLOCK */

 OS-DELETE VALUE(cTempFile).
 RETURN cRetValue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RebuildImport) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RebuildImport Procedure 
PROCEDURE RebuildImport :
/*------------------------------------------------------------------------------
  Purpose:     Called when multiple source files are fetched for rebuild
  Parameters:  pcList Comma delimited list of source files
  Notes:       Called from rebuildfromList in _tempdbImport.w
               Called from save Hook in uibmproe.i
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcList AS CHARACTER  NO-UNDO.

DEFINE VARIABLE i        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cErrList AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOK      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE lRebuild AS LOGICAL     NO-UNDO.

/* Check that the TEMP-DB database is connected */
 RUN ConnectDB(OUTPUT lok).
 IF NOT lok THEN RETURN.

SESSION:SET-WAIT-STATE("general":U).

lRebuild = IF PROGRAM-NAME(2) MATCHES "*_TempDBImport*" THEN TRUE ELSE FALSE.
   

RUN StartLog IN TARGET-PROCEDURE.
IF glLogFile THEN
  glNoMessage = TRUE.
DO i = 1 TO NUM-ENTRIES(pcList):
    RUN RebuildFromFile IN TARGET-PROCEDURE (ENTRY(i,pcList), lrebuild).
    IF RETURN-VALUE BEGINS "ERROR":U THEN
       cErrList = cErrList + (IF cErrList = "" THEN "" ELSE ",") 
                     + ENTRY(i,pcList).
END.
IF glLogFile THEN
  glNoMessage = FALSE.

SESSION:SET-WAIT-STATE("":U).

IF cErrList > "" AND glLogFile THEN
DO:
  MESSAGE "An error has occured when rebuilding TEMP-DB for file(s) '" + cErrList + "'" SKIP
          "Please check the log file for more info."
      VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
ELSE IF glDynamicsRunning THEN
  RUN EntityImportCheck IN TARGET-PROCEDURE (pcList).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-rebuildTempDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE rebuildTempDB Procedure 
PROCEDURE rebuildTempDB :
/*------------------------------------------------------------------------------
  Purpose:     Rebuilds the temp-db databse based on a specified file.
  Parameters:  pcTables   Comma delimited list of tables to rebuild
               pcFile     Name of Source File
               pcDropTables Name of tables to be dropped
               pcDumpFile Name dump file to load
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTables     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFile       AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcDropTables AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcDumpFile   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE lError    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cRetValue AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hTempdb   AS HANDLE     NO-UNDO.
DEFINE VARIABLE lOK       AS LOGICAL     NO-UNDO.

/* Check that the TEMP-DB database is connected */
RUN ConnectDB(OUTPUT lok).
IF NOT lok THEN RETURN.

RUN adecomm/_setcurs.p ("WAIT":U).

trn-blk:
DO ON ERROR UNDO,LEAVE
               ON STOP UNDO,LEAVE:
    
    RUN adeuib/_tempdbawarelib.p PERSISTENT SET hTempdb.
    IF NOT VALID-HANDLE(hTempDB) THEN STOP.
    RUN buildControlFile IN hTempDB (INPUT pcTables, INPUT pcFile, 
                                     INPUT pcDropTables, INPUT glInclude). 
    DELETE PROCEDURE hTempDB.
   
    RUN loadFile IN TARGET-PROCEDURE (pcDumpFile, OUTPUT lError) NO-ERROR.
    IF lError THEN
    DO: 
       cRetValue = "ERROR":U.
       UNDO trn-blk, LEAVE trn-blk.
    END.
END.


/* Delete the data definition file */
OS-DELETE VALUE(pcDumpFile).    
RUN adecomm/_setcurs.p ("":U).
RETURN cRetValue.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-RunInclude) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RunInclude Procedure 
PROCEDURE RunInclude :
/*------------------------------------------------------------------------------
  Purpose:     Verifies the source file prior to updating the temp-db database.
               Writes out include file to temp file and then runs it which returns
               a list of buffer handles. It then checks the control file for conflicts
               and then runs the dumpFile routine which dumps the file to a temporary 
               .df file and returns that file.
               
  Parameters:  pcTables     Comma delimited list of tables to rebuild
               pcFile       Name of Source File (This is a temporary file when creating a new file)
               pcInclude    Name of Include FIle
               plDump       Perform the dumping of the file to a .df file
      OUTPUT   pcDropTables List of tables to drop in the .df
               pcDumpFile   Name of DumpFile created          
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTables     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFile       AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcInclude    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDropTables AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER pcDumpFile   AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cConflictTables  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempFile        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cBufHandles      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hTempFile        AS HANDLE     NO-UNDO.
DEFINE VARIABLE i                AS INTEGER    NO-UNDO.
DEFINE VARIABLE cRetValue        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cMessage         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hTempDB          AS HANDLE     NO-UNDO.

RUN adecomm/_setcurs.p ("WAIT":U).

VERIFY_BLOCK:
DO ON ERROR UNDO, LEAVE:
   /* Write out the include file along with code to return the buffer handles */
   RUN makeInclude IN TARGET-PROCEDURE (pcFile, INPUT pcTables, OUTPUT cTempFile).

   /* Run temp file which will return the temp-table handles in a string */
   RUN VALUE(cTempFile) PERSISTENT SET hTempFile (INPUT pcTables,OUTPUT cBufHandles) NO-ERROR.
   IF ERROR-STATUS:ERROR THEN
   DO:
       cmessage = "Source file '" + pcFile + "' could not be run without error." + CHR(10) +
                  "Please ensure the source file is runnable on it's own.".
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "RUN":U + pcFile,
             INPUT cMessage).
       cRetValue = "ERROR-":U + cMessage.
       LEAVE VERIFY_BLOCK.
   END.

   /* If the table is already defined in the TEMP-DB but it is defined with another source file, do not
      rebuild those tables but log them. Also, determine those tables to be deleted and 
      pass it to the dumpFile routine.  */
   RUN adeuib/_tempdbawarelib.p PERSISTENT SET hTempdb.
   IF NOT VALID-HANDLE(hTempDB) THEN UNDO.
   RUN checkControlFile IN hTempdb (INPUT pcTables, INPUT pcInclude, 
                                    OUTPUT pcDropTables, OUTPUT cConflictTables).
   DELETE PROCEDURE hTempDB.

   IF cConflictTables > "" THEN
   DO:
     cMessage = "Cannot update tables '" + cConflictTables +  "' because there already exists a source file defined".
     RUN logFile (INPUT "checkControlFile",
                  INPUT cMessage).
     cRetValue = "ERROR-":U + cMessage.
     LEAVE VERIFY_BLOCK.
   END.
   
   RUN dumpFile IN TARGET-PROCEDURE (INPUT cBufHandles, INPUT pcTables, INPUT pcDropTables, OUTPUT pcDumpFile).
   IF pcDumpFile = "" THEN
   DO:
      cMessage = "The source file does not contain any valid Temp-Table definitions." + CHR(10) +
                 "No schema update performed.".
      RUN logFile (INPUT "dumpFile",
                   INPUT cMessage).
      cRetValue = "ERROR-":U + cMessage.
      LEAVE VERIFY_BLOCK.
   END.

END.

/* Delete the data definition file */
IF VALID-HANDLE(hTempFile) THEN
  DELETE PROCEDURE hTempFile.
/* Delete the temporary file */
OS-DELETE VALUE(cTempFile).

RUN adecomm/_setcurs.p ("":U).

RETURN cRetValue.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SaveFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveFile Procedure 
PROCEDURE SaveFile :
/*------------------------------------------------------------------------------
  Purpose:     Prompts users for filename (for new file) and saves the file to disk
  Parameters:  phEditor     Widget handle of Editor containing source file
               pcFileName   File name and relative path of requested file
      OUPUT    pcNewFIle    Name of New file created         
      OUTPUT   plOK         YES  File Saved 
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER phEditor   AS HANDLE     NO-UNDO.
DEFINE INPUT  PARAMETER pcFileName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcNewFile  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER plOK       AS LOGICAL    NO-UNDO.

DEFINE VARIABLE hFrame  AS HANDLE  NO-UNDO.
DEFINE VARIABLE hWidget AS HANDLE  NO-UNDO.
DEFINE VARIABLE lOK     AS LOGICAL     NO-UNDO.

IF pcFileName = ? OR pcFileName = "" THEN
DO:
  SYSTEM-DIALOG GET-FILE pcFileName
     TITLE   "Save File"
     FILTERS "Includes(*.i)" "*.i":U,"Procedures(*.p)" "*.p":U,"All Source(*.p~;*.w~;*.i)" "*.*":U
     SAVE-AS USE-FILENAME ASK-OVERWRITE CREATE-TEST-FILE
             DEFAULT-EXTENSION "i":U
     UPDATE plOK .
    IF plOK <> TRUE THEN 
        RETURN "CANCEL":U.
       
END.

/* Create frame to parent editor widget. Use this editor widget to 
   save file to avoid slick edit from loosing its Progress association */ 
CREATE FRAME hFrame.
CREATE EDITOR hWidget
    ASSIGN FRAME           = hFrame
           LARGE           = TRUE
           AUTO-INDENT     = TRUE
           RETURN-INSERTED = TRUE .

ASSIGN hWidget:SCREEN-VALUE = RIGHT-TRIM(phEditor:INPUT-VALUE).
       
plOK = hWidget:SAVE-FILE(pcFileName) NO-ERROR.

DELETE WIDGET hWidget.
DELETE WIDGET hFrame.

IF plOK THEN
DO:
   ASSIGN pcNewFile = pcFileName.
   RETURN "".
END.
ELSE
   RETURN "ERROR":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-SaveProcess) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE SaveProcess Procedure 
PROCEDURE SaveProcess :
/*------------------------------------------------------------------------------
  Purpose:     Performs entire save operation of the contents in the editor .
               Does syntax checking, file parsing, temp-DB .df verification and 
               dump, and temp-db load
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE VARIABLE lOK         AS LOGICAL    NO-UNDO.
 DEFINE VARIABLE cFileName   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTables     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cDropTables AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cTempFile   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE hEditor     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hFileLabel  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cDumpFile   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRetValue   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cMessage    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cRelFile    AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lLog        AS LOGICAL     NO-UNDO.
 
/* Check that the TEMP-DB database is connected */
 RUN ConnectDB(OUTPUT lok).
 IF NOT lok THEN RETURN.
                        
 {get Editor hEditor}.
 {get FileLabel hFileLabel}.
 {get LogFile lLog}.           
/* Turn off logging to file for check check syntax */ 

 {set LogFile FALSE}.                                

 /* Set messaging on */
 glNoMessage = FALSE.
 /* Syntax Check */
 RUN CheckSyntax IN TARGET-PROCEDURE (INPUT hEditor, INPUT "", INPUT NO, OUTPUT lOK).

 IF NOT lOK THEN 
 DO:
    RUN constructSyntaxError IN TARGET-PROCEDURE (OUTPUT cMessage).
    RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "CheckSyntax":U,
             INPUT cMessage + CHR(10) + "File not saved!").
    RETURN "ERROR":U.
 END.
 
 /* Check if existing file is found  */
 IF hFileLabel:SCREEN-VALUE > "" THEN
 DO:
   FILE-INFO:FILE-NAME = TRIM(hFileLabel:SCREEN-VALUE).
   IF FILE-INFO:FULL-PATHNAME = ? THEN
   DO:
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "SaveProcess":U,
             INPUT "Include File '" + hFileLabel:SCREEN-VALUE + "' cannot be found on disk.").
       RETURN "ERROR":U.

   END.
   /* Check that file is in relative path. Otherwise cannot save file */
   RUN adecomm/_relname.p (hFileLabel:SCREEN-VALUE,"MUST-BE-REL":U,OUTPUT cRelFile).
   IF cRelFile = ? THEN
   DO:
       cMessage = "File '" + hFileLabel:SCREEN-VALUE + "' cannot be found in Propath.".
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "SaveProcess":U,
             INPUT cMessage ).
       RETURN "ERROR-":U + cMessage.
   END.

   /* Check file is not read-only */
   IF INDEX(FILE-INFO:FILE-TYPE, "W":U ) = 0 THEN
   DO:
       cMessage = "Include File '" + hFileLabel:SCREEN-VALUE + "' is read-only."
               + CHR(10) + "Either modify Propath or move include file and try again.".
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "SaveProcess":U,
             INPUT cMessage).
       RETURN "ERROR-":U + cMessage.           
   END.
 END.
 
 SAVE_BLOCK:
 DO ON ERROR UNDO, LEAVE:
     /* Create temporary file to save the contents of the editor which is used for parsing 
        and to pass to other APIs. The actual save of the file is done after the TEMP-DB rebuild at end of block */
   RUN adecomm/_tmpfile.p (INPUT "", INPUT ".ab", OUTPUT cTempFile).
   RUN SaveFile IN TARGET-PROCEDURE (INPUT hEditor, INPUT cTempFile, OUTPUT cFileName, OUTPUT lOK) NO-ERROR.
   IF NOT lOK THEN
   DO:
     cRetValue = RETURN-VALUE.
     IF cRetValue NE "CANCEL":U THEN
         RUN constructSyntaxError IN TARGET-PROCEDURE (OUTPUT cMessage).
         RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "SaveFile":U, INPUT cMessage + CHR(10) + "File not saved!").
     LEAVE SAVE_BLOCK.
   END.
   
   RUN ParseFile IN TARGET-PROCEDURE  (INPUT cTempFile, OUTPUT cTables).  /* Parse file to extract table names). */
   cRetValue = RETURN-VALUE.
   IF cRetValue = "ERROR":U THEN
   DO:
       RUN constructSyntaxError IN TARGET-PROCEDURE (OUTPUT cMessage).
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "ParseFile":U, INPUT cMessage + CHR(10) + "Could not compile file!").   
       LEAVE SAVE_BLOCK.    
   END.
   ELSE IF cTables = "" THEN
   DO:
       cRetValue = RETURN-VALUE.
       RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "ParseFile":U, INPUT "Could not detect any DEFINE TEMP-TABLE statements." + CHR(10) + "File not saved!").   
       LEAVE SAVE_BLOCK.
   END.
   
   /* Perform Rebuild verification and dump file only */
   RUN RunInclude IN TARGET-PROCEDURE  (INPUT cTables, INPUT cFileName, INPUT hFileLabel:SCREEN-VALUE, OUTPUT cDropTables, OUTPUT cDumpFile).
   IF RETURN-VALUE BEGINS "ERROR":U THEN
     LEAVE SAVE_BLOCK.
   
   /* save the file to disk */
   RUN SaveFile IN TARGET-PROCEDURE (INPUT hEditor, INPUT hFileLabel:SCREEN-VALUE, OUTPUT cFileName, OUTPUT lOK).
   IF NOT lOK THEN 
   DO:
     /* If this is a new file, user may have cancelled the save from the system-dialog */
     IF RETURN-VALUE NE "CANCEL":U THEN
     DO:
        RUN constructSyntaxError IN TARGET-PROCEDURE (OUTPUT cMessage).
        RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "SaveFile":U, INPUT cMessage + CHR(10) + "File not saved!").   
     END.
     LEAVE SAVE_BLOCK.
   END.
   
   /* Turn on Logging */
   {set LogFile lLog}.                      
   RUN StartLog IN TARGET-PROCEDURE.   
     
   RUN RebuildTempDB IN TARGET-PROCEDURE (INPUT cTables, INPUT cFileName, INPUT cDropTables, INPUT cDumpFile).
   IF RETURN-VALUE = "ERROR":U THEN
   DO:
      RUN LogFile IN TARGET-PROCEDURE 
           ( INPUT "RebuildTempDB":U, INPUT "Error in rebuilding File " + cFileName + CHR(10) + "File not saved!").
      LEAVE SAVE_BLOCK.
   END.  
   /* Log that file sucessfuly rebuilt */
/* Set messaging ff */
   glNoMessage = TRUE.
   RUN LogFile IN TARGET-PROCEDURE 
        ( INPUT "Rebuild":U, 
          INPUT (IF NUM-ENTRIES(cTables) = 1 
                 THEN "Table '" + cTables + "' was "
                 ELSE "Tables '" + cTables + "' were ")
                + "rebuilt from source file '" + cFileName + "'").  
   ASSIGN hFileLabel:SCREEN-VALUE = cFileName.
   ASSIGN hEditor:MODIFIED = FALSE.
   
   RUN rebuildBrowse IN TARGET-PROCEDURE.
   /* Set the state back to 'edit' mode if no errors returned */
   PUBLISH "SetMode":U FROM TARGET-PROCEDURE ("Edit":U).
   PUBLISH "StateChanged":U FROM TARGET-PROCEDURE.
   
   IF glDynamicsRunning THEN
      RUN EntityImportCheck IN TARGET-PROCEDURE (cTables).  
 END. /* End Save_block */
 

 OS-DELETE VALUE(cTempFile).
 RETURN RETURN-VALUE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-StartLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE StartLog Procedure 
PROCEDURE StartLog :
/*------------------------------------------------------------------------------
  Purpose:    Blanks out the log file if Append is set to NO
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cSection  AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cValue    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lAppend   AS LOGICAL    NO-UNDO.
  DEFINE VARIABLE cFullName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDir      AS CHARACTER  NO-UNDO.

  ASSIGN FILE-INFO:FILE-NAME = gcLogFile
         cFullName           = FILE-INFO:FULL-PATHNAME.

  /* Check that the directory is valid */
  IF cFullName = ? THEN
  DO:
    ASSIGN cDir = SUBSTRING(gcLogFile,1, R-INDEX(gcLogFile,"~\":U) - 1).
           FILE-INFO:FILE-NAME = cDir.
    /* If the file does not exist, check that the directory exists
       and its writable */
    IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 AND INDEX(FILE-INFO:FILE-TYPE,"W":U) > 0 THEN
       cFullName = gcLogFile.
  END.

  ASSIGN cSection = "ProAB":U. 
  IF glLogFile AND cFullName <> ? THEN
  DO:
    GET-KEY-VALUE SECTION  cSection KEY "TempDBLogFileAppend":U VALUE cValue.
    lAppend = IF cValue EQ ? THEN TRUE
              ELSE CAN-DO ("true,yes,on",cValue).
     IF NOT lAppend THEN
     DO:
       OUTPUT STREAM tempDBLog TO VALUE(cFullName)  NO-MAP.
       PUT STREAM tempDBLog UNFORMATTED .
       OUTPUT STREAM tempDBLog CLOSE.
     END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-tempDBView) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE tempDBView Procedure 
PROCEDURE tempDBView :
/*------------------------------------------------------------------------------
  Purpose:     Runs the protool viewer to view the schema details.
  Parameters:  pcTableName   Name of current table.
  Notes:       The schema viewer was modified to reposition to the specified table 
               by running SetTable API.
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcTableName AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hChildWin AS HANDLE     NO-UNDO.

  IF NOT CONNECTED("TEMP-DB":U) THEN 
  DO:
    MESSAGE "You are no longer connected to TEMP-DB database"
      VIEW-AS ALERT-BOX INFORMATION.
    /* If schema window is running, close it and any child windows */          
    IF VALID-HANDLE(ghSchema) THEN DO:
      hChildWin = ghSchema:CURRENT-WINDOW.
      APPLY "WINDOW-CLOSE":U TO hChildWin.
    END.  /* if Schema window running */
  END.  /* selected database no longer connected */
  ELSE DO:  /* db still connected */
    /* If Schema window is running, don't run it again, move it to the top */
    IF VALID-HANDLE(ghSchema) THEN DO:
      hChildWin = ghSchema:CURRENT-WINDOW.
      hChildWin:MOVE-TO-TOP().
      IF hChildWin:WINDOW-STATE = WINDOW-MINIMIZED THEN
         hChildWin:WINDOW-STATE = WINDOW-NORMAL.
      APPLY "ENTRY":U TO hChildWin.
    END.  /* if Schema detail window is already running */
    /* If Schema window is not already running, run it */
    ELSE DO:
       RUN protools/_schlist.w PERSISTENT SET ghSchema (INPUT TARGET-PROCEDURE).
       RUN RefreshSchema IN ghSchema (INPUT "TEMP-DB":U, INPUT "PROGRESS":U, INPUT getTbl()).
    END.  /* else do - Schema window not already running */
    
    RUN SetTable IN ghSchema (INPUT pcTableName, "") NO-ERROR.
  END.  /* else do - db is still connected */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-writeLog) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE writeLog Procedure 
PROCEDURE writeLog :
/*------------------------------------------------------------------------------
  Purpose:     Writes to log file
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcSection AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcMessage AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cFullName AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cUser     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDir     AS CHARACTER   NO-UNDO.



ASSIGN FILE-INFO:FILE-NAME =  gcLogFile
       cFullName           = FILE-INFO:FULL-PATHNAME.

/* Check that the directory is valid */
IF cFullName = ? THEN
DO:
   ASSIGN cDir = SUBSTRING(gcLogFile,1, R-INDEX(gcLogFile,"~\":U) - 1).
          FILE-INFO:FILE-NAME = cDir.
   /* If the file does not exist, check that the directory exists
      and its writable */
   IF INDEX(FILE-INFO:FILE-TYPE,"D") > 0 AND INDEX(FILE-INFO:FILE-TYPE,"W":U) > 0 THEN
      cFullName = gcLogFile.
END.
    
IF cFullName <> ? THEN
DO:
    /* Get User */
   IF glDynamicsRunning THEN
         ASSIGN cUser = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                        INPUT "currentUserLogin":U,
                                                        INPUT NO).
   OUTPUT STREAM tempDBLog TO VALUE(cFullName) APPEND NO-MAP.
   PUT STREAM tempDBLog UNFORMATTED 
       STRING(NOW) + " | " + (IF cUser > "" THEN cUser + " | " ELSE "") + pcMessage SKIP.
   OUTPUT STREAM tempDBLog CLOSE.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-availFld) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION availFld Procedure 
FUNCTION availFld RETURNS LOGICAL
  ( INPUT pcTblName AS CHARACTER, INPUT pcFldName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: This function determines if a field still exists in the database, it
           may have been removed through the data dictionary  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE LExists AS LOGICAL    NO-UNDO.

  CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME("TEMP-DB":U)).
  RUN protools/_fldavbl.p (INPUT "PROGRESS":U, INPUT "TEMP-DB":U, INPUT pcTblName, 
                           INPUT pcFldName, OUTPUT lExists).
  DELETE ALIAS tinydict.
  

  RETURN lExists.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-availIdx) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION availIdx Procedure 
FUNCTION availIdx RETURNS LOGICAL
   ( INPUT pcTblName AS CHARACTER, INPUT pcIdxName AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: This function determines if an Index still exists in the database, it
           may have been removed through the data dictionary  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE lExists AS LOGICAL    NO-UNDO.

  CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME("TEMP-DB":U)).
  RUN protools/_idxavbl.p (INPUT "PROGRESS":U, INPUT "TEMP-DB":U, INPUT pcTblName, 
                          INPUT pcIdxName, OUTPUT lExists).
  DELETE ALIAS tinydict.
  
  RETURN lExists.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-availTbl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION availTbl Procedure 
FUNCTION availTbl RETURNS LOGICAL
   (INPUT pcTblName AS CHARACTER) :
 /*------------------------------------------------------------------------------
   Purpose: This function determines if a Table still exists in the database, it 
            may have been removed through the data dictionary
     Notes:  
 ------------------------------------------------------------------------------*/
   DEFINE VARIABLE lExists AS LOGICAL    NO-UNDO.

    CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME("TEMP-DB":U)).
     RUN protools/_tblavbl.p (INPUT "PROGRESS":U, INPUT "TEMP-DB":U, INPUT pcTblName, OUTPUT lExists).
     DELETE ALIAS tinydict.

   RETURN lExists.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dbconn) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION dbconn Procedure 
FUNCTION dbconn RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  IF NOT CONNECTED("TEMP-DB":U) THEN RETURN FALSE.
  ELSE RETURN TRUE.   /* Function return value. */
  

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-FileReadOnly) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION FileReadOnly Procedure 
FUNCTION FileReadOnly RETURNS LOGICAL
  ( pcFile AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
 ASSIGN FILE-INFO:FILE-NAME = pcFile.
 IF FILE-INFO:FULL-PATHNAME <> ? AND INDEX(FILE-INFO:FILE-TYPE, "W":U) = 0 THEN
    RETURN TRUE.
 ELSE          
    RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDumpName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getDumpName Procedure 
FUNCTION getDumpName RETURNS CHARACTER
  ( pcName AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:   Returns a unique dump Name
    Notes:  
------------------------------------------------------------------------------*/
DEFINE VARIABLE hTempDB   AS HANDLE     NO-UNDO.
DEFINE VARIABLE cDumpName AS CHARACTER  NO-UNDO.

RUN adeuib/_tempdbawarelib.p PERSISTENT SET hTempdb.
IF NOT VALID-HANDLE(hTempDB) THEN RETURN pcName.
RUN getDumpName IN hTempDB (pcName, OUTPUT cDumpName).
DELETE PROCEDURE hTempdb.

RETURN cDumpName.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getFld) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getFld Procedure 
FUNCTION getFld RETURNS CHARACTER
  ( INPUT pcTable AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: This function is called from the Schema window with a table name, it 
           creates an alias for the TEMP-DB database and runs a procedure 
           to get a comma separated list of field names.  It passes the list of
           field names back to the Schema window.   
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTableList AS CHARACTER  NO-UNDO.

  CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME("TEMP-DB":U)).
  RUN protools/_fldlist.p (INPUT "PROGRESS":U, INPUT "TEMP-DB":U, INPUT pcTable, OUTPUT cTableList).
  DELETE ALIAS tinydict.
  
  RETURN cTableList.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getInclude) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getInclude Procedure 
FUNCTION getInclude RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glInclude.  .   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getIndx) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getIndx Procedure 
FUNCTION getIndx RETURNS CHARACTER
 ( INPUT pcTable AS CHARACTER ) :
/*------------------------------------------------------------------------------
  Purpose: This function is called from the Schema window with a table name, it 
           creates an alias for the currently selected database and runs a procedure 
           to get a comma separated list of index names.  It passes the list of
           index names back to the Schema window. 
    Notes:  
------------------------------------------------------------------------------*/

  DEFINE VARIABLE cTableList AS CHARACTER  NO-UNDO.

   CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME("TEMP-DB":U)).
   RUN protools/_idxlist.p (INPUT "PROGRESS":U, INPUT "TEMP-DB":U, INPUT pcTable, OUTPUT cTableList).
   DELETE ALIAS tinydict.

  RETURN cTableList.   /* Function return value. */


END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getLogFile Procedure 
FUNCTION getLogFile RETURNS LOGICAL
  ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RETURN glLogFile.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getTbl) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION getTbl Procedure 
FUNCTION getTbl RETURNS CHARACTER
 ( /* parameter-definitions */ ) :
/*------------------------------------------------------------------------------
  Purpose: This function creates an alias for the currently selected database and 
           runs a procedure to get a comma separated list of table names.
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cTableList AS CHARACTER  NO-UNDO.
  
  CREATE ALIAS tinydict FOR DATABASE VALUE(SDBNAME("TEMP-DB":U)).
  RUN protools/_tbllist.p (INPUT "TEMP-DB":U, INPUT "PROGRESS":U, OUTPUT cTableList).
  DELETE ALIAS tinydict.
  /* Remove entry "temp-db-ctrl" */
  ASSIGN  cTableList = REPLACE(cTableList, "temp-db-ctrl,":U, "")
          cTableList = REPLACE(cTableList, ",temp-db-ctrl":U, "")
          cTableList = REPLACE(cTableList, "temp-db-ctrl":U,  "").
  RETURN cTableList.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setCompareHandle) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setCompareHandle Procedure 
FUNCTION setCompareHandle RETURNS LOGICAL
  ( phHandle AS HANDLE ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN ghCompare = phHandle.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setInclude) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setInclude Procedure 
FUNCTION setInclude RETURNS LOGICAL
  ( plInclude AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  Sets the Include flag used to store the 
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN glInclude = plInclude.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogCompare) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogCompare Procedure 
FUNCTION setLogCompare RETURNS LOGICAL
  ( plLog AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN glLogCompare = plLog.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogFile Procedure 
FUNCTION setLogFile RETURNS LOGICAL
  ( plLog AS LOG ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN glLogFIle = plLog.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setLogFileName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setLogFileName Procedure 
FUNCTION setLogFileName RETURNS LOGICAL
  ( pcFileName AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  ASSIGN gcLogFile = pcFileName.
  RETURN FALSE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setNoMessage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION setNoMessage Procedure 
FUNCTION setNoMessage RETURNS LOGICAL
  ( plNoMessage AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  glNoMessage = plNoMessage.
  RETURN TRUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


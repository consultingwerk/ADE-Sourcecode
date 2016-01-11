&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
/*------------------------------------------------------------------------
    File        : adeuib/_tempdbAwarelib.p
    Purpose     : Procedure Library for temp-db aware routines

    Syntax      :

    Description :

    Author(s)   :
    Created     :
    Notes       :This procedure is run as a super procedure of _tempdb.w
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
{adeuib/_tempdbtt.i}  /* ttTempDB definition. Used to construct browse */
{src/adm2/globals.i}

DEFINE VARIABLE glDynamicsRunning AS LOGICAL    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&IF DEFINED(EXCLUDE-CanFindTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD CanFindTable Procedure 
FUNCTION CanFindTable RETURNS LOGICAL
  ( pcTable AS CHAR)  FORWARD.

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
         HEIGHT             = 13
         WIDTH              = 52.
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

&IF DEFINED(EXCLUDE-buildControlFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildControlFile Procedure 
PROCEDURE buildControlFile :
/*------------------------------------------------------------------------------
  Purpose:     Used to create a control file in the TEMP-DB database
  Parameters:  pcTables  Comma delimited list of tables
               pcFile    Relative pathed name of SOurce file
               pcDropTables  Comma delimtied list oft tables to be dropped
               plnclude      Use Include flag
     
  Notes:       Called from rebuildTempDB in _tempdblip.p
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTables     AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFile       AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcDropTables AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER plInclude    AS LOGICAL    NO-UNDO.

DEFINE VARIABLE i         AS INTEGER    NO-UNDO.
DEFINE VARIABLE cTable    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dFileDate AS DATETIME   NO-UNDO.
DEFINE VARIABLE cRelFile  AS CHARACTER  NO-UNDO.

/* get the file-date */
FILE-INFO:FILE-NAME = pcFile.
IF FILE-INFO:FULL-PATHNAME <> ? THEN
    dFileDate = DATETIME(FILE-INFO:FILE-MOD-DATE,FILE-INFO:FILE-MOD-TIME).

RUN adecomm/_relname.p (pcFile, "",OUTPUT cRelFile).
/* Process dropped tables  */
IF pcDropTables > "" THEN
DO:
  DO i = 1 TO NUM-ENTRIES(pcDropTables):
    cTable = ENTRY(i,pcDropTables).
    FIND TEMP-DB.temp-db-ctrl WHERE temp-db-ctrl.TableName = cTable EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL TEMP-DB.temp-db-ctrl THEN
      DELETE TEMP-DB.temp-db-ctrl .
  END.
END.

/* Create/modify control records */
DO i = 1 TO NUM-ENTRIES(pcTables):
  cTable = ENTRY(i,pcTables).
  FIND TEMP-DB.temp-db-ctrl WHERE temp-db-ctrl.TableName = cTable EXCLUSIVE-LOCK NO-ERROR.
  IF NOT AVAIL TEMP-DB.temp-db-ctrl THEN
  DO:
     CREATE TEMP-DB.temp-db-ctrl.
     ASSIGN TableName = cTable.
  END.

  ASSIGN TEMP-DB.temp-db-ctrl.SourceFile       = cRelFile
         TEMP-DB.temp-db-ctrl.TableDate        = NOW
         TEMP-DB.temp-db-ctrl.UseInclude       = plInclude 
         TEMP-DB.temp-db-ctrl.FileDate         = dFileDate
  NO-ERROR.

  IF glDynamicsRunning THEN
      ASSIGN TEMP-DB.temp-db-ctrl.userModified = DYNAMIC-FUNCTION("getPropertyList":U IN gshSessionManager,
                                                     INPUT "currentUserLogin":U,
                                                     INPUT NO).
END.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-buildTempDBBrowse) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buildTempDBBrowse Procedure 
PROCEDURE buildTempDBBrowse :
/*------------------------------------------------------------------------------
  Purpose:     Construct temp table records from the metaschema tables.
  Parameters:  OUTPUT TABLE ttTempDB (adeuib/_tempdbtt.i)
  Notes:       Called from RebuildBrowse (_tempdb.w) and rebuildFromFile and SaveProcess
               in _tempdblib.p to populate its browser
               
               This assumes the control file is contained in the
               TEMP-DB database (temp-db-ctrl)
               Status Codes:
                 C - Control record not found for table in TEMP-DB
                 O - Orphan record in control file has Table that is not in TEMP-DB
                 F - File not found in disk
                 M - Matching File
                 X - Mismatched file
------------------------------------------------------------------------------*/
 DEFINE INPUT-OUTPUT PARAMETER TABLE FOR  ttTempDB.

 DEFINE VARIABLE hBrowse   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE dDateTime AS DATETIME  NO-UNDO.
 DEFINE VARIABLE cRelFile  AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE lNew      AS LOGICAL    NO-UNDO.

 /* Only include records from Progress TEMP-DB database (Not foreign)
    and exclude control file */
 FIND TEMP-DB._db WHERE TEMP-DB._db._db-name = ? AND 
        TEMP-DB._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */
 IF NOT AVAIL TEMP-DB._db THEN
     RETURN "ERROR":U.

 FOR EACH TEMP-DB._FILE NO-LOCK
     WHERE TEMP-DB._File._DB-recid      = RECID(TEMP-DB._db)
       AND NOT TEMP-DB._FILE._File-Name BEGINS "_" 
       AND NOT TEMP-DB._FILE._File-Name = "temp-db-ctrl":U
       AND TEMP-DB._FILE._Owner         = "PUB":U :
    
    FIND ttTempDB WHERE ttTempDB.ttProcedure = SOURCE-PROCEDURE
                    AND ttTempDB.ttTableID = TEMP-DB._FILE._File-Name NO-ERROR.
    IF NOT AVAIL ttTempDB THEN
    DO:
       CREATE ttTempDB.
       ASSIGN ttTempDB.ttProcedure    = SOURCE-PROCEDURE
              ttTempDB.ttTableName    =  TEMP-DB._FILE._File-Name
              ttTempDB.ttTableID      =  TEMP-DB._FILE._File-Name
              lnew                    = TRUE.
    END.
    /* Find control record for each table */
    FIND TEMP-DB.temp-db-Ctrl WHERE  TEMP-DB.temp-db-Ctrl.TableName = TEMP-DB._FILE._FILE-NAME NO-LOCK NO-ERROR.
    IF AVAIL TEMP-DB.temp-db-Ctrl THEN
    DO:
        ASSIGN 
          ttTempDB.ttTableName        = TEMP-DB._FILE._File-Name
          ttTempDB.ttSourceFile       = TEMP-DB.temp-db-Ctrl.SourceFile
          ttTempDB.ttTableDate        = TEMP-DB.temp-db-Ctrl.TableDate
          ttTempDB.ttUseInclude       = TEMP-DB.temp-db-Ctrl.UseInclude
          ttTempDB.ttEntityImported   = TEMP-DB.temp-db-Ctrl.EntityImported
          ttTempDB.ttUserModified     = TEMP-DB.temp-db-Ctrl.UserModified
          ttTempDB.ttFileDate         = TEMP-DB.temp-db-Ctrl.FileDate
          ttTempDB.ttStatusCode       = REPLACE(ttTempDB.ttSTatusCode,"o":U,"").
        
         /* Check that file is in Propath */
        RUN adecomm/_relname.p (TEMP-DB.temp-db-Ctrl.SourceFile,"MUST-BE-REL":U,OUTPUT cRelFile).
        IF cRelFile = ? THEN
        DO:
           IF LOOKUP("F":U,ttTempDB.ttStatusCode) = 0 THEN
              ASSIGN ttTempDB.ttStatus      = ttTempDB.ttStatus + (IF ttTempDB.ttStatus = "" THEN "" ELSE ";")
                                                   + "File Not Found in Propath"
                     ttTempDB.ttStatusCode  = ttTempDB.ttStatusCode + (IF ttTempDB.ttStatusCode = "" THEN "" ELSE ",")
                                                   + "F":U.
        END.
        ELSE DO:
        /* Check whether the file system date and time differs from the file date and time 
           when it was last rebuilt */
           ASSIGN FILE-INFO:FILE-NAME = TEMP-DB.temp-db-Ctrl.SourceFile.
           ASSIGN dDateTime = DATETIME(FILE-INFO:FILE-MOD-DATE,FILE-INFO:FILE-MOD-TIME).
           
           IF dDateTime <> TEMP-DB.temp-db-ctrl.FileDate  THEN
               ASSIGN ttTempDB.ttFileChanged = TRUE.
           ELSE
               ASSIGN ttTempDB.ttFileChanged = FALSE.
        END.
   
        
    END.
    ELSE
        ASSIGN ttTempDB.ttSourceFile       = ""
               ttTempDB.ttUseInclude       = ?
               ttTempDB.ttEntityImported   = ?
               ttTempDB.ttStatus           = ttTempDB.ttStatus + (IF ttTempDB.ttStatus = "" THEN "" ELSE ";")
                                                   + "Control Record Not Found"
               ttStatusCode                = ttTempDB.ttStatusCode + (IF ttTempDB.ttStatusCode = "" THEN "" ELSE ",")
                                                   + "C":U
               ttTempDB.ttFileChanged      = ?.
 END.

 /* Find Orphan records */
 FOR EACH TEMP-DB.temp-db-Ctrl NO-LOCK:
    IF NOT CAN-FIND(FIRST ttTempDB 
                    WHERE ttTempDB.ttprocedure = SOURCE-PROCEDURE 
                      AND ttTempDB.ttTableID = TEMP-DB.temp-db-Ctrl.TableName) THEN
    DO:
       CREATE ttTempDB.
       ASSIGN  
          ttTempDB.ttProcedure        = SOURCE-PROCEDURE
          ttTempDB.ttTableID          = TEMP-DB.temp-db-Ctrl.TableName
          ttTempDB.ttSourceFile       = TEMP-DB.temp-db-Ctrl.SourceFile
          ttTempDB.ttTableDate        = TEMP-DB.temp-db-Ctrl.TableDate
          ttTempDB.ttUseInclude       = TEMP-DB.temp-db-Ctrl.UseInclude
          ttTempDB.ttEntityImported   = TEMP-DB.temp-db-Ctrl.EntityImported
          ttTempDB.ttUserModified     = TEMP-DB.temp-db-Ctrl.UserModified
          ttTempDB.ttStatus           = IF TEMP-DB.temp-db-Ctrl.TableName > "" 
                                        THEN ("Table " + TEMP-DB.temp-db-Ctrl.TableName + " Not Found")
                                        ELSE (" Table is blank")
          ttTempDB.ttStatusCode       = "o":U
          ttTempDB.ttFileChanged      = ?
          NO-ERROR.
          /* Check whether source is found */
          ASSIGN FILE-INFO:FILE-NAME = TEMP-DB.temp-db-Ctrl.SourceFile.
          IF FILE-INFO:FULL-PATHNAME = ? OR FILE-INFO:FULL-PATHNAME = "" THEN
             ASSIGN ttTempDB.ttStatusCode       = "o,F":U
                    ttTempDB.ttStatus           = ttTempDB.ttStatus + ";" + "File Not Found".
    END.
 END.
 
/* Find orphaned temptable records and delete them */
FOR EACH ttTempDB WHERE ttTempDB.ttprocedure = SOURCE-PROCEDURE:
   IF NOT CAN-FIND (FIRST TEMP-DB.temp-db-Ctrl WHERE TEMP-DB.temp-db-Ctrl.TableName = ttTempDB.ttTableID) THEN
      DELETE ttTempDB.
END.

 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-checkControlFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE checkControlFile Procedure 
PROCEDURE checkControlFile :
/*------------------------------------------------------------------------------
  Purpose:    Determine tables to be deleted and those tables that cannot be updated
  Parameters: pcTables          Delimited list of tables defined in the source
              pcFile            Relative pathed file of source file with forward slash.
    OUTPUT    pcDropTables      Delimited list of tables flagged for deletion
    OUTPUT    pcConflictTables  List of tables that cannot be rebuilt because
                                it already exists with another source file
              
  Notes:      If the user removes a table definition in the source file, the
              code checks whether the table should be removed.
              Called from RunInclude (_tempdblib.p)
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTables         AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcFile           AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDropTables     AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcConflictTables AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTableName    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i             AS INTEGER    NO-UNDO.
DEFINE VARIABLE cSourceTables AS CHARACTER  NO-UNDO.

/* Ensure pcFile is relatively pathed */
RUN adecomm/_relname.p (pcFile, "MUST-BE-REL":U,OUTPUT pcFile).
IF pcFile = ? THEN
    RETURN "ERROR":U.

FIND TEMP-DB._db WHERE TEMP-DB._db._db-name = ? AND 
     TEMP-DB._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */

/* Build list of all tables the include file defines */
FOR EACH TEMP-DB.Temp-db-ctrl WHERE TEMP-DB.Temp-db-ctrl.SourceFile = pcFile NO-LOCK:
    ASSIGN cSourceTables = cSourceTables + (IF cSourceTables= "" THEN "" ELSE ",")
                                         + TEMP-DB.Temp-db-ctrl.TableName.
END.

/* Find files to be deleted if the temp-table definition is removed.*/
TABLE_DELETE_LOOP:
DO i = 1 TO NUM-ENTRIES(cSourceTables):
  ASSIGN cTableName = ENTRY(i,cSourceTables).
  /* Check if the table exists in the list of defined tables for the source, if not it's 
     a candidate for deletion */
  IF LOOKUP(cTableName,pcTables) = 0  THEN
  DO:
     /* Check that table exists in TEMP-DB, if not, don't add it to list */
    IF NOT CAN-FIND (TEMP-DB._FILE WHERE TEMP-DB._File._DB-recid   = RECID(TEMP-DB._db)
                                     AND TEMP-DB._FILE._File-Name = cTableName) THEN
         NEXT TABLE_DELETE_LOOP.

     pcDropTables = pcDropTables + (IF pcDropTables = "" THEN "" ELSE ",")
                                 + cTableName.
  END.
END.

/* Test whether tables already exist and have a different source. User may have added a define
   temp-table statement that refers to a table that already exists with a different source file*/
TABLE_LOOP:
DO i = 1 TO NUM-ENTRIES(pcTables):
   ASSIGN cTableName = ENTRY(i,pcTables).
   FIND TEMP-DB.Temp-db-ctrl WHERE TEMP-DB.Temp-db-ctrl.TableName = cTableName NO-LOCK NO-ERROR.
   IF AVAIL TEMP-DB.Temp-db-ctrl AND TEMP-DB.Temp-db-ctrl.SourceFile NE pcFile 
                       AND trim(pcFile) NE "" THEN
          pcConflictTables = pcConflictTables + (IF pcConflictTables = "" THEN "" ELSE ",") 
                                              + cTableName.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-compareBuffer) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE compareBuffer Procedure 
PROCEDURE compareBuffer :
/*------------------------------------------------------------------------------
  Purpose:     Performs buffer comparisons between a schema table and a temp-table
               defined in a source file.
  Parameters:  pcBufHandles   Handle to temp-table buffers
               pcTable        Schema table used for comparison
               pcResult       String of comparios result
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcBufHandles AS CHARACTER  NO-UNDO.
 DEFINE INPUT  PARAMETER pcTable      AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER pcResult     AS CHARACTER  NO-UNDO.

 DEFINE VARIABLE hBuffer    AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hBufferDB  AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hField     AS HANDLE     NO-UNDO.
 DEFINE VARIABLE hFieldDB   AS HANDLE     NO-UNDO.
 DEFINE VARIABLE cField     AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cMessage   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cIdxInfoDB AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE cIdxInfo   AS CHARACTER  NO-UNDO.
 DEFINE VARIABLE i          AS INTEGER    NO-UNDO.
 DEFINE VARIABLE j          AS INTEGER    NO-UNDO.
 

 BUFFER_LOOP:
 DO i = 1 TO NUM-ENTRIES(pcBufHandles):
    hBuffer = WIDGET-HANDLE(TRIM(ENTRY(i,pcBufHandles))) NO-ERROR.
    IF VALID-HANDLE(hBuffer) AND hBuffer:TABLE EQ TRIM(pcTable) THEN
        LEAVE BUFFER_LOOP.
 END.

 IF VALID-HANDLE(hBuffer) THEN
 DO:
    IF NOT pcTable BEGINS "TEMP-DB."THEN
       pcTable = "TEMP-DB." + pcTable.
    
    CREATE BUFFER hBufferDB FOR TABLE pcTable.
 END.

 FIELD_LOOP:
 DO j = 1 TO hBufferDB:NUM-FIELDS:
   ASSIGN hFieldDB =  hBufferDB:BUFFER-FIELD(j) 
          cField   =  hFieldDB:NAME
          hField   =  hBuffer:BUFFER-FIELD(cField) NO-ERROR.
   
   IF NOT VALID-HANDLE(hField) THEN
   DO:
     pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Defined in TEMP-DB but not defined in Include file ".
     NEXT FIELD_LOOP.
   END.
   
   
   IF hFieldDB:DATA-TYPE NE hField:DATA-TYPE THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched Data Types ".

   IF hFieldDB:FORMAT NE hField:FORMAT THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched FORMAT ".
    
   IF hFieldDB:INITIAL NE hField:INITIAL THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched INITIAL Values ".

   IF hFieldDB:LABEL NE hField:LABEL THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched LABEL ". 

   IF hFieldDB:COLUMN-LABEL NE hField:COLUMN-LABEL THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched COLUMN-LABEL ".
    
   IF hFieldDB:VALIDATE-EXPRESSION NE hField:VALIDATE-EXPRESSION THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched VALIDATE-EXPRESSION ".

   IF hFieldDB:VALIDATE-MESSAGE NE hField:VALIDATE-MESSAGE THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched VALIDATE-MESSAGE ".

   IF hFieldDB:VALIDATE-MESSAGE NE hField:VALIDATE-MESSAGE THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched HELP ".

   IF hFieldDB:EXTENT NE hField:EXTENT THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched EXTENT values ".

   IF hFieldDB:DECIMALS NE hField:DECIMALS THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched DECIMALS value ".

   IF hFieldDB:MANDATORY NE hField:MANDATORY THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched MANDATORY value ". 

   IF hFieldDB:CASE-SENSITIVE NE hField:CASE-SENSITIVE THEN
      pcResult = pcResult + CHR(10) + "Field: " + hFieldDB:NAME + "  **Mismatched CASE-SENSITIVE value ". 
    
 END.

 /* Test that fields in Include file are defined in TEMP-DB */
 DO j = 1 TO hBuffer:NUM-FIELDS:
   ASSIGN hField =  hBuffer:BUFFER-FIELD(j) 
          cField   =  hField:NAME
          hFieldDB   =  hBufferDB:BUFFER-FIELD(cField) NO-ERROR.
   IF NOT VALID-HANDLE(hFieldDB) THEN
     pcResult = pcResult + CHR(10) + "Field: " + hField:NAME + "  **Defined in Include file but not in TEMP-DB ".
 END.
 

 /* Build Index information */
 ASSIGN i = 1.
 INDEX_LOOP:
 DO WHILE hBufferDB:INDEX-INFORMATION(i) <> ?:
    ASSIGN cIdxInfoDB = hBufferDB:INDEX-INFORMATION(i).
    ASSIGN j = 1.
    DO WHILE hBuffer:INDEX-INFORMATION(j) <> ?:
        cIdxInfo   = hBuffer:INDEX-INFORMATION(j).
        IF ENTRY(1,cIdxInfo) = ENTRY(1,cIdxInfoDB) THEN
           LEAVE.
        j = j + 1.
    END.
    ASSIGN i = i + 1 NO-ERROR.

    IF cIdxInfoDB NE cIdxInfo THEN
       pcResult = pcResult + CHR(10) + "Index: " + ENTRY(1,cIdxInfoDB) + "  **Mismatched Index '" + cIdxInfoDB + "' : " + cIdxInfo .
 END. /* End Do While INDEX_INFORMATION <> ? */
 
 

 /* Cleanup */
 DELETE OBJECT hBufferDB.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-deleteTempDB) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE deleteTempDB Procedure 
PROCEDURE deleteTempDB :
/*------------------------------------------------------------------------------
  Purpose:     Deletes control file if delete menu itme is selected
  Parameters:  pcTableID    Name of table in control table
      OUTPUT   plDeleted    Indicator that record was deleted
  Notes:       
------------------------------------------------------------------------------*/
 DEFINE INPUT  PARAMETER pcTableID AS CHARACTER  NO-UNDO.
 DEFINE OUTPUT PARAMETER plDeleted AS LOGICAL    NO-UNDO.


 /* Delete the metaschema file */
 FIND TEMP-DB._db WHERE TEMP-DB._db._db-name = ? AND 
      TEMP-DB._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */

 FOR EACH TEMP-DB._FILE WHERE TEMP-DB._File._DB-recid   = RECID(TEMP-DB._db)
                          AND TEMP-DB._FILE._File-Name = pcTableID EXCLUSIVE-LOCK:

   FOR EACH TEMP-DB._Index OF TEMP-DB._File EXCLUSIVE-LOCK:
     FOR EACH TEMP-DB._index-field OF TEMP-DB._Index EXCLUSIVE-LOCK:
       DELETE TEMP-DB._Index-field.
     END.
     DELETE TEMP-DB._index.
   END.

   FOR EACH TEMP-DB._FIELD OF TEMP-DB._File EXCLUSIVE-LOCK:
     DELETE TEMP-DB._Field.
   END.

   IF AVAIL TEMP-DB._FILE THEN
   DO:
      DELETE  TEMP-DB._FILE.
      plDeleted = YES.
   END.
 END.
 
 FIND TEMP-DB.Temp-db-ctrl WHERE TEMP-DB.Temp-db-ctrl.TableName = pcTableID EXCLUSIVE-LOCK NO-ERROR.
 IF AVAIL TEMP-DB.Temp-db-ctrl THEN
     DELETE TEMP-DB.Temp-db-ctrl.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getDumpName) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDumpName Procedure 
PROCEDURE getDumpName :
/*------------------------------------------------------------------------------
  Purpose:     Checks and transforms a name into a valid unique dumpname
  Parameters:  pcName      Name of Table
               pcDumpName  Valid returned dump name
  Notes:       COpied from prodict/dump/dumpname.i
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcName AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDumpName AS CHARACTER  NO-UNDO.

DEFINE VARIABLE ipass AS INTEGER    NO-UNDO.


ASSIGN pcDumpName = SUBSTRING(pcName,1,8,"CHARACTER":U).
FIND TEMP-DB._db WHERE TEMP-DB._db._db-name = ? AND 
     TEMP-DB._db._db-type = "PROGRESS" NO-LOCK NO-ERROR. /*local */

 
IF CAN-FIND(TEMP-DB._File WHERE TEMP-DB._File._Db-recid  EQ RECID(TEMP-DB._db)
                            AND TEMP-DB._File._Dump-Name EQ pcDumpName 
                            AND TEMP-DB._FILE._File-Name NE pcName                                                         
                            AND (TEMP-DB._File._Owner    EQ "PUB" OR TEMP-DB._File._Owner EQ "_FOREIGN")) THEN
DO ipass = 1 TO 9999:
  ASSIGN pcDumpName = SUBSTRING(pcDumpName + "-------"
                               ,1
                               ,8 - LENGTH(STRING(ipass),"character")
                               ,"character" )
                       + STRING(ipass).

  IF NOT CAN-FIND(TEMP-DB._File WHERE TEMP-DB._File._Db-recid  EQ RECID(TEMP-DB._db)
                                  AND TEMP-DB._File._Dump-Name EQ pcDumpName
                                  AND TEMP-DB._FILE._File-Name NE pcName  
                                  AND (TEMP-DB._File._Owner EQ "PUB" OR TEMP-DB._File._Owner EQ "_FOREIGN")) THEN
     LEAVE.
   
END.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateEntity) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateEntity Procedure 
PROCEDURE updateEntity :
/*------------------------------------------------------------------------------
  Purpose:     Updates the EntityImported flag
  Parameters:  pcTables   Comma delimtied list of tables to flag as being imported
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcTables AS CHARACTER  NO-UNDO.

DEFINE VARIABLE cTable AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i      AS INTEGER    NO-UNDO.

DO i = 1 TO NUM-ENTRIES(pcTables):
  cTable = ENTRY(i,pcTables).
  FIND TEMP-DB.temp-db-ctrl WHERE temp-db-ctrl.TableName = cTable EXCLUSIVE-LOCK NO-ERROR.
  IF AVAIL TEMP-DB.temp-db-ctrl THEN
     ASSIGN TEMP-DB.temp-db-ctrl.EntityImported = YES NO-ERROR.
END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

/* ************************  Function Implementations ***************** */

&IF DEFINED(EXCLUDE-CanFindTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION CanFindTable Procedure 
FUNCTION CanFindTable RETURNS LOGICAL
  ( pcTable AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:  Checks whether a specified table exists in the TEMP-DB database
    Notes:  
------------------------------------------------------------------------------*/
  
  FIND TEMP-DB._db WHERE TEMP-DB._db._db-name = ? AND 
        TEMP-DB._db._db-type = "PROGRESS":U NO-LOCK NO-ERROR. /*local */

  IF CAN-FIND(TEMP-DB._FILE 
        WHERE TEMP-DB._File._DB-recid      = RECID(TEMP-DB._db)
          AND TEMP-DB._FILE._File-name =  pcTable ) THEN
      RETURN TRUE.
  ELSE
     RETURN FALSE.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


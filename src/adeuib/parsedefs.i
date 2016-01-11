/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*------------------------------------------------------------------------
File        : adeuib/parsefile.i
Purpose     : parse a file and return table and/or dataset definitions
Description :

Preprocessor parameters 
  Mandatory  
        &SourceFile - input filename 
        &streamname - stream name for input file 
  Alternative (define one or both)  
        &Tables     - outputs parsed temp-tables 
        &Datasets   - outputs parsed dataset 
  Optional                       
        &returnerror - option for RETURN when error.         
        Don't define this if it is necessary to capture compile error 
        Instead check compiler:error and error-status:get-message(1)
        after the inclusion. (also check error-status:error)
        
Notes       : Included in internal procedures.
              The code will search for the key word TEMP-TABLE and/or DATSET
              not contained within comments.
              The name following that key word (excluding NEW, GLOBAL and 
              SHARED) will be extracted.
              Since the temp-table following the TEMP-TABLE statement can be 
              defined on another line, this will also be considered.
           -  error-status is kept intact for missing file and compile error                   
------------------------------------------------------------------------------*/
DEFINE VARIABLE cLine         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTempFile     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iWords        AS INTEGER    NO-UNDO.
DEFINE VARIABLE cWord         AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lTTPending    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lDSPending    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE lDefPending   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE iComment      AS INTEGER    NO-UNDO.
DEFINE VARIABLE cComStart     AS CHARACTER  NO-UNDO INIT "/*":U.
DEFINE VARIABLE cComEnd       AS CHARACTER  NO-UNDO INIT "*/":U.

DO ON ERROR UNDO,LEAVE:
  
   /* Check file is valid */
  FILE-INFO:FILE-NAME = {&SourceFile}  .
  IF FILE-INFO:FULL-PATHNAME EQ ? THEN
    RETURN {&ReturnError}. 

   /* Generate temporary file */
  RUN adecomm/_tmpfile.p
        (INPUT "", INPUT ".ab", OUTPUT cTempFile).
  
  /* Compile file using PREPROCESS param to get a flat file with all inserted includes.
     This precludes the requirement to recurse nested include files */
  COMPILEBLOCK:  
  DO ON ERROR UNDO, LEAVE COMPILEBLOCK
     ON STOP  UNDO, LEAVE COMPILEBLOCK
     ON QUIT  UNDO, LEAVE COMPILEBLOCK:
    COMPILE VALUE({&SourceFile}) PREPROCESS VALUE(cTempFile) NO-ERROR.
  END.
  
  IF COMPILER:ERROR THEN
    UNDO.
  
  INPUT STREAM {&StreamName} FROM VALUE (cTempFile) NO-ECHO.
  
  READ_LINE:
  REPEAT ON ERROR UNDO, LEAVE
         ON STOP  UNDO, LEAVE:
    IMPORT STREAM {&StreamName} UNFORMATTED cLine.
    ASSIGN cLine  = TRIM(cLine)
           iWords = NUM-ENTRIES(cLine, " ":U).
    /* Skip blank lines */
    IF cLine = "" THEN   
      NEXT READ_LINE. 
  
    WORD_LOOP:
    DO i = 1 TO iWords:
      ASSIGN cWord = TRIM(ENTRY(i,cLine," ":U)).
      
      /* Skip blank lines */
      IF cWord = "" THEN
          NEXT WORD_LOOP.
      /* Skip inline comments in one word i.e. /*onewordinline*/  */
      ELSE IF cWord BEGINS cComStart AND SUBSTRING(cWord,LENGTH(cWord) - 1, -1) = cComEnd THEN 
          NEXT WORD_LOOP.
      /* Increment counter if start comment found */
      ELSE IF cWord BEGINS cComStart THEN
         iComment = iComment + 1.
      /* Decrease counter if end comment found */
      ELSE IF LENGTH(cWord) GE 2 AND SUBSTRING(cWord,LENGTH(cWord) - 1, -1) = cComEnd THEN
        iComment = iComment - 1.
      
      /* Skip Word if contained within comment */
      IF iComment > 0 THEN
         NEXT WORD_LOOP.
      
      IF cWord = 'DEFINE' THEN
      DO:
        lDefPending = TRUE.
        NEXT WORD_LOOP.
      END.
      IF lDefPending THEN
      DO:
        IF cWord = "NEW":U OR cWord = "SHARED":U OR cWord = "GLOBAL":U  OR cWord = "" THEN
          NEXT WORD_LOOP.
  
              &IF DEFINED(Tables) <> 0 &THEN
        IF cWord = "TEMP-TABLE":U  THEN
        DO:
          ASSIGN lTTPending = YES.
          NEXT WORD_LOOP.
        END.
              &ENDIF
          
              &IF DEFINED(Datasets) <> 0 AND DEFINED(Tables) <> 0 &THEN
        ELSE 
              &ENDIF
  
              &IF DEFINED(Datasets) <> 0 &THEN
        IF cWord = "DATASET":U  THEN
        DO:
          ASSIGN lDSPending = YES.
          NEXT WORD_LOOP.
        END.
              &ENDIF
  
              &IF DEFINED(Datasets) <> 0 OR DEFINED(Tables) <> 0  &THEN
        /* Test for the temp-table name on another line */
        ELSE IF lTTPending OR lDSPending THEN 
        DO:
  
                    &IF DEFINED(Datasets) <> 0 AND DEFINED(Tables) <> 0 &THEN
          IF lTTPending THEN
                    &ENDIF
                    &IF DEFINED(Tables) <> 0 &THEN
            ASSIGN {&Tables}   =  IF LOOKUP(cWord,{&Tables}) > 0 THEN {&Tables}
                                  ELSE {&Tables} + (IF {&Tables} = "" THEN "" ELSE ",")
                                                 + cWord
                   lTTPending = NO.
                    &ENDIF  
                                                                               
                    &IF DEFINED(Datasets) <> 0 AND DEFINED(Tables) <> 0 &THEN
          ELSE 
                    &ENDIF
  
                    &IF DEFINED(Datasets) <> 0 &THEN
            ASSIGN {&Datasets} =  IF LOOKUP(cWord,{&Datasets}) > 0 THEN {&Datasets}
                                  ELSE {&Datasets} + (IF {&Datasets} = "" THEN "" ELSE ",")
                                                   + cWord
                   lDSPending = NO.
                    &ENDIF                                                            
                                                                                         lTTPending = NO.
        END. /* End if ttpending or dspending */
        ELSE 
              &ENDIF /* defined dataset or tables */
               
          lDefPending = FALSE.
      END.
    END. /* Word loop */
  END. /* Main repeat import loop  */
END. /* do on error */

INPUT STREAM {&StreamName} CLOSE.

OS-DELETE VALUE(cTempFile) NO-ERROR.
   
    &IF DEFINED(ReturnError) <> 0 &THEN
IF COMPILER:ERROR THEN
  RETURN {&ReturnError}.
IF ERROR-STATUS:ERROR THEN
  RETURN {&ReturnError}.
   &ENDIF
 

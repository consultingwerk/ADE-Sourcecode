&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Check Version Notes Wizard" Procedure _INLINE
/* Actions: af/cod/aftemwizcw.w ? ? ? ? */
/* MIP Update Version Notes Wizard
Check object version notes.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Update-Object-Version" Procedure _INLINE
/* Actions: ? ? ? ? af/sup/afverxftrp.p */
/* This has to go above the definitions sections, as that is what it modifies.
   If its not, then the definitions section will have been saved before the
   XFTR code kicks in and changes it */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Definition Comments Wizard" Procedure _INLINE
/* Actions: ? af/cod/aftemwizcw.w ? ? ? */
/* Program Definition Comment Block Wizard
Welcome to the Program Definition Comment Block Wizard. Press Next to proceed.
af/cod/aftemwizpw.w
*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: afqrydetlp.p

  Description:  Query Evaluation Procedure

  Purpose:      To evaluate the passed in query as pass back details of the query tables,
                fields, etc.

  Parameters:   input query
                output query valid
                output query table list - comma delimited
                output query field name list - comma delimited
                output query field format list - chr(1) delimited
                output query field datatype list - comma delimited
                output query field label list - chr(1) delimited
                output query field column label list - chr(1) delimited
                output first record value list - chr(1) delimited or blank if no records

  History:
  --------
  (v:010000)    Task:        7065   UserRef:    
                Date:   04/12/2000  Author:     Anthony Swindells

  Update Notes: Created from Template aftemprocp.p

  (v:010001)    Task:        7427   UserRef:    
                Date:   29/12/2000  Author:     Anthony Swindells

  Update Notes: Generically fix query prepare issues for Europe

  (v:010002)    Task:    90000159   UserRef:    IZ1305
                Date:   12/06/2001  Author:     Tammy St Pierre

  Update Notes: Changed field format list to be chr(1) delimited

----------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       afqrydetlp.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* MIP object identifying preprocessor */
&glob   mip-structured-procedure    yes

DEFINE INPUT  PARAMETER pcQuery                 AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcBuffers               AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable1.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable2.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable3.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable4.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable5.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable6.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable7.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable8.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable9.
DEFINE INPUT  PARAMETER TABLE-HANDLE phTempTable10.
DEFINE INPUT  PARAMETER plReturnExtents         AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER plQueryValid            AS LOGICAL    NO-UNDO.
DEFINE OUTPUT PARAMETER pcBufferList            AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFieldNameList         AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFieldFormatList       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFieldDataTypeList     AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFieldLabelList        AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFieldCLabelList       AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcFieldValueList        AS CHARACTER  NO-UNDO.

{af/sup2/afglobals.i}

DEFINE VARIABLE gcTTList      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE gcBufferList  AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



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
         HEIGHT             = 13.38
         WIDTH              = 67.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE hQuery                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE hBufferList                 AS HANDLE EXTENT 20 NO-UNDO.
DEFINE VARIABLE hBuffer                     AS HANDLE     NO-UNDO.
DEFINE VARIABLE hField                      AS HANDLE     NO-UNDO.
DEFINE VARIABLE cFieldHandles               AS CHARACTER  NO-UNDO.
DEFINE VARIABLE iLoop                       AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop2                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLoop3                      AS INTEGER    NO-UNDO.
DEFINE VARIABLE iBuffer                     AS INTEGER    NO-UNDO.
DEFINE VARIABLE cField                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cRowid                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cValue                      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cEmptyValue                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lOk                         AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cBufferName                 AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDBList                     AS CHARACTER  NO-UNDO.

ASSIGN plQueryValid = NO.

RUN getBufferList (INPUT pcQuery, OUTPUT pcBufferList, OUTPUT cDBList).
RUN assignTTList.

IF pcBufferList = "":U THEN RETURN.

/* Create a query */
CREATE QUERY hQuery NO-ERROR.

buffer-loop:
DO iLoop = 1 TO NUM-ENTRIES(pcBufferList):
  /* Check for TEMP-TABLES */
  IF LOOKUP(ENTRY(iLoop,pcBufferList),gcTTList) > 0 THEN DO:
    CASE LOOKUP(ENTRY(iLoop,pcBufferList),gcTTList):
      WHEN 1 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable1:DEFAULT-BUFFER-HANDLE NO-ERROR.
      WHEN 2 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable2:DEFAULT-BUFFER-HANDLE NO-ERROR.
      WHEN 3 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable3:DEFAULT-BUFFER-HANDLE NO-ERROR.
      WHEN 4 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable4:DEFAULT-BUFFER-HANDLE NO-ERROR.
      WHEN 5 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable5:DEFAULT-BUFFER-HANDLE NO-ERROR.
      WHEN 6 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable6:DEFAULT-BUFFER-HANDLE NO-ERROR.
      WHEN 7 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable7:DEFAULT-BUFFER-HANDLE NO-ERROR.
      WHEN 8 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable8:DEFAULT-BUFFER-HANDLE NO-ERROR.
      WHEN 9 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable9:DEFAULT-BUFFER-HANDLE NO-ERROR.
      WHEN 10 THEN
        CREATE BUFFER hBufferList[iLoop] FOR TABLE phTempTable10:DEFAULT-BUFFER-HANDLE NO-ERROR.
    END CASE.
  END.
  
  /* Check for BUFFERS */
  IF LOOKUP(ENTRY(iLoop,pcBufferList),gcBufferList) > 0 THEN
    CREATE BUFFER hBufferList[iLoop] FOR TABLE TRIM(ENTRY(LOOKUP(ENTRY(iLoop,pcBufferList),pcBuffers) + 1,pcBuffers)) BUFFER-NAME TRIM(ENTRY(LOOKUP(ENTRY(iLoop,pcBufferList),pcBuffers),pcBuffers)) NO-ERROR. 
  
  /* Actual DataBase Tables */
  IF NOT VALID-HANDLE(hBufferList[iLoop]) THEN
    CREATE BUFFER hBufferList[iLoop] FOR TABLE ENTRY(iLoop,pcBufferList) NO-ERROR.
  
  IF ERROR-STATUS:ERROR THEN NEXT buffer-loop.
  hQuery:ADD-BUFFER(hBufferList[iLoop]) NO-ERROR.
END. /* buffer-loop */

/* Prepare the query */

/* Now strip DB name from query */
RUN removeDBPrefix (INPUT-OUTPUT pcQuery, INPUT cDBList).

lOK = NO.
lOk = hQuery:QUERY-PREPARE(pcQuery) NO-ERROR.

IF lOk THEN
DO:
  ASSIGN plQueryValid = YES.

  /* Open the query */
  hQuery:QUERY-OPEN() NO-ERROR.

  /* Retrieve 1st record */
  hQuery:GET-FIRST() NO-ERROR.

  /* build field lists for query buffers */
  buffer-loop2:
  DO iLoop = 1 TO NUM-ENTRIES(pcBufferList):
    /* Check for DB Prefix */
    cBufferName = IF NUM-ENTRIES(ENTRY(iLoop,pcBufferList),".":U) > 1 THEN ENTRY(2,ENTRY(iLoop,pcBufferList),".":U) ELSE ENTRY(iLoop,pcBufferList).
    field-loop:
    DO iLoop2 = 1 TO hBufferList[iLoop]:NUM-FIELDS:
      ASSIGN hField = hBufferList[iLoop]:BUFFER-FIELD(iLoop2).
      IF hField:DATA-TYPE = "BLOB":U OR hField:DATA-TYPE = "CLOB":U THEN NEXT.

      IF hField:EXTENT = 0 OR plReturnExtents = FALSE THEN
        ASSIGN          
          pcFieldNameList = pcFieldNameList + 
                            (IF pcFieldNameList <> "":U THEN ",":U ELSE "":U) +
                            cBufferName + ".":U + hField:NAME
          pcFieldFormatList = pcFieldFormatList + 
                            (IF pcFieldFormatList <> "":U THEN CHR(1) ELSE "":U) +
                            hField:FORMAT
          pcFieldDataTypeList = pcFieldDataTypeList + 
                            (IF pcFieldDataTypeList <> "":U THEN ",":U ELSE "":U) +
                            hField:DATA-TYPE
          pcFieldLabelList = pcFieldLabelList + 
                            (IF pcFieldLabelList <> "":U THEN CHR(1) ELSE "":U) +
                            (IF hField:LABEL <> ? AND hField:LABEL <> "":U THEN hField:LABEL ELSE "?":U)
          pcFieldCLabelList = pcFieldCLabelList + 
                            (IF pcFieldCLabelList <> "":U THEN CHR(1) ELSE "":U) +
                            (IF hField:COLUMN-LABEL <> ? AND hField:COLUMN-LABEL <> "":U THEN hField:COLUMN-LABEL ELSE "?":U)
          cFieldHandles = cFieldHandles + 
                            (IF cFieldHandles <> "":U THEN ",":U ELSE "":U) +
                            STRING(hField)
          .
      ELSE DO:
        DO iLoop3 = 1 TO hField:EXTENT:
          ASSIGN
            pcFieldNameList = pcFieldNameList + 
                              (IF pcFieldNameList <> "":U THEN ",":U ELSE "":U) +
                              cBufferName + ".":U + hField:NAME + "[":U + STRING(iLoop3) + "]":U
            pcFieldFormatList = pcFieldFormatList + 
                              (IF pcFieldFormatList <> "":U THEN CHR(1) ELSE "":U) +
                              hField:FORMAT
            pcFieldDataTypeList = pcFieldDataTypeList + 
                              (IF pcFieldDataTypeList <> "":U THEN ",":U ELSE "":U) +
                              hField:DATA-TYPE
            pcFieldLabelList = pcFieldLabelList + 
                              (IF pcFieldLabelList <> "":U THEN CHR(1) ELSE "":U) +
                              (IF hField:LABEL <> ? AND hField:LABEL <> "":U THEN hField:LABEL ELSE "?":U)
            pcFieldCLabelList = pcFieldCLabelList + 
                              (IF pcFieldCLabelList <> "":U THEN CHR(1) ELSE "":U) +
                              (IF hField:COLUMN-LABEL <> ? AND hField:COLUMN-LABEL <> "":U THEN hField:COLUMN-LABEL ELSE "?":U)
            cFieldHandles = cFieldHandles + 
                              (IF cFieldHandles <> "":U THEN ",":U ELSE "":U) +
                              STRING(hField)
            .
  
        END.
      END.
      ASSIGN cValue = "?":U.
      IF VALID-HANDLE(hBufferList[iLoop]) AND hBufferList[iLoop]:AVAILABLE = YES THEN
        ASSIGN cValue = hField:BUFFER-VALUE NO-ERROR.
      IF cValue = "":U OR cValue = ? THEN
        ASSIGN cValue = "?":U.

      ASSIGN
        pcFieldValueList = pcFieldValueList + 
                          (IF pcFieldValueList <> "":U THEN CHR(1) ELSE "":U) +
                          cValue
        .

    END. /* field-loop */

  END. /* buffer-loop2 */

END. /* if lok */
ELSE ASSIGN pcBufferList = "":U.

ASSIGN
  pcFieldLabelList = REPLACE(pcFieldLabelList,"?":U,"":U)
  pcFieldCLabelList = REPLACE(pcFieldCLabelList,"?":U,"":U)
  pcFieldValueList = REPLACE(pcFieldValueList,"?":U,"":U)
  .

/* tidy up */
hQuery:QUERY-CLOSE() NO-ERROR.
DELETE OBJECT hQuery NO-ERROR.
ASSIGN hQuery = ?.

buffer-loop3:
DO iLoop = 1 TO NUM-ENTRIES(pcBufferList):
  DELETE OBJECT hBufferList[iLoop] NO-ERROR.
  ASSIGN hBufferList[iLoop] = ?.
END. /* buffer-loop3 */

RUN updateFieldFromRepository.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-assignTTList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE assignTTList Procedure 
PROCEDURE assignTTList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  gcTTList = FILL(",":U,9).
  IF VALID-HANDLE(phTempTable1) THEN
    ENTRY(1,gcTTList) = phTempTable1:NAME.
  IF VALID-HANDLE(phTempTable2) THEN
    ENTRY(2,gcTTList) = phTempTable2:NAME.
  IF VALID-HANDLE(phTempTable3) THEN
    ENTRY(3,gcTTList) = phTempTable3:NAME.
  IF VALID-HANDLE(phTempTable4) THEN
    ENTRY(4,gcTTList) = phTempTable4:NAME.
  IF VALID-HANDLE(phTempTable5) THEN
    ENTRY(5,gcTTList) = phTempTable5:NAME.
  IF VALID-HANDLE(phTempTable6) THEN
    ENTRY(6,gcTTList) = phTempTable6:NAME.
  IF VALID-HANDLE(phTempTable7) THEN
    ENTRY(7,gcTTList) = phTempTable7:NAME.
  IF VALID-HANDLE(phTempTable8) THEN
    ENTRY(8,gcTTList) = phTempTable8:NAME.
  IF VALID-HANDLE(phTempTable9) THEN
    ENTRY(9,gcTTList) = phTempTable9:NAME.
  IF VALID-HANDLE(phTempTable10) THEN
    ENTRY(10,gcTTList) = phTempTable10:NAME.

  IF pcBuffers <> "":U THEN DO:
    DO iLoop = 1 TO NUM-ENTRIES(pcBuffers):
      gcBufferList = IF gcBufferList = "":U THEN ENTRY(iLoop,pcBuffers)
                                            ELSE gcBufferList + ",":U + ENTRY(iLoop,pcBuffers).
      iLoop = iLoop + 1.
    END.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-getBufferList) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getBufferList Procedure 
PROCEDURE getBufferList :
/*------------------------------------------------------------------------------
  Purpose:     Get buffers from query string
  Parameters:  input query string
               output buffer list
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER  pcQueryString             AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcBuffers                 AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDBList                  AS CHARACTER  NO-UNDO.

DEFINE VARIABLE iStart                            AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPosn                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos1                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos2                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos3                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos4                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos5                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos6                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos7                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos8                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iPos9                             AS INTEGER    NO-UNDO.
DEFINE VARIABLE iLen                              AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBuffer                           AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cDB                               AS CHARACTER  NO-UNDO.

ASSIGN iStart = 1.


buffer-loop:
REPEAT WHILE TRUE:

  ASSIGN
    cBuffer = "":U
    iPos1 = INDEX(pcQueryString, " EACH ":U, iStart)
    iPos2 = INDEX(pcQueryString, " FIRST ":U, iStart)
    iPos3 = INDEX(pcQueryString, " LAST ":U, iStart)
    iPos4 = INDEX(pcQueryString, ",EACH ":U, iStart)
    iPos5 = INDEX(pcQueryString, ",FIRST ":U, iStart)
    iPos6 = INDEX(pcQueryString, ",LAST ":U, iStart)
    iPos7 = INDEX(pcQueryString, CHR(10) + "EACH ":U, iStart)
    iPos8 = INDEX(pcQueryString, CHR(10) + "FIRST ":U, iStart)
    iPos9 = INDEX(pcQueryString, CHR(10) + "LAST ":U, iStart)
    iPosn = IF (iPos1 > 0) THEN iPos1 ELSE 999999
    iPosn = IF (iPos2 > 0 AND iPos2 < iPosn) THEN iPos2 ELSE iPosn
    iPosn = IF (iPos3 > 0 AND iPos3 < iPosn) THEN iPos3 ELSE iPosn
    iPosn = IF (iPos4 > 0 AND iPos4 < iPosn) THEN iPos4 ELSE iPosn
    iPosn = IF (iPos5 > 0 AND iPos5 < iPosn) THEN iPos5 ELSE iPosn
    iPosn = IF (iPos6 > 0 AND iPos6 < iPosn) THEN iPos6 ELSE iPosn
    iPosn = IF (iPos7 > 0 AND iPos7 < iPosn) THEN iPos7 ELSE iPosn
    iPosn = IF (iPos8 > 0 AND iPos8 < iPosn) THEN iPos8 ELSE iPosn
    iPosn = IF (iPos9 > 0 AND iPos9 < iPosn) THEN iPos9 ELSE iPosn
    .
  IF iPosn = 0 OR iPosn = 999999 THEN LEAVE buffer-loop.

  IF SUBSTRING(pcQueryString,iPosn + 1,1) = "F":U THEN
    ASSIGN iLen = 6.
  ELSE
    ASSIGN iLen = 5.

  ASSIGN iStart = iPosn + iLen.

  /* Found a buffer - get its name, minus the DB reference */
  ASSIGN
    cBuffer = TRIM(SUBSTRING(pcQueryString,iPosn + iLen))
    iPos1 = INDEX(cBuffer, " ":U)
    iPos2 = INDEX(cBuffer, ",":U)
    iLen = IF (iPos1 > 0) THEN iPos1 ELSE 999999
    iLen = IF (iPos2 > 0 AND iPos2 < iLen) THEN iPos2 ELSE iLen    
    .
    IF iLen = 0 OR iLen = 999999 THEN ASSIGN iLen = LENGTH(cBuffer) + 1.
  ASSIGN
    cBuffer = SUBSTRING(cBuffer,1,iLen - 1).
  
/* Do not strip DB - issue 10252 
  IF NUM-ENTRIES(cBuffer,".":U) = 2 THEN
    ASSIGN cBuffer = ENTRY(2,cBuffer,".":U).  /* strip off DB */
  */
  
  IF NUM-ENTRIES(cBuffer,".":U) = 2 THEN
    ASSIGN cDB = ENTRY(1,cBuffer,".":U).  /* strip off DB */

  IF LENGTH(cDB) > 0 THEN
    ASSIGN
      pcDBList = pcDBList + (IF pcDBList <> "":U THEN ",":U ELSE "":U) +
                  cDB.

  IF LENGTH(cBuffer) > 0 THEN
    ASSIGN
      pcBuffers = pcBuffers + (IF pcBuffers <> "":U THEN ",":U ELSE "":U) +
                  cBuffer
      .
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-removeDBPrefix) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE removeDBPrefix Procedure 
PROCEDURE removeDBPrefix :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT-OUTPUT PARAMETER pcQuery   AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER       pcDBList  AS CHARACTER  NO-UNDO.

  DEFINE VARIABLE iLoop   AS INTEGER    NO-UNDO.
  DEFINE VARIABLE cDBName AS CHARACTER  NO-UNDO.

  DO iLoop = 1 TO NUM-ENTRIES(pcDBList):
    cDBName = ENTRY(iLoop,pcDBList).
    pcQuery = REPLACE(pcQuery,(cDBName + ".":U),"":U).
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-updateFieldFromRepository) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE updateFieldFromRepository Procedure 
PROCEDURE updateFieldFromRepository :
/*------------------------------------------------------------------------------
  Purpose:     This procedure will get the data from fields from the repository
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDataFieldName    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iLoop             AS INTEGER    NO-UNDO.
  DEFINE VARIABLE hObjectBuffer     AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hAttributeBuffer  AS HANDLE     NO-UNDO.
  DEFINE VARIABLE dInstanceId       AS DECIMAL    NO-UNDO.
  DEFINE VARIABLE cFieldFormat      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldLabel       AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cFieldCLabel      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE hFieldFormat      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFieldLabel       AS HANDLE     NO-UNDO.
  DEFINE VARIABLE hFieldCLabel      AS HANDLE     NO-UNDO.
  DEFINE VARIABLE cPropertyNames    AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cPropertyValues   AS CHARACTER  NO-UNDO.

  DO iLoop = 1 TO NUM-ENTRIES(pcFieldNameList):
    ASSIGN cDataFieldName  = ENTRY(iLoop,pcFieldNameList)
           cPropertyNames  = "Format,Label,ColumnLabel":U
           cPropertyValues = "":U.
    
    RUN getInstanceProperties IN gshRepositoryManager ( INPUT  cDataFieldName,
                                                         INPUT  "",
                                                         INPUT-OUTPUT cPropertyNames,
                                                        OUTPUT cPropertyValues ) NO-ERROR.
    ASSIGN cFieldFormat = ENTRY(LOOKUP("Format":U, cPropertyNames), cPropertyValues, CHR(1) ) 
           cFieldFormat = IF cFieldFormat = "?":U THEN ENTRY(iLoop,pcFieldFormatList,CHR(1)) ELSE cFieldFormat
           cFieldLabel  = ENTRY(LOOKUP("Label":U, cPropertyNames), cPropertyValues, CHR(1) ) 
           cFieldLabel  = IF cFieldLabel = "?":U THEN ENTRY(iLoop,pcFieldLabelList,CHR(1)) ELSE cFieldLabel
           cFieldLabel =  IF cFieldLabel = "?":U  THEN "" ELSE cFieldLabel 
           cFieldCLabel = ENTRY(LOOKUP("ColumnLabel":U, cPropertyNames), cPropertyValues, CHR(1) ) 
           cFieldCLabel = IF cFieldCLabel = "?":U THEN ENTRY(iLoop,pcFieldCLabelList,CHR(1)) ELSE cFieldCLabel
           cFieldCLabel = IF cFieldCLabel = "?":U THEN cFieldLabel ELSE cFieldCLabel
           NO-ERROR.
    
    /* Assign default values from Schema */
    ASSIGN ENTRY(iLoop,pcFieldFormatList,CHR(1)) = cFieldFormat
           ENTRY(iLoop,pcFieldLabelList,CHR(1))  = cFieldLabel
           ENTRY(iLoop,pcFieldCLabelList,CHR(1)) = cFieldCLabel.
  END. /* DO iLoop */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


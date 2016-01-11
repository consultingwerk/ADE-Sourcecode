&ANALYZE-SUSPEND _VERSION-NUMBER AB_v10r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*************************************************************/
/* Copyright (c) 1984-2005 by Progress Software Corporation  */
/*                                                           */
/* All rights reserved.  No part of this program or document */
/* may be  reproduced in  any form  or by  any means without */
/* permission in writing from PROGRESS Software Corporation. */
/*************************************************************/
/*---------------------------------------------------------------------------
 File        : adeuib/_rundsinclude.p
 Purpose     : run a datasource from an include.
 Parameters  : pcInclude - include file that defines a single temp-table 
                           or a single dataset (with temp-tables).  
               pctable   - optional table  
                           As of current this is only applied when the
                           include has a dataset.                             
       output phDataview - The handle of a new DataView instance  
------------------------------------------------------------------------------               
 Notes: Temp-table include
          The Dataview is returned with RowObject set to a new dynamic 
          instance of the include file's temp-table defintion.  
        Dataset include
          The Dataview is returned with a running DatasetSource, which is a 
          procedure wrapper/instance for a new dynamic instance of the 
          include file's dataset definition. 
          The DataTable and corresponding RowObject is set to the buffer 
          specified by the passed pcTable. 
          if pcTable is not specified by the caller the DataView will be 
          returned unprepared without a defined DataTable. 
          In this case the caller is responsible of setting the DataTable 
          and then run createObjects in the DataView.     
  ---------------------------------------------------------------------------*/

/* ***************************  Definitions  ******************************* */

DEFINE INPUT  PARAMETER pcInclude  AS CHARACTER  NO-UNDO.
DEFINE INPUT  PARAMETER pcTable    AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER phDataView AS HANDLE     NO-UNDO.
  
DEFINE STREAM FileStream.

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
         HEIGHT             = 14
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DEFINE VARIABLE cDataSet     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cTables      AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFile        AS CHARACTER  NO-UNDO.
DEFINE VARIABLE hData        AS HANDLE     NO-UNDO.
DEFINE VARIABLE hTable       AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDatasetProc AS HANDLE     NO-UNDO.
DEFINE VARIABLE iTable       AS INTEGER    NO-UNDO.
DEFINE VARIABLE cBuffers     AS CHARACTER  NO-UNDO.

RUN parseFile (pcInclude, OUTPUT cDataset, OUTPUT cTables). 

IF NUM-ENTRIES(cDataSet) > 1 THEN
  MESSAGE "The include file cannot have more than one dataset." 
  VIEW-AS ALERT-BOX INFORMATION.

IF cDataset = '' AND NUM-ENTRIES(cTables) > 1 THEN
  MESSAGE "The include file cannot have more than one temp-table"
          "without a dataset definition." 
  VIEW-AS ALERT-BOX INFORMATION.
 
IF NUM-ENTRIES(cDataSet) = 1 THEN
DO:
  RUN generateDataSet (pcInclude,cDataSet,OUTPUT cFile).
  /* if a single table (and no table is passed) make it default */
  IF pcTable = '' AND NUM-ENTRIES(cTables) = 1 THEN
    pcTable = cTables.
END.
ELSE IF NUM-ENTRIES(cTables) = 1 THEN
  RUN generateTempTable (pcInclude,cTables,OUTPUT cFile).
 
IF cFile > '':U THEN
DO ON STOP UNDO,LEAVE:
  RUN VALUE(cFile) (OUTPUT hData).
END.

OS-DELETE VALUE(cFile).

IF VALID-HANDLE(hData) THEN 
DO:
  IF pcTable > '':U 
  AND hData:TYPE = "DATASET":U  
  AND NOT VALID-HANDLE(hData:GET-BUFFER-HANDLE(pcTable)) THEN
    MESSAGE 'The specified "' pcTable '"table is not defined in the dataset.'
    VIEW-AS ALERT-BOX INFORMATION.
  ELSE DO: /* all set to start the object(s) */
    RUN adm2/dyndataview.w PERSISTENT SET phDataView.
    IF hData:TYPE = "TEMP-TABLE":U THEN
    DO:
     {set DataTable hData:NAME phDataView}.
     {set RowObject hData:DEFAULT-BUFFER-HANDLE phDataView}.
    END.
    ELSE 
    DO:
      RUN adm2/dyndataset.w PERSISTENT SET hDataSetProc.
      {set DatasetHandle hData hDataSetProc}.  
      {set DatasetSource hDataSetProc phDataView}.  
      IF pcTable > '' THEN
        {set DataTable pcTable phDataView}.
      
      /* The dataset procedure is not started normally, since there is no 
         business entity at this stage. We need to ensure that the dataset
         proceure is shut down when the dataview shuts down, to avoid a 
         memory leak.
       */
      subscribe procedure hDataSetProc to 'DestroyObject':u in phDataView.
    END.
    RUN createObjects IN phDataView.
  END. /* else (everything is ok) */  
END. /* valid-handle hdata */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-generateDataset) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateDataset Procedure 
PROCEDURE generateDataset :
/*------------------------------------------------------------------------------
  Purpose:   generate a procedure that returns a dynamic dataset from an include 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInclude  AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcDataSet  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTempFile AS CHARACTER  NO-UNDO.

  RUN adecomm/_tmpfile.p
      (INPUT "", INPUT ".p", OUTPUT pcTempFile).

  OUTPUT STREAM FileStream TO VALUE(pcTempFile) NO-MAP.

  PUT STREAM FileStream UNFORMATTED 
  "~{" pcInclude "~}" SKIP
  "DEFINE OUTPUT PARAMETER phDataSet AS HANDLE." SKIP 
  "RUN createDataSet(OUTPUT DATASET-HANDLE phDataSet)." SKIP 
  "PROCEDURE createDataSet:":U SKIP
  "  DEFINE OUTPUT PARAMETER DATASET FOR ":U pcDataSet "." SKIP
  "END.":U SKIP.

  OUTPUT STREAM FileStream CLOSE.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-generateTempTable) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE generateTempTable Procedure 
PROCEDURE generateTempTable :
/*------------------------------------------------------------------------------
  Purpose:   generate a procedure that returns a temp-table from an include 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER pcInclude    AS CHARACTER  NO-UNDO.
  DEFINE INPUT  PARAMETER pcTempTable  AS CHARACTER  NO-UNDO.
  DEFINE OUTPUT PARAMETER pcTempFile   AS CHARACTER  NO-UNDO.

  RUN adecomm/_tmpfile.p
      (INPUT "", INPUT ".p", OUTPUT pcTempFile).

  OUTPUT STREAM FileStream TO VALUE(pcTempFile) NO-MAP.

  PUT STREAM FileStream UNFORMATTED 
  "~{" pcInclude "~}" SKIP
  "DEFINE OUTPUT PARAMETER phTempTable AS HANDLE." SKIP 
  "RUN createTempTable(OUTPUT TABLE-HANDLE phTempTable)." SKIP 
  "PROCEDURE createTempTable:":U SKIP
  "  DEFINE OUTPUT PARAMETER TABLE FOR ":U pcTempTable "." SKIP
  "END.":U SKIP.

  OUTPUT STREAM FileStream CLOSE.
 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-parseFile) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE parseFile Procedure 
PROCEDURE parseFile :
/*------------------------------------------------------------------------------
     Purpose: Parses file and extracts all temp-table definitions
  Parameters: 
                 pcFileName   Name of file to parse
         OUTPUT  pcTables     Comma delimited list of tables extracted
         OUTPUT  pcDatasets   Comma delimited list of datasets extracted
       Notes: returns ERROR on error.     
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pcFileName  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcDatasets  AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAMETER pcTables    AS CHARACTER  NO-UNDO.

 &SCOPED-DEFINE SourceFile pcFilename
 &SCOPED-DEFINE DataSets pcDatasets
 &SCOPED-DEFINE Tables pcTables
 &SCOPED-DEFINE StreamName FileStream

 {adeuib/parsedefs.i}

 IF ERROR-STATUS:ERROR THEN
   RETURN ERROR.

 IF COMPILER:ERROR THEN
   RETURN ERROR ERROR-STATUS:GET-MESSAGE(1).

 &UNDEFINE SourceFile
 &UNDEFINE DataSets
 &UNDEFINE Tables
 &UNDEFINE StreamName

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


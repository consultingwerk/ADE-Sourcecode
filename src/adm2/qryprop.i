&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : qryprop.i
    Purpose     : Starts query.p Super procedure and defines Basic Query Object
                  properties.
    Syntax      : {src/adm2/qryprop.i}

    Description :

    Modified    : May 15, 2000 -- Version 9.1B
    Modified    : 10/24/2001            Mark Davies (MIP0
                  Added new property FilterAvailable.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  {src/adm2/custom/querydefscustom.i}
&ENDIF

/* This variable designates the maximal length of any database 
   table index within the Rocket. If the total length of index 
   fields exceeds this limit, PROGRESS raises a run-time error. */ 
DEF VAR xiRocketIndexLimit AS INTEGER INIT 188 NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Include
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Include ASSIGN
         HEIGHT             = 4.57
         WIDTH              = 42.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */


  /* Include the file which defines prototypes for all of the super
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/qryprto.i}
  &ENDIF
&ENDIF

 /* Preprocessors to define properties that can be retrieved
    directly from the property temp-table. */
 &GLOB xpAssignList 
 &GLOB xpAuditEnabled
 &GLOB xpBaseQuery                               
 &GLOB xpCalcFieldList
 &GLOB xpCheckLastOnOpen
 &GLOB xpDataColumnsByTable 
 &GLOB xpEntityFields
 &GLOB xpFetchAutoComment
 &GLOB xpFetchHasAudit
 &GLOB xpFetchHasComment
 &GLOB xpFirstResultRow            
 &GLOB xpLastDBRowIdent
 &GLOB xpLastResultRow            
 &GLOB xpNewBatchInfo
 &GLOB xpNoLockReadOnlyTables
 &GLOB xpPhysicalTables
 &GLOB xpPositionForClient 
 &GLOB xpQueryHandle            
 &GLOB xpQueryRowIdent
 &GLOB xpRequiredProperties
 &GLOB xpSkipTransferDbRow
 &GLOB xpTempTables 
 &GLOB xpUpdatableColumnsByTable 
 &GLOB xpUpdateFromSource
                    
 {src/adm2/dataqueryprop.i}
 
 /* the data class derives this from UpdatableColumnsByTable */  
 &UNDEFINE xpUpdatableColumns  
 
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
 
&IF "{&ADMSuper}":U = "":U &THEN
  /* Keep these in alphabetical order */
  ghADMProps:ADD-NEW-FIELD('AssignList':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('AuditEnabled':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('BaseQuery':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CalcFieldList':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CheckLastOnOpen':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('DataColumnsByTable':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DBNames':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('EntityFields':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('FetchHasAudit':U, 'LOGICAL':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('FetchHasComment':U, 'LOGICAL':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('FetchAutoComment':U, 'LOGICAL':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('FirstResultRow':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('KeyFields':U, 'CHARACTER':U, 0, ?, '{&KEY-FIELDS}':U). 
  ghADMProps:ADD-NEW-FIELD('KeyTableId':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LastDBRowIdent':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LastResultRow':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('NewBatchInfo':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('NoLockReadOnlyTables':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('PhysicalTables':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('PositionForClient':U, 'CHARACTER':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('QueryHandle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('QueryRowIdent':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('RequiredProperties':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('SkipTransferDBRow':U, 'LOGICAL':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('TempTables':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('UpdatableColumnsByTable':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('UpdateFromSource':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('WordIndexedFields':U, 'CHAR':U, 0, ?,?).
  
&ENDIF

  {src/adm2/custom/qrypropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



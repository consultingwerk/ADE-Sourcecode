&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
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
/*--------------------------------------------------------------------------
    File        : dataprop.i
    Purpose     : Starts data.p Super procedure and defines Basic DataObject
                  properties.
    Syntax      : {src/adm2/dataprop.i}

    Description :

    Modified    : June 26, 2000 Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/datadefscustom.i}

  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
AppService,ASUsePrompt,ASInfo,ForeignFields,RowsToBatch,CheckCurrentChanged,~
RebuildOnRepos,ServerOperatingMode,DestroyStateless,DisconnectAppServer,~
ObjectName,UpdateFromSource

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/datad.w
&ENDIF

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
         HEIGHT             = 8
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */


  /* Include the file which defines prototypes for all of the super
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/dataprto.i}
&ENDIF
 
 /* Preprocessor definitions which tell at compile time which
    properties can be retrieved directly from the property temp-table. */
 &GLOB xpRowObject
 &GLOB xpRowObjUpd
 &GLOB xpRowObjUpdTable
 &GLOB xpFirstRowNum            
 &GLOB xpLastRowNum                    
 &GLOB xpAutoCommit             
 &GLOB xpDataHandle
 &GLOB xpDataQueryString
 &GLOB xpCurrentRowid                                                         
 &GLOB xpUpdateSource           
 &GLOB xpCommitSource           
 &GLOB xpCommitSourceEvents     
 &GLOB xpCommitTarget           
 &GLOB xpCommitTargetEvents     
 &GLOB xpDataModified
 &GLOB xpRowsToBatch
 &GLOB xpCheckCurrentChanged
 &GLOB xpFirstResultRow
 &GLOB xpLastResultRow
 &GLOB xpRebuildOnRepos
 &GLOB xpStatelessSavedProperties
 &GLOB xpDestroyStateless
 &GLOB xpDisconnectAppserver
 &GLOB xpDataFieldDefs
 &GLOB xpQueryContainer
 &GLOB xpQueryContext
 &GLOB xpFillBatchOnRepos
 &GLOB xpUpdateFromSource
 
{src/adm2/qryprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('RowObject':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RowObjUpd':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RowObjectTable':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RowObjUpdTable':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('FirstRowNum':U, 'INT':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('LastRowNum':U, 'INT':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('AutoCommit':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('DataHandle':U, 'HANDLE':U).   
  ghADMProps:ADD-NEW-FIELD('DataQueryString':U, 'CHAR':U, 0, ?, 
    'FOR EACH RowObject':U).
  ghADMProps:ADD-NEW-FIELD('CurrentRowid':U, 'ROWID':U).
  ghADMProps:ADD-NEW-FIELD('ASHandle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('UpdateSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('CommitSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('CommitSourceEvents':U, 'CHAR':U, 0, ?, 
    'commitTransaction,undoTransaction':U).
  ghADMProps:ADD-NEW-FIELD('CommitTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CommitTargetEvents':U, 'CHAR':U, 0, ?, 'rowObjectState':U).
  ghADMProps:ADD-NEW-FIELD('DataModified':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('RowsToBatch':U, 'INT':U, 0, ?, 200).  /* Rows per AppServer xfer */
  ghADMProps:ADD-NEW-FIELD('CheckCurrentChanged':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('DataQueryBrowsed':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('FirstResultRow':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('LastResultRow':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RebuildOnRepos':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('RowObjectState':U, 'CHAR':U, 0, ?, 'NoUpdates':U).
  ghADMProps:ADD-NEW-FIELD('StatelessSavedProperties':U, 'CHAR':U, 0, ?, 
    'CheckCurrentChanged,RowObjectState,LastResultRow,FirstResultRow,QueryRowIdent':U).
  ghADMProps:ADD-NEW-FIELD('DestroyStateless':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('DisconnectAppServer':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('ServerSubmitValidation':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('DataFieldDefs':U, 'CHARACTER':U, 0, ?, 
      '{&DATA-FIELD-DEFS}':U).
                                             /* Key-fields not yet supported */
  ghADMProps:ADD-NEW-FIELD('KeyFields':U, 'CHAR':U, 0, ?, '{&KEY-FIELDS}':U).
  ghADMProps:ADD-NEW-FIELD('QueryContainer':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('IndexInformation':U, 'CHARACTER':U, 0, ?,?). 
  ghADMProps:ADD-NEW-FIELD('QueryContext':U, 'CHARACTER':U, 0, ?,?). 
  ghADMProps:ADD-NEW-FIELD('FillBatchOnRepos':U, 'LOGICAL':U, 0, ?, YES).
  ghADMProps:ADD-NEW-FIELD('UpdateFromSource':U, 'LOGICAL':U, 0, ?, NO).
&ENDIF

  {src/adm2/custom/datapropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



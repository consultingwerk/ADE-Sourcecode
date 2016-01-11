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

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  {src/adm2/custom/datadefscustom.i}
  
 &IF "{&xcInstanceProperties}":U NE "":U &THEN       
    &GLOB xcInstanceProperties {&xcInstanceProperties},
 &ENDIF                                           

&GLOB xcInstanceProperties {&xcInstanceProperties}~
AppService,ASInfo,ASUsePrompt,CacheDuration,CheckCurrentChanged,~
DestroyStateless,DisconnectAppServer,ServerOperatingMode,ShareData,~
UpdateFromSource

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/datad.w
&ENDIF

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
         HEIGHT             = 4.29
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

&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/dataprto.i}
  &ENDIF
&ENDIF
 
 /* Preprocessor definitions which tell at compile time which
    properties can be retrieved directly from the property temp-table. */
 
 &GLOB xpRowObjUpd
 &GLOB xpCheckCurrentChanged
 &GLOB xpStatelessSavedProperties
 &GLOB xpDestroyStateless
 &GLOB xpDisconnectAppserver
 &GLOB xpDataFieldDefs
 &GLOB xpQueryContainer
 &GLOB xpQueryContext
 &GLOB xpAsynchronousSDO
 &GLOB xpDataLogicObject
 &GLOB xpDataDelimiter                    
 &GLOB xpDataReadHandler 
 &GLOB xpDataReadBuffer 
 &GLOB xpDataReadColumns                    
 &GLOB xpDataReadFormat                    
 &GLOB xpManualAddQueryWhere        
 &GLOB xpIsRowObjectExternal
 &GLOB xpIsRowObjUpdExternal
 &GLOB xpDynamicData
 &GLOB xpLastCommitErrorType  
 &GLOB xpLastCommitErrorKeys  
 &GLOB xpRunDataLogicProxy
 &GLOB xpSchemaLocation
 &GLOB xpCacheDuration
 &GLOB xpShareData
 
 
{src/adm2/qryprop.i}

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
 
  ghADMProps:ADD-NEW-FIELD('RowObjUpd':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RowObjectTable':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RowObjUpdTable':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('CheckCurrentChanged':U, 'LOGICAL':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('StatelessSavedProperties':U, 'CHAR':U, 0, ?, 
    'CheckCurrentChanged,RowObjectState,LastResultRow,FirstResultRow,QueryRowIdent':U).
  ghADMProps:ADD-NEW-FIELD('DestroyStateless':U, 'LOGICAL':U, 0, ?, YES).
  ghADMProps:ADD-NEW-FIELD('DisconnectAppServer':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('ServerSubmitValidation':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('DataFieldDefs':U, 'CHARACTER':U, 0, ?, 
      '{&DATA-FIELD-DEFS}':U).
  ghADMProps:ADD-NEW-FIELD('QueryContainer':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('QueryContext':U, 'CHARACTER':U, 0, ?,?). 
  ghADMProps:ADD-NEW-FIELD('AsynchronousSDO':U, 'LOGICAL':U, ?, ?, TRUE).   
  ghADMProps:ADD-NEW-FIELD('DataLogicProcedure':U, 'CHARACTER':U, ?, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DataLogicObject':U, 'HANDLE':U, ?, ?, ?).
  ghADMProps:ADD-NEW-FIELD('DataReadHandler':U, 'HANDLE':U, ?, ?, ?).
  ghADMProps:ADD-NEW-FIELD('DataReadColumns':U, 'CHARACTER':U, ?, ?, ?).
  ghADMProps:ADD-NEW-FIELD('DataReadBuffer':U, 'HANDLE':U, ?, ?, ?).
  ghADMProps:ADD-NEW-FIELD('DataDelimiter':U, 'CHARACTER':U, ?, ?, '|':U).
  ghADMProps:ADD-NEW-FIELD('DataReadFormat':U, 'CHARACTER':U, ?, ?, 'TrimNumeric':U).
  ghADMProps:ADD-NEW-FIELD('IsRowObjectExternal':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('IsRowObjUpdExternal':U, 'LOGICAL':U, 0, ?, NO).


/* The following properties are used to store query manipluation strings made
   manually. If you change the query manually in code, you should set these
   properties. The filter window will retrieve these settings again when reapplying
   the filter, thus ensuring the original query is not corrupted by the Astra
   filter. Each property is chr(3) delimited to match the parameters that should
   be passed to each of the routines when reapplying them.
   
   Note that multiple entries are supported, seperated by chr(4), but this must
   be done manually - the set procedure does not do this automatically, but the
   filter will handle it when retrieving the values.
   To add multiple entries, be sure to do a get first and if a value exists, add
   a chr(4) before adding in your value and setting the new value.*/

  /* pcwhere + chr(3) + pcbuffer or empty or "?" + chr(3) + pcandor */
  ghADMProps:ADD-NEW-FIELD('ManualAddQueryWhere':U, 'CHARACTER':U).   
  ghADMProps:ADD-NEW-FIELD('DynamicData':U, 'LOGICAL':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('LastCommitErrorType':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('LastCommitErrorKeys':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RunDataLogicProxy':U, 'LOGICAL':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('SchemaLocation':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CacheDuration':U, 'INTEGER':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('ShareData':U, 'LOGICAL':U, 0, ?, NO).

&ENDIF

  {src/adm2/custom/datapropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



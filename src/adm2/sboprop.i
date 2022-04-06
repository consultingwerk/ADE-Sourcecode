&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : sboprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/sboprop.i}

    Description :

    Modified    : October 25, 2000 -- Version 9.1C
    Modified    : 16/11/2001    Mark Davies (MIP)
                  Added new property FilterAvailable
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  /* Define the maximum number of SDOs the SBO can handle. 
     This corresponds to the number of TABLE-HANDLE parameters
     passed to the server, and is used as an array extent in sbo.p. */
  &GLOB MaxContainedDataObjects 20

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
AppService,UpdateOrder,CascadeOnBrowse,OpenOnInit,ForeignFields

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/sbod.w
&ENDIF

  /* Custom instance definition file */

  {src/adm2/custom/sbodefscustom.i}

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
     procedure's entry points. 
     And skip including the prototypes if we are *any* super procedure. */
&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/sboprto.i}
  &ENDIF
&ENDIF

&GLOBAL-DEFINE xpMasterDataObject
&GLOBAL-DEFINE xpContainedDataColumns
&GLOBAL-DEFINE xpDataColumns
&GLOBAL-DEFINE xpOpenOnInit
&GLOBAL-DEFINE xpAutoCommit
&GLOBAL-DEFINE xpCascadeOnBrowse
&GLOBAL-DEFINE xpObjectMapping
&GLOBAL-DEFINE xpForeignFields
&GLOBAL-DEFINE xpForeignValues
&GLOBAL-DEFINE xpDataObjectOrdering
&GLOBAL-DEFINE xpUpdateStateInProcess
&GLOBAL-DEFINE xpBlockDataAvailable
&GLOBAL-DEFINE xpBlockQueryPosition
&GLOBAL-DEFINE xpFilterWindow
&GLOBAL-DEFINE xpCurrentUpdateSource
&GLOBAL-DEFINE xpDataIsFetched
&GLOBAL-DEFINE xpUpdateTables
&GLOBAL-DEFINE xpDataLogicObject
&GLOBAL-DEFINE xpDynamicData
&GLOBAL-DEFINE xpLastCommitErrorType
&GLOBAL-DEFINE xpLastCommitErrorKeys
&GLOBAL-DEFINE xpUpdateOrder

{src/adm2/cntnprop.i}

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
   ghADMProps:ADD-NEW-FIELD('MasterDataObject':U, 'HANDLE':U, 0, ?, ?).
   ghADMProps:ADD-NEW-FIELD('ContainedDataColumns':U, 'CHARACTER':U, 0, ?,'':U).
   ghADMProps:ADD-NEW-FIELD('RowObjectState':U, 'CHARACTER':U, 0, ?, 
      'NoUpdates':U).
   ghADMProps:ADD-NEW-FIELD('DataObjectNames':U, 'CHARACTER':U, 0, ?, 
      '{&Data-Object-Names}':U). 
   ghADMProps:ADD-NEW-FIELD('DataColumns':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('OpenOnInit':U, 'LOGICAL':U, 0, ?, yes). 
   ghADMProps:ADD-NEW-FIELD('AutoCommit':U, 'LOGICAL':U, 0, ?, no). 
   ghADMProps:ADD-NEW-FIELD('CascadeOnBrowse':U, 'LOGICAL':U, 0, ?, yes).
   ghADMProps:ADD-NEW-FIELD('ObjectMapping':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('ForeignFields':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('ForeignValues':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('DataObjectOrdering':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('UpdateStateInProcess':U, 'LOGICAL':U, 0, ?, no). 
   ghADMProps:ADD-NEW-FIELD('BlockDataAvailable':U, 'LOGICAL':U, 0, ?, NO). 
   ghADMProps:ADD-NEW-FIELD('FilterAvailable':U, 'LOGICAL':U, 0, ?, no).
   ghADMProps:ADD-NEW-FIELD('BlockQueryPosition':U, 'LOGICAL':U, 0, ?, NO). 
   ghADMProps:ADD-NEW-FIELD('FilterActive':U, 'LOGICAL':U, 0, ?, ?).
   ghADMProps:ADD-NEW-FIELD('FilterWindow':U, 'CHARACTER':U).
   ghADMProps:ADD-NEW-FIELD('CurrentUpdateSource':U, 'HANDLE':U).
   ghADMProps:ADD-NEW-FIELD('DataIsFetched':U, 'LOGICAL':U, 0, ?, no).
   ghADMProps:ADD-NEW-FIELD('UpdateTables':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('DataLogicProcedure':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('DataLogicObject':U, 'HANDLE':U).
   ghADMProps:ADD-NEW-FIELD('DynamicData':U, 'LOGICAL':U, 0, ?, no).
   ghADMProps:ADD-NEW-FIELD('LastCommitErrorType':U, 'CHAR':U, 0, ?, ?).
   ghADMProps:ADD-NEW-FIELD('LastCommitErrorKeys':U, 'CHAR':U, 0, ?, ?).
   ghADMProps:ADD-NEW-FIELD('UpdateOrder':U, 'CHARACTER':U, 0, ?, '':U). 
&ENDIF

  {src/adm2/custom/sbopropcustom.i}

END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



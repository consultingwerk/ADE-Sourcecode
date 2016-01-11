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
* The contents of this file are subject to the Progress Public       *
* License Version 1.0 (the "License"); you may not use this file     *
* except in compliance with the License.  A copy of the License is   *
* available as of the date of this notice at                         *
* http://www.sourcepro.org/PPL/                                      *
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
    File        : sboprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/sboprop.i}

    Description :

    Modified    : October 25, 2000 -- Version 9.1C
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  /* Define the maximum number of SDOs the SBO can handle. 
     This corresponds to the number of TABLE-HANDLE parameters
     passed to the server, and is used as an array extent in sbo.p. */
  &GLOB MaxContainedDataObjects 20

  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
AppService,DataObjectNames,CascadeOnBrowse

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/sbod.w
&ENDIF

  /* Custom instance definition file */

  {src/adm2/custom/sbodefscustom.i}

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
&IF "{&ADMSuper}":U EQ "":U &THEN
  {src/adm2/sboprto.i}
&ENDIF
 
&GLOBAL-DEFINE xpCommitSource
&GLOBAL-DEFINE xpCommitSourceEvents
&GLOBAL-DEFINE xpNavigationSource
&GLOBAL-DEFINE xpNavigationSourceEvents
&GLOBAL-DEFINE xpMasterDataObject
&GLOBAL-DEFINE xpContainedDataColumns
&GLOBAL-DEFINE xpContainedDataObjects
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

{src/adm2/cntnprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
   ghADMProps:ADD-NEW-FIELD('CommitSource':U, 'HANDLE':U, 0, ?, ?).
   ghADMProps:ADD-NEW-FIELD('CommitSourceEvents':U, 'CHAR':U, 0, ?, 
          'commitTransaction,undoTransaction':U).
   ghADMProps:ADD-NEW-FIELD('NavigationSource':U, 'CHARACTER':U, 0, ?, '':U).
   ghADMProps:ADD-NEW-FIELD('NavigationSourceEvents':U, 'CHAR':U, 0, ?, 
          'fetchFirst,fetchNext,fetchPrev,fetchLast,registerObject':U).
   ghADMProps:ADD-NEW-FIELD('MasterDataObject':U, 'HANDLE':U, 0, ?, ?).
   ghADMProps:ADD-NEW-FIELD('ContainedDataColumns':U, 'CHARACTER':U, 0, ?,'':U).
   ghADMProps:ADD-NEW-FIELD('ContainedDataObjects':U, 'CHARACTER':U, 0, ?,'':U).
   ghADMProps:ADD-NEW-FIELD('RowObjectState':U, 'CHARACTER':U, 0, ?, 
      'NoUpdates':U).
   ghADMProps:ADD-NEW-FIELD('DataObjectNames':U, 'CHARACTER':U, 0, ?, 
      '{&Data-Object-Names}':U). 
   ghADMProps:ADD-NEW-FIELD('DataColumns':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('OpenOnInit':U, 'LOGICAL':U, 0, ?, yes). 
   ghADMProps:ADD-NEW-FIELD('AutoCommit':U, 'LOGICAL':U, 0, ?, no). 
   ghADMProps:ADD-NEW-FIELD('CascadeOnBrowse':U, 'LOGICAL':U, 0, ?, yes).
   ghADMProps:ADD-NEW-FIELD('ASHandle':U, 'HANDLE':U, 0, ?, ?). 
   ghADMProps:ADD-NEW-FIELD('ObjectMapping':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('ForeignFields':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('ForeignValues':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('DataObjectOrdering':U, 'CHARACTER':U, 0, ?, '':U). 
   ghADMProps:ADD-NEW-FIELD('UpdateStateInProcess':U, 'LOGICAL':U, 0, ?, no). 
   ghADMProps:ADD-NEW-FIELD('BlockDataAvailable':U, 'LOGICAL':U, 0, ?, NO). 

&ENDIF

  {src/adm2/custom/sbopropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



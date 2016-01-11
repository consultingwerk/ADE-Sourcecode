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
    File        : cntnprop.i
    Purpose     : Starts containr.p super procedure and defines general
                  SmartContainer properties and other values.
    Syntax      : {src/adm2/cntnprop.i}

    Description :

    Modified    : August 1, 2000 -- Version 9.1B
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  {src/adm2/custom/containrdefscustom.i}

 &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
 &ENDIF
  
 &GLOB xcInstanceProperties {&xcInstanceProperties}LogicalObjectName,PhysicalObjectName,DynamicObject,RunAttribute

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
         HEIGHT             = 18.71
         WIDTH              = 66.6.
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
  {src/adm2/cntnprto.i}
&ENDIF

  /* Preprocs to identify to compiler which properties are in the temp-table.*/
  &GLOBAL-DEFINE xpCurrentPage
  &GLOBAL-DEFINE xpContainerTarget
  &GLOBAL-DEFINE xpContainerTargetEvents
  &GLOBAL-DEFINE xpToolbarSource
  &GLOBAL-DEFINE xpToolbarSourceEvents
  &GLOBAL-DEFINE xpOutMessageTarget
  &GLOBAL-DEFINE xpPageNTarget
  &GLOBAL-DEFINE xpPageSource
  &GLOBAL-DEFINE xpFilterSource
  &GLOBAL-DEFINE xpUpdateSource
  &GLOBAL-DEFINE xpUpdateTarget
  &GLOBAL-DEFINE xpCommitSourceEvents
  &GLOBAL-DEFINE xpCommitTarget           
  &GLOBAL-DEFINE xpCommitTargetEvents    
  &GLOBAL-DEFINE xpStartPage
  &GLOBAL-DEFINE xpRunMultiple
  &GLOBAL-DEFINE xpWaitForObject
  &GLOBAL-DEFINE xpDynamicSDOProcedure
  &GLOBAL-DEFINE xpRunDOOptions
  &GLOBAL-DEFINE xpInitialPageList  /* comma delimited list of pages to construct at startup or * for all or empty for just start page and page 0 */
  &GLOBAL-DEFINE xpWindowFrameHandle
  /* for support of Layout Managers */
 &GLOBAL-DEFINE xpPage0LayoutManager
 
 /* for support Navigation as Pass-Through link */
 &GLOBAL-DEFINE xpNavigationSource        
 &GLOBAL-DEFINE xpNavigationSourceEvents
 &GLOBAL-DEFINE xpNavigationTarget
 
 &GLOBAL-DEFINE xpMultiInstanceSupported
 &GLOBAL-DEFINE xpMultiInstanceActivated
 &GLOBAL-DEFINE xpContainerMode
 &GLOBAL-DEFINE xpSavedContainerMode
 &GLOBAL-DEFINE xpSdoForeignFields
 &GLOBAL-DEFINE xpPrimarySdoTarget
 &GLOBAL-DEFINE xpCallerWindow
 &GLOBAL-DEFINE xpCallerProcedure
 &GLOBAL-DEFINE xpCallerObject
 &GLOBAL-DEFINE xpDisabledAddModeTabs
 &GLOBAL-DEFINE xpReEnableDataLinks
 &GLOBAL-DEFINE xpWindowTitleViewer
 &GLOBAL-DEFINE xpUpdateActive
 &GLOBAL-DEFINE xpObjectsCreated
 &GLOBAL-DEFINE xpInstanceNames
 &GLOBAL-DEFINE xpClientNames
 &GLOBAL-DEFINE xpDataContainer
 &GLOBAL-DEFINE xpContainedDataObjects
 &GLOBAL-DEFINE xpContainedAppServices
 &GLOBAL-DEFINE xpHasDynamicProxy

  /* Now include the next-level-up property include file. This builds up
     the property temp-table definition, which we will then add our 
     field definitions to. If this is a non-visual ('virtual') container,
     then skip the visual properties */  
&IF "{&ADM-CONTAINER}":U = "VIRTUAL":U &THEN
  /* Directly to smart properties */
  &IF DEFINED(APP-SERVER-VARS) = 0 &THEN
    {src/adm2/smrtprop.i}
  /* else if appserver aware (adecomm/appserv.i) include appserver props */
  &ELSE
    {src/adm2/appsprop.i}
  &ENDIF
&ELSE /* visprop has the same conditional inclusion of appserver as above */ 
    {src/adm2/visprop.i}
&ENDIF

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('CurrentPage':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('ContainerTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ContainerTargetEvents':U, 'CHAR':U, 0, ?,
    'exitObject,okObject,cancelObject,updateActive':U).
  ghADMProps:ADD-NEW-FIELD('ToolbarSource':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ToolbarSourceEvents':U, 'CHAR':U, 0, ?,
    'toolbar,okObject,cancelObject':U).
  ghADMProps:ADD-NEW-FIELD('OutMessageTarget':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('PageNTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('PageSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('FilterSource':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('UpdateSource':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('UpdateTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CommitSource':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('CommitSourceEvents':U, 'CHAR':U, 0, ?, 
          'commitTransaction,undoTransaction':U).
  ghADMProps:ADD-NEW-FIELD('CommitTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CommitTargetEvents':U, 'CHAR':U, 0, ?, 'rowObjectState':U).
  ghADMProps:ADD-NEW-FIELD('StartPage':U, 'INT':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('RunMultiple':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('WaitForObject':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('DynamicSDOProcedure':U, 'CHAR':U, 0, ?,
      'adm2/dyndata.w':U).
  ghADMProps:ADD-NEW-FIELD('RunDOOptions':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('InitialPageList':U, 'CHARACTER':U, 0, ?, '':U). /* comma delimited list of pages to construct at startup or * for all or empty for just start page and page 0 */
  ghADMProps:ADD-NEW-FIELD('WindowFrameHandle':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('Page0LayoutManager', 'CHARACTER').
  ghADMProps:ADD-NEW-FIELD('MultiInstanceSupported', 'LOGICAL', ?, ? ,&IF DEFINED(MULTI-INSTANCE-SUPPORTED) > 0 &THEN {&MULTI-INSTANCE-SUPPORTED} &ELSE NO &ENDIF).  
  ghADMProps:ADD-NEW-FIELD('MultiInstanceActivated', 'LOGICAL').  
  ghADMProps:ADD-NEW-FIELD('ContainerMode', 'CHARACTER').  
  ghADMProps:ADD-NEW-FIELD('SavedContainerMode', 'CHARACTER').  
  ghADMProps:ADD-NEW-FIELD('SdoForeignFields', 'CHARACTER').  
  ghADMProps:ADD-NEW-FIELD('NavigationSource':U, 'CHARACTER':U). 
  ghADMProps:ADD-NEW-FIELD('NavigationTarget':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('PrimarySdoTarget':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('NavigationSourceEvents':U, 'CHAR':U, 0, ?, 
    'fetchFirst,fetchNext,fetchPrev,fetchLast,startFilter':U).
  ghADMProps:ADD-NEW-FIELD('CallerWindow':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('CallerProcedure':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('CallerObject':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('DisabledAddModeTabs', 'CHARACTER').  
  ghADMProps:ADD-NEW-FIELD('ReEnableDataLinks', 'CHARACTER').  
  ghADMProps:ADD-NEW-FIELD('WindowTitleViewer', 'CHARACTER').  
  ghADMProps:ADD-NEW-FIELD('UpdateActive', 'LOGICAL').  
  ghADMProps:ADD-NEW-FIELD('ObjectsCreated', 'LOGICAL').  
  ghADMProps:ADD-NEW-FIELD('InstanceNames':U, 'CHARACTER':U, 0, ?,'':U) .
  ghADMProps:ADD-NEW-FIELD('ClientNames':U, 'CHARACTER':U, 0, ?,'':U) .
  ghADMProps:ADD-NEW-FIELD('ContainedDataObjects':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('ContainedAppServices':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('DataContainer':U, 'LOGICAL':U, 0, ?,NO).
  ghADMProps:ADD-NEW-FIELD('HasDynamicProxy':U, 'LOGICAL':U, 0, ?,NO).
&ENDIF


  {src/adm2/custom/cntnpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


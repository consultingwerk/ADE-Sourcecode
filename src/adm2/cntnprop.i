&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************
* Copyright (C) 2005,2007 by Progress Software Corporation. All rights *
* reserved.  Prior versions of this work may contain portions          *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
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

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  {src/adm2/custom/containrdefscustom.i}

 &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
 &ENDIF
  
 &GLOB xcInstanceProperties {&xcInstanceProperties}LogicalObjectName,PhysicalObjectName,DynamicObject,RunAttribute

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
         HEIGHT             = 4.52
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
&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/cntnprto.i}
  &ENDIF
&ENDIF
  
  /* Preprocs to identify to compiler which properties are in the temp-table.*/
  &GLOBAL-DEFINE xpCurrentPage
  &GLOBAL-DEFINE xpPendingPage
  &GLOBAL-DEFINE xpContainerTarget
  &GLOBAL-DEFINE xpContainerTargetEvents
  &GLOBAL-DEFINE xpContainerToolbarSource
  &GLOBAL-DEFINE xpContainerToolbarSourceEvents
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
  &GLOBAL-DEFINE xpPageLayoutInfo
  /* comma delimited list of pages to construct at startup or * for all or empty for just start page and page 0 */
  &GLOBAL-DEFINE xpInitialPageList  
  &GLOBAL-DEFINE xpWindowFrameHandle
  /* for support of Layout Managers */
 &GLOBAL-DEFINE xpPage0LayoutManager
 
 /* for support Navigation as Pass-Through link */
 &GLOBAL-DEFINE xpNavigationSource        
 &GLOBAL-DEFINE xpNavigationSourceEvents
 &GLOBAL-DEFINE xpNavigationTarget
 
 &GLOBAL-DEFINE xpMultiInstanceSupported
 &GLOBAL-DEFINE xpMultiInstanceActivated
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
 &GLOBAL-DEFINE xpInstanceNames
 &GLOBAL-DEFINE xpClientNames
 &GLOBAL-DEFINE xpDataContainer
 &GLOBAL-DEFINE xpContainedDataObjects
 &GLOBAL-DEFINE xpContainedAppServices
 &GLOBAL-DEFINE xpHasDbAwareObjects
 &GLOBAL-DEFINE xpHasDynamicProxy
 &GLOBAL-DEFINE xpHideOnClose
 &GLOBAL-DEFINE xpHideChildContainersOnClose
 &GLOBAL-DEFINE xpHasObjectMenu 
 /* List of pages that must be initialised together with a specific page. */
 &GLOBAL-DEFINE xpRequiredPages
 &GLOBAL-DEFINE xpRemoveMenuOnHide 
 &GLOBAL-DEFINE xpProcessList
 /* page security tokens, in page order. pipe-delimited */
 &global-define xpPageTokens 
 &GLOBAL-DEFINE xpDataContainerName
 &GLOBAL-DEFINE xpWidgetIDFileName
 
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

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('CurrentPage':U, 'INT':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('PendingPage':U, 'INT':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('ContainerTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ContainerTargetEvents':U, 'CHAR':U, 0, ?,
    'exitObject,okObject,cancelObject,updateActive':U).
  ghADMProps:ADD-NEW-FIELD('ContainerToolbarSource':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ContainerToolbarSourceEvents':U, 'CHAR':U, 0, ?,
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
  ghADMProps:ADD-NEW-FIELD('Page0LayoutManager':U, 'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('MultiInstanceSupported':U, 'LOGICAL':U, ?, ? ,&IF DEFINED(MULTI-INSTANCE-SUPPORTED) > 0 &THEN {&MULTI-INSTANCE-SUPPORTED} &ELSE NO &ENDIF).  
  ghADMProps:ADD-NEW-FIELD('MultiInstanceActivated':U, 'LOGICAL':U).  
  ghADMProps:ADD-NEW-FIELD('ContainerMode':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('SavedContainerMode':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('SdoForeignFields':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('NavigationSource':U, 'CHARACTER':U). 
  ghADMProps:ADD-NEW-FIELD('NavigationTarget':U, 'CHARACTER':U). 
  ghADMProps:ADD-NEW-FIELD('PrimarySdoTarget':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('NavigationSourceEvents':U, 'CHAR':U, 0, ?, 
    'fetchFirst,fetchNext,fetchPrev,fetchLast,startFilter':U).
  ghADMProps:ADD-NEW-FIELD('CallerWindow':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('CallerProcedure':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('CallerObject':U, 'HANDLE':U). 
  ghADMProps:ADD-NEW-FIELD('DisabledAddModeTabs':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('ReEnableDataLinks':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('WindowTitleViewer':U, 'CHARACTER':U).  
  ghADMProps:ADD-NEW-FIELD('UpdateActive':U, 'LOGICAL':U).  
  ghADMProps:ADD-NEW-FIELD('InstanceNames':U, 'CHARACTER':U, 0, ?,'':U) .
  ghADMProps:ADD-NEW-FIELD('ClientNames':U, 'CHARACTER':U, 0, ?,'':U) .
  ghADMProps:ADD-NEW-FIELD('ContainedDataObjects':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('ContainedAppServices':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('DataContainer':U, 'LOGICAL':U, 0, ?,NO).
  ghADMProps:ADD-NEW-FIELD('HasDbAwareObjects':U, 'LOGICAL':U, 0, ?,?).
  ghADMProps:ADD-NEW-FIELD('HasDynamicProxy':U, 'LOGICAL':U, 0, ?,NO).
  ghADMProps:ADD-NEW-FIELD('HideOnClose':U, 'LOGICAL':U, 0, ?,NO).
  ghADMProps:ADD-NEW-FIELD('HideChildContainersOnClose':U, 'LOGICAL':U, 0, ?,?).
  ghADMProps:ADD-NEW-FIELD('HasObjectMenu':U, 'LOGICAL':U, 0, ?,NO).
  ghADMProps:ADD-NEW-FIELD('RequiredPages':U, 'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('RemoveMenuOnHide':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('ProcessList':U, 'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('PageLayoutInfo':U, 'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('PageTokens':U, 'CHARACTER':U).
  ghADMProps:ADD-NEW-FIELD('DataContainerName':U, 'CHARACTER':U, 0, ?,"DataContainer":U).
  ghADMProps:ADD-NEW-FIELD('WidgetIDFileName':U, 'CHARACTER':U, 0, ?,"{&WIDGETID-FILE-NAME}":U).
&ENDIF

  {src/adm2/custom/cntnpropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



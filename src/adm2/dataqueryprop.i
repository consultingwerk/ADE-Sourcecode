&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*--------------------------------------------------------------------------
    File        : dataqueryprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/dataqueryprop.i}

    Description :

    Modified    : 06/27/2006
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN  
  /* Custom instance definition file */
  {src/adm2/custom/dataquerydefscustom.i}

  &IF "{&xcInstanceProperties}":U NE "":U &THEN
&GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF 

&GLOB xcInstanceProperties {&xcInstanceProperties}~
ForeignFields,ObjectName,OpenOnInit,PromptColumns,PromptOnDelete,RowsToBatch,~
RebuildOnRepos,ToggleDataTargets
  
  /* This is the procedure to execute to set InstanceProperties at design time. */
  /***
  &IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
      &SCOP ADM-PROPERTY-DLG adm2/support/xxxx.w
  &ENDIF 
   **/   
  
      
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
    {src/adm2/dataqueryprto.i}
  &ENDIF
&ENDIF  /* defined(adm-exclude-prototypes)  */
 
 /* if appserver aware add appserver properties  */ 
&IF DEFINED(APP-SERVER-VARS) <> 0 &THEN
  {src/adm2/appsprop.i}
&ELSE
  {src/adm2/smrtprop.i}
&ENDIF   
  
 &GLOBAL-DEFINE xpBufferHandles          
 &GLOBAL-DEFINE xpCommitSource           
 &GLOBAL-DEFINE xpCommitSourceEvents     
 &GLOBAL-DEFINE xpCommitTarget           
 &GLOBAL-DEFINE xpCommitTargetEvents     
 &GLOBAL-DEFINE xpCurrentRowid                                                                 
 &GLOBAL-DEFINE xpCurrentUpdateSource
 &GLOBAL-DEFINE xpDataColumns 
 &GLOBAL-DEFINE xpDataHandle
 &GLOBAL-DEFINE xpDataIsFetched
 &GLOBAL-DEFINE xpDataQueryString
 &GLOBAL-DEFINE xpFillBatchOnRepos
 &GLOBAL-DEFINE xpFilterSource           
 &GLOBAL-DEFINE xpFilterWindow           
 &GLOBAL-DEFINE xpFirstRowNum
 &GLOBAL-DEFINE xpForeignValues
 &GLOBAL-DEFINE xpLastRowNum                               
 &GLOBAL-DEFINE xpNavigationSource       
 &GLOBAL-DEFINE xpNavigationSourceEvents          
 &GLOBAL-DEFINE xpOpenOnInit
 &GLOBAL-DEFINE xpPromptOnDelete 
 &GLOBAL-DEFINE xpPrimarySDOSource
 &GLOBAL-DEFINE xpQueryColumns
 &GLOBAL-DEFINE xpQueryString
 &GLOBAL-DEFINE xpRebuildOnRepos
 &GLOBAL-DEFINE xpRowObject
 &GLOBAL-DEFINE xpRowsToBatch
 &GLOBAL-DEFINE xpTables 
 &GLOBAL-DEFINE xpToggleDataTargets
 &GLOBAL-DEFINE xpTransferChildrenForAll 
 &GLOBAL-DEFINE xpUpdateSource  
 &GLOBAL-DEFINE xpUpdatableColumns  
 &GLOBAL-DEFINE xpUpdatableWhenNew  
 

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN  
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
  &IF "{&ADMSuper}":U = "":U &THEN
     ghADMProps:ADD-NEW-FIELD('AutoCommit':U, 'LOGICAL':U, 0, ?, yes).
     ghADMProps:ADD-NEW-FIELD('BLOBColumns':U, 'CHAR':U, 0, ?, ?).
     ghADMProps:ADD-NEW-FIELD('BufferHandles':U, 'CHAR':U, 0, ?, '':U).
     ghADMProps:ADD-NEW-FIELD('CLOBColumns':U, 'CHAR':U, 0, ?, ?).
     ghADMProps:ADD-NEW-FIELD('CommitSource':U, 'HANDLE':U).
     ghADMProps:ADD-NEW-FIELD('CommitSourceEvents':U, 'CHAR':U, 0, ?, 
       'commitTransaction,undoTransaction':U).
     ghADMProps:ADD-NEW-FIELD('CommitTarget':U, 'CHAR':U, 0, ?, '':U).
     ghADMProps:ADD-NEW-FIELD('CommitTargetEvents':U, 'CHAR':U, 0, ?, 'rowObjectState':U).
     ghADMProps:ADD-NEW-FIELD('CurrentRowid':U, 'ROWID':U).
     ghADMProps:ADD-NEW-FIELD('CurrentUpdateSource':U, 'HANDLE':U).
     ghADMProps:ADD-NEW-FIELD('DataColumns':U, 'CHAR':U, 0, ?, '':U).
     ghADMProps:ADD-NEW-FIELD('DataHandle':U, 'HANDLE':U).   
     ghADMProps:ADD-NEW-FIELD('DataIsFetched':U, 'LOGICAL':U, 0, ?, ?).
     ghADMProps:ADD-NEW-FIELD('DataModified':U, 'LOGICAL':U, 0, ?, no).
     ghADMProps:ADD-NEW-FIELD('DataQueryBrowsed':U, 'LOGICAL':U, 0, ?, no).
     ghADMProps:ADD-NEW-FIELD('DataQueryString':U, 'CHAR':U, 0, ?,'':U).
     ghADMProps:ADD-NEW-FIELD('FetchOnOpen':U, 'CHAR':U, 0, ?, ?).
     ghADMProps:ADD-NEW-FIELD('FillBatchOnRepos':U, 'LOGICAL':U, 0, ?, YES).
     ghADMProps:ADD-NEW-FIELD('FilterActive':U, 'LOGICAL':U, 0, ?, no).
     ghADMProps:ADD-NEW-FIELD('FilterAvailable':U, 'LOGICAL':U, 0, ?, no).
     ghADMProps:ADD-NEW-FIELD('FilterSource':U, 'HANDLE':U).
     ghADMProps:ADD-NEW-FIELD('FilterWindow':U, 'CHAR':U).
     ghADMProps:ADD-NEW-FIELD('FirstRowNum':U, 'INT':U, 0, ?, ?).
     ghADMProps:ADD-NEW-FIELD('ForeignFields':U, 'CHAR':U, 0, ?, '':U).
     ghADMProps:ADD-NEW-FIELD('ForeignValues':U, 'CHAR':U, 0, ?, ?).
     ghADMProps:ADD-NEW-FIELD('IgnoreTreeViewFilter':U, 'LOGICAL':U, ?, ?, ?).
     ghADMProps:ADD-NEW-FIELD('IndexInformation':U, 'CHARACTER':U, 0, ?,?). 
     ghADMProps:ADD-NEW-FIELD('LargeColumns':U, 'CHAR':U, 0, ?, ?).
     ghADMProps:ADD-NEW-FIELD('LastRowNum':U, 'INT':U, 0, ?, ?).
     ghADMProps:ADD-NEW-FIELD('NavigationSource':U, 'CHAR':U).
     ghADMProps:ADD-NEW-FIELD('NavigationSourceEvents':U, 'CHAR':U, 0, ?, 
                              'fetchFirst,fetchNext,fetchPrev,fetchLast,startFilter':U).
     ghADMProps:ADD-NEW-FIELD('OpenOnInit':U, 'LOGICAL':U, 0, ?, yes).
     ghADMProps:ADD-NEW-FIELD('PrimarySDOSource':U, 'HANDLE':U).
     ghADMProps:ADD-NEW-FIELD('PromptColumns':U, 'CHAR':U, 0, ?, '':U).
     ghADMProps:ADD-NEW-FIELD('PromptOnDelete':U, 'LOGICAL':U, 0, ?, YES).
     ghADMProps:ADD-NEW-FIELD('QueryColumns':U, 'CHAR':U, 0, ?, '':U).
     ghADMProps:ADD-NEW-FIELD('QueryPosition':U, 'CHAR':U, 0, ?, '':U).
     ghADMProps:ADD-NEW-FIELD('QueryString':U, 'CHAR':U, 0, ?, '':U).
     ghADMProps:ADD-NEW-FIELD('RebuildOnRepos':U, 'LOGICAL':U, 0, ?, no).
     ghADMProps:ADD-NEW-FIELD('RowObject':U, 'HANDLE':U, 0, ?, ?). 
     ghADMProps:ADD-NEW-FIELD('RowObjectState':U, 'CHAR':U, 0, ?, 'NoUpdates':U).
     ghADMProps:ADD-NEW-FIELD('RowsToBatch':U, 'INT':U, 0, ?, 200).  /* Rows per AppServer xfer */
     ghADMProps:ADD-NEW-FIELD('Tables':U, 'CHAR':U, 0, ?, '':U).
     ghADMProps:ADD-NEW-FIELD('ToggleDataTargets':U, 'LOGICAL':U, ?, ?, TRUE).
     ghADMProps:ADD-NEW-FIELD('TransferChildrenForAll':U, 'LOGICAL':U, 0, ?, NO).
     ghADMProps:ADD-NEW-FIELD('UpdatableColumns':U, 'CHAR':U, 0, ?, ?).
     ghADMProps:ADD-NEW-FIELD('UpdatableWhenNew':U, 'CHARACTER':U,0,?,'':U).
     ghADMProps:ADD-NEW-FIELD('UpdateSource':U, 'CHARACTER':U).
 &ENDIF  /* "{&ADMSuper}" = "" */

  {src/adm2/custom/dataquerypropcustom.i}

END. /* if not adm-props-defined */

&ENDIF  /* defined(adm-exclude-static)  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



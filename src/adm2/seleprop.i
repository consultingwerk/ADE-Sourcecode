&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/***********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions           *
* contributed by participants of Possenet.                             *
*                                                                      *
***********************************************************************/
/*--------------------------------------------------------------------------
    File        : seleprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/seleprop.i}

    Description :

    Modified    : 06/23/1999
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
AutoRefresh,ChangedEvent,DisplayedField,DataSourceFilter,NumRows,~
Optional,OptionalString,Label,Sort,ViewAs,ToolTip,Format,HelpId,BrowseTitle,~
BrowseFields,ExitBrowseOnAction,CancelBrowseOnExit,RepositionDataSource,~
DefineAnyKeyTrigger,StartBrowseKeys


  {src/adm2/custom/selectdefscustom.i}

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
         HEIGHT             = 9.24
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
    {src/adm2/seleprto.i}
  &ENDIF
&ENDIF

/* Selection-specific properties which are in the property temp-table. */
  &GLOB xpKeyFields              
                                     
  &GLOBAL-DEFINE xpAutoRefresh 
  &GLOBAL-DEFINE xpModify 
  &GLOBAL-DEFINE xpStarting 
  &GLOBAL-DEFINE xpFormat 
  &GLOBAL-DEFINE xpTooltip 
  &GLOBAL-DEFINE xpHelpId 
  &GLOBAL-DEFINE xpChangedEvent 
  &GLOBAL-DEFINE xpDisplayedField
  &GLOBAL-DEFINE xpDataSourceFilter
  &GLOBAL-DEFINE xpNumRows
  &GLOBAL-DEFINE xpOptional 
  &GLOBAL-DEFINE xpOptionalString
  &GLOBAL-DEFINE xpOptionalBlank
  &GLOBAL-DEFINE xpSort
  &GLOBAL-DEFINE xpDisplaySelection
  &GLOBAL-DEFINE xpEnableSelection
  &GLOBAL-DEFINE xpEnableOnAdd
  &GLOBAL-DEFINE xpViewAs 
  &GLOBAL-DEFINE xpListInitialized 
  &GLOBAL-DEFINE xpLabelHandle 
  &GLOBAL-DEFINE xpSelectionHandle 
  &GLOBAL-DEFINE xpSelectionImage 
  &GLOBAL-DEFINE xpButtonHandle 
  &GLOBAL-DEFINE xpBrowseFields 
  &GLOBAL-DEFINE xpBrowseTitle 
  &GLOBAL-DEFINE xpBrowseContainer 
  &GLOBAL-DEFINE xpBrowseProcedure 
  &GLOBAL-DEFINE xpBrowseObject 
  &GLOBAL-DEFINE xpBrowseWindowProcedure 
  &GLOBAL-DEFINE xpExitBrowseOnAction
  &GLOBAL-DEFINE xpCancelBrowseOnExit
  &GLOBAL-DEFINE xpRepositionDataSource
  &GLOBAL-DEFINE xpStartBrowseKeys
  {src/adm2/fieldprop.i}
  
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  /* and then we add our Selection property defs to that... */
  ghADMProps:ADD-NEW-FIELD('AutoRefresh':U, 'LOG':U, 0, ?, no).       
  ghADMProps:ADD-NEW-FIELD('Starting':U, 'LOG':U, 0, ?, no).       
  ghADMProps:ADD-NEW-FIELD('Modify':U, 'LOG':U, 0, ?, no).       
  ghADMProps:ADD-NEW-FIELD('ToolTip':U, 'CHAR':U, 0, ?, '':U).    
  ghADMProps:ADD-NEW-FIELD('HelpId':U, 'INT':U, 0, ?, 0).    
  ghADMProps:ADD-NEW-FIELD('Format':U, 'CHAR':U, 0, ?, ?).    
  ghADMProps:ADD-NEW-FIELD('ChangedEvent':U, 'CHAR':U, 0, ?, '':U).       
  ghADMProps:ADD-NEW-FIELD('DisplayedField':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DataSourceFilter':U, 'CHAR':U, 0, ?, '':U).   
  ghADMProps:ADD-NEW-FIELD('NumRows':U, 'INT':U, 0, ?, 5).          
  ghADMProps:ADD-NEW-FIELD('Optional':U, 'LOG':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('OptionalString':U, 'CHAR':U, 0, ?, '<none>':U).     
  ghADMProps:ADD-NEW-FIELD('OptionalBlank':U, 'CHAR':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('Sort':U, 'LOG':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('EnableOnAdd':U, 'LOG':U, 0, ?, no).  
  ghADMProps:ADD-NEW-FIELD('ViewAs':U, 'CHAR':U, 0, ?, 'combo-box:drop-down-list':U).                
  ghADMProps:ADD-NEW-FIELD('ListInitialized':U, 'LOG':U, 0, ?, no).                
  ghADMProps:ADD-NEW-FIELD('LabelHandle':U, 'HANDLE':U, 0, ?, ?).                
  ghADMProps:ADD-NEW-FIELD('SelectionHandle':U, 'HANDLE':U, 0, ?, ?).                
  ghADMProps:ADD-NEW-FIELD('SelectionImage':U, 'CHARACTER':U, 0, ?, 'adeicon/select.bmp':U).                
  ghADMProps:ADD-NEW-FIELD('ButtonHandle':U, 'HANDLE':U, 0, ?, ?).                
  ghADMProps:ADD-NEW-FIELD('BrowseWindowProcedure':U, 'CHARACTER':U, 0, ?, 'adm2/dynwindow.w':U).                
  ghADMProps:ADD-NEW-FIELD('BrowseProcedure':U, 'CHARACTER':U, 0, ?, 'adm2/dynbrowser.w':U).                
  ghADMProps:ADD-NEW-FIELD('BrowseContainer':U, 'HANDLE':U, 0, ?, ?).                
  ghADMProps:ADD-NEW-FIELD('BrowseObject':U, 'HANDLE':U, 0, ?, ?).                
  ghADMProps:ADD-NEW-FIELD('BrowseFields':U, 'CHARACTER':U, 0, ?, '':U).                
  ghADMProps:ADD-NEW-FIELD('BrowseTitle':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ExitBrowseOnAction':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('CancelBrowseOnExit':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('RepositionDataSource':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('DefineAnyKeyTrigger':U, 'LOGICAL':U, 0, ?, YES).
  ghADMProps:ADD-NEW-FIELD('StartBrowseKeys':U, 'CHARACTER':U, 0, ?, 'NEXT-FRAME':U).  
&ENDIF

  /*<<BEGIN-CUSTOM-PROPERTIES>>*/
  {src/adm2/custom/selepropcustom.i}
  /*<<END-CUSTOM-PROPERTIES>>*/
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



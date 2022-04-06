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
    File        : toolprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/toolprop.i}

    Description :

    Modified    : 05/31/1999
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/toold.w
&ENDIF

&IF "{&xcInstanceProperties}":U NE "":U &THEN
   &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOB xcInstanceProperties {&xcInstanceProperties}~
EdgePixels,DeactivateTargetOnHide,DisabledActions,FlatButtons,Menu,ShowBorder,~
Toolbar,ActionGroups,TableIOType,SupportedLinks,ToolbarBands,~
ToolbarAutoSize,ToolbarDrawDirection,LogicalObjectName,~
DisabledActions,HiddenActions,HiddenToolbarBands,HiddenMenuBands,~
MenuMergeOrder,RemoveMenuOnHide,CreateSubMenuOnConflict,NavigationTargetName

/* Custom instance include for the action class is included here since
   the action class is merged with the toolbar class */ 
{src/adm2/custom/actiondefscustom.i}
  
/* Custom instance definition file */
{src/adm2/custom/toolbardefscustom.i}
  
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
         HEIGHT             = 12.19
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
    {src/adm2/toolprto.i}
  &ENDIF
&ENDIF

&GLOB xpPanelType
&GLOB xpBoxRectangle
&GLOB xpBoxRectangle2
&GLOB xpMenu
&GLOB xpToolbar
&GLOB xpMenubarHandle
&GLOB xpFlatButtons
&GLOB xpActionGroups
&GLOB xpToolMarginPxl
&GLOB xpToolSpacingPxl
&GLOB xpToolSeparatorPxl
&GLOB xpToolWidthPxl
&GLOB xpToolHeightPxl
&GLOB xpImagePath 
&GLOB xpShowBorder 
&GLOB xpAvailMenuActions 
&GLOB xpAvailToolbarActions
&GLOB xpHiddenToolbarBands
&GLOB xpHiddenMenuBands
&GLOB xpSubModules 
&GLOBAL-DEFINE xpToolbarBands
&GLOBAL-DEFINE xpToolbarParentMenu
&GLOBAL-DEFINE xpMenuMergeOrder
&GLOBAL-DEFINE xpToolbarDrawDirection
&GLOBAL-DEFINE xpToolbarAutoSize
&GLOBAL-DEFINE xpToolMaxWidthPxl
&GLOBAL-DEFINE xpToolbarInitialState
&GLOBAL-DEFINE xpCommitTarget       
&GLOBAL-DEFINE xpCommitTargetEvents 
&GLOBAL-DEFINE xpContainerToolbarTarget
&GLOBAL-DEFINE xpContainerToolbarTargetEvents
&GLOBAL-DEFINE xpNavigationTarget
&GLOBAL-DEFINE xpNavigationTargetEvents
&GLOBAL-DEFINE xpNavigationTargetName
&GLOBAL-DEFINE xpTableIOTarget
&GLOBAL-DEFINE xpTableIOTargetEvents
&GLOBAL-DEFINE xpTableioType 
&GLOBAL-DEFINE xpToolbarTarget
&GLOBAL-DEFINE xpToolbarTargetEvents
&GLOBAL-DEFINE xpLinkTargetNames
&GLOBAL-DEFINE xpDeactivateTargetOnHide
&GLOBAL-DEFINE xpCreateSubMenuOnConflict
&GLOBAL-DEFINE xpRemoveMenuOnHide
&GLOBAL-DEFINE xpSubMenuLabelRetrieval
&GLOBAL-DEFINE xpActionWidgetIDs

{src/adm2/visprop.i}
    
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  /* add new field takes 5 arguements - name,type,extent,format,default */
  ghADMProps:ADD-NEW-FIELD('PanelType':U, 'CHAR':U, 0, ?, '{&ADM-Panel-Type}':U).
  ghADMProps:ADD-NEW-FIELD('DisabledActions':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BoxRectangle':U, 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('BoxRectangle2':U , 'HANDLE':U).
  ghADMProps:ADD-NEW-FIELD('Menu':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('Toolbar':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('MenubarHandle':U, 'HANDLE':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('FlatButtons':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('PanelState':U, 'CHAR':U, 0, ?, '':U).          
  ghADMProps:ADD-NEW-FIELD('ActionGroups':U, 'CHARACTER':U, 0, ?,'Tableio,Navigation':U).
  ghADMProps:ADD-NEW-FIELD('ToolSpacingPxl':U, 'INTEGER':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('ToolSeparatorPxl':U, 'INTEGER':U, 0, ?, 3).
  ghADMProps:ADD-NEW-FIELD('ToolWidthPxl':U, 'INTEGER':U, 0, ?, 24).
  ghADMProps:ADD-NEW-FIELD('ToolHeightPxl':U, 'INTEGER':U, 0, ?, 22).
  ghADMProps:ADD-NEW-FIELD('ImagePath':U, 'CHARACTER':U, 0, ?, 'adm2/image':U).
  ghADMProps:ADD-NEW-FIELD('ShowBorder':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('AvailMenuActions':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('AvailToolbarActions':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('subModules':U, 'CHARACTER':U, 0, ?,'':U).
  ghADMProps:ADD-NEW-FIELD('DisabledActions':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('HiddenActions':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('HiddenToolbarBands':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('HiddenMenuBands':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ToolbarBands':U, 'CHAR':U, 0, ?, '':U).      
  ghADMProps:ADD-NEW-FIELD('ToolbarParentMenu':U, 'CHAR':U, 0, ?, '':U).      
  ghADMProps:ADD-NEW-FIELD('MenuMergeOrder':U, 'INTEGER':U, 0, ?).      
  ghADMProps:ADD-NEW-FIELD('ToolbarDrawDirection':U, 'CHAR':U, 0, ?, 'horizontal':U).
  ghADMProps:ADD-NEW-FIELD('ToolbarAutoSize':U, 'LOGICAL':U, 0, ?, FALSE).
  ghADMProps:ADD-NEW-FIELD('ToolMaxWidthPxl':U, 'INTEGER':U, 0, ?, 24 ).
  ghADMProps:ADD-NEW-FIELD('ToolbarInitialState':U, 'CHAR':U, 0, ?, '':U).      
  ghADMProps:ADD-NEW-FIELD('EdgePixels':U, 'INTEGER':U, 0, ?, 2 ).   
  ghADMProps:ADD-NEW-FIELD('ToolMarginPxl':U, 'INTEGER':U, 0, ?, 2 ).   
  ghADMProps:ADD-NEW-FIELD('CommitTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CommitTargetEvents':U, 'CHAR':U, 0, ?, 'rowObjectState,resetCommit':U).  
  ghADMProps:ADD-NEW-FIELD('ContainerToolbarTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ContainerToolbarTargetEvents':U, 'CHAR':U, 0, ?,'resetContainerToolbar,linkState':U). 
  ghADMProps:ADD-NEW-FIELD('NavigationTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('NavigationTargetEvents':U, 'CHAR':U, 0, ?, 'queryPosition,updateState,linkState,filterState,resetNavigation':U).
  ghADMProps:ADD-NEW-FIELD('NavigationTargetName':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('TableioTarget':U, 'CHAR':U, 0, ?, '':U).  
  ghADMProps:ADD-NEW-FIELD('TableioTargetEvents':U, 'CHAR':U, 0, ?, 'queryPosition,updateState,linkState,resetTableio':U).   
  ghADMProps:ADD-NEW-FIELD('TableIoType':U, 'CHARACTER':U, 0, ?,'Save':U).
  ghADMProps:ADD-NEW-FIELD('ToolbarTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ToolbarTargetEvents':U, 'CHAR':U, 0, ?,'resetToolbar,linkState':U). 
  ghADMProps:ADD-NEW-FIELD('DeactivateTargetOnHide':U, 'LOGICAL':U, 0, ?, FALSE).
  ghADMProps:ADD-NEW-FIELD('LinkTargetNames':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CreateSubMenuOnConflict':U, 'LOGICAL':U, 0, ?, TRUE).
  ghADMProps:ADD-NEW-FIELD('RemoveMenuOnHide':U, 'LOGICAL':U, 0, ?, FALSE).
  ghADMProps:ADD-NEW-FIELD('SubMenuLabelRetrieval':U, 'CHAR':U, 0, ?, 'Label':U).
  ghADMProps:ADD-NEW-FIELD('ActionWidgetIDs':U, 'CHAR':U).
&ENDIF

  /*<<BEGIN-CUSTOM-PROPERTIES>>*/
  {src/adm2/custom/actipropcustom.i}
  {src/adm2/custom/toolpropcustom.i}
  /*<<END-CUSTOM-PROPERTIES>>*/
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



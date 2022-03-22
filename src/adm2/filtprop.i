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
    File        : filtprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/filtprop.i}

    Description :

    Modified    : 06/28/1999
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Custom instance definition file */
  {src/adm2/custom/filterdefscustom.i}
  /* Custom instance definition file */

&IF "{&xcInstanceProperties}":U NE "":U &THEN
  &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOB xcInstanceProperties {&xcInstanceProperties}~
DisplayedFields,OperatorStyle,OperatorViewAs,Operator,UseBegins,UseContains,~
DefaultWidth,DefaultCharWidth,DefaultEditorLines,ViewAsFields,FieldOperatorStyles,~
FieldFormats,FieldWidths,FieldLabels,FieldToolTips,FieldHelpIds,DesignDataObject,~
FieldColumn

/* This is the procedure to execute to set InstanceProperties at design time. */
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
  &SCOP ADM-PROPERTY-DLG adm2/support/filterd.w
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
    {src/adm2/filtprto.i}
  &ENDIF
&ENDIF
 
 &GLOB xpFilterTargetEvents
 &GLOB xpFieldsEnabled       
 &GLOB xpDisplayedFields       
 &GLOB xpEnabledFields         
 &GLOB xpEnabledHandles        
 &GLOB xpDataObject        
 &GLOB xpDataModified      
 &GLOB xpOperatorStyle
 &GLOB xpOperatorViewAs
 &GLOB xpOperator
 &GLOB xpUseBegins
 &GLOB xpUseContains
 &GLOB xpOperatorLongValues
 &GLOB xpOperatorShortValues
 &GLOB xpDefaultLogical
 &GLOB xpDefaultWidth    
 &GLOB xpDefaultCharWidth     
 &GLOB xpDefaultHeight    
 &GLOB xpDefaultEditorLines    
 &GLOB xpMaxWidth    
 &GLOB xpFieldColumn    
 &GLOB xpFieldSpacingPxl    
 &GLOB xpFieldSeparatorPxl        
 &GLOB xpViewAsFields    
 &GLOB xpFieldHandles    
 &GLOB xpOperatorHandles    
 &GLOB xpLabelHandles    
 &GLOB xpFieldOperatorStyles  
 &GLOB xpFieldFormats  
 &GLOB xpFieldWidths
 &GLOB xpFieldLabels
 &GLOB xpFieldTooltips
 &GLOB xpFieldHelpIds
 &GLOB xpVisualBlank
 &GLOB xpFieldWidgetIDs
 {src/adm2/visprop.i}
 
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN  
  ghADMProps:ADD-NEW-FIELD('FilterTarget':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FilterTargetEvents':U, 'CHAR':U, 0, ?, 'dataAvailable':U).
  ghADMProps:ADD-NEW-FIELD('FieldsEnabled':U, 'LOG':U, 0, ?, no).
  ghADMProps:ADD-NEW-FIELD('DisplayedFieldS':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('EnabledFields':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('EnabledHandles':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DataObject':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DataModified':U,'LOG':U, 0, ?, no).
  
  /* Operator Properties */
  ghADMProps:ADD-NEW-FIELD('OperatorStyle':U,'CHAR':U, 0, ?, 'Explicit':U).
  ghADMProps:ADD-NEW-FIELD('OperatorViewAs':U,'CHAR':U, 0, ?, 'combo-box':U).
  ghADMProps:ADD-NEW-FIELD('Operator':U,'CHAR':U, 0, ?, '=,>,<':U).
  ghADMProps:ADD-NEW-FIELD('UseBegins':U,'LOG':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('UseContains':U,'LOG':U, 0, ?, yes).
  ghADMProps:ADD-NEW-FIELD('OperatorLongValues':U,'CHAR':U, 0, ?, 
'Greater Equals,>=,Greater Than,>,Equals,=,Begins,BEGINS,Contains,CONTAINS,Less Than,<,Less Equals,<=').
 /* as a default we skip LT,GT in short values to save screen real estate */ 
  ghADMProps:ADD-NEW-FIELD('OperatorShortValues':U,'CHAR':U, 0, ?,
'GE,>=,EQ,=,LE,<=,Begins,BEGINS,Contains,CONTAINS').

 /* future support for logical values as toggle or radio-set 
    ghADMProps:ADD-NEW-FIELD('LogicalValues':U,'CHAR':U, 0, ?, 
   'Yes No,yes-no,Yes No Unknown,yes-no-unknown,Yes No All,yes-no-all,Yes No Unknown All,yes-no-unknown-all').
  */ 
  /* Size properties */
  ghADMProps:ADD-NEW-FIELD('DefaultLogical':U,'CHAR':U, 0, ?, 'NO':U).
  ghADMProps:ADD-NEW-FIELD('DefaultWidth':U,'DECIMAL':U, 0, ?, 16).
  ghADMProps:ADD-NEW-FIELD('DefaultCharWidth':U,'DECIMAL':U, 0, ?, 20).
  ghADMProps:ADD-NEW-FIELD('DefaultHeight':U,'DECIMAL':U, 0, ?, 1).
  ghADMProps:ADD-NEW-FIELD('DefaultEditorLines':U,'INTEGER':U, 0, ?, 1).
  ghADMProps:ADD-NEW-FIELD('MaxWidth':U,'DECIMAL':U, 0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('FieldColumn':U,'DECIMAL':U, 0, ?, 20).
  ghADMProps:ADD-NEW-FIELD('FieldSpacingPxl':U, 'INTEGER':U, 0, ?, 3).
  ghADMProps:ADD-NEW-FIELD('FieldSeparatorPxl':U, 'INTEGER':U, 0, ?, 7).
  
  /* field level Properties  <fieldname>;<override>  */ 
  ghADMProps:ADD-NEW-FIELD('ViewAsFields':U,'CHAR':U, 0, ?, '':U). /* NOT IN USE */

  /* field lists */ 
  ghADMProps:ADD-NEW-FIELD('FieldHandles':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('OperatorHandles':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('LabelHandles':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldOperatorStyles':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldHandles':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldFormats':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldWidths':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldLabels':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldTooltips':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldHelpIds':U,'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('VisualBlank':U,'CHAR':U, 0, ?, '<Blank>':U).
  ghADMProps:ADD-NEW-FIELD('FieldWidgetIDs':U,'CHAR':U, 0, ?, '':U).
&ENDIF

  /*<<BEGIN-CUSTOM-PROPERTIES>>*/
  {src/adm2/custom/filtpropcustom.i}
  /*<<END-CUSTOM-PROPERTIES>>*/
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



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
    File        : combprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/combprop.i}

    Description :

    Modified    : 08/14/2001
    
    Modified: 09/25/2001         Mark Davies (MIP)
              1. Remove references to KeyFieldValue and SavedScreenValue
    
    Modified: 10/18/2001         Mark Davies (MIP)
              Removed xpInstanceProperty field from list.
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
&IF "{&xcInstanceProperties}":U NE "":U &THEN
   &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOB xcInstanceProperties {&xcInstanceProperties}~
DisplayedField,KeyField,FieldLabel,FieldTooltip,KeyFormat,KeyDatatype,DisplayFormat,~
DisplayDatatype,BaseQueryString,QueryTables,SDFFileName,SDFTemplate,ParentField,~
ParentFilterQuery,DescSubstitute,ComboDelimiter,ListItemPairs,InnerLines,Sort,ComboFlag,~
FlagValue,BuildSequence,Secured,CustomSuperProc,PhysicalTableNames,TempTables,~
QueryBuilderJoinCode,QueryBuilderOptionList,QueryBuilderOrderList,QueryBuilderTableOptionList,~
QueryBuilderTuneOptions,QueryBuilderWhereClauses,UseCache,SuperProcedure
  
  /* Custom instance definition file */

  {src/adm2/custom/combodefscustom.i}

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
         HEIGHT             = 5.19
         WIDTH              = 52.
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
    {src/adm2/combprto.i}
  &ENDIF
&ENDIF

  /* These preprocessors tell at compile time which properties can
     be retrieved directly from the temp-table */
  &GLOBAL-DEFINE xpInnerLines         /* Sets the Number of inner lines for the Combo */
  &GLOBAL-DEFINE xpSort               /* Sort combo widget  */
  &GLOBAL-DEFINE xpListItemPairs      /* The actual value of the list items in the combo */  
  &GLOBAL-DEFINE xpComboHandle        /* Contains the handle to the actual combo widget itself */
  &GLOBAL-DEFINE xpSecured             /* When TRUE indicates that the field's security is set to HIDDEn */
  &GLOBAL-DEFINE xpAltValueOnAdd
  &GLOBAL-DEFINE xpAltValueOnRebuild
  
  {src/adm2/lookupfieldprop.i}

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:
&IF "{&ADMSuper}":U = "":U &THEN
  /* Combo property field definitions */
  ghADMProps:ADD-NEW-FIELD('DescSubstitute':U,     'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ComboFlag':U,          'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FlagValue':U,          'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('InnerLines':U,         'INTEGER':U,   0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('Sort':U,               'LOGICAL':U,   0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('ComboDelimiter':U,     'CHARACTER':U, 0, ?, CHR(1)).
  ghADMProps:ADD-NEW-FIELD('ListItemPairs':U,      'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BuildSequence':U,      'INTEGER':U,   0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ComboHandle':U,        'HANDLE':U,    0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('Secured':U,            'LOGICAL':U,   0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('AltValueOnAdd':U,      'CHARACTER':U, 0, ?, '<Clear>':U).
  ghADMProps:ADD-NEW-FIELD('AltValueOnRebuild':U,  'CHARACTER':U, 0, ?, '<Clear>':U).
&ENDIF

  {src/adm2/custom/combpropcustom.i}
END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



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

&IF "{&xcInstanceProperties}":U NE "":U &THEN
   &GLOB xcInstanceProperties {&xcInstanceProperties},
&ENDIF
&GLOB xcInstanceProperties {&xcInstanceProperties}~
DisplayedField,KeyField,FieldLabel,FieldTooltip,KeyFormat,KeyDatatype,DisplayFormat,DisplayDatatype,~
BaseQueryString,QueryTables,SDFFileName,SDFTemplate,ParentField,ParentFilterQuery,DescSubstitute,CurrentKeyValue,ComboDelimiter,ListItemPairs,CurrentDescValue,InnerLines,ComboFlag,FlagValue,BuildSequence,Secured
  
  /* Custom instance definition file */

  {src/adm2/custom/combodefscustom.i}

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
  {src/adm2/combprto.i}
&ENDIF

  /* These preprocessors tell at compile time which properties can
     be retrieved directly from the temp-table */

  &GLOBAL-DEFINE xpDisplayedField     /* Name of field to display from query (with table prefix) */
  &GLOBAL-DEFINE xpKeyField           /* Name of key field to assign value from (with table prefix) */
  &GLOBAL-DEFINE xpFieldLabel         /* Label for displayed field */
  &GLOBAL-DEFINE xpFieldTooltip       /* Tooltip for displayed field */
  &GLOBAL-DEFINE xpKeyFormat          /* Format of key field */
  &GLOBAL-DEFINE xpKeyDataType        /* Datatype of key field */
  &GLOBAL-DEFINE xpDisplayFormat      /* Format of displayed field */
  &GLOBAL-DEFINE xpDisplayDataType    /* Datatype of displayed field */
  &GLOBAL-DEFINE xpBaseQueryString    /* Base Browser query string (design time) */
  &GLOBAL-DEFINE xpQueryTables        /* Comma list of query tables (buffers) */
  &GLOBAL-DEFINE xpDescSubstitute     /* Conatins the field substitution order */
  &GLOBAL-DEFINE xpComboFlag          /* A = <All>, N = <None> */
  &GLOBAL-DEFINE xpFlagValue          /* This will contain the default value for the optional <All> and <None> flags */
  &GLOBAL-DEFINE xpInnerLines         /* Sets the Number of inner lines for the Combo */
  &GLOBAL-DEFINE xpCurrentKeyValue    /* Contains the current value of the key field */
  &GLOBAL-DEFINE xpComboDelimiter     /* This is to allow a programmer to retreive the list-item-pair delimiter of the combo */
  &GLOBAL-DEFINE xpListItemPairs      /* The actual value of the list items in the combo */
  &GLOBAL-DEFINE xpCurrentDescValue   /* Contains the current description value of the combo */
  
  &GLOBAL-DEFINE xpModify
  
  &GLOBAL-DEFINE xpLabelHandle        /* Contains the handle to the combo's label */
  &GLOBAL-DEFINE xpComboHandle        /* Contains the handle to the actual combo widget itself */
  &GLOBAL-DEFINE xpCurrentQueryString /* Current Browser query string (filters, etc.) */
  
  &GLOBAL-DEFINE xpSDFFileName         /* SmartDataField File Name */
  &GLOBAL-DEFINE xpSDFTemplate         /* SmartDataField Template File Name */
  &GLOBAL-DEFINE xpParentField         /* The field/widget name of the parent object that this combo is dependant on */
  &GLOBAL-DEFINE xpParentFilterQuery   /* The filter query to be used to filter on parent information */
  &GLOBAL-DEFINE xpSecured             /* When TRUE indicates that the field's security is set to HIDDEn */
  
  {src/adm2/fieldprop.i}

&IF "{&ADMSuper}":U = "":U &THEN
  /* Combo property field definitions */
  ghADMProps:ADD-NEW-FIELD('Modify':U,             'LOGICAL':U,   0, ?, NO).
  
  ghADMProps:ADD-NEW-FIELD('DisplayedField':U,     'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('KeyField':U,           'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldLabel':U,         'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FieldTooltip':U,       'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('KeyFormat':U,          'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('KeyDataType':U,        'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DisplayFormat':U,      'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DisplayDataType':U,    'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('QueryTables':U,        'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BaseQueryString':U,    'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('SDFFileName':U,        'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('SDFTemplate':U,        'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ParentField':U,        'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ParentFilterQuery':U,  'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('DescSubstitute':U,     'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ComboFlag':U,          'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('FlagValue':U,          'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('InnerLines':U,         'INTEGER':U,   0, ?, 0).
  ghADMProps:ADD-NEW-FIELD('CurrentKeyValue':U,    'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ComboDelimiter':U,     'CHARACTER':U, 0, ?, CHR(1)).
  ghADMProps:ADD-NEW-FIELD('ListItemPairs':U,      'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('CurrentDescValue':U,   'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('BuildSequence':U,      'INTEGER':U,   0, ?, '':U).

  ghADMProps:ADD-NEW-FIELD('LabelHandle':U,        'HANDLE':U,    0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('ComboHandle':U,        'HANDLE':U,    0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('CurrentQueryString':U, 'CHARACTER':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('Secured':U,            'LOGICAL':U,   0, ?, NO).

&ENDIF


&IF "{&ADMSuper}":U = "":U &THEN
  /* Put your property field definitions here.
     Use the following syntax, e.g.,
     ghADMProps:ADD-NEW-FIELD('MyProperty':U, 'CHAR':U, 0,'X(20)':U, 'Hi':U). */
   
&ENDIF

  {src/adm2/custom/combpropcustom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



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
    File        : fieldprop.i
    Purpose     : Starts Super procedure field.p and defines SmartDataField
                  properties
    Syntax      : {src/adm2/fieldprop.i}

    Description :

    Modified    : June 23, 1999 Version 9.1A
    Modified    : 10/25/2001        Mark Davies (MIP)
                  1. Added ADM props fields for DataValue and DisplayedValue
    Modified    : 03/15/2002        Mark Davies (MIP)
                  Added ADM props field for CustomSuperProc
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  {src/adm2/custom/fielddefscustom.i}

  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}FieldName,DisplayField,EnableField,LocalField

  /* This is the procedure to execute to set InstanceProperties at design time. */
  &IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
    &SCOP ADM-PROPERTY-DLG adm2/support/fieldd.w
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
     procedure's entry points. Also, start or attach to the super procedure.
     Skip start-super-proc if we *are* the super procedure. 
     And skip including the prototypes if we are *any* super procedure. */
&IF DEFINED(ADM-EXCLUDE-PROTOTYPES) = 0 &THEN
  &IF "{&ADMSuper}":U EQ "":U &THEN
    {src/adm2/fieldprto.i}
  &ENDIF
&ENDIF

  /* These preprocessors tell at compile time which properties can be
     retrieved directly from the temp-table. */
  &GLOB xpFieldName
  &GLOB xpFieldEnabled
  &GLOB xpEnableField
  &GLOB xpDisplayField
  &GLOBAL-DEFINE xpFrameWidgetID
  &global-define xpKeyField

  /* Include the next property file up the chain to get property FIELDs
     defined. */

  {src/adm2/visprop.i}
  
&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}~
KeyField


  IF NOT {&ADM-PROPS-DEFINED} THEN
  DO:
  &IF "{&ADMSuper}":U = "":U &THEN
    ghADMProps:ADD-NEW-FIELD('DataValue':U,      'CHARACTER':U, 0, ?, '':U).
    ghADMProps:ADD-NEW-FIELD('DisplayValue':U, 'CHARACTER':U, 0, ?, '':U).
    ghADMProps:ADD-NEW-FIELD('FieldName':U, 'CHAR':U, 0, ?, '':U).
    ghADMProps:ADD-NEW-FIELD('FieldEnabled':U, 'LOGICAL':U, 0, ?, no).
    ghADMProps:ADD-NEW-FIELD('EnableField':U, 'LOGICAL':U, 0, ?, no).
    ghADMProps:ADD-NEW-FIELD('DisplayField':U, 'LOGICAL':U, 0, ?, yes).
    ghADMProps:ADD-NEW-FIELD('DataModified':U, 'LOGICAL':U, 0, ?, no).
    ghADMProps:ADD-NEW-FIELD('CustomSuperProc':U, 'CHARACTER':U, 0, ?, '':U).
    ghADMProps:ADD-NEW-FIELD('LocalField':U, 'LOGICAL':U, 0, ?, NO).
    ghADMProps:ADD-NEW-FIELD('FrameWidgetID':U, 'INT':U).
    ghADMProps:ADD-NEW-FIELD('KeyField':U, 'CHAR':U, 0, ?, '':U).     
  &ENDIF

    {src/adm2/custom/fieldpropcustom.i}
  END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



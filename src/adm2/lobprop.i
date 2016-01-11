&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------------
    File        : lobprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/lobprop.i}

    Description :

    Modified    : 04/25/2004
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  &IF "{&xcInstanceProperties}":U NE "":U &THEN
    &GLOB xcInstanceProperties {&xcInstanceProperties},
  &ENDIF
  &GLOB xcInstanceProperties {&xcInstanceProperties}AutoFill,TempLocation
  
&ENDIF  
&IF DEFINED (ADM-PROPERTY-DLG) = 0 &THEN
    &SCOP ADM-PROPERTY-DLG adm2/support/lobfieldd.w
&ENDIF 
 

  /* Custom instance definition file */

  {src/adm2/custom/lobfielddefscustom.i}

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
   {src/adm2/lobprto.i}
  &ENDIF
&ENDIF  

&GLOBAL-DEFINE xpLOBFileName
&GLOBAL-DEFINE xpAutoFill
&GLOBAL-DEFINE xpTempLocation


  {src/adm2/fieldprop.i}

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:

&IF "{&ADMSuper}":U = "":U &THEN   ghADMProps:ADD-NEW-FIELD('LOBFileName':U,'CHARACTER':U,?,?,'').
  ghADMProps:ADD-NEW-FIELD('AutoFill':U,'LOGICAL':U,?,?,YES).
  ghADMProps:ADD-NEW-FIELD('TempLocation':U,'CHARACTER':U,?,?,'File':U).
&ENDIF

  {src/adm2/custom/lobpropcustom.i}

END.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



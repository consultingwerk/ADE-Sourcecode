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
    File        : appsprop.i
    Purpose     : Defines basic properties.
    Syntax      : {src/adm2/appsprop.i}

    Description :

    Modified    : 01/24/2001
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

  &IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* Custom instance definition file */
  {src/adm2/custom/appserverdefscustom.i}
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
         HEIGHT             = 7.86
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
    {src/adm2/appsprto.i}
  &ENDIF
&ENDIF

  /* These preprocessors tell at compile time which properties can
     be retrieved directly from the temp-table */
&GLOBAL-DEFINE xpASInfo
&GLOBAL-DEFINE xpASHasStarted
&GLOBAL-DEFINE xpASHasConnected
&GLOBAL-DEFINE xpASInitializeOnRun 
&GLOBAL-DEFINE xpASUsePrompt
&GLOBAL-DEFINE xpBindSignature
&GLOBAL-DEFINE xpServerOperatingMode
&GLOBAL-DEFINE xpServerFirstCall
                                      
/* include properties from smart */
{src/adm2/smrtprop.i}

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-PROPS-DEFINED} THEN
DO:

&IF "{&ADMSuper}":U = "":U &THEN
  ghADMProps:ADD-NEW-FIELD('AppService':U, 'CHAR':U, 0, ?, '':U).  
  ghADMProps:ADD-NEW-FIELD('ASDivision':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('ASHandle':U, 'HANDLE':U, 0, ?, ?). 
  ghADMProps:ADD-NEW-FIELD('ASHasConnected':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('ASHasStarted':U, 'LOGICAL':U, 0, ?, NO).
  ghADMProps:ADD-NEW-FIELD('ASInfo':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ASInitializeOnRun':U, 'LOGICAL':U, 0, ?, YES).
  ghADMProps:ADD-NEW-FIELD('ASUsePrompt':U, 'LOGICAL':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('BindSignature':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('BindScope':U, 'CHAR':U, 0, ?, '':U).
  ghADMProps:ADD-NEW-FIELD('ServerOperatingMode':U, 'CHAR':U, 0, ?, ?).
  ghADMProps:ADD-NEW-FIELD('ServerFileName':U,  'CHAR':U, 0, ?,?). 
  ghADMProps:ADD-NEW-FIELD('ServerFirstCall':U, 'LOGICAL':U, 0, ?, NO). 
  ghADMProps:ADD-NEW-FIELD('NeedContext':U, 'LOGICAL':U, 0, ?, ?). 
 &ENDIF

  {src/adm2/custom/appspropcustom.i}
END.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



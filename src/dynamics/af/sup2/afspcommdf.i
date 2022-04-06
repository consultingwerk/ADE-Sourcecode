&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Include 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : afspcommdf.i

    Purpose     : Common SmartPak Components Properties
                  Copied from SmartPak file src/adm2/spcommdf.i

  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
&IF "{&ADM-VERSION}" = "ADM2.0"
&THEN
    &IF DEFINED(xpAutoSize) > 0
    &THEN
        FIELD AutoSize AS LOGICAL INIT TRUE
    &ELSE
        &GLOBAL-DEFINE EXCLUDE-getAutoSize
    &ENDIF

    &IF DEFINED(xpEnableStates) > 0
    &THEN
        FIELD EnableStates  AS CHARACTER INIT "All"
        FIELD DisableStates AS CHARACTER INIT "All"
    &ELSE
        &GLOBAL-DEFINE EXCLUDE-getEnableStates
        &GLOBAL-DEFINE EXCLUDE-setEnableStates
    &ENDIF

    FIELD MouseCursor AS CHARACTER INIT "{&MOUSE-POINTER}"
&ELSE
    &IF DEFINED(xpAutoSize) > 0
    &THEN
        ghADMProps:ADD-NEW-FIELD('AutoSize':U,'LOGICAL', 0, ?, TRUE).
    &ELSE
        &GLOBAL-DEFINE EXCLUDE-getAutoSize
    &ENDIF

    &IF DEFINED(xpEnableStates) > 0
    &THEN
        ghADMProps:ADD-NEW-FIELD('EnableStates':U, 'CHARACTER', 0, ?, "All").
        ghADMProps:ADD-NEW-FIELD('DisableStates':U,'CHARACTER', 0, ?, "All").
    &ELSE
        &GLOBAL-DEFINE EXCLUDE-getEnableStates
        &GLOBAL-DEFINE EXCLUDE-setEnableStates
    &ENDIF

    ghADMProps:ADD-NEW-FIELD('MouseCursor':U,'CHARACTER', 0, ?, "{&MOUSE-POINTER}").
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



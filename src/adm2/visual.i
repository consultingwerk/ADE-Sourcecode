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
    File        : visual.i
    Purpose     : Defines basic properties and other info for visual objects

    Syntax      :

    Description :

    Modified    : May 19, 1999 Version 9.1A
    Modified    : 11/13/2001      Mark Davies (MIP)
                  Check for valid handle of any gsh... variables
  ------------------------------------------------------------------------*/
/*          This .i file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{&ADMClass}":U = "":U &THEN
  &GLOB ADMClass visual
&ENDIF

&IF "{&ADMClass}":U = "visual":U &THEN
  {src/adm2/visprop.i}
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Include 
/* ************************* Included-Libraries *********************** */

  &IF DEFINED(APP-SERVER-VARS) = 0 &THEN   
    {src/adm2/smart.i}
  &ELSE  
    {src/adm2/appserver.i}
  &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Include 


/* ***************************  Main Block  *************************** */
  

DEFINE VARIABLE cFields AS CHARACTER NO-UNDO.

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
IF NOT {&ADM-LOAD-FROM-REPOSITORY} THEN
  RUN start-super-proc ("adm2/visual.p":U).
&ENDIF

&IF "{&ENABLED-OBJECTS}":U <> "":U &THEN
  cFields =  REPLACE("{&ENABLED-OBJECTS}":U, " ":U, ",":U).
  {set EnabledObjFlds cFields}.
&ENDIF

&IF DEFINED(ADM-EXCLUDE-STATIC) = 0 &THEN
  /* _ADM-CODE-BLOCK-START _CUSTOM _INCLUDED-LIB-CUSTOM CUSTOM */
  {src/adm2/custom/visualcustom.i}
  /* _ADM-CODE-BLOCK-END */
&ENDIF

&IF "{&FRAME-NAME}":U <> "":U &THEN
  IF VALID-HANDLE(gshSessionManager) THEN
  DO:
    ON HELP OF FRAME {&FRAME-NAME} ANYWHERE
      RUN contextHelp IN gshSessionManager (INPUT THIS-PROCEDURE, INPUT FOCUS).
  END.

  ON CTRL-PAGE-UP OF FRAME {&FRAME-NAME} ANYWHERE DO:
    RUN processAction IN TARGET-PROCEDURE (INPUT "CTRL-PAGE-UP":U).
  END.
  
  ON CTRL-PAGE-DOWN OF FRAME {&FRAME-NAME} ANYWHERE DO:
    RUN processAction IN TARGET-PROCEDURE (INPUT "CTRL-PAGE-DOWN":U).
  END.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



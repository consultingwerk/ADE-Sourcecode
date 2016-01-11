&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
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



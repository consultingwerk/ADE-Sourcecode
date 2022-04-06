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
    File        : web/method/webutils.i
    Purpose     : Global variables and temp-tables
    Syntax      :
    Description :
    Notes       :
    Updated     : 05/15/2001 cthomson@bravepoint.com
                    Initial version
                  07/26/2001 adams@progress.com

  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

&IF "{1}" EQ "new" &THEN
&GLOBAL-DEFINE share-type NEW GLOBAL SHARED
&ELSE
&GLOBAL-DEFINE share-type SHARED 
&ENDIF

DEFINE {&share-type} VARIABLE glStateAware AS LOGICAL NO-UNDO.

/* For use with [get|set]AgentSetting functions. */
DEFINE {&share-type} TEMP-TABLE ttAgentSetting
  FIELD cKey       AS CHARACTER
  FIELD cSub       AS CHARACTER
  FIELD cName      AS CHARACTER 
  FIELD cVal       AS CHARACTER
  INDEX SettingIdx IS PRIMARY cKey cSub
  INDEX NameIdx cName.

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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



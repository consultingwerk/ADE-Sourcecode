&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*---------------------------------------------------------------------------------
  File: _reposaddfile.p

  Description:  adeuib/_reposaddfile.p

  Purpose:      API Call to add a file that is external to AB to repository.
                AB shared defines are used and defined as NEW to avoid conflicts with
                shared data the AppBuilder might be using.
                
                Program adeuib/_reposaddfl.p actually runs the Add to Repository
                dialog and performs the actual add to the repository. Since that
                program utilizes shared AppBuilder temp-tables and variables, callers
                other than AppBuilder (like this one) must define those shared
                elements as NEW to avoid data conflicts with the AppBuilder.
                
                Part of IZ 2513 Error when trying to save structured include

  Parameters:   INPUT  phWindow        AS HANDLE
                INPUT  pPrecid         AS RECID
                INPUT  pcProductModule AS CHARACTER
                INPUT  pcFileName      AS CHARACTER
                INPUT  pcType          AS CHARACTER
                OUTPUT pressedOK       AS LOGICAL

  History:
  --------
  (v:010000)    Task:           0   UserRef:    IZ 2513
                Date:   11/18/2001  Author:     John Palazzo

  Update Notes: Created from Template rytemprocp.p

---------------------------------------------------------------------------------*/
/*                   This .W file was created with the Progress UIB.             */
/*-------------------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
/* MIP-GET-OBJECT-VERSION pre-processors
   The following pre-processors are maintained automatically when the object is
   saved. They pull the object and version from Roundtable if possible so that it
   can be displayed in the about window of the container */

&scop object-name       _reposaddfile.p
DEFINE VARIABLE lv_this_object_name AS CHARACTER INITIAL "{&object-name}":U NO-UNDO.
&scop object-version    000000


/* object identifying preprocessor */
&glob   AstraProcedure    yes

{src/adm2/globals.i}

DEFINE INPUT  PARAMETER phWindow        AS HANDLE       NO-UNDO.
DEFINE INPUT  PARAMETER pPrecid         AS RECID        NO-UNDO.
DEFINE INPUT  PARAMETER pcProductModule AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcFileName      AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER pcType          AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER pressedOK       AS LOGICAL      NO-UNDO.

/* Need to use AppBuilder temp-tables and shared variables. They are defined new here
   to keep their shared variable and temp-tables separate from the AppBuilder's. */
{adeuib/sharvars.i NEW}.
{adeuib/uniwidg.i NEW}.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 8.1
         WIDTH              = 48.4.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

DO ON STOP UNDO, LEAVE:

    /* Run Add to Repos dialog and perform add to repos if need be. */
    RUN adeuib/_reposaddfl.p
        (INPUT phWindow,          /* Parent Window    */
         INPUT pPrecid,           /* _P recid         */
         INPUT pcProductModule,   /* Product Module   */
         INPUT pcFileName,        /* Object to add    */
         INPUT pcType,            /* File type        */
         OUTPUT pressedOK).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



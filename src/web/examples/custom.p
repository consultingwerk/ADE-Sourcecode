&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*------------------------------------------------------------------------
    File        : src/web/examples/custom.p
    Purpose     : This file demonstrates SUPER override on web-utilities-hdl

    Syntax      :

    Description :

    Author(s)   : Per Digre / tPC
    Created     :
    Notes       :
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE gscSessionId      AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE HTTP_COOKIE       AS char FORMAT "x(50)" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE SCRIPT_NAME       AS char FORMAT "x(50)" NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE PATH_INFO         AS char FORMAT "x(50)" NO-UNDO.

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
         HEIGHT             = 15
         WIDTH              = 60.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-init-session) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-session Procedure 
PROCEDURE init-session :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DYNAMIC-FUNCTION ("logNote" IN web-utilities-hdl, "NOTE":U,
                                "Initializing my custom") NO-ERROR.    
   RUN SUPER.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-run-batch-object) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE run-batch-object Procedure 
PROCEDURE run-batch-object :
/*------------------------------------------------------------------------------
  Purpose:     Run the selected program 
  Parameters:  pcFilename = (CHAR) Name of application file user is requesting
  Notes:       if this agent is in development and r code d oes not exist,
               then a compile on the requested html program will be attempted
               and the resulting r code will be run if possible
------------------------------------------------------------------------------*/
   gscSessionId = "Batch".
   DYNAMIC-FUNCTION ("logNote" IN web-utilities-hdl, "BATCH":U,
                                "*****Starting Batch*****") NO-ERROR.    
   /*** Whatever batch routines ***/
   DYNAMIC-FUNCTION ("logNote" IN web-utilities-hdl, "BATCH":U,
                                "************************") NO-ERROR.    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-run-web-object) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE run-web-object Procedure 
PROCEDURE run-web-object :
/*------------------------------------------------------------------------------
  Purpose:     Run the selected program 
  Parameters:  pcFilename = (CHAR) Name of application file user is requesting
  Notes:       if this agent is in development and r code d oes not exist,
               then a compile on the requested html program will be attempted
               and the resulting r code will be run if possible
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER pcFilename     AS CHARACTER  NO-UNDO.

/***** Extension mapping for dynamics *******/
  IF SCRIPT_NAME matches "*icf" THEN DO: 
    MESSAGE "Dynamics ExtMap:" SCRIPT_NAME.
    DYNAMIC-FUNCTION ("logNote" IN web-utilities-hdl, "NOTE":U,
                      "Dynamics ExtMap:" + SCRIPT_NAME) NO-ERROR.    
    assign PATH_INFO   = "/icfweb/"
           SCRIPT_NAME = REPLACE(SCRIPT_NAME,PATH_INFO,"").
    pcFilename = search("rm.r").    /** Execute Request Manager **/
  END.
  RUN SUPER (pcFilename).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


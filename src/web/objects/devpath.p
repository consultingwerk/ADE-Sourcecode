&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
    File        : devpath.p
    Purpose     : reassigns development propaths for individual developers                

    Syntax      : run webutil/devpath.p persistent set <handle>

    Description : this procedure is run as a "super" of web-utilities-hdl

    Author(s)   : mattB, mbaker@progress.com
    Created     : June 12, 2001
    Notes       : this procedure should only be run in a development
                  environment.  checks have been put in place to prevent
                  this code from running outside of a development broker

    Revision History:
                      
  ----------------------------------------------------------------------*/
/*          This .W file was created with the Progress AppBuilder.      */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE    NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE HTTP_COOKIE       AS CHARACTER NO-UNDO FORMAT "x(50)":U.

DEFINE VARIABLE lProPathReset           AS LOGICAL    NO-UNDO.
DEFINE VARIABLE cRealProPath            AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lDevMode                AS LOGICAL    NO-UNDO.

/** webstart.p */
FUNCTION getEnv                RETURNS CHARACTER
  (INPUT p_name                 AS CHARACTER) IN web-utilities-hdl.



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

&IF DEFINED(EXCLUDE-end-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE end-request Procedure 
PROCEDURE end-request :
/*------------------------------------------------------------------------------
  Purpose:     reset the current propath back to what it should be before
               the current run
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  RUN SUPER.
  IF lDevMode THEN DO:
    /*If we adjusted the propath, then adjust it back */
    IF lProPathReset THEN DO:
      ASSIGN 
        PROPATH       = cRealProPath
        lPropathReset = FALSE.  
      DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "NOTE":U,
                                    "Propath restored":U) NO-ERROR.    
    END.
  END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-config) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-config Procedure 
PROCEDURE init-config :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c1         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE c2         AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE i1         AS INTEGER    NO-UNDO.
  DEFINE VARIABLE lRetVal    AS LOGICAL    NO-UNDO.
  
  /* MultiDevPropath.  Allow multiple developers to customize the propath for 
     their use.  The devpropath will be prepended to the existing propath for 
     the duration of the run of the object, then returned to the default propath.
        
     MultiDevPropath=developer1=/usr/dev1/apps/test;/usr/dev1/apps/test2 |
                     developer2=/usr/dev2/apps/test;/usr/dev2/apps/test2
  */
  ASSIGN c1 = REPLACE(getEnv("MULTI_DEV_PROPATH":U),";":U,",":U).
  IF c1 NE ? AND c1 GT "" THEN
  DO i1 = 1 TO NUM-ENTRIES(c1,"|":U):
    ASSIGN
      c2      = TRIM(ENTRY(i1,c1,"|":U))
      lRetVal = DYNAMIC-FUNCTION("setAgentSetting":U IN web-utilities-hdl,"MultiDevPath":U,"",TRIM(ENTRY(1,c2,"=":U)),TRIM(ENTRY(2,c2,"=":U))).
  END.
   
  RUN SUPER.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-request Procedure 
PROCEDURE init-request :
/*------------------------------------------------------------------------------
  Purpose:     sets a custom propath for a developer
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cDevPath               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE cDevUser               AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE lRetVal                AS LOGICAL    NO-UNDO.
  
  /* Check for devuser value, and prepend propath with developer's custom 
     propath. */
  IF lDevMode THEN DO:
    ASSIGN cDevUser = DYNAMIC-FUNCTION("GET-VALUE":U IN web-utilities-hdl,"DEVUSER":U).
    IF cDevUser NE "" THEN DO:
      /* Set a cookie so the developer doesn't have to set this query value on
         every request. Cookie expires when web browser is closed. */
      IF INDEX(HTTP_COOKIE,"DEVUSER=":U) EQ 0 THEN  
        DYNAMIC-FUNCTION("set-cookie":U IN web-utilities-hdl,"DEVUSER":U,cDevUser,?,?,?,?,?). 
    
      ASSIGN cDevPath = DYNAMIC-FUNCTION("getAgentSetting":U IN web-utilities-hdl,
                       "MultiDevPath":U, "", cDevUser).
    
      /* store the original propath so we can put it back later, and then
         update the current propath with any changes */
      IF cDevPath NE "" THEN DO:
        ASSIGN cRealProPath  = (IF cRealProPath GT "" THEN cRealPropath ELSE PROPATH)
               lProPathReset = TRUE
               PROPATH       = cDevPath + ",":U + PROPATH.
        DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "NOTE":U,
                            SUBSTITUTE ("Propath modified for &1: &2":U, cDevUser, cDevPath )).    
      END.
    END. /* devuser */
  END.
  RUN SUPER.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-init-session) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE init-session Procedure 
PROCEDURE init-session :
/*------------------------------------------------------------------------------
  Purpose:     initialize some variables at startup time
  Parameters:  <none>
  Notes:       This procedure MUST ONLY be run in a development environment, 
               so check the environment and prevent anything from happening 
               if development is not set.
------------------------------------------------------------------------------*/
  
  lDevMode = DYNAMIC-FUNCTION("devCheck":U IN web-utilities-hdl).

  RUN SUPER.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


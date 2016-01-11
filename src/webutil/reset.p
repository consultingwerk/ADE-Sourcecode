&ANALYZE-SUSPEND _VERSION-NUMBER AB_v9r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*           This .W file was created with the Progress AppBuilder.     */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
         HEIGHT             = 14.14
         WIDTH              = 60.6.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Cue Card" Procedure _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* Custom CGI Wrapper Procedure,wdt,49681
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{src/web2/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest Web event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&IF DEFINED(EXCLUDE-process-web-request) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE cBroker AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE iPos    AS INTEGER    NO-UNDO.

  /* Output the MIME header. */
  output-content-type ("text/html":U).

  IF NOT debugging-enabled THEN DO:
    DYNAMIC-FUNCTION ("logNote":U IN web-utilities-hdl, "WARNING":U,
                              SUBSTITUTE ("Reset.p was requested by &1 and debugging mode not set. (Ref: &2)",
                                          REMOTE_ADDR, HTTP_REFERER)) NO-ERROR.
    DYNAMIC-FUNCTION ("ShowErrorScreen":U IN web-utilities-hdl,"Unable to find web object file 'reset.p'") NO-ERROR.  
    RETURN.
  END.

  RUN reset-utilities.
  {&OUT}
    '<HTML>':U SKIP
    '<BODY BGCOLOR="#FFFFCC" TEXT="#000000">':U SKIP
    '<H2>':U
    SUBSTITUTE('Reset &1 for this Agent.',
               IF VALID-HANDLE(web-utilities-hdl) AND debugging-enabled 
               THEN 'succeeded' ELSE 'failed')
    '</H2>':U SKIP
    '</BODY>':U SKIP
    '</HTML>':U SKIP.
    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-reset-utilities) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE reset-utilities Procedure 
PROCEDURE reset-utilities :
/* -------------------------------------------------------------------
   Procedure: reset-utilities
   Purpose:   Replaces web/objects/web-util.p with webutil/webstart.p
              as web-utilities-hdl.  Load all standard and user-defined 
              super-procedures.
 --------------------------------------------------------------------*/   
  DEFINE VARIABLE ix AS INTEGER    NO-UNDO.

  /* Clean up the existing utilities procedure. */
  IF VALID-HANDLE(web-utilities-hdl) THEN DO: 
    RUN destroy IN web-utilities-hdl NO-ERROR.
    /* Make sure it worked. */
    IF VALID-HANDLE(web-utilities-hdl) THEN
      DELETE PROCEDURE web-utilities-hdl.
  END.
  
  /* Create the utilities handle as a persistent procedure.*/
  if multi-session-agent() then
  do:
      RUN webutil/paswebstart.p PERSISTENT SET web-utilities-hdl NO-ERROR.
  end.
  else do:
      RUN webutil/webstart.p PERSISTENT SET web-utilities-hdl NO-ERROR.
  end.
  
  IF RETURN-VALUE GT "" OR NOT VALID-HANDLE(web-utilities-hdl) THEN DO:
    /* Write what went wrong to the log: <brokername>.server.log  */
    MESSAGE "ERROR: webstart.p did not load due to the following errors: ".
    DO ix = 1 TO NUM-ENTRIES(RETURN-VALUE,CHR(1)):
      MESSAGE ENTRY(ix, RETURN-VALUE,CHR(1)) SKIP.
    END.
    RETURN.
  END. /* error loading or invalid web-utilities-hdl */

  /* Initialize the tagmap file if classic webSpeed (old behavior) */
  if not multi-session-agent() then
    RUN reset-tagmap-utilities IN web-utilities-hdl.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


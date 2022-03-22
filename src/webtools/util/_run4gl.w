&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 GUI
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _run4gl.w

  Description: Runs progress 4GL code and outputs the code to the Webstream 
               
               All code is prefaces with src/web/method/cgidefs.i
               and 'OUTPUT TO "WEB"'.
               
               This is a utility program with parameters.  It cannot be 
               directly run from the web.

  Input Parameters:
      p_code: [CHAR] The code to output.  This has three variations
                 1) "code"
                       -- the code to be compiled
                 2) "Field: name"
                       -- the code is returned using GetField on the name
                          (Name is trimmed.).
                 3) "File: name"  [** NOT-IMPLEMENTED **]
                       -- the code is actually found in a Progress file
     p_title: [CHAR] Title of the web page (only if NO-HEAD is not specified)
     p_options: [CHAR] List of options supported
                  COMPACT -- Avoid using headings (e.g. "RESULTS:<HR>") because
                             the space is limited. 
                  PRE     -- Preformat the output
                  NO-HEAD -- No HTML <HEAD> or <CONTENT-TYPE>
                             (i.e. you can stream it into another page.
     
  Output Parameters:
     <none>
     
  RETURN-VALUE:
       "File Not Found" -- File not found (only for File:Name option
       "Compile Errors" -- Some compile errors (or some sort)
        

  Author:  Wm. T. Wood
  Created: September 10, 1996

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_code    AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_title   AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_options AS CHAR NO-UNDO.

/* Preprocessors for status values. */
&Scoped-define Compile-errors "Compiler Errors"
&Scoped-define File-not-found "File Not Found"

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by design tool only) 
  CREATE WINDOW Procedure ASSIGN
         HEIGHT             = 2.38
         WIDTH              = 36.
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{ src/web/method/wrap-cgi.i }
{ webutil/wstyle.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************ Local Definitions ********************** */
DEFINE VAR c_name     AS CHAR NO-UNDO.
DEFINE VAR c_status   AS CHAR NO-UNDO.  

DEFINE VAR l_compact  AS LOGICAL NO-UNDO.  /* Use a compact style. */
DEFINE VAR l_head     AS LOGICAL NO-UNDO.  /* Show a header. */
DEFINE VAR l_pre      AS LOGICAL NO-UNDO.  /* Preformat output. */

/* Stream to save file into. */
DEFINE STREAM codeStream.

/* ************************  Main Code Block  *********************** */

/* Check the p_code for the special cases of the "Field:" or "File:"  */
p_code = LEFT-TRIM(p_code).
IF p_code BEGINS "Field:":U THEN DO:
  /* Get the CODE from the input field. */
  IF LENGTH(p_code, "CHARACTER":U) < 7 THEN p_code = "".
  ELSE DO:
    c_name = TRIM(SUBSTRING(p_code, 7, -1, "CHARACTER":U)).
    RUN GetField IN web-utilities-hdl (INPUT c_name, OUTPUT p_code).
  END.
END. /* IF p_code BEGINS "Field:":U... */

/* Check special options.  */
ASSIGN l_compact = (LOOKUP ("COMPACT", p_options) > 0)
       l_head    = (LOOKUP ("NO-HEAD", p_options) eq 0)
       l_pre     = (LOOKUP ("PRE", p_options) > 0)
       .  

/* Output the header for the form (if necessary). */
IF l_head THEN DO:  
  /* Output the MIME header, and start returning the HTML form. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  
  /* Check the title. */
  IF p_title eq "?" THEN p_title = "WebSpeed 4GL Run Window".
  
  /* Create the header for the HTML form.  */
  {&OUT}
    '<HTML>~n
     <HEAD>~n 
     <TITLE>' p_title '</TITLE>~n 
     </HEAD>~n 
     <BODY>~n'
     .
END.

/* Run new, non-blank code. Don't run any newly created sample code. */
IF p_code eq "":U THEN
  {&OUT} '<P>There is no code to run.</P>'.
ELSE 
  RUN run-code (p_code, OUTPUT c_status).


/* Finish the Page.(if necessary). */
IF l_head THEN DO:    
  {&OUT}
   '</BODY>~n
    </HTML>~n'
    .
END.

/* Return the return value. */
IF c_status ne "":U THEN RETURN c_status.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE run-code Procedure 
PROCEDURE run-code :
/*------------------------------------------------------------------------------
  Purpose:     Run the code and report error messages, if any.
  Parameters:  p_4gl: Code to run.
               p_status: "Compile Errors" if there is an error. 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_4gl    AS CHAR NO-UNDO.
  DEFINE OUTPUT PARAMETER p_status AS CHAR NO-UNDO.
  
  DEFINE VARIABLE Comp_File    AS CHARACTER     NO-UNDO.
  DEFINE VARIABLE cXCode       AS CHARACTER     NO-UNDO.
  
  Execute-Block:
  DO ON STOP UNDO Execute-Block, LEAVE Execute-Block:
    
    /* Don't do anything if we don't have to. */
    IF ( p_4gl eq "") THEN RETURN.

    /* Generate a temporary filename to write the file to. */
    RUN adecomm/_tmpfile.p ( "" , ".cmp" , OUTPUT Comp_File ).
    
    /* Save to this file. */
    OUTPUT STREAM codeStream TO VALUE (Comp_File).
    PUT STREAM codeStream UNFORMATTED 
      'OUTPUT TO "WEB":U.' SKIP
      '~{ src/web/method/cgidefs.i }' SKIP
      .
    IF l_pre 
    THEN PUT STREAM codeStream UNFORMATTED
       "PUT UNFORMATTED '<PRE>'." SKIP    
        /* Don't close the </PRE> because the user might have done code like:
         * FOR EACH cust: DISPLAY cust.
         * The </PRE> would come after the first record. */
        p_4gl SKIP.
   
    ELSE PUT STREAM codeStream UNFORMATTED
       p_4gl SKIP.
     
    OUTPUT STREAM codeStream CLOSE.
    
    /* Compile the contents of the file. */
    ASSIGN
      cXCode = DYNAMIC-FUNCTION('getAgentSetting' IN web-utilities-hdl,'Compile','','xcode') NO-ERROR.  
    IF cXCode > "" 
    THEN COMPILE VALUE( Comp_File ) XCODE cXCode NO-ERROR.
    ELSE COMPILE VALUE( Comp_File ) NO-ERROR.

    /* Report any errors neatly. */
    IF COMPILER:ERROR THEN DO:
      p_status = "{&Compiler-Errors}".
      RUN webtools/util/_errmsgs.w
            (INPUT Comp_File, 
             INPUT (IF l_compact THEN "COMPACT" ELSE "")).
    END.
    ELSE DO:
      /* Run the file, after a label, if there is room. */
      IF NOT l_compact THEN {&OUT} format-text ('Results:', 'CENTER,H3':U) '<HR>~n'. 
      RUN VALUE(Comp_File).
    END.
  END. /* DO ON STOP */
    
  /* Delete the temporary file. */
  OS-DELETE VALUE ( Comp_File ).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



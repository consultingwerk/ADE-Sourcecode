&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebSpeed-Object
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: _seedit.w
  
  Description: Bring up the WebSpeed Java Section editor.
  Parameters:  p_proc-id  -- context id for the file
               p_code-id  -- context id of initial section. If this
                             is ?, then no default code section will be
                             used.
               p_options  -- comma delimeted list of additional options
                             (currently unused)

  Author:  Wm. T. Wood
  Created: January. 21, 1997
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_proc-id  AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p_code-id  AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p_options  AS CHAR    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Included Definitions ---                                             */
{ webutil/wstyle.i }     /* Standard style definitions. */
{ workshop/help.i }      /* Help Context Strings.       */
{ workshop/code.i }      /* Shared code temp-tables.    */
{ workshop/objects.i }   /* Shared objects temp-tables. */
{ workshop/sharvars.i }  /* Shared variables.           */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WebSpeed-Object


&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */

{src/web/method/wrap-cgi.i}
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ************************  Main Code Block  *********************** */

/* Process the latest WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEF VAR command    AS CHAR NO-UNDO.
  DEF VAR fileName   AS CHAR NO-UNDO.
  DEF VAR section    AS CHAR NO-UNDO.
  DEF VAR next-id    LIKE _code._next-id NO-UNDO.

  /* Generate the Section Editor. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  
  /* Get the current file record. */
  FIND _P WHERE RECID(_P) eq p_proc-id.
  IF NOT AVAILABLE (_P) THEN DO:
     RUN HtmlError IN web-utilities-hdl 
       ('File id ' + STRING(p_proc-id) + ' not found.').  
  END.
  ELSE DO:

    /* Get a Section to display. This is (a) the section desired; (b) the
       process-web-request or (c) the first CUSTOM section. */
    IF p_code-id ne ? THEN FIND _code WHERE RECID(_code) eq p_code-id NO-ERROR.
    ELSE DO:
      FIND _code WHERE _code._P-recid eq RECID(_P) 
                   AND _code._section eq "_PROCEDURE":U
                   AND _code._name eq "process-web-request":U NO-ERROR.
      IF NOT AVAILABLE _code  THEN DO:
        RUN workshop/_find_cd.p (p_proc-id, "FIRST":U, "":U, OUTPUT next-id).
        Search-Loop:
        DO WHILE next-id ne ?:
          FIND _code WHERE RECID(_code) eq next-id.
          IF _code._section eq "_CUSTOM":U THEN LEAVE Search-Loop.
          ELSE next-id = _code._next-id.
        END. /* Search-Loop: DO... */
      END.
      IF AVAILABLE _code THEN RECID(_code) eq p_code-id.
    END.
    /* Format the section ID and the command. */
    command = "Edit":U.
    IF AVAILABLE (_code) THEN section = STRING(RECID(_code)).

    /* Output the header. */
    {&OUT}
      { workshop/html.i &SEGMENTS = "head,open-body"
                        &FRAME    = "WSFC_main" 
                        &AUTHOR   = "Wm.T.Wood"
                        &TITLE    = "Section Editor"  } 
      { workshop/html.i &SEGMENTS = "help"
                        &FRAME    = "WSFC_main" 
                        &CONTEXT  = "{&Section_Editor_Help}" }
      format-filename (_P._filename, 'Editing &1...', '':U)
      '<CENTER>~n'
      { workshop/startse.i &P_BUFFER    = "_P"
                           &CODE_BUFFER = "_code"
                           &BUTTON      = "yes"
                           &DoCommand   = "command" } 
      '</CENTER>~n<BR>~n'
      .
   
  END.
  /* Finish the HTML. */
  {&OUT}
    '</BODY>~n'
    '</HTML>~n'
    .
  
END PROCEDURE.
&ANALYZE-RESUME
 


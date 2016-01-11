&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebTool
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
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

  File: oscommand.w

  Description: Runs a single line of code through "INPUT THROUGH".
               This allows you to do OS-COMMANDS (such as cp, mkdir, etc)
               and see the results.
               
               All code output to the web with "<PRE>...</PRE>".


  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: Wm. T. Wood

  Created: July 1, 1997

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Included Files ---                                                   */

/* Preprocessor Definitions ---                                         */
&Scoped-define ScriptDir src/web/scripts

/* Stream to save file into. */
DEFINE STREAM instream.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WebTool


&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* Standard WebTool Included Libraries --  */
{ webtools/webtool.i }
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

/* ***************************  Functions  **************************** */

&ANALYZE-SUSPEND _CODE-BLOCK _FUNCTION load-script 
FUNCTION load-script RETURNS CHAR (INPUT p_name AS CHAR) :
/*------------------------------------------------------------------------------
  Purpose:     Loads a file from the script directory into the CODE variable.
  Parameters:  p_name: filename of the script
  Returns:     "Error" message if code failed.
------------------------------------------------------------------------------*/
  DEF VAR next-line AS CHAR NO-UNDO.
  DEF VAR code-text AS CHAR NO-UNDO.

  /* Make sure the file exists. */
  FILE-INFO:FILE-NAME = "{&ScriptDir}/" + p_name.
  IF FILE-INFO:FULL-PATHNAME eq ? THEN RETURN "** Error loading script file.".
  ELSE DO:
    code-text = "":U.
    /* Read the first line of the file. */
    INPUT STREAM instream FROM VALUE(FILE-INFO:FULL-PATHNAME) NO-ECHO.
    Read-Block:
    REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
      IMPORT STREAM instream UNFORMATTED next-line.
      next-line = TRIM(next-line).
      IF next-line ne "" THEN DO:
        code-text = next-line.
        LEAVE Read-Block.
      END.
    END. /* Read-Block: */
    INPUT CLOSE.
    /* Trim the end of the code. */
    code-text = RIGHT-TRIM(code-text).
    /* Load succeeded. */
    RETURN code-text.
  END. /* IF FILE [exists]... */
END FUNCTION.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* ************************  Main Code Block  *********************** */

/* Handle the WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process Web Request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VAR ch          AS CHAR NO-UNDO.
  DEFINE VAR code        AS CHAR NO-UNDO.
  DEFINE VAR cols        AS CHAR NO-UNDO.
  DEFINE VAR i           AS INTEGER NO-UNDO.
  DEFINE VAR load-name   AS CHAR NO-UNDO.
  DEFINE VAR l_loadOK    AS LOGICAL NO-UNDO INITIAL yes.
  DEFINE VAR l_run       AS LOGICAL NO-UNDO.
  DEFINE VAR l_scriptDir AS LOGICAL NO-UNDO.
  
  /* 
   * Output the MIME header, and start returning the HTML form. This object is
   * not State-Aware, so run this directly.
   */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  /* See if there is a "Sample Script Dir" */
  FILE-INFO:FILE-NAME = "{&ScriptDir}".
  l_scriptDir = FILE-INFO:FULL-PATHNAME ne ? AND FILE-INFO:FILE-TYPE BEGINS "D":U.

  /* Are we loading a script? */
  load-name = get-value ('loadScript':U).
  IF load-name ne '':U THEN
    code = load-script(INPUT load-name).
  ELSE IF l_scriptDir AND get-value('ListScripts':U) ne '' THEN
    /* See if the user wants a list of scripts. */
    ASSIGN code = ""
           l_run = FALSE
           .
  ELSE 
   /* Get the code, and see if the user wants to RUN. */
   ASSIGN code  = get-value("CODE":U)
          l_run = REQUEST_METHOD eq "POST":U
          . 
  /*
   * Create the HTML form.  
   */
  {&OUT}
    {webtools/html.i 
      &SEGMENTS = "head,open-body,title-line"
      &AUTHOR   = "Wm.T.Wood"
      &TITLE    = "OS Command" 
      &FRAME    = "WS_main"  
      &CONTEXT  = "{&Webtools_OS_Command_Help}" }
    '<CENTER>~n'
    '<FORM METHOD="POST" ACTION="' AppURL '/' THIS-PROCEDURE:FILE-NAME '">~n'
    format-label ('OS Command', 'INPUT':U, '':U)
    .
   

  /* Place the CODE text input */ 
  {&OUT} 
    '<INPUT TYPE="TEXT" NAME="CODE" SIZE="40"~n' 
    '       VALUE="' html-encode(code) '">~n'
    '<INPUT TYPE="SUBMIT" NAME="Run" VALUE="Submit">~n'
    .
  /* Are there samples? */
  IF l_scriptDir 
  THEN {&OUT} '<INPUT TYPE="SUBMIT" NAME="ListScripts" VALUE="Load Script...">':U. 
  
  /* Finish the top part of the frame. */
  {&OUT} '</FORM>~n</CENTER>~n'.

  /* Execute non-blank code as an OS command. Don't run any newly loaded
    sample code.  Note if no lines are output.*/
  IF code ne "":U AND l_run THEN DO:
    {&OUT} format-text ('Results:', 'CENTER,H3':U) '<HR>~n'
           format-text ("Executing '" + html-encode(code) + "'...", 'H4':U) 
           '~n'
           '<PRE>~n'.
    i = 0.
    INPUT THROUGH VALUE(code).
    REPEAT:
      IMPORT UNFORMATTED ch.
      {&OUT} html-encode(ch) SKIP.
      i = i + 1.
    END.
    /* Note error. */
    IF i < 1 THEN {&OUT} "Command generated no output on this " OPSYS " system.".
    {&OUT} '</PRE>~n'.
  END. /* IF code... */
  ELSE IF l_scriptDir AND get-value ("ListScripts":U) ne 'no':U AND load-name eq '':U THEN DO:
    /* Does the user want a list of saved scripts? This is the default. */
    {&OUT} format-text (OPSYS + ' Sample Scripts:', 'CENTER,H3':U) '<HR><CENTER>~n'.
    /* Output a list of files in the scripts directory that match this type. */
    RUN webtools/util/_dirlist.w
           ("{&ScriptDir}",            /* Directory */
            "*.os",                    /* Filter */
            false,                     /* No directories */
            ' <A HREF="oscommnd.w?loadScript=&4">&1</A> ',
            '',                        /* non-empty leader */
            '',                        /* non-empty trailer */
            'No Scripts Available',    /* "empty" string. */
            '4,0,0,3':U,               /* Table columns, border,cellpadding, cellspacing,  */
            'Clean-Name':U,            /* Remove "_" and extension from name.  */
            OUTPUT i).         
   {&OUT} '</CENTER>~n'.
 
  END. /* IF...ListScripts... */
  
  /* Finish the Page. */  
  {&OUT}
   '</BODY>~n'
   '</HTML>~n'
    .
  
END PROCEDURE.
&ANALYZE-RESUME
 


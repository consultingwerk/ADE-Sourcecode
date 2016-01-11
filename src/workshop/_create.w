&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 WebSpeed-Object
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
  File: _create.w
  
  Description: Creates a new file in the WebSpeed Workshop
  Parameters:  
    p_template -- the name of the template file. If this is ? then
                  the template field will be looked at.
    p_tagfile  -- the name of the html file. If this is ? then the
                  tagfile field will be looked at.
    p_options  -- a comma-delimited list of options [currently unused]
  
  Fields:
    template -- the name of the template file to open.
    tagfile  -- the name of either the blank html file, or
                the offset file to use in creating the file.

  Author:  Wm. T. Wood
  Created: Jan. 21, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_template AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_tagfile  AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_options  AS CHAR NO-UNDO.

/* Included Definitions ---                                             */
{ webutil/wstyle.i }        /* Standard style definitions.    */
{ workshop/sharvars.i }     /* Common Shared variables.       */
{ workshop/objects.i }      /* Shared web-object temp-tables. */
{ workshop/errors.i }       /* Error handler and functions.   */

/* Local Variable Definitions ---                                       */

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

{ src/web/method/wrap-cgi.i }

&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 


/* **********************  Local Definitions  *********************** */
DEF VAR cnt        AS INTEGER NO-UNDO.
DEF VAR l_OK       AS LOGICAL NO-UNDO.
DEF VAR new-P-Id   AS INTEGER INITIAL ? NO-UNDO.

/* ************************  Main Code Block  *********************** */

/* Generate the output document for a failed creation. */
RUN outputContentType IN web-utilities-hdl ("text/html":U).   

/* Get the name of the template (and the name of the tagmap file, if
   there is one.  If these came in as ? parameters, look in the html
   fields.*/        
IF p_template eq ? THEN
  RUN GetField IN web-utilities-hdl ('template':U, OUTPUT p_template).
IF p_tagfile eq ? THEN
  RUN GetField IN web-utilities-hdl ('tagfile':U,  OUTPUT p_tagfile).

/* Check for the various error conditions. */
IF p_template eq "":U THEN
  RUN Add-Error IN _err-hdl
    ("ERROR":U, ?, 
     'A template must be specified to create a new file.').
ELSE IF SEARCH(p_template) eq ? THEN
  RUN Add-Error IN _err-hdl
    ("ERROR":U, ?, 
     SUBSTITUTE ('Template file "&1" not found.', p_template)).
ELSE IF p_tagfile ne "":U AND SEARCH(p_tagfile) eq ? THEN
  RUN Add-Error IN _err-hdl
    ("ERROR":U, ?, 
     SUBSTITUTE ('File "&1" not found.', p_tagfile)).

/* If there are any messages, report the error. */
IF {&Workshop-Errors}
THEN RUN output-failure-doc.
ELSE DO:
  /* Open the file -- restore settings after openning. */
  RUN workshop/_reader.p (INPUT  p_template, "OPEN UNTITLED":U, 
                          OUTPUT new-P-id).
  /* Restore the NUMERIC-FORMAT (we do this here incase reader error'd out. */
  SESSION:NUMERIC-FORMAT = _numeric_format.    
  /* Load from the tagmap template file. */
  IF new-P-id ne ? AND p_tagfile ne "":U THEN DO: 
    RUN workshop/_loadhtm.p (new-P-id, p_tagfile, OUTPUT l_ok).
    /* Was there a problem? */
    IF NOT l_ok THEN DO: 
      /* There was an error parsing the file, so just delete it. */
      RUN workshop/_delet_p.p (new-P-id).
      new-P-id = ?.
    END. /* IF NOT l_ok... */     
  END. /* IF new-P-id ne ? and p_tagfile ne "":U... */
  
  /* Output the HTML -- this is either the report of a failure, or the
     fileset frame. */
  IF new-P-id eq ?
  THEN RUN output-failure-doc.
  ELSE RUN workshop/_fileset.w ("file-id=":U + TRIM(STRING(new-P-id,">>>>>>>9":U)), "":U).
END.

&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-failure-doc 
PROCEDURE output-failure-doc :
/*------------------------------------------------------------------------------
  Purpose:     Output the HTML for a failure to create. 
               List all the messages.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Show the error message. */
  {&OUT} 
    { workshop/html.i &SEGMENTS = "head,open-body"
                      &FRAME    = "WSFI_main" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "Create File Failure" }
     '<B>Could not create the new web object...</B>~n'
         
     /* Were there any messages to report. */
     '<P>E<FONT SIZE="-1">RRORS:</FONT><UL>'
     .
  RUN Output-Errors IN _err-hdl ("ALL":U, ? /* Use default template */ ).
  
  /* Close the form. */
  {&OUT} 
      '</UL></P>~n'
      '</BODY>~n'
      '</HTML>~n'
      .

END PROCEDURE.

&ANALYZE-RESUME
 


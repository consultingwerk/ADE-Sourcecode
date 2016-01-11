&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Procedure 
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
  File: _preview.w
  
  Description: Save the file in a temporary name, then view this
               file. 4GL files are viewed as HTML.
               
  Input Parameters:  
    p_proc-id -- context id of the file
    p_options -- comma delimeted list of additional options. 
                 This list is passed through to webtools/util/_putfile.w

  Output Parameters:  
    <none>
    
  Author:  Wm. T. Wood
  Created: Feb. 2, 1997
------------------------------------------------------------------------*/
/*            This .W file was created with WebSpeed Workshop.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_proc-id  AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p_options  AS CHAR     NO-UNDO.

/* Included Definitions ---                                             */
{ workshop/errors.i }       /* Error handler and functions.   */
{ workshop/help.i }         /* Help Context Strings.          */
{ workshop/objects.i }      /* Shared web-object temp-tables. */
{ workshop/sharvars.i }     /* Common Shared variables.       */
{ webutil/wstyle.i }        /* Standard style definitions.    */
/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE WebSpeed-Object


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: WebSpeed-Object
   Allow: 
   Frames: 0
   Add Fields to: Neither
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


/* ***************  Runtime Attributes and Tool Settings  ************* */

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */

{ src/web/method/wrap-cgi.i }

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* **********************  Local Definitions  *********************** */    
DEFINE VARIABLE c_field     AS CHAR    NO-UNDO.
DEFINE VARIABLE l_header    AS LOGICAL NO-UNDO.
DEFINE VARIABLE prvw-file   AS CHAR    INITIAL ? NO-UNDO.
DEFINE VARIABLE put-options AS CHAR    INITIAL ? NO-UNDO.


/* ************************  Main Code Block  *********************** */
  
/* Get the relevent _P record. */
FIND _P WHERE RECID(_P) eq p_proc-id NO-ERROR.
IF ( NOT AVAILABLE _P ) 
THEN DO:
  RUN HtmlError IN web-utilities-hdl
           (SUBSTITUTE ('File id &1 not found.', p_proc-id)). 
  RETURN.
END.    
ELSE DO:     

  /* Parse options. */
  l_header = LOOKUP ("NO-HEAD", p_options) eq 0.
  
  /* Generate the header if necessary. */
  IF l_header THEN DO:
    RUN outputContentType IN web-utilities-hdl ("text/html":U).
    {&OUT} 
      { workshop/html.i &SEGMENTS = "head"
                        &FRAME    = "WSFI_main" 
                        &AUTHOR   = "Wm.T.Wood"
                        &TITLE    = "File View" }   
      /* Show the contents of a file against a white background. */
      '<BODY' get-body-phrase("Listing":U) '>~n'
      . 
      
  END.
  {&OUT}
     format-filename (_P._filename, "Viewing source for file &1...", "":U)
     { workshop/html.i &SEGMENTS = "help"
                       &FRAME    = "WSFC_main" 
                       &CONTEXT  = "{&File_View_Help}" }
     .

  /* If the file is not open, just prvw that file. Otherwise
     we have to create a new element. */
  IF NOT _P._open THEN prvw-file = _P._fullpath. 
  ELSE DO:
    /* Save the file. PREVIEW will use the _comp_file_name as 
       the temporary name and return the full path for it. */
    RUN workshop/_gen4gl.p (p_proc-id, "PREVIEW":U, ?, ?, OUTPUT prvw-file). 
    /* Reset the session numeric format. */
    SESSION:NUMERIC-FORMAT = _numeric_format.
  
    /* Report any messages or errors. */  
    IF {&Workshop-Errors} THEN DO:
      {&OUT} '<UL>~n'.    
      RUN Output-Errors IN _err-hdl ("ALL":U, ? /* Use default template */ ).
      {&OUT} '</UL>~n' .
    END.
  END. /* IF..._P._open... */
      
  /* Show the contents of the temporary file, if it exists. */
  IF prvw-file NE ? THEN DO:  
    /* Add a line. */
    {&OUT} '<HR>~n'.   
      
    /* Show the file. Don't output a header, and format the text
       accordingly. */ 
    IF LOOKUP("4GL":U, _P._type-list) > 0 THEN 
      RUN webtools/util/_putfile.w (prvw-file, ?, "No-Head,4GL,Line-Num":U).
    ELSE IF LOOKUP("HTML":U, _P._type-list) > 0 THEN
      RUN webtools/util/_putfile.w (prvw-file, ?, "No-Head,Listing,Line-Num":U).
    ELSE
      RUN webtools/util/_putfile.w (prvw-file, ?, "No-Head,Listing":U).    

    /* The temporary preview file is no longer needed */
    IF _P._open THEN OS-DELETE VALUE(prvw-file).
    
  END. /* IF prvw-file... */
  
  /* Close the file, if necessary. */
  IF l_header THEN {&OUT} '</BODY>~n</HTML>~n'.

END. /* IF...AVAILABLE _P ...  */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



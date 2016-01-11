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
  File: _check.w
  
  Description: Checks the Syntax of a file in the Workshop.

  Input Parameters:   
    p_proc-id -- context id of the file
    p_options -- comma delimeted list of additional options
                     "NO-HEAD" don't output the <HTML><HEAD../HEAD> ,
                               <BODY> or </BODY></HTML>. 
  Output Parameters:  
    <none>
     
  Fields:
     <none>
         
  Author:  Wm. T. Wood
  Created: Feb. 16, 1997
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_proc-id  AS INTEGER  NO-UNDO.
DEFINE INPUT PARAMETER p_options  AS CHAR     NO-UNDO.

/* Included Definitions ---                                             */
{ webutil/wstyle.i }        /* Standard style definitions.    */
{ workshop/errors.i }       /* Error handler and functions.   */
{ workshop/help.i }         /* Help context strings.          */
{ workshop/objects.i }      /* Shared web-object temp-tables. */
{ workshop/sharvars.i }     /* Common Shared variables.       */

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
 
DEFINE VARIABLE l_header    AS LOGICAL NO-UNDO.
DEFINE VARIABLE temp-name   AS CHAR   NO-UNDO.

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
      { workshop/html.i &SEGMENTS = "head,open-body"
                        &FRAME    = "WSFI_main" 
                        &AUTHOR   = "Wm.T.Wood"
                        &TITLE    = "Check Syntax" }
      .
  END.
  {&OUT}
     { workshop/html.i &SEGMENTS = "help"
                       &FRAME    = "WSFI_main"
                       &CONTEXT  = "{&Check_Syntax_Help}" } 
     .
     
  /* Check the file. */
  RUN workshop/_gen4gl.p 
      (INTEGER(RECID(_P)), "CHECK-SYNTAX":U, ?, ?, OUTPUT temp-name). 
  /* Reset the session numeric format. */
  SESSION:NUMERIC-FORMAT = _numeric_format.

  /* Report any messages as a list. */  
  IF {&Workshop-Errors} THEN DO:
    {&OUT} '<UL>~n'.
    RUN Output-Errors IN _err-hdl ("ALL":U, ? /* Use default template */ ).
    {&OUT} '</UL>~n' .
  END.
  
  /* Close the file, if necessary. */
  IF l_header THEN {&OUT} '~n</BODY>~n</HTML>~n'.
  
END. /* IF...AVAILABLE (_P)... */

&ANALYZE-RESUME
 


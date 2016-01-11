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
  File: _open.w
  
  Description: Opens a file in the WebSpeed Workshop
  Input Parameters: 
      p_id -- context id of the file
      p_fullpath -- full pathname of file
      p_options -- comma delimeted list of additional options
                   currently unused)
  Output Parameters: 
      p_open -- true if file was able to be open.

  Author:  Wm. T. Wood
  Created: Dec. 21, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT  PARAMETER p_id       AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p_fullpath AS CHAR    NO-UNDO.
DEFINE INPUT  PARAMETER p_options  AS CHAR    NO-UNDO.
DEFINE OUTPUT PARAMETER p_open     AS LOGICAL NO-UNDO.

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


/* ************************  Main Code Block  *********************** */

RUN output-open-doc.

&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-open-doc 
PROCEDURE  output-open-doc :
/*------------------------------------------------------------------------------
  Purpose:     Show the results of the openned screen.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE id AS INTEGER NO-UNDO.
  
  FIND _P WHERE RECID(_P) eq p_id NO-ERROR.
  IF ( NOT AVAILABLE _P ) THEN RUN HtmlError IN web-utilities-hdl
           (SUBSTITUTE ('File "&1" not found.', p_fullpath)).
  ELSE DO:
   
    /* Open the file -- restore settings after opening. */
    RUN workshop/_reader.p (_P._fullpath, "OPEN":U, OUTPUT id).
    IF RETURN-VALUE eq "_ABORT" OR _P._open eq no
    THEN p_open = no.
    ELSE p_open = yes.
    
    /* Restore the NUMERIC-FORMAT (we do this here incase reader error'd out. */
    SESSION:NUMERIC-FORMAT = _numeric_format.

    /* Output the HTML for a failure -- note that the READING could have been aborted. */
    IF NOT p_open THEN DO:
      /* Generate the output document. */
      RUN outputContentType IN web-utilities-hdl ("text/html":U).
 
      {&OUT} 
        { workshop/html.i &SEGMENTS = "head,open-body"
                          &FRAME    = "WSFI_main" 
                          &AUTHOR   = "Wm.T.Wood"
                          &TITLE    = "File Open Failure" }
        format-filename (_P._filename, "filename &1 could not be opened...", "":U).
      /* Report Errors. */
      IF {&Workshop-Errors} THEN DO:
        {&OUT} '<BR><BR>E<FONT SIZE="-1">RRORS:</FONT><UL>'.
        RUN Output-Errors IN _err-hdl ("ALL":U, ? /* Use Default Template */ ).
        {&OUT} '</UL>':U.  
      END.  
      /* Close the file. */
      {&OUT} '</BODY>~n</HTML>~n'.
    END. /* IF...ABORT...*/
  END. /* IF [available] _P... */
    
END PROCEDURE.

&ANALYZE-RESUME
 


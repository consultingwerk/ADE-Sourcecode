&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Web-Object
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
  File: workshop/_sectact.w
  
  Description: Acts on the current section.
  
  Parameters:  
    p_action -- "Edit" -- Edits the current screen. 

  Fields: this checks for
    section-id : The context ID of the section that is to be worked on.

  Author:  Wm. T. Wood
  Created: Jan. 9, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_action AS CHAR NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Included Definitions ---                                             */
{ webutil/wstyle.i }              /* Shared style guide definitions.    */
{ workshop/code.i }               /* Shared code temp-tables.           */
{ workshop/objects.i }            /* Shared objects temp-tables.        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Object


&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
{src/web/method/wrap-cgi.i}
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ********************  Additional Definitions  ******************** */

DEFINE VARIABLE c_id  AS CHAR    NO-UNDO.

/* ************************  Main Code Block  *********************** */

/* Determine a default. */
IF p_action eq "" THEN p_action = "Edit":U.

/* Get the current _code record. */
RUN GetField IN web-utilities-hdl ("section-id":U, OUTPUT c_id).
FIND _code WHERE RECID(_code) eq INTEGER(c_id) NO-ERROR.
    
/* Make sure file is specified. */
IF NOT AVAILABLE (_code) THEN DO:
  RUN HtmlError IN web-utilities-hdl 
         (SUBSTITUTE ('Section id &1 not valid.', c_id)).
  RETURN.
END.

/* Get the current file record. */
FIND _P WHERE RECID(_P) eq _code._p-recid NO-ERROR.
  
/* Can the request be handled by the section editor or another special tool? 
   If so, use it. */
IF LOOKUP (_code._section, "_PROCEDURE,_FUNCTION,_CUSTOM,_CONTROL":U) > 0 THEN                       
  RUN workshop/_seedit.w (INTEGER(RECID(_P)), INTEGER(RECID(_code)), "":U).
ELSE IF _code._section eq "_WORKSHOP":U AND _code._special eq "_PROCEDURE-SETTINGS":U THEN
  RUN workshop/_procset.r (p_action, RECID(_code), "":U).
ELSE IF _code._section eq "_WORKSHOP":U AND _code._special eq "_INCLUDED-LIBRARIES":U THEN
  RUN workshop/_methlib.r (p_action, RECID(_code), "":U).
ELSE DO:    
  /* Simply display the request. */
  CASE p_action:
    WHEN "Edit":U THEN RUN output-edit-doc IN THIS-PROCEDURE.
    WHEN "Save":U THEN DO:
      /* Save the code, if necessary. */
      RUN GetField IN web-utilities-hdl ("code-id":U, OUTPUT c_id).
      FIND _code-text WHERE RECID(_code-text) eq INTEGER (c_id) NO-ERROR.
      IF NOT AVAILABLE (_code-text)
      THEN RUN HtmlError IN web-utilities-hdl 
              (SUBSTITUTE ('Code Section id &1 not valid.', c_id)).    
      ELSE DO:
        RUN GetField IN web-utilities-hdl ('code-text':U, OUTPUT _code-text._text).
        IF AVAILABLE _P THEN _P._modified = yes.
        /* Redisplay the screen. */
        RUN output-edit-doc IN THIS-PROCEDURE.
      END.
    END.
    OTHERWISE
      RUN htmlError IN web-utilities-hdl ('Invalid section action requested:' + p_action).
  END CASE.
END.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-edit-doc 
PROCEDURE output-edit-doc :
/*------------------------------------------------------------------------------
  Purpose:     Output the  code for this section. 
               Convert all the sections to valid HTM before sending.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE next-id LIKE _code-text._next-id NO-UNDO.
 
 /* Output the MIME header and start of page. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
 {&OUT}
    { workshop/html.i &SEGMENTS = "head,open-body"
                      &FRAME    = "WSFC_main" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "Section Contents"  } 
    .
  /* For temporary debugging, add some more stuff. */
  {&OUT}
    format-label-text ('Section', _code._name)
    .     
  FIND _code-text WHERE RECID(_code-text) eq _code._text-id NO-ERROR.
  {&OUT} '~n<PRE>~n'.
  DO WHILE AVAILABLE _code-text:
    {&OUT} html-encode(_code-text._text). /* No NL */
    next-id = _code-text._next-id.
    FIND _code-text WHERE RECID(_code-text) eq next-id NO-ERROR.   
  END. /* DO WHILE AVAILABLE _code-text... */ 
 {&OUT} '~n</PRE>~n'.

  /*     
   *    Debugging Code -- Allow user to change contents.
   *
   *    DO WHILE AVAILABLE _code-text:
   *      {&OUT} 
   *         '<FORM ACTION="_main.w" METHOD="POST">~n'
   *         '<INPUT TYPE="HIDDEN" NAME="html"       VALUE="saveSection">~n'
   *         '<INPUT TYPE="HIDDEN" NAME="section-id" VALUE="' RECID(_code) '">~n'
   *         '<INPUT TYPE="HIDDEN" NAME="code-id"    VALUE="' RECID(_code-text) '">~n'
   *         '<CENTER>'
   *         '<TEXTAREA NAME="code-text" COLS="70" ROWS="15">' /* no NL */
   *         html-encode(_code-text._text)  /* no NL */ 
   *         '</TEXTAREA><BR>~n'
   *         '<INPUT TYPE="SUBMIT" VALUE="Save">&nbsp~;<INPUT TYPE="RESET">~n'
   *         '</CENTER>~n'
   *         '</FORM>~n'.
   *      next-id = _code-text._next-id.
   *      FIND _code-text WHERE RECID(_code-text) eq next-id NO-ERROR.   
   *    END. /* DO WHILE AVAILABLE _code-text... */ 
   */
    
  /* Close the page. */
  {&OUT}
    '</BODY>~n'
    '</HTML>~n'
    .
  
END PROCEDURE.
&ANALYZE-RESUME
 


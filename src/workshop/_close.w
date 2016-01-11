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
  File: _close.w
  
  Description: Close a file in the WebSpeed Workshop
  Parameters:  p_id -- context id of the file
               p_options -- comma delimeted list of additional options
                            (currently unused)   
  Fields: 
    "ignoreChanges" -- if "yes" then the file can be closed even if
                       it has been modifield.
                       
  Notes: This sets _P._open to FALSE, but does not delete the record.
  
  Author:  Wm. T. Wood
  Created: Dec. 30, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_id       AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER p_options  AS CHAR    NO-UNDO.

/* Included Definitions ---                                             */
{ webutil/wstyle.i }        /* Standard style definitions.    */
{ workshop/sharvars.i }     /* Common Shared variables.       */
{ workshop/objects.i }      /* Shared web-object temp-tables. */

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


/* *********************  Additional Defintions  ******************** */
DEFINE VARIABLE c_field         AS CHAR NO-UNDO.
DEFINE VARIABLE l_ignoreChanges AS LOGICAL NO-UNDO.

/* ************************  Main Code Block  *********************** */
  
/* Generate the output document. */
RUN outputContentType IN web-utilities-hdl ("text/html":U).
 
{&OUT} 
  { workshop/html.i &SEGMENTS = "head,open-body"
                    &TITLE    = "Close File"
                    &FRAME    = "WSFI_main"  }
  .

/* Get the relevent _P record. */
FIND _P WHERE RECID(_P) eq p_id NO-ERROR.
IF ( NOT AVAILABLE _P )
THEN RUN HtmlError IN web-utilities-hdl 
               (SUBSTITUTE ('File "&1" not found.', _P._filename)).
ELSE DO:
  /* See if the user wants to ignore changes before saving, if any
     changes exist? */
  RUN GetField IN web-utilities-hdl ("ignoreChanges":U, OUTPUT c_field).
  IF c_field ne "":U THEN l_ignoreChanges = yes.
  IF l_ignoreChanges OR NOT _P._modified
  THEN RUN output-close-doc.
  ELSE RUN confirm-close.
END.
  
/* Close the html stream. */
{&OUT} '</BODY>~n</HTML>~n'.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE confirm-close 
PROCEDURE confirm-close :
/*------------------------------------------------------------------------------
  Purpose:     Create an HTML file that asks the user if they are sure they
               want to close a modified file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  {&OUT}   
    /* Create a function to run if the user cancels the close.  This
       just clears the frame. */
    { workshop/javascpt.i
            &SEGMENTS      = "Clear-Self"   
            &FUNCTION-NAME = "clearSelf()" }                     
    '<FORM METHOD="POST">~n' 
    '<IMG SRC="/webspeed/images/question.gif" ALIGN="LEFT">~n'
    { workshop/html.i 
            &SEGMENTS = "HELP"
            &FRAME    = "WSFI_main"
            &CONTEXT  = "{&File_Delete_Help}" } 
    '<CENTER>~n'
    ' The file, <B>' _P._filename '</B>, has changes which have not been saved.<BR><BR>~n' 
    'Would you still like to close the file?~n'
    '<BR><BR>'
    '<INPUT TYPE="SUBMIT" NAME="ignoreChanges" VALUE="Yes, close the file anyway.">~n'
    '<INPUT TYPE="BUTTON" NAME="CancelDelete"  VALUE="No, keep the file open."~n'
    '       onClick="clearSelf();">~n'    
    '</CENTER></FORM>~n'
    .

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-close-doc 
PROCEDURE  output-close-doc :
/*------------------------------------------------------------------------------
  Purpose:     Show the results closing the file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
  /* Remove all _CODE & _U records before closing */
  RUN workshop/_close_p.p (INTEGER(RECID(_P)), "":U /* No options */ ).

  /* Output the HTML -- stating the file was closed. 
     If the file does not exist on disk, then output the message in the
     parent window. */ 
  {&OUT}
    format-filename (_P._filename, "File &1...", "":U)
    '<UL>...closed.</UL> ~n'
    /* Add the WebSpeed Editor stub needed to close any editor windows. */
    { workshop/startse.i &P_BUFFER  = "_P" &DoCommand = "'Close':U" }
    .
  
  /* Tell the header frame to clear itself, if the file does not exist. */
  IF _P._fullpath eq ? 
  THEN {&OUT} { workshop/javascpt.i &SEGMENTS    = "Clear-Frame"                         
                                    &FRAME       = "parent.WSFI_header" }   .

END PROCEDURE.
&ANALYZE-RESUME
 


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
  File: _delete.w
  
  Description: Delete a file in the WebSpeed Workshop
  Parameters:  p_filename -- short name of file
               p_fullpath -- full pathname of file
               p_options -- comma delimited list of additional options
                            (currently unused)

  Author:  Wm. T. Wood
  Created: Dec. 31, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p_filename AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_fullpath AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER p_options  AS CHAR NO-UNDO.

/* Included Definitions ---                                             */
{ webutil/wstyle.i }        /* Standard style definitions.    */
{ workshop/help.i }         /* Help Context Strings.          */
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

/* ***********************  Local Definitions *********************** */

DEF VAR c_field AS CHAR NO-UNDO.

/* ************************  Main Code Block  *********************** */

/* Generate the HTTP header. */
RUN outputContentType IN web-utilities-hdl ("text/html":U).

/* Get the _P record for this file. */
FIND _P WHERE _P._fullpath eq p_fullpath NO-ERROR.
    
IF ( NOT AVAILABLE _P ) OR ( SEARCH(_P._fullpath) eq ? )
THEN RUN HtmlError IN web-utilities-hdl (SUBSTITUTE ('File "&1" not found.', p_filename)).
ELSE DO:
  /* Has the delete request been confirmed? */
  RUN GetField IN web-utilities-hdl ('ConfirmDelete', OUTPUT c_field).
  IF c_field ne '':U 
  THEN RUN delete-file.
  ELSE RUN confirm-delete.
END.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE confirm-delete 
PROCEDURE confirm-delete :
/*------------------------------------------------------------------------------
  Purpose:     Create an HTML file that asks the user if they are sure they
               want to delete the file.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Output the page. */
  {&OUT}  
    { workshop/html.i &SEGMENTS = "head,open-body"
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "Delete File" 
                      &FRAME    = "WSFI_main" 
                      &TARGET   = "_parent"}
    { workshop/javascpt.i
            &SEGMENTS      = "Clear-Self"   
            &FUNCTION-NAME = "clearSelf()" }                     
    '<FORM METHOD="POST">~n' 
    .
  /* Break OUT to watch out for 4096 character statement limit. */
  {&OUT}
    { workshop/html.i 
            &SEGMENTS = "HELP"
            &FRAME    = "WSFI_main"
            &CONTEXT  = "{&File_Delete_Help}" } 
    '<CENTER>~n'
    'Are you sure you want to delete the file, <B>' _P._filename '</B>?~n'
    '<BR><BR>'
    '<INPUT TYPE="SUBMIT" NAME="ConfirmDelete" VALUE="Yes, delete the file.">~n'
    '<INPUT TYPE="BUTTON" NAME="CancelDelete"  VALUE="No, keep the file."~n'
    '       onClick="clearSelf();">~n'    
    '</CENTER></FORM>~n'
    '</BODY>~n'
    '</HTML>~n'
    .

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE delete-file 
PROCEDURE delete-file :
/*------------------------------------------------------------------------------
  Purpose:     Show the results of a deleted screen.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Delete the file -- */
  OS-DELETE VALUE(_P._fullpath).

  /* Output the page. */
  {&OUT}  
    { workshop/html.i &SEGMENTS = "head,open-body"
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "Delete File" 
                      &FRAME    = "WS_main" } .
 
  /* Output the HTML -- note if the file could not be deleted. */
  IF SEARCH(_P._fullpath) ne ? THEN DO:
    {&OUT}
      format-filename (p_filename, 'File &1 could not be deleted.', '':U)
      '<ul>~n' 
      'You may wish to check the file protection before trying again.~n'
      '</ul>'.
  END. /* IF...ABORT...*/
  ELSE DO:
    /* Report the result. */
    {&OUT}
      /* Tell the header frame to blank itself out. */
      format-filename(p_filename, 'File &1...', '':U)
      '<UL>...deleted.</UL> ~n'
      /* Add the WebSpeed Editor stub needed to close any editor windows. */
      { workshop/startse.i &P_BUFFER  = "_P" &DoCommand = "~'Close~':U" }
      .

    /* Delete the _P record. */
    RUN workshop/_delet_p.p (INTEGER (RECID(_P))).

  END. /* IF <not> ABORT... */
  /* Finish the page. */
  {&OUT} '</BODY>~n</HTML>~n'. 
    
END PROCEDURE.
&ANALYZE-RESUME
 


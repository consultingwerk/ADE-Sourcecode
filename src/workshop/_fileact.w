&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Procedure
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
  File: _fileact.w
  
  Description: Perform an action on a file.
  
  Parameters:  <none>
  
  Fields: This checks for the following CGI fields:
    file-id : The context ID of the file that is open
    
    One of the following actions will have a non-zero value.
            CompileFile, ViewFile, RunFile, OpenFile
    
  Author:  Wm. T. Wood
  Created: Oct 23, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed Workshop.           */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Included Definitions ---                                             */
{ webutil/wstyle.i }        /* Standard style definitions.    */
{ workshop/objects.i }      /* Shared web-object temp-tables. */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure


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

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE get-action 
PROCEDURE get-action :
/*------------------------------------------------------------------------------
  Purpose:     Figure out what the action should be.
  Parameters:  p_action: the action
  Notes:       The action can be set directly in the "action" field, or
               by particular named actions (like "CompileFile" or
               "ViewFile").
------------------------------------------------------------------------------*/
  DEFINE OUTPUT PARAMETER p_action AS CHAR    NO-UNDO.

  DEFINE VARIABLE c_field AS CHAR    NO-UNDO.
  
  /* Is the action explicitly specified? */
  RUN GetField IN web-utilities-hdl ('action':U, OUTPUT p_action).  
  IF p_action ne "":U THEN RETURN.

  IF p_action eq "":U THEN DO:
    RUN GetField IN web-utilities-hdl ('DeleteFile':U, OUTPUT c_field).
    IF c_field ne "":U THEN p_action = "Delete":U.
  END.    
 
  IF p_action eq "":U THEN DO:
    RUN GetField IN web-utilities-hdl ('List':U, OUTPUT c_field).
    IF c_field ne "":U THEN p_action = "List":U.
  END.

  IF p_action eq "":U THEN DO:
    RUN GetField IN web-utilities-hdl ('OpenFile':U, OUTPUT c_field).
    IF c_field ne "":U THEN p_action = "Open":U.
  END.    

  IF p_action eq "":U THEN DO:
    RUN GetField IN web-utilities-hdl ('RunFile':U, OUTPUT c_field).
    IF c_field ne "":U THEN p_action = "Run":U.
  END.

  IF p_action eq "":U THEN DO:
    RUN GetField IN web-utilities-hdl ('ViewFile':U, OUTPUT c_field).
    IF c_field ne "":U THEN p_action = "View":U.
  END.

  /* If we get here, the action is unknown. */
  IF p_action eq "":U THEN p_action = "UNKNOWN":U.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-compile-doc 
PROCEDURE output-compile-doc :
/*------------------------------------------------------------------------------
  Purpose:     Output the document for a "Compile".
  Parameters:  p_proc-id - Context ID of the current procedure.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_proc-id AS INTEGER NO-UNDO.
  
  /* Find the current procedure. */
  FIND _P WHERE RECID(_P) eq p_proc-id.

  /* Write a screen that shows the compile and save options. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  {&OUT} { workshop/html.i &SEGMENTS = "head,open-body"
                           &FRAME    = "WSFI_main" 
                           &AUTHOR   = "Wm.T.Wood"
                           &TITLE    = "File Compile" }  .
  /* Save the file first, if necessary. Otherwise, just compile. */
  IF _P._modified 
  THEN RUN workshop/_save.w (p_proc-id, "no-head,compile").
  ELSE RUN webtools/util/_fileact.w  (_P._filename, _P._fullpath, "Compile":U, "no-head":U).

  /* Finish the form. */
  {&OUT} '</BODY>~n</HTML>~n~n'.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-run-doc 
PROCEDURE output-run-doc :
/*------------------------------------------------------------------------------
  Purpose:     Output the document for a file "Run"
  Parameters:  p_proc-id - Context ID of the current procedure.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_proc-id AS INTEGER NO-UNDO.
  
  /* Find the current procedure. */
  FIND _P WHERE RECID(_P) eq p_proc-id.

  /* Write a screen that shows the compile and save options. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  {&OUT} { workshop/html.i &SEGMENTS = "head,open-body"
                           &FRAME    = "WSFI_main" 
                           &AUTHOR   = "Wm.T.Wood"
                           &TITLE    = "File Run" }  .
  /* Save the file first, if necessary. Otherwise, just compile. */
  IF _P._modified 
  THEN RUN workshop/_save.w (p_proc-id, "no-head,compile,run").
  ELSE RUN webtools/util/_fileact.w  (_P._filename, _P._fullpath, "Run":U, "no-head":U).

  /* Finish the form. */
  {&OUT} '</BODY>~n</HTML>~n~n'.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-unsaved-doc 
PROCEDURE output-unsaved-doc :
/*------------------------------------------------------------------------------
  Purpose:     Display a page asking the user to save before doing some action.
  Parameters:  p_action-text -- Name of action to use in text.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_action-text AS CHAR NO-UNDO.
  
  /* Generate the output document. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).
  {&OUT} 
    { workshop/html.i &SEGMENTS = "head,open-body"
                      &FRAME    = "WSFI_main" 
                      &AUTHOR   = "Wm.T.Wood"
                      &TITLE    = "File Modified Message" }
    '<IMG SRC="/webspeed/images/warning.gif" ALIGN="LEFT">~n'
    '<B>The web object is new and has never been saved.</B>~n' 
    '<BR>~n'
    'Please save the file before ' p_action-text '.~n'
    '</BR>~n'
    '</BODY>~n</HTML>~n'
    .
    
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       This call other routines that output the actual HTML. It does
               not set the header or the output itself.
------------------------------------------------------------------------------*/
  DEFINE VARIABLE action      AS CHAR    NO-UNDO.
  DEFINE VARIABLE c_directory AS CHAR    NO-UNDO.
  DEFINE VARIABLE c_filename  AS CHAR    NO-UNDO.
  DEFINE VARIABLE c_file-id   AS CHAR    NO-UNDO. 
  DEFINE VARIABLE l_ok        AS LOGICAL NO-UNDO. 
  DEFINE VARIABLE l_reload    AS LOGICAL NO-UNDO. 
  DEFINE VARIABLE proc-id     AS INTEGER NO-UNDO.
  DEFINE VARIABLE old-list    AS CHAR    NO-UNDO. 
 
  /* Find the current _P record (or create one if the file is new). */
  { workshop/find_p.i 
      &file-id   = "c_file-id"
      &filename  = "c_filename"
      &directory = "c_directory"
  }
 
  /* Make sure file is specified. */
  IF NOT AVAILABLE (_P) THEN DO:
    RUN OutputContentType IN web-utilities-hdl ('text/html':U).
    RUN HtmlError IN web-utilities-hdl 
         (SUBSTITUTE ('File id &1 not valid.', c_file-id)).
    RETURN.
  END.
  
  /* We should never get here for unsupported file types, but check for
     them anyway. */
  IF _P._type eq "Unsupported":U THEN DO:
    RUN OutputContentType IN web-utilities-hdl ('text/html':U).
    RUN HtmlError IN web-utilities-hdl 
         ('Workshop cannot work with this file.' +
           IF LOOKUP('Spaces-in-Name':U, _P._type-list) > 0
           THEN ' (The file name contains spaces.)' ELSE '':U).
    RETURN.
  END.

  /* Figure out what the action should be. Action is performed on the
     current _P. */ 
  RUN get-action (OUTPUT action).
  proc-id = RECID(_P).
  
  /* The following actions require an open file. If the file is not open,
     open it. */
  IF NOT _P._open 
     AND LOOKUP (action, "CheckSyntax,Edit,HtmlMap,List,Save,SaveAs":U) > 0
  THEN DO:  
    /* Openning the file may discover some information about the file
       that was unknown. If so, we need to reload the file. Save the
       initial state. */
    old-list = _P._type-list.
    RUN workshop/_open.w (proc-id, _P._fullpath, "":U, OUTPUT l_ok).   
    /* If the file did not open, return. */
    IF NOT l_ok THEN RETURN. 
    /* File openned... but did it change? */
    IF old-list ne _P._type-list THEN l_reload = yes.
  END.
  /* The following actions are invalid on a new, unsaved file. */
  ELSE IF _P._fullpath eq ? AND LOOKUP(action, "Compile,Run":U) > 0
  THEN DO:
    /* Let the user know the file has saved. */
    RUN output-unsaved-doc (IF action eq "Compile":U THEN "compiling" ELSE "running").
    RETURN.
  END.
   
  /*
     Process the file based on the action.  Note that some actions
     are assumed to operate on CLOSED files only (and as such can take
     the name and path.  Actions that operate on open files take the ID.
   */
  CASE action:
    WHEN "CheckSyntax":U 
      THEN RUN workshop/_check.w (proc-id, "":U).
    WHEN "Close":U 
      THEN RUN workshop/_close.w (proc-id, "":U).
    WHEN "Compile":U 
      THEN RUN output-compile-doc (proc-id).
    WHEN "ContentFrameset":U
      THEN RUN workshop/_content.w (proc-id, "":U).
    WHEN "Delete":U THEN DO:
      /* Handle the case (which should never occur) of trying to DELETE a
         file that is not saved. To avoid FILE NOT FOUND errors, just close it. */
      IF _P._fullpath ne ?
      THEN RUN workshop/_delete.w (_P._filename, _P._fullpath, "":U).
      ELSE RUN workshop/_close.w (proc-id, "":U).
    END.
    WHEN "Edit":U 
      THEN RUN workshop/_seedit.w (proc-id, ?, "":U).
    WHEN "HtmlMap":U 
      THEN RUN workshop/_htmlmap.w (proc-id, "":U).
    WHEN "List":U 
      THEN RUN workshop/_list.w (proc-id, "":U).
    WHEN "Run":U 
      THEN RUN output-run-doc (proc-id).
    WHEN "Save":U OR WHEN "SaveAs":U 
      THEN RUN workshop/_save.w 
            (proc-id, 
             IF action eq "SaveAs":U THEN "Ask-File-Name":U ELSE "":U).     
    WHEN "TagMap":U 
      THEN RUN workshop/_create.w 
               ("src/web/template/html-map.w",  /* Template file.   */
                _P._fullpath,                   /* HTML file to map */
                "":U).                          /* options          */
    WHEN "View":U 
      THEN RUN workshop/_preview.w (proc-id, "":U).
    OTHERWISE DO:
      RUN workshop/_undrcon.w ('File Action "' + action + '" is still under development.').
    END.

  END CASE.    
  
  /* Even though the HTML for the last request is finished, output the
     JavaScript necessary to tell the WSFI_header to reload itself,
     if necessary. [This was set above, when the file was openned.]*/
  IF l_reload THEN DO:
    {&OUT}
      /* Reload the header. This should be the File Menu 
         (workshop/_file.w) */
      { workshop/javascpt.i &SEGMENTS    = "Load-Sibling"                         
                            &FRAME       = "WSFI_header"
                            &FRAME-INDEX = "0" } .
  END.
END PROCEDURE.
&ANALYZE-RESUME
 


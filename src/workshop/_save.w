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
  File: _save.w
  
  Description: Save the file in the WebSpeed Workshop

  Input Parameters:   
    p_proc-id -- context id of the file
    p_options -- comma delimeted list of additional options
                     "NO-HEAD" don't output the <HTML><HEAD../HEAD> ,
                               <BODY> or </BODY></HTML>. 
                     "Ask-File-Name" ask the user for the filename prior
                               to saving. 
                     "Compile" Compile the file after saving (if compilable)
                     "Run"     Run the file after compiling (if compilable)
  Output Parameters:  
    <none>
     
  Fields:
    "SaveAs" -- suggested file name to use for save.
    "Overwrite" -- don't ask if saving over an existing file.
    
  Author:  Wm. T. Wood
  Created: Jan. 6, 1997
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

/* All errors will be in the same group. */
&Scoped-define ERR-GRP Name-Validation
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
DEFINE VARIABLE l_ask-name  AS LOGICAL NO-UNDO.  
DEFINE VARIABLE l_errors    AS LOGICAL NO-UNDO.  
DEFINE VARIABLE l_header    AS LOGICAL NO-UNDO.
DEFINE VARIABLE l_overwrite AS LOGICAL NO-UNDO.
DEFINE VARIABLE save-name   AS CHAR    NO-UNDO.
DEFINE VARIABLE c_field     AS CHAR    NO-UNDO.

/* ************************  Main Code Block  *********************** */

/* Add Passed options to options. */
p_options = p_options + "," + get-field ("PassedOptions":U).
/* Parse options. */
l_header = LOOKUP ("NO-HEAD", p_options) eq 0.

/* Get the relevent _P record. */
FIND _P WHERE RECID(_P) eq p_proc-id NO-ERROR.
IF ( NOT AVAILABLE _P ) 
THEN DO:
  RUN HtmlError IN web-utilities-hdl
           (SUBSTITUTE ('File id &1 not found.', p_proc-id)). 
  RETURN.
END.         

/* See if existing files should be overwritten. */
RUN GetField IN web-utilities-hdl ('Overwrite':U, OUTPUT c_field). 
IF c_field ne "" THEN l_overwrite = yes.   

/* Should we ask the user for the filename to use? (This would have
   happened if the user clicked a "Save As" button.) */
IF LOOKUP ("Ask-File-Name", p_options) > 0 THEN l_ask-name = yes.
ELSE DO:  
  /* Is there a save-as name to use? If not, use the saved path */     
  RUN GetField IN web-utilities-hdl ('SaveAs':U, OUTPUT save-name).
  /* Trim the name. */
  save-name = TRIM(save-name).
  IF save-name ne "":U 
  THEN RUN workshop/_valfnam.p (save-name, _P._type-list, '{&ERR-GRP}':U, OUTPUT l_errors).
  ELSE DO:
    /* save-name is blank. See if file has a valid name to use. */
    IF _P._fullpath eq ? THEN l_ask-name = yes.
    ELSE ASSIGN save-name = _P._fullpath 
                l_overwrite = yes.
  END.
END. 

/* Either ask for a name, or save the file. */
IF l_errors         THEN RUN output-save-as-doc ("Errors":U).
ELSE IF l_ask-name  THEN RUN output-save-as-doc ("New-Name":U).   
ELSE DO:   
  /* Going to save the save. If it exists, and they haven't decided to overwrite it,
     then ask to overwrite. */
  IF l_overwrite eq NO AND SEARCH(save-name) ne ?
  THEN RUN output-save-as-doc ("Name-Used":U).
  ELSE RUN output-save-doc.
END.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-save-as-doc 
PROCEDURE output-save-as-doc :
/*------------------------------------------------------------------------------
  Purpose:     Show the contents (objects and code sections) for the open file.
  Parameters:  p_mode -- the case this is called for.  There are two cases
                 "New-Name"  -- the user should enter a new name for the file
                 "Name-Used" -- the selected name is in use. Confirm the over-
                                writing of the name.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_mode AS CHAR NO-UNDO.

  DEFINE VARIABLE i      AS INTEGER NO-UNDO.
  DEFINE VARIABLE opts   AS CHAR NO-UNDO.
  
  /* Generate the header if necessary. */
  IF l_header THEN DO:
    RUN outputContentType IN web-utilities-hdl ("text/html":U).
    {&OUT} 
      { workshop/html.i &SEGMENTS = "head,open-body"
                        &FRAME    = "WSFI_main" 
                        &AUTHOR   = "Wm.T.Wood"
                        &TITLE    = "File Save As" }
      .
  END.
  
  /* Suggest a file name. */
  IF save-name eq "" OR save-name eq ? THEN DO:
    /* Is there a filename? */
    IF ENTRY(1, _P._filename , ":":U) ne "Untitled":U THEN save-name = _P._filename.
    ELSE DO:  
      /* If this is an HTML-Mapping file, then base the save name on the HTML file name. */
      IF _P._html-file ne "":U THEN DO:
        /* Set the filename for this file to be like the name of the tagfile. */
        save-name = _P._html-file.
        i = R-INDEX(save-name, ".").
        /* Watch for cases of a period in the directory, but not in the file extension
           (eg. /user/test.dir/myfile) */
        IF i > 0 AND INDEX(save-name, "~/":U, i) eq 0
        THEN save-name = SUBSTRING(save-name, 1, i - 1, "CHARACTER":U).
      END.
      ELSE DO:
        /* Default to the first twelve characters of the type. If the type is the same as
           the file extension, then use "newfile". Lower case this, */
        save-name = (IF _P._type eq _P._fileext THEN "newfile" ELSE lc(_P._type)).
        IF LENGTH(save-name, "CHARACTER":U) > 12 
        THEN save-name = SUBSTRING(save-name, 1, 12, "CHARACTER":U).     
      END. /* IF...html-file [eq] ""... */
      /* Add in the file extension (this was copied from the original template file). */
      IF _P._fileext eq "":U OR _P._fileext eq ? THEN _P._fileext eq "w".
      save-name = save-name + ".":U + _P._fileext.
    END. /* IF...Untitled... */
  END. /* IF save-name eq ""... */
   
  /* Output the form. */
  {&OUT} 
     '<FORM NAME="saveAsForm"~n'
     '      ACTION="_main.w?html=fileAction&amp~;action=save&amp~;file-id=' RECID(_P) '"~n'
     '      METHOD="POST">~n'
     '<CENTER>~n'
     { workshop/html.i &SEGMENTS = "help"
                       &FRAME    = "WSFI"
                       &CONTEXT  = "{&Save_As_Help}" }
     '<p>~n'
     . 
  CASE p_mode:
    WHEN "Name-Used":U THEN DO:
      {&OUT} '<IMG SRC="/webspeed/images/warning.gif" ALIGN="LEFT">~n'
             'The file already exists.<br> ~n'
             'Either enter a new name, or ask to overwrite the existing file.~n '. 
    END.
    WHEN "Errors":U THEN DO:
      {&OUT} '<IMG SRC="/webspeed/images/error.gif" ALIGN="LEFT">~n'
             '<B>File Naming Errors:</B><BR>~n'.
      RUN Output-Errors IN _err-hdl ('{&ERR-GRP}':U, '&1&2<BR>':U).
    END. 
    OTHERWISE
      {&OUT} '<IMG SRC="/webspeed/images/question.gif" ALIGN="LEFT">~n'
             'You must choose a file name for saving this file.~n'.
  END CASE.

  /* Output the rest of the form. */
  {&OUT}
     '</p>~n '
     '<TABLE BORDER="0" CELLPADDING="1" CELLSPACING="0">~n'
     '<TR>~n'
     '  <TD>' format-label("Save File As", "INPUT":U, "":U) '</FONT></TD>~n'
     '  <TD><INPUT TYPE="TEXT" NAME="saveAs" SIZE="40" VALUE="' save-name '"></TD>~n' 
     '  <TD><INPUT TYPE="SUBMIT" VALUE="Save"></TD>~n' 
     '</TR>~n'
     '<TR>~n'
     '  <TD>~&nbsp~;</TD>~n' /* empty cell */
     '  <TD><INPUT TYPE="CHECKBOX" NAME="Overwrite"' 
         IF l_overwrite THEN ' CHECKED>' ELSE '>':U
         'Overwrite file' IF p_mode ne "Name-Used":U THEN ', if it exists' ELSE ''
         '</TD>~n'
     '</TR>~n'
     '</TABLE>~n'
     '</CENTER>~n'
     '</FORM>~n'
     '<SCRIPT LANGUAGE="JavaScript">~n'
     '<!--~n'
     '  // Put focus in the saveAs field~n'
     '  document.saveAsForm.saveAs.focus();~n'
     '  document.saveAsForm.saveAs.select();~n'
     '  //-->~n'
     '</SCRIPT>'
     .
  /* Pass options for "Compile,Run". */
  IF LOOKUP ("Compile":U, p_options) > 0 THEN 
    opts = "Compile":U.
  IF LOOKUP ("Run":U, p_options) > 0 THEN
    opts = (IF opts eq "":U THEN "Run":U ELSE opts + ",Run":U).
  IF opts ne "":U THEN {&OUT} hidden-field ("passedOptions":U, opts).

  /* Close the file, if necessary. */
  IF l_header THEN {&OUT} '</BODY>~n</HTML>~n'.
  
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE output-save-doc 
PROCEDURE output-save-doc :
/*------------------------------------------------------------------------------
  Purpose:     Report results of a save.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def var l_compile   as logical no-undo.
  def var l_isaE4gl   as logical no-undo.
  def var l_fileSaved as logical no-undo.
  def var name        as character no-undo. 
  def var newloc      as character no-undo. 
  def var opts        as character no-undo. 
  def var path        as character no-undo.
  def var ue_name     as character no-undo.

  def buffer ip_P for _P.

  /* Parse options. */
  ASSIGN l_header = LOOKUP ("NO-HEAD", p_options) eq 0.
  
  /* Generate the header if necessary. */
  IF l_header THEN DO:
    RUN outputContentType IN web-utilities-hdl ("text/html":U).
    {&OUT} 
      { workshop/html.i &SEGMENTS = "head,open-body"
                        &FRAME    = "WSFI_main" 
                        &AUTHOR   = "Wm.T.Wood"
                        &TITLE    = "File Save" }
      .
  END.
  {&OUT}
     format-filename (save-name, "Saving file &1...":U, "":U)
     { workshop/html.i &SEGMENTS = "help"
                       &FRAME    = "WSFI_main"
                       &CONTEXT  = "{&Saving_File_Help}" }
     '<UL>~n'     
     .
  
  /*  Make sure that we have the full pathname of the file, not
      just a local path. Build the full pathname.  */
  FILE-INFO:FILE-NAME = save-name.
  if FILE-INFO:FULL-PATHNAME = ? THEN DO:
    /* Figure out the current path, but first, figure out if the
       proposed name already is a fully qualified name. 
       If the path is "?" then there was no path. The save-name 
       is a simple name. Build a full path for it.  */
    run adecomm/_osprefx.p(save-name, OUTPUT path, OUTPUT name).
    if (LENGTH(path) eq 0) THEN DO:
      FILE-INFO:FILE-NAME = ".".
      run adecomm/_osfmush.p(INPUT  FILE-INFO:FULL-PATHNAME,
                             INPUT  save-name,
		             OUTPUT save-name).
    END.
  END.
  ELSE save-name = FILE-INFO:FULL-PATHNAME.  

  /*
   * Now check to see if the file that the user selected is already in
   * being used by an open window. If it is, then let the user know there
   * is a conflict. It is up to the user to get everything figured
   * out. We check to see if there are 2 records with the same name.
   * If there are 0 or 1 the FIND NEXT will fail.
   */
  FIND ip_P WHERE ip_P._fullpath eq save-name 
              AND ip_P._open
              AND RECID(ip_P) <> RECID(_P) NO-ERROR.
  IF AVAILABLE ip_P 
  THEN DO:
    RUN Add-Error IN _err-hdl
       ("ERROR":U, 
        ?,
	SUBSTITUTE ("Another open file uses &1 to save into. " +
                    "Either close that file or choose another filename " +
                    "for this window.", save-name)).
  END. 
  ELSE DO:
    /* Save the file. */
    RUN workshop/_gen4gl.p 
      (INTEGER(RECID(_P)), "SAVE":U, ?, save-name, OUTPUT save-name). 
    l_FileSaved = save-name ne ?.
    /* Reset the session numeric format. */
    SESSION:NUMERIC-FORMAT = _numeric_format.
  
    /* Note that the file has been saved with the new name. */
    IF l_FileSaved THEN DO:     
      
      /* Record the save as successful */
      ASSIGN _P._modified = NO.
    
      /* Remove any other files that are using this name. (NOTE that
         we checked for OPEN files with this name, but not closed ones).
         Closed ones need to be deleted or we won't have a unique 
         _P._fullpath. */
      FOR EACH ip_P WHERE ip_P._fullpath eq save-name
                      AND RECID(ip_P) <> RECID(_P):
        RUN workshop/_delet_p.w (INPUT INTEGER(RECID(ip_P))).
      END.       
      
      /* Change the filename of the saved file. */
      IF _P._fullpath ne save-name THEN DO:
        _P._fullpath = save-name.
        RUN webutil/_relname.p (INPUT _P._fullpath, "":U, OUTPUT _P._filename).
        /* Insert the JavaScript to tell the File Menu frame to redisplay
           (with the new name). */
        /* Tell the header frame to reload itself. */
        newloc = AppURL + 
                 "/workshop/_main.w?html=mainFile&file-id=" + STRING(RECID(_P)).
        {&OUT} { workshop/javascpt.i
                   &SEGMENTS    = "Load-Sibling"                         
                   &FRAME       = "WSFI_header" 
                   &LOCATION    = "newloc"
                   &FRAME-INDEX = "0" } .
      END. /* IF <new name> ... */  
      /* Output a message. */
      {&OUT} 'File saved.'.
      /* Should we compile on save? (HTML include files can be "compiled" to .i's). */
      IF (LOOKUP("INCLUDE":U, _P._type-list) eq 0 AND LOOKUP("4GL":U, _P._type-list) > 0) OR
         LOOKUP("HTML":U, _P._type-list) > 0
      THEN DO:
        /* See if an E4GL file needs to be compiled. We could have done this every time the section
           is saved in the Section Editor (_secomm.w). */
        IF LOOKUP("HTML":U, _P._type-list) > 0 AND LOOKUP("MAPPED":U, _P._type-list) eq 0
        THEN RUN workshop/_wsopt.p (INPUT p_proc-id, OUTPUT l_isaE4gl).
        /* Don't automatically compile templates. */
        IF LOOKUP ("Compile", p_options) > 0 OR (_P._compile AND NOT _P._template)
        THEN l_compile = yes. 
        ELSE DO: 
          /* Give the user the option of compiling the file. */
          /* URL-encode the full pathname. */
          RUN UrlEncode IN web-utilities-hdl (INPUT _P._fullpath, OUTPUT ue_Name, INPUT "QUERY":U).
          {&OUT}
            ' Click '
            '<A HREF="' AppURL '/workshop/_main.w?html=fileAction&amp;action=compile&filename='
            ue_Name '"><IMG SRC="/webspeed/images/u-compil.gif" ALT="Compile" BORDER="0" ALIGN="MIDDLE"></A>~n'
            ' to compile the file now.~n'
            .
        END. /* IF [not] _P._compile... */  
      END. /* IF 4gl/html and not include... */ 
    END. /* If l_fileSaved */  
  END. /* IF <not> AVAILABLE ip_P... */

  /* Report any messages. */  
  IF {&Workshop-Errors} THEN 
    RUN Output-Errors IN _err-hdl ("ALL":U, ? /* Use default template */ ).

  /* Finish the list */
  {&OUT} '</UL>~n' .

  /* Compile the file automatically, if necessary. */
  IF l_compile THEN DO:
    opts = "No-Head" + (IF LOOKUP("Run", p_options) > 0 THEN ",Run":U ELSE "":U).
    RUN webtools/util/_fileact.p (_P._filename, _P._fullpath, "Compile":U, opts).
  END.

  /* Close the file, if necessary. */
  IF l_header THEN {&OUT} '~n</BODY>~n</HTML>~n'.
  
END PROCEDURE.
&ANALYZE-RESUME
 


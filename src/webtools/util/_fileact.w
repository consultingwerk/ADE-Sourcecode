&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 Procedure
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
  
  Description: Perform an action on a file in the current directory.
  
  Parameters: 
    p_filename -- the simple filename [used in titles etc. ]
    p_fullname -- full pathname
    p_action   -- action.  Supported actions are:
                      CheckSyntax, Compile, View, Run, Open, GenerateE4GL, TagExtract
                  Check-Syntax is like Compile except it deletes all
                  the temporary e4gl files and r-code.
    p_options  -- comma-delimited list of options supplied
                  (this list depends on the nature of p_action)
                  
                  Special options on Compile/Check-Syntax:
                    Save-E4GL-gen -- don't removes intermediate e4gl files
                                     after compiling (NOTE: .i files are always saved).
                    No-run-message -- don't show the "Click here to run this file."
                                      message (compile only)
                    No-w-save-message -- don't show the "Click here to save the .w file"
                                         message (all options)
                    Run -- Run after compiling (compile only)
                                 
  Fields: This checks for the following CGI fields:
  
    directory: The full pathname of the directory where the file can be found.
    Filename : The Filename of the file
   
  Author:  Wm. T. Wood
  Created: Oct 23, 1996
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/
DEFINE INPUT PARAMETER  p_filename AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER  p_fullpath AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER  p_action   AS CHAR NO-UNDO.
DEFINE INPUT PARAMETER  p_options  AS CHAR NO-UNDO.

/* ***************************  Definitions  ************************** */

/* Included Definitions ---                                             */
{ webutil/wstyle.i }       /* Standard style definitions and functions. */

/* Local Variable Definitions ---                                       */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE Procedure


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _INCLUDED-LIBRARIES
/* ************************* Included-Libraries *********************** */

{src/web/method/cgidefs.i}  /* needed by webutil/_genoff.p */
{src/web/method/wrap-cgi.i}
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 
/* ***********************  Local Definitions  ********************** */
DEFINE VARIABLE c_offset    AS CHAR    NO-UNDO.
DEFINE VARIABLE c_type      AS CHAR    NO-UNDO.
DEFINE VARIABLE c_typelist  AS CHAR    NO-UNDO.
DEFINE VARIABLE l_include   AS LOGICAL NO-UNDO.
DEFINE VARIABLE o_newfile   AS CHAR    NO-UNDO.

/* ************************  Main Code Block  *********************** */

/* Process the file based on the action. */
CASE p_action:
  WHEN "CheckSyntax":U THEN
    RUN compile-file (p_filename, p_fullpath, TRUE).  
  WHEN "Compile":U THEN
    RUN compile-file (p_filename, p_fullpath, FALSE).    
  WHEN "Delete":U THEN 
    RUN delete-file (p_filename, p_fullpath).
  WHEN "Open":U THEN 
    RUN workshop/_fileset.w (url-field ("filename":U, p_fullpath, "":U), "":U).
  WHEN "Run":U THEN  
    RUN run-file (p_filename, p_fullpath).
  WHEN "TagExtract":U THEN  
    RUN tag-extract (p_fullpath).
  WHEN "View":U THEN DO:
    /* Check the file type. */ 
    RUN webtools/util/_filetyp.p (p_fullpath, OUTPUT c_type, OUTPUT c_typelist).
    IF LOOKUP("4GL":U, c_typelist) > 0 THEN 
      RUN webtools/util/_putfile.w (p_fullpath, "text/html":U, "4GL":U).
    ELSE IF LOOKUP("TEXT":U, c_typelist) > 0 THEN
      RUN webtools/util/_putfile.w (p_fullpath, "text/html":U, "Listing":U).
    ELSE  
      RUN webtools/util/_putfile.w (p_fullpath, "text/plain":U, "").
  END.
  WHEN "GenerateE4GL":U THEN
    RUN e4glgen-file (p_filename, "No-W-Save-Message," + p_options, OUTPUT l_include, OUTPUT o_newfile).

END CASE.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE compile-file 
PROCEDURE compile-file :
/*------------------------------------------------------------------------------
  Purpose:     Compile the file and report any errors.
  Parameters:  p_filename -- name of the file
               p_fullpath -- full pathname of the file.
               p_checkOnly -- TRUE if CHECK-SYNTAX. 
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_filename  AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER p_fullpath  AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER p_checkOnly AS LOGICAL NO-UNDO.
  
  /* Local variable definitions */         
  DEFINE VARIABLE l_del-e4gl   AS LOGICAL NO-UNDO INITIAL yes.
  DEFINE VARIABLE l_e4gl       AS LOGICAL NO-UNDO.
  DEFINE VARIABLE l_head       AS LOGICAL NO-UNDO INITIAL yes.
  DEFINE VARIABLE l_include    AS LOGICAL NO-UNDO.
  DEFINE VARIABLE l_run-msg    AS LOGICAL NO-UNDO INITIAL yes.
  DEFINE VARIABLE l_w-save-msg AS LOGICAL NO-UNDO INITIAL yes.
  DEFINE VARIABLE l_run        AS LOGICAL NO-UNDO.
  
  DEFINE VARIABLE cXCode       AS CHAR    NO-UNDO.
  DEFINE VARIABLE f_type       AS CHAR    NO-UNDO.
  DEFINE VARIABLE f_list       AS CHAR    NO-UNDO.
  DEFINE VARIABLE f_compfile   AS CHAR    NO-UNDO.

  DEFINE VARIABLE run-name     AS CHAR    NO-UNDO.

  /* Check options. */
  IF LOOKUP("no-head":U,  p_options) > 0         THEN l_head    = no.
  IF LOOKUP("save-e4gl-gen":U, p_options) > 0    THEN l_del-e4gl = no.
  IF LOOKUP ("Run":U, p_options) > 0             THEN l_run     = yes.
  /* Show a "Click here to run"  message unless (a) the user doesn't want it;
     (b) we are doing Check Syntax; or (c) we are going to run anyway. */
  IF p_checkOnly OR l_run OR 
     LOOKUP("no-run-message":U, p_options) > 0   THEN l_run-msg  = no.
  /* See if we want to add a Save message for e4gl files. */
  IF p_checkOnly OR l_del-e4gl eq NO OR
     LOOKUP("no-w-save-message":U, p_options) > 0 THEN l_w-save-msg = no.
  /* Should we generate E4GL intermediate file. Check options, 
     and/or look at the file type. */
  IF LOOKUP("e4gl-gen":U, p_options) > 0          THEN l_e4gl = yes.
  ELSE DO:
    /* Check if file is E4GL type before compiling */
    RUN webtools/util/_filetyp.p (p_fullpath, OUTPUT f_type, OUTPUT f_list).
    IF LOOKUP("HTML":u, f_list) > 0 THEN l_e4gl = yes.        
    IF LOOKUP("include":U, f_list) > 0 THEN ASSIGN l_include = yes
                                                   l_run = no.      
  END.
  
  /* This is an HTML document. */
  RUN OutputContentType IN web-utilities-hdl ('text/html':U).
  
  /* Create the header for the HTML form. Note that we only CHECK SYNTAX of include files. */
  IF l_head THEN DO:   
    IF p_checkOnly
    THEN {&OUT}
        {webtools/html.i 
       &SEGMENTS = "head,open-body,sub-title"
       &AUTHOR = "Wm. T. Wood"
       &TITLE = "Check Syntax"
       &FRAME = "WS_main" }
           .
    ELSE {&OUT}
        {webtools/html.i 
       &SEGMENTS = "head,open-body,sub-title"
       &AUTHOR = "Wm. T. Wood"
       &TITLE = "Compile File"
       &FRAME = "WS_main" }
           .
  END. /* IF h_head THEN DO... */
 

  /* Check if file is E4GL type before compiling */
  RUN webtools/util/_filetyp.p (INPUT  p_fullpath, 
                OUTPUT f_type, 
                OUTPUT f_list).
  /* If this is an E4GL file, then the file to compile is the generated file. 
     Otherwise the input file is the file to compile. */
  IF NOT l_e4gl THEN f_compfile = p_fullpath.     
  ELSE DO: 
    /* Run the E4GL generator code, but add the NO-HEAD to the
       options because this procedure has done that.  If we are just checking syntax,
       then don't show the name of the temporary file. */    
    RUN e4glgen-file( p_filename, 
                     "no-head" +
                     (IF l_del-e4gl OR p_CheckOnly THEN ",no-4gl-name":U ELSE "":U) + 
                     (IF l_w-save-msg THEN "" ELSE ",no-w-save-message"), 
                     OUTPUT l_include,
                     OUTPUT f_compfile).
    /* If this is an include file, tell the user we are not deleting the file. 
      (but don't compile it.). */
    IF l_include THEN DO:
      {&OUT} format-filename (f_compfile, 'Saving generated SpeedScript include file &1...~n', '':U)
             '<UL>Click '
             '<A HREF="' AppURL 
                       '/webtools/fileact.w?action=CheckSyntax&filename=' 
                       url-encode(f_compfile,"QUERY":U) '">'
             '<IMG SRC="' RootURL '/images/u-compil.gif" ALT="Check Syntax" BORDER="0" ALIGN="MIDDLE"></A>~n'
             ' to check the syntax of this include file.~n'
             '</UL>~n'. 
      /* Don't Compile. */
      RETURN.
    END. /* IF l_include... */
  END. /* IF [HTML file, not mapped]... */

  IF (f_type eq "R-CODE":U) OR (f_type eq "BINARY":U) 
      OR (f_type eq "4GL include") OR (LOOKUP("binary":U, f_list) > 0 ) THEN DO:
     {&OUT} format-filename (p_filename, 'Error attempting to compile &1...', '':U)
            '<BR><BR>~n'
            '&nbsp~; This file cannot be compiled because it is the wrong file type. ~n'.
     RETURN.
  END.
  /* Now compile the file. */
  IF f_compfile ne ? THEN DO:
    {&OUT} format-filename (p_filename, 
                            IF p_checkOnly THEN 'Checking &1...' ELSE 'Compiling &1...',
                            '':U).
    {&OUT} '~n':U.

    /* Compile the contents of the file. Save only if compiling. */
    ASSIGN
      cXCode = DYNAMIC-FUNCTION('getAgentSetting' IN web-utilities-hdl,'Compile','','xcode') NO-ERROR.  
    IF p_checkOnly 
    THEN DO:
      IF cXCode > "" 
      THEN COMPILE VALUE( f_compfile ) XCODE cXCode NO-ERROR.
      ELSE COMPILE VALUE( f_compfile ) NO-ERROR.
    END.  
    ELSE DO:
      IF cXCode > "" 
      THEN COMPILE VALUE( f_compfile ) SAVE XCODE cXCode NO-ERROR.
      ELSE COMPILE VALUE( f_compfile ) SAVE NO-ERROR.
    END.
    
    /* Report any errors neatly. */
    IF COMPILER:ERROR 
    THEN DO:   
      /* Report errors. */
      {&OUT} '<UL>~n'.
      RUN webtools/util/_errmsgs.w (f_compfile, "COMPACT,LINE-NUMBERS":U).
      {&OUT} '</UL>~n'.
    END.
    ELSE DO:
      {&OUT} '<UL>No errors found.'.
      IF l_run-msg AND NOT l_include THEN DO:
        /* Does the file exist in PROPATH?  If must be a relative name in order
           to be run as a Web Object. */
        RUN webutil/_relname.p (INPUT p_fullpath, "must-be-rel":U, OUTPUT run-name).
        IF run-name ne ?
        THEN {&OUT}
             ' Click '
             '<A HREF="' AppURL '/' run-name '"><IMG SRC="' RootURL '/images/u-run.gif" ALT="Run" BORDER="0" ALIGN="MIDDLE"></A>~n'
             ' to run this web object.'.
      END.
      {&OUT} '</UL>'.
      /* Should we run the file anyway. */
      IF l_run THEN
        RUN webtools/util/_fileact.p (p_filename, p_fullpath, "Run":U, "no-head":U).
    END.   
    
    /* Delete the temporary e4gl file, if necessary. */
    IF l_e4gl THEN DO:
      /* Always delete if in check-syntax. Othewise look at the input option. */
      IF p_checkOnly OR l_del-e4gl 
      THEN OS-DELETE VALUE(f_compfile) . 
    END. /* IF l_e4gl... */  
  END. /* IF f_compile ne ?... */

  /* Finish the Page.(if necessary). */ 
  IF l_head THEN DO:
  {&OUT}
    '</BODY>~n'
    '</HTML>'
    .
  END.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE delete-file 
PROCEDURE delete-file :
/*------------------------------------------------------------------------------
  Purpose:     Delete the file and/or report any errors.
  Parameters:  p_filename -- name of the file
               p_fullpath -- full pathname of the file.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_filename AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER p_fullpath AS CHAR NO-UNDO.
  
  /* This is an HTML document. */
  RUN OutputContentType IN web-utilities-hdl ('text/html':U).
  
  /* Create the header for the HTML form.  */
  IF NOT CAN-DO(p_options, "no-head":U) THEN
    {&OUT}
      {webtools/html.i 
        &SEGMENTS = "head,open-body,sub-title"
        &AUTHOR = "Wm. T. Wood"
        &TITLE = "Delete Files"
        &FRAME = "WS_main"
        &CONTEXT = "File Delete" } 
   .
  
  /* Make sure the file exists, and is a Writable File (not a directory) */
  ASSIGN FILE-INFO:FILE-NAME = p_fullpath.
  IF FILE-INFO:FULL-PATHNAME eq ? THEN
    {&OUT} 'File <I>' p_filename '</I> does not exist.'.
  ELSE IF FILE-INFO:FILE-TYPE BEGINS "D":U THEN
    {&OUT} '<I>' p_filename '</I> is a directory, and cannot be deleted.'.
  ELSE IF INDEX(FILE-INFO:FILE-TYPE, "W":U) eq 0 THEN
    {&OUT} 'File <I>' p_filename '</I> cannot be deleted due to file protection privileges.'.
  ELSE DO:
    OS-DELETE VALUE(p_fullpath).
    FILE-INFO:FILE-NAME = p_fullpath.
    {&OUT} 
      format-filename (p_filename, 'Deleting &1...', '':U)
      '<UL>The file was'
      IF FILE-INFO:FULL-PATHNAME eq ? THEN ' ' ELSE ' <EM>not</EM> '
      'deleted.</UL>'.
  END.
  
  /* Finish the Page.(if necessary). */ 
  IF NOT CAN-DO(p_options, "no-head":U) THEN DO:
  {&OUT}
    '</BODY>~n'
    '</HTML>'
    .
  END.

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE e4glgen-file 
PROCEDURE e4glgen-file :
/*------------------------------------------------------------------------------
  Purpose:     Run E4gl-gen preprocessor - report any errors.
  Input Parameters:  Input 
     p_filename -- name of the file
     p_options  -- comma-delimeted list of options.
          NO-HEAD -- don't output the Content-type, and HTML head
                     (this may be set as part of the compile
                      function)
          NO-W-SAVE-MESSAGE -- Don't show message and button to allow the user to
                     regenerate the .w file later. (When their is a save message
                     the 4gl name is not displayed.)
          NO-4GL-NAME -- Don't show the temporary 4gl file name

  Output Parameters:
     p_include  -- TRUE if the generated file is an include file.
     p_newfile  -- the filename of the file created. If there is an
                   error generating the file, then this will be ?.

------------------------------------------------------------------------------*/
  DEFINE INPUT  PARAMETER p_filename AS CHAR    NO-UNDO.
  DEFINE INPUT  PARAMETER p_options  AS CHAR    NO-UNDO.
  DEFINE OUTPUT PARAMETER p_include  AS LOGICAL NO-UNDO.
  DEFINE OUTPUT PARAMETER p_newfile  AS CHAR    NO-UNDO.

  DEFINE VARIABLE gen-options    AS CHAR NO-UNDO.
  DEFINE VARIABLE f_type         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE f_list         AS CHARACTER NO-UNDO.
  DEFINE VARIABLE i              AS INTEGER NO-UNDO.
  DEFINE VARIABLE l_error        AS LOGICAL NO-UNDO.
  DEFINE VARIABLE l_head         AS LOGICAL NO-UNDO.
  DEFINE VARIABLE l_4gl-name     AS LOGICAL NO-UNDO.
  DEFINE VARIABLE l_save-message  AS LOGICAL NO-UNDO.

  /* Is the HTTP/HTML header information necessary. */
  ASSIGN l_head         = LOOKUP("no-head":U, p_options) eq 0
         l_save-message = LOOKUP("no-w-save-message":U, p_options) eq 0 
         l_4gl-name     = IF l_save-message THEN no ELSE LOOKUP("no-4gl-name":U, p_options) eq 0
         .
  IF l_head THEN DO:
    /* This is an HTML document. */
    RUN OutputContentType IN web-utilities-hdl ('text/html':U).
  
    /* Create the header for the HTML form.  */
    {&OUT}
       {webtools/html.i 
        &SEGMENTS = "head,open-body,sub-title"
       &AUTHOR = "Wm. T. Wood"
       &TITLE  = "SpeedScript File Generation"
       &FRAME = "WS_main"
           &CONTEXT = "File Compile" } 
         .

  END. /* IF l_head... */

  {&OUT}
     format-filename (p_filename, 'Generating SpeedScript file for &1...', '':U)
     '<BR><BR>~n'.
   RUN webtools/util/_filetyp.p (INPUT p_fullpath, 
                 OUTPUT f_type, 
                             OUTPUT f_list).
   IF (LOOKUP("MAPPED":U, f_list) > 0) AND (f_type eq "HTML") THEN DO:
    {&OUT}
           '<UL>' format-filename (p_filename, 'Cancelling SpeedScript generation for &1.', '':U) 
           '<BR>~n' 
           'The intermediate SpeedScript file was not generated because a~n'
           '<B>.p, .w,</B> or <B>.off</B> file already exists.~n'
           'Processing this file would cause one of these files to be overwritten.~n'
           'To successfully generate the intermediate SpeedScript for file, delete any offset (.off)~n'
           'files or web objects (.p or .w) and reissue the compile for this HTML file. </UL>~n'. 
      p_newfile = ?. 
    RETURN.
  END.
  RUN reset-return-value. /* Blank out the return value. */
  RUN webutil/e4gl-gen.p 
          ( INPUT p_fullpath, 
            INPUT-OUTPUT gen-options, 
            INPUT-OUTPUT p_newfile ) NO-ERROR. 
  /* Save the error status, and check to see if the file is an include file. */
  ASSIGN l_error = ERROR-STATUS:ERROR
         p_include =  LOOKUP('include':U, gen-options) > 0.

  /* Error occured generation file. */
  IF l_error THEN DO:
    p_newfile = ?.
    /* Report the errors. */
    IF RETURN-VALUE eq "":U 
    THEN {&OUT} '<UL>There was an error trying to run the preprocessor.</UL>~n'.
    ELSE DO:
      {&OUT} '<UL>The following errors were generated while processing the file:<UL>~n'.
      DO i=1 TO NUM-ENTRIES(RETURN-VALUE):
        {&OUT} '<LI>' ENTRY(i, RETURN-VALUE) '</LI>~n'.     
      END.
      {&OUT} '</UL></UL>~n'.
    END. /* IF RETURN-VALUE [ne] "". */
  END.
  ELSE DO:
    /* Success! */
    {&OUT}
      '<UL>SpeedScript file generated'
      IF l_4gl-name THEN ' <I>(' + p_newfile + ')</I>.' ELSE '.':U
      .
    /* Allow option to regenerate the E4GL file later (but not .i files). */
    IF l_save-message AND NOT p_include THEN 
     {&OUT} 
       ' Click ' 
       '<A HREF="' AppURL '/webtools/fileact.w?action=GenerateE4GL&filename='
                   url-encode(p_fullpath, "QUERY":U) 
       '"><IMG SRC="' RootURL '/images/u-save.gif" '
              'ALT="Save Generated File" BORDER="0" ALIGN="MIDDLE"></A>~n'
      ' to save this temporary file.~n'.
    /* Finish the block. */
    {&OUT} '</UL>~n'. 
  END.
   
  /* Finish the HTML page, if necessary. */
  IF l_head THEN {&OUT} '</BODY>~n</HTML>~n'.
 
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE reset-return-value 
PROCEDURE reset-return-value :
/*------------------------------------------------------------------------------
  Purpose:     If we need to be sure that the value of RETURN-VALUE is blank,
               then call this procedure, which will return "". In this way
               a second file can be called, and we can check for RETRUN-VALUE
               after that file.
------------------------------------------------------------------------------*/
  RETURN "":U.
END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE run-file 
PROCEDURE run-file :
/*------------------------------------------------------------------------------
  Purpose:     Run a WebSpeed file, using the AppURL reference on the
               file so that we guarantee that the file can reset the
               BASE HREF used by the browser (in particular, we don't
               want the browser to think that the file is being run from
               the "webtools" directory. 
  Parameters:  p_filename -- name of the file
               p_fullpath -- full pathname of the file.
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_filename AS CHAR NO-UNDO.
  DEFINE INPUT PARAMETER p_fullpath AS CHAR NO-UNDO.

  DEFINE VARIABLE c_relname   AS CHAR NO-UNDO.
  DEFINE VARIABLE c_type      AS CHAR NO-UNDO.
  DEFINE VARIABLE c_list      AS CHAR NO-UNDO.
  DEFINE VARIABLE rcodepath   AS CHAR NO-UNDO.
  DEFINE VARIABLE search-file AS CHAR NO-UNDO.
  DEFINE VARIABLE goto-file   AS CHAR NO-UNDO. 
   
  /* This is an HTML document. */
  RUN OutputContentType IN web-utilities-hdl ('text/html':U).
  
  /* Create the header for the HTML that resets the BASE HREF to
     the AppURL  */
  IF NOT CAN-DO(p_options, "no-head") THEN DO:
    {&OUT}
        {webtools/html.i 
	   &SEGMENTS = "head,open-body,sub-title"
	   &AUTHOR = "Wm. T. Wood"
	   &TITLE = "File Run"
	   &FRAME = "WS_main" } .
  END.
  
    RUN webtools/util/_filetyp.p (p_fullpath, OUTPUT c_type, OUTPUT c_typelist).
    IF (c_type eq "HTML") THEN DO:
	/* We can assume file has an extension since we have "HTML" as type */
	rcodepath = SUBSTRING(p_fullpath, 1, R-INDEX(p_fullpath, ".")) + "r".
        RUN adecomm/_rsearch.p (INPUT rcodepath, OUTPUT search-file).
	IF search-file eq ? THEN DO:
	  {&OUT}
            format-filename (p_filename, 'Error running &1...', '':U)
            '<UL> ~n' 
	    'R-Code does not exist. '
            IF LOOKUP("MAPPED":U, c_typelist) > 0
            THEN 'This is a mapped HTML file.' +
                 ' It cannot be run until the associated web object (.w) has been compiled. ~n'
            ELSE 'Source file must be compiled. ~n'
            '</UL>~n'.
	  RETURN.
        END.
     END.

  /* Send a temporary message to the user. The message is followed
     by JavaScript that runs the file, or reports an error if the
     file can't be found relative to the application URL. */
  {&OUT} 
    format-filename (p_filename, 'Running &1...', '':U)
    '<UL>~n'
    .
  /* Does the file exist in PROPATH?  If must be a relative name in order
     to be run as a Web Object. */
  RUN webutil/_relname.p (p_fullpath, "must-be-rel":U, OUTPUT c_relname).
  IF c_relname eq ? 
  THEN
    {&OUT} 
      'Run cancelled.<BR>~n'
      'The file is not accessible from the application script~n'
      '(<I>' HostURL AppURL '/<I>).~n'
      .
  ELSE DO:
    /* Add JavaScript to run the file. The JavaScript command to run the file
       is browser specific. Navigation is a "Mozilla", not " MSIE " agent. */
    goto-file = AppURL + "/":U + c_relname + "?WorkshopRunId=":U + STRING(INTEGER(TIME)).
    IF HTTP_USER_AGENT BEGINS "Mozilla":U AND INDEX(HTTP_USER_AGENT, " MSIE ":U) eq 0 
    THEN goto-file = SUBSTITUTE ('window.location.replace("&1")~;':U, goto-file).
    ELSE goto-file = SUBSTITUTE ('window.location.href = "&1"~;':U,   goto-file).
    
    {&OUT} 
      '<!--~n' 
      '  -- This page is used to reset the BASE HREF used by the browser~n'
      '  -- so that the WebSpeed Transaction Agent receives a valid URL~n'
      '  -- from the browser. ~n'
      '  -->~n'
      '<INPUT TYPE="HIDDEN" NAME="runFile" VALUE="' html-encode(AppURL + "/":U + c_relname) '">~n'
      '<SCRIPT LANGUAGE="JavaScript">~n'
      '  <!--~/~/Load the application file that is to be run (after a slight delay).~n'
      '  function runFile () ~{ ~n' 
      '    ' goto-file
      '  }~n'
      '  setTimeout("runFile()",1500)~;~n'
      '  ~/~/--> ~n'
      '</SCRIPT> ~n'
      .
  END.
  
  /* Finish the Page. Add the code to actually run the file. */ 
  {&OUT}
    '</BODY>~n'
    '</HTML>~n'
    .

END PROCEDURE.
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE tag-extract 
PROCEDURE tag-extract :
/*------------------------------------------------------------------------------
  Purpose:     Extract HTML field offsets.
  Parameters:  
               
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_htmlfile AS CHARACTER NO-UNDO.
  
  DEFINE VARIABLE cExt   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE l_head AS LOGICAL   NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE l_html AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE scrap  AS CHARACTER NO-UNDO.

  IF LOOKUP("no-head":U, p_options) > 0 THEN 
    l_head = no.

  RUN OutputContentType IN web-utilities-hdl ('text/html':U).
  
  /* Create the header for the HTML form. */
  IF l_head THEN
    {&OUT}
      {webtools/html.i 
	    &SEGMENTS = "head,open-body,sub-title"
	    &AUTHOR = "D.M.Adams"
	    &TITLE = "TagExtract"
	    &FRAME = "WS_main" }
      .

  {&OUT} 
    format-filename (p_htmlfile, 'Extracting HTML field offsets for &1...', '':U) SKIP.
  
  RUN adecomm/_osfext.p (p_htmlfile, OUTPUT cExt).
  IF cExt eq ".htm":U OR cExt eq ".html":U THEN DO:
    l_html = TRUE.
    RUN webutil/_genoff.p (p_htmlfile, OUTPUT scrap).
  END.
  ELSE
    scrap = ?.

  {&OUT}  
    '<UL>Extraction was' (IF (scrap eq ? OR scrap = "") THEN ' <EM>not</EM>' ELSE '') ' successful.'
    (IF l_html THEN '' ELSE ' File is <EM>not</EM> HTML.') '</UL>~n'.
    
  /* Finish the Page.(if necessary). */ 
  IF NOT CAN-DO(p_options, "no-head":U) THEN
    {&OUT}
      '</BODY>~n'
      '</HTML>'
      .
END PROCEDURE.
&ANALYZE-RESUME
 


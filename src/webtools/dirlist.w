&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r12 WebTool
/* Maps: HTML */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM Definitions 
/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------
  File: dirlist.w
  
  Description: List the files in a particular directory.
               If no directory is specified then use the current directory.
  Parameters:  <none>
  
  Fields: This checks for the following CGI fields:
  
    directory: The directory to search. This can be relative to PROPATH.
               The default is ".".
    filter: the file filter to use in searching
    
  Author:  Wm. T. Wood
  Created: Oct 23, 1996

  Modifications:  
   01/08/97 nhorn Cleaned up HTML, add style, consistency changes.
   01/15/97 nhorn Multiple file selection
   04/20/97 wood  Use "*" as the "All File" filter on NT               
   04/05/01 thm   Integrated WCIAT utilities
   07/11/01 adams Rework page layout
------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Included Files ---                                                   */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE WebTool


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

/* Standard WebTool Included Libraries --  */
{ webtools/webtool.i }
&ANALYZE-RESUME _END-INCLUDED-LIBRARIES

&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 

/* ************************  Main Code Block  *********************** */

/* Process the latest WEB event. */
RUN process-web-request.
&ANALYZE-RESUME
/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE process-web-request 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE directory     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dirpath       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE filter        AS CHARACTER NO-UNDO.
  DEFINE VARIABLE select-list   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dft-filters   AS CHARACTER NO-UNDO
    INITIAL "*.w~;*.p~;*.i,*.htm*,*.w~;*.p~;*.i~;*.htm*,*":U.
  DEFINE VARIABLE workshop-file AS CHARACTER NO-UNDO
    INITIAL "workshop/_main.*":U.
  DEFINE VARIABLE ipos          AS INTEGER   NO-UNDO.
  DEFINE VARIABLE icount        AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ix            AS INTEGER   NO-UNDO.
  DEFINE VARIABLE filter-num    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE slash-os      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE slash-nos     AS CHARACTER NO-UNDO.

  /* Output the MIME header. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).  
  
  /* What is the context of this request?  Look at "filter". */
  RUN GetField IN web-utilities-hdl ('filter':U, OUTPUT filter).
  IF filter eq "":U THEN filter = ENTRY(3,dft-filters). /* All sources: *.w;*.p;*.htm* */
  RUN GetField IN web-utilities-hdl ('directory':U, OUTPUT directory).
  IF directory eq "":U THEN directory = ".":U.
  
  /* If the filter contains a directory name, add it to the directory. */
  ASSIGN 
    slash-os  = (IF OPSYS = "UNIX":U THEN "~/":U ELSE "~\":U)
    slash-nos = (IF OPSYS = "UNIX":U THEN "~\":U ELSE "~/":U)
    filter    = REPLACE(filter, slash-nos, slash-os) 
    ipos      = R-INDEX(filter, slash-os).
    
  IF ipos > 0 THEN DO:
    /* If the filter starts with '/' then go to the root directory. */
    IF SUBSTRING(filter, 1, 1, "CHARACTER":U) eq slash-os THEN directory = slash-os.
    /* Add the directory part of the filter to the directory. */
    directory = (IF directory ne ".":U THEN
                  (RIGHT-TRIM (directory, slash-os)  + slash-os)
                 ELSE '':U)
              + TRIM( SUBSTRING(filter, 1, ipos, "CHARACTER":U), slash-os).
    /* Remove the directory from the filter. */
    IF LENGTH(filter, "CHARACTER":U) eq ipos THEN filter = "".
    ELSE filter = SUBSTRING (filter, ipos + 1, -1, "CHARACTER":U).
  END.
  
  /* Get the full directory path. */
  ASSIGN 
    FILE-INFO:FILE-NAME = directory 
    dirpath             = FILE-INFO:FULL-PATHNAME.
  
  /* Output page header */
  {&OUT}
    {webtools/html.i 
      &SEGMENTS  = "head,open-body,title-line"
      &AUTHOR    = "Wm.T.Wood"
      &TITLE     = "File Tools"
      &TITLESPAN = TRUE
      &FRAME     = "WS_main"
      &CONTEXT   = "{&Webtools_Web_Objects_Help}" }.

  {&OUT}
    '~n<CENTER>~n':U
    '<SCRIPT LANGUAGE="JavaScript">~n':U
    '<!--~n':U
    'function setFilter (index, target, opt) ~{ ~n':U
    '  var filters = new Array ("*.w~;*.p~;*.i", "*.htm*", "*.w~;*.p~;*.i~;*.htm*","*");~n':U
    '  if (index > 3) ~n':U
    '    target.value = opt.text; ~n':U
    '  else ~n':U
    '    target.value = filters[index];~n':U
    '~}~n':U
    '//-->~n':U
    '</SCRIPT>~n':U.

  /* Output toolbar */
  {&OUT}
    '<TABLE ID="tToolBar" BORDER="1" BGCOLOR="#DEB887" /*burlywood*/ CELLPADDING="1" WIDTH="100%">~n':U
    '<TR><TD><NOBR>~n':U
    '<A HREF="Javascript:if (window.SubmitForm) SubmitForm(~'View~')~;"~n':U
    '   onMouseOver="window.status=~'':U 'View source code for the selected file' '~'~; return true~;"~n':U
    '   onMouseOut="window.status=~'~'~; return true~;">':U /* No ~n */
    '<IMG SRC="' RootURL '/images/u-view-n.gif" ALT="':U 'View' '" BORDER="0"></A>&nbsp~;~n':U
    '<A HREF="Javascript:if (window.SubmitForm) SubmitForm(~'Run~')~;"~n':U 
    '   onMouseOver="window.status=~'':U 'Run the selected file, if possible' '~'~; return true~;"~n':U
    '   onMouseOut="window.status=~'~'~; return true~;">':U /* No ~n */
    '<IMG SRC="' RootURL '/images/u-run-n.gif" ALT="':U 'Run' '" BORDER="0"></A>&nbsp~;~n':U
    '<A HREF="Javascript:if (window.SubmitForm) SubmitForm(~'Compile~')~;"~n':U
    '   onMouseOver="window.status=~'':U 'Compile selected files' '~'~; return true~;"~n':U
    '   onMouseOut="window.status=~'~'~; return true~;">':U /* No ~n */
    '<IMG SRC="' RootURL '/images/u-compil-n.gif" ALT="':U 'Compile' '" BORDER="0"></A>&nbsp~;~n':U 
    '<A HREF="Javascript:if (window.SubmitForm) SubmitForm(~'TagExtract~')~;"~n':U
    '   onMouseOver="window.status=~'':U 'Create .off files for selected HTML files' '~'~; return true~;"~n':U
    '   onMouseOut="window.status=~'~'~; return true~;">':U /* No ~n */
    '<IMG SRC="' RootURL '/images/u-tagext-n.gif" ALT="':U 'Extract offset file' '" BORDER="0"></A>&nbsp~;~n':U
    '<A HREF="Javascript:if (window.SubmitForm) SubmitForm(~'Delete~')~;"~n':U
    '   onMouseOver="window.status=~'':U 'Delete selected files' '~'~; return true~;"~n':U
    '   onMouseOut="window.status=~'~'~; return true~;">':U /* No ~n */
    '<IMG SRC="' RootURL '/images/u-delete-n.gif" ALT="':U 'Delete' '" BORDER="0"></A>&nbsp~;~n':U
    '</NOBR></TD>~n':U
    '</TR>~n':U
    '</TABLE>~n':U.

  /* Output a table containing the contents of the directory, and buttons
     to act on these files. */
  IF dirpath eq ? THEN
    {&OUT} '<HR>Directory "' directory '" was not found.'.
  ELSE DO:
    /* Output a list of directories. */ 
    {&OUT}
      '<BR>~n':U
      '<TABLE':U get-table-phrase('') ' CELLPADDING="4" WIDTH="100%">~n':U
      '<TR>~n':U
      '  <TH>':U format-label('Directories':U, "COLUMN":U, "":U) '</TH>~n':U
      '  <TH>':U format-label('Files':U, "COLUMN":U, "":U) '</TH>~n':U
      '  <TH>':U format-label('Filters':U, "COLUMN":U, "":U) '</TH>~n':U
      '</TR>~n':U
      '<TR VALIGN="TOP"><TD>~n':U
      .
    
    /* See if there is a Parent Directory. */
    FILE-INFO:FILE-NAME = directory + slash-os + '..':U.  
    IF FILE-INFO:FULL-PATHNAME ne ? AND FILE-INFO:FILE-TYPE BEGINS "D":U THEN
      {&OUT} 
        '<A HREF="dirlist.w?':U url-field ("directory":U, FILE-INFO:FULL-PATHNAME, "":U) 
                                url-field ("filter", filter, "&":U) + '">':U
        '<IMG SRC="' RootURL '/images/uplevel.gif" BORDER=0 WIDTH=15 HEIGHT=12> Parent directory</A><BR>~n':U.
             
    /* Output a list of directories in the first column.  ('' filter matches all) */
    RUN webtools/util/_dirlist.w
      (directory, '':U, true,
       '<A HREF="dirlist.w?directory=&5&4~&~&' + url-field ("filter", filter, "":U) + '">':U +
       '<IMG SRC="' + RootURL + '/images/folder.gif" BORDER=0 WIDTH=15 HEIGHT=12> &1</A><BR>~n':U,
       '',           /* non-empty leader */
       '',           /* non-empty trailer */
       '',           /* "empty" string. */
       '':U,         /* Not a table, */
       'no-dot':U,   /* Don't show '.' or '..'  */
       OUTPUT icount).
   
    /* Output the files in the directory (in column 2). NOTE that this cell contains 
       the FORM for input.  This FORM can NOT be around the next cell with the links.  
       If it is, then the onMouseOver events will not work in IE3. */ 
    {&OUT} '</TD>~n<TD ALIGN="center">~n':U
      '<FORM NAME="FileList" METHOD="POST" ACTION="fileact.w"> ~n':U
      '<SCRIPT LANGUAGE="JavaScript">~n':U
      '  <!--// Submit the form. ~n':U
      '  function SubmitForm (todo) ~{~n':U
      '    var f = document.FileList~;~n':U
      '    // Is a file selected?~n':U
      '    if ((f.Filename == null) || f.Filename.selectedIndex == -1) ~n':U
      '       window.alert(~'':U 'Please select a file.' '~')~; ~n':U
      '    // Confirm deletion?~n':U
      '    else if (todo != "Delete" || window.confirm("':U 'Are you sure you want to delete the selected files?' '")) ~{~n':U
      '      f.FileAction.value = todo~;~n':U
      '      f.submit()~;~n':U
      '    }~n':U
      '  }~n':U
      '  // End of Script -->~n':U
      '</SCRIPT>~n':U
      '<INPUT TYPE="HIDDEN" NAME="Directory" VALUE="' dirpath '">~n':U
      '<INPUT TYPE="HIDDEN" NAME="FileAction" VALUE="">~n':U
      . 

    /* Output a filelist */
    RUN webtools/util/_dirlist.w
      (directory, filter, false,
       '<OPTION>&1</OPTION>~n':U,
       '<SELECT NAME="Filename" SIZE="15" MULTIPLE>~n':U,
       '</SELECT>~n':U,
       '<I>No matching files</I>~n',    
       '':U,         /* Not a Table */
       '':U,         /* No Options  */
       OUTPUT icount).
 
    /* Output Filters objects */
    {&OUT} 
      '</FORM></TD>~n':U
      '<TD ALIGN="left">~n':U
      '<FORM METHOD="POST" ACTION="dirlist.w">~n':U
      format-label ('File', 'TOP':U, '') '<BR>~n':U
      '<INPUT TYPE="TEXT" NAME="filter" SIZE="20" VALUE="':U html-encode(Filter) '">~n':U
      '<INPUT TYPE="HIDDEN" NAME="directory" VALUE="':U html-encode(directory) '">~n':U
      '<INPUT TYPE="SUBMIT" VALUE="List" NAME="ListF" ><BR><BR>~n':U
      format-label ('Files of Type', 'TOP':U, '') '<BR>~n':U
      '<SELECT NAME="FilterType" SIZE="1"~n':U
      '     onChange = "setFilter(this.selectedIndex, form.filter, this.options[this.selectedIndex]);form.ListF.click();"> ~n':U.

    ASSIGN select-list = "Webspeed Files (*.w~;*.p~;*.i),Html Files (*.htm*),All Sources (*.w~;*.p~;*.i~;*.htm*),All Files (*)".
    IF LOOKUP(filter, dft-filters) = 0 THEN  
      ASSIGN select-list = select-list + ",":U + filter.

    DO ix = 1 to NUM-ENTRIES(select-list):
      {&OUT} '<OPTION':U
        (IF (ix eq LOOKUP(filter, select-list)) OR (ix eq LOOKUP(filter, dft-filters)) THEN ' SELECTED>':U ELSE ' > ':U)
        html-encode(ENTRY(ix,select-list))
        '</OPTION>~n':U.
    END.
    {&OUT}
      '</SELECT>~n':U
      '</FORM>~n':U
      '</TD>~n':U
      '</TR></TABLE>~n':U.

  END. /* IF dirpath ne ? ... */
    
  /* Finish out the HTML document. */      
  {&OUT} 
    '</CENTER>~n':U
    '</BODY>~n':U
    '</HTML>~n':U.
  
END PROCEDURE.
&ANALYZE-RESUME
 


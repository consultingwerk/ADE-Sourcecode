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
  File: _dirlist.w
  
  Description: List the files in a particular directory.
               If no directory is specified then use the current directory.
  Parameters:  <none>
  
  Fields: This checks for the following CGI fields:
  
    directory: The directory to search. This can be relative to PROPATH.
               The default is ".".
    filter: the file filter to use in searching
    
  Author:  Wm. T. Wood
  Created: Oct 23, 1996

  Modifications:  Cleaned up HTML, add style, consistency  nhorn 1/8/97
		  changes.
		  Multiple file selection                  nhorn 1/15/97

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/


/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Web-Object


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */


/* ************************  Frame Definitions  *********************** */

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Web-Object
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

{ webutil/wstyle.i }  /* Standard style definitions. */
{webtools/help.i}
{src/web/method/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 


/* ************************  Main Code Block  *********************** */

/* Process the latest WEB event. */
RUN process-web-request.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE process-web-request Procedure 
PROCEDURE process-web-request :
/*------------------------------------------------------------------------------
  Purpose:     Process the web request.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE VARIABLE directory    AS CHAR    NO-UNDO.
  DEFINE VARIABLE dirpath      AS CHAR    NO-UNDO.
  DEFINE VARIABLE filter       AS CHAR    NO-UNDO.
  DEFINE VARIABLE select-list  AS CHAR    NO-UNDO.
  DEFINE VARIABLE dft-filters  AS CHAR    INITIAL "*.w~;*.p~;*.i,*.htm~;*.html,*.w~;*.p~;*.i~;*.htm~;*.html,*.*".
  DEFINE VARIABLE workshop-file AS CHAR   INITIAL "workshop/_main.*".
  DEFINE VARIABLE search-file  AS CHAR    NO-UNDO.
  DEFINE VARIABLE ipos         AS INTEGER NO-UNDO.
  DEFINE VARIABLE icount       AS INTEGER NO-UNDO.
  DEFINE VARIABLE i            AS INTEGER NO-UNDO.
  DEFINE VARIABLE filter-num   AS INTEGER NO-UNDO.
  DEFINE VARIABLE subdir       AS CHAR NO-UNDO.

  /* If OPSYS is unix, change the value of the default filters */
  IF OPSYS = "unix" THEN
    ASSIGN dft-filters = "*.w~;*.p~;*.i,*.htm~;*.html,*.w~;*.p~;*.i~;*.htm~;*.html,*".

  /* Output the MIME header. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).  
  
  /* What is the context of this request?  Look at "filter". */
  RUN GetField IN web-utilities-hdl ('filter', OUTPUT filter).
  IF filter eq "":U THEN filter = "*.w~;*.p~;*.i".
  RUN GetField IN web-utilities-hdl ('directory', OUTPUT directory).
  IF directory eq "":U THEN directory = ".":U.
  
  /* If the filter contains a directory name, add it to the directory. */
  ASSIGN filter = REPLACE (filter, '~\':U, '~/':U) 
         ipos = R-INDEX (filter, '~/':U).
  IF ipos > 0 THEN DO:
    /* If the filter starts with '/' then go to the root directory. */
    IF SUBSTRING( filter, 1, 1, "CHARACTER":U) eq '~/' THEN directory = '~/':U.
    /* Add the directory part of the filter to the directory. */
    directory = (IF directory ne "."
                 THEN (RIGHT-TRIM (directory, '~/':U)  + '~/':U )
                 ELSE '':U)
              + TRIM( SUBSTRING(filter, 1, ipos, "CHARACTER":U), '~/':U).
    /* Remove the directory from the filter. */
    IF LENGTH(filter, "CHARACTER":U) eq ipos THEN filter = "".
    ELSE filter = SUBSTRING (filter, ipos + 1, -1, "CHARACTER":U).
  END.
  
  /* Get the full directory path. */
  ASSIGN FILE-INFO:FILE-NAME = directory 
         dirpath = FILE-INFO:FULL-PATHNAME
         FILE-INFO:FILE-NAME = "."
         subdir = FILE-INFO:FULL-PATHNAME + "/".

  IF dirpath NE subdir AND INDEX(dirpath,subdir) = 1 THEN
    subdir = SUBSTRING(dirpath,LENGTH(subdir) + 1,100) + "/".
  ELSE
    subdir = "".
           
  {&OUT}
    {webtools/html.i 
	    &SEGMENTS = "head,open-body,title-line"
	    &AUTHOR  = "Wm.T.Wood"
	    &TITLE    = "Web Objects"
	    &FRAME    = "WS_main"
	    &CONTEXT  = "{&Webtools_Web_Objects_Help}" }
    .
 
  {&OUT}
    '<script language="javascript"> ~n'
    '  var ParentHistory = parent.opener.history.length~; ~n'
    '</script> ~n'
    .

  {&OUT}
    '<CENTER>~n'
    '<FORM METHOD = "POST" ACTION="_dirlist.r">~n'	 
    '<SCRIPT LANGUAGE="JavaScript">~n'
    '<!--~n'
    'function setFilter (index, target, opt) ~{ ~n'
    '  var filters = ' 
    (IF (OPSYS = "unix") THEN 'new Array ("*.w~;*.p~;*.i", "*.htm~;*.html", "*.w~;*.p~;*.i~;*.htm~;*.html","*");~n' ELSE 'new Array("*.w~;*.p~;*.i", "*.htm~;*.html", "*.w~;*.p~;*.i~;*.htm~;*.html","*.*");~n' )
    '  if (index > 3) ~n'
    '      target.value = opt.text; ~n'
    '  else ~n'
    '      target.value = filters[index];~n'
    ' }~n'
    '//-->~n'
    '</SCRIPT>~n'
    '<TABLE BORDER=0 CELLPADDING="0" CELLSPACING="1">~n'
    '<TR><TD><B>File Filter: </B></TD>~n'
    '<TD><INPUT TYPE = "TEXT" NAME = "filter" SIZE = "30" VALUE = "' html-encode(Filter) '"></TD>~n'
    '<TD><INPUT TYPE = "HIDDEN" NAME = "directory" VALUE = "' html-encode(directory) '">~n'
    '<INPUT TYPE="SUBMIT" VALUE="List Files" NAME="ListF" ></TD></TR>~n'
    '<TR><TD><B>Filter Options: </B></TD>~n'
    '<TD><SELECT NAME = FilterType SIZE = 1~n'
    '     onChange = "setFilter(this.selectedIndex, form.filter, this.options[this.selectedIndex]);form.ListF.click();"> ~n'.
    IF OPSYS = "unix" THEN 
        ASSIGN select-list = "Webspeed Files (*.w~;*.p~;*.i),Html Files(*.htm~;*.html),All Sources (*.w~;*.p~;*.i~;*.htm~;*.html),All Files(*)".
    ELSE 
        ASSIGN select-list = "Webspeed Files (*.w~;*.p~;*.i),Html Files(*.htm~;*.html),All Sources (*.w~;*.p~;*.i~;*.htm~;*.html),All Files(*.*)".

    IF LOOKUP(filter, dft-filters) = 0 THEN  
       ASSIGN select-list = select-list + "," + filter.

  DO i = 1 to NUM-ENTRIES(select-list):
    {&OUT} '<OPTION'
      (IF (i eq LOOKUP(filter, select-list)) OR (i eq LOOKUP(filter, dft-filters)) THEN ' SELECTED>' ELSE ' > ')
      html-encode(ENTRY(i,select-list))
      '~n'.
  END.
  {&OUT}
    '</SELECT></TD></TR>~n'
    '</TABLE>~n'
    '</FORM>~n'
    .
  
  /* Output a form containing the contents of the directory, and buttons
     to act on these files. */
  IF dirpath eq ?
  THEN {&OUT} '<HR>Directory "' directory '" was not found.'.
  ELSE DO:
    /* Output a list of directories. */ 
    {&OUT}
      '<FORM NAME="FileList">~n'
      '<SCRIPT LANGUAGE="JavaScript">~n'
      '  function ParentWindow() ~{ ~n'
      '    if (parent.opener.closed || ParentHistory != parent.opener.history.length) ~{ ~n'
      '      window.alert(~'Parent window is no longer available.  Closing Web Objects window.~')~; ~n'
      '      window.close()~; ~n'
      '    ~} ~n'
      '    else ~n'
      '      if ((document.FileList.Filename == null) || '
      '           document.FileList.Filename.selectedIndex == -1) ~{ ~n'
      '        window.alert(~'Please select a file.~')~; ~n'
      '      ~} ~n' 
      '      else ~{~n' 
      '        if (document.FileList.Filename.options[document.FileList.Filename.selectedIndex] == null)~n'
      '          window.alert("Cannot update HyperLinked Web Object field.  Manually enter file name.")~;~n'
      '        else~n'
      '          parent.opener.document.forms[0].LinkedWebObject.value = document.FileList.Filename.options[document.FileList.Filename.selectedIndex].text~; ~n'
      '      ~}~n'
      '  ~} ~n' 
      '</SCRIPT>~n'
      '<TABLE BORDER = "2" CELLPADDING="4">~n'
      '<TR><TH>Directories</TH>~n'
      '    <TH COLSPAN="2">Files in <B> '.
      IF directory eq "." THEN 
        {&OUT} '<FONT COLOR="RED">Web</FONT>Speed Agent Startup Directory ~n'.
      ELSE 
        {&OUT} '<FONT COLOR="OLIVE"> ' directory ' </FONT></B>~n'.
   {&OUT} 
      ' </TH></TR>~n'
      '<TR><TD VALIGN="TOP">~n'     
      .
      
    /* Output a list of directories in the first column.  ('' filter matches all) */
    RUN webtools/util/_dirlist.w
           (directory, '':U, true,
            '<A HREF="_dirlist.w?directory=&5&4~&~&' + url-field ("filter", filter, "":U) + '">' +
            '<IMG SRC="/webspeed/images/folder.gif" BORDER="0"> &1</A><BR>~n',
            '',           /* non-empty leader */
            '',           /* non-empty trailer */
            '',           /* "empty" string. */
            '':U,         /* Not a table, */
            'no-dot':U,   /* Don't show '.' or '..'  */
            OUTPUT icount).
   
    /* Output the files in the directory (in column 2). */ 
    {&OUT} '</TD>~n<TD>'.
    RUN webtools/util/_dirlist.r
           (directory, filter, false,
            '<OPTION>' + html-encode(subdir) + '&1~n',
            '<SELECT NAME="Filename" SIZE="15">~n',
            '</SELECT>~n',
            '<I>No matching files</I>~n',    
            '':U,  /* Not a Table */
            '':U,         /* No Options  */
            OUTPUT icount).
 
    /* Finish out the last column of the table.
       Pad some of the button labels with spaces to help align them. */    
    {&OUT}
      '</TD><TD ALIGN="CENTER">~n'     
      '<INPUT TYPE="BUTTON" NAME="LinkFile" VALUE="Link" BORDER="0" ~n'
      ' onClick="ParentWindow()"><BR><BR> ~n'
      .

    {&OUT}
      '<INPUT TYPE="BUTTON" NAME="CloseWindow" VALUE="Close" BORDER="0"~n'
      'onClick="window.close()"><BR><BR> ~n'
      .

    {&OUT} '</TD></TR></TABLE>~n'
      '<INPUT TYPE="HIDDEN" NAME="Directory" VALUE="' dirpath '">~n'    
      '</FORM>~n'
      .
    END. /* IF dirpath ne ? ... */

  /* Finish out the HTML document. */      
   {&OUT} 
    '</CENTER>~n'
    '</BODY>~n'
    '</HTML>~n'
     .
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



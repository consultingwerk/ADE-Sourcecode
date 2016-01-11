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

  File: _project.w

  Description: File Manager control.  Generates directory/file structure 
               as an HTML table.

  Input Parameters:
    <none>

  Output Parameters:
    <none>

  Author: D.M.Adams

  Created: December 1996

  Modifications:  Multiple filter support           adams   4/24/97
                  Two frame layout                  adams   4/17/97
                  Redraw bug fixes                  adams   3/8/97
                  Moved [New File], Filter to top   adams   2/14/97
                  Color/Style/Font Consistency      nhorn   1/21/97

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Included Definitions ---                                             */
{ workshop/dirnode.i }        /* Shared temp-table for project nodes.   */
{ workshop/errors.i }
{ webutil/wstyle.i }          /* Shared style definitions & functions.  */

/* Local Variable Definitions ---                                       */

&ANALYZE-RESUME
&ANALYZE-SUSPEND _PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&SCOPED-DEFINE PROCEDURE-TYPE Procedure
&SCOPED-DEFINE debug false

&if {&debug} &then
define stream debug.
output stream debug to aa-project.log.
&endif

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

/* ********************** Function Definitions ************************ */

/*----------------------------------------------------------------------------
  Purpose:     Given a directory pathname, it returns the pathname with <WBR> 
               for Netscape Navigator and spaces for Internet Explorer 
               inserted before each "/".
  Parameters:  p_phrase:   The text to use around the hilit text. Within this
                           text, &1 is where p_highlite will go.
  For Example:
    word-break (directory) where directory = "/usr1/apache/foo"
  Returns:
    "<WBR>/usr1<WBR>/apache<WBR>/foo" on Netscape Navigator and
    " /usr1 /apache /foo"             on Internet Explorer
------------------------------------------------------------------------------*/
FUNCTION word-break RETURNS CHARACTER (p_phrase AS CHARACTER,
                                       p_slash  AS CHARACTER):
  RETURN REPLACE(p_phrase,p_slash,
    (IF INDEX(HTTP_USER_AGENT,"MSIE":U) > 0 THEN " ":U 
     ELSE "<WBR>":U) + p_slash).

END FUNCTION.

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
  DEFINE VARIABLE bad-dir      AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE c-recid      AS CHARACTER NO-UNDO. /* parent char. RECID */
  DEFINE VARIABLE file-filters AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE directory    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE errmsg       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE file-name    AS CHARACTER NO-UNDO. /* file name */
  DEFINE VARIABLE file-path    AS CHARACTER NO-UNDO. /* file path */
  DEFINE VARIABLE filter       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE html         AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE location     AS CHARACTER NO-UNDO. 
  DEFINE VARIABLE ix           AS INTEGER   NO-UNDO.
  DEFINE VARIABLE r-pos        AS INTEGER   NO-UNDO. /* position of slash */
  DEFINE VARIABLE is-root      AS LOGICAL   NO-UNDO. /* parent is root dir */
  DEFINE VARIABLE node-recid   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE p-level      AS INTEGER   NO-UNDO. /* indent level */
  DEFINE VARIABLE prev-dir     AS CHARACTER NO-UNDO. /* previous directory */
  DEFINE VARIABLE prev-filter  AS CHARACTER NO-UNDO. /* previous filter */
  DEFINE VARIABLE profilter    AS CHARACTER NO-UNDO. /* Progress 4GL MATCHES filter */
  DEFINE VARIABLE reset        AS LOGICAL   NO-UNDO.
  DEFINE VARIABLE select-list  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE slash-os     AS CHARACTER NO-UNDO. /* directory slash for this OS */
  DEFINE VARIABLE slash-nos    AS CHARACTER NO-UNDO. /* direcotry slash for other OS */
  DEFINE VARIABLE subframe     AS CHARACTER NO-UNDO. /* HTML subframe from URL */
  DEFINE VARIABLE tmpURL       AS CHARACTER NO-UNDO.

  /* Output the MIME header. */
  RUN outputContentType IN web-utilities-hdl ("text/html":U).

  RUN GetField IN web-utilities-hdl ('html':U, OUTPUT html).
  RUN GetField IN web-utilities-hdl ('subframe':U, OUTPUT subframe).
  RUN GetField IN web-utilities-hdl ('filter':U, OUTPUT filter).
  RUN GetField IN web-utilities-hdl ('directory':U, OUTPUT directory).
  RUN GetField IN web-utilities-hdl ('node-recid':U, OUTPUT node-recid).
  
  ASSIGN
    slash-os     = (IF OPSYS = "UNIX":U THEN "~/":U ELSE "~\":U)
    slash-nos    = (IF OPSYS = "UNIX":U THEN "~\":U ELSE "~/":U)
    
    /* Keep if we decide to put Filter Options back in
    file-filters = "*.w~;*.p~;*.i,*.htm~;*.html,*.w~;*.p~;*.i~;*.htm~;*.html,*"
    filter       = (IF filter EQ "" THEN ENTRY(3,file-filters) 
                    ELSE REPLACE(TRIM(filter),slash-nos,slash-os)).
    */
    filter       = (IF filter EQ "" THEN "*.*":U
                    ELSE REPLACE(TRIM(filter),slash-nos,slash-os))
    prev-filter  = filter.
    
  /* Keep if we decide to put Filter Options back in
  /* If OPSYS is not UNIX, change the value of the All Files default filter */
  IF OPSYS <> "unix":U THEN
    file-filters = file-filters + ".*":U.
  */
  /* What is the current directory? */
  IF directory EQ "":U THEN 
    ASSIGN 
      FILE-INFO:FILE-NAME = ".":U
      directory           = FILE-INFO:FULL-PATHNAME
      .
  prev-dir = directory.
  
  /* What is the directory RECID to expand/collapse?  Check for invalid 
   * options. On the initial GET, node-recid = "".  When user presses
   * parent icon (up arrow), node-recid = 0. Otherwise, node-recid is 
   * RECID of directory or file dir-node record. */
  
  /* Back up one directory level if user pressed parent icon. */
  IF node-recid = "0":U THEN DO:
    r-pos = R-INDEX(directory,slash-os).
    IF r-pos = 1 THEN
      directory = slash-os.
    ELSE IF r-pos = 3 AND 
      SUBSTRING(directory,1,3,"CHARACTER":U) MATCHES (".:":U + slash-os) THEN
      directory = SUBSTRING(directory,1,3,"CHARACTER":U).
    ELSE IF r-pos > 1 THEN
      directory = SUBSTRING(directory,1,r-pos - 1,"CHARACTER":U).
  END.
  
  IF REQUEST_METHOD = "POST":U THEN DO:
    ASSIGN r-pos = R-INDEX(filter,slash-os).
    
    /* If the filter contains a directory name, add it to the directory. */
    IF r-pos > 0 THEN DO:
      /* If filter starts with a single slash then go to the root. */
      IF SUBSTRING(filter,1,1,"CHARACTER":U) EQ slash-os THEN
        ASSIGN 
          /*directory = slash-os.*/
          FILE-INFO:FILE-NAME = slash-os + ".":U
          directory           = FILE-INFO:FULL-PATHNAME.
        
      /* Filter starts with a drive letter. */
      IF SUBSTRING(filter,1,3,"CHARACTER":U) MATCHES (".:":U + slash-os) THEN
        directory = SUBSTRING(filter,1,r-pos,"CHARACTER":U).

      /* Add the directory part of the filter to the directory. */
      ELSE 
        directory = RIGHT-TRIM(directory,slash-os) + slash-os
                  + TRIM(SUBSTRING(filter,1,r-pos,"CHARACTER":U),slash-os).
      
      /* Remove the directory from the filter. */
      filter    = IF LENGTH(filter,"CHARACTER":U) EQ r-pos THEN ""
                  ELSE SUBSTRING (filter, r-pos + 1, -1, "CHARACTER":U).
                  
      RUN validate-dir (prev-dir, prev-filter,
                        INPUT-OUTPUT directory,
                        INPUT-OUTPUT filter, slash-os,
                        OUTPUT bad-dir).
    END.
    
    /* No directory change required so rebuild active directories by 
     * refetching filelist to pick up any added or deleted files. */
    ELSE DO:
      ASSIGN
        c-recid             = ?
        p-level             = 1
        reset               = FALSE
        profilter           = REPLACE(filter,'.':U,CHR(10))
        profilter           = REPLACE(profilter,'?':U,'.':U)
        profilter           = REPLACE(profilter,CHR(10),'~~.':U)
        FILE-INFO:FILE-NAME = directory.
        
      RUN validate-dir (prev-dir, prev-filter,
                        INPUT-OUTPUT directory,
                        INPUT-OUTPUT filter, slash-os,
                        OUTPUT bad-dir).
        
      &if {&debug} &then
      put stream debug unformatted "deleting all dir-node file records" skip.
      &endif
      
      IF NOT bad-dir THEN DO:
        /* Delete files only at this point. */
        FOR EACH dir-node WHERE NOT dir-node.is-dir:
          DELETE dir-node.
        END.
  
        RUN workshop/_getnode.w (INPUT-OUTPUT c-recid, INPUT-OUTPUT p-level,
                                 directory, profilter, reset).
      END.
    END.
  END. /* POST */

  /* Rebuild all because 
     1. initial setup (node-recid = "")
     2. user pressed parent directory icon (node-recid = "0")
     3. filter included a directory name (r-pos > 0)
   */
  IF subframe ne "header":U AND
    ((REQUEST_METHOD = "GET":U AND node-recid = "") OR node-recid = "0":U 
    OR (REQUEST_METHOD = "POST":U AND r-pos > 0 AND NOT bad-dir)) THEN DO:
    ASSIGN
      c-recid    = ?
      p-level    = 1
      reset      = TRUE
      profilter  = REPLACE(filter,'.':U,CHR(10))
      profilter  = REPLACE(profilter,'?':U,'.':U)
      profilter  = REPLACE(profilter,CHR(10),'~~.':U)
      .
  
    &if {&debug} &then
    put stream debug unformatted "deleting all dir-node records" skip.
    &endif
      
    /* Rebuild all node records. */
    FOR EACH dir-node:
      DELETE dir-node.
    END.
  
    RUN workshop/_getnode.w (INPUT-OUTPUT c-recid, INPUT-OUTPUT p-level,
                             directory, profilter, reset).
  END.

  CASE subframe:
    WHEN "":U THEN DO:
      /* Draw the frameset layout */
      {&OUT}    
        '<FRAMESET ROWS="135,*">~n':U
        '  <FRAME NAME="WSFL_header" SRC="':U get-location("blank":U) '"~n':U
        '    FRAMEBORDER=yes MARGINHEIGHT=3 MARGINWIDTH=3>~n':U
        '  <FRAME NAME="WSFL_directory" SRC=_main.w?html=mainProject~&subframe=directory~n':U
        '    FRAMEBORDER=yes MARGINHEIGHT=3 MARGINWIDTH=3>~n':U
        '</FRAMESET>~n':U 
        '<NOFRAME>~n':U
        '<H1>WebSpeed File View</H1>~n'
        'This page can be display with a frame enabled browser.~n'
        '</NOFRAME>~n':U
        '</HTML>~n':U
        .
    END.
    
    WHEN "header":U THEN DO:
      /* Draw the page header */
      {&OUT}
        { webtools/html.i
          &SEGMENTS  = "head,open-body,title-line"
          &TITLE     = "Files"
          &FRAME     = "WS_index"
          &AUTHOR    = "D.M.Adams"  }

        '<BR>':U SKIP
        '&nbsp~;&nbsp~;<A HREF="_main.w?html=fileNew" TARGET="WS_main">New&nbsp~;File</A><BR>':U SKIP 
        '&nbsp~;&nbsp~;<A HREF="_main.w?html=openedFiles" TARGET="WS_main">Opened&nbsp~;Files</A><BR>':U SKIP 
        '&nbsp~;&nbsp~;<A HREF="_main.w?html=preferences" TARGET="WS_main">Preferences</A><BR>':U SKIP
        '&nbsp~;&nbsp~;<A HREF="_main.w?html=shutdown" TARGET="_top">Exit</A><BR>':U SKIP
        /* Last line needs <BR> to allow some browser to display the whole page at once. */ 
        '</BODY>~n':U
        '</HTML>~n':U
        .
    END. /* header */
    
    WHEN "directory":U THEN DO:
      {&OUT}
        { workshop/html.i
          &SEGMENTS  = "head,open-body"
          &FRAME     = "WSFL_directory"
          &AUTHOR    = "D.M.Adams" 
          &EXPIRES   = "0" }
        
        '<FORM METHOD="POST" ACTION="_main.w">':U SKIP
        '  ' format-label ('File Filter', "TOP":U, '':U) '<BR>':U SKIP
        '  <TABLE BORDER="0" CELLPADDING="0" CELLSPACING="2">':U SKIP
        '    <TR>':U SKIP
        '      <TD><INPUT TYPE="TEXT" NAME="filter" SIZE="9" VALUE="':U filter '"></TD>':U SKIP
        '      <TD><INPUT TYPE="SUBMIT" VALUE="List" NAME="ListF"></TD>':U SKIP
        '    </TR>':U SKIP
        '  </TABLE>':U SKIP
        '  <INPUT TYPE="HIDDEN" NAME="html" VALUE="mainProject">':U SKIP
        '  <INPUT TYPE="HIDDEN" NAME="subframe" VALUE="directory">':U SKIP
        '  <INPUT TYPE="HIDDEN" NAME="directory" VALUE="':U directory '">':U SKIP.
        
      {&OUT}
        '</TABLE>~n':U
        '</FORM>~n':U 
      
        '<CENTER><B><FONT COLOR="' get-color('Filename':U) '">':U 
          word-break(directory,slash-os)
        '</FONT></B></CENTER><BR>':U SKIP
        '<TABLE BORDER="0" CELLPADDING="0" CELLSPACING="0">':U SKIP.
    
      IF NOT bad-dir THEN DO:      
        /* Get directory RECID and expand/collapse if available. */
        FIND FIRST dir-node WHERE RECID(dir-node) EQ INTEGER(node-recid) NO-ERROR.
        IF NOT AVAILABLE dir-node THEN DO:
          IF node-recid <> "" AND node-recid <> ? AND node-recid <> "0":U THEN DO:
            /* The directory for node <node-id> could not be found. */
            RUN webutil/_promsgs.w (5669,"error,out":U,"node-id=":U + node-recid,
                                OUTPUT errmsg).
            RETURN "Error":U.
          END.
        END.
        ELSE DO:
          IF dir-node.is-dir THEN DO:
            ASSIGN
              dir-node.expanded = (IF NOT dir-node.is-dir THEN FALSE ELSE
                                    (IF dir-node.expanded THEN FALSE ELSE TRUE))
              node-recid        = (IF node-recid = "" THEN "?" ELSE dir-node.p-recid)
              .
          
            IF NOT dir-node.expanded THEN
              RUN workshop/_hidnode.w (STRING(RECID(dir-node))).
            ELSE DO:
              /* Build the filelist for this newly opened directory. */
              ASSIGN
                c-recid             = STRING(RECID(dir-node))
                p-level             = dir-node.level + 1
                FILE-INFO:FILE-NAME = dir-node.dir-path + slash-os + 
                                      dir-node.name.

              RUN workshop/_getnode.w (INPUT-OUTPUT c-recid, INPUT-OUTPUT p-level,
                                       FILE-INFO:FULL-PATHNAME, filter, FALSE).
            END.
          END.
        END.
      
        /* Redraw the directory/file tree. */
        ASSIGN
          c-recid    = ?
          is-root    = (IF directory = slash-os OR (LENGTH(directory,"CHARACTER":U) = 3
            AND SUBSTRING(directory,1,3,"CHARACTER":U) MATCHES (".:":U + slash-os)) THEN 
            TRUE ELSE FALSE).
        RUN workshop/_putnode.w (INPUT-OUTPUT c-recid,is-root,filter,directory,TRUE).
        
        {&OUT}
          '  <TR><TD>~&nbsp~;</TD></TR>':U SKIP
          '</TABLE>':U SKIP.
          
        IF REQUEST_METHOD = "GET":U AND node-recid = "" THEN DO:
          /* Load the "header" subframe for the project view. Fully qualify the 
             URL here so that the javascript will work on IE3. Originally, the 
             header frame loaded the directory frame, but this was reversed
             to fix bug 97-05-23-019. We only need to do this for the GET. */
          tmpURL = AppURL + '/workshop/_main.w?html=mainProject~&subframe=header':U. 
          {&OUT}
            { workshop/javascpt.i 
              &SEGMENTS = "load-sibling"
              &FRAME    = "WSFL_header"
              &LOCATION = "tmpURL" }.
        END.
            
        {&OUT}
          '</BODY>':U SKIP
          '</HTML>':U SKIP
          .
      END. /* IF NOT bad-dir */
	END. /* directory */
    OTHERWISE DO: /* unknown subframe */
      {&OUT} 
        'html= ':U html '<BR>':U SKIP
        'subframe= ':U subframe SKIP
        '</HTML>':U.
    END.
  END CASE.
  
        &if {&debug} &then
        for each dir-node use-index p-recid:
          put stream debug unformatted
            dir-node.p-recid   " "
            dir-node.level     " "
            dir-node.file-type " "
            dir-node.is-dir    " " 
            dir-node.dir-path " "
            dir-node.name     skip
            .
        end.
        output stream debug close.
        &endif

END PROCEDURE.
&ANALYZE-RESUME
 
&ANALYZE-SUSPEND _CODE-BLOCK _PROCEDURE validate-dir
PROCEDURE validate-dir :
/*------------------------------------------------------------------------------
  Purpose:     Validate the directory name
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  DEFINE INPUT        PARAMETER pPrevDir    AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER pPrevFilter AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pDirectory  AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pFilter     AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER pSlash      AS CHARACTER NO-UNDO.
  DEFINE       OUTPUT PARAMETER pBadDir     AS LOGICAL   NO-UNDO.
  
  FILE-INFO:FILE-NAME = pDirectory.
  
  IF FILE-INFO:FULL-PATHNAME = ? THEN DO:
    RUN Add-Error IN _err-hdl ("ERROR":U,?,
      SUBSTITUTE("&1 is an invalid directory name.",
      word-break(pDirectory,pSlash))).
    ASSIGN
      pBadDir    = TRUE
      pDirectory = pPrevDir
      pFilter    = pPrevFilter
      .
  END.
  
END PROCEDURE.
&ANALYZE-RESUME

/* _project.w - end of file */

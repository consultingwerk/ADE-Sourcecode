&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v1r1 GUI
&ANALYZE-RESUME
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

  File: _putnode.w

  Description: Writes directory/file structure to the web stream

  Input Parameters:  p_recid     - parent char. RECID 
                     p_isroot    - parent is root directory
                     p_filter    - file selection filter
                     p_directory - current directory
                     p_initial   - initial call to this program

  Output Parameters:
      <none>

  Author: D.M.Adams

  Created: 12-3-96
  
  Modified:
    wood 12-12-96 - Use &nbsp to indent lines

------------------------------------------------------------------------*/
/*           This .W file was created with WebSpeed WorkBench.          */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{workshop/dirnode.i}   /* Shared temp-table for project nodes. */

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER p_recid     AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_isroot    AS LOGICAL   NO-UNDO.
DEFINE INPUT        PARAMETER p_filter    AS CHARACTER NO-UNDO.  
DEFINE INPUT        PARAMETER p_directory AS CHARACTER NO-UNDO.  
DEFINE INPUT        PARAMETER p_initial   AS LOGICAL   NO-UNDO.

/* Local Variable Definitions ---                                       */
&scoped-define debug false
&if {&debug} &then
define stream debug.
output stream debug to aa-putnode.log.
&endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Procedure

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Procedure
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
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
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Cue Card" Procedure _INLINE
/* Actions: adecomm/_so-cue.w ? adecomm/_so-cued.p ? adecomm/_so-cuew.p */
/* Custom CGI Wrapper Procedure,wdt,49681
Destroy on next read */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Procedure 
/* ************************* Included-Libraries *********************** */
{src/web/method/wrap-cgi.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ************************  Main Code Block  *********************** */

DEFINE VARIABLE file-ext   AS CHARACTER NO-UNDO.
DEFINE VARIABLE gif-file   AS CHARACTER NO-UNDO.
DEFINE VARIABLE node-text  AS CHARACTER NO-UNDO.

IF p_initial AND NOT p_isroot THEN
  {&OUT}
    '  <TR><TD>':U SKIP
    '    <A HREF="_main.w?html=mainProject':U 
    '&node-recid=0&directory=':U url-encode(p_directory,"query":U) 
    '&filter=':U url-encode(p_filter,"query":U)
    '&subframe=directory"><IMG SRC="/webspeed/images/uplevel.gif"':U
    ' BORDER="0"></A></TD>':U SKIP.

&if {&debug} &then      
for each dir-node use-index p-recid:
  display stream debug
    dir-node.p-recid   label "recid"
    dir-node.level     format "zzzz9"
    dir-node.file-type format "x(4)" label "type"
    dir-node.is-dir   
    dir-node.name      format "x(12)"
    dir-node.dir-path  format "x(30)"
    dir-node.sort-fld  format "x(12)".
end.
output stream debug close.
&endif

&IF "{&OPSYS}":U eq "WIN32":U &THEN 
/* Sort alphabetically, case-insensitive for Windows users */
FOR EACH dir-node WHERE dir-node.p-recid = p_recid USE-INDEX sort-fld:
&ELSE
/* Sort alphabetically, case-sensitive for UNIX users */
FOR EACH dir-node WHERE dir-node.p-recid = p_recid USE-INDEX p-recid:
&ENDIF
  IF dir-node.dir-path = dir-node.name THEN NEXT.
  
  IF dir-node.is-dir THEN
    gif-file = (IF dir-node.expanded THEN "fldropen":U ELSE "folder":U).
  ELSE DO:
    RUN adecomm/_osfext.p (dir-node.name,OUTPUT file-ext).
    
    /*
    CASE file-ext:
      WHEN ".f":U                     THEN gif-file = "file-f":U.
      WHEN ".htm":U OR WHEN ".html":U THEN gif-file = "file-h":U.
      WHEN ".i":U                     THEN gif-file = "file-i":U.
      WHEN ".p":U                     THEN gif-file = "file-p":U.
      WHEN ".r":U                     THEN gif-file = "file-r":U.
      WHEN ".w":U                     THEN gif-file = "file-w":U.
      OTHERWISE                            gif-file = "file-p":U.
    END CASE.
    */
    gif-file = "file-p":U.
  END.

  {&OUT}
    '  <TR><TD NOWRAP>':U 
    /* write cell padding (empty cells) */
    FILL ("~&nbsp~;":U, (dir-node.level - 1) * 4) SKIP.

  /* Write node image and text */
  RUN AsciiToHtml IN web-utilities-hdl (dir-node.name, OUTPUT node-text).
  
  IF dir-node.is-dir THEN
    {&OUT}
      '    <A HREF="_main.w?html=mainProject&node-recid=':U RECID(dir-node) 
      '&directory=':U url-encode(p_directory,"query":U) 
      (IF dir-node.expanded THEN '&action=close':U ELSE '')
      '&filter=':U url-encode(p_filter,"query":U) '&subframe=directory">':U.
  ELSE
    {&OUT}
      '    <A HREF="_main.w?html=procedureFrameset':U
      '&filename=':U url-encode(dir-node.name,"query":U)
      '&directory=':U url-encode(dir-node.dir-path,"query":U)
      '" TARGET="WS_main">':U.
    
  {&OUT}
    '<IMG SRC="/webspeed/images/':U gif-file '.gif" BORDER="0"> ':U node-text
    '</A></TD></TR>':U SKIP.
    
  IF dir-node.is-dir AND (dir-node.expanded OR p_recid = ?) THEN DO:
    p_recid = STRING(RECID(dir-node)).     
    RUN workshop/_putnode.w (INPUT-OUTPUT p_recid,p_isroot,p_filter,p_directory,FALSE).
  END.
END. /* FOR EACH dir-node: */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _putnode.w - end of file */

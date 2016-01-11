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

  File: _getnode.w

  Description: Load the directory/file node structure

  Input Parameters: p_recid     - parent char. RECID
                    p_level     - indent level
                    p_directory - directory/file name
                    p_filter    - file selection filter
                    p_initial   - initial call to this program

  Output Parameters:
      <none>

  Author: D.M.Adams

  Created: 12-3-96

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
DEFINE INPUT-OUTPUT PARAMETER p_level     AS INTEGER   NO-UNDO.
DEFINE INPUT        PARAMETER p_directory AS CHARACTER NO-UNDO CASE-SENSITIVE.
DEFINE INPUT        PARAMETER p_filter    AS CHARACTER NO-UNDO.
DEFINE INPUT        PARAMETER p_initial   AS LOGICAL   NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE STREAM instream.

&scoped-define debug false
&if {&debug} &then
define stream debug.
if p_initial then do:
  output stream debug to aa-getnode.log.
  put stream debug unformatted
    skip(1) today " " string(time,"hh:mm") skip.
end.
else
  output stream debug to aa-getnode.log append.
&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Procedure 

/* ***********************  Local Definitions  ********************** */

DEFINE VARIABLE c-scrap    AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE directory  AS CHARACTER NO-UNDO CASE-SENSITIVE.
DEFINE VARIABLE filter     AS CHARACTER NO-UNDO.
DEFINE VARIABLE last-char  AS CHARACTER NO-UNDO.
DEFINE VARIABLE no-match   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE ix         AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE level      AS INTEGER   NO-UNDO.
DEFINE VARIABLE next-name  AS CHARACTER NO-UNDO CASE-SENSITIVE.
DEFINE VARIABLE next-path  AS CHARACTER NO-UNDO.
DEFINE VARIABLE next-type  AS CHARACTER NO-UNDO.
DEFINE VARIABLE p-recid    AS CHARACTER NO-UNDO.
DEFINE VARIABLE slash-os   AS CHARACTER NO-UNDO. /* directory slash for this OS */
  
/* ************************  Main Code Block  *********************** */

/* Create record for base directory */
IF p_initial THEN
  RUN add-node (p_recid, 1, p_directory, p_directory, "D":U).

/* Remove directories that have been deleted. */
FOR EACH dir-node WHERE dir-node.is-dir:
  ASSIGN
    FILE-INFO:FILE-NAME = dir-node.dir-path + "/":U + dir-node.name
    c-scrap             = FILE-INFO:FILE-TYPE.

  IF dir-node.dir-path <> dir-node.name AND c-scrap = ? THEN
    DELETE dir-node.
END.

slash-os  = (IF OPSYS = "UNIX":U THEN "~/":U ELSE "~\":U).

/* Read directory structure */
INPUT STREAM instream FROM OS-DIR(p_directory) NO-ECHO.
Read-Block:
REPEAT ON ENDKEY UNDO Read-Block, LEAVE Read-Block:
  IMPORT STREAM instream next-name next-path next-type.
  
  DO ix = 1 TO NUM-ENTRIES(p_filter,";":U):
    filter = ENTRY(ix, p_filter,";":U).
    
    IF INDEX(next-type,"D":U) > 0 OR (INDEX(next-type,"F":U) > 0 AND
       (filter EQ "":U OR LC(next-name) MATCHES LC(filter))) THEN DO:
      IF next-name = ".":U OR next-name = "..":U THEN NEXT.
      RUN add-node (p_recid, p_level, p_directory, next-name, next-type).
    
      /* Build list of files for an expanded directory. */
      FIND FIRST dir-node WHERE dir-node.is-dir AND dir-node.expanded AND
        dir-node.dir-path MATCHES p_directory AND
        dir-node.name MATCHES next-name NO-ERROR.
      IF AVAILABLE dir-node THEN DO:
        ASSIGN
          p-recid   = STRING(RECID(dir-node))
          last-char = SUBSTRING(dir-node.dir-path,
                        LENGTH(dir-node.dir-path,"CHARACTER":U), -1,
                        "CHARACTER":U)
          directory = dir-node.dir-path +
                      (IF last-char <> slash-os THEN slash-os ELSE '') +
                      dir-node.name
          level     = dir-node.level + 1.
        RUN workshop/_getnode.w (INPUT-OUTPUT p-recid, INPUT-OUTPUT level,
                                 directory, filter, FALSE).
      END.
    END.
  END.
END.
INPUT STREAM instream CLOSE.

/* Purge files that no longer meet filter criteria */
FOR EACH dir-node WHERE NOT dir-node.is-dir:
  no-match = TRUE.
  
  DO ix = 1 TO NUM-ENTRIES(p_filter,";":U):
    filter = ENTRY(ix,p_filter,";":U).
    
    IF filter <> "" AND LC(dir-node.name) MATCHES LC(filter) THEN DO:
      no-match = FALSE.
      LEAVE.
    END.
  END.
  
  IF p_filter <> "" AND no-match THEN DELETE dir-node.
END.

&if {&debug} &then
for each dir-node:
  put stream debug unformatted
    "p_filter: " p_filter " "
    dir-node.p-recid " "   
    dir-node.level " "
    dir-node.file-type " "
    dir-node.is-dir " "
    dir-node.name " "
    dir-node.dir-path " "
    dir-node.sort-fld skip
    .
end.
output stream debug close.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE add-node Procedure 
PROCEDURE add-node :
/*------------------------------------------------------------------------------
  Purpose: Create directory/file node record in dir-node temp-table
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p_recid     AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER this-level  AS INTEGER   NO-UNDO.
  DEFINE INPUT PARAMETER p_directory AS CHARACTER NO-UNDO CASE-SENSITIVE.
  DEFINE INPUT PARAMETER next-name   AS CHARACTER NO-UNDO CASE-SENSITIVE.
  DEFINE INPUT PARAMETER next-type   AS CHARACTER NO-UNDO.
  
  /* MATCHES is used here to get around a collation table limitation with 
     'a = a-umlaut' in which the two are seen as the same.  MATCHES uses 
     each string's ASCII value instead. */
  IF CAN-FIND(FIRST dir-node WHERE 
    dir-node.dir-path MATCHES p_directory AND
    dir-node.name MATCHES next-name) THEN RETURN.
    
  CREATE dir-node.
  ASSIGN
    dir-node.p-recid   = p_recid
    dir-node.level     = this-level
    dir-node.file-type = next-type
    dir-node.is-dir    = (INDEX(next-type,"D":U) > 0)
    dir-node.name      = next-name
    dir-node.dir-path  = p_directory
    dir-node.sort-fld  = LC(next-name)
    .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* _getnode.w - end of file */

&ANALYZE-SUSPEND _VERSION-NUMBER WDT_v2r1 Procedure
&ANALYZE-RESUME
&ANALYZE-SUSPEND _CODE-BLOCK _CUSTOM "Main Code Block" 
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
/*-----------------------------------------------------------------------
  File: _valfnam.p

  Purpose:  Validate that the name given to save into is a valid PROGRESS
              name. NOTE: most of this is due to the fact that we don't support
              long file names. 
 
  Input Parameters: 
    p_name  - name to check (this is assumed to be TRIMMED).
    p_types - Type list of the file saved (eg. HTML,MAPPED)
    p_group - name of error group (in Workshop, not WebSpeed queue-messages)

  Output Parameters:
    p_error - TRUE if any errors are found. 

  Author: Wm. T. Wood
  Created: May 19, 1997
-----------------------------------------------------------------------*/
/*            This file was created with WebSpeed Workshop.            */
/*---------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_savename  AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_types     AS CHAR NO-UNDO.
DEFINE INPUT  PARAMETER p_group     AS CHAR NO-UNDO.
DEFINE OUTPUT PARAMETER p_error     AS LOGICAL NO-UNDO.

/* Local Definitions --                                                */
DEFINE VARIABLE c_type   AS CHAR NO-UNDO.
DEFINE VARIABLE dir-path AS CHAR NO-UNDO.
DEFINE VARIABLE ext      AS CHAR NO-UNDO.
DEFINE VARIABLE fname    AS CHAR NO-UNDO.
DEFINE VARIABLE l_win    AS LOGICAL NO-UNDO.

/* Included Definitions ---                                             */
{ workshop/errors.i }                 /* Error handler and functions.   */

/* ************************ Main Code Block ************************** */

/* Clear any validation errors. */
RUN clear-errors IN _err-hdl (p_group).

/* Do a test, first, on the name to see that it is not read-only. */
FILE-INFO:FILE-NAME = p_savename.
IF FILE-INFO:FULL-PATHNAME ne ? AND INDEX(FILE-INFO:FILE-TYPE, "W":U) eq 0
THEN RUN Add-Error in _err-hdl (p_group, ?, "Specified file is READ-ONLY.").

/* Break the name into the directory and the name. */
fname = REPLACE (p_savename, "~\":U, "~/":U).
RUN adecomm/_osprefx.p (INPUT fname, OUTPUT dir-path , OUTPUT fname).
/* Make sure the directory exists. */
IF dir-path  ne "":U THEN DO:
  FILE-INFO:FILE-NAME = dir-path .
  IF FILE-INFO:FULL-PATHNAME eq ? OR NOT (FILE-INFO:FILE-TYPE BEGINS "D":U) 
  THEN RUN Add-Error in _err-hdl
            (p_group, ?, 
             SUBSTITUTE ("Specified directory, <i>&1</i>, does not exist.", dir-path)).
END. 

/* The remaining tests may look at platform. */
l_win = (OPSYS BEGINS "WIN":U).
/* Don't allow bad extensions. */
RUN adecomm/_osfext.p (INPUT fname, OUTPUT ext).

/* Do tests by file type. We are particularly concerned about 4GL and HTML files.
   These can never have spaces, and they must end with legal extensions.*/
IF LOOKUP('4GL':U, p_types) > 0 THEN
  c_Type = "SpeedScript":U.
ELSE IF LOOKUP('HTML':U, p_types) > 0 THEN 
  c_Type = "HTML":U.
IF c_Type ne "":U THEN DO:
  /* Is this a runnable unix file. (This is an old limit that really should not
     apply anymore, but it does. NOTE that the really old limit was 12 characters.
     Now it is 60.) */
  IF NOT l_win AND LENGTH(p_savename) > 60 THEN
    RUN Add-Error IN _err-hdl (p_group, ?, c_Type +
                               " path names must be 60 characters long, or less.").
  ELSE IF l_win AND LENGTH(fname) > 255 THEN
    RUN Add-Error IN _err-hdl (p_group, ?, c_Type +
                               " file names must be 255 characters long, or less.").

  /* We base whether a file is compilable and or runnable based on the extension. */
  IF c_Type eq "HTML":U THEN DO:
    /* HTML must be ".htm" or ".html" */
    IF LOOKUP(ext,".htm,.html":U) eq 0 THEN
      RUN Add-Error IN _err-hdl (p_group, ?, c_Type +
                                 " files must have a .htm or .html extension.").
  END.
  ELSE DO:
    /* 4GL files must be .w */
    IF LOOKUP(ext,".w,.p,.i":U) eq 0 THEN
      RUN Add-Error IN _err-hdl (p_group, ?, c_Type +
                                 " files must have use .p, .w, or .i as an extension.").
  END.
END. /* IF c_Type [is HTML or SpeedScript]... */

/* Were any errors found so far.  If so, stop checking so the error list is not
   huge. (Also we don't want to check extensions and spaces twice. */
IF errors-exist (p_group) THEN p_error = yes.
ELSE DO:
  /* Do some simple tests on the name that are appropriate for all platforms. */
  IF fname BEGINS ".":U THEN
    RUN Add-Error IN _err-hdl (p_group, ?, "File name cannot start with a period (.).").
  IF INDEX(fname, "~~":U) > 0 THEN 
    RUN Add-Error IN _err-hdl (p_group, ?, "File name cannot contain tildes (~~).").
  IF INDEX(fname, '"':U) > 0 THEN 
    RUN Add-Error IN _err-hdl (p_group, ?, "File name cannot contain quotes (~").").
  IF INDEX(fname, ':':U) > 0 THEN
    RUN Add-Error IN _err-hdl (p_group, ?, "File name cannot contain colons (:).").
  IF INDEX(fname, '?':U) > 0 OR INDEX(fname, '<':U) > 0 OR INDEX(fname, ">":U) > 0 OR
     INDEX(fname, '*':U) > 0 OR INDEX(fname, '|':U) > 0 
  THEN
    RUN Add-Error IN _err-hdl (p_group, ?, "File name cannot contain any of the following characters: ? * < > |").

  /* On unix, we can't save files with spaces */
  IF NOT l_win AND INDEX(fname, " ":U) > 0 THEN 
    RUN Add-Error IN _err-hdl (p_group, ?, "File name cannot contain spaces.").
 
  /* Don't allow users to use .r as an extension. */
  IF ext eq ".r":U THEN 
    RUN Add-Error IN _err-hdl (p_group, ?,
    " You cannot use .r as a file extension. This is reserved for compiled r-code.").

  /* Were any errors found. */
  IF errors-exist (p_group) THEN p_error = yes.
END.
&ANALYZE-RESUME
/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

 


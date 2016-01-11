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
/* status.p - display brief and useful status information */

{src/web/method/cgidefs.i}

RUN show-status.

/* -------------------------------------------------------------------
   Procedure: show-status
   Purpose:   Displays various status information
 --------------------------------------------------------------------*/   
PROCEDURE show-status :
  DEFINE VARIABLE verbose-mode      AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE default-directory AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE gmt-date          AS CHARACTER  NO-UNDO.

  /* Get the current or default directory and save */
  ASSIGN
    FILE-INFO:FILE-NAME = ".":U  /* do a stat() on the current directory */
    default-directory   = FILE-INFO:FULL-PATHNAME.  /* get full path */

  RUN OutputContentType IN web-utilities-hdl ("text/html":U).

  {&OUT}
    '<HTML>~n':U
    '<HEAD><TITLE>':U 'WebSpeed Status' '</TITLE></HEAD>~n':U
    '<BODY BGCOLOR="white">~n':U
    '<H1>':U 'WebSpeed Status' '</H1>~n':U
  {&END}

  {&OUT}
    '<HR>~n':U
    '<UL>~n':U  /* start list */
    '<LI>':U 'Web browser: ' 
             '<B>':U HTTP_USER_AGENT '</B>~n':U
    '<LI>':U 'Web server: ' 
             '<B>':U SERVER_SOFTWARE '</B>~n':U
    '<LI>':U 'Host and port part of URL: ' 
             '<B>':U HostURL '</B>~n':U
    '<LI>':U 'Server relative URL of this Web object: ' 
             '<B>':U SelfURL '</B>~n':U
    '<LI>':U 'Server relative URL for this application: ' 
             '<B>':U AppURL '</B>~n':U
    '<LI>':U 'Web object path (PROPATH): '
             '<B>':U REPLACE(PROPATH, ",":U, ", ":U) '</B>~n':U
    '<LI>':U 'Default directory for this application: ' 
             '<B>':U default-directory '</B>~n':U.

  /* Determine the WebSpeed installation directory.  Currently, this only
     works if an environment variable is used rather than a progress.ini in
     Windows NT. */
  IF OPSYS = "unix":U THEN
    {&OUT}
      '<LI>' 'WebSpeed installation directory: '
             '<B>':U OS-GETENV("DLC":U) '</B>~n':U.

  {&OUT}
    '<LI>' 'WebSpeed operating system (OPSYS): '
           '<B>':U OPSYS '</B>~n':U
    '</UL>~n':U.

  /* Check for argument/field "verbose" */
  RUN GetField IN web-utilities-hdl ("verbose":U, OUTPUT verbose-mode).

  /* Verobse mode? */
  IF verbose-mode = "yes":U THEN DO:
    /* Output a link to ourself */
    {&OUT}
      '<P><A HREF="':U SelfURL '">':U 'Brief' '</A> ':U 'mode' '</P>~n':U.

    /* Run the debugging Web object without turning on debugging. */
    RUN web/support/printval.p ("all":U).
  END.

  /* No, just output a link */
  ELSE DO:
    /* Output a link to ourself with an optional argument */
    {&OUT}
      '<P><A HREF="':U SelfURL '?verbose=yes">':U 'Verbose' '</A> ':U 
      'mode' '</P>~n':U.
  END.

  RUN CookieDate IN web-utilities-hdl (TODAY, TIME, OUTPUT gmt-date).
  {&OUT}
    '<HR>~n':U
    '<ADDRESS>':U "Generated on " gmt-date '</ADDRESS>~n':U
    '</BODY>~n':U
    '</HTML>~n':U
  {&END}

END PROCEDURE.  /* show-status */

/* status.p - end of file */

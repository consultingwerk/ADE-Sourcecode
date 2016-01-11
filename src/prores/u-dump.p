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
/* u-dump.p - dump report into database */

/* part of a set comprised of u-dump.p u-load.p u-pick.p u-used.p */

DEFINE SHARED VARIABLE qbf-module AS CHARACTER NO-UNDO.

DEFINE NEW SHARED VARIABLE qbf-total AS INTEGER NO-UNDO. /* used by u-load.p */

DEFINE VARIABLE qbf-f AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO.

IF qbf-module <> "r" THEN DO:
  RUN prores/s-error.p ("The u-dump program can only be called from within " +
                        "the Reports module.").
  RETURN.
END.

/* If a database with a logical name or alias of "file$cab" is not    */
/* connected, the first try to connect a database with the physical   */
/* name of "file$cab".  If this fails, then try to connect a database */
/* with a name the same as the user's opsys userid.  If this fails,   */
/* then complain.                                                     */
IF LDBNAME("file$cab") = ? THEN DO:
  HIDE MESSAGE NO-PAUSE.
  CONNECT "file$cab" -1 NO-ERROR.
  IF NOT CONNECTED("file$cab") AND USERID("RESULTSDB") <> "" THEN
    CONNECT VALUE(USERID("RESULTSDB")) -ld "file$cab" -1 NO-ERROR.
  IF NOT CONNECTED("file$cab") THEN DO:
    RUN prores/s-error.p ("Sorry, but could not connect to file cabinet database.").
    RETURN.
  END.
END.

/* We at PSC are cheating and using the RESULTSDB alias.  This is */
/* semi-legal.  It makes our compile scripts work on the u-*.p    */
/* procedures.  For general work, all references to RESULTSDB in  */
/* u-dump.p, u-load.p, u-pick.p and u-used.p should be changed to */
/* something safer, preferably something like "file$sys".         */
CREATE ALIAS "RESULTSDB" FOR DATABASE VALUE(LDBNAME("FILE$CAB")).

/* Select a file.  A file name beginning with "<<" means the user */
/* wants to add a new file.                                       */
RUN prores/u-pick.p (OUTPUT qbf-f).
IF qbf-f BEGINS "<<" THEN qbf-f = "".

/* Get the new file name from the user.                           */
IF qbf-f = "" THEN DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
  UPDATE
    qbf-f FORMAT "x(32)" LABEL "Enter a file name to hold the report"
    WITH FRAME qbf-title ROW 5 CENTERED ATTR-SPACE OVERLAY.
  HIDE MESSAGE NO-PAUSE.

  /* check to make sure valid name */
  DO qbf-i = 1 TO LENGTH(qbf-f):
    IF INDEX("abcdefghijklmnopqrstuvwxyz" + (IF qbf-i = 1 THEN "" ELSE "_"),
      SUBSTRING(qbf-f,qbf-i,1)) = 0 THEN LEAVE.
  END.
  IF qbf-i < LENGTH(qbf-f) + 1 THEN DO:
    MESSAGE
      "Only letters and ~"_~" allowed in names, and must begin with a letter.".
    UNDO,RETRY.
  END.
END.

/* check if already exists */
RUN prores/u-used.p (INPUT qbf-f,OUTPUT qbf-l).
IF qbf-l THEN DO:
  RUN prores/s-box.p
    (INPUT-OUTPUT qbf-l,?,?,'Do you want to over-write "' + qbf-f + '"?').
  IF NOT qbf-l THEN qbf-f = "".
END.

IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN qbf-f = "".
HIDE FRAME qbf-title NO-PAUSE.

/* Now, actually load stuff into database.  u-load.p creates file */
/* definitions in _File, _Field, etc. and a program called _qbf.p */
/* to do the loading of data.                                     */
IF qbf-f <> "" THEN DO:
  RUN prores/u-load.p ("FILE$CAB",qbf-f).
  MESSAGE "Creating records...".
  COMPILE _qbf.p.
  RUN _qbf.p.
  HIDE MESSAGE NO-PAUSE.
  MESSAGE "Done. " qbf-total "records created.".
END.

/* return to reports module. */
qbf-module = "r".

RETURN.

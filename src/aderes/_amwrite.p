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
/*
*  _amwrite.p
*
*    This file creates the file that builds the VAR's structure over
*    RESULTS user interface.
*
*    writeRequest    0 Write if config is dirty and qbf-awrite is set
*                    1 Write if config is dirty, regardless of qbf-awrite
*                    2 Write regardless of bits
*/					   

{ aderes/s-system.i }
{ aderes/a-define.i }
{ aderes/_fdefs.i }

DEFINE INPUT PARAMETER writeRequest AS INTEGER NO-UNDO.

DEFINE VARIABLE menuFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE baseName AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-l    AS LOGICAL   NO-UNDO. /* scrap */

/*
 * If the writeRequest is 0 then write out the configuration file. 
 * Otherwise check the state of the bits to see if we should write.
 */
IF writeRequest = 1 AND _uiDirty = FALSE THEN RETURN.
ELSE IF writeRequest = 0
  AND NOT ((_uiDirty = YES) AND (qbf-awrite = YES)) THEN RETURN.

/* If the menu file doesn't have a name, give it one.  */
RUN adecomm/_statdsp.p (wGlbStatus,1,"Creating UI File...":t72).

IF (_adminMenuFile = ?) OR (_adminMenuFile = "") THEN DO:
  ASSIGN
    baseName       = qbf-fastload
    _adminMenuFile = baseName + "mt.p":u
    .

  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"information":u,"ok":u,
    SUBSTITUTE("The UI file does not have a name.  &1 will provide the name &2.",qbf-product,_adminMenuFile)).

  /* Core doesn't remember the state of the cursor. Turn watch cursor back on */
  RUN adecomm/_setcurs.p("WAIT":u).
  _configDirty = TRUE.
  RUN aderes/_awrite.p (0).
END.
ELSE
  baseName = SUBSTRING(_adminMenuFile,1, 
               R-INDEX(_adminMenuFile,".":u) - 1,"CHARACTER":u).

/*
* First,  make the version that we want customers to be able to
* recompile. This is needed if there is an r code chagne. The users
* will be able to keep existing work. This file must have a date before the
* fastload .r file, otherwise this will be recompiled on the fly.
*/

RUN adeshar/_mwrite.p({&resId}, _adminMenuFile, "mt", "p").

/* Create a temporary file */
RUN adecomm/_tmpfile.p ("r":u, "", OUTPUT menuFile).	

/* Create, compile, and copy the file */
RUN adeshar/_mwrite.p ({&resId}, menuFile + ".am":u, "mt":u, "fp":u).

RUN adecomm/_statdsp.p (wGlbStatus, 1, "Compiling UI File...":t72).

COMPILE VALUE(menuFile + ".am":u) SAVE.

RUN adecomm/_statdsp.p (wGlbStatus, 1, "Copying UI File...":t72).

OS-COPY VALUE(menuFile + ".r":u) VALUE(baseName + ".r":u).

/* Cleanup */
&IF DEFINED(dont) = 0 &THEN
OS-DELETE VALUE(menuFile + ".am").
&ENDIF

OS-DELETE VALUE(menuFile + ".r").

ASSIGN
  _uiDirty     = FALSE
  _writeReport = TRUE
  .

RUN adecomm/_statdsp.p(wGlbStatus, 1, "").

/* _amwrite.p - end of file */

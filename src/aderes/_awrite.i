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
* _awrite.i
*
*    Contains the common functions needed for writing.
*    Assumes a stream, named pStream, has been defined.
*/

/* Compiles a file and moves the r-code to the given name.  */
PROCEDURE compileFastload:
  DEFINE INPUT PARAMETER fastloadBase AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER rFile        AS CHARACTER NO-UNDO.

  DEFINE VARIABLE sourceFile AS CHARACTER NO-UNDO.
  DEFINE VARIABLE eText      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf-l      AS LOGICAL   NO-UNDO.

  sourceFile = fastloadBase + ".d":u.

  compileFastload:
  DO ON STOP UNDO compileFastload, RETRY compileFastload:
    IF RETRY THEN LEAVE compileFastLoad.

    /* Compile the program */
    COMPILE VALUE(sourceFile) SAVE.
  END.

  IF COMPILER:ERROR = TRUE THEN DO:
    DEFINE VARIABLE saveFile AS CHARACTER NO-UNDO.

    /* Copy the temp name into another temp name. Let the user know of this 
     * file.  */
    RUN adecomm/_tmpfile.p ("r":u, ".p":u, OUTPUT saveFile).
    OS-COPY VALUE(sourceFile) VALUE(saveFile).

    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"information":u,"ok":u,
      SUBSTITUTE("The source of the fastload file has been saved as &1.",
      saveFile)).
  END.
  ELSE DO:
    OS-COPY VALUE(fastloadBase + ".r":u) VALUE(rFile).
    IF OS-ERROR > 0 THEN DO:
      RUN adecomm/_oserr.p (OUTPUT eText).
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
        SUBSTITUTE("Problem copying the fastload file.^^&1.",eText)).
    END.
    ELSE DO:
      OS-DELETE VALUE(fastloadBase + ".r":u).
      IF OS-ERROR > 0 THEN DO:
        RUN adecomm/_oserr.p (OUTPUT eText).
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
          SUBSTITUTE("Problem deleting the temporary fastload file.^^&1.",
          eText)).
      END.
    END.
  END.

  /* dont is a compiler variable. If it is set then the file will not be 
   * deleted. */
  &IF DEFINED(dont) = 0 &THEN
  OS-DELETE VALUE(sourceFile).
  OS-DELETE VALUE(qbf-tempdir + ".d":u).
  &ENDIF
  
END PROCEDURE.

/*----------------------------------------------------------------------*/
PROCEDURE startFile:
  /* Starts a new file. Opens the stream and creates the header. */

  DEFINE INPUT        PARAMETER pName    AS CHARACTER NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pCount   AS INTEGER   NO-UNDO.
  DEFINE INPUT        PARAMETER pLines   AS CHARACTER NO-UNDO.
  DEFINE INPUT        PARAMETER timeText AS CHARACTER NO-UNDO.

  OUTPUT STREAM pStream  TO VALUE(pName) NO-ECHO.

  pCount = 0.
  IF pLines <> "" THEN
    PUT STREAM pStream UNFORMATTED
      SKIP pLines SKIP.

  PUT STREAM pStream UNFORMATTED
    SKIP
    '~{ aderes/u-pvars.i }':u SKIP
    '~{ aderes/af-idefs.i }':u SKIP
    'DEFINE VARIABLE s  AS LOGICAL   NO-UNDO.':u SKIP
    'DEFINE VARIABLE i1 AS INTEGER   NO-UNDO.':u SKIP
    .

  RUN startProc (INPUT-OUTPUT pCount).
  
END PROCEDURE.

/*----------------------------------------------------------------------*/
PROCEDURE endFile:
  /* Closes the last procedure and closes the stream */
  DEFINE INPUT-OUTPUT PARAMETER ix     AS INTEGER   NO-UNDO.
  DEFINE INPUT        PARAMETER pLines AS CHARACTER NO-UNDO.

  RUN endProc(INPUT-OUTPUT ix).

  IF pLines <> "" THEN
    PUT STREAM pStream UNFORMATTED SKIP pLines SKIP.

  OUTPUT STREAM pStream CLOSE.
  
END PROCEDURE.

/*----------------------------------------------------------------------*/
PROCEDURE endProc:
  /* These functions are used to create the internal functions. The
   * internal functions are used to avoid hitting those nasty limits. */
  DEFINE INPUT-OUTPUT PARAMETER ix AS INTEGER NO-UNDO.

  ix = 0.

  PUT STREAM pStream UNFORMATTED
    'END PROCEDURE.':u
    SKIP.

END PROCEDURE.

/*----------------------------------------------------------------------*/
PROCEDURE startProc:
  DEFINE INPUT-OUTPUT PARAMETER pCount AS INTEGER NO-UNDO.

  PUT STREAM pStream UNFORMATTED
    SKIP(1)
    'RUN ip':u pCount '.':u
    SKIP
    '/* ============================================================== */':u
    SKIP
    'PROCEDURE ip':u pCount ':':u
    SKIP.

  pCount = pCount + 1.
  
END PROCEDURE.

/* _awrite.i - end of file */


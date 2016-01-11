/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
*  _afwrite.p
*
*    This file creates the file that builds the VAR's structure over
*    RESULTS features.
*
*    writeRequest    0 Write if config is dirty and qbf-awrite is set
*                    1 Write if config is dirty, regardless of qbf-awrite
*                    2 Write regardless of bits
*/					   

{ aderes/s-system.i }
{ aderes/a-define.i }
{ aderes/_fdefs.i }

DEFINE INPUT PARAMETER writeRequest AS INTEGER NO-UNDO.

DEFINE VARIABLE featureFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE baseName    AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-l       AS LOGICAL   NO-UNDO. /* scrap */

/*
 * If the writeRequest is 0 then write out the configuration file. 
 * Otherwise check the state of the bits to see if we should write.
 */
IF writeRequest = 1 AND _featDirty = FALSE THEN RETURN.
ELSE IF writeRequest = 0
  AND NOT ((_featDirty = YES) AND (qbf-awrite = YES)) THEN RETURN.

RUN adecomm/_statdsp.p (wGlbStatus,1,"Creating Feature File...":t72).
RUN adecomm/_tmpfile.p ("r":u,"",OUTPUT featureFile).

/* If the adminMenuFile does not have a name then provide one. */
IF (_adminFeatureFile = ?) OR (_adminFeatureFile = "") THEN DO:

  ASSIGN
    baseName          = qbf-fastload
    _adminFeatureFile = baseName + "f.p":u
    .

  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"information":u,"ok":u,
    SUBSTITUTE("The feature file does not have a name.  &1 will provide the name &2.",qbf-product,_adminFeatureFile)).

  RUN adecomm/_setcurs.p("WAIT":u).
  _configDirty = TRUE.
  RUN aderes/_awrite.p(0).
END.
ELSE
  baseName = SUBSTRING(_adminFeatureFile, 1, 
               R-INDEX(_adminFeatureFile, ".":u) - 1,"CHARACTER":u).

/*
* First, make the version that we want customers to be able to
* recompile. This is needed if there is an r-code chagne. The users
* will be able to keep existing work. It must have a earlier date than
* the fastload verision
*/
RUN adeshar/_mwrite.p ({&resId}, _adminFeatureFile, "f":u, "p":u).

/* Create a temporary file */
RUN adeshar/_mwrite.p ({&resId}, featureFile + ".af":u, "f":u, "fp":u).
RUN adecomm/_statdsp.p (wGlbStatus, 1, "Compiling Feature File...":t72).

COMPILE VALUE(featureFile + ".af") SAVE.

IF COMPILER:ERROR = TRUE THEN
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
    SUBSTITUTE("There is a problem with compiling feature file during compile phase.  Saving the file as &1.af",featureFile)).
ELSE DO:
  RUN adecomm/_statdsp.p (wGlbStatus, 1, "Copying Feature File...":t72).
  OS-COPY VALUE(featureFile + ".r":u) VALUE(baseName + ".r":u).

  IF os-error > 0 THEN DO:
    DEFINE VARIABLE eText AS CHARACTER NO-UNDO.

    RUN adecomm/_oserr.p (OUTPUT eText).
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("There is a problem with saving the feature during copy phase.  &1.",eText)).
  END.
  
  /* Cleanup */
  &IF DEFINED(dont) = 0 &THEN
  OS-DELETE VALUE(featureFile + ".af":u).
  &ENDIF

  OS-DELETE VALUE(featureFile + ".r":u).
END.

ASSIGN
  _featDirty   = FALSE
  _writeReport = TRUE
  .
RUN adecomm/_statdsp.p(wGlbStatus, 1, "").

/* _afwrite.p - end of file */


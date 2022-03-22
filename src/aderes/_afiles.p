/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _afiles
*
*    Write out an ASCII file detailing the files that encompass the
*    Results application. This list includes all integration points,
*    deployment/fastload files, feature programs, icon files.
*
*    It doesn't include any information about query directories.
*
*    The flow of control has us loading up a temp table with all the files
*    and then writing out the temp table. This allow us to get all the info
*    at one time but then sort as needed
*/

{ aderes/s-system.i }
{ aderes/j-define.i }
{ aderes/a-define.i }

{ aderes/_fdefs.i }

DEFINE TEMP-TABLE _fileInfo
  FIELD _fileType AS CHARACTER
  FIELD _fileDesc AS CHARACTER
  FIELD _fileName AS CHARACTER
  .

DEFINE VARIABLE cScrap      AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i       AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-c       AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-d       AS CHARACTER NO-UNDO.
DEFINE VARIABLE upImage     AS CHARACTER NO-UNDO.
DEFINE VARIABLE tUpImage    AS CHARACTER NO-UNDO.
DEFINE VARIABLE func        AS CHARACTER NO-UNDO.
DEFINE VARIABLE jChar       AS CHARACTER NO-UNDO.
DEFINE VARIABLE jHandle     AS HANDLE    NO-UNDO.
DEFINE VARIABLE jLogical    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE jInt        AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE userDefined AS LOGICAL   NO-UNDO.

DEFINE STREAM fStream.

/* Only do the work if something has changed.  */
IF _writeReport = FALSE THEN
  RETURN.

RUN adecomm/_statdsp.p(wGlbStatus, 1, "Writing Deployment Report...").

/* Results.l. Check for it in aderes. If there then find. Else look for it in
 * in the path. */
qbf-c = "aderes/results.l":u.
IF SEARCH(qbf-c) = ? THEN DO:
  qbf-c = "results.l":u.
  IF SEARCH(qbf-c) = ? THEN
    qbf-c = qbf-c + " **** NOT FOUND ****".
END.

RUN makeRec("baseResourceFile":u, ?, qbf-c).

/* Now come the database(s) */
DO qbf-i = 1 TO NUM-ENTRIES(qbf-dbs):
  RUN makeRec("database":u, STRING(qbf-i), ENTRY(qbf-i, qbf-dbs)).
END.

/* The configuration file. Do not include fastload files for this release.
 * The documented deployment process will have the fastload files built at 
 * the site. */
RUN makeRec("configurationFile":u, "ascii":u, qbf-qcfile + {&qcExt}).

/* Now the feature and UI files */
IF _adminFeatureFile <> "" THEN DO:

  /* Show both the .p and .r file.  */
  RUN makePfile("configurationFile":u, "featureFile":u,
                _adminFeatureFile, "AltSrc":u).
END.

IF _adminMenuFile <> "" THEN 
  /* Show both the .p and .r file.  */
  RUN makePfile("configurationFile":u,"menuFile":u,_adminMenuFile,"AltSrc":u).

/*
* Get all of the features, first the Results core features and then the
* admin defined features.
*/
RUN adeshar/_mgetfl.p({&resid}, FALSE, OUTPUT qbf-c).

DO qbf-i = 1 TO NUM-ENTRIES(qbf-c):
  qbf-d = ENTRY(qbf-i, qbf-c).
  RUN adeshar/_mgetf.p({&resId}, qbf-d,
                       OUTPUT jChar,
                       OUTPUT jChar,
                       OUTPUT func,
                       OUTPUT jChar,
                       OUTPUT upImage,
                       OUTPUT cScrap,
                       OUTPUT cScrap,
                       OUTPUT jChar,
                       OUTPUT jChar,
                       OUTPUT userDefined,
                       OUTPUT qbf-s).

  IF (userDefined = TRUE) AND (func <> "") THEN DO:
    RUN makePfile("featureFile":u, qbf-d, ENTRY(2,func), "Src").
    IF upImage <> "" THEN
      RUN makeImage("defaultIcon":u, qbf-d, upImage).
  END.

  /*
  * Now see if there is a toolbar button out there. It may have a
  * different image than the default for the feature.
  */
  RUN adeshar/_mgett2.p({&resId}, qbf-d,
                        {&resToolbar},
                        OUTPUT tUpImage,
                        OUTPUT cScrap,
                        OUTPUT cScrap,
                        OUTPUT jChar,
                        OUTPUT jLogical,
                        OUTPUT jChar,
                        OUTPUT jInt,
                        OUTPUT jInt,
                        OUTPUT jInt,
                        OUTPUT jInt,
                        OUTPUT jHandle,
                        OUTPUT jHandle,
                        OUTPUT qbf-s).

  IF NOT qbf-s THEN NEXT.

  IF (tUpImage <> "") AND (tUpImage <> upImage) THEN
    RUN makeImage("toobarIcon":u, qbf-d, tUpImage).
END.

/* The minimize logo */
IF (_minLogo <> "") AND (ENTRY(1,_minLogo,".":u) <> "adeicon/results%":u) THEN
  RUN makeImage("logoIcon":u, ?, _minLogo).

/* The integration points */
DO qbf-i = 1 TO EXTENT(qbf-u-hook):
  IF qbf-u-hook[qbf-i] = ? THEN NEXT.
  RUN makePfile("integrationPoint":u, ENTRY(qbf-i, {&ahQcNames}),
                qbf-u-hook[qbf-i], "Src":u).
END.

/* Now it is time to write out the file */
qbf-c = qbf-fastload + ".txt":u.

OUTPUT STREAM fStream TO VALUE(qbf-c) NO-ECHO.

problemo:
DO ON ERROR UNDO problemo, RETRY problemo:
  IF RETRY THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-s,"error":u,"ok":u,
      SUBSTITUTE("There is a problem writing &1.  The file will not be created.",qbf-c)).

    RETURN.
  END.

  PUT STREAM fStream UNFORMATTED
    '# PROGRESS RESULTS Deployed APPLICATION FileList' SKIP
    '# This reports does NOT provide Public QUERY Directory Information'
    SKIP(2)
    .

  FOR EACH _fileInfo BY _fileType BY _fileDesc BY _fileName:
    PUT STREAM fStream UNFORMATTED _fileType.
    IF _fileDesc <> ? THEN
    PUT STREAM fStream UNFORMATTED ':':u _fileDesc.
    PUT STREAM fStream UNFORMATTED '= ':u _fileName SKIP.
  END.
END. /* problemo */

OUTPUT STREAM fStream CLOSE.

RUN adecomm/_statdsp.p(wGlbStatus, 1, "").

RETURN.

/*-------------------------------------------------------------------------*/
PROCEDURE makeImage:
  DEFINE INPUT PARAMETER fType AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER fDesc AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER fName AS CHARACTER NO-UNDO.

  DEFINE VARIABLE ext     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO.

  /* Let's figure out which file it is.  */
  &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
  ext = ".bmp":U.
  &ELSE
  ext = ".xbm":U.
  &ENDIF

  qbf-c = fName + ext.

  IF SEARCH(qbf-c) = ? THEN DO:
    /* The first type wasn't found. Let's try the second.  */
    &IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
    ext = ".ico":u.
    &ELSE
    ext = ".xpm":u.
    &ENDIF
  
    qbf-c = fName + ext.
  
    /* We didn't find the file. Dump out info to that effect in the output.  */
    IF SEARCH(qbf-c) = ? THEN 
      qbf-c = qbf-c + " **** FILE NOT FOUND ****".
  END.

  RUN makeRec(fType, fDesc, qbf-c).
END.

/*-------------------------------------------------------------------------*/
PROCEDURE makePfile:
  DEFINE INPUT PARAMETER fType AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER fDesc AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER fName AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER mText AS CHARACTER NO-UNDO.

  DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.

  RUN makeRec(fType + mText, fDesc, fName).

  qbf-c = ENTRY(1, fName, ".":u).

  /* Again, no r-code in deployment report for this release
  RUN makeRec(fType, fDesc, qbf-c + ".r":u).
  */
END.

/*-------------------------------------------------------------------------*/
PROCEDURE makeRec.
  DEFINE INPUT PARAMETER fType AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER fDesc AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER fName AS CHARACTER NO-UNDO.

  CREATE _fileInfo.
  ASSIGN
    _fileInfo._fileType = fType
    _fileInfo._fileDesc = fDesc
    _fileInfo._fileName = fName
    .
END.

/* _afiles.p - end of file */


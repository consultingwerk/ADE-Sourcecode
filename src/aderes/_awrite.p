/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _awrite.p - write out configuration (.qc[n]) file
 *
 *       _awrite is responsible for writing the configuration file, but
 *       also the fastload versions of the configuration file. To
 *       improve startup performance, there are multiple fastload files.
 *       Each one takes a piece of the configuration file.
 *
 *       To make management of these multiple files easier, the AP
 *       provides up to 7 characters as a deployment name.  RESULTS will
 *       create unique names by adding a final character.
 * 
 *       The fastload files:
 *
 *         r - Relationships & tables
 *         s - Information that must provided at startup.
 *
 * Note: This file is not only called by various RESULTS files, but is called
 *       from the TTY to GUI RESULTS converter. Although most format changes
 *       won't affect the converter most datastructure changes will!
 *
 *       None of the buffer searches use the "standard" as defined in
 *       j-define. The reason is that the writing code must be able to
 *       write out all the information, even if the current user isn't
 *       privy to it all.
 *
 * Input Parameters
 *
 *    writeRequest    0 Write if config is dirty and qbf-awrite is set
 *                    1 Write if config is dirty, regardless of qbf-awrite
 *                    2 Write regardless of bits
 */						

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/r-define.i }
/*{ aderes/t-define.i }*/
{ aderes/l-define.i }
{ aderes/e-define.i }
{ aderes/j-define.i }
{ aderes/s-output.i }
{ aderes/a-define.i }
{ aderes/_fdefs.i }

DEFINE INPUT PARAMETER writeRequest AS INTEGER NO-UNDO.

DEFINE VARIABLE qbf-a       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-c       AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i       AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j       AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k       AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-o       AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-s       AS DECIMAL   NO-UNDO.
DEFINE VARIABLE qbf-t       AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-w       AS INTEGER   NO-UNDO.
DEFINE VARIABLE blockSize   AS INTEGER   NO-UNDO INITIAL 100.
DEFINE VARIABLE i           AS INTEGER   NO-UNDO.
DEFINE VARIABLE pCount      AS INTEGER   NO-UNDO.
DEFINE VARIABLE qcName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE pName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE pBase       AS CHARACTER NO-UNDO.
DEFINE VARIABLE pLine       AS CHARACTER NO-UNDO.
DEFINE VARIABLE fCount      AS INTEGER   NO-UNDO.
DEFINE VARIABLE dName       AS CHARACTER NO-UNDO.
DEFINE VARIABLE currentFile AS CHARACTER NO-UNDO.

DEFINE VARIABLE cJunk       AS CHARACTER NO-UNDO.
DEFINE VARIABLE joinString  AS CHARACTER NO-UNDO.
DEFINE VARIABLE whereId     AS INTEGER   NO-UNDO.
DEFINE VARIABLE relatedId   AS INTEGER   NO-UNDO.
DEFINE VARIABLE tableId     AS INTEGER   NO-UNDO.
DEFINE VARIABLE lText       AS CHARACTER NO-UNDO.
DEFINE VARIABLE rText       AS CHARACTER NO-UNDO.

DEFINE STREAM qcStream.
DEFINE STREAM pStream.

/* If the writeRequest is 0 then write out the configuration file. Otherwise
 * check the state of the bits to see if we should write. */
IF writeRequest = 1 AND _configDirty = FALSE THEN RETURN.
ELSE IF writeRequest = 0
  AND NOT ((_configDirty = YES) AND (qbf-awrite = YES)) THEN RETURN.

/* Set up the 2 streams. Write out the ASCII to qbf5. Write out the .p to
   qbf6. Clean up later. */
RUN adecomm/_statdsp.p (wGlbStatus,1,"Building Configuration Files...":t72).
ASSIGN
  qcName       = qbf-tempdir + "5.d":u
  pBase        = qbf-tempdir + "6":u
  pName        = pBase + ".d":u
  _configDirty = FALSE
  _writeReport = TRUE
  .

problemo:
DO ON ERROR UNDO problemo, RETRY problemo:
  IF RETRY THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
      SUBSTITUTE("There is a problem writing &1. The file will not be created.",
      qcName)).

    RETURN.
  END.

  OUTPUT STREAM qcStream TO VALUE(qcName) NO-ECHO.

  /* Write out the basic header information. This is only written to the
   * configuration file. The first few lines of the configuration file
   * are always read. Then, if there is a compiled configuration file the
   * switch is made to reading the compiled configuration file. */
  PUT STREAM qcStream UNFORMATTED
    '/*':u SKIP
    '# PROGRESS RESULTS system administrator configuration file':u SKIP
    'config= sysadmin':u SKIP
    'version= ':u qbf-vers SKIP
    .

  /* Dump out the checkdb flag. This flag allows the application to avoid
   * the CRC check. Of course, the application takes all responsibility 
   * for keeping the config files in synch with the database(s).  Also, this 
   * flag isn't written out to compiled versions, as the compiled versions 
   * aren't read until after the db CRCs are done. */
  PUT STREAM qcStream UNFORMATTED
    'checkdb= "':u (IF qbf-checkdb THEN 'true':u ELSE 'false':u) '"':u SKIP.

  /* Do the database information before fastload. This allows us to know now
   * if an application rebuild is needed. */
  DO qbf-i = 1 TO NUM-ENTRIES(qbf-dbs):
    qbf-t = ENTRY(qbf-i,qbf-dbs).
    RUN aderes/s-schema.p (qbf-t, "", "", "DB:CRC":u, OUTPUT qbf-o).
    PUT STREAM qcStream CONTROL 'database[':u string(qbf-i) ']= ':u.
    EXPORT STREAM qcStream qbf-t DBTYPE(qbf-t) DECIMAL(qbf-o).
  END.

  /* From here on out all information is written in both formats. Set up the
   * initial information in the pStream before continuing! */
  currentFile = qbf-fastload + {&flStartupExt} + ".r":u.
  RUN startFile (pName, INPUT-OUTPUT pCount, "", currentFile).
  RUN adecomm/_statdsp.p (wGlbStatus,1,"Writing Startup Information...":t72).

  /* Write out the integration procedures */
  PUT STREAM pStream UNFORMATTED ' ASSIGN':u SKIP.

  DO qbf-i = 1 TO EXTENT(qbf-u-hook):
    IF qbf-u-hook[qbf-i] = ? THEN NEXT.

    PUT STREAM qcStream UNFORMATTED 
      'hook.':u ENTRY(qbf-i, {&ahQcNames}) '= ':u.
    EXPORT STREAM qcStream qbf-u-hook[qbf-i].

    PUT STREAM pStream UNFORMATTED 
      '  qbf-u-hook[':u qbf-i '] = ':u.
    EXPORT STREAM pStream qbf-u-hook[qbf-i].
  END.
  PUT STREAM pStream UNFORMATTED
    ' .':u SKIP(1).

  /* FastLoad is only in the configuration file. The configurationfile is
   * read first. When the FastLoad line is hit then transfer is switched to 
   * the fastload file. */
  IF qbf-fastload <> "" THEN
    PUT STREAM qcStream UNFORMATTED 'fastload= "':u qbf-fastload '"':u SKIP.

  PUT STREAM pStream UNFORMATTED
    '/*PROGRESS RESULTS ':u 'Fastload Startup file' '*/':u SKIP.

  /* Now, back to writing out the the attributes. We have to write stuff so
   * that the ASSIGN statement can be used. */
  PUT STREAM pStream UNFORMATTED ' ASSIGN':u SKIP.

  PUT STREAM qcStream UNFORMATTED
    'goodbye= "':u (IF qbf-goodbye THEN 'quit':u ELSE 'return':u) '"':u SKIP.
  PUT STREAM pStream UNFORMATTED '  qbf-goodbye = ':u qbf-goodbye SKIP.

  PUT STREAM qcStream UNFORMATTED
    'threed= "':u (IF qbf-threed THEN 'true':u ELSE 'false':u) '"':u SKIP.
  PUT STREAM pStream UNFORMATTED '  qbf-threed = ':u qbf-threed SKIP.

  PUT STREAM qcStream UNFORMATTED
    'status-area= "':u (IF lGlbStatus THEN 'true':u ELSE 'false':u) '"':u SKIP.
  PUT STREAM pStream UNFORMATTED '  lGlbStatus  = ':u lGlbStatus SKIP.

  PUT STREAM qcStream UNFORMATTED
    'toolbar= "':u (IF lGlbToolbar THEN 'true':u ELSE 'false':u) '"':u SKIP.
  PUT STREAM pStream UNFORMATTED '  lGlbToolbar = ':u lGlbToolbar SKIP.

  PUT STREAM qcStream UNFORMATTED
   'writeconfig= "':u (IF qbf-awrite THEN 'true':u ELSE 'false':u) '"':u SKIP.
  PUT STREAM pStream UNFORMATTED '  qbf-awrite = ':u qbf-awrite SKIP.

  PUT STREAM qcStream UNFORMATTED 'product= ':u.
  EXPORT STREAM qcStream qbf-product.
  PUT STREAM pStream UNFORMATTED '  qbf-product = ':u.
  EXPORT STREAM pStream qbf-product.

  PUT STREAM qcStream UNFORMATTED 'public-directory= ':u.
  EXPORT STREAM qcStream qbf-qdpubl.
  PUT STREAM pStream UNFORMATTED '  qbf-qdpubl = ':u.
  EXPORT STREAM pStream qbf-qdpubl.

  /* If the delimiter char is "{" then put a ~ in fornt of it. Otherwise the
   * compiler will get confused. */
  ASSIGN qbf-c = IF qbf-left = "~{":u THEN "~~":u + qbf-left ELSE qbf-left.
  PUT STREAM qcStream UNFORMATTED 'left-delim= ':u.
  EXPORT STREAM qcStream qbf-left.
  PUT STREAM pStream UNFORMATTED '  qbf-left = ':u.
  EXPORT STREAM pStream qbf-c.

  ASSIGN qbf-c = IF qbf-right = "~{":u THEN "~~":u + qbf-right ELSE qbf-right.
  PUT STREAM qcStream UNFORMATTED 'right-delim= ':u.
  EXPORT STREAM qcStream qbf-right.
  PUT STREAM pStream UNFORMATTED '  qbf-right = ':u.
  EXPORT STREAM pStream qbf-c.

  PUT STREAM pStream UNFORMATTED
    ' .':u SKIP(1).

  IF (_adminFeatureFile <> ?) AND (_adminFeatureFile <>  "") THEN DO:
    /* There is a feature file defined. Use it */
    PUT STREAM qcStream UNFORMATTED 'feature-file= ':u.
    EXPORT STREAM qcStream _adminFeatureFile.

    PUT STREAM pStream UNFORMATTED
      ' RUN aderes/af-aff.p ("adminFeature", "':u
      _adminFeatureFile '").':u SKIP.
  END.
  ELSE
    /* There is no feature file defined. For the configuraiton file that is
     * OK, _aread.p will take care of it. For the fastload file, load the
     * default set of results features. */
    PUT STREAM pStream UNFORMATTED
      'RUN aderes/af-init.p.':u SKIP.

  IF _adminMenuFile <> ? AND _adminMenuFile <> "" THEN DO:
    PUT STREAM qcStream UNFORMATTED 'menu-file= ':u.
    EXPORT STREAM qcStream _adminMenuFile.

    PUT STREAM pStream UNFORMATTED
      ' RUN aderes/af-aff.p ("adminMenu", "':u _adminMenuFile '").':u SKIP.
  END.

  /* Write out more attributes */
  IF _minLogo <> "" THEN DO:
    PUT STREAM qcStream UNFORMATTED 'minlogo= ':u.
    EXPORT STREAM qcStream _minLogo.
    PUT STREAM pStream UNFORMATTED 
      ' RUN aderes/af-aff.p ("minLogo", "':u
      _minLogo '").':u SKIP.
  END.

  PUT STREAM pStream UNFORMATTED ' ASSIGN':u SKIP.

  /* Write auto-select field list for mailing labels */
  RUN adecomm/_statdsp.p (wGlbStatus,1,"Writing Default Labels...":t72).

  PUT STREAM qcStream UNFORMATTED '#':u SKIP.

  DO qbf-i = 1 to 10:
    PUT STREAM qcStream UNFORMATTED 'label-':u
      ENTRY(qbf-i,"name,addr1,addr2,addr3,city,state,zip,zip+4,csz,country":u)
      '= ':u.
    EXPORT STREAM qcStream qbf-l-auto[qbf-i].
    PUT STREAM pStream UNFORMATTED '  qbf-l-auto[':u qbf-i '] = ':u.
    EXPORT STREAM pStream qbf-l-auto[qbf-i].
  END.

  PUT STREAM pStream UNFORMATTED ' .':u SKIP.

  /* For clarity, create an internal procedure for labels and exports. */
  RUN endProc (INPUT-OUTPUT i).

  RUN startProc (INPUT-OUTPUT pCount).

  /* Write label types */
  PUT STREAM pStream UNFORMATTED ' ASSIGN':u SKIP.

  DO qbf-i = 1 TO EXTENT(qbf-l-cat) WHILE qbf-l-cat[qbf-i] <> "":
    PUT STREAM qcstream UNFORMATTED SUBSTITUTE('label.size[&1]= ':u,qbf-i).
    EXPORT STREAM qcstream qbf-l-cat[qbf-i].

    PUT STREAM pStream UNFORMATTED '  qbf-l-cat[':u qbf-i '] = ':u.
    EXPORT STREAM pStream qbf-l-cat[qbf-i].
  END.

  PUT STREAM pStream UNFORMATTED ' .':u SKIP.

  /* Write export types */
  RUN adecomm/_statdsp.p (wGlbStatus,1,"Writing Export Information...":t72).
  PUT STREAM pStream UNFORMATTED ' ASSIGN':u SKIP.

  PUT STREAM qcStream UNFORMATTED '#':u SKIP.

  DO qbf-i = 1 TO EXTENT(qbf-e-cat) WHILE qbf-e-cat[qbf-i] <> "":
    PUT STREAM qcStream UNFORMATTED SUBSTITUTE('export.type[&1]= ':u,qbf-i).
    EXPORT STREAM qcStream qbf-e-cat[qbf-i].

    PUT STREAM pStream UNFORMATTED '  qbf-e-cat[':u qbf-i '] = ':u.
    EXPORT STREAM pStream qbf-e-cat[qbf-i].
  END.

  PUT STREAM pStream UNFORMATTED ' .':u SKIP.

  /* For clarity, create an internal procedure for security -OB */
  RUN endProc (INPUT-OUTPUT i).

  RUN StartProc (INPUT-OUTPUT pCount).
  PUT STREAM qcStream UNFORMATTED '#':u SKIP.

  /* Write out security info into the fastload.  */
  DEFINE VARIABLE securityList AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fName        AS CHARACTER NO-UNDO.

  RUN adecomm/_statdsp.p (wGlbStatus, 1,
  "Writing Security Information...":t72).
  RUN adeshar/_mgetfl.p ({&resId}, TRUE, OUTPUT qbf-o).

  DO qbf-k = 1 TO NUM-ENTRIES(qbf-o):
    fName = ENTRY(qbf-k, qbf-o).

    /* Get the corresponding information stored in the menu feature */
    RUN adeshar/_mgetu.p ({&resId}, fName, OUTPUT securityList, OUTPUT qbf-a).

    qbf-c = (IF securityList = "" OR securityList = ? THEN '*':u
             ELSE securityList).

    PUT STREAM qcStream UNFORMATTED 'security.':u fName '= ':u.
    EXPORT STREAM qcStream qbf-c.

    /* For now, don't write out to fastload. This information is written out
     * in the feature file. So no sense in duplicating.  The other reason is 
     * that I couldn't generate any code without _adminFeatureFile.  Since 
     * that name won't compile and time is now short, just don't write out 
     * the information.

    PUT STREAM pStream UNFORMATTED
      ' RUN adeshar/_msetu.p ("':u {&resId} '", "':u fName '", "':u qbf-c
      '", OUTPUT s).':u SKIP.
     */

    i = i + 1.
    IF i = blockSize THEN DO:
      RUN endProc (INPUT-OUTPUT i).
      RUN startProc (INPUT-OUTPUT pCount).
    END.
  END. /* NUM-ENTRIES(qbf-o) */

  /* For clarity, create an internal procedure for reports */
  RUN endProc (INPUT-OUTPUT i).

  RUN startProc (INPUT-OUTPUT pCount).

  /* When _aread is started it blows away all the report stuff.  */
  RUN adecomm/_statdsp.p (wGlbStatus, 1, "Writing Report Information...":t72).

  FIND FIRST qbf-rsys WHERE NOT qbf-rsys.qbf-live NO-ERROR.
  PUT STREAM pStream UNFORMATTED
    ' FIND FIRST qbf-rsys.':u SKIP
    ' ASSIGN':u SKIP
    .
  PUT STREAM qcStream UNFORMATTED '#':u SKIP.

  PUT STREAM qcStream control 'report.format= ':u.
  EXPORT STREAM qcStream qbf-rsys.qbf-format.
  PUT STREAM pStream UNFORMATTED '  qbf-rsys.qbf-format = ':u.
  EXPORT STREAM pStream qbf-rsys.qbf-format.

  PUT STREAM qcStream control 'report.dimension= ':u.
  EXPORT STREAM qcStream qbf-rsys.qbf-dimen.
  PUT STREAM pStream UNFORMATTED '  qbf-rsys.qbf-dimen = ':u.
  EXPORT STREAM pStream qbf-rsys.qbf-dimen.

  PUT STREAM qcStream UNFORMATTED
    'report.left-margin= ':u    qbf-rsys.qbf-origin-hz   SKIP
    'report.page-size= ':u      qbf-rsys.qbf-page-size   SKIP
    'report.column-spacing= ':u qbf-rsys.qbf-space-hz    SKIP
    'report.line-spacing= ':u   qbf-rsys.qbf-space-vt    SKIP
    'report.top-margin= ':u     qbf-rsys.qbf-origin-vt   SKIP
    'report.before-body= ':u    qbf-rsys.qbf-header-body SKIP
    'report.after-body= ':u     qbf-rsys.qbf-body-footer SKIP
    .

  PUT STREAM pStream UNFORMATTED
    '  qbf-rsys.qbf-origin-hz   = ':u qbf-rsys.qbf-origin-hz   SKIP
    '  qbf-rsys.qbf-page-size   = ':u qbf-rsys.qbf-page-size   SKIP
    '  qbf-rsys.qbf-width       = ':u qbf-rsys.qbf-width       SKIP
    '  qbf-rsys.qbf-space-hz    = ':u qbf-rsys.qbf-space-hz    SKIP
    '  qbf-rsys.qbf-space-vt    = ':u qbf-rsys.qbf-space-vt    SKIP
    '  qbf-rsys.qbf-origin-vt   = ':u qbf-rsys.qbf-origin-vt   SKIP
    '  qbf-rsys.qbf-header-body = ':u qbf-rsys.qbf-header-body SKIP
    '  qbf-rsys.qbf-body-footer = ':u qbf-rsys.qbf-body-footer SKIP
    .

  DO qbf-i = 1 TO 10:
    FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = - qbf-i NO-ERROR.

    IF NOT AVAILABLE qbf-hsys THEN NEXT.
    qbf-c = ENTRY(qbf-i,"top-left,top-center,top-right,":u
          + "bottom-left,bottom-center,bottom-right,":u
          + "first-only,last-only,cover-page,final-page":u).

    DO qbf-j = 1 TO EXTENT(qbf-hsys.qbf-htxt):
      IF qbf-hsys.qbf-htxt[qbf-j] = "" THEN NEXT.
      PUT STREAM qcStream CONTROL 'report.':u qbf-c '[':u qbf-j ']= ':u.
      EXPORT STREAM qcStream qbf-hsys.qbf-htxt[qbf-j].
    END.
  END.

  PUT STREAM pStream UNFORMATTED ' .':u SKIP.

  /* Write out paper sizes.  For clarity, create an internal procedure
     for reports. */
  RUN endProc (INPUT-OUTPUT i).

  RUN startProc (input-output pCount).

  PUT STREAM pStream UNFORMATTED ' ASSIGN':u SKIP.

  DO qbf-i = 1 TO EXTENT(qbf-p-cat) WHILE qbf-p-cat[qbf-i] <> "":
    PUT STREAM qcstream CONTROL SUBSTITUTE('page.size[&1]= ':u,qbf-i).
    EXPORT STREAM qcstream qbf-p-cat[qbf-i].

    PUT STREAM pStream UNFORMATTED '  qbf-p-cat[':u qbf-i '] = ':u.
    EXPORT STREAM pStream qbf-p-cat[qbf-i].
  END.

  PUT STREAM pStream UNFORMATTED ' .':u SKIP.

  PUT STREAM qcStream UNFORMATTED '#':u SKIP.

  RUN adecomm/_statdsp.p (wGlbStatus,1,"Writing Relationships...":t72).

  /* Write out the table aliases only to ascii configuration file. The 
   * compiled information will be written out with the tables. */
  FOR EACH qbf-rel-buf USE-INDEX tnameix:
    IF qbf-rel-buf.sid <> ? THEN DO:

      /* Got a table alias. */
      FIND qbf-rel-buf2 WHERE qbf-rel-buf2.tid = qbf-rel-buf.sid.

      PUT STREAM qcstream CONTROL 'talias.':u qbf-rel-buf.tname '= ':u.
      EXPORT STREAM qcstream qbf-rel-buf2.tname.
    END.
  END.

  PUT STREAM qcStream UNFORMATTED '#':u SKIP.

  qbf-k = 1.

  /* Write out the ASCII configuration file form of the relationships. */
  FOR EACH qbf-rel-buf USE-INDEX tnameix:
    tableId = qbf-rel-buf.tid.

    /* Now write out the relation info in a more human readable form.  To
     * minimize the number of lines generated in the configuration file
     * write out as much information on one line as possible. */
    DO qbf-j = 2 TO NUM-ENTRIES(qbf-rel-buf.rels):
      qbf-c = ENTRY(qbf-j,qbf-rel-buf.rels).

      RUN breakJoinInfo (qbf-c,OUTPUT relatedId,OUTPUT joinString,
                         OUTPUT cJunk,OUTPUT whereId).
      lText = "".
      IF whereId <> 0 THEN DO:
        {&FIND_WHERE_BY_ID} whereId NO-ERROR.
        IF AVAILABLE qbf-rel-whr THEN
          lText = qbf-rel-whr.jwhere.
      END.

      /* If the tableId is less than the relatedId then we haven't analyzed 
       * the nature of the relationship(s) yet. */
      RUN isCummunative (tableId,relatedId,OUTPUT qbf-c,OUTPUT whereId).

      IF qbf-c <> "" THEN DO:
        IF relatedId < tableId THEN NEXT.
        /* The tables have a "cummunative" relationship. Get the other WHERE 
           clause if it's different from the "left" side. */

        rText = "".
        IF whereId <> 0 THEN DO:
          {&FIND_WHERE_BY_ID} whereId NO-ERROR.
          IF AVAILABLE qbf-rel-whr AND
            lText <> qbf-rel-whr.jwhere THEN
            rText = qbf-rel-whr.jwhere.
        END.
      END.
      ELSE
        /* Table 1, represented by tableId, is related to table 2.  But table 
         * 2 is not related to table 1. */
        rText = "X":u.

      /* Insure that no unkown values get written out. */
      IF lText = ? THEN lText = "".
      IF rText = ? THEN rText = "".

      PUT STREAM qcStream UNFORMATTED 'relat[':u qbf-k ']= ':u.
      EXPORT STREAM qcStream qbf-rel-buf.tname TRIM(joinString)
        qbf-rel-buf2.tname lText rText.

      qbf-k = qbf-k + 1.
    END.
  END. /* FOR EACH qbf-rel-buf */
  
  PUT STREAM qcStream UNFORMATTED '#':u SKIP.

  FOR EACH _tableWhere:
    IF (_tableWhere._text = ?) OR (_tableWhere._text = "") THEN NEXT.

    FIND qbf-rel-buf WHERE qbf-rel-buf.tid = _tableWhere._tableId.
    PUT STREAM qcstream CONTROL 'restriction= ':u.
    EXPORT STREAM qcStream qbf-rel-buf.tname _tableWhere._text.
  END.

  /* Finished with the startup configuation fastload file. Close it before 
   * going on to relationships. */
  RUN endFile (INPUT-OUTPUT i,"").
  RUN compileFastload (pBase,currentFile).

  /* Write out the fastload version of the relation/database information. */
  RUN aderes/_arwrite.p (pName,pBase).

  /* The files have been written out. Close shop and cleanup */
  PUT STREAM qcStream UNFORMATTED '*/':u SKIP.
  OUTPUT STREAM qcStream CLOSE.

  /* 1) New Config file is qbf5.d
   * 2) if old configuration file exists, copy it to qbf.d as backup
   * 3) copy qbf5.d over dbname{&qcExt}
   */
  ASSIGN
    qbf-c = SEARCH(qbf-qcfile + {&qcExt})
    qbf-a = (qbf-c = ?)
    qbf-c = (IF qbf-a THEN qbf-qcfile + {&qcExt} ELSE qbf-c)
    qbf-t = qbf-tempdir + ".d":u.

  IF NOT qbf-a THEN
    OS-COPY VALUE(qbf-c) VALUE(qbf-t).
  OS-COPY VALUE(qbf-tempdir + "5.d":u) VALUE(qbf-c).
  OS-DELETE VALUE(qcName).

  RUN adecomm/_statdsp.p (wGlbStatus,1,"").
END. /* problemo */

RETURN.

/* Internal procedure for file management */
{ aderes/_awrite.i }
{ aderes/_jbkjoin.i }

/*----------------------------------------------------------------------*/
PROCEDURE isCummunative:
  DEFINE INPUT  PARAMETER tableId   AS INTEGER   NO-UNDO.
  DEFINE INPUT  PARAMETER relatedId AS INTEGER   NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf-s     AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER whereId   AS INTEGER   NO-UNDO.

  FIND qbf-rel-buf2 WHERE qbf-rel-buf2.tid = relatedId NO-ERROR.

  DO qbf-i = 1 TO NUM-ENTRIES(qbf-rel-buf2.rels):
    RUN breakJoinInfo (ENTRY(qbf-i, qbf-rel-buf2.rels),
                       OUTPUT qbf-w, OUTPUT cJunk,
                       OUTPUT cJunk, OUTPUT whereId).

    IF qbf-w = tableId THEN DO:
      qbf-s = ENTRY(qbf-i, qbf-rel-buf2.rels).
      LEAVE.
    END.
  END.
END PROCEDURE.

/* _awrite.p - end of file */


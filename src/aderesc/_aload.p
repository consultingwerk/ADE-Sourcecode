/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *  _aload.p - do system initialization and read in TTY .qc file
 */

{ aderes/s-system.i }
{ aderes/a-define.i }
{ aderes/_fdefs.i   }
{ aderes/s-define.i }
{ aderes/r-define.i }
{ aderes/j-define.i }
{ adeshar/_mnudefs.i }
{ aderes/i-define.i }

/* djl qbf-k was used as Checkpoint detected flag.  Set to TRUE if checkpoint
 * symbol found in v6. We don't need it for that, but do need to know if
 * the read went smoothly. So I'll use the parameter that was passed out.
 */

DEFINE OUTPUT PARAMETER goodRead  AS LOGICAL   NO-UNDO INITIAL TRUE.
DEFINE OUTPUT PARAMETER writeWhat AS CHARACTER NO-UNDO.

DEFINE SHARED VARIABLE microqbf   AS LOGICAL   NO-UNDO.
DEFINE SHARED VARIABLE ttyApp     AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE outDir     AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE appName    AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE appDir     AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE initDb     AS LOGICAL   NO-UNDO.

DEFINE VARIABLE qbf-c        AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-d        AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-h        AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i        AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l        AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-m        AS CHARACTER NO-UNDO EXTENT 11.
DEFINE VARIABLE qbf-s        AS LOGICAL   NO-UNDO. /* abort of some kind */
DEFINE VARIABLE qbf-q        AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-v        AS CHARACTER NO-UNDO.
DEFINE VARIABLE lbl-field    AS INTEGER   NO-UNDO EXTENT  7.
DEFINE VARIABLE logName      AS CHARACTER NO-UNDO.
DEFINE VARIABLE fCount       AS INTEGER   NO-UNDO.
DEFINE VARIABLE fName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE tName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE dName        AS CHARACTER NO-UNDO.
DEFINE VARIABLE junk         AS CHARACTER NO-UNDO.
DEFINE VARIABLE queNumber    AS INTEGER   NO-UNDO.

/* fastload 0=ok 1=schema change 2=version mismatch */
DEFINE VARIABLE qbf-f AS INTEGER NO-UNDO.

DEFINE STREAM qbf-io.
DEFINE STREAM logStream.

FIND FIRST qbf-rsys.

ASSIGN
  writeWhat    = "qc7,,,":u
  qbf-dir-ent# = 0
  qbf-h        = "first-only=,,,last-only=,,,":u
               + "top-left=,,,top-center=,,,top-right=,,,":u
               + "bottom-left=,,,bottom-center=,,,bottom-right=,,,":u
               + "left-margin=,page-size=,column-spacing=,line-spacing=,":u
               + "top-margin=,before-body=,after-body=":u
  qbf-q        = "next,prev,first,last,add,update,copy,delete,view,browse,":u
               + "join,query,where,total,order,module,info,user,exit":u
  qbf-l        = "name=,addr1=,addr2=,addr3=,city=,":u
               + "state=,zip=,zip+4=,csz=,country=":u
  qbf-c        = appDir + appName
  .

/* open TTY configuration file for reading */
INPUT STREAM qbf-io FROM VALUE(ttyApp) NO-ECHO.

ASSIGN
  qbf-qdfile = outDir + "public.qd7":u /* for forms in QC file */
  qbf-qdpubl = outDir + "public.qd7":u
  logName    = outDir + LDBNAME(1) + ".qcl":u
  .

/* open configuration logfile for writing */		     
OUTPUT STREAM logStream TO VALUE(logName) NO-ECHO.

/* Load list of db tables */
/*IF (initDb = FALSE) THEN DO:*/
IF qbf-rel-tbl# = 0 THEN DO:
  RUN aderes/j-init.p (?).
  initDb = TRUE.
END.

REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.

  IF INDEX(qbf-m[1],"=":u) = 0 
    OR qbf-m[1] BEGINS "#":u
    OR qbf-m[1] = "message=":u THEN NEXT.

  PUT STREAM logStream UNFORMATTED
    qbf-m[1] ' ':u qbf-m[2] ' ':u qbf-m[3] ' ':u 
    qbf-m[4] ' ':u qbf-m[5] ' ':u qbf-m[6] ' ':u.

  IF qbf-m[1] BEGINS "form":u THEN
    PUT STREAM logStream UNFORMATTED SKIP '    ':u.

  PUT STREAM logStream UNFORMATTED
    qbf-m[7]  ' ':u qbf-m[8]  ' ':u qbf-m[9] ' ':u 
    qbf-m[10] ' ':u qbf-m[11] ' ':u.

  IF qbf-m[1] BEGINS "query-":u THEN DO:
    qbf-i  = LOOKUP(SUBSTRING(qbf-m[1],7,LENGTH(qbf-m[1],"CHARACTER":u) - 7,
                              "CHARACTER":u),qbf-q).

    IF qbf-i = 0 THEN
      PUT STREAM logStream UNFORMATTED
        SKIP '    is not a correct V6 feature.'
        SKIP '    It was not converted to GUI RESULTS.' SKIP.
    ELSE DO:
      /* V7 feature depends on V6 feature. Handle the 1-1 conversions first. */
      qbf-d = "".

      CASE TRIM(qbf-m[1]):
        WHEN "query-add=":u    THEN qbf-d = {&rfRecordAdd}.
        WHEN "query-update=":u THEN qbf-d = {&rfRecordUpdate}.
        WHEN "query-delete=":u THEN qbf-d = {&rfRecordDelete}.
        WHEN "query-view=":u   THEN qbf-d = {&rfFileOpen}.
        WHEN "query-browse=":u THEN qbf-d = {&rfBrowseView}.
        WHEN "query-exit=":u   THEN qbf-d = {&rfExit}.
        WHEN "query-wheret=":u THEN qbf-d = {&rfSelection}.
        WHEN "query-next=":u   THEN qbf-d = "".
        WHEN "query-prev=":u   THEN qbf-d = "".
        WHEN "query-first=":u  THEN qbf-d = "".
        WHEN "query-last=":u   THEN qbf-d = "".
        WHEN "query-user=":u   THEN qbf-d = "".
      END.

      IF qbf-d <> "" THEN DO:
        PUT STREAM logStream UNFORMATTED
          SKIP '    was preserved with security of ' qbf-m[2]
          ' and as RESULTS Feature ' qbf-d '.' SKIP.

        ENTRY(2, writeWhat) = "ff":u.
        RUN adeshar/_msetu.p ({&resId}, qbf-d, qbf-m[2], OUTPUT qbf-s).
      END.
      ELSE
      PUT STREAM logStream UNFORMATTED
        SKIP '    is not converted to GUI RESULTS.' SKIP.
    END.
  END. /* query- */

  ELSE IF qbf-m[1] BEGINS "version":u THEN DO:
    qbf-v = qbf-m[2].

    PUT STREAM logStream UNFORMATTED
      SKIP '    was changed to version ' qbf-vers '.' SKIP.
  END. /* version */

  ELSE IF qbf-m[1] BEGINS "goodbye":u THEN DO:
    qbf-goodbye = qbf-m[2] BEGINS "q":u.
    PUT STREAM logStream UNFORMATTED
      SKIP '    was preserved.' SKIP.
  END. /* goodbye */

  ELSE IF qbf-m[1] BEGINS "product":u THEN DO:
    qbf-product = qbf-m[2].
    PUT STREAM logStream UNFORMATTED
      SKIP '    was preserved as' ' "':u qbf-m[2] '".':u SKIP .
  END. /* product */

  ELSE IF qbf-m[1] BEGINS "signon":u THEN
    PUT STREAM logStream UNFORMATTED
      SKIP '    was not preserved.' SKIP.

  ELSE IF qbf-m[1] BEGINS "checksum":u THEN DO:
    ASSIGN /* for compatibility with 1.1 RESULTS for V5 */
      qbf-m[4] = qbf-m[2]
      qbf-m[2] = LDBNAME("RESULTSDB":u)
      qbf-m[3] = "PROGRESS":u
      .

    PUT STREAM logStream UNFORMATTED
      SKIP '    was preserved as ' qbf-m[2] ' ':u qbf-m[3] '.':u
      SKIP '    The checksum ' qbf-m[4] ' will be recalculated.' SKIP.
  END. /* checksum */

  ELSE IF qbf-m[1] BEGINS "fastload":u THEN
    /* Make a fastload file for this moment. */
    PUT STREAM logStream UNFORMATTED
      SKIP '    will be created IN GUI RESULTS.' SKIP.

  ELSE IF qbf-m[1] BEGINS "module-":u THEN DO:
    ENTRY(2, writeWhat) = "ff":u.

    IF qbf-m[1] = "module-user=":u THEN
      PUT STREAM logStream UNFORMATTED
        SKIP '    is not converted to GUI RESULTS.' SKIP.
    ELSE
      PUT STREAM logStream UNFORMATTED
        SKIP '    was preserved with security of ' qbf-m[2]
        SKIP '    and as RESULTS Feature(s) '.

    CASE TRIM(qbf-m[1]):
      WHEN "module-query=":u THEN DO:
        RUN adeshar/_msetu.p ({&resId},{&rfFormView},qbf-m[2],OUTPUT qbf-s).
        RUN adeshar/_msetu.p ({&resId},{&rfNewFormView},qbf-m[2],OUTPUT qbf-s).

        PUT STREAM logStream UNFORMATTED
          '{&rfFormView} and {&rfNewFormView}.' SKIP.
      END.

      WHEN "module-report=":u THEN DO:
        RUN adeshar/_msetu.p ({&resId},{&rfReportView},qbf-m[2],OUTPUT qbf-s).
        RUN adeshar/_msetu.p ({&resId},{&rfNewReportView},qbf-m[2],
                              OUTPUT qbf-s).

        PUT STREAM logStream UNFORMATTED
          '{&rfReportView} and {&rfNewReportView}.' SKIP.
      END.

      WHEN "module-label=":u THEN DO:
        RUN adeshar/_msetu.p ({&resId},{&rfLabelView},qbf-m[2],OUTPUT qbf-s).
        RUN adeshar/_msetu.p ({&resId},{&rfNewLabelView},qbf-m[2],OUTPUT qbf-s).
      
        PUT STREAM logStream UNFORMATTED
          '{&rfLabelView} and {&rfNewLabelView}.' SKIP.
      END.
    
      WHEN "module-data=":u THEN DO:
        RUN adeshar/_msetu.p ({&resId},{&rfExportView},qbf-m[2],OUTPUT qbf-s).
        RUN adeshar/_msetu.p ({&resId},{&rfNewExportView},qbf-m[2],
                              OUTPUT qbf-s).
      
        PUT STREAM logStream UNFORMATTED
          '{&rfExportView} and {&rfNewExportView}.' SKIP.
      END.

      WHEN "module-admin=":u THEN DO:
        RUN adeshar/_msetu.p ({&resId},{&rfAdminSubMenu},qbf-m[2],OUTPUT qbf-s).
      
        PUT STREAM logStream UNFORMATTED
          '{&rfAdminSubMenu}.' SKIP.
      END.
    END CASE.
  END. /* module- */

  ELSE IF qbf-m[1] BEGINS "color-":u THEN
    PUT STREAM logStream UNFORMATTED
      SKIP '    is not converted to GUI RESULTS.' SKIP.

  ELSE IF qbf-m[1] BEGINS "printer":u THEN DO:
    /*  Keep for future use, if we ever decide to use qbf-printer temp-table
    ASSIGN
      qbf-printer#               = qbf-printer# + 1
      qbf-printer[qbf-printer#]  = qbf-m[2]
      qbf-pr-dev[qbf-printer#]   = (IF qbf-m[3] = "TERMINAL":u
                                    AND qbf-m[5] = "term":u
                                    THEN TERMINAL ELSE qbf-m[3])
      qbf-pr-type[qbf-printer#]  = qbf-m[5]
      qbf-pr-width[qbf-printer#] = INTEGER(qbf-m[6])
      qbf-pr-init[qbf-printer#]  = qbf-m[7]
      qbf-pr-norm[qbf-printer#]  = qbf-m[8]
      qbf-pr-comp[qbf-printer#]  = qbf-m[9]
      qbf-pr-bon[qbf-printer#]   = qbf-m[10]
      qbf-pr-boff[qbf-printer#]  = qbf-m[11]
      .
    */

    /*
     * Printers are interesting to convert. We'll make RESULTS Admin-defined
     * features out of them and attach the printers off the print menu.  This
     * means that a feature file and menu file will get created.
     *
     * First knock off the printers that we don't convert at all.  Those are 
     * term, page (except for named printer TERMINAL), thru, file
     * (except for named printer FILE)
     */

    qbf-d = "".

    IF qbf-m[5] = "page":u AND qbf-m[2] <> "TERMINAL":u THEN 
      qbf-d = "Use Print Preview.".

    ELSE IF qbf-m[5] = "file":u AND qbf-m[2] <> "FILE":u THEN 
      qbf-d = "Use Print File.".

    ELSE IF qbf-m[5] = "thru":u THEN 
      qbf-d = "It is not supported in WINDOWS.".

    ELSE IF qbf-m[5] = "term":u THEN 
      qbf-d = "Use Print Preview.".

    IF qbf-d <> "" THEN DO:
      PUT STREAM logStream UNFORMATTED
        SKIP '    is not converted to GUI RESULTS. ' qbf-d SKIP.
    END.
  
    ELSE DO:
      /*
       * Now take care of the default printers. We just want to pick
       * off the security information.
       */
      ENTRY(2, writeWhat) = "ff":u.

      IF qbf-m[5] = "page":u AND qbf-m[2] = "TERMINAL":u THEN
        qbf-d = {&rfPrintPreview}.

      IF qbf-m[5] = "file":u AND qbf-m[2] = "FILE":u THEN
        qbf-d = {&rfPrintFile}.
	 
      IF qbf-m[5] = "to":u AND qbf-m[2] = "PRINTER":u THEN
        qbf-d = {&rfPrintPrinter}.

      IF qbf-d <> "" THEN DO:
        PUT STREAM logStream UNFORMATTED
          SKIP '    was converted to RESULTS Feature ' qbf-d
               ' with security of ' qbf-m[4] '.':u SKIP.

        RUN adeshar/_msetu.p ({&resId}, qbf-d, qbf-m[4], OUTPUT qbf-s).

        /* don't forget about PrinterPrinterNoBox (95-03-20-050) */
        IF qbf-d = {&rfPrintPrinter} THEN DO:
          qbf-d = {&rfPrintPrinterNoBox}.
          RUN adeshar/_msetu.p ({&resId}, qbf-d, qbf-m[4], OUTPUT qbf-s).
        END.
      END.
    
      ELSE DO:
        /*
         * The only printers left are the ones we have to convert.
         * "to printers", "to printers w/ control chars", "view printers",
         * and "prog printers".
         *
         * qbf-m[2] will be the default label for the feature
         * qbf-m[3] has the output destination and will the argument
         *          for the feature.
         * qbf-m[4] has the security information for the feature.
         *
         * We'll generate a unique name for the feature.
         */
 
        ENTRY(3, writeWhat) = "gf":u.
   
        IF qbf-m[5] = "to":u AND qbf-m[7] = "" THEN
          qbf-d = "RunAdmin,aderes/u-to.p,":u + qbf-m[3].
        ELSE
          qbf-d = "RunAdmin,aderes/u-cprint.p,":u 
                + qbf-m[3] + ",":u + qbf-m[7].

        IF qbf-m[5] = "view":u THEN
          qbf-d = "RunAdmin,aderes/u-pview.p,":u + qbf-m[3].
	 
        IF qbf-m[5] = "prog":u THEN
          qbf-d = "RunAdmin,aderes/u-pprog.p,":u + qbf-m[3].

        fName = appName + "Print_":u + STRING(fCount).

        PUT STREAM logStream UNFORMATTED
          SKIP '    was converted to Feature ' fName
               ' with security of ' qbf-m[4] '.':u
          SKIP '    The reference to ' qbf-m[3] ' is preserved'
               ' but the file was not copied.' SKIP.

        /* Make the feature */
        RUN adeshar/_maddf.p ({&resId}, fName,
          {&mnuItemType},
          "aderes/_dspfunc.p",
          qbf-d,
          qbf-m[2],
          ?,
          ?,
          ?,
          ?,
          TRUE,
          "",
          qbf-m[4],
          OUTPUT qbf-s).

        /* Make the menu and hang it off the printer submenu */
        RUN adeshar/_maddi.p ({&resId}, fName,
          {&rlPrintSubMenu},
          qbf-m[2],
          {&mnuItemType},
          TRUE,
          "",
          OUTPUT qbf-s).

        fCount = fCount + 1.
      END.
    END.
  END. /* printer */

  /* label stuff */
  ELSE IF qbf-m[1] BEGINS "label-":u 
    AND CAN-DO(qbf-l,SUBSTRING(qbf-m[1],7,-1,"CHARACTER":u)) THEN DO:

    PUT STREAM logStream UNFORMATTED
      SKIP '    was preserved.' SKIP.

    ASSIGN
      qbf-i             = LOOKUP(SUBSTRING(qbf-m[1],7,-1,"CHARACTER":u),qbf-l)
      qbf-l-auto[qbf-i] = qbf-m[2].
  END. /* label- */

  ELSE IF CAN-DO("form*,view*":u,qbf-m[1]) 
    AND CAN-DO(qbf-m[4],USERID("RESULTSDB":u)) THEN DO:

    /*
     * There are two step involved in converting the forms. First,
     * we have to create a query directory entry for this entry
     * and then we have to convert the form. We have to get the
     * database name from the third token. We can't use the appName
     * since there can be multiple databases.
     */
    ASSIGN
      qbf-dir-ent# = qbf-dir-ent# + 1
      junk         = "junk":u
      .

    /* First we must find an open slot. */
    REPEAT WHILE junk <> ?:
      ASSIGN
        queNumber = queNumber + 1
        qbf-d     = outDir + "que":u + STRING(queNumber, "99999":u) + ".p":u
        junk      = SEARCH(qbf-d)
        .
    END.
    
    ASSIGN
      dName = SUBSTRING(qbf-m[3],1,INDEX(qbf-m[3],".":u) - 1,"CHARACTER":u)
      tName = SUBSTRING(qbf-m[3],INDEX(qbf-m[3],".":u) + 1,-1,"CHARACTER":u)
      .

    /*
     * Initialize the query that we will be writing out. This includes
     * setting the table as well as the fields (done by _qread.p)
     */
    RUN aderes/s-zap.p (FALSE).

    RUN aderes/vstbll.p (qbf-m[3], OUTPUT qbf-s).

    /* Do this after vstbll.p, since it might call s-zap.p */
    ASSIGN
      qbf-module = "f":u
      qbf-name   = qbf-m[7]
      .

    /* read form view queries */
    RUN aderesc/_qread.p (qbf-m[2],OUTPUT qbf-s).
    
    IF qbf-s THEN DO:
      PUT STREAM logStream UNFORMATTED
        SKIP '    was not converted.  File read error.' SKIP(1).
      NEXT.
    END.

    /* Set up the other variables */
    RUN aderes/s-level.p.

    /* Write out the new version of the query */
    RUN aderes/s-write.p (qbf-d, "s":u).

    PUT STREAM logStream UNFORMATTED
      SKIP '    was converted and added to the ' appName
           ' public directory as ' qbf-d '.' SKIP.

    ASSIGN
      ENTRY(4, writeWhat)       = "qd7":u
      qbf-dir-ent[qbf-dir-ent#] = qbf-m[7]
      qbf-dir-dbs[qbf-dir-ent#] = dName
      qbf-dir-num[qbf-dir-ent#] = queNumber
      .
  END. /* form*, view* */

  ELSE IF qbf-m[1] BEGINS "join":u 
    AND LENGTH(qbf-m[1],"CHARACTER":u) > 5 THEN DO:
    /*
     * The only difficulty in converting the relationship is dealing with
     * the type of relationship. If it is OF then don't pass the reltext.
     * "OF" is assumed in v7. If their reltext starts with WHERE then send 
     * that text, but clip the word WHERE. The big problem with the WHERE 
     * text is that v7 wants a fully qualified name whereas v6 doesn't put 
     * the database in all cases. So we've got to do it.  The problem is 
     * that we've got to "parse" the string to add the fully qualified name.
     */
    ASSIGN
      qbf-d    = ""
      
      /* Need db.table format.  Attempt to fix if only table name given -dma */
      qbf-m[2] = (IF INDEX(qbf-m[2],".":u) = 0 THEN
                    ENTRY(1,qbf-dbs) + ".":u + qbf-m[2] ELSE qbf-m[2])
      qbf-m[3] = (IF INDEX(qbf-m[3],".":u) = 0 THEN
                    ENTRY(1,qbf-dbs) + ".":u + qbf-m[3] ELSE qbf-m[3])
      .

    IF qbf-m[4] BEGINS "WHERE":u THEN DO:
      qbf-d = SUBSTRING(qbf-m[4],7,-1,"CHARACTER":u). /* strip 'WHERE' */
      
      /* We can't do this if multiple dbs are connected or if qbf-m[2] or 
         qbf-m[3] consists only of a table name, i.e. QAD, then this fails.  
         Should we assume in this case that only one db is connected? -dma
      RUN aderesc/_fullnam.p (qbf-m[2], INPUT-OUTPUT qbf-d). /* base */
      RUN aderesc/_fullnam.p (qbf-m[3], INPUT-OUTPUT qbf-d). /* other */
      */
    END.

    RUN af-rship (qbf-m[2],qbf-m[3],{&joinTypeUnknown},qbf-d,qbf-d,FALSE,
                  OUTPUT qbf-s).

    /* Configuration read aborted.  Let's get out of here... */
    IF qbf-s THEN DO:
      goodRead = FALSE.
      RETURN.
    END.

    PUT STREAM logStream UNFORMATTED
      SKIP '    was preserved.' SKIP.
  END. /* join */
  
  ELSE IF qbf-m[1] BEGINS "user-program":u THEN DO:
    PUT STREAM logStream UNFORMATTED
      SKIP '    is not converted to GUI RESULTS.' SKIP.
  END. /* user-program */

  ELSE IF qbf-m[1] BEGINS "user-export":u THEN
    PUT STREAM logStream UNFORMATTED
      SKIP '    is not converted to GUI RESULTS.' SKIP.
      
  ELSE IF qbf-m[1] BEGINS "user-query":u THEN
    PUT STREAM logStream UNFORMATTED
      SKIP '    is not converted to GUI RESULTS.' SKIP.
      
  /* report stuff */
  ELSE IF CAN-DO(qbf-h,qbf-m[1]) THEN DO:
    DEFINE VARIABLE headerTrailer AS LOGICAL NO-UNDO.

    IF qbf-m[2] = "" AND qbf-m[3] = "" AND qbf-m[4] = "" THEN
      PUT STREAM logStream UNFORMATTED
        SKIP '    has nothing defined. It is not converted.' SKIP.
    ELSE
      PUT STREAM logStream UNFORMATTED
        SKIP '    was preserved as ' qbf-m[2] ' ':u qbf-m[3] ' ':u 
        qbf-m[4] '.':u SKIP.

    headerTrailer = FALSE.

    /* s-zap.p, which is called for the form* section that follows, will
       clear the qbf-rsys fields, so we'll store this stuff temporarily
       somewhere else, then put it back in later. -dma */
    CASE TRIM(qbf-m[1]):
      WHEN "left-margin=":u    THEN lbl-field[1] = INTEGER(qbf-m[2]).
      WHEN "page-size=":u      THEN lbl-field[2] = INTEGER(qbf-m[2]).
      WHEN "column-spacing=":u THEN lbl-field[3] = INTEGER(qbf-m[2]).
      WHEN "line-spacing=":u   THEN lbl-field[4] = INTEGER(qbf-m[2]).
      WHEN "top-margin=":u     THEN lbl-field[5] = INTEGER(qbf-m[2]).
      WHEN "before-body=":u    THEN lbl-field[6] = INTEGER(qbf-m[2]).
      WHEN "after-body=":u     THEN lbl-field[7] = INTEGER(qbf-m[2]).
      OTHERWISE DO:
        headerTrailer = TRUE.
      END.
    END CASE.

    /*
     * If the attribute is a header or trailer then we may have to make
     * multiple records
     */
    IF headerTrailer = TRUE THEN DO:
      qbf-i = LOOKUP(TRIM(qbf-m[1]),"top-left=,top-center=,top-right=,":u
            + "bottom-left=,bottom-center=,bottom-right=,":u
            + "first-only=,last-only=,cover-page=,final-page=":u).

      IF qbf-i > 0 THEN DO:
        FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = - qbf-i NO-ERROR.
        IF NOT AVAILABLE qbf-hsys THEN
          CREATE qbf-hsys.

        ASSIGN
          qbf-hsys.qbf-hpos    = - qbf-i
          qbf-hsys.qbf-htxt[1] = qbf-m[2]
          qbf-hsys.qbf-htxt[2] = qbf-m[3]
          qbf-hsys.qbf-htxt[3] = qbf-m[4]
          .
      END.
    END.
  END. /* report stuff */

  PUT STREAM logStream UNFORMATTED ' ':u SKIP.
END. /* main repeat loop */

INPUT  STREAM qbf-io    CLOSE.
OUTPUT STREAM logStream CLOSE.

/* restore qbf-rsys fields */
ASSIGN
  qbf-rsys.qbf-origin-hz   = lbl-field[1]
  qbf-rsys.qbf-page-size   = lbl-field[2]
  qbf-rsys.qbf-space-hz    = lbl-field[3]
  qbf-rsys.qbf-space-vt    = lbl-field[4]
  qbf-rsys.qbf-origin-vt   = lbl-field[5]
  qbf-rsys.qbf-header-body = lbl-field[6]
  qbf-rsys.qbf-body-footer = lbl-field[7]
  .

RETURN.

/*----------------------------------------------------------------------*/
{ aderes/af-rship.i }

/* _aload.p - end of file */


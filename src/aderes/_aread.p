/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _aread.p - read in the configuration file
*
*    If there any changes to this file they may impact _abuilda.p. That
*    file rebuilds the table aliases during an application rebuild.
*/

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/a-define.i }
{ aderes/e-define.i }
{ aderes/l-define.i }
{ aderes/r-define.i }
{ aderes/i-define.i }
{ aderes/j-define.i }
{ aderes/y-define.i }
{ aderes/s-output.i }
{ aderes/_fdefs.i }

DEFINE INPUT  PARAMETER readMode  AS INTEGER   NO-UNDO. /* 1=initial,2=full */
DEFINE OUTPUT PARAMETER abortRead AS LOGICAL   NO-UNDO.

DEFINE VARIABLE qbf-a  AS LOGICAL   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-c  AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d  AS CHARACTER NO-UNDO. /* database list */
DEFINE VARIABLE qbf-i  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j  AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-m  AS CHARACTER NO-UNDO EXTENT 6. /* input line */
DEFINE VARIABLE qbf-n  AS INTEGER   NO-UNDO. /* # databases */
DEFINE VARIABLE qbf-s  AS INTEGER   NO-UNDO. /* token subscript */
DEFINE VARIABLE qbf-t  AS CHARACTER NO-UNDO. /* token */
DEFINE VARIABLE qbf-v  AS CHARACTER NO-UNDO. /* version */

DEFINE VARIABLE qbf-e# AS INTEGER   NO-UNDO. /* end of qbf-e-cat */
DEFINE VARIABLE qbf-l# AS INTEGER   NO-UNDO. /* end of qbf-l-cat */
DEFINE VARIABLE qbf-p# AS INTEGER   NO-UNDO. /* end of qbf-p-cat */

/*
* In Results V7 the tables will be loaded by _aread.p. This is due to
* the new feature, table security. The tables have to be loaded before
* the "relationship" part of the confguration file. BUT, we can't load until
* we have the name of the table security function, which is also saved in
* the configuration. Fortunately, the file name is ahead of the
* relationship info.
*
* Why not wait until after _aread.p to do the table stuff? The main reason
* is that after _aread.p the relation table is complete. It would be harder
* to remove relationship, change index entries and the like.
*
* Finally, it is not as simple as reading in the tables. This code has
* to worry if there's no table security, no relationships, etc. in building
* the tables.
*/

DEFINE VARIABLE loadedtables         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE loadedAdminFeatures  AS LOGICAL   NO-UNDO.
DEFINE VARIABLE badDatabase          AS LOGICAL   NO-UNDO.
DEFINE VARIABLE missingDatabase      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE appRebuild           AS LOGICAL   NO-UNDO.
DEFINE VARIABLE rcodeMissing         AS LOGICAL   NO-UNDO.
DEFINE VARIABLE currentFile          AS CHARACTER NO-UNDO.
DEFINE VARIABLE tempFile             AS CHARACTER NO-UNDO.

DEFINE STREAM qbf-io.

/* Initialize local variables and get needed temp table records */
FIND FIRST qbf-rsys WHERE NOT qbf-rsys.qbf-live.

ASSIGN
  qbf-c     = SEARCH(qbf-qcfile + {&qcExt})
  qbf-l#    = 0 /* used only here for size of qbf-l-cat table */
  qbf-p#    = 0 /* used only here for size of qbf-p-cat table */
  qbf-e#    = 0 /* used only here for size of qbf-e-cat table */
  .

IF qbf-c = ? THEN RETURN.

/* clear out joins */
FOR EACH qbf-rel-buf:
  qbf-rel-buf.rels = "".
END.

STATUS DEFAULT "Reading configuration file...":t63.

/* Copy the .qc7 file to a temporary file. This is meant to get around bug
   99-03-16-012 where we can't rewrite the .qc7 file (_awrite.p(2), line 280) 
   while it's open, duh! */
RUN adecomm/_tmpfile.p ("qc", ".tmp", OUTPUT tempFile).
OS-COPY VALUE(qbf-c) VALUE(tempFile).
INPUT STREAM qbf-io FROM VALUE(tempFile) NO-ECHO.

main-loop:
REPEAT:
  ASSIGN
    qbf-t = ""
    qbf-m = "".
  IMPORT STREAM qbf-io qbf-t qbf-m.
  IF INDEX(qbf-t,"=":u) = 0 OR qbf-t BEGINS "#":u THEN NEXT.

  ASSIGN
    /* strip off trailing "=" */
    qbf-t = SUBSTRING(qbf-t,1,LENGTH(qbf-t,"CHARACTER":u) - 1,"CHARACTER":u)

    qbf-i = INDEX(qbf-t,"[":u)
    qbf-j = INDEX(qbf-t,"]":u)
    qbf-s = 0. /* is subscript n if token[n] seen */

  IF qbf-i > 0 AND qbf-j > qbf-i THEN
  ASSIGN
    qbf-s = INTEGER(SUBSTRING(qbf-t,qbf-i + 1,qbf-j - qbf-i - 1,"CHARACTER":u))
    qbf-t = SUBSTRING(qbf-t,1,qbf-i - 1,"CHARACTER":u).

  qbf-i = INDEX(qbf-t,".":u).

  CASE (IF qbf-i > 0 THEN SUBSTRING(qbf-t,1,qbf-i,"CHARACTER":u) ELSE qbf-t):
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "version":u THEN DO:
      IF readMode > 1 THEN NEXT.
      qbf-vers = qbf-m[1].
    END.

    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "checkdb":u THEN DO:
      IF readMode > 1 THEN NEXT.
    qbf-checkdb = IF qbf-m[1] = "true" THEN TRUE ELSE FALSE.
    END.
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "database":u THEN DO:
      IF readMode = 1 THEN NEXT.
      qbf-n = qbf-n + 1.
  
      /*
      * Determine the state of the database, vs the state we left it. This
      * is the beginning of application rebuild. Here are the rules:
      *
      *    1.  If the db CRCs are the same then all is fine.
      *    1A. If the number of DB's are different then we can't
      *        use the fastload. We can't use the fastload files!
      *    2.  If the CRCs are different then perhaps we need to rebuild.
      *    2A. If the CRC is 0 that means a database alias was deleted.
      *        However, we don't have to rebuild relationships and tables
      *        because RESULTS had made the alias. So the "database shape"
      *        is ok. But we want the CRC to be different so
      *        queries that reference the alias will be caught
      *    2B. Otherwise something changed in the database. We don't
      *        know what. Ask the user to:
      *              A. Punt.
      *              B. Get tables and rebuild relats (presumes a table
      *                 has been added/removed and/or a field has been
      *                 added/removed that affect relationships). In
      *                 effect, start over.
      *              C. Get tables but uses existing relats! This presumes
      *                 that the change to the database doesn't need to affect
      *                 relats. And this is the way v6 Results worked.
      *
      * If we've already discovered a bad CRC on a database or if
      * the application doesn't need us to look at the CRC then
      * don't even try with any other databases. The user has already
      * been told about the problem and has indicated the course of action
      */

      IF qbf-checkdb = FALSE OR badDatabase OR missingDatabase THEN NEXT.
  
      IF LDBNAME(qbf-m[1]) = ? OR DBTYPE(qbf-m[1]) <> qbf-m[2] THEN
        ASSIGN
        qbf-d = (IF qbf-d = "" THEN "" ELSE ",":u) + qbf-m[1] + ":":u + qbf-m[2]
        qbf-c = "-1":u
        .
      ELSE
        RUN aderes/s-schema.p (qbf-m[1],"","","DB:CRC":u,OUTPUT qbf-c).
  
      IF qbf-m[3] = "*":u THEN
        qbf-m[3] = qbf-c.

      IF NOT CONNECTED(qbf-m[1])
        OR (DECIMAL(qbf-m[3]) = 1)
        OR (DECIMAL(qbf-c) <> DECIMAL(qbf-m[3])) THEN DO:
        IF DECIMAL(qbf-m[3]) = 1 THEN
          qbf-d = "Previously, table alias(es) were deleted".
        ELSE IF NOT CONNECTED(qbf-m[1]) THEN
          ASSIGN
            missingDatabase = TRUE
            qbf-d           = qbf-m[1] + " is no longer connected".
        ELSE IF DECIMAL(qbf-c) <> DECIMAL(qbf-m[3]) THEN
          qbf-d = "The database structure has changed".

        RUN rebuild_structure (INPUT qbf-d, OUTPUT abortRead).
        IF abortRead THEN DO:
          INPUT STREAM qbf-io CLOSE.
          OS-DELETE VALUE(tempFile).
          RETURN.
        END.
      END.
    END.
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "hook.":u THEN DO:
      IF readMode > 1 THEN NEXT.
  
      qbf-i = LOOKUP(SUBSTRING(qbf-t,6,-1,"CHARACTER":u), {&ahQcNames}).
      IF qbf-i > 0 THEN
        qbf-u-hook[qbf-i] = qbf-m[1].
  
      /*
      * If this is the logo hook then run it now during the first pass
      * (aderes.p calls _aread.p twice...).  Results needs to get that
      * screen displayed as early as possible.
      */
      IF qbf-i = {&ahLogo} AND readMode = 1 THEN
        RUN aderes/_alogo.p.
    END.
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "fastload":u THEN DO:
      IF readMode = 1 THEN NEXT.
    
        IF NUM-DBS > qbf-n THEN DO:
          qbf-d = "A connected database was not found in the configuration file".
          RUN rebuild_structure (INPUT qbf-d, OUTPUT abortRead).
        IF abortRead THEN DO:
          INPUT STREAM qbf-io CLOSE.
          OS-DELETE VALUE(tempFile).
          RETURN.
        END.
      END.
    
        qbf-fastload = qbf-m[1].

      /*
      * If there is a bad database and the user wants to rebuild
      * relationships then don't use the fastload file.
      * The configuration file will do a better job (and easier, since
      * all the code is written) of building/updating the internal
      * data structures, especially, qbf-rel-tt.
      *
      * The database schema has changed somehow. There may be new/missing
      * tables. The relationship may be different. But after those
      * are figured out, we still want to try to add in the previously
      * saved relationship and table aliases.
      */
  
      IF (badDatabase AND appRebuild) OR missingDatabase THEN NEXT.
  
      currentFile = qbf-fastload + {&flStartupExt} + ".r".
  
      RUN aderes/_ssearch.p (currentFile, OUTPUT qbf-c).
  
      IF qbf-c = ? THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
          SUBSTITUTE("The fastload file, &1, was defined but not found. The configuration file will be used for startup information.  The fastload file will be rebuilt.",
          currentFile)).

        rcodeMissing = TRUE.
      END.
      ELSE DO:
        fastload:
        DO ON STOP UNDO fastload, RETRY fastload:
          IF RETRY THEN DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
            SUBSTITUTE("There is a problem with the fastload file, &1. The configuration file will be used for startup information.",
              currentFile)).
  
            LEAVE fastload.
          END.
  
          /* Run the login program */
          RUN VALUE(currentFile).

          currentFile = qbf-fastload + {&flRelationshipExt} + ".r".
          RUN VALUE(currentFile).
  
          IF badDatabase AND NOT appRebuild THEN
            RUN aderes/_awrite.p (2).
  
          /* All of the information was retrieved from the fastload files.
           * So we are done reading. */
          INPUT STREAM qbf-io CLOSE.
          OS-DELETE VALUE(tempFile).
          RETURN.
        END.
      END.
    END.
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "goodbye":u THEN
      qbf-goodbye = qbf-m[1] BEGINS "q":u.
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
      WHEN "threed":u THEN
      ASSIGN
      qbf-threed      = IF qbf-m[1] = "true":u THEN TRUE ELSE FALSE
      SESSION:THREE-D = IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN":u
                      AND qbf-threed THEN TRUE ELSE FALSE.
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "status-area":u THEN
    lGlbStatus = IF qbf-m[1] = "true" THEN TRUE ELSE FALSE.
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "toolbar":u THEN
    lGlbToolBar = IF qbf-m[1] = "true" THEN TRUE ELSE FALSE.
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "writeconfig":u THEN
      qbf-awrite = IF qbf-m[1] = "true" THEN TRUE ELSE FALSE.

    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "product":u THEN
      qbf-product = qbf-m[1].
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "public-directory":u THEN
      qbf-qdpubl = qbf-m[1].
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "left-delim":u THEN
      qbf-left = qbf-m[1].
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "right-delim":u THEN
      qbf-right = qbf-m[1].
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "feature-file":u THEN DO:
      IF readMode = 1 THEN NEXT.

      /*
      * The admin feature file has to be read in now. Why?
      * 1. Before reading of the configuration file started the core
      *    features were created.
      * 2. To read in the admin feature we need the name of the
      *    file they are stored in. We just got that.
      * 3. All the features must be available before Results core
      *    security information is read. And that information is
      *    stored later in the configuration file.
      *
      * This is the only oppertunity to get the admin features that
      * meets the above criteria.
      *
      * Make sure that the file exists.
      */
  
      loadedAdminFeatures = TRUE.
      RUN aderes/af-aff.p ("adminFeature":u, qbf-m[1]).
    END.
    
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "menu-file":u THEN
      _adminMenuFile = qbf-m[1].
  	
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "minlogo":u THEN
      /*
      * Save the image and then load it. The load has to be done here
      * because the window has aleady been created.
      */
      ASSIGN
        _minLogo = qbf-m[1]
        qbf-a    = qbf-win:LOAD-ICON(_minLogo)
       .
    
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    /* label stuff */
    WHEN "label-name":u    THEN
      qbf-l-auto[ 1] = qbf-m[1].
    WHEN "label-addr1":u   THEN
      qbf-l-auto[ 2] = qbf-m[1].
    WHEN "label-addr2":u   THEN
      qbf-l-auto[ 3] = qbf-m[1].
    WHEN "label-addr3":u   THEN
      qbf-l-auto[ 4] = qbf-m[1].
    WHEN "label-city":u    THEN
      qbf-l-auto[ 5] = qbf-m[1].
    WHEN "label-state":u   THEN
      qbf-l-auto[ 6] = qbf-m[1].
    WHEN "label-zip":u     THEN
      qbf-l-auto[ 7] = qbf-m[1].
    WHEN "label-zip+4":u   THEN
      qbf-l-auto[ 8] = qbf-m[1].
    WHEN "label-csz":u     THEN
      qbf-l-auto[ 9] = qbf-m[1].
    WHEN "label-country":u THEN
      qbf-l-auto[10] = qbf-m[1].

    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "label.":u THEN DO:
      IF readMode = 1 THEN LEAVE main-loop.
  
      IF qbf-t = "label.size":u AND qbf-l# < EXTENT(qbf-l-cat) THEN
      ASSIGN
        qbf-l#            = qbf-l# + 1
        qbf-l-cat[qbf-l#] = qbf-m[1].
    END.

    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    /* export stuff */
    WHEN "export.":u THEN
      IF qbf-t = "export.type":u AND qbf-e# < EXTENT(qbf-e-cat) THEN
        ASSIGN
          qbf-e#            = qbf-e# + 1
          qbf-e-cat[qbf-e#] = qbf-m[1].
  
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "security.":u THEN DO:
      /*
       * The features must be available before reading in security
       * info. But if we got this far without loading features that
       * means that there was no feature file in the configuration file.
       * Use Results core features.
       */
  
      IF loadedAdminFeatures = FALSE THEN DO:
        RUN aderes/af-init.p.
        loadedAdminFeatures = TRUE.
      END.
  
      /* This is a security element. Move the information off into the
       * correct entry for the feature.
       */
      qbf-t = SUBSTRING(qbf-t,INDEX(qbf-t,".":u) + 1,
              LENGTH(qbf-t,"CHARACTER":u),"CHARACTER":u).
      RUN adeshar/_msetu.p ({&resId}, qbf-t, qbf-m[1], OUTPUT qbf-a).
    END.

    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    /* report stuff */
    WHEN "report.":u THEN
      CASE SUBSTRING(qbf-t,8,-1,"CHARACTER":u):
  
      WHEN "format":u THEN
        qbf-rsys.qbf-format      = qbf-m[1].
      WHEN "dimension":u THEN
        qbf-rsys.qbf-dimen       = qbf-m[1].
      WHEN "left-margin":u THEN
        qbf-rsys.qbf-origin-hz   = INTEGER(qbf-m[1]).
      WHEN "page-size":u THEN
        qbf-rsys.qbf-page-size   = INTEGER(qbf-m[1]).
      WHEN "column-spacing":u THEN
        qbf-rsys.qbf-space-hz    = INTEGER(qbf-m[1]).
      WHEN "line-spacing":u THEN
        qbf-rsys.qbf-space-vt    = INTEGER(qbf-m[1]).
      WHEN "top-margin":u THEN
        qbf-rsys.qbf-origin-vt   = INTEGER(qbf-m[1]).
      WHEN "before-body":u THEN
        qbf-rsys.qbf-header-body = INTEGER(qbf-m[1]).
      WHEN "after-body":u THEN
        qbf-rsys.qbf-body-footer = INTEGER(qbf-m[1]).
      OTHERWISE DO:
        qbf-i = LOOKUP(ENTRY(1,SUBSTRING(qbf-t,8,-1,"CHARACTER":u),"[":u),
                "top-left,top-center,top-right,":u
                + "bottom-left,bottom-center,bottom-right,":u
              + "first-only,last-only,cover-page,final-page":u).
        IF qbf-i > 0 THEN DO:
          FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = - qbf-i NO-ERROR.
          IF NOT AVAILABLE qbf-hsys THEN
            CREATE qbf-hsys.
          ASSIGN
            qbf-hsys.qbf-hpos        = - qbf-i
            qbf-hsys.qbf-htxt[qbf-s] = qbf-m[1].
        END.
      END.
    END CASE.

    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    /* page size stuff */
    WHEN "page.":u THEN
      IF qbf-t = "page.size":u AND qbf-p# < EXTENT(qbf-p-cat) THEN
        ASSIGN
          qbf-p#            = qbf-p# + 1
      qbf-p-cat[qbf-p#] = qbf-m[1].
    
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "restriction":u THEN DO:

      RUN lookup_table (qbf-m[1],OUTPUT qbf-i).
      IF qbf-i <= 0 THEN NEXT.
    
      CREATE _tableWhere.
      ASSIGN
        _tableWhere._tableId = qbf-i
        _tableWhere._text = qbf-m[2]
        .
    END.
    
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "printer":u THEN
      IF qbf-m[3] = "" OR CAN-DO(qbf-m[3],USERID("RESULTSDB":u)) THEN
        ASSIGN
          qbf-printer#               = qbf-printer# + 1
          qbf-printer[qbf-printer#]  = qbf-m[1]
          qbf-pr-dev[qbf-printer#]   = qbf-m[2]
      qbf-pr-perm[qbf-printer#]  = ""
          qbf-pr-type[qbf-printer#]  = qbf-m[4]
          qbf-pr-width[qbf-printer#] = INTEGER(qbf-m[5])
          qbf-pr-init[qbf-printer#]  = qbf-m[6]
          .
    
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "talias.":u THEN DO:
      /* If the tables haven't been loaded yet, then get 'm. */
      IF (loadedTables = FALSE) THEN DO:
        loadedTables = TRUE.
        RUN aderes/j-init.p (?).
      END.
    
      /* Set up the alias */
      qbf-c = SUBSTRING(qbf-t,INDEX(qbf-t,".":u) + 1,-1,"CHARACTER":u).
    
      RUN aderes/af-tal.p (qbf-c, qbf-m[1], TRUE).

      IF appRebuild THEN DO:
        {&FIND_TABLE_BY_NAME} qbf-c.
        IF AVAILABLE qbf-rel-buf THEN
        RUN aderes/_atalrel.p (TRUE,
                               qbf-rel-buf.tname,
                               qbf-rel-buf.tid,
                               qbf-rel-buf.sid,
                               TRUE,
                               TRUE,
                               OUTPUT qbf-rel-buf.rels).
      END.
    END.
    
    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
    WHEN "relat":u THEN DO:
    
      IF (loadedTables = FALSE) THEN DO:
        loadedTables = TRUE.
    
        RUN aderes/j-init.p (?).
      END.
    
      /*
       * Set up the relationship. Like everything with rebuilding it
       * is never simple. If we are using the qc7 file as the
       * repository (no fastload file and good db) then all relationships
       * must be built.
       *
       * If the database was "bad" and we are rebuilding then only
       * create the relationships that aren't contained in the database.
       * These are relationships between tables and table aliases as well
       * as non-standard relationships.
       */

      qbf-a = FALSE.
      IF badDatabase AND appRebuild AND qbf-m[4] = "" THEN
        qbf-a = TRUE.

      RUN af-rship (qbf-m[1], qbf-m[3], qbf-m[2], qbf-m[4], qbf-m[5], qbf-a,
                    OUTPUT abortRead).
      IF abortRead THEN DO:
        INPUT STREAM qbf-io CLOSE.
        OS-DELETE VALUE(tempFile).
        RETURN.
      END.
    END.

    /*- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
  END CASE.
END. /* main-loop: REPEAT */

INPUT STREAM qbf-io CLOSE.
IF readMode = 1 THEN DO:
  OS-DELETE VALUE(tempFile).  
  RETURN.
END.

/*
* Since we've built relationships, or should we assume we've added
* relationships let's make sure they are sorted.
*/
FOR EACH qbf-rel-buf:
  RUN aderes/_jsort1.p (qbf-rel-buf.rels, OUTPUT qbf-rel-buf.rels).
END.

/* If the tables haven't been loaded yet, get them now */
IF (loadedTables = FALSE) THEN
  RUN aderes/j-init.p (?).

/* If there was an application rebuild then write out the new version
 * of the configuration and fastload files. If not a complete rebuild
 * then update the database CRCs. Other wise we'll get the ()*&)(*&
 * message everytime RESULTS is started.
 */
IF badDatabase OR rcodeMissing THEN DO:
  /*
   * IF we can't find any rcode, then write out all rcode. This will help
   * when moving code from one platform/directory to another. Also, when
   * everything is done, RESULTS has set up everything to go as fast
   * as possible. THe reason we've only flagged the menus to be written is
   * that they haven't been read in yet. They will get written later
   */
  RUN aderes/_awrite.p (2).
  RUN aderes/_afwrite.p (2).
  _uiDirty = TRUE.
END.

STATUS DEFAULT.
OS-DELETE VALUE(tempFile).

RETURN.

/*--------------------------------------------------------------------------*/

/* Several internal procedure, that need to be shared, are defined
 * in the following .i file. They are in .i files to improve performance.
 * Subprocedures do not have the overhead of a .p procedure call.
 */

{ aderes/p-lookup.i }
{ aderes/af-rship.i }

PROCEDURE search_propath:
  DEFINE INPUT  PARAMETER qbf_i AS CHARACTER           NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_o AS CHARACTER INITIAL ? NO-UNDO.

  IF qbf_i = "" OR qbf_i = ? THEN RETURN.
  IF SUBSTRING(qbf_i,LENGTH(qbf_i,"CHARACTER":u) - 1,2,
    "CHARACTER":u) = ".r":u THEN
    SUBSTRING(qbf_i,LENGTH(qbf_i,"CHARACTER":u),1,"CHARACTER":u) = "p":u.
    qbf_o = SEARCH(qbf_i).

  IF qbf_o = ? AND SUBSTRING(qbf_i,LENGTH(qbf_i,"CHARACTER":u) - 1, 2, 
                             "CHARACTER":u) = ".p":u THEN
    qbf_o = SEARCH(SUBSTRING(qbf_i,1,
                   LENGTH(qbf_i,"CHARACTER":u) - 1,"CHARACTER":u) + "r":u).
                   
END PROCEDURE.

/*--------------------------------------------------------------------------*/
PROCEDURE rebuild_structure:
  DEFINE INPUT  PARAMETER qbf_d       AS CHARACTER       NO-UNDO.
  DEFINE OUTPUT PARAMETER qbf_abort   AS LOGICAL         NO-UNDO.

  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"warning":u,"yes-no-cancel":u,
    SUBSTITUTE("&1.  An application rebuild may be needed.  Choose YES to regenerate table relationships; Choose NO to use existing relationships;  Choose CANCEL to exit.",
    qbf_d)).

  /*
   * If cancel then punt. If true then rebuild, if false then use existing
   * stuff, which allows us to use any fastload files. */
  IF qbf-a = ? THEN DO:
    /*
     * Let the caller know that there was an abort.  That code will have to 
     * decide to return or quit from Results.
     */
    qbf_abort = TRUE.
    RETURN.
  END.
  ELSE DO:
    badDatabase = TRUE.

    IF qbf-a = TRUE THEN DO:
      appRebuild  = TRUE.

      /* Do the rebuild */
      IF (loadedTables = FALSE) THEN DO:
        loadedTables = TRUE.

        RUN aderes/j-init.p (?).
        RUN aderes/j-find.p.
      END.
    END.
  END.
  
END PROCEDURE.

/* _aread.p - end of file */


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* results.i - query form kernel */
/* File prores/results.x is an xcoded version of this file. If you
   make changes to results.i, you must create a new xcoded version
   of results.x. Also, results.x must be deployed to the prores rcode
   directory.
*/

/*
  Parameters:
  &brow= list of fields for browsing
  &code= include file for seek
  &disp= list of fields on form
  &down= "*" to include browse code
  &dtyp= comma-separated list of &seek field dtypes in rpos order
  &fake= false index finds for scoping ci's
  &file= file to QBF
  &form= form statement for file
  &full= "*" to include update code (for compiling under Full/Query)
  &imag= field _field-rpos's sorted by _order
  &join= where-clause for self-join
  &ldbn= logical dbname of _file to QBF
  &name= name of form
  &read= list of update fields on form
  &rest= where clause to find &save'd record
  &rpos= highest _field-rpos of any field in this file
  &save= save unique key for later &rest'ore
  &scan= "*" to include query code
  &seek= list of search fields on form
  &self= name of this program (sans .p)
*/

/*{ prores/s-system.i }*/
DEFINE SHARED VARIABLE qbf-mhi     AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-mlo     AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-module  AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-tempdir AS CHARACTER NO-UNDO.
DEFINE SHARED VARIABLE qbf-total   AS INTEGER   NO-UNDO.

/*{ prores/s-define.i }*/
DEFINE SHARED VARIABLE qbf-asked  AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-db     AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-file   AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-of     AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-u-prog AS CHARACTER          NO-UNDO.
DEFINE SHARED VARIABLE qbf-where  AS CHARACTER EXTENT 5 NO-UNDO.

/*{ prores/t-define.i }*/
DEFINE SHARED VARIABLE qbf-lang AS CHARACTER EXTENT 33 NO-UNDO.

/*{ prores/q-define.i }*/
DEFINE SHARED VARIABLE qbf-brow  AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-index AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE SHARED VARIABLE qbf-level AS INTEGER            NO-UNDO.
DEFINE SHARED VARIABLE qbf-query AS LOGICAL   EXTENT 5 NO-UNDO.

/*{ prores/s-menu.i }*/
DEFINE SHARED VARIABLE qbf-m-cmd AS CHARACTER           NO-UNDO.
DEFINE SHARED VARIABLE qbf-m-col AS INTEGER   EXTENT 21 NO-UNDO.
DEFINE SHARED VARIABLE qbf-m-dsc AS CHARACTER EXTENT 21 NO-UNDO.
DEFINE SHARED VARIABLE qbf-m-lim AS INTEGER             NO-UNDO.
DEFINE SHARED VARIABLE qbf-m-now AS CHARACTER           NO-UNDO.
DEFINE SHARED VARIABLE qbf-m-row AS INTEGER   EXTENT 21 NO-UNDO.
DEFINE SHARED VARIABLE qbf-m-tbl AS CHARACTER           NO-UNDO.

DEFINE NEW SHARED VARIABLE qbf-off AS LOGICAL NO-UNDO.
DEFINE NEW SHARED BUFFER {&file} FOR {&ldbn}.{&file}.

DEFINE VARIABLE qbf#       AS INTEGER                  NO-UNDO.
DEFINE VARIABLE qbf-ans    AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE qbf-bottom AS INTEGER                  NO-UNDO.
DEFINE VARIABLE qbf-disp   AS LOGICAL   INITIAL   TRUE NO-UNDO.
DEFINE VARIABLE qbf-draw   AS LOGICAL   INITIAL   TRUE NO-UNDO.
DEFINE VARIABLE qbf-edit   AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE qbf-erc    AS INTEGER   INITIAL      0 NO-UNDO.
DEFINE VARIABLE qbf-find   AS CHARACTER                NO-UNDO.
DEFINE VARIABLE qbf-ibro   AS LOGICAL   INITIAL  FALSE NO-UNDO.
DEFINE VARIABLE qbf-image  AS CHARACTER                NO-UNDO.
DEFINE VARIABLE qbf-j      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE qbf-k      AS INTEGER                  NO-UNDO.
DEFINE VARIABLE qbf-old    AS INTEGER                  NO-UNDO.
DEFINE VARIABLE qbf-recid  AS RECID                    NO-UNDO.
DEFINE VARIABLE qbf-qcmp   AS CHARACTER EXTENT {&rpos} NO-UNDO.
DEFINE VARIABLE qbf-qval   AS CHARACTER EXTENT {&rpos} NO-UNDO.
DEFINE VARIABLE qbf-qtru   AS CHARACTER EXTENT {&rpos} NO-UNDO.
DEFINE VARIABLE qbf-store  AS CHARACTER                NO-UNDO.
DEFINE VARIABLE qbf-title  AS CHARACTER                NO-UNDO.
DEFINE VARIABLE qbf-type   AS INTEGER                  NO-UNDO.
DEFINE VARIABLE qbf-work   AS CHARACTER                NO-UNDO.

/*FIND QBF$0._File WHERE QBF$0._File._File-name = "{&file}" NO-LOCK.*/
RUN prores/s-lookup.p
  (qbf-db[qbf-level],qbf-file[qbf-level],"","FILE:RECID",OUTPUT qbf-work).

ASSIGN
  qbf-recid            = INTEGER(qbf-work)
  qbf-brow[qbf-level]  = (IF ENTRY(1,qbf-brow[qbf-level]) = "{&ldbn}.{&file}"
                         THEN qbf-brow[qbf-level]
                         ELSE "{&ldbn}.{&file},{&brow}")
  qbf-bottom           = SCREEN-LINES + MESSAGE-LINES + 1
  qbf-index[qbf-level] = ""
  qbf-asked[qbf-level] = ""
  qbf-find             = qbf-tempdir + STRING(qbf-level) + ".p"
  qbf-image            = qbf-tempdir + STRING(qbf-level) + ".d".

/* load up qbf-m-dsc and qbf-lang */
RUN prores/q-init.p ("{&full}","{&down}","{&scan}",OUTPUT qbf#).

RUN prores/q-find.p ("").

DO FOR {&file} WITH FRAME {&name}: /* scoping block */
  { {&form} }
  FORM WITH OVERLAY.
  PAUSE 0.

  IF FALSE THEN DO:
    {&fake} /* this makes the compiler happy */
  END.

  DO WHILE TRUE: /* iterating block */

    IF qbf-draw OR NOT AVAILABLE {&file} THEN DO:
      qbf-title = ' ' + ENTRY(
                  IF qbf-level = 1 AND qbf-query[1] = ? THEN 1 ELSE 3
                  ,qbf-lang[2]) + ' - "{&ldbn}.{&file}" '.
      /* 'Full Set,Join,Subset' */
      IF NOT AVAILABLE {&file} THEN RUN VALUE(qbf-find) (3). /* FIRST */
      VIEW.
      IF NOT AVAILABLE {&file} THEN CLEAR NO-PAUSE.
      IF NOT AVAILABLE {&file} THEN qbf-erc = 11. /* no records avail */
    END.

    HIDE MESSAGE NO-PAUSE.
    IF qbf-erc > 0 THEN MESSAGE qbf-lang[qbf-erc].
    IF AVAILABLE {&file} AND qbf-disp THEN DISPLAY {&disp}.
    ASSIGN
      qbf-module = "q"
      qbf-erc    = 0
      qbf-disp   = FALSE.

    /* automatic join initialization */
    IF qbf# = 11 AND qbf-level < 5 AND qbf-file[qbf-level + 1] <> "" THEN .
    ELSE
      RUN prores/s-menu.p
        (INPUT-OUTPUT qbf#,INPUT-OUTPUT qbf-old,INPUT-OUTPUT qbf-draw).

    IF qbf# >= 1 AND qbf# <= 4 THEN DO: /*--- start of NEXT/PREV/FIRST/LAST */
      qbf-disp = TRUE.
      IF AVAILABLE {&file} THEN {&save}.
      RUN VALUE(qbf-find) (qbf#). /* NEXT/PREV/FIRST/LAST */
      IF qbf-off THEN qbf-erc = INTEGER(ENTRY(qbf#,"14,13,13,14")).
      IF qbf-off AND NOT AVAILABLE {&file} THEN
        FIND {&file} WHERE {&rest} NO-LOCK NO-ERROR.
      NEXT.
    END. /*------------------------------------ end of NEXT/PREV/FIRST/LAST */

    qbf-draw = TRUE.
    /{&full}*/ /*-full-start-*/
    IF qbf# >= 5 AND qbf# <= 7 THEN /*------------ start of ADD/UPDATE/COPY */
      _qbf567o: DO TRANSACTION:
      IF qbf# <> 5 AND NOT AVAILABLE {&file} THEN NEXT.
      ASSIGN
        qbf-disp   = TRUE
        qbf-edit   = FALSE
        qbf-module = "q" + STRING(qbf#) + "s".
      IF qbf# = 6 THEN DO:
        {&save}.
        FIND {&file} WHERE {&rest} EXCLUSIVE-LOCK.
      END.
      ELSE
        CREATE {&file}.
      IF qbf# = 5 AND qbf-level > 1 THEN
        RUN prores/q-add.p (qbf-level).
      IF qbf# <> 7 THEN DISPLAY {&disp}.
      _qbf567i:
      DO ON ERROR UNDO _qbf567i,RETRY _qbf567i
        ON ENDKEY UNDO _qbf567o,LEAVE _qbf567o:
        SET {&read}.
      END.
    END. /*----------------------------------------- end of ADD/UPDATE/COPY */
    ELSE
    IF qbf# = 8 AND AVAILABLE {&file} THEN DO: /*---------- start of DELETE */
      ASSIGN
        qbf-ans  = FALSE
        qbf-disp = TRUE.
      {&save}.
      RUN prores/s-box.p (INPUT-OUTPUT qbf-ans,?,?,qbf-lang[5]).
      IF qbf-ans THEN DO TRANSACTION ON ERROR UNDO,LEAVE:
        FIND {&file} WHERE {&rest} EXCLUSIVE-LOCK.
        DELETE {&file}.
        RUN VALUE(qbf-find) (1). /* NEXT */
      END.
    END. /*-------------------------------------------------- end of DELETE */
    ELSE
    /{&full}*/ /*-full-end-*/
    IF qbf# = 9 THEN DO: /*---------------------------------- start of VIEW */
      qbf-work = "{&self}".
      RUN prores/c-form.p ("",INPUT-OUTPUT qbf-work).
      IF qbf-work = "" OR ENTRY(2,qbf-work) = "{&self}" THEN NEXT.
      qbf-module = "q:" + qbf-work.
      LEAVE.
    END. /*---------------------------------------------------- end of VIEW */
    ELSE
    /{&down}*/ /*-down-start-*/
    IF qbf# = 10 AND AVAILABLE {&file} THEN DO: /*--------- start of BROWSE */
      ASSIGN
        qbf-ans    = TRUE
        qbf-work   = ENTRY(2,
                     IF qbf-brow[qbf-level] = ""
                     OR ENTRY(1,qbf-brow[qbf-level]) <> "{&ldbn}.{&file}"
                     THEN "{&ldbn}.{&file},{&brow}"
                     ELSE qbf-brow[qbf-level])
        qbf-module = "browse,{&ldbn}.{&file}".
      DO WHILE qbf-ans:
        IF NOT qbf-ibro THEN
          RUN prores/q-browse.p
            (KEYFUNCTION(LASTKEY) = "GET",INPUT-OUTPUT qbf-work).
        {&save}.
        IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN DO:
          qbf-brow[qbf-level] = "{&ldbn}.{&file}," + qbf-work.
          RUN VALUE(qbf-tempdir + STRING(qbf-level + 1) + ".p").
        END.
        ASSIGN
          qbf-module = "q"
          qbf-ibro   = TRUE
          qbf-ans    = (KEYFUNCTION(LASTKEY) = "GET").
        IF qbf-ans THEN qbf-ibro = FALSE.
        IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN
          FIND {&file} WHERE {&rest} NO-LOCK NO-ERROR.
      END.
      qbf-disp = TRUE.
    END. /*-------------------------------------------------- end of BROWSE */
    ELSE
    /{&down}*/ /*-down-end-*/
    IF qbf# = 11 AND AVAILABLE {&file} THEN DO: /*----------- start of JOIN */
      IF qbf-level < 5 AND qbf-file[qbf-level + 1] <> "" THEN DO:
        qbf-work = "*" + qbf-db[qbf-level + 1] + "." + qbf-file[qbf-level + 1].
        RUN prores/c-form.p ("",INPUT-OUTPUT qbf-work).
        IF qbf-work <> "" THEN qbf-work = ENTRY(2,qbf-work).
      END.
      ELSE
        RUN prores/q-join.p ("{&join}",OUTPUT qbf-work).
      IF qbf-work <> "" AND SEARCH(qbf-work + ".r") = ? THEN DO:
        qbf-ans = FALSE.
        RUN prores/s-box.p (INPUT-OUTPUT qbf-ans,?,?,"#20").
        IF NOT qbf-ans THEN qbf-work = "".
        /* The compiled query form is missing for this procedure.    */
        /* Continuing may result in an error from PROGRESS, but will */
        /* not damage anything.  Do you want to attempt to continue? */
      END.
      IF qbf-work = "" THEN DO qbf-j = qbf-level + 1 TO 5:
        ASSIGN
          qbf-of[qbf-level + 1]    = ""
          qbf-where[qbf-level + 1] = ""
          qbf-file[qbf-level + 1]  = "".
      END.
      ELSE DO:
        ASSIGN
          qbf-ibro             = FALSE
          qbf-level            = qbf-level + 1
          qbf-query[qbf-level] = (IF qbf-where[qbf-level] = ""
                                 THEN ? ELSE FALSE).
        CREATE ALIAS "QBF$0" FOR DATABASE VALUE(SDBNAME(qbf-db[qbf-level])).
        OUTPUT TO VALUE(qbf-tempdir + STRING(qbf-level) + ".d") NO-ECHO.
        PUT UNFORMATTED "-" SKIP "-" SKIP.
        OUTPUT CLOSE.
        RUN VALUE(qbf-work + ".p"). /* -call-form- */

        qbf-level = qbf-level - 1.
        CREATE ALIAS "QBF$0" FOR DATABASE VALUE(SDBNAME(qbf-db[qbf-level])).
        IF qbf-module <> "q" THEN LEAVE. /* no longer in Query */
        ASSIGN
          qbf-of[qbf-level + 1]    = ""
          qbf-where[qbf-level + 1] = ""
          qbf-file[qbf-level + 1]  = "".
        RUN prores/q-init.p
          ("{&full}","{&down}","{&scan}",OUTPUT qbf#).
      END.
    END. /*---------------------------------------------------- end of JOIN */
    ELSE
    IF qbf# = 11 THEN qbf# = 1.
    ELSE
    /{&scan}*/ /*-scan-start-*/
    IF qbf# = 12 THEN DO: /*-------------------------------- start of QUERY */
      CLEAR FRAME {&name} NO-PAUSE.
      ASSIGN
        qbf-disp = TRUE
        qbf-ibro = FALSE
        qbf-edit = TRUE
        qbf-erc  = 0 /* just to make sure */
        qbf-qcmp = "="
        qbf-qval = ""
        qbf-qtru = ""
        qbf-work = "".
      IF AVAILABLE {&file} THEN {&save}.
      STATUS INPUT OFF.
      PUT SCREEN ROW qbf-bottom COLUMN 1 COLOR NORMAL FILL(" ",63).

      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        DO qbf-j = (IF SEARCH(qbf-image) = qbf-image THEN 1 ELSE 2) TO 2:
          IF qbf-j = 1 THEN DO WITH FRAME qbf-ops:
            FORM qbf-work FORMAT "x(32)" qbf-qcmp
              WITH NO-VALIDATE NO-ATTR-SPACE NO-LABELS.
            INPUT FROM VALUE(qbf-image) NO-ECHO.
            SET qbf-work WHEN FALSE qbf-qcmp WHEN FALSE.
            SET qbf-work qbf-qcmp.
            INPUT CLOSE.
            IF qbf-work = "{&ldbn}.{&file}" THEN
              INPUT FROM VALUE(qbf-image).
            ELSE
              qbf-j = 2.
          END.
      	  
          PROMPT-FOR {&seek} EDITING:
            IF FRAME-FIELD <> "" THEN DO:
              FIND FIRST QBF$0._Field
                WHERE QBF$0._Field._File-recid = qbf-recid
                  AND QBF$0._Field._Field-name = FRAME-FIELD NO-LOCK.
              PUT SCREEN ROW qbf-bottom COLUMN 1 COLOR NORMAL STRING(
                (IF QBF$0._Field._Label = ? OR QBF$0._Field._Label = "" THEN
                  QBF$0._Field._Field-name ELSE QBF$0._Field._Label)
                + " "
                + ENTRY(LOOKUP(qbf-qcmp[QBF$0._Field._field-rpos],
                  "=,<,<=,>,>=,<>,?,&"),
                  qbf-lang[10]) + " " + FRAME-VALUE,"x(63)").
            END.
            ELSE
              PUT SCREEN ROW qbf-bottom COLUMN 1 COLOR NORMAL FILL(" ",63).
            READKEY.
            IF FRAME-FIELD = "" THEN
              RELEASE QBF$0._Field.
            ELSE
              FIND FIRST QBF$0._Field
                WHERE QBF$0._Field._File-recid = qbf-recid
                  AND QBF$0._Field._Field-name = FRAME-FIELD NO-LOCK NO-ERROR.
            IF KEYFUNCTION(LASTKEY) = "NEW-LINE" THEN DO:
              CLEAR FRAME {&name} NO-PAUSE.
              OUTPUT TO VALUE(qbf-image) NO-ECHO.
              PUT UNFORMATTED "-" SKIP "-" SKIP.
              OUTPUT CLOSE.
              ASSIGN
                qbf-qcmp = "="
                qbf-qval = ""
                qbf-qtru = "".
            END.
            ELSE
            IF KEYFUNCTION(LASTKEY) = "HELP" THEN DO:
              qbf-module = "q12s".
              RUN prores/applhelp.p.
              qbf-module = "q".
            END.
            ELSE
            IF CHR(LASTKEY) = "~~" THEN DO: READKEY. APPLY LASTKEY. END.
            ELSE
            IF NOT AVAILABLE QBF$0._Field THEN APPLY LASTKEY.
            ELSE
            IF CHR(LASTKEY) = "="
              AND CAN-DO("<,>",qbf-qcmp[QBF$0._Field._field-rpos])
              THEN qbf-qcmp[QBF$0._Field._field-rpos]
                = qbf-qcmp[QBF$0._Field._field-rpos] + "=".
            ELSE
            IF CHR(LASTKEY) = "#" THEN
              qbf-qcmp[QBF$0._Field._field-rpos] = "<>".
            ELSE
            IF INDEX("=<>?&",CHR(LASTKEY)) > 0 AND FRAME-FIELD <> "" THEN
              qbf-qcmp[QBF$0._Field._field-rpos] = CHR(LASTKEY).
            ELSE
              APPLY LASTKEY.
          END. /* editing */
          IF qbf-j = 1 THEN INPUT CLOSE.
          { {&code} }
        END.

        qbf-store = "".
        DO qbf-j = 1 TO {&rpos}:
          ASSIGN
            qbf-type = INTEGER(ENTRY(qbf-j,"{&dtyp}"))
            qbf-work = (IF qbf-type = 0 THEN ? ELSE
                       IF qbf-qval[qbf-j] = ? THEN "?" ELSE qbf-qval[qbf-j]).
          IF INDEX(qbf-work,'"') > 0 THEN
            DO qbf-k = LENGTH(qbf-work) TO 1 BY -1:
              IF SUBSTRING(qbf-work,qbf-k,1) = '"' THEN
                SUBSTRING(qbf-work,qbf-k,1) = '""'.
            END.
          IF qbf-type = 1 AND qbf-work <> "?" AND qbf-work <> "" THEN
            qbf-work = '"' + qbf-work + '"'.
          qbf-work = (IF qbf-work = ? OR qbf-work = "" THEN "-" ELSE qbf-work).

          IF qbf-work <> qbf-qval[qbf-j] THEN qbf-qtru[qbf-j] = qbf-work.
          ASSIGN
            qbf-qval[qbf-j] = qbf-work
            qbf-qcmp[qbf-j] = (IF INDEX("?&",qbf-qcmp[qbf-j]) > 0
                              AND qbf-type <> 1 THEN '=' ELSE qbf-qcmp[qbf-j]).

          IF qbf-qval[qbf-j] = "-" THEN NEXT.

          /* in future, change MATCHES to CAN-DO */
          /*IF qbf-qcmp[qbf-j] = "?" THEN PUT UNFORMATTED
            qbf-store ' CAN-DO(' qbf-qval[qbf-j]
            ',' QBF$0._Field._Field-name ')' SKIP.*/
          FIND FIRST QBF$0._Field
            WHERE QBF$0._Field._File-recid = qbf-recid
              AND QBF$0._Field._field-rpos = qbf-j NO-LOCK.
          qbf-store = qbf-store
                    + (IF qbf-store = '' THEN '' ELSE ' AND')
                    + ' {&file}.'
                    + QBF$0._Field._Field-name + ' '
                    + (IF   qbf-qcmp[qbf-j] = "&" THEN 'BEGINS'
                    ELSE IF qbf-qcmp[qbf-j] = "?" THEN 'MATCHES'
                    ELSE    qbf-qcmp[qbf-j])
                    + ' ' + qbf-qval[qbf-j].
        END.
        qbf-work = qbf-store.
      END.

      STATUS INPUT.
      HIDE MESSAGE.
      PUT SCREEN ROW qbf-bottom COLUMN 1 COLOR NORMAL FILL(" ",63).
      IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN qbf-work = "".

      IF qbf-work <> "" THEN DO:
        OUTPUT TO VALUE(qbf-image) NO-ECHO.
        qbf-store = "{&imag}".
        DO qbf-j = 1 TO NUM-ENTRIES(qbf-store):
          PUT UNFORMATTED qbf-qtru[INTEGER(ENTRY(qbf-j,qbf-store))] ' '.
        END.
        PUT UNFORMATTED SKIP.
        EXPORT "{&ldbn}.{&file}" qbf-qcmp.
        OUTPUT CLOSE.

        ASSIGN
          qbf-store            = qbf-where[qbf-level]
          qbf-where[qbf-level] = qbf-work.
        IF AVAILABLE {&file} THEN {&save}.
        RUN prores/q-find.p (""). /* -new-where-clause- */
        RUN VALUE(qbf-find) (3). /* FIRST */
        qbf-erc = (IF AVAILABLE {&file} THEN 0 ELSE 1).
        IF qbf-erc = 1 THEN DO:
          FIND {&file} WHERE {&rest} NO-LOCK NO-ERROR.
          qbf-where[qbf-level] = qbf-store.
          RUN prores/q-find.p ("").
        END.
        /* continue normally but w/new where-clause */
        ELSE
        IF qbf-query[qbf-level] = ? THEN DO:
          qbf-query[qbf-level] = TRUE.
          HIDE NO-PAUSE. /* refresh title */
        END.
        IF qbf-query[qbf-level] <> ? THEN qbf-disp = TRUE.
      END.

      IF qbf-where[qbf-level] <> qbf-store THEN
        RUN prores/q-init.p
          ("{&full}","{&down}","{&scan}",OUTPUT qbf#).

    END. /*--------------------------------------------------- end of QUERY */
    ELSE
    /{&scan}*/ /*-scan-end-*/
    IF qbf# = 13 THEN DO: /*-------------------------------- start of WHERE */
      PUT SCREEN ROW qbf-bottom COLUMN 1 COLOR NORMAL FILL(" ",63).
      PUT SCREEN ROW 2 COLUMN 1 COLOR NORMAL FILL(" ",78).
      ASSIGN
        qbf-disp  = TRUE
        qbf-ibro  = FALSE
        qbf-erc   = 0
        qbf-store = qbf-where[qbf-level]
        qbf-work  = qbf-asked[qbf-level].
      RUN prores/s-where.p
        (FALSE,qbf-db[qbf-level] + "." + qbf-file[qbf-level],
        INPUT-OUTPUT qbf-work).
      IF qbf-work <> "" THEN DO:
        ASSIGN
          qbf-where[qbf-level] = qbf-work
          qbf-asked[qbf-level] = qbf-work.
        IF AVAILABLE {&file} THEN {&save}.
        RUN prores/q-find.p (""). /* -new-where-clause- */
        RUN VALUE(qbf-find) (3). /* FIRST */
        qbf-erc = (IF AVAILABLE {&file} THEN 0 ELSE 1).
        IF qbf-erc = 1 THEN DO:
          FIND {&file} WHERE {&rest} NO-LOCK NO-ERROR.
          qbf-where[qbf-level] = qbf-store.
          RUN prores/q-find.p ("").
        END.
        /* continue normally but w/new where-clause */
        ELSE
        IF qbf-query[qbf-level] = ? THEN DO:
          qbf-query[qbf-level] = FALSE.
          HIDE NO-PAUSE. /* refresh title */
        END.
        IF qbf-query[qbf-level] <> ? THEN qbf-disp = TRUE.
      END.

      IF qbf-where[qbf-level] <> qbf-store THEN
        RUN prores/q-init.p
          ("{&full}","{&down}","{&scan}",OUTPUT qbf#).

    END. /*--------------------------------------------------- end of WHERE */
    ELSE
    IF qbf# = 14 THEN DO: /*-------------------------------- start of TOTAL */
      PUT SCREEN ROW qbf-bottom COLUMN 1 COLOR NORMAL
        STRING(qbf-lang[9],"x(63)").
      PUT CURSOR ROW qbf-bottom COLUMN LENGTH(qbf-lang[9]) + 2.
      RUN prores/q-total.p.
      RUN VALUE(qbf-tempdir + ".p").
      ASSIGN
        qbf-erc     = 6
        qbf-old     = qbf-m-lim
        qbf-draw    = FALSE
        qbf-lang[6] = (IF LASTKEY <> -1 THEN qbf-lang[7]
                      ELSE qbf-lang[8] + STRING(qbf-total) + ".").
      PUT CURSOR OFF.
    END. /*--------------------------------------------------- end of TOTAL */
    ELSE
    IF qbf# = 15 THEN DO: /*-------------------------------- start of ORDER */
      ASSIGN
        qbf-draw = FALSE
        qbf-work = qbf-index[qbf-level].
      RUN prores/q-order.p
        (OUTPUT qbf-erc,OUTPUT qbf-index[qbf-level]).
      IF qbf-work <> qbf-index[qbf-level] THEN
        RUN prores/q-find.p ("").
      IF qbf-erc = 0 THEN qbf-ibro = FALSE.
    END.
    /*-------------------------------------------------------- end of ORDER */
    ELSE
    IF qbf# = 16 THEN DO: /*------------------------------- start of MODULE */
      PUT SCREEN ROW qbf-bottom COLUMN 1 COLOR NORMAL FILL(" ",63).
      RUN prores/s-module.p ("q",OUTPUT qbf-work).
      IF qbf-work <> ? THEN DO:
        qbf-module = qbf-work.
        LEAVE.
      END.
    END. /*-------------------------------------------------- end of MODULE */
    ELSE
    IF qbf# = 17 THEN /*------------------------------------- start of INFO */
      RUN prores/s-info.p ("q").
    /*--------------------------------------------------------- end of INFO */
    ELSE
    IF qbf# = 18 THEN DO: /*--------------------------------- start of USER */
      qbf-module = "q".
      RUN VALUE(qbf-u-prog).
      IF qbf-module <> "q" THEN LEAVE.
    END.
    /*--------------------------------------------------------- end of USER */
    ELSE
    IF qbf# = qbf-m-lim THEN DO: /*-------------------------- start of EXIT */
      IF qbf-level = 1 AND qbf-query[qbf-level] = ? AND qbf-module = "q"
        THEN qbf-module = ?.
      IF qbf-module <> "q" OR qbf-query[qbf-level] = ? THEN LEAVE.
      HIDE MESSAGE NO-PAUSE.
      ASSIGN
        qbf-query[qbf-level] = ?
        qbf-where[qbf-level] = ""
        qbf-ibro             = FALSE.
      RUN prores/q-init.p
        ("{&full}","{&down}","{&scan}",OUTPUT qbf#).
      RUN prores/q-find.p ("").
      HIDE NO-PAUSE. /* refresh title */
    END. /*---------------------------------------------------- end of EXIT */

  END. /* iterating block */
END. /* scoping block */

HIDE FRAME {&name} NO-PAUSE.
HIDE MESSAGE NO-PAUSE.
RETURN.

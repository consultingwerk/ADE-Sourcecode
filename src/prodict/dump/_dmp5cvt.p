/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


/* dict5cvt.p - convert V5 .df into V6 .df */
/*
  user_env[1] = V5 .df file name (source)
  user_env[2] = V6 .df file name (destination)
*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i }

DEFINE VARIABLE ddl    AS CHARACTER EXTENT 30 NO-UNDO.
DEFINE VARIABLE flag   AS CHARACTER           NO-UNDO.
DEFINE VARIABLE x-file AS CHARACTER           NO-UNDO.
DEFINE VARIABLE x-temp AS CHARACTER           NO-UNDO.
DEFINE VARIABLE err    AS LOGICAL                    NO-UNDO INITIAL FALSE.

DEFINE WORKFILE fil NO-UNDO LIKE DICTDB._File.
DEFINE WORKFILE fld NO-UNDO LIKE DICTDB._Field.
DEFINE WORKFILE idx NO-UNDO LIKE DICTDB._Index.
DEFINE WORKFILE key NO-UNDO LIKE DICTDB._Index-field.

DEFINE STREAM olddf.
DEFINE STREAM newdf.

INPUT  STREAM olddf FROM VALUE(user_env[1]) NO-ECHO NO-MAP.
OUTPUT STREAM newdf TO   VALUE(user_env[2]) NO-ECHO NO-MAP.

/* LANGUAGE DEPENDENCIES START */ /*----------------------------------------*/
DEFINE VARIABLE new_lang AS CHARACTER EXTENT 9 NO-UNDO INITIAL [
  /* 1*/ "An input record starting with",
  /* 2*/ "was read,",
  /* 3*/ "but a FILE, REN-FILE, NEW-FILE, CHG-FILE or DEL-FILE",
  /* 4*/ "record was expected.",
  /* 5*/ "Processing will be terminated.",
  /* 6*/ "But a NEW-FIELD, CHG-FIELD, REN-FIELD or DEL-FIELD",
  /* 7*/ "But an NEW-INDEX, REN-INDEX, CHG-INDEX or DEL-INDEX",
  /* 8*/ "But an INDEX-FIELD record was expected",
  /* 9*/ ".df translation completed."
].

FORM
  flag FORMAT "x(32)" LABEL " Working on table"
  WITH FRAME working 
  ROW 5 CENTERED SIDE-LABELS ATTR-SPACE USE-TEXT.
COLOR DISPLAY MESSAGES flag WITH FRAME working.

/* LANGUAGE DEPENDENCIES END */ /*------------------------------------------*/

SESSION:IMMEDIATE-DISPLAY = yes.
IF TERMINAL <> "" THEN
  run adecomm/_setcurs.p ("WAIT").

processing:
REPEAT ON ENDKEY UNDO,LEAVE:

  FOR EACH fil: DELETE fil. END.
  FOR EACH fld: DELETE fld. END.
  FOR EACH idx: DELETE idx. END.
  FOR EACH key: DELETE key. END.

  /*------------------------------------------------ file translation start */
  CREATE fil.
  IMPORT STREAM olddf
    flag           fil._File-Name  fil._Can-Create fil._Can-Read
    fil._Can-Write fil._Can-delete fil._Desc       fil._Valexp
    fil._Valmsg    fil._Frozen     fil._Hidden     fil._Db-lang.
  IF TERMINAL <> "" THEN
    DISPLAY fil._File-name @ flag WITH FRAME working.
  ddl = "".
  RUN "prodict/_dctquot.p" (fil._File-name ,'"',OUTPUT ddl[1]).
  RUN "prodict/_dctquot.p" (fil._Can-Create,'"',OUTPUT ddl[2]).
  RUN "prodict/_dctquot.p" (fil._Can-Read  ,'"',OUTPUT ddl[3]).
  RUN "prodict/_dctquot.p" (fil._Can-Write ,'"',OUTPUT ddl[4]).
  RUN "prodict/_dctquot.p" (fil._Can-Delete,'"',OUTPUT ddl[5]).
  RUN "prodict/_dctquot.p" (fil._Desc      ,'"',OUTPUT ddl[6]).
  RUN "prodict/_dctquot.p" (fil._Valexp    ,'"',OUTPUT ddl[7]).
  RUN "prodict/_dctquot.p" (fil._Valmsg    ,'"',OUTPUT ddl[8]).
  x-file = ddl[1].

  IF flag = "NEW-FILE" OR flag = "CHG-FILE" THEN DO:
    PUT STREAM newdf UNFORMATTED
      (IF flag = "NEW-FILE" THEN "ADD" ELSE "UPDATE")
        " FILE " ddl[1]
        " TYPE " (IF fil._Db-lang = 1 THEN "SQL" ELSE "PROGRESS") SKIP
      "  CAN-CREATE " ddl[2] SKIP
      "  CAN-READ   " ddl[3] SKIP
      "  CAN-WRITE  " ddl[4] SKIP
      "  CAN-DELETE " ddl[5] SKIP
      "  DESCRIPTION "  ddl[6] SKIP
      "  VALEXP " ddl[7] SKIP
      "  VALMSG " + ddl[8] SKIP.
    IF fil._Frozen THEN PUT STREAM newdf UNFORMATTED "  FROZEN" SKIP.
    IF fil._Hidden THEN PUT STREAM newdf UNFORMATTED "  HIDDEN" SKIP.
    PUT STREAM newdf UNFORMATTED SKIP(1).
  END.
  ELSE
  IF flag = "REN-FILE" THEN DO:
    PUT STREAM newdf UNFORMATTED
      "RENAME FILE " ddl[1] " TO " ddl[2] SKIP(1).
  END.
  ELSE
  IF flag = "DEL-FILE" THEN DO:
    PUT STREAM newdf UNFORMATTED
      "DROP FILE " ddl[1] SKIP(1).
    NEXT.
  END.
  ELSE
  IF flag <> "FILE" THEN DO:
    /* "An input record starting with" INPUT flag "was read," */
    /* "but a FILE, REN-FILE, NEW-FILE, CHG-FILE or DEL-FILE" */
    /* "was expected." */
    /* "Processing terminated" */
    MESSAGE new_lang[1] INPUT flag new_lang[2] SKIP
                  new_lang[3] SKIP
                  new_lang[4] SKIP
                  new_lang[5]
                  VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    err = true.
    LEAVE processing.
  END.
  DELETE fil.
  /*-------------------------------------------------- file translation end */

  /*----------------------------------------------- field translation start */
  REPEAT ON ENDKEY UNDO,LEAVE:
    CREATE fld.
    IMPORT STREAM olddf
      flag           fld._Field-Name fld._Data-type fld._Decimals
      fld._Format    fld._Initial    fld._Label     fld._Mandatory
      fld._Order     fld._Can-Read   fld._Can-Write fld._Extent
      fld._Valexp    fld._Valmsg     fld._Help      fld._Desc
      fld._Col-label fld._Fld-case.
    IF _Data-type = "boolean" THEN _Data-type = "logical".
    IF _Data-type = "dbkey"   THEN _Data-type = "recid".

    RUN "prodict/_dctquot.p" (fld._Field-name,'"',OUTPUT ddl[ 1]).
    RUN "prodict/_dctquot.p" (fld._Desc      ,'"',OUTPUT ddl[ 2]).
    RUN "prodict/_dctquot.p" (fld._Format    ,'"',OUTPUT ddl[ 3]).
    RUN "prodict/_dctquot.p" (fld._Initial   ,'"',OUTPUT ddl[ 4]).
    RUN "prodict/_dctquot.p" (fld._Label     ,'"',OUTPUT ddl[ 5]).
    RUN "prodict/_dctquot.p" (fld._Col-label ,'"',OUTPUT ddl[ 6]).
    RUN "prodict/_dctquot.p" (fld._Can-Read  ,'"',OUTPUT ddl[ 7]).
    RUN "prodict/_dctquot.p" (fld._Can-Write ,'"',OUTPUT ddl[ 8]).
    RUN "prodict/_dctquot.p" (fld._Valexp    ,'"',OUTPUT ddl[ 9]).
    RUN "prodict/_dctquot.p" (fld._Valmsg    ,'"',OUTPUT ddl[10]).
    RUN "prodict/_dctquot.p" (fld._Help      ,'"',OUTPUT ddl[11]).
    RUN "prodict/_dctquot.p" (fld._Data-type ,'"',OUTPUT ddl[12]).

    IF flag = "NEW-FIELD" OR flag = "CHG-FIELD" THEN DO:
      PUT STREAM newdf UNFORMATTED
        (IF flag = "NEW-FIELD" THEN "ADD" ELSE "UPDATE")
          " FIELD " ddl[1]
          " OF " x-file
          " TYPE " fld._Data-type SKIP
        "  DESCRIPTION "  ddl[ 2] SKIP
        "  FORMAT "       ddl[ 3] SKIP
        "  INITIAL "      ddl[ 4] SKIP
        "  LABEL "        ddl[ 5] SKIP
        "  COLUMN-LABEL " ddl[ 6] SKIP
        "  CAN-READ  "    ddl[ 7] SKIP
        "  CAN-WRITE "    ddl[ 8] SKIP
        "  VALEXP "       ddl[ 9] SKIP
        "  VALMSG "       ddl[10] SKIP
        "  HELP "         ddl[11] SKIP
        "  ORDER "    STRING(fld._Order)    SKIP.
      IF fld._Decimals <> ? THEN PUT STREAM newdf UNFORMATTED
        "  DECIMALS " STRING(fld._Decimals) SKIP.
      IF fld._Extent > 0 THEN PUT STREAM newdf UNFORMATTED
        "  EXTENT " STRING(fld._Extent) SKIP.
      IF fld._Mandatory THEN PUT STREAM newdf UNFORMATTED
        "  MANDATORY" SKIP.
      IF fld._Fld-case THEN PUT STREAM newdf UNFORMATTED
        "  CASE-SENSITIVE" SKIP.
      PUT STREAM newdf UNFORMATTED SKIP(1).
    END.
    ELSE
    IF flag = "REN-FIELD" THEN DO:
      PUT STREAM newdf UNFORMATTED
        "RENAME FIELD " ddl[1] " TO " ddl[12] " OF " x-file SKIP(1).
    END.
    ELSE
    IF flag = "DEL-FIELD" THEN DO:
      PUT STREAM newdf UNFORMATTED
        "DROP FIELD " ddl[1] " OF " x-file SKIP(1).
    END.
    ELSE IF flag <> "FIELD" THEN DO:
      /* "An input record starting with" INPUT flag "was read," */
      /* "But a NEW-FIELD, CHG-FIELD, REN-FIELD or DEL-FIELD" */
      /* "record was expected" */
      /* "Processing terminated" */
      MESSAGE new_lang[1] INPUT flag new_lang[2] SKIP
              new_lang[6] SKIP
              new_lang[4] SKIP
              new_lang[5] 
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      err = true.
      LEAVE processing.  
    END.
    DELETE fld.
  END.
  /*------------------------------------------------- field translation end */

  /*----------------------------------------------- index translation start */
  REPEAT ON ENDKEY UNDO,LEAVE:
    CREATE idx.
    IMPORT STREAM olddf flag idx._Index-name x-temp idx._Active.
    idx._Unique = (x-temp = "yes").

    IF flag = "NEW-INDEX" OR flag = "CHG-INDEX" THEN DO:
      PUT STREAM newdf UNFORMATTED
        (IF flag = "NEW-INDEX" THEN "ADD" ELSE "UPDATE")
          (IF idx._Unique THEN " UNIQUE" ELSE "")
          (IF idx._Active THEN "" ELSE " INACTIVE")
          " INDEX ~"" idx._Index-name "~""
          " ON " x-file SKIP.
    END.
    ELSE
    IF flag = "REN-INDEX" THEN DO:
      PUT STREAM newdf UNFORMATTED
        "RENAME INDEX ~"" idx._Index-name
          "~" TO ~"" x-temp "~" ON " x-file SKIP.
    END.
    ELSE
    IF flag = "DEL-INDEX" THEN DO:
      PUT STREAM newdf UNFORMATTED
        "DROP INDEX ~"" idx._Index-name "~" ON " x-file SKIP.
    END.
    ELSE IF flag <> "INDEX" THEN DO:
      /* "An input record starting with" INPUT flag "was read," */
      /* "But an NEW-INDEX, REN-INDEX, CHG-INDEX or DEL-INDEX" */
      /* "record was expected" */
      /* "Processing terminated" */
      MESSAGE new_lang[1] INPUT flag new_lang[2] SKIP
              new_lang[7] SKIP
              new_lang[4] SKIP
              new_lang[5]
                    VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      err = true.
      LEAVE processing.  
    END.

    IF flag = "NEW-INDEX" THEN REPEAT ON ENDKEY UNDO,LEAVE:
      CREATE key.
      IMPORT STREAM olddf flag
        key._Index-Seq x-temp key._Ascending key._Abbreviate.
      IF flag = "INDEX-FIELD" THEN DO:
        PUT STREAM newdf UNFORMATTED
          "  INDEX-FIELD ~"" x-temp "~" "
          (IF key._Ascending THEN "A" ELSE "DE") + "SCENDING"
          (IF key._Abbreviate THEN " ABBREVIATED" ELSE "") SKIP.
      END.
      ELSE DO:
        /* "An input record starting with" INPUT flag "was read," */
        /* "But an INDEX-FIELD record was expected" */
        /* "Processing terminated" */
        MESSAGE new_lang[1] INPUT flag new_lang[2] SKIP
                new_lang[8] SKIP
                       new_lang[5] 
                      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
              err = true.
               LEAVE processing.  
      END.
      DELETE key.
    END.

    DELETE idx.
    PUT STREAM newdf UNFORMATTED SKIP(1).
  END.
  /*------------------------------------------------- index translation end */

  /*---------------------------------------------- primary index flag start */
  REPEAT ON ENDKEY UNDO,LEAVE:
    IMPORT STREAM olddf flag x-temp.
    PUT STREAM newdf UNFORMATTED
      "UPDATE PRIMARY INDEX ~"" x-temp "~" ON " x-file SKIP(1).
  END.
  /*------------------------------------------------ primary index flag end */

END.

OUTPUT STREAM newdf CLOSE.
INPUT  STREAM olddf CLOSE.
IF TERMINAL <> "" THEN
  run adecomm/_setcurs.p ("").

HIDE FRAME working NO-PAUSE.
SESSION:IMMEDIATE-DISPLAY = no.
IF TERMINAL <> "" THEN
  MESSAGE new_lang[9] VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.

RETURN.

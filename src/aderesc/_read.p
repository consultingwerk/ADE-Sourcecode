/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 *   _read.p
 *
 *   The combined report, export, and label reader for the TTY
 *   to GUI RESULTS converter.
 *
 *   This file combines the readers that can be found at
 *        prores/r-read.p
 *        prores/d-read.p
 *        prores/l-read.p
 *
 *   Much of the code was cloned, so it is best to bring it all into one place.
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/r-define.i }
{ aderes/l-define.i }
{ aderes/e-define.i }
{ aderes/j-define.i }

DEFINE INPUT  PARAMETER qbf-f     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER fType     AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER writeWhat AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-c       AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-d       AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-h       AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-i       AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-j       AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-k       AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-m       AS CHARACTER NO-UNDO EXTENT 7.
DEFINE VARIABLE qbf-n       AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-s       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE qbf-t       AS CHARACTER NO-UNDO.

DEFINE VARIABLE iPos        AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE lineNumber  AS INTEGER   NO-UNDO.
DEFINE VARIABLE logName     AS CHARACTER NO-UNDO.
DEFINE VARIABLE lookAhead   AS CHARACTER NO-UNDO.
DEFINE VARIABLE multiLine   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE pageEject   AS CHARACTER NO-UNDO.
DEFINE VARIABLE tableList   AS CHARACTER NO-UNDO.
DEFINE VARIABLE whereClause AS CHARACTER NO-UNDO.

DEFINE        STREAM qbf-io.
DEFINE SHARED STREAM userLog.

ASSIGN
  qbf-h = "top-left=,top-center=,top-right=,":u
        + "bottom-left=,bottom-center=,bottom-right=,":u
        + "first-only=,last-only=,,":u
  qbf-t = "left-margin=,page-size=,column-spacing=,line-spacing=,":u
        + "top-margin=,before-body=,after-body=,,page-eject=":u.

/*
 * This conversion will be a two-pass process. The first pass will identify
 * all the tables in the report. We need to set all the names of all the
 * tables at once. The problem has to do with the other attrs that are table
 * specific that can't be set until there are tables.
 */
INPUT STREAM qbf-io FROM VALUE(qbf-f) NO-ECHO NO-MAP.

REPEAT:
  qbf-m = "".
  IMPORT STREAM qbf-io qbf-m.
  
  IF qbf-m[1] BEGINS "#":u THEN NEXT.
  IF qbf-m[1] = "*":u + "~/":u THEN LEAVE.

  IF qbf-m[1] MATCHES "file*=":u THEN
    ASSIGN
      tableList = tableList + lookAhead + qbf-m[2]
      lookAhead = ",":u
      .
  ELSE IF qbf-m[1] = "page-eject=":u AND qbf-m[2] <> "" THEN
    pageEject = qbf-m[2].
END.

INPUT STREAM qbf-io CLOSE.
INPUT STREAM qbf-io FROM VALUE(qbf-f) NO-ECHO NO-MAP.

RUN aderes/vstbll.p (tableList, OUTPUT qbf-s).

IF qbf-s = FALSE THEN RETURN.

/*
 * Put the report information into a record, and then make that record the
 * current record.
 */
FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live = TRUE.
IF NOT AVAILABLE qbf-rsys THEN
  CREATE qbf-rsys.

/* Find the first export record */
FIND FIRST qbf-esys.
FIND FIRST qbf-lsys.

ASSIGN
  qbf-rsys.qbf-live = TRUE
  writeWhat         = ".p":u
  lookAhead         = ""
  .

REPEAT:
  ASSIGN qbf-m = "".
  
  IMPORT STREAM qbf-io qbf-m.
  
  IF qbf-m[1] BEGINS "#":u THEN NEXT.
  IF qbf-m[1] = "*/":u THEN LEAVE.

  IF qbf-m[1] BEGINS "name":u THEN 
    qbf-name = qbf-m[2].

  ELSE IF qbf-m[1] = "left-margin=":u AND fType = "rep":u THEN
    qbf-rsys.qbf-origin-hz = INTEGER(qbf-m[2]).

  ELSE IF qbf-m[1] = "left-margin=":u AND fType = "lbl":u THEN
    qbf-lsys.qbf-origin-hz = INTEGER(qbf-m[2]).

  ELSE IF CAN-DO(qbf-t,qbf-m[1]) THEN DO:
    CASE TRIM(qbf-m[1]):
      WHEN "page-size=":u THEN
        qbf-rsys.qbf-page-size   = INTEGER(qbf-m[2]).
      WHEN "column-spacing=":u THEN
        qbf-rsys.qbf-space-hz    = INTEGER(qbf-m[2]).
      WHEN "line-spacing=":u THEN
        qbf-rsys.qbf-space-vt    = INTEGER(qbf-m[2]).
      WHEN "top-margin=":u THEN
        qbf-rsys.qbf-origin-vt   = INTEGER(qbf-m[2]).
      WHEN "before-body=":u THEN
        qbf-rsys.qbf-header-body = INTEGER(qbf-m[2]).
      WHEN "after-body=":u THEN
        qbf-rsys.qbf-body-footer = INTEGER(qbf-m[2]).
    END CASE.
  END.
  
  /*
   * The following is from d-read.p and must be
   * before the field* if statement
   */
  ELSE IF qbf-m[1] = "type=":u THEN
    qbf-esys.qbf-type = qbf-m[2].
    
  ELSE IF qbf-m[1] = "use-headings=":u THEN
    qbf-esys.qbf-headers = CAN-DO("y*,t*":u,qbf-m[2]).

  ELSE IF qbf-m[1] = "record-delimiter=":u THEN
    qbf-esys.qbf-lin-beg = qbf-m[2].

  ELSE IF qbf-m[1] = "record-separator=":u THEN
    qbf-esys.qbf-lin-end = qbf-m[2].

  ELSE IF qbf-m[1] = "field-delimiter=":u THEN
    qbf-esys.qbf-fld-dlm = qbf-m[2].
  
  ELSE IF qbf-m[1] = "field-separator=":u THEN
    qbf-esys.qbf-fld-sep = qbf-m[2].
  
  ELSE IF qbf-m[1] = "label-spacing=":u THEN
    qbf-lsys.qbf-label-wd = IF INTEGER(qbf-m[2]) = 0 THEN 35 
                            ELSE INTEGER(qbf-m[2]).
  
  ELSE IF qbf-m[1] = "total-height=":u THEN
      qbf-lsys.qbf-label-ht = INTEGER(qbf-m[2]).
    
  ELSE IF qbf-m[1] = "top-margin=":u THEN
      qbf-lsys.qbf-space-vt = INTEGER(qbf-m[2]).
    
  ELSE IF qbf-m[1] = "number-across=":u THEN
    qbf-lsys.qbf-across = INTEGER(qbf-m[2]).
  
  ELSE IF qbf-m[1] = "number-copies=":u THEN
    qbf-lsys.qbf-copies = INTEGER(qbf-m[2]).
    
  ELSE IF qbf-m[1] = "omit-blank=":u THEN
    qbf-lsys.qbf-omit = CAN-DO("t*,y*":u,qbf-m[2]).
    
  ELSE IF qbf-m[1] MATCHES "text*=":u THEN DO:
    /* Deal with the V6 "continuation character". GUI RESULTS
     * doesn't use it, so we'll combine the lines together. */
    qbf-j = LENGTH(qbf-m[2],"CHARACTER":u).
  
    IF multiLine THEN DO:
      IF SUBSTRING(qbf-m[2],qbf-j,1,"CHARACTER":u) = "~~":u THEN
        /* Remove the character, save the information, and append to the
         * previous line. */
        ASSIGN
          qbf-l-text[lineNumber] = qbf-l-text[lineNumber]
                                 + SUBSTRING(qbf-m[2],1,qbf-j - 1,"CHARACTER":u)
          multiLine              = TRUE
          .
      
      ELSE
        /* Use the line as-is. */
        ASSIGN
          qbf-l-text[lineNumber] = qbf-l-text[lineNumber] + qbf-m[2]
          multiLine              = FALSE
          .
    END.
    ELSE DO:
      /* Is there a continuation character? */
      qbf-i = INTEGER(SUBSTRING(qbf-m[1],5,LENGTH(qbf-m[1],"CHARACTER":u) - 5,
                                "CHARACTER":u)).

      IF SUBSTRING(qbf-m[2],qbf-j,1,"CHARACTER":u) = "~~":u THEN
        /* Remove the character and save the information. */
        ASSIGN
          qbf-l-text[qbf-i] = SUBSTRING(qbf-m[2],1,qbf-j - 1,"CHARACTER":u)
          lineNumber        = qbf-i
          multiLine         = TRUE
          .
      ELSE
        /* Use the line as-is. */
        ASSIGN
          qbf-l-text[qbf-i] = qbf-m[2]
          multiLine         = FALSE
          .
    END.
  END. /* text* */

  ELSE IF qbf-m[1] BEGINS "summary":u THEN
    qbf-summary = (IF qbf-m[2] BEGINS "t":u THEN TRUE ELSE FALSE).

  ELSE IF qbf-m[1] MATCHES "file*=":u THEN DO:
    /* Check the WHERE clause for Ask-At-Runtime phrase. */
    IF INDEX(qbf-m[4],"~{~{":u) > 0 THEN
      RUN convertAsk (qbf-m[4], OUTPUT whereClause).
    ELSE
      whereClause = qbf-m[4].
    
    RUN aderes/vstbli.p (qbf-m[2],
                         qbf-c,
                         qbf-m[3],
                         whereClause,
                         ?,
                         ?,
                         OUTPUT qbf-s).
  END. /* file* */
  
  ELSE IF qbf-m[1] MATCHES "order*=":u THEN
    ASSIGN
      qbf-c      = qbf-m[2] + (IF qbf-m[3] BEGINS "d":u THEN " DESC":u ELSE "")
      qbf-sortby = qbf-sortby + lookAhead + qbf-c
      lookAhead  = ",":u
      .

  ELSE IF qbf-m[1] MATCHES "field*=":u THEN DO:
    ASSIGN
      /*
       * For total and stuff: 6 used to mean "summary area". In V7 Results
       * 0 means summary area. */
      qbf-m[5]         = REPLACE(qbf-m[5],"6":u,"0":u)
      qbf-j            = INDEX(qbf-m[5],"*":u)
      qbf-k            = INDEX(qbf-m[2],"[":u) /* is field an array? */
      qbf-n            = qbf-n + 1
      qbf-rc#          = qbf-n
      .

    ASSIGN
      qbf-rcn[qbf-n]   = IF qbf-m[7] = "" OR qbf-m[2] BEGINS "qbf-":u THEN 
                           qbf-m[2] 
                         ELSE "qbf-":u + STRING(qbf-n,"999":u) + ",":u +
                           ENTRY(1,qbf-m[2],"[":u) 
 
      qbf-rcl[qbf-n]   = qbf-m[3]
      qbf-rcf[qbf-n]   = qbf-m[4]
      qbf-rcg[qbf-n]   = (IF qbf-j = 0 THEN qbf-m[5]
                          ELSE SUBSTRING(qbf-m[5],1,qbf-j - 1,"CHARACTER":u))
      qbf-rct[qbf-n]   = LOOKUP(qbf-m[6],qbf-dtype)
      qbf-rcc[qbf-n]   = (IF qbf-j = 0 THEN qbf-m[7]
                          ELSE SUBSTRING(qbf-m[5],qbf-j + 1,-1,"CHARACTER":u))
      qbf-rcs[qbf-n]   = ""
      qbf-rcp[qbf-n]   = ",,,,,,,,":u
      .

    /*
     * Worry about the page eject. In V7 the name of the field is saved, not
     * the position in the report. This is the only time we have the column
     * name and the column number was made available in the first pass. */
    IF pageEject <> "0":u THEN DO:
    
      /* Get the number from the token. If the columns match then
       * put the name in the report record. */
      qbf-c = SUBSTRING(qbf-m[1],6,INDEX(qbf-m[1],"=":u) - 6,"CHARACTER":u).

      IF qbf-c = pageEject THEN
        /* We found a match. Assign the column name to the record.
         * And make it so we don't visit this code anymore. */
        ASSIGN
          pageEject               = "0":u
          qbf-rsys.qbf-page-eject = qbf-m[2]
          .
    END.
  END.
  
  ELSE IF CAN-DO(qbf-h,qbf-m[1]) THEN DO:
    qbf-i = LOOKUP(TRIM(qbf-m[1]), qbf-h).

    IF qbf-i > 0 THEN DO:
      FIND FIRST qbf-hsys WHERE qbf-hsys.qbf-hpos = qbf-i NO-ERROR.
      IF NOT AVAILABLE qbf-hsys THEN
       CREATE qbf-hsys.

      ASSIGN
        qbf-hsys.qbf-hpos    = qbf-i
        qbf-hsys.qbf-htxt[1] = qbf-m[2]
        qbf-hsys.qbf-htxt[2] = qbf-m[3]
        qbf-hsys.qbf-htxt[3] = qbf-m[4]
        .
    END.
  END.
END.
INPUT STREAM qbf-io CLOSE.

RETURN.

/*--------------------------------------------------------------------*/
PROCEDURE convertAsk:
  DEFINE INPUT  PARAMETER source      AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER whereClause AS CHARACTER NO-UNDO.   

  DEFINE VARIABLE boolOp      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE endClause   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE firstClause AS LOGICAL   NO-UNDO INITIAL TRUE.
  DEFINE VARIABLE firstPart   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE logOp       AS CHARACTER NO-UNDO.
  DEFINE VARIABLE numSpaces   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf-i       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE qbf-j       AS INTEGER   NO-UNDO.
  DEFINE VARIABLE secondPart  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE startClause AS INTEGER   NO-UNDO.
  DEFINE VARIABLE tempSource  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisClause  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE thisChar    AS CHARACTER NO-UNDO.
							  
  /* We have to worry about multiple asks for a single table. 
   * The old form:
   *   t.f op {{dt, t.f, char op:Prompt}} <log op> ...
   *
   * The new form:
   *   /*dt, t.f, op, :Prompt */ TRUE <log op>
   *
   * We have to strip out the extra WHERE clause stuff for each instance.
   */
  startClause = INDEX(source,"~{":U).
  
  /* Strip off static WHERE that proceeds AAR before we process the latter. */
  IF startClause > 1 THEN DO:
  
    /* Look from right-to-left for the beginning of the AAR phrase and the end
       of the initial, static WHERE stuff.  Note: this relies on the fact that
       spaces will only occur BETWEEN AAR components. */
    DO qbf-i = (startClause - 1) TO 1 BY -1:
      thisChar = SUBSTRING(source, qbf-i, 1, "CHARACTER":U).
      IF thisChar = " ":U THEN
        numSpaces = numSpaces + 1.
        
      /* We've reached the start of the AAR stuff. */
      IF numSpaces = 3 THEN DO:
        ASSIGN
          whereClause = SUBSTRING(source, 1, qbf-i, "CHARACTER":U)
          source      = SUBSTRING(source, (qbf-i + 1), -1, "CHARACTER":U).
        LEAVE.
      END.
    END.
  END.
  
  DO WHILE TRUE:
    /* Start at the beginning and shorten the list as we go. */
    ASSIGN
      startClause = 1
      endClause   = INDEX(source,"}":u) + 1
      thisClause  = SUBSTRING(source,startClause,endClause,"CHARACTER":u)
      .
  
    /* We now have a single clause. Pull it apart and add to the output. */
    ASSIGN
      qbf-i      = INDEX(thisClause, "~{":u) + 2
      qbf-j      = INDEX(thisClause, "}":u)
      firstPart  = TRIM(SUBSTRING(thisClause, 1, qbf-i - 1, "CHARACTER":u))
      secondPart = SUBSTRING(thisClause, qbf-i, qbf-j - 2, "CHARACTER":u)
      .

    /* No more Ask-At-Runtime phrase, so assume it's static WHERE criteria. */
    IF qbf-j = 0 THEN DO:
      whereClause = whereClause + source.
      LEAVE.
    END.
    
    IF firstClause THEN
      ASSIGN
        logOp       = ENTRY(2,firstPart," ":u)
        boolOp      = ""
        firstClause = FALSE.
    ELSE
      ASSIGN
        logOp  = ENTRY(3, firstPart, " ":u) + " ":u
        boolOp = " ":u + ENTRY(1, firstPart ," ":u) + " ":u.

    /* Build the string. */
    whereClause = whereClause
                + boolOp
                + "/*":u
                + ENTRY(1, secondPart)
                + ",":u
                + ENTRY(2, secondPart)
                + ",":u
                + logOp
                + ",":u
                + TRIM(SUBSTRING(secondPart, INDEX(secondPart,":":u), -1,
                                 "CHARACTER":u), "}":U)
                + "*/ TRUE":u.
            
    /* Shorten the list and move to the next clause. */
    IF endClause + 1 >= LENGTH(source, "CHARACTER":u) 
      OR LENGTH(source, "CHARACTER":u) = 0 THEN LEAVE.

    source = SUBSTRING(source, endClause + 1 ,-1, "CHARACTER":u).
  END.
END PROCEDURE.

/* _read.p - end of file */


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
/* s-where.p - state machine to build a WHERE-clause */

{ prores/s-system.i }
{ prores/s-edit.i NEW 20 }
{ prores/t-define.i }
{ prores/s-define.i }
{ prores/t-set.i &mod=s &set=2 }

/*
11. pick field
    goto 21
21. pick comparison operator
    goto 31
31. enter value or {ask}
    if ask goto 41
    goto 51
41. enter {ask} question
    goto 51
51. if not (= or <> or 'contains' or 'matches') goto 61
    ask for mult
    if yes goto 31
    goto 61
61. ask for more
    if yes goto 71
    goto 99
71. and/or
    goto 11
81. enter expert mode
    goto 99
99. end
*/

/*
+------------------- PICK A FIELD --------------++--------- OPERATORS --------+
|                                               ||_Greater or Equal_          |
|                                               ||       DATA                 |
|       SCROLLING                               ||     OPERATORS              |
|       FIELD                                   ||      WINDOWS               |
|       LIST                                    |+----------------------------+
|                                               |+------- Enter a Value ------+
|                                               ||_123456789012345678901234567_
|12345678901234567890123456789012345678901234567|| VALUE BOX                  |
+-----------------------------------------------++----------------------------+
+-----------------------------------------------------------------------------+
|                            WHERE EXPRESSION                                 |
|                                                                             |
+-----------------------------------------------------------------------------+
*/

DEFINE INPUT        PARAMETER qbf-g AS LOGICAL   NO-UNDO. /* ask flag */
DEFINE INPUT        PARAMETER qbf-f AS CHARACTER NO-UNDO. /* filename */
DEFINE INPUT-OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* output */

DEFINE VARIABLE qbf#   AS INTEGER   INITIAL 11 NO-UNDO. /* current state */
DEFINE VARIABLE qbf-a  AS LOGICAL              NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-b  AS CHARACTER            NO-UNDO. /* combine */
DEFINE VARIABLE qbf-c  AS CHARACTER            NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d  AS CHARACTER            NO-UNDO. /* data type */
DEFINE VARIABLE qbf-e  AS CHARACTER EXTENT 100 NO-UNDO. /* expression array */
DEFINE VARIABLE qbf-e# AS INTEGER   INITIAL  0 NO-UNDO. /* expression array */
DEFINE VARIABLE qbf-h  AS INTEGER              NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-i  AS INTEGER              NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l  AS INTEGER   INITIAL  0 NO-UNDO. /* where '(' goes */
DEFINE VARIABLE qbf-n  AS CHARACTER            NO-UNDO. /* field name */
DEFINE VARIABLE qbf-p  AS CHARACTER            NO-UNDO. /* comparison */
DEFINE VARIABLE qbf-r  AS CHARACTER            NO-UNDO. /* combine */
DEFINE VARIABLE qbf-s  AS INTEGER   INITIAL 99 NO-UNDO. /* prev state */
DEFINE VARIABLE qbf-t  AS CHARACTER            NO-UNDO. /* field format */
DEFINE VARIABLE qbf-v  AS CHARACTER            NO-UNDO. /* value holder */
DEFINE VARIABLE qbf-w  AS CHARACTER            NO-UNDO. /* holds orig qbf-o */

/*
  Future:
  10: "Range of Values"
  11: "List of Values"
  12: "Sounds Like"
*/

{ prores/c-field.i
  &new=NEW &down=14 &row="ROW 2" &column="COLUMN 1"
  &title="' ' + qbf-lang[10] + ' '"
}
/* title = "Choose a Field" */

FORM
  qbf-o FORMAT "x(78)" SKIP
  qbf-c FORMAT "x(78)" SKIP
  WITH OVERLAY FRAME qbf--select ROW 18 NO-LABELS WIDTH 80 NO-ATTR-SPACE
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) " " + qbf-lang[11] + " ". /*"Expression"*/

FORM SKIP(1)
  qbf-v FORMAT "x(32)" SKIP(1)
  WITH FRAME qbf-fake ROW 13 COLUMN 45 WIDTH 36 OVERLAY ATTR-SPACE NO-LABELS
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) " " + qbf-lang[12] + " ". /*"Enter a value"*/

FORM
  qbf-lang[1] FORMAT "x(16)" SKIP
  qbf-lang[2] FORMAT "x(16)" SKIP
  qbf-lang[3] FORMAT "x(16)" SKIP
  qbf-lang[4] FORMAT "x(16)" SKIP
  qbf-lang[5] FORMAT "x(16)" SKIP
  qbf-lang[6] FORMAT "x(16)" SKIP
  qbf-lang[7] FORMAT "x(16)" SKIP
  qbf-lang[8] FORMAT "x(16)" SKIP
  qbf-lang[9] FORMAT "x(16)" SKIP
  WITH FRAME qbf--x9 ROW 2 COLUMN 45 WIDTH 36 OVERLAY NO-LABELS ATTR-SPACE
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo) " " + qbf-lang[13] + " ". /*"Comparisons"*/

FORM " " SKIP
  WITH FRAME qbf--shadow ROW 9 COLUMN 1 WIDTH 81 OVERLAY
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  NO-BOX NO-LABELS NO-ATTR-SPACE.
FORM SKIP(1)
  qbf-v FORMAT "x(76)" SKIP(1)
  HEADER
  qbf-lang[14] FORMAT "x(72)" SKIP
  qbf-lang[15] FORMAT "x(72)" SKIP
  /*"At run-time, ask the user for a value."*/
  /*"Enter the question to ask at run-time:"*/
  WITH FRAME qbf--asker ROW 10 COLUMN 1 OVERLAY NO-LABELS ATTR-SPACE
  COLOR DISPLAY VALUE(qbf-plo) PROMPT VALUE(qbf-phi)
  TITLE COLOR VALUE(qbf-plo)
    " " + qbf-lang[16] + " "
    + CAPS(SUBSTRING(qbf-d,1,1)) + LC(SUBSTRING(qbf-d,2))
    + " " + qbf-lang[17] + " ".
  /*" Ask For <Datatype> Value "*/

PAUSE 0.
VIEW FRAME qbf--x9.
VIEW FRAME qbf-fake.
VIEW FRAME qbf-pick.

IF LENGTH(qbf-o) <= 156 THEN
  DISPLAY qbf-o SUBSTRING(qbf-o,79) @ qbf-c WITH FRAME qbf--select.
ELSE
  DISPLAY "..." +
    SUBSTRING(qbf-o,LENGTH(qbf-o) - 152,75) @ qbf-o
    SUBSTRING(qbf-o,LENGTH(qbf-o) -  77,78) @ qbf-c
    WITH FRAME qbf--select.

ASSIGN
  qbf-w = qbf-o
  qbf-o = "".

DO WHILE qbf# <> 99:

  PAUSE 0.
  STATUS DEFAULT.
  STATUS INPUT.
  HIDE MESSAGE NO-PAUSE.
  PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 COLOR NORMAL FILL(" ",78).
  PUT SCREEN ROW SCREEN-LINES + 2 COLUMN 1 COLOR MESSAGES STRING(
    (IF INDEX(qbf-o,"~{~{") = 0 THEN qbf-lang[20] + "  " ELSE "")
    + qbf-lang[IF qbf-s = 99 THEN 18 ELSE 19]
    ,"x(78)").
  /*18: "Press [END-ERROR] to exit."*/
  /*19: "Press [END-ERROR] to undo last step."*/
  /*20: "Press [GET] for expert mode."*/
  ASSIGN
    qbf-e#        = qbf-e# + 1
    qbf-e[qbf-e#] = "".

/* 11. pick field */
/*     goto 21 */
  IF qbf# = 11 THEN _s11: DO:
    COLOR DISPLAY VALUE(qbf-plo) qbf-lang[1 FOR 9] WITH FRAME qbf--x9.
    ASSIGN
      qbf-c      = qbf-module
      qbf-module = "w1s".
    RUN prores/s-field.p
      (qbf-f,"","!raw,!rowid,*",INPUT-OUTPUT qbf-n).
    qbf-module = qbf-c.
    IF qbf-n = "" OR CAN-DO("GET,END-ERROR",KEYFUNCTION(LASTKEY))
      THEN LEAVE _s11.
    RUN prores/s-lookup.p
      (qbf-n,"","","FIELD:TYP&FMT",OUTPUT qbf-c).
    qbf-n = SUBSTRING(qbf-n,R-INDEX(qbf-n,".") + 1).
    ASSIGN
      qbf-s         = qbf#
      qbf#          = 21
      qbf-d         = ENTRY(INTEGER(ENTRY(1,qbf-c)),qbf-dtype)
      qbf-t         = SUBSTRING(qbf-c,INDEX(qbf-c,",") + 1)
      qbf-l         = qbf-e#
      qbf-e[qbf-e#] = qbf-f + "." + qbf-n.
  END.

/* 21. pick comparison operator */
/*     goto 31 */
  ELSE
  IF qbf# = 21 THEN _s21: DO:
    STATUS DEFAULT qbf-lang[21].
    /*"Select the type of comparison to perform on the field."*/
    ASSIGN
      qbf-p      = ""
      qbf-c      = qbf-module
      qbf-module = "w2s".
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE WITH FRAME qbf--x9:
      IF qbf-d = "character" THEN DO:
        DISPLAY qbf-lang[1 FOR 9].
        CHOOSE FIELD qbf-lang[1 FOR 9]
          GO-ON("F5" "CTRL-G") COLOR VALUE(qbf-phi).
      END.
      ELSE IF qbf-d = "logical" THEN DO:
        DISPLAY qbf-lang[1 FOR 2]           "" @ qbf-lang[3]
          "" @ qbf-lang[4] "" @ qbf-lang[5] "" @ qbf-lang[6]
          "" @ qbf-lang[7] "" @ qbf-lang[8] "" @ qbf-lang[9].
        CHOOSE FIELD qbf-lang[1 FOR 2]
          GO-ON("F5" "CTRL-G") COLOR VALUE(qbf-phi).
      END.
      ELSE DO:
        DISPLAY qbf-lang[1 FOR 6]
          "" @ qbf-lang[7] "" @ qbf-lang[8] "" @ qbf-lang[9].
        CHOOSE FIELD qbf-lang[1 FOR 6]
          GO-ON("F5" "CTRL-G") COLOR VALUE(qbf-phi).
      END.
      qbf-p = qbf-lang[FRAME-INDEX].
    END.
    qbf-module = qbf-c.
    STATUS DEFAULT.
    IF qbf-p = "" OR KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO:
      DISPLAY
        "" @ qbf-lang[1] "" @ qbf-lang[2] "" @ qbf-lang[3]
        "" @ qbf-lang[4] "" @ qbf-lang[5] "" @ qbf-lang[6]
        "" @ qbf-lang[7] "" @ qbf-lang[8] "" @ qbf-lang[9]
        WITH FRAME qbf--x9.
      LEAVE _s21.
    END.

    /* translate to progress operator */
    IF      qbf-p = qbf-lang[1] THEN qbf-r = "=".
    ELSE IF qbf-p = qbf-lang[2] THEN qbf-r = "<>".
    ELSE IF qbf-p = qbf-lang[3] THEN qbf-r = "<".
    ELSE IF qbf-p = qbf-lang[4] THEN qbf-r = "<=".
    ELSE IF qbf-p = qbf-lang[5] THEN qbf-r = ">".
    ELSE IF qbf-p = qbf-lang[6] THEN qbf-r = ">=".
    ELSE IF qbf-p = qbf-lang[7] THEN qbf-r = "BEGINS".
    ELSE IF qbf-p = qbf-lang[8] THEN qbf-r = "MATCHES".
    ELSE IF qbf-p = qbf-lang[9] THEN qbf-r = "MATCHES".

    qbf-b = "".
    IF      qbf-r = "="  THEN qbf-b = "OR".
    ELSE IF qbf-r = "<>" THEN qbf-b = "AND".
    ELSE IF qbf-r = "MATCHES" THEN qbf-b = "OR".
    ASSIGN
      qbf-e[qbf-e#] = qbf-r
      qbf-s         = qbf#
      qbf#          = 31.

  END.

/* 31. enter value or {ask} */
/*     if ask goto 41 */
/*     if combinable goto 51 */
/*     goto 61 */
  ELSE
  IF qbf# = 31 THEN _s31: DO:

    IF qbf-g THEN
      /*"Press [PUT] to prompt for a value at run-time."*/
      PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 COLOR MESSAGES qbf-lang[24].
    /*'Enter the {1} value to compare with "{2}".'*/
    ASSIGN
      qbf-v = qbf-lang[22]
      SUBSTRING(qbf-v,INDEX(qbf-v,"~{1~}"),3) = qbf-d
      SUBSTRING(qbf-v,INDEX(qbf-v,"~{2~}"),3) = qbf-n.
    STATUS INPUT qbf-v.
    ASSIGN
      qbf-i = { prores/s-size.i &type=LOOKUP(qbf-d,qbf-dtype) &format=qbf-t }
      qbf-v = "".
    IF qbf-i > 72 THEN
      qbf-t = (IF qbf-d = "date"      THEN "99/99/99"
          ELSE IF qbf-d = "character" THEN "x(72)"
          ELSE IF qbf-d = "logical"   THEN
            LC(TRIM(ENTRY(1,qbf-boolean)) + "/" + TRIM(ENTRY(2,qbf-boolean)))
          ELSE "->>>,>>>,>>9.<<<<<<<<<<").
    /* now recalc length in case above line changed anything */
    qbf-i = { prores/s-size.i &type=LOOKUP(qbf-d,qbf-dtype) &format=qbf-t }.
    RUN prores/s-quote.p (qbf-t,'"',OUTPUT qbf-c).
    OUTPUT TO VALUE(qbf-tempdir + ".p") NO-ECHO NO-MAP.
    PUT UNFORMATTED
      'DEFINE OUTPUT PARAMETER qbf-v AS CHARACTER NO-UNDO.' SKIP.
    IF qbf-d <> "character" THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE qbf-v2 AS ' CAPS(qbf-d)
          (IF qbf-d = "date" THEN ' INITIAL TODAY' ELSE '')
          ' NO-UNDO.' SKIP.
    PUT UNFORMATTED
      'DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:' SKIP
      '  UPDATE SKIP(1)' SKIP
        '    qbf-v' (IF qbf-d = "character" THEN '' ELSE '2')
        ' FORMAT ' qbf-c ' SKIP(1)' SKIP
      '    WITH FRAME qbf-make OVERLAY ATTR-SPACE NO-LABELS'
        ' ROW 13 COLUMN ' MINIMUM(77 - qbf-i,45)
        ' WIDTH ' MAXIMUM(36,qbf-i + 4) SKIP.
    RUN prores/s-quote.p (qbf-lang[12],?,OUTPUT qbf-c).
    PUT UNFORMATTED
      '    TITLE COLOR NORMAL " ' qbf-c ' "' SKIP /*12:"Enter a value"*/
      '    EDITING:' SKIP
      '      READKEY.' SKIP
      '      APPLY (IF KEYFUNCTION(LASTKEY) = "GET"' SKIP.
    IF qbf-g THEN
      PUT UNFORMATTED '        OR KEYFUNCTION(LASTKEY) = "PUT"' SKIP.
    PUT UNFORMATTED
      '        THEN KEYCODE(KBLABEL("GO")) ELSE LASTKEY).' SKIP
      '    END.' SKIP
      'END.' SKIP.
    IF qbf-d = "decimal" THEN
      PUT UNFORMATTED
        'qbf-v = (IF qbf-v2 > -1 AND qbf-v2 < 0 THEN "-" ELSE "") + '
        'STRING(TRUNCATE(qbf-v2,0)) + '
        '(IF qbf-v2 = TRUNCATE(qbf-v2,0) THEN "" ELSE ".") + '
        'SUBSTRING(STRING(qbf-v2 - TRUNCATE(qbf-v2,0)),'
        'IF qbf-v2 < 0 THEN 3 ELSE 2).' SKIP.
    ELSE
    IF qbf-d = "date" THEN
      PUT UNFORMATTED 'qbf-v = STRING(MONTH(qbf-v2)) + "/" + '
        'STRING(DAY(qbf-v2)) + "/" + STRING(YEAR(qbf-v2)).' SKIP.
    ELSE
    IF qbf-d <> "character" THEN
      PUT UNFORMATTED 'qbf-v = STRING(qbf-v2).' SKIP.
    PUT UNFORMATTED
      'HIDE FRAME qbf-make NO-PAUSE.' SKIP
      'RETURN.' SKIP.
    OUTPUT CLOSE.
    COMPILE VALUE(qbf-tempdir + ".p") ATTR-SPACE.

    ASSIGN
      qbf-c      = qbf-module
      qbf-module = "where," + qbf-f + "." + qbf-n.
    RUN VALUE(qbf-tempdir + ".p") (OUTPUT qbf-v).
    qbf-module = qbf-c.

    IF KEYFUNCTION(LASTKEY) = "PUT" THEN
      ASSIGN
        qbf-s = qbf#
        qbf#  = 41.
    IF CAN-DO("GET,PUT,END-ERROR",KEYFUNCTION(LASTKEY)) THEN LEAVE _s31.
    /* add quotes/stars, etc. on the value */
    IF qbf-d = "character" AND qbf-v MATCHES '"*"' THEN
      qbf-v = SUBSTRING(qbf-v,2,LENGTH(qbf-v) - 2).
    IF qbf-p = qbf-lang[8] THEN qbf-v = "*" + qbf-v + "*". /*Contains*/
    IF qbf-d = "character" THEN
      RUN prores/s-quote.p (qbf-v,'"',OUTPUT qbf-v).
    ELSE IF qbf-v = ? THEN qbf-v = "?".

    DISPLAY
      (IF LENGTH(qbf-v) > 32 THEN SUBSTRING(qbf-v,1,29) + "..." ELSE qbf-v)
      @ qbf-v WITH FRAME qbf-fake.

    ASSIGN
      qbf-e[qbf-e#] = qbf-v
      qbf-s         = qbf#
      qbf#          = (IF qbf-b = "" THEN 61 ELSE 51).

  END.


/* 41. enter {ask} question */
/*     goto 51 */
  ELSE
  IF qbf# = 41 THEN DO:
    ASSIGN
      qbf-v = qbf-lang[23]
      SUBSTRING(qbf-v,INDEX(qbf-v,"~{1~}"),3) = qbf-d
      SUBSTRING(qbf-v,INDEX(qbf-v,"~{2~}"),3) = qbf-n.
    /*'Please enter the {1} value for "{2}".'*/
    VIEW FRAME qbf--shadow.
    DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
      UPDATE qbf-v
        VALIDATE(qbf-v <> ?,qbf-lang[28]) /*Must not be unknown value!*/
        WITH FRAME qbf--asker.
    END.
    HIDE FRAME qbf--shadow NO-PAUSE.
    HIDE FRAME qbf--asker  NO-PAUSE.
    IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN
      ASSIGN
        qbf-v         = "~{~{" + qbf-d + ","       /* datatype */
                      + qbf-f + "." + qbf-n + ","  /* file.field name */
                      + qbf-p + ":"                /* comparison */
                      + qbf-v + "~}~}"             /* question */
        qbf-e[qbf-e#] = qbf-v
        qbf-s         = qbf#
        qbf#          = (IF qbf-b = "" THEN 61 ELSE 51).
  END.

/* 51. if not (= or <> or 'contains' or 'matches') goto 61 */
/*     ask for mult */
/*     if yes goto 31 */
/*     goto 61 */
  ELSE
  IF qbf# = 51 THEN _s51: DO:
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,
      qbf-lang[29] + ' "' + qbf-n + '"? ').
    /*"Enter more values for"*/
    IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN LEAVE _s51.
    IF NOT qbf-a THEN DO:
      ASSIGN
        qbf-e[qbf-e#] = (IF qbf-l < 0 THEN ")" ELSE "")
        qbf-s         = qbf#
        qbf#          = 61.
      LEAVE _s51.
    END.
    ASSIGN
      qbf-e[qbf-e#] = qbf-b + " " + qbf-f + "." + qbf-n + " " + qbf-r
      qbf-s         = qbf#
      qbf#          = 31.

    IF qbf-l > 0 THEN
      ASSIGN
        qbf-e[qbf-l] = "(" + qbf-e[qbf-l]
        qbf-l        = - qbf-l.
  END.

/* 61. ask for more */
/*     if yes goto 71 */
/*     goto 99 */
  ELSE
  IF qbf# = 61 THEN DO:
    /* now user might want to choose another field */
    qbf-a = FALSE.
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a,?,?,"#30").
    /*"Enter more selection criteria?"*/
    IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN
      ASSIGN
        qbf-s = qbf#
        qbf#  = (IF qbf-a THEN 71 ELSE 99).
  END.

/* 71. and/or */
/*     goto 11 */
  ELSE
  IF qbf# = 71 THEN DO:
    qbf-a = TRUE.
    RUN prores/s-box.p (INPUT-OUTPUT qbf-a," AND"," OR","#31").
    /*"Combine with previous criteria using?*/
    IF KEYFUNCTION(LASTKEY) <> "END-ERROR" THEN
      ASSIGN
        qbf-s         = qbf#
        qbf#          = 11
        qbf-e[qbf-e#] = (IF qbf-a THEN "AND" ELSE "OR").
  END.

/* 81. enter expert mode */
/*     goto 99 */
  ELSE
  IF qbf# = 81 THEN DO: /* expert mode */
    ASSIGN
      qbf#  = 99
      qbf-n = ""
      qbf-o = (IF qbf-o = "" THEN qbf-w ELSE qbf-o).
    { prores/s-split.i &src=qbf-o &dst=qbf-text &num=20 &len=72 &chr=" " }
    PAUSE 0 BEFORE-HIDE.
    HIDE MESSAGE.
    PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 COLOR NORMAL FILL(" ",78).
    PUT SCREEN ROW SCREEN-LINES + 2 COLUMN 1 COLOR NORMAL FILL(" ",78).

    DO ON ERROR UNDO,RETRY ON ENDKEY UNDO,LEAVE:
      IF RETRY THEN DO:
        RUN prores/s-quoter.p
          (qbf-tempdir + ".d",qbf-tempdir + ".p").
        DO qbf-i = qbf-text# TO 1 BY -1.
          IF qbf-text[qbf-i] <> "" THEN LEAVE.
        END.
        INPUT FROM VALUE(qbf-tempdir + ".p") NO-ECHO.
        REPEAT:
          IMPORT qbf-c.
          ASSIGN
            qbf-c = (IF qbf-c BEGINS "**" THEN "" ELSE "** ") + qbf-c
            qbf-h = INDEX(qbf-c,qbf-tempdir + ".p").
          IF qbf-h > 0 THEN SUBSTRING(qbf-c,qbf-h,6) = "".
          ASSIGN
            qbf-i           = qbf-i + 1
            qbf-text[qbf-i] = qbf-c.
        END.
        INPUT CLOSE.
      END.
      ASSIGN
        qbf-c      = qbf-module
        qbf-module = "w4s"
        qbf-o      = ""
        qbf-e#     = 0.
      PAUSE 0.
      /*VIEW FRAME qbf--box. GJO 07-13-93 repaint menu problem. */
      RUN prores/s-edit.p
        (12,qbf-lang[32],OUTPUT qbf-a). /*"Expert Mode"*/
      ASSIGN
        qbf-module = qbf-c
        qbf-c      = ?.
      /* HIDE FRAME qbf--box NO-PAUSE. GJO ***/
      IF NOT qbf-a THEN UNDO,LEAVE.
      DO qbf-i = 1 TO qbf-text#:
        IF qbf-text[qbf-i] BEGINS "**" THEN qbf-text[qbf-i] = "".
        IF qbf-text[qbf-i] = "" THEN NEXT.
        qbf-o = qbf-o + " " + qbf-text[qbf-i].
      END.
      ASSIGN
        qbf-e#   = 1
        qbf-e[1] = TRIM(qbf-o).
      OUTPUT TO VALUE(qbf-tempdir + ".p") NO-ECHO NO-MAP.
        DO qbf-i = 1 TO 5 WHILE qbf-file[qbf-i] <> "":
          IF qbf-f <> qbf-db[qbf-i] + "." + qbf-file[qbf-i] THEN
            PUT UNFORMATTED
              'FIND FIRST ' qbf-db[qbf-i] '.' qbf-file[qbf-i]
              ' NO-LOCK NO-ERROR.' SKIP.
        END.
        PUT UNFORMATTED 'FIND FIRST ' qbf-f ' WHERE ' qbf-e[1] '.' SKIP.
      OUTPUT CLOSE.
      ASSIGN
        qbf-c = SEARCH(qbf-tempdir + ".p")
        SUBSTRING(qbf-c,LENGTH(qbf-c),1) = "r".
      INPUT FROM VALUE(qbf-tempdir + ".p") NO-ECHO.
        /* input from is a dummy to suppress message to screen */
      OUTPUT TO VALUE(qbf-tempdir + ".d") NO-ECHO.
      DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
        COMPILE VALUE(qbf-tempdir + ".p") SAVE ATTR.
      END.
      OUTPUT CLOSE.
      INPUT CLOSE.
      IF qbf-c <> SEARCH(qbf-tempdir + ".r") THEN UNDO,RETRY.
    END.
    PAUSE BEFORE-HIDE.
    IF qbf-c <> ? THEN 
      RUN prores/a-zap.p (qbf-c).
  END.

/* help! unknown state! */
  ELSE DO:
    RUN prores/s-error.p
      ("Unknown state " + STRING(qbf#) + "   qbf-s=" + STRING(qbf-s)).
    ASSIGN
      qbf-e#   = 1
      qbf-e[1] = ""
      qbf-s    = 99
      qbf#     = 99.
  END.

/* 99. end */
  IF KEYFUNCTION(LASTKEY) = "END-ERROR" THEN DO: /* undo last / leave */
    ASSIGN
      qbf#   = qbf-s
      qbf-s  = 99
      qbf-e# = qbf-e# - 2.
    IF qbf-l < 0 THEN
      ASSIGN
        qbf-l        = - qbf-l
        qbf-e[qbf-l] = SUBSTRING(qbf-e[qbf-l],2).
    IF qbf# = 99 THEN qbf-e# = 0.
  END.
  ELSE
  IF KEYFUNCTION(LASTKEY) = "GET" THEN DO: /* go to expert mode */
    IF INDEX(qbf-o,"~{~{") < INDEX(qbf-o,"~}~}")
      OR (qbf-o = "" AND INDEX(qbf-w,"~{~{") < INDEX(qbf-w,"~}~}")) THEN DO:
      RUN prores/s-error.p ("#27").
      /* Sorry, but "expert mode" is not compatible with "ask for */
      /* a value at run-time".  You must use one or the other.    */
    END.
    ELSE
      ASSIGN
        qbf-s = qbf#
        qbf#  = 81.
  END.

  qbf-o = "".
  DO qbf-i = 1 TO qbf-e#:
    qbf-o = qbf-o
          + (IF qbf-i = 1 OR qbf-e[qbf-i] = ")" OR qbf-o MATCHES "* "
            THEN "" ELSE " ")
          + qbf-e[qbf-i].
  END.
  IF qbf# <> 81 OR qbf-o <> "" OR INPUT FRAME qbf--select qbf-o = "" THEN
    IF LENGTH(qbf-o) <= 156 THEN
      DISPLAY qbf-o SUBSTRING(qbf-o,79) @ qbf-c WITH FRAME qbf--select.
    ELSE
      DISPLAY "..." +
        SUBSTRING(qbf-o,LENGTH(qbf-o) - 152,75) @ qbf-o
        SUBSTRING(qbf-o,LENGTH(qbf-o) -  77,78) @ qbf-c
        WITH FRAME qbf--select.

END. /* end of major loop */

qbf-o = TRIM(qbf-o).

HIDE MESSAGE NO-PAUSE.
PUT SCREEN ROW SCREEN-LINES + 1 COLUMN 1 FILL(" ",78).
PUT SCREEN ROW SCREEN-LINES + 2 COLUMN 1 FILL(" ",78).
STATUS DEFAULT.
STATUS INPUT.

HIDE FRAME qbf--asker  NO-PAUSE.
HIDE FRAME qbf--select NO-PAUSE.
HIDE FRAME qbf--shadow NO-PAUSE.
HIDE FRAME qbf--x9     NO-PAUSE.
HIDE FRAME qbf-fake    NO-PAUSE.
HIDE FRAME qbf-pick    NO-PAUSE.

{ prores/t-reset.i }
RETURN.

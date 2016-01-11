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
 * s-ask.p - prompt user for 'ask at run-time' WHERE-clause questions
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/t-define.i }
{ aderes/s-alias.i } 

DEFINE INPUT        PARAMETER qbf-f   AS CHARACTER NO-UNDO. /* output file */
DEFINE INPUT        PARAMETER g-mode  AS LOGICAL   NO-UNDO. 
DEFINE INPUT-OUTPUT PARAMETER qbf-a   AS LOGICAL   NO-UNDO.
/*
input value:  TRUE  = do asking
              FALSE = load up qbf-wask "pretty" from qbf-wcls
return value: TRUE  = all okay
              FALSE = end-error pressed
*/

DEFINE VARIABLE cTable  AS CHARACTER NO-UNDO. /* alias table */
DEFINE VARIABLE calcFld AS LOGICAL   NO-UNDO. /* calc field */
DEFINE VARIABLE calcFmt AS CHARACTER NO-UNDO. /* calc field format */
DEFINE VARIABLE cFile   AS CHARACTER NO-UNDO. /* prompt dialog file */
DEFINE VARIABLE iCount  AS INTEGER   NO-UNDO. /* prompt dialog counter */
DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d   AS CHARACTER NO-UNDO. /* datatype */
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-l   AS INTEGER   NO-UNDO. /* position of '/' + '*' */
DEFINE VARIABLE qbf-n   AS CHARACTER NO-UNDO. /* field-name */
DEFINE VARIABLE qbf-p   AS CHARACTER NO-UNDO. /* comparison */
DEFINE VARIABLE qbf-q   AS CHARACTER NO-UNDO. /* user's question */
DEFINE VARIABLE qbf-r   AS INTEGER   NO-UNDO. /* position of '*' + '/' */
DEFINE VARIABLE qbf-t   AS CHARACTER NO-UNDO. /* format */
DEFINE VARIABLE qbf-v   AS CHARACTER NO-UNDO. /* value holder */
DEFINE VARIABLE qbf-w   AS CHARACTER NO-UNDO. /* value holder */
DEFINE VARIABLE qbf-x   AS CHARACTER NO-UNDO. /* context */
DEFINE VARIABLE suffix  AS INTEGER   NO-UNDO INIT 1. /* suffix counter */

/* qbf-v contains the user-supplied values.  Values are separated by CHR(10),
   since the user might enter some other character that would conflict with 
   our delimiter character.  The first entry is one of the following:

   can = user aborted dialog box
   nor = no range present
   inc = inclusive range 
   exc = exclusive range

   If a WHERE phrase involved an inclusive range, followed by a non-range
   Ask-At-Runtime phrase, qbf-v would look like this:

   inc
   value1	(lower bound value)
   value2	(upper bound value)
   value3
*/

IF NOT qbf-a THEN DO:
  FOR EACH qbf-where:
    ASSIGN
      qbf-where.qbf-wask = qbf-where.qbf-wcls
      qbf-l              = INDEX(qbf-where.qbf-wask,"/*":u) + 2
      qbf-r              = INDEX(qbf-where.qbf-wask,"*/":u) - qbf-l.
    DO WHILE qbf-l > 1 AND qbf-r > 0:
      ASSIGN
        SUBSTRING(qbf-where.qbf-wask,qbf-l - 2,qbf-r + 4,"CHARACTER":u) =
            "[":u 
          + ENTRY(1,SUBSTRING(qbf-where.qbf-wask,qbf-l,qbf-r,"CHARACTER":u))
          + "]":u
        qbf-l = INDEX(qbf-where.qbf-wask,"/*":u) + 2
        qbf-r = INDEX(qbf-where.qbf-wask,"*/":u) - qbf-l.
    END.
  END.
  qbf-a = TRUE.
  RETURN.
END.

/* make sure output file is empty for generating dynamic ask-at-runtime */
IF g-mode AND
  CAN-FIND(FIRST qbf-where WHERE INDEX(qbf-where.qbf-wcls,"/*":u) > 0
                             AND INDEX(qbf-where.qbf-wcls,"*/":u) > 0) THEN DO:
  OUTPUT TO VALUE(qbf-f) NO-ECHO NO-MAP.
  OUTPUT CLOSE.      
END.

qbf-outer:
FOR EACH qbf-where:
  ASSIGN
    qbf-where.qbf-wask = qbf-where.qbf-acls 
                       + (IF qbf-where.qbf-acls > "" AND
                            qbf-where.qbf-wcls > "" THEN " AND ":u ELSE "")
                       + qbf-where.qbf-wcls
    qbf-where.qbf-wask = REPLACE(qbf-where.qbf-wask,"*/ TRUE":u,"*/":u)
    qbf-l              = INDEX(qbf-where.qbf-wask,"/*":u)
    qbf-r              = INDEX(qbf-where.qbf-wask,"*/":u)
    qbf-w              = "".

  {&FIND_TABLE_BY_ID} qbf-where.qbf-wtbl.
  
  /*    v-- qbf-l                                qbf-r --v    */
  /* .../*data-type,db.file.field,comparison:explanation*/... */
  /*      |.qbf-d.| |...qbf-n...| |.qbf-p..| |..qbf-q..|      */
  
  DO WHILE qbf-l > 0 AND qbf-r > qbf-l:
    ASSIGN
      qbf-q   = SUBSTRING(qbf-where.qbf-wask,qbf-l + 2,
                          qbf-r - qbf-l - 2,"CHARACTER":u)
      qbf-d   = ENTRY(1,qbf-q)
      qbf-n   = ENTRY(2,qbf-q)
      calcFld = FALSE
      calcFmt = ""
      .

    /* check if qbf-n is a calculated field */
    DO qbf-i = 1 TO qbf-rc#:
      IF qbf-n = ENTRY(1,qbf-rcn[qbf-i]) THEN LEAVE.
    END.
   
    /* strip [[db.]file.] for non-calc fields */
    IF qbf-i <= qbf-rc# AND qbf-rcc[qbf-i] > "" THEN 
      ASSIGN
        calcFld = TRUE
        calcFmt = qbf-rcf[qbf-i]
        .
    ELSE
      qbf-n  = SUBSTRING(qbf-n,R-INDEX(qbf-n,".":u) + 1,-1,"CHARACTER":u).

    ASSIGN
      qbf-p  = ENTRY(3,SUBSTRING(qbf-q,1,INDEX(qbf-q,":":u) - 1,"CHARACTER":u))
      qbf-q  = SUBSTRING(qbf-q,INDEX(qbf-q,":":u) + 1,-1,"CHARACTER":u)

      /*'Enter the {1} value to compare with "{2}".'*/
      qbf-c  = 'Enter the ~{1~} value to compare with "~{2~}".'
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{1~}":u),3,"CHARACTER":u) = qbf-d
      SUBSTRING(qbf-c,INDEX(qbf-c,"~{2~}":u),3,"CHARACTER":u) = qbf-n.
     
    IF NOT g-mode THEN 
      STATUS INPUT qbf-c.

    RUN aderes/s-quote.p (qbf-q, ?, OUTPUT qbf-q).

    RUN alias_to_tbname (qbf-rel-buf.tname, FALSE, OUTPUT cTable).

    IF calcFld THEN
      qbf-t = calcFmt.
    ELSE DO:
      RUN adecomm/_y-schem.p (cTable, "", qbf-n, OUTPUT qbf-t).
      
      qbf-t = REPLACE(ENTRY(2,qbf-t,CHR(10)),"%":u,"").
    END.

    ASSIGN qbf-i = {aderes/s-size.i &type=LOOKUP(qbf-d,qbf-dtype) 
                                    &format=qbf-t} NO-ERROR.
    IF qbf-i > 72 THEN
      qbf-t = (IF qbf-d = "character":u THEN "x(72)":u
          ELSE IF qbf-d = "logical":u   THEN "Yes     /No      "
          ELSE IF qbf-d = "date":u      THEN "99/99/99":u
          ELSE                               "->>>,>>>,>>9.<<<<<<<<<<":u).
          
    RUN aderes/s-quote.p (qbf-t, ?, OUTPUT qbf-t).

    qbf-t = IF qbf-p <> "list":u THEN qbf-t
            ELSE "x(":u + STRING(LENGTH(qbf-t,"RAW":u)) + ")":u.

    ASSIGN
      /*'Context: {1} is {2} some {3} value.'*/
      qbf-x = 'Context: ~{1~} is ~{2~} some ~{3~} value.'
      SUBSTRING(qbf-x,INDEX(qbf-x,"~{1~}":u),3,"CHARACTER":u) = qbf-n
      SUBSTRING(qbf-x,INDEX(qbf-x,"~{2~}":u),3,"CHARACTER":u) = qbf-p
      SUBSTRING(qbf-x,INDEX(qbf-x,"~{3~}":u),3,"CHARACTER":u) = qbf-d.
      
    RUN aderes/s-quote.p (qbf-x,'"':u,OUTPUT qbf-x).

    IF g-mode THEN
      OUTPUT TO VALUE(qbf-f) APPEND NO-ECHO NO-MAP.
    ELSE DO:
      ASSIGN
        iCount = iCount + 1
        cFile  = qbf-tempdir + STRING(iCount,"999.p":u).
      
      OUTPUT TO VALUE(cFile) NO-ECHO NO-MAP.
    END.
 
    IF NOT g-mode THEN 
    PUT UNFORMATTED
      'DEFINE OUTPUT PARAMETER qbf-v AS CHARACTER NO-UNDO.':u SKIP
      'DEFINE OUTPUT PARAMETER qbf-c AS LOGICAL   NO-UNDO.':u SKIP(1) .

    PUT UNFORMATTED
      'DEFINE VARIABLE qbf-beg-':u STRING(suffix) ' AS ':u
        (IF qbf-p = "list":u THEN "CHARACTER":u ELSE qbf-d) ' NO-UNDO.':u SKIP
      'DEFINE VARIABLE qbf-end-':u STRING(suffix) ' AS ':u
        (IF qbf-p = "list":u THEN "CHARACTER":u ELSE qbf-d) ' NO-UNDO.':u SKIP
      'DEFINE VARIABLE qbf-inc-':u STRING(suffix) 
      ' AS LOGICAL   NO-UNDO INITIAL TRUE.':u SKIP.

    IF suffix = 1 THEN
      PUT UNFORMATTED
        'DEFINE VARIABLE qbf-bscr  AS CHARACTER NO-UNDO. /* scrap */':u SKIP
        'DEFINE VARIABLE qbf-escr  AS CHARACTER NO-UNDO. /* scrap */':u SKIP(1)
        'DEFINE BUTTON qbf-ok LABEL "':u 'OK' 
           '"     SIZE 8 BY 1 AUTO-GO.':u SKIP
        'DEFINE BUTTON qbf-ee LABEL "':u 'Cancel'
           '" SIZE 8 BY 1 AUTO-ENDKEY.':u SKIP(1).
    ELSE 
      PUT UNFORMATTED " ":u SKIP.

    IF qbf-d = "date":u THEN
      PUT UNFORMATTED
        (IF qbf-p = "list":u THEN
           'qbf-beg-':u + STRING(suffix) + ' = STRING(TODAY).':u
         ELSE IF qbf-p = "range":u THEN
           'qbf-end-':u + STRING(suffix) + ' = TODAY.':u
         ELSE
           'qbf-beg-':u + STRING(suffix) + ' = TODAY.':u) SKIP(1).

    PUT UNFORMATTED 
      'DO ON ERROR UNDO, LEAVE ON ENDKEY UNDO, LEAVE:':u SKIP
      '  FORM SKIP(.5)':u SKIP.

    PUT UNFORMATTED
      '    "':u qbf-q '" AT 2 SPACE(1) SKIP':u SKIP.

    IF qbf-p = "list":u THEN
    PUT UNFORMATTED
      '    "':u '(Enter one value per line)' '" AT 2 SPACE(1)':u SKIP.

    IF qbf-p = "range":u THEN
    PUT UNFORMATTED
      '    SKIP(.5)':u SKIP 
      '    "':u '&Lower Bound' ':" AT 2 VIEW-AS TEXT SKIP(.2)':u SKIP.

    PUT UNFORMATTED
      '    qbf-beg-':u STRING(suffix) ' AT 2 FORMAT "':u qbf-t 
      (IF qbf-p = "list":u THEN '"':u ELSE '" SPACE(1)':u) SKIP.

    IF qbf-p = "list":u THEN
    PUT UNFORMATTED 
      '      VIEW-AS EDITOR INNER-CHARS 30 INNER-LINES 8':u SKIP
      '      SCROLLBAR-VERTICAL SCROLLBAR-HORIZONTAL SPACE(1) SKIP(.5)':u SKIP.

    IF qbf-p = "range":u THEN
    PUT UNFORMATTED
      '    SKIP(.5)':u SKIP
      '    "':u '&Upper Bound' ':" AT 2 VIEW-AS TEXT SKIP(.2)':u SKIP
      '    qbf-end-':u STRING(suffix) ' AT 2 FORMAT "':u qbf-t 
      '" SPACE(1) SKIP(.5)':u SKIP.

    IF qbf-p = "range":u OR qbf-p = "list":u THEN
    PUT UNFORMATTED
      '    qbf-inc-':u STRING(suffix) 
      ' AT 2 VIEW-AS TOGGLE-BOX LABEL "':u '&Inclusive' '"':u SKIP
      .

    PUT UNFORMATTED 
      '    SKIP(1)':u SKIP 
      '    qbf-ok AT 2 qbf-ee SPACE(1) SKIP(.5)':u SKIP(1)
      '    WITH FRAME qbf-ask-':u STRING(suffix) ' OVERLAY ATTR-SPACE':u SKIP
      '    NO-LABELS TITLE "':u 'Ask At Run Time' '"':u SKIP
      '    DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee':u SKIP
      '    VIEW-AS DIALOG-BOX':u
      .
    
    IF qbf-threed THEN
      PUT UNFORMATTED
        ' THREE-D':u.
    
    PUT UNFORMATTED 
      '.':u SKIP(1).

    IF qbf-p = "range":u THEN
    PUT UNFORMATTED 
      '  ON ALT-L OF FRAME qbf-ask-':u STRING(suffix) SKIP
      '    APPLY "ENTRY":u TO qbf-beg-':u STRING(suffix) 
      ' IN FRAME qbf-ask-':u STRING(suffix) '.':u SKIP(1)
      '  ON ALT-U OF FRAME qbf-ask-':u STRING(suffix) SKIP
      '    APPLY "ENTRY":u TO qbf-end-':u STRING(suffix) 
      ' IN FRAME qbf-ask-':u STRING(suffix) '.':u SKIP(1).

    IF NOT g-mode THEN
    PUT UNFORMATTED 
      '  ON GO OF FRAME qbf-ask-':u STRING(suffix) ' DO:':u SKIP
      '    IF INPUT FRAME qbf-ask-':u STRING(suffix) ' qbf-beg-':u STRING(suffix) 
      ' BEGINS "*" THEN DO:':u SKIP
      '      MESSAGE':u SKIP
      '        "':u 
        'Contains string cannot begin with an asterisk,' '" SKIP':u SKIP
      '        "':u 
        'but may be used as a trailing wildcard, for' '" SKIP':u SKIP
      '        "':u 'example ""sales*"".' '"':u SKIP
      '        VIEW-AS ALERT-BOX ERROR.':u SKIP
      '      RETURN NO-APPLY.':u SKIP
      '    END.':u SKIP
      '  END.':u SKIP(1)
      '  ON ENDKEY OF FRAME qbf-ask-':u STRING(suffix) SKIP
      '    qbf-c = TRUE.':u SKIP(1)
      '  ON WINDOW-CLOSE OF FRAME qbf-ask-':u STRING(suffix) ' DO:':u SKIP
      '    qbf-c = TRUE.':u SKIP
      '    APPLY "END-ERROR" TO SELF.':u SKIP
      '  END.':u SKIP(1).

    IF qbf-p = "list":u THEN
      PUT UNFORMATTED 
      '  qbf-beg-':u STRING(suffix) ':RETURN-INSERTED = TRUE.':u SKIP(1).

    IF qbf-p = "range":u THEN
      PUT UNFORMATTED 
        '  UPDATE qbf-beg-':u STRING(suffix) ' qbf-end-':u STRING(suffix) 
        ' qbf-inc-':u STRING(suffix) ' qbf-ok qbf-ee':u SKIP
        '    WITH FRAME qbf-ask-':u STRING(suffix) '.':u SKIP.
    ELSE IF qbf-p = "list":u THEN
      PUT UNFORMATTED 
        '  UPDATE qbf-beg-':u STRING(suffix) ' qbf-inc-':u STRING(suffix) 
        ' qbf-ok qbf-ee':u SKIP
        '    WITH FRAME qbf-ask-':u STRING(suffix) '.':u SKIP.
    ELSE
      PUT UNFORMATTED 
        '  UPDATE qbf-beg-':u STRING(suffix) ' qbf-ok qbf-ee':u SKIP
        '    WITH FRAME qbf-ask-':u STRING(suffix) '.':u SKIP.

    PUT UNFORMATTED 
      'END.':u SKIP(1).

    IF NOT g-mode AND qbf-d <> "date":u THEN
      PUT UNFORMATTED 
        'ASSIGN':u SKIP
        '  qbf-bscr = STRING(qbf-beg-':u STRING(suffix) ')':u SKIP
        '  qbf-escr = STRING(qbf-end-':u STRING(suffix) ').':u SKIP(1).

    IF NOT g-mode AND qbf-d = "decimal":u 
      AND SESSION:NUMERIC-FORMAT = "EUROPEAN":u THEN 
      PUT UNFORMATTED 
        'ASSIGN':u SKIP
        '  qbf-bscr = REPLACE(qbf-bscr,",",".")':u SKIP
        '  qbf-escr = REPLACE(qbf-escr,",",".").':u SKIP(1).

    IF NOT g-mode AND qbf-d = "date":u THEN 
      PUT UNFORMATTED
        'ASSIGN':u SKIP
        '  qbf-bscr = STRING(MONTH(qbf-beg-':u STRING(suffix) ')) + "/"':u SKIP
        '           + STRING(DAY(qbf-beg-':u STRING(suffix) ')) + "/"':u SKIP
        '           + STRING(YEAR(qbf-beg-':u STRING(suffix) '))':u SKIP
        '  qbf-escr = STRING(MONTH(qbf-end-':u STRING(suffix) ')) + "/"':u SKIP
        '           + STRING(DAY(qbf-end-':u STRING(suffix) ')) + "/"':u SKIP
        '           + STRING(YEAR(qbf-end-':u STRING(suffix) ')).':u SKIP(1).

    IF NOT g-mode THEN
    PUT UNFORMATTED 
      'qbf-v = ':u (IF qbf-p = "range":u THEN 
                      'STRING(qbf-inc-':u + STRING(suffix) + ',"#inc#/#exc#")':u
                    ELSE IF qbf-p = "list":u THEN '"#lst#"':u
                    ELSE '"#nor#"':u) ' + CHR(10) + qbf-bscr.':u SKIP(1).
  
    IF NOT g-mode AND qbf-p = "range":u THEN
      PUT UNFORMATTED 
        'qbf-v = qbf-v + CHR(10) + qbf-escr.':u SKIP(1).
     
    IF g-mode AND qbf-p = "list":u THEN
    PUT UNFORMATTED
      'qbf-beg-':u STRING(suffix) ' = REPLACE(qbf-beg-':u STRING(suffix)
      ',CHR(10),",":u).':u SKIP.
 
    PUT UNFORMATTED
      'HIDE FRAME qbf-ask-':u STRING(suffix) ' NO-PAUSE.':u SKIP(1).

    IF NOT g-mode THEN
    PUT UNFORMATTED
      'RETURN.':u SKIP(1).

    OUTPUT CLOSE.
   
    IF g-mode THEN 
      qbf-v = (IF qbf-p = "list":u THEN "#lst#":u ELSE "#nor#":u) + CHR(10)
            + "qbf-beg-":u + STRING(suffix) 
            + (IF qbf-p <> "range":u THEN ""
               ELSE CHR(10) + "qbf-end-":u + STRING(suffix)). 
    ELSE DO: 
      ASSIGN
        qbf-c      = qbf-module
        qbf-module = "ask,":u + qbf-rel-buf.tname + ".":u + qbf-n
        qbf-v      = "".
  
      /* run the dialog-box to prompt the user for value(s) */ 
      RUN VALUE(cFile) (OUTPUT qbf-v, OUTPUT qbf-a).

      STATUS INPUT.
     
      qbf-module = qbf-c.

      IF qbf-a THEN 
        qbf-v = "#can#":u + CHR(10) + "cancel":u.
      ELSE DO:
        /* add quotes/stars, etc. on the value */
        IF qbf-d = "character":u AND qbf-v MATCHES '"*"':u THEN
          qbf-v = SUBSTRING(qbf-v,2,LENGTH(qbf-v,"CHARACTER":u) - 2,
                            "CHARACTER":u).

        /* stern - Added check for CONTAINS case so we don't end up with "*"
           as the query since this causes an error. */
        IF qbf-p = "contains":u THEN 
          qbf-v = IF NUM-ENTRIES(qbf-v, CHR(10)) > 1 AND NOT qbf-a THEN
                    qbf-v + "*":u ELSE "TRUE":u.
      END.
    END.

    SUBSTRING(qbf-where.qbf-wask,qbf-l,qbf-r - qbf-l + 2,
              "CHARACTER":u) = qbf-v.

    IF qbf-v > "" THEN
      qbf-w = qbf-w + qbf-v + CHR(10).

    ASSIGN
      qbf-l  = INDEX(qbf-where.qbf-wask, "/*":u)
      qbf-r  = INDEX(qbf-where.qbf-wask, "*/":u)
      suffix = (IF g-mode THEN suffix + 1 ELSE suffix)
      .
      
    IF NOT g-mode THEN
      OS-DELETE VALUE(cFile).
  END. /* loop through ask-at-runtime phrases */

  /* stuff the user's values into qbf-wask or in the case of dynamic
     ask-at-runtime, the variable names that match -dma */
  IF qbf-w > "" THEN
    qbf-where.qbf-wask = qbf-w.
END. /* qbf-outer */

/* stern: This used to return false only if user hit cancel from the last ask  
   at run time dialog.  If there were 4 ask clauses and user canceled 3 of them
   but not the 4th, it would return true.  That's WEIRD.  If we did return
   false, The calling code (s-write) would not generate any code but return ""
   which is equivilent to OK so that was screwed up.  Then y-run proceeded to 
   ignore the return code anyway(!) and tried to compile a blank file which
   kind of worked - ending up with no records processed.  However for Form 
   and Browse s-write is called from y-menu.  It would try to compile this 
   empty file and then run it which would do nothing and then continue on to 
   repeat the main wait-for loop and do the whole thing all over again!
   So I've changed this to always return true.  If the user cancels out of
   all ask boxes, the query should produce a bunch of clauses that won't
   match anything and they'll just get no records.  The other alternative
   is to return false if the user hits cancel from ANY of the ask boxes.
   This would work fine for report but Form and Browse cannot run without
   a query so I don't know what we'd do for that case.  
*/
qbf-a = TRUE.
RETURN.

/* s-ask.p - end of file */


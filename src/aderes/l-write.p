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
 * l-write.p - generate labels program
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/l-define.i }
{ aderes/j-define.i }
{ aderes/r-define.i }

DEFINE INPUT PARAMETER usage  AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf-a  AS LOGICAL      NO-UNDO.
DEFINE VARIABLE qbf-c  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE qbf-g  LIKE qbf-l-text NO-UNDO.
DEFINE VARIABLE qbf-h  AS INTEGER      NO-UNDO.
DEFINE VARIABLE qbf-i  AS INTEGER      NO-UNDO.
DEFINE VARIABLE qbf-j  AS INTEGER      NO-UNDO.
DEFINE VARIABLE qbf-k  AS INTEGER      NO-UNDO.
DEFINE VARIABLE qbf-l  AS INTEGER      NO-UNDO. /* left-curly brace */
DEFINE VARIABLE qbf-m  AS LOGICAL      NO-UNDO. /* is mandatory */
DEFINE VARIABLE qbf-n  AS INTEGER      NO-UNDO.
DEFINE VARIABLE qbf-p  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE qbf-r  AS INTEGER      NO-UNDO. /* right-curly brace */
DEFINE VARIABLE qbf-s  AS CHARACTER    NO-UNDO.
DEFINE VARIABLE tbnam  AS CHARACTER    NO-UNDO. /* real db.tbl value */

/*--------------------------------------------------------------------------*/

FIND FIRST qbf-lsys.

qbf-n = 1.

DO qbf-i = 1 TO EXTENT(qbf-l-text):
  qbf-g[qbf-i] = qbf-l-text[qbf-i].
END.

/* misc. cleanup */
DO qbf-i = 1 TO EXTENT(qbf-l-text):
  IF qbf-i > qbf-lsys.qbf-label-ht THEN /* zap lines beyond label height */ 
    qbf-g[qbf-i] = "".
  ELSE IF qbf-g[qbf-i] = "" THEN        /* replace null with space */
    qbf-g[qbf-i] = " ":u.
END.
qbf-n = 0.

/* find last usable line, use to set loop limit */
DO qbf-i = qbf-lsys.qbf-label-ht TO 1 BY -1 WHILE qbf-n = 0:
  IF qbf-g[qbf-i] <> " ":u THEN qbf-n = qbf-i.
  IF qbf-g[qbf-i] =  " ":u THEN qbf-g[qbf-i] = "".
END.

DO qbf-h = 1 TO qbf-n:
  IF LENGTH(qbf-g[qbf-h],"CHARACTER":u) = 0 THEN NEXT.
  /*---
  IF INDEX(qbf-g[qbf-h],'"':u) > 0 THEN
    DO qbf-l = LENGTH(qbf-g[qbf-h],"CHARACTER":u) TO 1 BY -1:
      IF SUBSTRING(qbf-g[qbf-h],qbf-l,1,"CHARACTER":u) = '"':u
	THEN SUBSTRING(qbf-g[qbf-h],qbf-l,1,"CHARACTER":u) = '""':u.
    END.
  ---*/
  ASSIGN
    qbf-g[qbf-h] = '"':u + REPLACE(qbf-g[qbf-h], '~"':u, '~~"':u) + '"':u
    qbf-l        = INDEX(qbf-g[qbf-h],qbf-left)
    qbf-r        = INDEX(qbf-g[qbf-h],qbf-right).

  DO WHILE qbf-l > 0 AND qbf-r > qbf-l:
    qbf-c = SUBSTRING(qbf-g[qbf-h],qbf-l + 1,qbf-r - qbf-l - 1,"CHARACTER":u).

    RUN alias_to_tbname (qbf-c, TRUE, OUTPUT tbnam).

    IF qbf-c = "TODAY":u THEN 
      qbf-c = 'STRING(TODAY,"99/99/99")':u.
    ELSE DO:
      ASSIGN
	qbf-i = INDEX(qbf-c,".":u)
	qbf-j = R-INDEX(qbf-c,".":u)
	qbf-k = 0.

      /* no file or db qualifier - could be a calculated field */
      IF qbf-i = 0 THEN DO:
      
	/* is this a calculated field? */
	DO qbf-k = 1 TO qbf-rc#:
	  IF qbf-c = ENTRY(1,qbf-rcn[qbf-k]) AND qbf-rcc[qbf-k] > "" THEN DO:
	    qbf-s = STRING(qbf-rct[qbf-k])   /* datatype */
		  + ",,,,n," + CHR(10)       /* not mandatory */
		  + qbf-rcf[qbf-k] + CHR(10) /* format */
		  + qbf-rcl[qbf-k].          /* label */
	    LEAVE.
	  END.
	END.

	/* field not part of field list or non-calculated field */
	IF qbf-k > qbf-rc# /* field not part of query field list */
	  OR (qbf-k <= qbf-rc# AND qbf-rcc[qbf-k] = "") THEN      
	  DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):
	    {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-i, qbf-tables)).
	    RUN alias_to_tbname (qbf-rel-buf.tname, FALSE, OUTPUT tbnam).
	    RUN adecomm/_y-schem.p (tbnam, "", qbf-c, OUTPUT qbf-s).
	    IF qbf-s = ? THEN NEXT.
	    qbf-c = tbnam + ".":u + qbf-c. /* tbnam is db.tbl */
	    LEAVE.
	  END.
      END.
      
      /* no db qualifier */
      ELSE IF qbf-i = qbf-j THEN 
	DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):
	  {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-i,qbf-tables)).
	  IF ENTRY(2,qbf-rel-buf.tname,".":u)
	    <> SUBSTRING(qbf-c,1,qbf-j - 1,"CHARACTER":u) THEN NEXT.
	  qbf-c = ENTRY(1,qbf-rel-buf.tname,".":u) + ".":u + qbf-c.
	  RUN alias_to_tbname (qbf-c, FALSE, OUTPUT tbnam).
	END.

      /* non-calculated field */
      IF qbf-k = 0 OR 
	(qbf-k > 0 AND qbf-k <= qbf-rc# AND qbf-rcc[qbf-k] = "") THEN      
	RUN adecomm/_y-schem.p (tbnam, "", "", OUTPUT qbf-s).

      ASSIGN
	qbf-a = INTEGER(ENTRY(1,qbf-s)) <> 1 /* = true when _not_ character */
	qbf-m = ENTRY(5,qbf-s) BEGINS "y":u
	qbf-s = ENTRY(2,qbf-s,CHR(10)). /* extract format */
	
      IF NOT qbf-a THEN DO: /* character */
	ASSIGN
	  qbf-j = LENGTH(STRING("",qbf-s),"CHARACTER":u)
	  qbf-a = TRUE.
	IF qbf-s = FILL(SUBSTRING(qbf-s,1,1,"CHARACTER":u),
			  LENGTH(qbf-s,"CHARACTER":u)) THEN 
	  qbf-a = FALSE.
	IF INDEX("XNA!9":u,SUBSTRING(qbf-s,1,1,"CHARACTER":u)) > 0
	  AND (SUBSTRING(qbf-s,2,-1,"CHARACTER":u) = 
	      "(":u + STRING(qbf-j) + ")":u
	    OR SUBSTRING(qbf-s,2,-1,"CHARACTER":u) = 
	      "(0":u  + STRING(qbf-j) + ")":u
	    OR SUBSTRING(qbf-s,2,-1,"CHARACTER":u) = 
	      "(00":u + STRING(qbf-j) + ")":u)
	  THEN qbf-a = FALSE.
      END.
      /* At this point, qbf-a = TRUE when formatting needs to be applied. */

      /* double-up embedded escape characters */
      qbf-s = REPLACE(qbf-s, "~~":u, "~~~~":u).

      /* change unknown value into "" */
      IF qbf-a THEN
	IF qbf-m THEN
	  qbf-c = 'TRIM(STRING(':u + qbf-c
		+ ',"':u 
		+ qbf-s + '"))':u.
	ELSE
	  qbf-c = 'TRIM(IF ':u + qbf-c + ' = ? THEN "" ELSE STRING(':u + qbf-c
		+ ',"':u 
		+ qbf-s + '"))':u.

      ELSE
      IF NOT qbf-m THEN DO:
	qbf-c = '(IF ':u + qbf-c + ' = ? THEN "" ELSE ':u + qbf-c + ')':u.
      END.
    END.
  
    ASSIGN
      SUBSTRING(qbf-g[qbf-h],qbf-l,qbf-r - qbf-l + 1,"CHARACTER":u) = 
	'" + ':u + qbf-c + ' + "':u
      qbf-l = INDEX(qbf-g[qbf-h],qbf-left)
      qbf-r = INDEX(qbf-g[qbf-h],qbf-right).
  END. /* do while ... */

  IF qbf-g[qbf-h] BEGINS '"" + ':u THEN 
    qbf-g[qbf-h] = SUBSTRING(qbf-g[qbf-h],6,-1,"CHARACTER":u).
  IF qbf-g[qbf-h] MATCHES '* + ""':u THEN
    qbf-g[qbf-h] = SUBSTRING(qbf-g[qbf-h],1,
		     LENGTH(qbf-g[qbf-h],"CHARACTER":u) - 5,"CHARACTER":u).
END.

/*-------------------------- GENERATE CODE ---------------------------------*/

DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO. /* for defbufs loop */
{ aderes/defbufs.i &mode = "NEW SHARED " }  

PUT UNFORMATTED
  SKIP(1)
  'DEFINE VARIABLE qbf-b AS CHARACTER NO-UNDO EXTENT ':u 
    STRING(qbf-n,"Z9":u) '.':u SKIP
  'DEFINE VARIABLE qbf-c AS INTEGER   NO-UNDO.':u SKIP
  'DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO.':u SKIP
  'DEFINE VARIABLE qbf-l AS CHARACTER NO-UNDO.':u SKIP
  'DEFINE VARIABLE qbf-n AS INTEGER   NO-UNDO.':u SKIP
  'DEFINE VARIABLE qbf-t AS INTEGER   NO-UNDO.':u SKIP(1).

/* write out initialization stuff for calc fields */
{ aderes/c-gen1.i &genUsage = usage }

IF usage <> "g":u OR (usage = "g":u AND qbf-govergen) THEN 
  PUT UNFORMATTED
    'qbf-governor = ' STRING(qbf-governor) ".":u SKIP.

PUT UNFORMATTED 'qbf-count    = 0.':u SKIP(1).

IF usage = "g":u THEN DO:
  FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

  PUT UNFORMATTED 'OUTPUT TO label.dat PAGE-SIZE ':u 
    qbf-rsys.qbf-page-size '.':u SKIP(1).
END.

{ aderes/x-gen2.i 
  &by=TRUE 
  &on="'ON ERROR UNDO,RETURN ON ENDKEY UNDO,RETURN'" }

qbf-p = (IF qbf-lsys.qbf-copies = 1 THEN '' ELSE '  ':u).
IF qbf-lsys.qbf-copies > 1 THEN PUT UNFORMATTED
  '  DO qbf-c = 1 TO ':u qbf-lsys.qbf-copies ':':u SKIP.
  
PUT UNFORMATTED SKIP(1)
  qbf-p '  ASSIGN':u SKIP
  qbf-p '    qbf-count = qbf-count - 1':u SKIP
  qbf-p '    qbf-i = 1':u SKIP.

/* assign calculated fields */
DO qbf-i = 1 TO qbf-rc#:
  IF NOT CAN-DO("s,d,n,l":u,SUBSTRING(qbf-rcc[qbf-i],1,1,"CHARACTER":u)) THEN
    NEXT. 
  PUT UNFORMATTED
    qbf-p '    ':u ENTRY(1,qbf-rcn[qbf-i]) ' = ':u 
    SUBSTRING(qbf-rcn[qbf-i],INDEX(qbf-rcn[qbf-i],",":u) + 1,-1,
	      "CHARACTER":u) SKIP.
END.

DO qbf-i = 1 TO qbf-n:
  qbf-c = (IF qbf-lsys.qbf-label-wd = 0 OR qbf-lsys.qbf-across = 1 THEN
	    'qbf-b[qbf-i] = ':u
	   + (IF qbf-lsys.qbf-origin-hz = 0 THEN ''
	      ELSE '"':u + FILL(' ':u,qbf-lsys.qbf-origin-hz) + '" + ':u)
	  ELSE
	    'OVERLAY(qbf-b[qbf-i],':u
	    + STRING(qbf-lsys.qbf-origin-hz + 1)
	    + ' + qbf-n * ':u
	    + STRING(qbf-lsys.qbf-label-wd)
	    + (IF qbf-lsys.qbf-space-hz > 0 
	       THEN ' + (qbf-n * ':u + STRING(qbf-lsys.qbf-space-hz) + ')':u
	       ELSE '')
	    + ','
	    + STRING(qbf-lsys.qbf-label-wd)
	    + ',"RAW") = ':u
	  ).

  PUT UNFORMATTED
    qbf-p '    qbf-l = ':u qbf-g[qbf-i] SKIP
    qbf-p '    qbf-l = (IF qbf-l = ? THEN "" ELSE qbf-l)':u SKIP
    qbf-p '    ':u qbf-c 'qbf-l':u SKIP.

   IF qbf-i < qbf-n THEN 
    PUT UNFORMATTED
      qbf-p '    qbf-i = ':u
      (IF qbf-lsys.qbf-omit THEN
	'(IF LENGTH(qbf-l,"CHARACTER":u) > 0 THEN qbf-i + 1 ELSE qbf-i)':u
      ELSE
	'qbf-i + 1':u
      ) SKIP.
    
  IF (qbf-i MOD 10) = 0 THEN
    PUT UNFORMATTED 
      qbf-p '    .':u SKIP 
      qbf-p '  ASSIGN':u SKIP.
END.

PUT UNFORMATTED
  qbf-p '    qbf-n = qbf-n + 1.':u SKIP(1)
  qbf-p '  IF qbf-n = ':u qbf-lsys.qbf-across ' OR':u SKIP
  qbf-p '    ((qbf-count * -1) = qbf-governor AND qbf-governor > 0) THEN DO:':u SKIP
  qbf-p '    PUT UNFORMATTED SKIP(':u qbf-lsys.qbf-space-vt ')':u.

DO qbf-i = 1 TO qbf-n:
  PUT UNFORMATTED SKIP qbf-p '      qbf-b[':u qbf-i '] " " SKIP':u.
END.

PUT UNFORMATTED
  '(':u qbf-lsys.qbf-label-ht - qbf-n ').':u SKIP
  qbf-p '    ASSIGN':u SKIP
  qbf-p '      qbf-b = ""':u SKIP
  qbf-p '      qbf-n = 0.':u SKIP(1)
  qbf-p '    IF ((qbf-count * -1) = qbf-governor AND qbf-governor > 0) THEN LEAVE.':u SKIP
  qbf-p '  END.':u SKIP(1).

IF qbf-lsys.qbf-copies > 1 THEN 
  PUT UNFORMATTED '  END.':u SKIP.

PUT UNFORMATTED
  'END.':u SKIP(1)
  'IF qbf-n > 0 THEN':u SKIP
  '  PUT UNFORMATTED SKIP(':u qbf-lsys.qbf-space-vt ')':u.

DO qbf-i = 1 TO qbf-n:
  PUT UNFORMATTED SKIP '    qbf-b[':u qbf-i '] " " SKIP':u.
END.

PUT UNFORMATTED
  '(':u qbf-lsys.qbf-label-ht - qbf-lsys.qbf-space-vt - qbf-n ').':u SKIP
  'qbf-count = - qbf-count.':u SKIP
  'RETURN.':u SKIP.

RETURN.

/*--------------------------------------------------------------------------*/

/* alias_to_tbname */
{ aderes/s-alias.i }

/* l-write.p - end of file */
 

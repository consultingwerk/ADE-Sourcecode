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
 * l-verify.p - look over current label fields for problems
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/s-alias.i }

DEFINE INPUT  PARAMETER qbf-m AS LOGICAL   NO-UNDO. /* report errors */
DEFINE OUTPUT PARAMETER qbf-b AS INTEGER   NO-UNDO. /* error line */
DEFINE OUTPUT PARAMETER qbf-o AS CHARACTER NO-UNDO. /* label text */

DEFINE VARIABLE qbf-c   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-e   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-h   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-i   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-j   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-k   AS INTEGER   NO-UNDO.
DEFINE VARIABLE qbf-l   AS INTEGER   NO-UNDO. /* left curly-brace */
DEFINE VARIABLE qbf-r   AS INTEGER   NO-UNDO. /* right curly-brace */
DEFINE VARIABLE qbf-s   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-t   AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-a   AS LOGICAL   NO-UNDO.
DEFINE VARIABLE refName AS CHARACTER NO-UNDO.
DEFINE VARIABLE dtName  AS CHARACTER NO-UNDO.

/* IF qbf-m is TRUE, then qbf-o returns the invalid field, if any.  If
   qbf-m is FALSE, then qbf-o returns label text with CHR(10) newline  
   characters. */

/* check for balanced brackets and available fields */
DO qbf-h = 1 TO EXTENT(qbf-l-text):
  ASSIGN
    qbf-t  = qbf-l-text[qbf-h]
    qbf-l  = INDEX(qbf-t, qbf-left)
    qbf-r  = INDEX(qbf-t, qbf-right).
  IF qbf-t = "" THEN NEXT.

  DO WHILE qbf-l > 0 OR qbf-r > 0:
    /* unbalanced or missing brace */
    IF qbf-l = 0 OR qbf-r = 0 OR qbf-l > qbf-r THEN DO:
      ASSIGN
        qbf-c = (IF qbf-l = 0 OR (qbf-l > qbf-r AND qbf-r <> 0) THEN 
                   SUBSTRING(qbf-t, 1, qbf-r,"CHARACTER":u)
                 ELSE SUBSTRING(qbf-t, qbf-l,-1,"CHARACTER":u))
        qbf-b = qbf-h
        qbf-o = qbf-c.

      RETURN.
    END.

    ASSIGN
      qbf-c = SUBSTRING(qbf-t, qbf-l + 1, qbf-r - qbf-l - 1,"CHARACTER":u)
      qbf-e = 0
      qbf-t = SUBSTRING(qbf-t, qbf-r + 1,-1,"CHARACTER":u)
      qbf-l = INDEX(qbf-t, qbf-left)
      qbf-r = INDEX(qbf-t, qbf-right).

    IF qbf-c = "TODAY":u THEN NEXT.

    /* array field */
    IF qbf-c MATCHES "*[*]":u THEN DO:
      DO qbf-i = INDEX(qbf-c, "[":u) + 1 TO LENGTH(qbf-c,"CHARACTER":u) - 1:
        qbf-s = SUBSTRING(qbf-s, qbf-i, 1,"CHARACTER":u).
        IF INDEX("0123456789":u, qbf-s) > 0 THEN
          qbf-e = (qbf-e * 10) + INTEGER(qbf-s).
      END.
      qbf-c = SUBSTRING(qbf-c, 1, INDEX(qbf-c, "[":u) - 1,"CHARACTER":u).
    END.

    ASSIGN
      qbf-i = INDEX(qbf-c, ".":u)
      qbf-j = R-INDEX(qbf-c, ".":u)
      qbf-k = 0.
      
    /* no file or db qualifier - could be a calculated field */
    IF qbf-i = 0 THEN DO:
    
      /* is this a calculated field? */
      DO qbf-k = 1 TO qbf-rc#:
        IF qbf-c = ENTRY(1,qbf-rcn[qbf-k]) THEN LEAVE.
      END.
      IF qbf-k > qbf-rc# /* field not part of query field list */
        OR (qbf-k <= qbf-rc# AND qbf-rcc[qbf-k] = "") THEN
        DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):
      	  {&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-i,qbf-tables)).
          RUN alias_to_tbname (qbf-rel-buf.tname,FALSE,OUTPUT refName).
          RUN adecomm/_y-schem.p (refName,"",qbf-c,OUTPUT qbf-s).
          IF qbf-s = ? THEN NEXT.
          qbf-c = qbf-rel-buf.tname + ".":u + qbf-c.
          LEAVE.
        END.
    END.
      
    /* no db qualifier */
    ELSE
    IF qbf-i = qbf-j THEN
      DO qbf-i = 1 TO NUM-ENTRIES(qbf-tables):
      	{&FIND_TABLE_BY_ID} INTEGER(ENTRY(qbf-i, qbf-tables)).
        IF ENTRY(2, qbf-rel-buf.tname, ".":u)
          <> SUBSTRING(qbf-c, 1, qbf-j - 1,"CHARACTER":u) THEN NEXT.
        qbf-c = ENTRY(1,qbf-rel-buf.tname, ".":u) + ".":u + qbf-c.
      END.

    IF qbf-k = 0 OR qbf-k > qbf-rc# OR
      (qbf-k > 1 AND qbf-k <= qbf-rc# AND qbf-rcc[qbf-k] = "") THEN DO:
      qbf-s = SUBSTRING(qbf-c, 1, R-INDEX(qbf-c, ".":u) - 1,"CHARACTER":u).

      RUN lookup_table (qbf-s, OUTPUT qbf-i).

      /* unselected table */
      IF qbf-i <= 0 OR NOT CAN-DO(qbf-tables, STRING(qbf-i)) THEN DO:
        RUN bad_field.
        RETURN.
      END.
      ELSE DO:
        RUN alias_to_tbname (qbf-c, TRUE, OUTPUT refName).
        RUN adecomm/_y-schem.p (refName, "", "", OUTPUT qbf-s).
      END.
 
      /* missing field */
      IF qbf-s = ? THEN DO:
        RUN bad_field.
        RETURN.
      END.

      /* Field Security */
      IF _fieldCheck <> ? THEN DO:
        hook:
        DO ON STOP UNDO hook, RETRY hook:
          IF RETRY THEN DO:
            RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-a,"error":u,"ok":u,
              SUBSTITUTE("There is a problem with &1.  &2 will use default field security.",_fieldCheck,qbf-product)).
	    
            _fieldCheck = ?.
            LEAVE hook.
          END.

          dtName = ENTRY(1, refName, ".":u) + ".":u + ENTRY(2, refName, ".":u).
     
          RUN VALUE(_fieldCheck) (dtName,
                                  ENTRY(3, refName, ".":u), 
                                  USERID(ENTRY(1, refName, ".":u)),
                                  OUTPUT qbf-a).

          IF NOT qbf-a THEN DO:
            RUN bad_field.
            RETURN.
          END.
        END.
      END.

      qbf-s = "0":u.
    
      /* array field */
      IF qbf-e > 0 THEN DO:
        RUN alias_to_tbname (qbf-c, TRUE, OUTPUT refName).
        RUN adecomm/_y-schem.p (refName, "", "", OUTPUT qbf-s).
      
        qbf-s = ENTRY(2, qbf-s).
      END.
    
      /* array field problems */
      IF INTEGER(qbf-s) < qbf-e THEN DO:
        RUN bad_field.
        RETURN.
      END.
    END. /* non-calculated field */
    
    qbf-o = qbf-o + CHR(10) + "  ":u + qbf-c.
  END. /* for each part of line */
END. /* for each line */

IF qbf-o > "" THEN
  qbf-o = "Label Field:" + qbf-o.

RETURN.

/* sub-proc to lookup table reference in relationship table */
{ aderes/p-lookup.i }

/* ----------------------------------------------------------------------- */

PROCEDURE bad_field:
  ASSIGN
    qbf-b = qbf-h
    qbf-o = qbf-left + qbf-c + qbf-right
    .
END PROCEDURE.

/* l-verify.p - end of file */


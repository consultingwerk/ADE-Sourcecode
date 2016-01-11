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
/* f-qbe.p - Store a new where clause based on the input to
query by example via forms.

Input Parameters:
p_hframe - handle of the qbe dialog frame.

Returns:
"error" or "" (OK).  Any error message is displayed here.
*/

{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/fbdefine.i }
{ aderes/s-menu.i }

DEFINE INPUT PARAMETER p_hframe AS HANDLE NO-UNDO.

DEFINE VARIABLE qbehdl  AS HANDLE   NO-UNDO. /* qbe dialog handle */
DEFINE VARIABLE mainhdl AS HANDLE   NO-UNDO. /* main frame handle */
DEFINE VARIABLE qbf-i   AS INTEGER  NO-UNDO.
DEFINE VARIABLE qbf-l   AS LOGICAL  NO-UNDO.

/*==========================Internal Procedures==========================*/

{aderes/p-lookup.i}  /* PROCEDURE lookup_table */

/*----------------------------------------------------------------------
Do some validation on this piece of the where clause. It should be of
the form: <operator><space>["]<value>["] where the quotes are only
valid for character fields. The space may be omitted around
the symbolic operators =,<, etc.

Input Parameters:
p_ix    - index into the qbf-rcx arrays for the field that this
where clause pertains to.
p_hdl   - widget handle of fill-in holding where criterion.
----------------------------------------------------------------------*/

PROCEDURE Check_Where_Clause:
  DEFINE INPUT PARAMETER p_ix  AS INTEGER  NO-UNDO.
  DEFINE INPUT PARAMETER p_hdl AS HANDLE   NO-UNDO.

  DEFINE VARIABLE whcls AS CHARACTER NO-UNDO.
  DEFINE VARIABLE db    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE tbl   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE fld   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE sinfo AS CHARACTER NO-UNDO. /* schema info */
  DEFINE VARIABLE c1    AS CHARACTER NO-UNDO.
  DEFINE VARIABLE ix    AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ix2   AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ixdot AS INTEGER   NO-UNDO.
  DEFINE VARIABLE ijunk AS INTEGER   NO-UNDO.
  DEFINE VARIABLE djunk AS DATE      NO-UNDO.
  DEFINE VARIABLE word  AS LOGICAL   NO-UNDO INITIAL NO.
  DEFINE VARIABLE oper  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE val   AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cval  AS CHARACTER NO-UNDO. /* converted value */
  DEFINE VARIABLE ops   AS CHARACTER NO-UNDO INITIAL
    "=,EQ,<>,NE,>,GT,>=,GE,<,LT,<=,LE,BEGINS,MATCHES,CONTAINS":u.
  DEFINE VARIABLE specl AS CHARACTER NO-UNDO INITIAL "~",~',~~,~\,~{":u.

  whcls = TRIM(p_hdl:SCREEN-VALUE).

  /* Extract a valid operator if we can. **Order of checking is important */
  IF whcls BEGINS "=":u         THEN oper = "=":u.
  ELSE IF whcls BEGINS "<>":u THEN oper = "<>":u.
  ELSE IF whcls BEGINS "<=":u THEN oper = "<=":u.
  ELSE IF whcls BEGINS "<":u  THEN oper = "<":u.
  ELSE IF whcls BEGINS ">=":u THEN oper = ">=":u.
  ELSE IF whcls BEGINS ">":u  THEN oper = ">":u.

  IF oper <> "" THEN
    ix = LENGTH(oper,"CHARACTER":u) + 1. /* index of char following operator */
  ELSE DO:
    /* assume operator is before the first space for now */
    ix = INDEX(whcls, " ":u).
    IF ix > 0 THEN
      oper = SUBSTRING(whcls, 1, ix - 1,"CHARACTER":u).
  END.

  /* If no valid operator, default to "=". */
  IF NOT CAN-DO(ops, oper) THEN
    ASSIGN
      oper = "=":u
      ix = 1.

  IF (oper = "MATCHES":u OR oper = "BEGINS":u OR oper = "CONTAINS":u) AND
    qbf-rct[p_ix] <> 1 THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      "MATCHES, BEGINS and CONTAINS can only be used with character fields.").

    RETURN "error":u.
  END.

  /* Make sure field is word-indexed if operator is CONTAINS. */
  IF oper = "CONTAINS":u THEN DO:
    ASSIGN
      fld   = qbf-rcn[p_ix]  	       	  /* db.tbl.field */
      ixdot = INDEX(fld, ".":u)
      db    = SUBSTRING(fld, 1, ixdot - 1,"CHARACTER":u)
      tbl   = SUBSTRING(fld, ixdot + 1,-1,"CHARACTER":u)  /* tbl.field */
      ixdot = INDEX(tbl, ".":u)
      fld   = SUBSTRING(tbl, ixdot + 1,-1,"CHARACTER":u)  /* just field */
      tbl   = SUBSTRING(tbl, 1, ixdot - 1,"CHARACTER":u). /* just tbl */

    RUN adecomm/_y-schem.p (db, tbl, fld, OUTPUT sinfo).

    word = (ENTRY(4, sinfo) = "y":u).
    IF NOT word THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
        "CONTAINS can only be used with word-indexed character fields.").

      RETURN "error":u.
    END.
  END.

  oper = oper + " ":u.  /* add or put back one trailing space */

  val = TRIM(SUBSTRING(whcls, ix,-1,"CHARACTER":u)). /* rest of where clause */
  IF qbf-rct[p_ix] = 1 THEN DO:  /* character field */
    /* make sure string is quoted */
    IF SUBSTRING(val, 1, 1,"CHARACTER":u) <> '"':u THEN
      val = '"':u + val.
    IF SUBSTRING(val, LENGTH(val,"CHARACTER":u), 1,"CHARACTER":u) <> '"':u THEN
      val = val + '"':u.

    /* Escape any embedded special chars with a tilde. */
    ix2 = 2. /* start after first quote */
    DO WHILE ix2 < LENGTH(val,"CHARACTER":u):
      c1 = SUBSTRING(val, ix2, 1,"CHARACTER":u).
      IF LOOKUP(c1, specl) > 0 THEN DO:
        SUBSTRING(val, ix2, 1,"CHARACTER":u) = '~~':u + c1.
        ix2 = ix2 + 1.
      END.
      ix2 = ix2 + 1.
    END.
    whcls = oper + val.
  END.
  ELSE IF qbf-rct[p_ix] <> 1 THEN DO: /* integer/decimal/date/logical */
    /* Remove initial quote */
    IF SUBSTRING(val, 1, 1,"CHARACTER":u) = '"':u THEN
      val = SUBSTRING(val, 2,-1,"CHARACTER":u).

    /* Remove ending quote */
    IF SUBSTRING(val, LENGTH(val,"CHARACTER":u), 1,"CHARACTER":u) = '"' THEN
      val = SUBSTRING(val, 1, LENGTH(val,"CHARACTER":u) - 1,"CHARACTER":u).

    IF qbf-rct[p_ix] = 2 THEN DO:  /* date */
      djunk = DATE(val) NO-ERROR.
      IF ERROR-STATUS:ERROR OR djunk = ? THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
          "For this field, the query value must be a valid date string (e.g., 09/10/92).").

        RETURN "error":u.
      END.
      val = "DATE(~"":u + val + "~")":u.
    END.
    ELSE IF qbf-rct[p_ix] = 3 THEN DO: /* logical */
      IF NOT CAN-DO("YES,NO,TRUE,false", val) THEN DO:
        /* if not yes,no,true,false and it's not either the yes or no
           value from the format string then it's an error.
        */  
        ix2 = LOOKUP(val, qbf-rcf[p_ix], "~/":u).
        IF ix2 = 0 THEN DO:
          RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
            "For this field, the query value must be a logical (yes, no, true, false, or one of the values from your format).").
          RETURN "error":u.
        END.
        ELSE DO:
          /* value is one of the strings from the format.  In order to
             have a valid query, we must replace this with a yes or no
             in the where phrase.
          */
          val = (IF ix2 = 1 THEN "yes" ELSE "no").
        END.
      END.
      /* else we had a yes, no true or false so we're OK */
    END.
    ELSE DO: /* integer or decimal */

      /* We require that the WHERE phrase be in American format -
      otherwise it won't compile when we generate code.
      In the Where builder, since we use a test compile, only
      American format will be accepted.  Here, the
      INTEGER function pays attention to the numeric format and only 
      accepts non-American format if numeric-format is not American or 
      American otherwise - just the opposite!  So assume user typed American 
      and change to non-American if necessary so INTEGER check works correctly.
      */
      IF SESSION:NUMERIC-FORMAT <> "AMERICAN":u THEN 
        RUN adecomm/_convert.p ("A-TO-N":u, val, 
                                SESSION:NUMERIC-SEPARATOR,
                                SESSION:NUMERIC-DECIMAL-POINT,
                                OUTPUT cval).
      ELSE cval = val.

      /* Need a real IS-INT function - all characters below do not
      result in an error!
      */
      ijunk = INTEGER(cval) NO-ERROR.
      IF ERROR-STATUS:ERROR OR
        (val = "+":u OR val = "-":u OR val = "*":u OR val = ".":u OR val = ",":u) 
        THEN DO:
          RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
            "For this field, the query value must be a number (in American format).").

        RETURN "error":u.
      END.
      /* Remove any thousand separators - they won't compile either. */
      val = REPLACE(val, ",":u, "").
    END.
    whcls = oper + val.
  END.

  /* Store the where info in the qbf-where table */
  tbl = SUBSTRING(qbf-rcn[p_ix], 1, R-INDEX(qbf-rcn[p_ix], ".":u) - 1,
                  "CHARACTER":u).

  RUN lookup_table (tbl, OUTPUT ix).
  FIND qbf-where WHERE qbf-where.qbf-wtbl = ix NO-ERROR.
  IF NOT AVAILABLE qbf-where THEN DO:
    CREATE qbf-where.
    qbf-where.qbf-wtbl = ix.
  END.

  whcls = qbf-rcn[p_ix] + " ":u + whcls.
  IF qbf-where.qbf-wcls <> "" THEN
  qbf-where.qbf-wcls = qbf-where.qbf-wcls + " AND ":u.
  qbf-where.qbf-wcls = qbf-where.qbf-wcls + whcls.

  qbf-where.qbf-wask = qbf-where.qbf-wcls.
END.

/*=============================Mainline Code=============================*/

/* Find the section(s) corresponding to the frame there querying on.
(What we really want is this:
FIND FIRST qbf-fwid WHERE qbf-fwid.qbf-fwqbe:FRAME = p_hframe.
but it doesn't work!)
*/
FOR EACH qbf-fwid:
  qbehdl = qbf-fwid.qbf-fwqbe:FRAME.
  IF qbehdl = p_hframe THEN
  LEAVE.
END.
IF AVAILABLE qbf-fwid THEN
/* this must be available but it doesn't work w/o this check! */
mainhdl = qbf-fwid.qbf-fwmain:FRAME.

/* Clear the current where clauses for those tables involved in these
sections. If there's an error, this will be undone.
*/
FOR EACH qbf-section WHERE qbf-section.qbf-shdl = mainhdl:
  FOR EACH qbf-where
    WHERE CAN-DO(qbf-section.qbf-stbl, STRING(qbf-where.qbf-wtbl)):
    ASSIGN
    qbf-where.qbf-wcls = ""
    qbf-where.qbf-wask = "".
  END.
END.

FOR EACH qbf-fwid:
  /* The qbf-fwid temp table has handles for fields in all frames
  (i.e., all master-detail levels).  Just check the ones in this
  frame.
  */
  qbehdl = qbf-fwid.qbf-fwqbe:FRAME.
  IF qbehdl <> p_hframe THEN
  NEXT.

  IF qbf-fwid.qbf-fwqbe:SENSITIVE AND
  qbf-fwid.qbf-fwqbe:SCREEN-VALUE <> "" THEN
  DO:
    RUN Check_Where_Clause (qbf-fwid.qbf-fwix, qbf-fwid.qbf-fwqbe).
    IF RETURN-VALUE = "error":u THEN DO:
      APPLY "ENTRY":u TO qbf-fwid.qbf-fwqbe.
      RETURN "error":u.
    END.
  END.
END.

/* update criteria combo-box in frame ftoolbar - dma */
RUN aderes/_updcrit.p.

RETURN "".

/* f-qbfe.p - end of file */


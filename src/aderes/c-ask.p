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
 * c-ask.p - convert Ask-At-Runtime to 4GL code
 */

/* History:
   03/15/93	gjo	Changed y-string.p to string.p
			y-string returns: "string"
			string returns: string
			use wisely.....
*/

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/j-define.i }
{ aderes/s-alias.i }

DEFINE INPUT PARAMETER g-mode AS LOGICAL   NO-UNDO.

DEFINE VARIABLE i_char    AS CHARACTER NO-UNDO. /* user-supplied value? */
DEFINE VARIABLE v_type    AS CHARACTER NO-UNDO. /* inclusive/exclusive flag */ 
DEFINE VARIABLE v_left    AS INTEGER   NO-UNDO. /* left end of ask info */
DEFINE VARIABLE v_list    AS CHARACTER NO-UNDO. /* temp list string */
DEFINE VARIABLE v_loop    AS INTEGER   NO-UNDO. /* scrap */
DEFINE VARIABLE v_right   AS INTEGER   NO-UNDO. /* right end of ask info */
DEFINE VARIABLE v_num     AS INTEGER   NO-UNDO. /* qbf-wask clause counter */
DEFINE VARIABLE v_seq     AS INTEGER   NO-UNDO. /* seq# embedded ask field */
DEFINE VARIABLE v_temp    AS CHARACTER NO-UNDO. /* temp WHERE clause */
DEFINE VARIABLE v_where   AS CHARACTER NO-UNDO. /* WHERE clause */
DEFINE VARIABLE lookAhead AS CHARACTER NO-UNDO.
DEFINE VARIABLE suffix    AS INTEGER   NO-UNDO.

DEFINE TEMP-TABLE t_subs
  FIELD tf_var   AS CHARACTER /* ask-??? */
  FIELD tf_var2  AS CHARACTER /* ask-??? - used for range upper limit */
  FIELD tf_comp  AS CHARACTER /* comparison operator */
  FIELD tf_type  AS CHARACTER /* datatype */
  FIELD tf_field AS CHARACTER /* db.table.field */
  FIELD tf_ques  AS CHARACTER /* question to ask user */
  FIELD tf_fmt   AS CHARACTER /* prompt variable format */
  INDEX ti_subs IS PRIMARY UNIQUE tf_var.
 
/* /*INTEGER,demo.customer.cust-num,>,:run-time prompt*/

   .../*data-type,db.table.field,operator:run-time prompt*/... 
        |.qbf-d.| |...qbf-n....| |.qbf-p..| |....qbf-q....|     
*/

FOR EACH qbf-where:
  ASSIGN
    v_where = qbf-where.qbf-acls
            + (IF qbf-where.qbf-acls > "" AND
                 qbf-where.qbf-wcls > "" THEN " AND ":u ELSE "")
            + qbf-where.qbf-wcls
    v_where = REPLACE(REPLACE(v_where,CHR(10)," "),"*/ TRUE":u,"*/":u)
    v_temp  = v_where
    v_left  = INDEX(v_temp, "/*":u)
    v_right = INDEX(v_temp, "*/":u)
    v_num   = 0
    .

  /* plain text before ask-at-runtime, if any */
  IF v_left > 1 AND v_right > v_left THEN
    ASSIGN
      v_where  = SUBSTRING(v_temp, 1, v_left - 1,"CHARACTER":u)

      /* strip out leading plain text */
      SUBSTRING(v_temp, 1, v_left - 1,"CHARACTER":u) = "" 
      v_left   = INDEX(v_temp, "/*":u)
      v_right  = INDEX(v_temp, "*/":u)
      .
  ELSE IF v_left = 1 THEN
    v_where = "".

  /* parse ask-at-runtime and build converted WHERE phrase */
  DO WHILE v_left > 0 AND v_right > 0 AND v_left < v_right:
    CREATE t_subs.
    ASSIGN
      t_subs.tf_ques  = 
        SUBSTRING(v_temp,v_left + 2,v_right - v_left - 2,"CHARACTER":u)
      t_subs.tf_type  = ENTRY(1, t_subs.tf_ques)
      t_subs.tf_field = ENTRY(2, t_subs.tf_ques)
      t_subs.tf_comp  = ENTRY(3, t_subs.tf_ques)
      t_subs.tf_ques  = REPLACE(
                          SUBSTRING(t_subs.tf_ques,
                            INDEX(t_subs.tf_ques,":":u) + 1,-1,
                                    "CHARACTER":u),
                                '"':u,'""':u)
      v_seq           = v_seq + 1
      t_subs.tf_var   = "ask-":u + STRING(v_seq, "999":u)

      v_num           = v_num + 1
      v_type          = ENTRY(v_num, qbf-where.qbf-wask, CHR(10))
      v_num           = v_num + 1
      i_char          = ENTRY(v_num, qbf-where.qbf-wask, CHR(10))
      lookAhead       = ""
      .

    IF v_type = "#can#":u THEN /* user aborted ask-at-runtime dialog -dma */
      v_where = (IF v_where = "" THEN "" ELSE v_where + " ":u) + "TRUE":u.
    
    ELSE DO:
      IF g-mode THEN
        suffix = INTEGER(SUBSTRING(i_char,LENGTH(i_char,"CHARACTER":u),1,
                         "CHARACTER":u)).
      ELSE IF t_subs.tf_comp <> "list":u 
        AND t_subs.tf_type = "character":u THEN 
        RUN aderes/s-quote.p (i_char,'"':u, OUTPUT i_char).

      IF t_subs.tf_comp = "range":u THEN DO:
        IF g-mode THEN DO:
          v_where = (IF v_where = "" THEN "(":u ELSE v_where + " (":u).

          DO v_loop = 1 TO 2:
            ASSIGN
              v_where = v_where 
                      + (IF v_loop = 1 THEN 
                           "(NOT qbf-inc-":u + STRING(suffix) + " AND ":u 
                         ELSE 
                           " OR (qbf-inc-":u + STRING(suffix) + " AND ":u)
                      + t_subs.tf_field 
                      + (IF v_loop = 1 THEN " > ":u ELSE " >= ":u)
                      + i_char
              v_num   = v_num + 1
              i_char  = ENTRY(v_num, qbf-where.qbf-wask, CHR(10))
              v_where = v_where + " AND ":u + t_subs.tf_field 
                      + (IF v_loop = 1 THEN " < ":u ELSE " <= ":u)
                      + i_char + ")":u
                      + (IF v_loop = 2 THEN ")":u ELSE "")
              v_num   = (IF v_loop = 1 THEN v_num - 1 ELSE v_num)
              i_char  = ENTRY(v_num, qbf-where.qbf-wask, CHR(10))
              .
          END.
        END.
        ELSE DO:
          ASSIGN
            v_where = (IF v_where = "" THEN "(":u ELSE v_where + " (":u) 
                    + t_subs.tf_field 
                    + (IF v_type = "#inc#":u THEN " >= ":u ELSE " > ":u)
                    + i_char
            v_num   = v_num + 1
            i_char  = ENTRY(v_num, qbf-where.qbf-wask, CHR(10))
            .

          IF NOT g-mode AND t_subs.tf_type = "character":u THEN 
            RUN aderes/s-quote.p (i_char,'"':u,OUTPUT i_char).

          v_where   = v_where + " AND ":u + t_subs.tf_field 
                    + (IF v_type = "#inc#":u THEN " <= ":u ELSE " < ":u)
                    + i_char + ")":u.
        END.
      END. /* range */

      ELSE IF t_subs.tf_comp = "list":u THEN DO:
        IF g-mode THEN 
          v_list = "(NOT qbf-inc-":u + STRING(suffix) 
                 + " AND NOT CAN-DO(qbf-beg-":u + STRING(suffix) 
                 + ",STRING(":u + t_subs.tf_field + "))) OR ":u
                 + "(qbf-inc-":u + STRING(suffix) 
                 + " AND CAN-DO(qbf-beg-":u + STRING(suffix) 
                 + ",STRING(":u + t_subs.tf_field + ")))":u.
        ELSE DO:
          v_list = "".

          DO WHILE i_char > "" AND INDEX(i_char,"#":u) = 0:
            IF REPLACE(i_char,'"':u,'') > "" THEN DO:
              IF v_list = "":u THEN
                v_list = 'CAN-DO("':u. 
              v_list = v_list 
                     + (IF v_list > 'CAN-DO("':u THEN ",":u ELSE "")
                     + i_char.
            END.

            v_num = v_num + 1.
            IF v_num > NUM-ENTRIES(qbf-where.qbf-wask, CHR(10)) THEN LEAVE.
            i_char = ENTRY(v_num, qbf-where.qbf-wask, CHR(10)).
 
            /*
             * If we hit the marker then we'll exit out of this loop.
             * Also reduce the count. It gets changed at the start of the
             * outer loop
             */
            IF INDEX(i_char,"#":u) > 0 THEN v_num = v_num - 1.
          END.

          IF v_list = "":u THEN 
            v_list = "TRUE":u.
          ELSE
            v_list = v_list + '",STRING(':u + t_subs.tf_field + "))":u.
        END.

        IF v_list > "":u THEN
          v_where = v_where + v_list.
      END. /* list */

      ELSE
        v_where = (IF v_where = "" THEN "" ELSE v_where + " ":u) 
                + t_subs.tf_field + " ":u
                + t_subs.tf_comp + " ":u
                + i_char.
    END.

    /* now strip out stuff we just converted */
    SUBSTRING(v_temp, v_left, v_right + 1,"CHARACTER":u) = "".

    v_left  = INDEX(v_temp, "/*":u).

    /* append plain text */ 
    IF v_left > 1 AND v_right > v_left THEN
      ASSIGN
        v_where                          = v_where + " ":u
          + SUBSTRING(v_temp, 1, INDEX(v_temp,"/*":u) - 1,"CHARACTER":u)
        SUBSTRING(v_temp, 1, v_left - 1,"CHARACTER":u) = ""
        v_left                           = INDEX(v_temp,"/*":u)
        .
    ELSE IF LENGTH(v_temp,"CHARACTER":u) > 0 THEN DO:
      v_where = v_where + " ":u + v_temp.
      LEAVE.
    END.

    v_right = INDEX(v_temp, "*/":u).
  END. /* DO WHILE loop through ask-at-runtime phrases */
 
  qbf-where.qbf-wask = v_where.
END.

RETURN.

/* c-ask.p - end of file */


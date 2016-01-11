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
/* _fcopy.p - Generate code that will assign all the fields from one
      table buffer (qbf-bufx) into another buffer except the ones 
      showing in the form.  This is to support the Copy function.

   Input Parameter:
      p_db    - Name of this database
      p_tbl   - Name of the real table in the database
      p_buf   - Name of the buffer - will be different if tbl is an alias
      p_sect  - form section 
*/

{ aderes/s-define.i }

DEFINE INPUT PARAMETER p_db   AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_tbl  AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_buf  AS CHAR  NO-UNDO.
DEFINE INPUT PARAMETER p_sect AS CHAR  NO-UNDO.

DEFINE VARIABLE fld    AS CHARACTER NO-UNDO.	    /* db.tbl.fld */
DEFINE VARIABLE aryfld AS CHARACTER NO-UNDO.	    /* db.tbl.fld[n] */
DEFINE VARIABLE ix     AS INTEGER   NO-UNDO.	    /* scrap/index */
DEFINE VARIABLE aryix  AS INTEGER   NO-UNDO.	    /* array index */
DEFINE VARIABLE cnt    AS INTEGER   NO-UNDO INIT 0. /* field count */

&GLOBAL-DEFINE CHECK_LIMIT ~
   IF cnt = 20 THEN DO: ~
     PUT UNFORMATTED ~
       '      .':u SKIP ~
       '    ASSIGN':u SKIP. ~
     cnt = 0. ~
   END. ~
   ELSE ~
     cnt = cnt + 1.

FIND QBF$0._Db WHERE QBF$0._Db._Db-name =
    (IF DBTYPE(p_db) = "PROGRESS" THEN ? ELSE LDBNAME(p_db)) NO-LOCK.

/* add this check to eliminate sql92 tables and views */
IF INTEGER(DBVERSION("QBF$0":U)) > 8 THEN DO:
    FIND FIRST QBF$0._File OF QBF$0._Db WHERE QBF$0._File._File-name = p_tbl
        AND (QBF$0._File._Owner = "PUB":U OR QBF$0._File._Owner = "_FOREIGN":U).
END.
ELSE FIND FIRST QBF$0._File OF QBF$0._Db WHERE QBF$0._File._File-name = p_tbl.

PUT UNFORMATTED
  '    ASSIGN':u SKIP.

fld_loop:
FOR EACH QBF$0._Field OF QBF$0._File WHERE
    CAN-DO(QBF$0._Field._Can-read, USERID(p_db)) AND
    CAN-DO(QBF$0._Field._Can-write, USERID(p_db)):
  fld = p_buf + "." + QBF$0._Field._Field-name.
  IF QBF$0._Field._Extent > 0 THEN
    extent_loop:
    DO aryix = 1 TO QBF$0._Field._Extent:
      aryfld = fld + "[" + STRING(aryix) + "]".
      /* if the field was in this form, skip it. */
      DO ix = 1 TO qbf-rc#:
        IF aryfld = ENTRY(1,qbf-rcn[ix]) AND
      	      qbf-rcs[ix] = p_sect THEN NEXT extent_loop.
      END.
      {&CHECK_LIMIT}
      PUT UNFORMATTED
        '      ':u aryfld ' = qbf-bufx.':u QBF$0._Field._Field-name 
      	 '[':u aryix ']':u SKIP.
    END.
  ELSE DO:
    /* if the field was in this form, skip it. */
    DO ix = 1 TO qbf-rc#:
      IF fld = ENTRY(1,qbf-rcn[ix]) AND
      	 qbf-rcs[ix] = p_sect THEN NEXT fld_loop.
    END.
    {&CHECK_LIMIT}
    PUT UNFORMATTED
      '      ':u fld ' = qbf-bufx.':u _Field._Field-name SKIP.
  END.
END.
PUT UNFORMATTED
  '      .':u SKIP.

/* _fcopy.p - end of file */


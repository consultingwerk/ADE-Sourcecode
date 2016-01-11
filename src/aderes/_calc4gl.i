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
 * _calc4gl.i - convert calc field in WHERE clause to 4GL
 *
 *    Input Parameter(s):
 *       p_where - The WHERE clause to convert to 4GL.
 *
 *    Output Parameter(s):
 *       p_where - The converted WHERE clause.
 *
 *    aderes/s-define.i must be included in the parent .p
 */

PROCEDURE calcfld_to_4gl:
  DEFINE INPUT-OUTPUT PARAMETER p_where  AS CHARACTER NO-UNDO.

  DEFINE VARIABLE qbf-b AS INTEGER   NO-UNDO. /* beginning byte */
  DEFINE VARIABLE qbf-e AS INTEGER   NO-UNDO. /* ending byte */
  DEFINE VARIABLE qbf-i AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf-j AS INTEGER   NO-UNDO. /* scrap */
  DEFINE VARIABLE qbf-l AS INTEGER   NO-UNDO. /* length calc field name */
  DEFINE VARIABLE qbf-n AS CHARACTER NO-UNDO.
  DEFINE VARIABLE qbf-s AS INTEGER   NO-UNDO. /* start byte */

  DO qbf-i = 1 TO qbf-rc#:
    IF qbf-rcc[qbf-i] = "" THEN NEXT.

    ASSIGN /* seed the lookup routine */
      qbf-s = 1
      qbf-n = ENTRY(1,qbf-rcn[qbf-i])
      qbf-l = LENGTH(qbf-n,"RAW":u)
      qbf-b = INDEX(p_where,qbf-n,qbf-s)
      qbf-e = qbf-b + qbf-l - 1
      .
    IF qbf-b = 0 THEN NEXT.

    DO WHILE qbf-s > 0:
      /* What we found is a calc field, since 'delimiting' characters imply 
         this string is not part of a db field name or string
      */
      IF (qbf-b = 1 OR
         INDEX("#$%&-_~.~'~"0123456789ETAONRISHDLFCMUGYPWBVKXJQZ":u,
	       SUBSTRING(p_where,qbf-b - 1,1,"CHARACTER":u)) = 0) AND
         (qbf-e = qbf-l OR
         INDEX("#$%&-_~.~'~"0123456789ETAONRISHDLFCMUGYPWBVKXJQZ":u,
	       SUBSTRING(p_where,qbf-e + 1,1,"CHARACTER":u)) = 0) THEN 
        SUBSTRING(p_where,qbf-b,qbf-l,"CHARACTER":u) = "(":u +
          SUBSTRING(qbf-rcn[qbf-i],INDEX(qbf-rcn[qbf-i],",":u) + 1,-1,
                    "CHARACTER":u) + ")":u.

      ASSIGN
        qbf-s = (IF qbf-e < qbf-l THEN qbf-e + 1 ELSE -1)
        qbf-b = (IF qbf-s > 0 THEN INDEX(p_where,qbf-n,qbf-s) ELSE 0)
        qbf-e = qbf-b + qbf-l - 1
        .
    END.
  END.
END PROCEDURE.

/* _calc4gl.i - end of file */


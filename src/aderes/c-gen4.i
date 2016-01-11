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
/* c-gen4.i - calc field code for main loop */

PROCEDURE generate_calc:
  DEFINE INPUT PARAMETER qbf_s AS CHARACTER NO-UNDO. /* qbf-section.qbf-sout */
  DEFINE INPUT PARAMETER marg# AS INTEGER   NO-UNDO. /* # of margin spaces */
  DEFINE INPUT PARAMETER supp  AS CHARACTER NO-UNDO. /* supported calc types */

  DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. /* scrap/loop */
  DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. /* calc field count */
  DEFINE VARIABLE qbf_m AS CHARACTER NO-UNDO. /* indent margin */
  DEFINE VARIABLE qbf_v AS CHARACTER NO-UNDO. /* field value */
  DEFINE VARIABLE fexp  AS CHARACTER NO-UNDO. /* qbf-rcn element */

  ASSIGN
    qbf_m = FILL(' ':u, marg#)
    qbf_k = 0.  

  /* First do lookup field qbf-nnn value determination */
  DO qbf_i = 1 TO qbf-rc#:
    IF NOT CAN-DO(qbf-rcs[qbf_i],qbf_s) OR /* not in this section */
       NOT CAN-DO(supp, SUBSTRING(qbf-rcc[qbf_i],1,1,"CHARACTER":u)) THEN NEXT. 

    IF qbf-rcc[qbf_i] BEGINS "x":u THEN DO:
      fexp = qbf-rcn[qbf_i].
      PUT UNFORMATTED
        qbf_m 'FIND FIRST qbf-':u STRING(qbf_i,"999":u) '-buffer WHERE qbf-':u
          STRING(qbf_i,"999":u) '-buffer.':u ENTRY(5,fexp) ' = ':u
          ENTRY(2,fexp) '.':u ENTRY(3,fexp)
          ' NO-LOCK NO-ERROR.':u SKIP.
    END.
    IF qbf-rcc[qbf_i] <> "" THEN
      qbf_k = qbf_k + 1.
  END.

  IF qbf_k > 1 THEN PUT UNFORMATTED qbf_m 'ASSIGN':u.

  IF qbf_k > 0 THEN
    DO qbf_i = 1 TO qbf-rc#:
      IF NOT CAN-DO(qbf-rcs[qbf_i],qbf_s) OR /* not in this section */
        NOT CAN-DO(supp, SUBSTRING(qbf-rcc[qbf_i],1,1,"CHARACTER":u)) THEN NEXT.

      fexp = qbf-rcn[qbf_i].
      qbf_v = (IF CAN-DO("s*,d*,n*,l*":u,qbf-rcc[qbf_i]) THEN
                SUBSTRING(fexp,INDEX(fexp,",":u) + 1,-1,"CHARACTER":u)
              ELSE
              IF qbf-rcc[qbf_i] BEGINS "x":u THEN
                SUBSTITUTE(
                  '(IF AVAILABLE qbf-&1-buffer THEN qbf-&1-buffer.&2 ELSE ?)':u,
                  STRING(qbf_i,"999":u),
                  ENTRY(6,fexp)
                )
              ELSE
                SUBSTITUTE(
                  IF      qbf-rcc[qbf_i] BEGINS "r":u THEN '&1 + &2':u
                  ELSE IF qbf-rcc[qbf_i] BEGINS "p":u THEN '&2 * 100 / &1%':u
                  ELSE IF qbf-rcc[qbf_i] BEGINS "c":u THEN '&1 + &3':u
                  ELSE '',
                ENTRY(1,fexp),
                ENTRY(2,fexp + ",":u),
                ENTRY(3,fexp + ",,":u)
                )
              ).

      IF qbf_v <> "" THEN
        PUT UNFORMATTED SKIP
          qbf_m (IF qbf_k = 1 THEN '' ELSE '  ':u)
          ENTRY(1,fexp) ' = ':u qbf_v.
    END.

  IF qbf_k > 0 THEN PUT UNFORMATTED '.':u SKIP.

END PROCEDURE. /* generate_calc */

/* c-gen4.i - end of file */


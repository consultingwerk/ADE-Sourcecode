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
/* c-gen2.i - generate FOR EACH with BREAK BY's and user's include code at
      	      start of loop.
              
   Variables that must be pre-defined:

     qbf_c   
     qbf_i
     qbf_k
     qbf_m
     qbf_s
*/

/* Do counter processing */
qbf_k = 0.
IF qbf_s <> "1":u THEN DO:
  DO qbf_i = 1 TO qbf-rc# WHILE qbf_k < 2:
    IF qbf-rcc[qbf_i] BEGINS "c":u AND ENTRY(1,qbf-rcs[qbf_i]) = qbf_s THEN
      qbf_k = qbf_k + 1.
  END.
  IF qbf_k > 1 THEN 
    PUT UNFORMATTED SUBSTRING(qbf_m,3,-1,"CHARACTER":u) 'ASSIGN':u.

  DO qbf_i = 1 TO qbf-rc# WHILE qbf_k > 0:
    IF qbf_k > 1 THEN PUT UNFORMATTED SKIP '  ':u.
    IF qbf-rcc[qbf_i] BEGINS "c":u AND ENTRY(1,qbf-rcs[qbf_i]) = qbf_s THEN
      PUT UNFORMATTED
        SUBSTRING(qbf_m,3,-1,"CHARACTER":u) 'qbf-':u 
        STRING(qbf_i,"999":u) ' = ':u
        INTEGER(ENTRY(2,qbf-rcn[qbf_i]))
              - INTEGER(ENTRY(3,qbf-rcn[qbf_i])).
  END.
  IF qbf_k > 0 THEN PUT UNFORMATTED '.':u SKIP.
END.

/* generate FOR EACH */
/*
{ aderes/c-gen7.i &tables = "qbf-section.qbf-stbl" 
      	       	  &margin = "NUM-ENTRIES(qbf_s,'.':u) * 2"
      	       	  &sbuffer = "qbf-section"
}
*/
{ aderes/c-gen7.i &tables = "qbf-section.qbf-stbl" 
      	       	  &margin = "LENGTH(qbf_m,'CHARACTER':u) - 2"
      	       	  &sbuffer = "qbf-section"
}

/* generate BREAK BY */
IF qbf-section.qbf-sort <> "" THEN DO: /* dma */
  DO qbf_i = 1 TO NUM-ENTRIES(qbf-section.qbf-sort):

    /* is this a calculated sort field? */
    DO qbf_k = 1 TO qbf-rc#:
      IF ENTRY(1,qbf-rcn[qbf_k]) = 
        REPLACE(ENTRY(qbf_i,qbf-section.qbf-sort)," DESC":u,"") THEN LEAVE.
    END.
    
    IF qbf_k <= qbf-rc# AND qbf-rcc[qbf_k] > "" THEN
      qbf_c = "(":u 
            + SUBSTRING(qbf-rcn[qbf_k],INDEX(qbf-rcn[qbf_k],",":u) + 1,
                                -1,"CHARACTER":U) 
            + ")":u
            + (IF INDEX(ENTRY(qbf_i,qbf-section.qbf-sort)," DESC":u) > 0 THEN 
                 " DESC":u ELSE "")
            .
    ELSE
      qbf_c = ENTRY(qbf_i,qbf-section.qbf-sort).
  
    IF qbf_i = 1 THEN
      PUT UNFORMATTED SKIP qbf_m 'BREAK BY ' qbf_c.    
    ELSE
      PUT UNFORMATTED SKIP qbf_m '  BY ' qbf_c.
  END.
END.

PUT UNFORMATTED ':':u SKIP(1).

/* process any include file entries */
DO qbf_i = 1 TO NUM-ENTRIES(qbf-section.qbf-stbl):
  FIND FIRST qbf-where
    WHERE qbf-where.qbf-wtbl = INTEGER(ENTRY(qbf_i,qbf-section.qbf-stbl))
    NO-ERROR.
  IF AVAILABLE qbf-where AND qbf-where.qbf-winc <> "" THEN
    PUT CONTROL
      qbf_m '/* ':u FILL('- ':u,37 - INTEGER(LENGTH(qbf_m,"CHARACTER":u) / 2)) 
      '*/':u CHR(10)
      qbf_m qbf-where.qbf-winc CHR(10)
      qbf_m '/* ':u FILL('- ':u,37 - INTEGER(LENGTH(qbf_m,"CHARACTER":u) / 2)) 
      '*/':u CHR(10).
END.

PUT UNFORMATTED qbf_m 'qbf-count  = qbf-count + 1.':u SKIP.

/* c-gen2.i - end of file */


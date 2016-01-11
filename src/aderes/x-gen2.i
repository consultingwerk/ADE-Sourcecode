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
/* x-gen2.i - generate FOR-EACH with WHEREs and BREAK-BYs */

RUN "aderes/c-for.p" (qbf-tables,0,FALSE,"FOR").

qbf-c = ''.
DO qbf-i = 1 TO NUM-ENTRIES(qbf-sortby):
  DO qbf-j = 1 TO qbf-rc#:
    /* See if sort field name matches entry 1 of qbf-rcn */
    IF (REPLACE(ENTRY(qbf-i,qbf-sortby)," DESC":u,"") =
        ENTRY(1,qbf-rcn[qbf-j])) THEN LEAVE.
  END.
    
  /* qbf-c will be either the name of the field or the calc field
     expression (which is second entry in qbf-rcn), followed
     by "DESC" if appropriate.
  */   
  qbf-c = qbf-c + (IF qbf-c > "" THEN CHR(3) ELSE "":u)
         + (IF qbf-j <= qbf-rc# AND qbf-rcc[qbf-j] > "" THEN
           "(":u 
           + SUBSTRING(qbf-rcn[qbf-j],INDEX(qbf-rcn[qbf-j],",":u) + 1,-1,
                       "CHARACTER":u) 
           + ")":u
           + (IF INDEX(ENTRY(qbf-i, qbf-sortby)," DESC":u) > 0 THEN 
               " DESC":u ELSE "")
           ELSE ENTRY(qbf-i,qbf-sortby)).
END.

IF {&by} AND qbf-c <> "" THEN
  PUT UNFORMATTED SKIP ' BREAK BY ':u REPLACE(qbf-c,CHR(3),' BY ':u).

PUT UNFORMATTED SKIP
  '  {&total}':u {&on} ':':u SKIP.

/* x-gen2.i - end of file */


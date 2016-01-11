/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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


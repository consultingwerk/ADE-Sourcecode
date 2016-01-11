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
/* p-comma.i - converts format from ".," to ",." and back */

PROCEDURE comma_swap:
  DEFINE INPUT-OUTPUT PARAMETER qbf_f AS CHARACTER NO-UNDO.

  qbf_f = REPLACE(
            REPLACE(
              REPLACE(qbf_f,",":u,CHR(1))
            ,".":u,",":u)
          ,CHR(1),".":u).

  /*
  DEFINE VARIABLE qbf_i AS INTEGER NO-UNDO.
  DO qbf_i = 1 TO LENGTH(qbf_f):
    IF SUBSTRING(qbf_f,qbf_i,1) = "." THEN SUBSTRING(qbf_f,qbf_i,1) = ",".
    ELSE
    IF SUBSTRING(qbf_f,qbf_i,1) = "," THEN SUBSTRING(qbf_f,qbf_i,1) = ".".
  END.
  */

END.

/* p-comma.i - end of file */


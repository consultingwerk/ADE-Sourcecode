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
/*  Procedure prodict/misc/_clproto.p  Procedure to remove created database when
              an error has occurred so that user can fix the problems and run the
              ProToxxx again.  Do not delete *.log as there could be information
              in the log that the user needs.  The *.sql gets overwritten so
              no need to delete in case user wants to look.
    
    Created: 12/07/99 D. McMann
*/              

DEFINE INPUT PARAMETER sh_dbname  AS CHARACTER.
DEFINE INPUT PARAMETER pro_dbname AS CHARACTER.

DEFINE VARIABLE deldb    AS CHARACTER          NO-UNDO.
DEFINE VARIABLE extsion  AS CHARACTER EXTENT 5 NO-UNDO.
DEFINE VARIABLE i        AS INTEGER            NO-UNDO.
 
  
ASSIGN extsion[1] = ".lg"
       extsion[2] = ".st"
       extsion[3] = ".db"
       extsion[4] = ".d1"
       extsion[5] = ".b1".

DO i = 1 TO 5:
  ASSIGN deldb = sh_dbname + extsion[i]. 
  OS-DELETE VALUE(deldb).       
END.

CREATE ALIAS DICTDB FOR DATABASE VALUE(pro_dbname).

RETURN.

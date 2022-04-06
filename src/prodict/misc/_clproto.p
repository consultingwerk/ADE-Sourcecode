/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

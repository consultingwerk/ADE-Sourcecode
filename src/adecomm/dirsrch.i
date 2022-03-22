/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * DIRSRCH.I
 *
 * This is the header for dirsrch.dll.  For quick and dirty directory 
 * searches.
 *
 * PROCEDURE NAME:  dir_search_dll
 *     PARAMETERS:  search-dir  :  Directory to search in, can be relative, use /../../, etc.
 *                  file-spec   :  comma delimited list of file types, can have trailing comma
 *                                 e.g: " foo?ar.*  ,  *.p, "
 *                  file-list   :  A MEMPTR *PRE-ALLOCATED* to hold the comma delimited list
 *                  list-size   :  Num bytes allocated to the file-list.  Don't exceed 32K.
 *                  miss-count  :  Returned as the number of files that didn't fit in the list.
 *                  error-val   :  0 if there were no errors.
 *                                 1- file list buffer is too small
 *                                 2- file list buffer is too big
 *                                 3- invalid path given
 *                                 4- drive is invaild
 *                                 5- directory on drive is invaild
 *                                 6- malloc failed (yeow!)
 */
 
PROCEDURE file_search EXTERNAL "dirsrch.dll":
 DEFINE INPUT        PARAMETER Search-Dir   AS HANDLE TO CHARACTER.
 DEFINE INPUT        PARAMETER File-Spec    AS HANDLE TO CHARACTER.
 DEFINE INPUT-OUTPUT PARAMETER File-List    AS MEMPTR.
 DEFINE INPUT        PARAMETER List-Size    AS LONG.          
 DEFINE OUTPUT       PARAMETER Missed-Count AS HANDLE TO LONG.
 DEFINE RETURN       PARAMETER Error-Val    AS SHORT.         
END PROCEDURE.

/* 
  Since this can get complex and ugly, here's a sample usage:
  (also grep through adeuib for some real uses of it)
  
  DEF VAR list-mem    AS MEMPTR.
  DEF VAR list-char   AS CHARACTER.
  DEF VAR list-size   AS INT       INIT 400.  /* 400 chars or about 40 files */
  DEF VAR srch-dir    AS CHARACTER INIT "~\tmp".
  DEF VAR missed-file AS INT.
  DEF VAR error       AS INT.
  DEF VAR sl          AS CHAR VIEW-AS SELECTION-LIST SIZE 30 BY 10.
  
  SET-SIZE(list-mem) = list-size.
  
  RUN file_search (srch-dir, 
                   "srt*.*, lib*.*, *.uib, ",
                   INPUT-OUTPUT list-mem,
                   list-size,
                   OUTPUT missed-file,
                   OUTPUT error).
                   
  IF error <> 0 THEN
     DO:
     MESSAGE "Error in directory search.".
     LEAVE.
     END.
     
  list-char = GET-STRING(list-mem,1).  /* Copy into char var */
  
  SET-SIZE(list-mem) = 0.              /* Free the mem */

  FORM sl WITH FRAME test.
  sl:LIST-ITEMS = list-char.
  UPDATE sl WITH FRAME test.     
     
*/

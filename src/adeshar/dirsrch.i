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
  DEF VAR srch-dir    AS CHARACTER INIT "/tmp".
  DEF VAR missed-file AS INT.
  DEF VAR error       AS INT.
  DEF VAR sl          AS CHAR VIEW-AS SELECTION-LIST.
  
  SET-SIZE(list-mem) = list-size.
  
  RUN file_search (srch-dir, 
                   "srt*.*, lib*.*, *.uib, ",
                   INPUT-OUTPUT list-mem,
                   list-size,
                   OUTPUT missed-file
                   OUTPUT error).
                   
  IF error <> 0 THEN
     DO:
     MESSAGE "Error in directory search."
     LEAVE.
     END.
     
  list-char = GET-STRING(list-mem,1).  / Copy into char var /
  
  SET-SIZE(list-mem) = 0.              / Free the mem /
     
  etc...

*/

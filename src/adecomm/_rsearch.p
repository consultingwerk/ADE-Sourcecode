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
/* --------------------------------------------------------------------
   _rsearch.p -- Acts like the function SEARCH, except it also looks for
                 r-code for a file. For example, for:
       p_file          SEARCH for
       ------          ----------
       test.w          test.w, test.r
       .\test          .\test, .\test.r
       c:bin.dir/test  c:bin.dir/test, c:bin.dir/test.r
       test.r          test.r
   
   Parameters:
      p_File  (INPUT CHAR) Name of file to test.
      p_Seach (OUTPT CHAR) The result of the SEARCH.   
   
   Author:  Wm.T.Wood
   Created: April 1996    
 --------------------------- Test Code --------------------------------

   def var c as char format "x(30)" INITIAL "adeuib/_uibmain.p".
   DO WHILE c ne "":
     UPDATE c.
     RUN adecomm/r-search.p (c, OUTPUT c).
     MESSAGE c.
   END.

 ---------------------------------------------------------------------- */
DEF INPUT PARAMETER  p_file   AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER p_search AS CHAR NO-UNDO.    

DEF VAR end-of-path AS INTEGER NO-UNDO.
DEF VAR last-dot    AS INTEGER NO-UNDO.

/* Make sure the file name uses portable BACK-SLASHES. */
p_file = REPLACE (p_file, "~\":U, "~/":U). 

/* Is the simple file name found already? */
p_Search = SEARCH(p_file). 

IF p_Search eq ? THEN DO:
  /* Look from the end of the file-name for the last character of the path.
   * That is, look for the latter of ":" or "/" in a file name like:
   *           c:test.w, or adeuib/_uibmode.p
   */
  end-of-path = MAX (R-INDEX(p_file, ":":U), R-INDEX(p_file, "~/":U)).
  
  /* Now look for the last "." */ 
  last-dot = R-INDEX (p_file, ".":U).
  
  /* Make sure this "." is not in the path 
    (i.e. watch out for c:\bin.win\test). */
  if last-dot < end-of-path THEN last-dot = 0.
  
  /* Break off the extenstion. */
  IF last-dot > 0 THEN 
    p_file = SUBSTRING(p_file, 1, last-dot - 1, "CHARACTER":U).  
    
  /* Check for r-code. */
  p_Search = SEARCH (p_file + ".r":U).
END.


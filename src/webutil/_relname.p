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
**********************************************************************

   _relname.p -- Returns the PROPATH relative filename for a file.
                 
       p_file          SEARCH for
       ------          ----------
       test.w          test.w, test.r
       .\test          .\test, .\test.r
       c:bin.dir/test  c:bin.dir/test, c:bin.dir/test.r
       test.r          test.r
   
   Input Parameters:
      p_File      (CHAR) Name of file to test.
      p_options   (CHAR) Comma-delimited list of options
                       MUST-EXIST -- file must exist  
                       MUST-BE-REL -- return ? if it is not in the propath even
                                      if it exists.
                   
   Output Parameters:
      p_Relname   (OUTPUT CHAR) The relative pathname. If the file is not
                  found in PROPATH, then this returns p_File.
                  If the file does not exist (and if MUST-EXIST is set)
                  p_relname will be ?.  
                  
                  The output name is always returned with Progress portable
                  slashes.
   
   Author:  Wm.T.Wood
   Created: January, 1997    
   
   Note: This file has been moved to the adecomm directory.  For now we 
         are redirecting references to that file.  In the future all
         references should go there directly and this file can be 
         totally eliminated.  DRH 3/24/98
 
 --------------------------- Test Code --------------------------------

   def var c as char format "x(30)" INITIAL "adeuib/_uibmain.r".
   DO WHILE c ne "":
     UPDATE c.
     RUN webutil/_relname.p (c, "MUST-EXIST", OUTPUT c).
     MESSAGE c.
   END.

 ---------------------------------------------------------------------- */
DEFINE INPUT  PARAMETER p_file    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_options AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_relname AS CHARACTER NO-UNDO INITIAL ?.    

RUN adecomm/_relname.p (p_file, p_options, OUTPUT p_relname).

/* _relname.p - end of file */

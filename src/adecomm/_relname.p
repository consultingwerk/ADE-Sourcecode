/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* --------------------------------------------------------------------
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


Modified on 11/28/00 achlensk - added logic that removes the longest PROPATH from filename, 
                                not the first match.

 --------------------------- Test Code --------------------------------

   def var c as char format "x(30)" INITIAL "adeuib/_uibmain.r".
   DO WHILE c ne "":
     UPDATE c.
     RUN webutil/_relname.p (c, "MUST-EXIST", OUTPUT c).
     MESSAGE c.
   END.

 ---------------------------------------------------------------------- */
DEF INPUT  PARAMETER p_file    AS CHAR NO-UNDO.
DEF INPUT  PARAMETER p_options AS CHAR NO-UNDO.
DEF OUTPUT PARAMETER p_relname AS CHAR NO-UNDO INITIAL ?.    

DEF VAR i               AS INTEGER NO-UNDO.   
DEF VAR cnt             AS INTEGER NO-UNDO.   
DEF VAR dir             AS CHAR    NO-UNDO.   
DEF VAR filename        AS CHAR    NO-UNDO.   
DEF VAR l_must-exist    AS LOGICAL NO-UNDO.   
DEF VAR l_must-be-rel   AS LOGICAL NO-UNDO.   
DEF VAR cLongestProPath AS CHAR    NO-UNDO.


/* If the file does not exist, just return. */
ASSIGN filename             = p_file
       FILE-INFO:FILE-NAME  = filename
       l_must-exist         = (LOOKUP ("MUST-EXIST":U,  p_options) > 0)    
       l_must-be-rel        = (LOOKUP ("MUST-BE-REL":U,  p_options) > 0)    
       .
/* Check for file not found. */
IF FILE-INFO:FULL-PATHNAME ne ?
THEN filename = FILE-INFO:FULL-PATHNAME.
ELSE DO:
  IF l_must-exist THEN RETURN.
END.

/* Make sure the file name uses portable BACK-SLASHES. */
filename = REPLACE (filename, "~\":U, "~/":U). 
    
/* At this point, filename will equal the FULL-PATHNAME of the file (if it
   exists, or the original name, if it does not.  
   Go through the directories in PROPATH looking for one that matches.  */

cnt = NUM-ENTRIES(PROPATH).
DO i = 1 TO cnt:
  dir = ENTRY (i, PROPATH).
  /* Get the full pathname of the directory without any fancy characters. */
  IF dir = "" THEN dir = ".". 
  ASSIGN FILE-INFO:FILE-NAME = dir
         dir = REPLACE (FILE-INFO:FULL-PATHNAME, "~\":U, "~/":U) + "~/":U
         .

  /* Strip the PROPATH dir out of the filename. */
  IF filename BEGINS dir THEN
  ASSIGN cLongestProPath 
  = 
  IF NUM-ENTRIES(dir, '/') > NUM-ENTRIES(cLongestProPath, '/') 
  THEN dir 
  ELSE cLongestProPath.
END.

IF cLongestProPath <> "" THEN
  DO:
  p_relname = SUBSTRING (filename, LENGTH(cLongestProPath, "CHARACTER":U) + 1, -1, "CHARACTER":U).
  RETURN.
  END.

/* If we get here, then the file was not found relative to PROPATH. 
   Return the original name unless it must be in the relative path. */
p_relname = IF l_must-be-rel THEN ? ELSE filename.

/*
 * --- End of File 
 */
 

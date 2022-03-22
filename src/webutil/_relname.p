/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
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
                       OPEN-SAVE -- when opening or saving a file (including rcode)
                                      do not search path in PROPATH 
                   
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

/* IZ1852 */
/* Included code to test if we need to check PROPATH or not */
/* Taken from adecomm/_relname.p */

DEF VAR filename        AS CHAR    NO-UNDO.   
DEF VAR l_must-exist    AS LOGICAL NO-UNDO.   
DEF VAR l_must-be-rel   AS LOGICAL NO-UNDO.   
DEF VAR cur-dir         AS CHAR    NO-UNDO.

DEF VAR l_save          AS LOGICAL NO-UNDO.

/* IZ1852: */
/* If we find 'open-save' in p_options, then we won't pass the call to       */
/* adecomm/_relname.p . When opening or saving a file, the file might end up */
/* in the working directory if the directory is in the PROPATH               */

IF (LOOKUP ("OPEN-SAVE":U,  p_options) > 0 ) THEN DO:

    /*finds out the working directory */
    ASSIGN FILE-INFO:FILE-NAME = ".":U.
    
    ASSIGN cur-dir = FILE-INFO:FULL-PATHNAME.
    
    ASSIGN cur-dir = REPLACE (cur-dir, "~\":U, "~/":U) + "~/":U.

    /* If the file does not exist, just return. */
    ASSIGN filename             = p_file
         FILE-INFO:FILE-NAME  = filename
         l_must-exist         = (LOOKUP ("MUST-EXIST":U,  p_options) > 0)    
         l_must-be-rel        = (LOOKUP ("MUST-BE-REL":U,  p_options) > 0)    
         .

    /*Check for file not found. */   
    IF FILE-INFO:FULL-PATHNAME ne ?
         THEN filename = FILE-INFO:FULL-PATHNAME.
    ELSE DO:
         IF l_must-exist THEN RETURN.
    END.

    /* Make sure the file name uses portable BACK-SLASHES. */
    ASSIGN FILENAME = REPLACE (FILENAME, "~\":U, "~/":U).

    /*test to see if directory is under the working directory */
   
    IF (FILENAME BEGINS cur-dir) THEN 
        /* Strip the working dir out of the filename. */
        p_relname = SUBSTRING (FILENAME, LENGTH(cur-dir, "CHARACTER":U) + 1, -1, "CHARACTER":U).
    ELSE 
        ASSIGN p_relname = p_file.

END.
ELSE
      /*If we need to check PROPATH for directory, pass parameters to adecomm/_relname.p */
      RUN adecomm/_relname.p (p_file, p_options, OUTPUT p_relname).

/* _relname.p - end of file */

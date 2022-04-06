/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* i-file
*
*    Returns read write information on the file or the directory
*    the file is in, if the file can't be found.
*/

DEFINE INPUT  PARAMETER fName    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER readable AS LOGICAL   NO-UNDO INITIAL ?.
DEFINE OUTPUT PARAMETER writable AS LOGICAL   NO-UNDO INITIAL ?.
DEFINE OUTPUT PARAMETER fFound   AS LOGICAL   NO-UNDO INITIAL TRUE.

DEFINE VARIABLE slash AS CHARACTER NO-UNDO.

&IF "{&WINDOW-SYSTEM}" BEGINS "MS-WIN" &THEN
slash = "~\".
&ELSE
slash = ~"/".
&ENDIF

/*
* Get the OS level information about the file. We need to know if the
* user can read or write the file. Also, we need to know if there is a
* file out there. The user may be trying to create a new file a
* file.
*/
ASSIGN
  FILE-INFO:FILE-NAME = fName
  writable            = (INDEX(FILE-INFO:FILE-TYPE, "W":u) > 1)
  readable            = (INDEX(FILE-INFO:FILE-TYPE, "R":u) > 1)
  .

IF writable = ? THEN DO:
  /*
  * The file doesn't exist. Let's try to figure out if the user
  * can write out the file. If we only have a file name then check to
  * see if we can write in the current directory.
  */
  IF NUM-ENTRIES(fName, slash) = 1 THEN fName = ".":u.

  ASSIGN
    fFound              = FALSE
    FILE-INFO:FILE-NAME = SUBSTRING(fName,1,R-INDEX(fName, slash) - 1,
                            "CHARACTER":u)
    writable            = (INDEX(FILE-INFO:FILE-TYPE, "W":u) > 1)
    readable            = (INDEX(FILE-INFO:FILE-type, "R":u) > 1)
    .

  /* If we can't write to the directory then let the app know.  */
  IF writable = ? THEN writable = FALSE.
  IF readable = ? THEN readable = FALSE.
END.

/* _ifile.p - end of file */


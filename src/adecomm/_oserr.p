/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _oserr.p
 * 
 *  Provides an error message for OS-ERROR.
 */

define output parameter errText as character no-undo.

case OS-ERROR:

    when   0 then errText = "".
    when   1 then errText = "Not Owner".
    when   2 then errText = "No such file or directory".
    when   3 then errText = "Interrupted system call".
    when   4 then errText = "I/O error".
    when   5 then errText = "Bad file number".
    when   6 then errText = "No more processes".
    when   7 then errText = "Not enough core memory".
    when   8 then errText = "Permission denied".
    when   9 then errText = "Bad address".
    when  10 then errText = "File exists".
    when  11 then errText = "No such device".
    when  12 then errText = "Not a directory".
    when  13 then errText = "Is a directory".
    when  14 then errText = "File table overflow".
    when  15 then errText = "Too many open files".
    when  16 then errText = "File too large".
    when  17 then errText = "No space left on device".
    when  18 then errText = "Directory not empty".
    otherwise     errText = "Unmapped error (PROGRESS default)".
end.

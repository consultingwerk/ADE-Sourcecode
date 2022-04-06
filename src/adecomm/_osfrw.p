/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
Procedure:  _osfrw.p
    
Purpose:    Determines if a specified file can be read from and written to.

Syntax :
    RUN adecomm/_osfrw.p
       (INPUT p_file , INPUT p_flags , OUTPUT p_access).

Parameters:
    p_file  The file you want to read from and/or write to.
        
    p_flags Comma-delimited list of flags to provide fine control over
            this routine.
            
            _READ-TEST    When present, p_file is tested for read access.
                              
            _WRITE-TEST   When present, p_file is tested for write access.
                              
            _DELETE-FILE  When present, p_file is deleted after testing
                          it for read/write access.
                              
            _SAVE-FILE    When present, p_file is first read and then
                          re-written onto itself. This preserves the file's
                          contents while still checking the write permissions.
                              
    p_access String that will contain "R" if the file was read successfully
             and "W" if the file was written successfully. This is just like
             the FILE-INFO:FILE-TYPE behavior.
                 
Description:

Notes  : 1. For _WRITE-TEST, if p_file does not exist, its created.
            If it does exist, its contents are emptied unless you 
            specifiy the _SAVE-FILE flag.
                
         2. To remove a write test file, specify _DELETE-FILE flag.

         3. This routine can be useful to replace FILE-INFO because
            FILE-INFO does not return RW access based on network
            privileges for MS platforms.
                
Authors: John Palazzo
Date   : September, 1995
**************************************************************************/

DEFINE INPUT  PARAMETER p_file     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_flags    AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_access   AS CHARACTER NO-UNDO.

DEFINE VARIABLE read-ok  AS LOGICAL FORMAT "R/":U NO-UNDO.
DEFINE VARIABLE write-ok AS LOGICAL FORMAT "W/":U NO-UNDO.

FORM p_file VIEW-AS EDITOR SIZE 60 BY 10 LARGE NO-WORD-WRAP
    WITH FRAME f_write.

DO ON STOP UNDO, RETRY:
  IF NOT RETRY THEN
  DO:
    IF CAN-DO(p_flags, "_READ-TEST":U) OR
       CAN-DO(p_flags, "_SAVE-FILE":U) THEN
    DO:
      ASSIGN read-ok = p_file:READ-FILE(p_file) IN FRAME f_write NO-ERROR.
      IF CAN-DO(p_flags, "_READ-TEST":U) THEN
        ASSIGN p_access = STRING(read-ok, "R/":U).
    END.
    
    IF CAN-DO(p_flags, "_WRITE-TEST":U) THEN
    DO:
      ASSIGN write-ok = p_file:SAVE-FILE(p_file) IN FRAME f_write NO-ERROR.
      ASSIGN p_access = p_access + STRING(write-ok, "W/":U).
    END.

  END.
  IF CAN-DO(p_flags , "_DELETE-FILE":U) THEN
    OS-DELETE VALUE(p_file) NO-ERROR.
END.

RETURN.

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _getflen.p
    
    Purpose:    Returns the length in bytes of an editor widget or disk
                file.
                
    Syntax :
    
        RUN adecomm/_getflen.p
                (INPUT  p_Editor     /* Editor handle.   */ ,
                 INPUT  p_File_Name  /* OS file.         */ ,
                 OUTPUT p_Length     /* Length in bytes  */ ).

    Parameters:
    
    p_Editor
        Handle of Editor widget whose length you want to query.

    p_File_Name 
        Name of OS file whose length you want to query. Pass Null ("") and
        this procedure will query the length of the passed Editor widget
        instead.
        
    
    p_Length
        Length of the editor widget or file in bytes.

    Description:
        Return the length of an OS file or PROGRESS Editor widget.
        
        Reasons for using this routine:
          - Simple, fast, portable method to get the length of an OS file.
          - Bypass the slow LENGHT attribute of the MS-Windows LARGE Editor.
          - Bypass the DOS Character Editor widget's LENGTH attribute which
            returns an internal buffer size that does not include <CR> in the
            EOL sequence, thereby returning a length smaller than what DOS
            reports.
            
        Here's the length algorithm:
        
        1. Copy the contents of the edit buffer to a temp buffer.
        2. Get a temp file name and save to that file.
        3. Open OUTPUT APPEND to position SEEK pointer at end of file and
           assign that as the length.
        4. Close the output and delete the temporary file, if one was
           used.
    
    Notes  :
    Authors: John Palazzo
    Date   : January, 1994
    Updated: January, 1995
**************************************************************************/

DEFINE INPUT  PARAMETER p_Editor    AS WIDGET    NO-UNDO.
DEFINE INPUT  PARAMETER p_File_Name AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_Length    AS INTEGER   NO-UNDO.

DEFINE VAR l_ok       AS LOGICAL   NO-UNDO.
DEFINE VAR l_Modified AS LOGICAL   NO-UNDO.
DEFINE VAR temp_file  AS CHARACTER NO-UNDO.

DO ON STOP UNDO, RETRY:

  IF NOT RETRY THEN DO:
    CASE p_File_Name:   /* No OS File, so query the editor widget. */
      WHEN "" THEN DO:
        IF p_Editor:EMPTY THEN RETURN.
        ASSIGN l_Modified = p_Editor:MODIFIED.
        RUN adecomm/_tmpfile.p ("",".ade":u,OUTPUT temp_file).

        /* Need the repeat here to trap error and be sure the editor
           widget's MODIFIED state is returned to what it was.
         */
        REPEAT ON STOP UNDO, LEAVE:
          ASSIGN l_ok = p_Editor:SAVE-FILE( temp_file ).
          /* Position the seek pointer at the end of the file. */
          OUTPUT TO VALUE(temp_file) APPEND NO-ECHO.
          ASSIGN p_Length = SEEK(OUTPUT).
          LEAVE.
        END.
        ASSIGN p_Editor:MODIFIED = l_Modified.
      END.
            
      OTHERWISE DO:   /* Query length of OS file. */
        /* Position the seek pointer at the end of the file. */
        OUTPUT TO VALUE(p_File_Name) APPEND NO-ECHO.
        ASSIGN p_Length = SEEK(OUTPUT).
      END.
    END CASE.
  END.
  OUTPUT CLOSE.
  OS-DELETE VALUE( temp_file ).
END. /* DO */

/* _getflen.p - end of file */


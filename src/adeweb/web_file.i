/*********************************************************************
* Copyright (C) 2000 - 2005 by Progress Software Corporation ("PSC"),*
* 14 Oak Park, Bedford, MA 01730, and other contributors as listed   *
* below.  All Rights Reserved.                                       *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _web_file.i
    
    Purpose:    Preprocessor Define and functions used to manage
                relative and full path name for files mantained
                through the remote development mode (WebSpeed).

    Syntax :    { adecomm/web_file.i }

    Parameters:
    
    Description:
        When opening or saving files in remote development mode, we need
        to display the relative path in the AppBuilder tool, but we have to
        maintain the full path to send it to the WebSpeed agent when saving
        the file. We also need to keep the full path so that when the user
        opens the file using the MRU list, we open the correct file. The issue
        is that if all we get is the relative path, if the file is found in more
        than one place in the agent's PROPATH, we may end up opening/saving the
        wrong file and from/to the wrong directory.
        
        We will work with a string with the following format:
        relative-path + chr(1) + path-to-relative-path
        
        By concatenating path-to-relative-path + relative-path we will get the
        full path name.
                
        Additional information is provided in the code comments.
    
    Notes  :
    Authors: Fernando de Souza
    Date   : September, 2005
**************************************************************************/

&SCOPED-DEFINE WEB-PATH-SEPARATOR CHR(1)

/* Receives the relative and absolute path name and returns the string in the format
   known by this facility */
FUNCTION ws-set-path-info RETURN CHARACTER (INPUT cRelName AS CHARACTER,
                                             INPUT cFullPath AS CHARACTER).

    DEFINE VAR p_fileName AS CHAR NO-UNDO.
    DEFINE VAR cPath      AS CHAR NO-UNDO.

    IF cFullPath NE cRelName THEN
       ASSIGN cPath = SUBSTRING(cFullPath,1,LENGTH(cFullPath) - LENGTH(cRelName))
              /* Filename is now a two part list - relative name first, 
                 path to cRelName */
              p_fileName = cRelName + {&WEB-PATH-SEPARATOR} + cPath.
    ELSE
        ASSIGN p_fileName = cRelName.

    RETURN p_fileName.

END FUNCTION.


/* given a string with the format known by this facility, returns the save-as-path */
FUNCTION ws-get-save-as-path RETURN CHARACTER (INPUT cString AS CHARACTER).

    /* if there is no path, return the unknown value */
    IF INDEX(cString, {&WEB-PATH-SEPARATOR}) = 0 THEN
       RETURN ?.

    RETURN ENTRY(2,cString, {&WEB-PATH-SEPARATOR}).
END FUNCTION.


/* given a string with the format known by this facility, returns the filename using the
   relative path */
FUNCTION ws-get-relative-path RETURN CHARACTER (INPUT cString AS CHARACTER).
    
    RETURN ENTRY(1,cString, {&WEB-PATH-SEPARATOR}).

END FUNCTION.

/* given a string with the format known by this facility, returns the filename with
  full path name */
FUNCTION ws-get-absolute-path RETURN CHARACTER (INPUT cString AS CHARACTER).

    /* if there is no path, return the unknown value */
    IF INDEX(cString, {&WEB-PATH-SEPARATOR}) = 0 THEN
       RETURN cString.

    RETURN ENTRY(2, cString, {&WEB-PATH-SEPARATOR}) 
                                   + ENTRY(1, cString, {&WEB-PATH-SEPARATOR}).
END FUNCTION.

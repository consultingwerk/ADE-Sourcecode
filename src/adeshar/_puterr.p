/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _puterr.p
                                       
    Purpose:    Displays alert box message indicating an ADE Tool's
                failure to save its settings to the PROGRESS environment
                file.

    Syntax :    RUN adeshar/_puterr.p ( INPUT p_Tool , INPUT p_Window ).

    Parameters:
        p_Tool      String indicating name of ADE Tool whose settings
                    could not be saved.  Defaults to null if not passed.
        p_Window    Handle of window in which you want the alert message to
                    display. If invalid handle passed, uses DEFAULT-WINDOW.
    Description:
    Notes  :
    Authors: John Palazzo
    Date   : April, 1994
    Modified by gfs on 1/6/97 - Added reference to Registry
**************************************************************************/

DEFINE INPUT PARAMETER p_Tool   AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER p_Window AS WIDGET    NO-UNDO.

IF NOT VALID-HANDLE( p_Window ) OR p_Window:TYPE <> "WINDOW":U
THEN ASSIGN p_Window = DEFAULT-WINDOW.

IF p_Tool = ? THEN p_Tool = "".

MESSAGE "Unable to save" p_Tool "settings." SKIP(1) 
        "You may not have access to the Windows Registry or" SKIP
        "the Windows Registry has become corrupted." SKIP(1)
        "If you are using the PROGRESS environment file," SKIP
        "it may be read-only or it may be located in a " SKIP
        "directory where you do not have write permissions."
    VIEW-AS ALERT-BOX WARNING IN WINDOW p_Window .

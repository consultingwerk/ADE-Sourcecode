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

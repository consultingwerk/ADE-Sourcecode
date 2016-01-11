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
    Procedure:  _runonce.i
                                       
    Purpose:    Checks to see if this procedure is already running
                and if so kills the second copy.

    Syntax :    {protools/_runonce.i}

    Parameters: None
        
    Description:
    Notes  :
    Authors: Gerry Seidl
    Date   : 4/27/95
**************************************************************************/
DEFINE VARIABLE pt-applet-hdl AS HANDLE.
DEFINE VARIABLE pt-applet-win AS WIDGET-HANDLE.

/* Prevent this procedure from being called twice (by checking FILE-NAME) */
IF THIS-PROCEDURE:PERSISTENT THEN DO:
  /* See if a copy already exists. */
  pt-applet-hdl = SESSION:FIRST-PROCEDURE.
  DO WHILE VALID-HANDLE(pt-applet-hdl):
    IF pt-applet-hdl:FILE-NAME eq THIS-PROCEDURE:FILE-NAME AND
       pt-applet-hdl NE THIS-PROCEDURE:HANDLE
    THEN DO:
      pt-applet-win = pt-applet-hdl:CURRENT-WINDOW.
      IF pt-applet-win:WINDOW-STATE = 2 THEN pt-applet-win:WINDOW-STATE = 3.
      IF pt-applet-win:MOVE-TO-TOP() THEN.
      DELETE PROCEDURE THIS-PROCEDURE.
      RETURN.
    END.
    pt-applet-hdl = pt-applet-hdl:NEXT-SIBLING.
  END.
END.

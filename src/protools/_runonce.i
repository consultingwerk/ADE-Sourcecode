/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

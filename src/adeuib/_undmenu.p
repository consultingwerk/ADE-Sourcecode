/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
{adeuib/uniwidg.i}
{adeuib/sharvars.i}
{adeuib/triggers.i}

DEFINE INPUT PARAMETER uRecId AS RECID NO-UNDO.
DEFINE INPUT PARAMETER h_self AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h_menu AS WIDGET-HANDLE NO-UNDO.
DEFINE BUFFER x_U FOR _U.

IF uRecId EQ ? THEN RETURN.
FIND x_U WHERE RECID(x_U) = uRecId.
RUN adeuib/_updmenu.p (INPUT FALSE, INPUT uRecId, OUTPUT h_menu).
RUN set_menu_status ( "NORMAL", uRecId, _h_win ).
/* NOTE: Only windows can have menu bars, we set the popup handle. */
ASSIGN h_self:POPUP-MENU = h_menu.

PROCEDURE set_menu_status.
  DEFINE INPUT PARAMETER cipStatus AS CHARACTER NO-UNDO.
  DEFINE INPUT PARAMETER riipParent AS RECID NO-UNDO.
  DEFINE INPUT PARAMETER whWindowHandle AS WIDGET-HANDLE NO-UNDO.

  DEFINE BUFFER ipU FOR _U.
  DEFINE BUFFER ipM FOR _M.
  DEFINE BUFFER ipTRG FOR _TRG.

  FIND ipU WHERE RECID(ipU) = riipParent.
  FIND ipM WHERE RECID(ipM) = ipU._x-recid.
  ASSIGN ipU._WINDOW-HANDLE = whWindowHandle
         ipU._STATUS        = cipStatus.

  /* Update the status of all triggers associated with this menu. */
  FOR EACH ipTRG WHERE ipTRG._wRECID = riipParent:
    ASSIGN ipTRG._STATUS = cipStatus.
  END.
  
  /* Repeat for children and siblings. */
  IF ipM._child-recid <> ? THEN
    RUN set_menu_status( cipStatus, ipM._child-recid, whWindowHandle ).
  IF ipM._sibling-recid <> ? THEN
    RUN set_menu_status( cipStatus, ipM._sibling-recid, whWindowHandle ).
END PROCEDURE. /* set_menu_status. */

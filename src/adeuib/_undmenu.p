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

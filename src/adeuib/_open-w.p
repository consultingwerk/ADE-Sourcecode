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
/*------------------------------------------------------------------------

  File: _open-w.p 

  Description: Open a file into the UIB.

  Input Parameters:
      pFileName: Name of file to Open 
        File may be on WebSpeed agent, in which case pFileName includes the
        full pathname and pTempFile will contain the file's contents locally.
      pTempFile: Name of temp file to Open for remote web files
      pMode : Mode of open
        OPEN:     Open the file as a WINDOW or DIALOG-BOX
        UNTITLED: Open the file as a WINDOW or DIALOG-BOX, but don't
                    use the filename. (Open as UNTITLED).
        IMPORT:   Import into the UIB's current frame or window.
       
  Output Parameters:
     <none>

  Author: Wm.T.Wood

  Created: 11/05/93 -  8:57 am
  Updated: 12/08/97 - support for HTML files
           1/17/98  - support for WebSpeed files (adams)
      tsm  4/07/99  - added support for various Intl Numeric Formats (in
                      addition to American and European) by using session
                      set-numeric-format method to set format back to 
                      user's setting.
      tsm  6/24/99  - when setting _P._broker-url, use the broker url from 
                      the mru fileslist if the file is being opened from it
------------------------------------------------------------------------ */
DEFINE INPUT PARAMETER pFileName AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pTempFile AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER pMode     AS CHARACTER NO-UNDO.

/* UIB Shared Variables and Common Definitions */
{adeuib/sharvars.i}
{adeuib/uniwidg.i}

DEFINE VARIABLE cHostName   AS CHARACTER NO-UNDO.
DEFINE VARIABLE hActiveWin  AS HANDLE    NO-UNDO.
DEFINE VARIABLE ldummy      AS LOGICAL   NO-UNDO.
DEFINE VARIABLE returnValue AS CHARACTER NO-UNDO.
DEFINE VARIABLE sectionID   AS INTEGER   NO-UNDO.
DEFINE VARIABLE sectionText AS CHARACTER NO-UNDO.

/* BEFORE-OPEN hook */
IF pMode NE "UNTITLED" AND pMode NE "IMPORT" THEN DO:
  RUN adecomm/_adeevnt.p
    ("UIB":U, "BEFORE-OPEN":U, ?, pFileName, OUTPUT ldummy).
  IF NOT ldummy THEN RETURN. /* returning FALSE cancels the open */
END.

/* Save the handle of the current window and it's visualization. */
ASSIGN hActiveWin = _h_win.

RUN adeuib/_qssuckr.p (pFileName, pTempFile, 
   (IF pMode eq "OPEN":U THEN "WINDOW":U
      ELSE IF pMode eq "UNTITLED":U THEN "WINDOW UNTITLED":U
      ELSE pMode), FALSE).

SESSION:SET-NUMERIC-FORMAT(_numeric_separator,_numeric_decimal).
ASSIGN returnValue            = RETURN-VALUE.
IF returnValue = "_ABORT":U THEN DO:
  RUN choose-pointer IN _h_uib.
  RUN display_current IN _h_uib.
  RETURN.
END. /* If return value is abort */

FIND _P WHERE _P._WINDOW-HANDLE = _h_win NO-ERROR.

/* Save the broker URL that was used to open the file for existing files
   only, not for new files. If the file was opened from the MRU file list, 
   store that broker url rather than the current broker url. */
IF AVAILABLE _P AND pTempFile NE "" AND _P._save-as-file <> ?
   AND NOT _P.design_ryobject THEN   /* jep-icf: No broker_url for repository objects. */
DO:
  ASSIGN
    _P._Broker-URL = (IF _mru_broker_url NE "" THEN _mru_broker_url ELSE _BrokerURL)
    cHostName      = DYNAMIC-FUNCTION("get-url-host":U IN _h_func_lib, FALSE,
                                      _P._Broker-URL)
    _h_win:TITLE   = _h_win:TITLE + 
                     (IF INDEX(_h_win:TITLE, cHostName) EQ 0 
                      THEN cHostName ELSE "").
END.

/* In case of _qssuckr failure, reset the cursors */
RUN adecomm/_setcurs.p ("":U).

IF pMode ne "IMPORT" AND VALID-HANDLE(_h_win) THEN DO:

  /* Add this window to the Window menu's active windows. The
     check for returnValue prevents the same window from appearing
     twice on the Window menu (fix to bug 95-08-07-057).
  */
  IF NOT returnValue BEGINS "_REOPEN":U THEN DO:
    /* Tell the UIB to display the window as the current widget. 
       Note we need to set _h_cur_widg to UNKNOWN otherwise 
       changewidg won't fire if _h_win = _h_cur_widg. (as for
       example, in the case of an empty window.) */
    ASSIGN _h_cur_widg = ?.
    RUN changewidg IN _h_UIB (_h_win, TRUE). /* Deselect others */
    
    /* Open Section Editor for non-.w files (.p and .i files). */
    IF (_P._FILE-TYPE <> "w":U) THEN 
      RUN call_sew IN _h_UIB (INPUT "SE_OPEN":U ).
    
    ASSIGN hActiveWin = (IF _h_win:TYPE = "WINDOW":U
                         THEN _h_win ELSE _h_win:PARENT).
    /* Note the menu was already updated if the visualization was changed */
    IF VALID-HANDLE(_h_WinMenuMgr) THEN
      RUN WinMenuAddItem IN _h_WinMenuMgr 
        (_h_WindowMenu, hActiveWin:TITLE, _h_uib ).
  END.		   
  ELSE IF returnValue BEGINS "_REOPEN":U THEN DO:
    /* Update the current active window and checked Window menu. 
       Corrects bug 95-08-16-067. */
    ASSIGN hActiveWin = WIDGET-HANDLE(ENTRY(2, returnValue)) NO-ERROR.
    RUN WinMenuChoose IN _h_UIB (hActiveWin:TITLE).
  END.

END.

/* _open-w.p - end of file */
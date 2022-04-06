/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
* _minit
*
*    The Menu System's bootup function.
*
*  Input Parameters
*
*    menuFile     The file to read/write the menu information.
*    resetFunc    The callback that will create/reset the menu
*                 structure if there is no menu file.
*    menuBar      The menu bar object that the menuitems are attached to.
*    toolBar      The object for the toolbar
*    statusArea   A status area. See adecomm/_status.p for more info.
*/

{ adecomm/_mtemp.i }
{ adeshar/_mnudefs.i}

DEFINE INPUT  PARAMETER appId        AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER userName     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER menuFile     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER sensFunc     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER resetFunc    AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER secureFunc   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER MENUBAR      AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER toolBar      AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER statusArea   AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER prvHandle    AS HANDLE    NO-UNDO.
DEFINE INPUT  PARAMETER prvData      AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER dispMessages AS LOGICAL   NO-UNDO.
DEFINE OUTPUT PARAMETER qbf-s        AS LOGICAL   NO-UNDO INITIAL FALSE.

DEFINE VARIABLE foundFile AS CHARACTER NO-UNDO.
DEFINE VARIABLE tryIt     AS LOGICAL   NO-UNDO INITIAL TRUE.

/* Register the new information of the application.  */
FIND FIRST mnuApp WHERE mnuApp.appId = appId NO-ERROR.
IF NOT AVAILABLE mnuApp THEN RETURN.

ASSIGN
  mnuApp.sensFunction    = sensFunc
  mnuApp.secureFunction  = secureFunc
  mnuApp.menubar         = MENUBAR
  mnuApp.toolbar         = toolBar
  mnuApp.statusArea      = statusArea
  mnuApp.displayMessages = dispMessages
  qbf-s                  = TRUE
  .

/* Check to see if the current user can use all of the functions */
RUN adeshar/_msecure.p(appId, userName, OUTPUT qbf-s).

/*
* Read the supplied menu file, if there is one. If not, have the client
* set up the information
*/
IF (menuFile <> ?) AND (menuFile <> "") THEN DO:
  runMenu:
  DO ON STOP UNDO runMenu, RETRY runMenu:
    IF RETRY THEN DO:
      MESSAGE "There is a problem with " menuFile "." SKIP
        "The default menu and toolbar layout will be used." SKIP
        VIEW-AS ALERT-BOX.
      LEAVE runMenu.
    END.

    RUN VALUE(menuFile)(appId, TRUE).
    tryIt = FALSE.
  END.
END.

IF tryIt = TRUE THEN DO:
  IF resetFunc <> "" THEN
    RUN VALUE(resetFunc) (appId,TRUE).
  ELSE DO:
    MESSAGE "Unable to find default menu and toolbar layout."
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN.
  END.
END.

/*
* Give the application a chance to inform us on the sensitivity
* of the items in the menu bar and in the menus
*/
RUN adeshar/_mcheckm.p (appId, OUTPUT qbf-s).
RUN adeshar/_machk.p (appId, OUTPUT qbf-s).

/* _minit.p - end of file */


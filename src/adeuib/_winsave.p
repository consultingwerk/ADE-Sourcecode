/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
{adeuib/uniwidg.i}

DEFINE INPUT PARAMETER whipWindowToSave AS WIDGET-HANDLE.
DEFINE INPUT PARAMETER lipValue AS LOGICAL.

DEFINE NEW GLOBAL SHARED VAR OEIDEIsRunning AS LOGICAL    NO-UNDO.

IF whipWindowToSave EQ ? OR lipValue EQ ? THEN RETURN.
FIND _P WHERE _P._WINDOW-HANDLE = whipWindowToSave NO-ERROR.
IF AVAILABLE _P
THEN 
DO:
    ASSIGN _P._FILE-SAVED = lipValue.
    IF OEIDEIsRunning AND VALID-HANDLE(_P._hSecEd) THEN
        RUN winsave IN _P._hSecEd (whipWindowToSave, lipValue) NO-ERROR.    
END.
ELSE MESSAGE "adeuib/_winsave.p: Window not found."
             VIEW-AS ALERT-BOX ERROR BUTTONS OK.

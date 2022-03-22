/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/**************************************************************************
    Procedure:  _ppuscl.p

    Purpose:    Checks to see if the UIB is running and if it is
                it launches adeuib/_ppuscal.w.

    Parameters: None

    Description:
    Notes  :
    Authors: Ross Hunter
    Date   : Feb. 10, 1997
**************************************************************************/

DEFINE VARIABLE level          AS INTEGER NO-UNDO INITIAL 1. 
DEFINE VARIABLE uib_is_running AS LOGICAL NO-UNDO INITIAL NO.

REPEAT WHILE PROGRAM-NAME(level) <> ?.
  IF PROGRAM-NAME(level) = "adeuib/_uibmain.p" THEN uib_is_running = TRUE.
  ASSIGN level = level + 1.
END.
IF NOT uib_is_running THEN DO:
  MESSAGE
    "The AppBuilder is not running." SKIP "You must start the AppBuilder before running the Screen Scaling Utility."
    VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.
ELSE
  RUN adeuib/_ppuscal.w PERSISTENT.

RETURN.

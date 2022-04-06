/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * _aerror.i
 *
 *   This insert decides if there are any system error and writes
 *   out any error messages.
 *
 *  Input
 *
 *    loopVar   An integer variable.
 *    message   The message to display.
 */

IF ERROR-STATUS:ERROR = TRUE AND ERROR-STATUS:NUM-MESSAGES > 0 THEN DO:

  MESSAGE "{&msg}" VIEW-AS ALERT-BOX.

  DO {&i} = 1 TO ERROR-STATUS:NUM-MESSAGES:
    MESSAGE ERROR-STATUS:GET-NUMBER({&i}) ERROR-STATUS:GET-MESSAGE({&i})
      VIEW-AS ALERT-BOX.
  END. 
END.

/* _aerror.i - end of file */


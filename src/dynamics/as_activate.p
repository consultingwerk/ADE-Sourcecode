/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* as_activate.p */

/* pull in Astra global variables as new global */
{src/adm2/globals.i}

/* This call to storeAppServerInfo results in all the properties being
   set to unknown. */
RUN storeAppServerInfo IN gshSessionManager
  (INPUT "":U).


RUN establishSession IN gshSessionManager 
  (INPUT YES,  /* Are we activating an already existing session */
   INPUT NO)   /* Should we check inactivity timeouts */
  NO-ERROR.
IF ERROR-STATUS:ERROR OR
   (RETURN-VALUE <> "":U AND
    RETURN-VALUE <> ?) THEN
DO:
  MESSAGE "UNABLE TO ACTIVATE SESSION. ":U + RETURN-VALUE.
  RETURN ERROR RETURN-VALUE.
END.


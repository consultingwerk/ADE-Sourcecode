/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* brschnge.i - trigger code for VALUE-CHANGED trigger of SmartBrowse */
RUN get-attribute('ADM-NEW-RECORD':U). /* If this is triggered by initial*/
IF RETURN-VALUE NE "YES":U THEN        /*  values in an Add, ignore it. */
  RUN notify ('row-available':U).

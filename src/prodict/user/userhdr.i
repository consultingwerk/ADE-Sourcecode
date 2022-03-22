/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/


&IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
  ASSIGN
    user_hdr = {1}.
  DISPLAY user_hdr WITH FRAME user_hdr.
&ENDIF

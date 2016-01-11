/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* This file should be included in all UIB dialog-boxes in order to achieve */
/* a modicum of common code and behavior                                    */

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF

PAUSE 0 BEFORE-HIDE.

/* WINDOW-CLOSE event will issue END-ERROR to the frame, if defined */
&IF DEFINED(FRAME_CLOSE) NE 0 &THEN
ON WINDOW-CLOSE OF FRAME {&FRAME_CLOSE} APPLY "END-ERROR":U TO SELF.
&ENDIF

/*********************************************************************
* Copyright (C) 2000-2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/**************************************************************
   Procedure: adewrap.i
    Function: Provide a runtime context sensitive entry point
              to the ADE Tools.
      Author: John Harris

***************************************************************
 *************************************************************/

/*
** Parameters:	&TTY	  TTY Procedure
**		&MOTIF	  OSF/Motif (GUI) Procedure
**		&MSWIN	  MS-Windows Procedure
**              &SETCURS  Cursor to set (use adecomm/_setcurs.p ("{&SETCURS}")
**                        the assumption is that the calling routine will
**                        reset it.  [Just used in MOTIF and MSWIN.]
*/

/* ADE Standards Include. */
{ adecomm/adestds.i}

/* If this is WebSpeed, exit */
IF SESSION:CLIENT-TYPE = "WEBSPEED" THEN RETURN ERROR.

/* This is done only once at startup of the ade.  This code runs and  
   loads up the colors and fonts
*/
IF NOT initialized_adestds THEN
  RUN adecomm/_adeload.p.

/* if started from the operating system, prompt for login ids */
IF PROGRAM-NAME(2) = ? AND "{&PRODUCT}" <> "RESULTS" THEN DO:
  RUN _prostar.p.

END.

IF SESSION:WINDOW-SYSTEM = "TTY" AND '{&TTY}' <> "" THEN
  RUN value("{&TTY}") .
ELSE IF (SESSION:WINDOW-SYSTEM = "OSF/Motif" AND '{&MOTIF}' <> "") OR
        (SESSION:WINDOW-SYSTEM BEGINS "MS-WIN" AND '{&MSWIN}' <> "") THEN
  /* There are two cases:
     1) where we want to surround the run with SETCURS (&SETCURS = WAIT)
     2) where we do not.   */
  &IF "{&SETCURS}" eq "" &THEN
    IF SESSION:WINDOW-SYSTEM = "OSF/Motif" 
    THEN RUN value("{&MOTIF}") .
    ELSE RUN value("{&MSWIN}") .
  &ELSE
    DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
      IF NOT RETRY THEN DO:
        RUN adecomm/_setcurs.p ("{&SETCURS}").
        IF SESSION:WINDOW-SYSTEM = "OSF/Motif" 
        THEN RUN value("{&MOTIF}") .
        ELSE RUN value("{&MSWIN}") .
      END.
      /* Restore the cursor */
      RUN adecomm/_setcurs.p ("").
    END.
  &ENDIF
ELSE DO:
  DEFINE VARIABLE t_log AS LOGICAL NO-UNDO.

  RUN adecomm/_s-alert.p (INPUT-OUTPUT t_log, "i", "ok",
    SUBSTITUTE("This application does not run in &1 environments.",
    SESSION:WINDOW-SYSTEM)).
END.

IF RETURN-VALUE = "RETURN" THEN
  RETURN.

IF PROGRAM-NAME(2) = ? THEN
  QUIT.
ELSE
  RETURN.

/* adewrap.i - end of file */


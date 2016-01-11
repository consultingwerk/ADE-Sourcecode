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


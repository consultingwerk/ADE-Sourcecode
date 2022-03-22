/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _ab.p

Description:
   this is the startup program for the AB (AppBuilder) .

Input/Output Parameters:
   
Author: Ross Hunter

Date Created: 04/01/98

----------------------------------------------------------------------------*/

DEFINE VAR window_list AS CHAR NO-UNDO.

/* ADE Standards Include. */
{ adecomm/adestds.i }

/* This is done only once at startup of the ade.  This code runs and
   loads up the colors and fonts
*/
IF NOT initialized_adestds THEN
    run adecomm/_adeload.p.

/* if started from the operating system, prompt for login ids */
IF PROGRAM-NAME(2) = ? THEN
    RUN _prostar.p.

IF PROGRAM-NAME(2)   =  ?  AND
   SESSION:PARAMETER <> ?  AND 
   SESSION:PARAMETER <> "" THEN
       window_list = SESSION:PARAMETER.

IF CAN-DO ("OSF/Motif,MS-WINDOWS,MS-WIN95,MS-WINXP", SESSION:WINDOW-SYSTEM) 
THEN DO:
    /* Add a STOP block, to catch user STOPS and restore the cursor */
    DO ON STOP UNDO, RETRY ON ERROR UNDO, RETRY ON ENDKEY UNDO, RETRY:
        IF NOT RETRY THEN DO:
	   RUN adecomm/_setcurs.p ("WAIT").
           RUN adeuib/_uibmain.p (INPUT window_list) .
	END.
        RUN adecomm/_setcurs.p ("").
    END.
END.
ELSE DO:
    DEFINE VARIABLE t_log AS LOGICAL NO-UNDO.

    run adecomm/_s-alert.p (
        INPUT-OUTPUT t_log,
        "i",
        "ok",
        "The {&UIB_NAME}" + 
         " does not run in " + SESSION:WINDOW-SYSTEM + " environments.").
END.

IF PROGRAM-NAME(2) = ? THEN
    QUIT.
ELSE
    RETURN.


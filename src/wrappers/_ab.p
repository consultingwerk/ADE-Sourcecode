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

IF CAN-DO ("OSF/Motif,MS-WINDOWS,MS-WIN95", SESSION:WINDOW-SYSTEM) 
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


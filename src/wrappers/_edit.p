/*************************************************************************
* Copyright (C) 1984 - 2007 by Progress Software Corporation. All rights *
* reserved. Prior versions of this work may contain portions             *
* contributed by participants of Possenet.                               *
*                                                                        *
*************************************************************************/
/*****************************************************************************

Procedure: _edit.p

Syntax:
        RUN _edit.p.

Purpose:          
    Start-up processing module which runs editor engine module.

Description:
    Passes the os files to open. 

Parameters: NONE.

Author: John Palazzo

Date Created: 08.06.92 

*****************************************************************************/

DEFINE VARIABLE File_List       AS CHAR NO-UNDO.
DEFINE VARIABLE Obj_IDList      AS CHAR NO-UNDO.

/* ADE Standards Include. */
{ adecomm/adestds.i }

/* If this is WebSpeed, exit */
IF SESSION:CLIENT-TYPE = "WEBSPEED" THEN RETURN ERROR.

/* This is done only once at startup of the ade.  This code runs and
   loads up the colors and fonts.
*/
IF NOT initialized_adestds THEN
    run adecomm/_adeload.p.

IF PROGRAM-NAME(2)   =  ?  AND
   SESSION:PARAMETER <> ?  AND 
   SESSION:PARAMETER <> "" THEN
    File_List = SESSION:PARAMETER.

/* If started from the operating system, prompt for login ids. */
IF PROGRAM-NAME(2) = ? THEN
    RUN _prostar.p.

STOP_BLOCK:
DO ON STOP UNDO STOP_BLOCK, RETRY STOP_BLOCK 
   ON ENDKEY UNDO STOP_BLOCK, RETRY STOP_BLOCK 
   ON ERROR UNDO STOP_BLOCK, RETRY STOP_BLOCK :
     IF NOT RETRY THEN DO:
       RUN adecomm/_setcurs.p ("WAIT").
       /*---------------------------------------------------------------------
       Run PROGRESS Editor engine with list of files to open for editing.
       Using this routine, the list of files and ade object id's are null.
       ---------------------------------------------------------------------*/
       RUN adeedit/_proedit.p (INPUT File_List, INPUT Obj_IDList).
     END.
     /* Restore the cursor */
     RUN adecomm/_setcurs.p ("").
     /* Give user chance to read any start-up errors. */
     IF RETRY THEN PAUSE. 
END.  /* STOP_BLOCK */
 
IF PROGRAM-NAME(2) = ? THEN 
    QUIT.
ELSE 
    RETURN.

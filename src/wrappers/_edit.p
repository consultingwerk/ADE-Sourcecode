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

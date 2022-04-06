/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*****************************************************************************

Procedure: _pwin.p

Syntax:
        RUN _pwin.p.

Purpose:          
    Start-up procedure which runs Procedure Window sub-procedure module.

Description:
    - Passes the os files to open based on SESSION:PARAMETER.
    
Parameters: NONE.

Author: John Palazzo

Date Created: January, 1994

*****************************************************************************/

DEFINE VARIABLE File_List    AS CHARACTER     NO-UNDO.
  /* Files editor should open automatically on start-up. */

/* ADE Standards Include. */
{ adecomm/adestds.i }

/* This is done only once at startup of the ade.  This code runs and
   loads up the colors and fonts.
*/
IF NOT initialized_adestds THEN
    run adecomm/_adeload.p.

/* If started from OS (i.e., this is the -p startup procedure), use the
   value of SESSION:PARAMETER as the list of files to open.
*/
IF PROGRAM-NAME(2)   =  ?  AND
   SESSION:PARAMETER <> ?  AND 
   SESSION:PARAMETER <> "" THEN
    File_List = SESSION:PARAMETER.

STOP_BLOCK:
DO ON STOP UNDO STOP_BLOCK, RETRY STOP_BLOCK 
   ON ENDKEY UNDO STOP_BLOCK, RETRY STOP_BLOCK 
   ON ERROR UNDO STOP_BLOCK, RETRY STOP_BLOCK :
     IF NOT RETRY THEN DO:
       RUN adecomm/_setcurs.p ("WAIT").
       /*---------------------------------------------------------------------
          Run Procedure window sub-procedure with list of files to open for
          editing.
       ---------------------------------------------------------------------*/
       RUN adecomm/_pwmain.p (INPUT ""        /* PW Parent ID   */ ,
                            INPUT File_List /* Files to open  */ ,
                            INPUT ""        /* PW Command     */ ).
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

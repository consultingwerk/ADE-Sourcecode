/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _cr_xftr.p

Description:
   Loads user xftrs from the xftr file.

Input Parameters:
   <None>
   
Output Parameters:
   rc (logical) - return code y/n
   
Author:  Gerry Seidl

Date Created: September 29, 1994 

----------------------------------------------------------------------------*/
{ adeuib/sharvars.i }
{ adeuib/xftr.i }

DEFINE OUTPUT PARAMETER rc AS LOGICAL NO-UNDO. /* return code */

DEFINE STREAM In_Stream.

DO ON STOP  UNDO, RETRY
   ON ERROR UNDO, RETRY:
   
   IF NOT RETRY THEN DO:
        /* Does the file exist? */
        ASSIGN FILE-INFO:FILE-NAME = {&XFTR-FILE} NO-ERROR.
        IF ( FILE-INFO:FULL-PATHNAME NE ? ) THEN DO:
            ASSIGN rc = yes.
            INPUT STREAM In_Stream FROM VALUE(FILE-INFO:FULL-PATHNAME) NO-ECHO.
            REPEAT TRANSACTION ON STOP UNDO, LEAVE:
                CREATE _XFTR.
                IMPORT STREAM In_Stream _XFTR.
            END.
            INPUT STREAM In_Stream CLOSE.
        END.   
        ELSE ASSIGN rc = no.
   END.   
END.

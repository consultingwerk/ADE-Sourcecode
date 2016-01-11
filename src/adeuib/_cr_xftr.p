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

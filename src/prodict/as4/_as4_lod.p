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
{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE NEW SHARED VARIABLE df-type AS CHARACTER NO-UNDO.

DEFINE VARIABLE savcurwin AS WIDGET-HANDLE. 
DEFINE VARIABLE savestate AS integer NO-UNDO.

ASSIGN df-type = user_env[33]
       savcurwin = CURRENT-WINDOW
       savestate = CURRENT-WINDOW:WINDOW-STATE.

RUN as4dict/load/_as4_lod.p.

ASSIGN CURRENT-WINDOW = savcurwin
       CURRENT-WINDOW:WINDOW-STATE = savestate.   

RUN adecomm/_setcurs.p ("").   

ASSIGN user_env[33] = "".

RETURN.

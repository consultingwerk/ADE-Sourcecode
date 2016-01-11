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
/*
* u-define.p -
*
* This function can set up the shared information needed by the application.
*
* This file must accept as an argument the function that runs Results.
*
* This program can be used to defined shared variables that are needed
* for user extensions to RESULTS.  The input parameter is the main
* RESULTS program.  Proper use of this program is to place the DEFINEs
* before the RUN VALUE(funcName), then do the RUN, then place any shut-down
* code.  The RETURN returns to the outer most RESULTS procedures which
* clean up temporary files.
*
*/

DEFINE INPUT PARAMETER functionName AS CHARACTER NO-UNDO.

/*
* Your definitions goes here
*/

/*
* The following line is required!
*/

RUN VALUE(functionName).

RETURN.

/* u-define.p - end of file */


/*********************************************************************
* Copyright (C) 2001 by Progress Software Corporation ("PSC"),       *
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
*  Per S Digre (pdigre@progress.com)                                 *
*                                                                    *
*********************************************************************/
/*--------------------------------------------------------------------
 File:    webutil/session.i
 Purpose: Include for the session module
 Updated: 04/04/98 pdigre@progress.com
            Initial version
          04/26/01 adams@progress.com
            WebSpeed integration
          05/23/01 mbaker@progress.com
            Dynamics integration
---------------------------------------------------------------------*/

&IF DEFINED(session-included) = 0 &THEN
&GLOBAL-DEFINE session-included YES

DEFINE NEW GLOBAL SHARED VARIABLE gscSessionId AS CHARACTER NO-UNDO.

FUNCTION setSession RETURNS LOGICAL
  ( cName AS CHARACTER, cValue AS CHARACTER) {&FORWARD}.
FUNCTION getSession RETURNS CHARACTER 
  ( cName AS CHARACTER) {&FORWARD}.
FUNCTION setGlobal RETURNS LOGICAL 
  ( cName AS CHARACTER, cValue AS CHARACTER) {&FORWARD}.
FUNCTION getGlobal RETURNS CHARACTER 
  ( cName AS CHARACTER) {&FORWARD}.
FUNCTION logNote RETURNS LOGICAL 
  ( pcLogType AS CHARACTER, pcLogText AS CHARACTER ) {&FORWARD}.

&ENDIF

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
/* adecomm/appserv.i checks to see if the persistent procedure adecomm/as-utils.w
                     has been started up, and if not, it starts it and then makes
                     is a SUPER procedure of the calling procedure.
                     
   Created: 11/26/97 by Ross Hunter
                                                                                 */

&IF DEFINED(APP-SERVER-VARS) = 0 &THEN
&GLOBAL-DEFINE APP-SERVER-VARS yes
DEFINE NEW GLOBAL SHARED VARIABLE appSrvUtils AS HANDLE                NO-UNDO.
&ENDIF

IF NOT VALID-HANDLE(appSrvUtils) THEN
  RUN adecomm/as-utils.w PERSISTENT SET appSrvUtils.

THIS-PROCEDURE:ADD-SUPER-PROCEDURE(appSrvUtils).



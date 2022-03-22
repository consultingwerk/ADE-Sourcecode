/*********************************************************************
* Copyright (C) 2005 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet.                           *
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



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
/* as_activate.p */

/* pull in Astra global variables as new global */
{adm2/globals.i}

/* This call to storeAppServerInfo results in all the properties being
   set to unknown. */
RUN storeAppServerInfo IN gshSessionManager
  (INPUT "":U).


RUN establishSession IN gshSessionManager 
  (INPUT YES,  /* Are we activating an already existing session */
   INPUT NO)   /* Should we check inactivity timeouts */
  NO-ERROR.
IF ERROR-STATUS:ERROR OR
   (RETURN-VALUE <> "":U AND
    RETURN-VALUE <> ?) THEN
DO:
  MESSAGE "UNABLE TO ACTIVATE SESSION. ":U + RETURN-VALUE.
  RETURN ERROR RETURN-VALUE.
END.


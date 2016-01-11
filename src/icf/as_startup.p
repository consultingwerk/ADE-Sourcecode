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
/* asstartup.p */
DEFINE INPUT PARAMETER cStartupData       AS CHARACTER NO-UNDO.

/* pull in old Astra 1 global variables so triggers function until code
   is removed from them that uses these variables
*/
{af/sup/afghplipdf.i NEW GLOBAL}

/* pull in Astra global variables as new global */
{af/sup2/afglobals.i NEW GLOBAL}

DEFINE VARIABLE hProc AS HANDLE     NO-UNDO.
DEFINE VARIABLE cProc AS CHARACTER  NO-UNDO.

cProc = SEARCH("af/app/afxmlcfgp.r").

IF cProc = ? THEN
  cProc = SEARCH("af/app/afxmlcfgp.p").

IF cProc = ? THEN
DO:
  RUN ICFCFM_InitializedServices.
END.
ELSE
DO:
  RUN VALUE(cProc) PERSISTENT SET hProc.

  RUN subscribeAll IN THIS-PROCEDURE (hProc, THIS-PROCEDURE).
  
  RUN initializeSession IN THIS-PROCEDURE ("":U) NO-ERROR.
  IF RETURN-VALUE <> "" THEN
  DO:
    MESSAGE {&line-number} PROGRAM-NAME(1) SKIP
        RETURN-VALUE.
    QUIT.
  END.

END.


/* prestart the data-related ADM2 super procedures */
/* no need to keep the handles as they can die on Appserver Agent shutdown */

RUN adm2/smart.p                PERSISTENT.
RUN adm2/query.p                PERSISTENT.
RUN adm2/data.p                 PERSISTENT.
RUN adm2/dataext.p              PERSISTENT.

PROCEDURE ICFCFM_InitializedServices:
  
  IF CONNECTED("ICFDB":U) THEN
  DO:
    CREATE ALIAS AFDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS ASDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS RYDB           FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS db_metaschema  FOR DATABASE VALUE("ICFDB":U).
    CREATE ALIAS db_index       FOR DATABASE VALUE("ICFDB":U).
  END.

END PROCEDURE.


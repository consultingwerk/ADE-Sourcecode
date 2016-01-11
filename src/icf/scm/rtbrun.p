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
/* Roundtable program launch */

DEFINE INPUT PARAMETER  ip_program_name     AS CHARACTER    NO-UNDO.

DEFINE VARIABLE         lv_program_handle   AS HANDLE       NO-UNDO.

IF INDEX(ip_program_name, ".ado":U) <> 0 THEN
DO:
  /* Run logical object */
  DEFINE VARIABLE iPosn                   AS INTEGER    NO-UNDO.
  ASSIGN iPosn = R-INDEX(ip_program_name,"/":U) + 1.
  IF iPosn = 1 THEN
      ASSIGN iPosn = R-INDEX(ip_program_name,"~\":U) + 1.
  ASSIGN
    ip_program_name = TRIM(LC(SUBSTRING(ip_program_name,iPosn)))
    ip_program_name = REPLACE(ip_program_name,".ado":U,"":U)
    .
  RUN ry/prc/rycsolnchp.p (INPUT ip_program_name).
END.
ELSE
  RUN-BLOCK:
  DO ON STOP UNDO RUN-BLOCK, LEAVE RUN-BLOCK ON ERROR UNDO RUN-BLOCK, LEAVE RUN-BLOCK:
    IF SESSION:SET-WAIT-STATE('general':U) THEN PROCESS EVENTS.
    RUN VALUE(ip_program_name) PERSISTENT SET lv_program_handle.
  END.
IF SESSION:SET-WAIT-STATE('':U) THEN PROCESS EVENTS.

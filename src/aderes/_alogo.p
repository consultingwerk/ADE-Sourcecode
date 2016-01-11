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
* _alogo.p
*
*    Runs the logo program. This file exists to provide a on-error
*    block. This function is called from fastload as well as
*    configuration read.
*/

{ aderes/s-system.i }

DEFINE VARIABLE qbf-c AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO. /* scrap */

IF qbf-u-hook[{&ahLogo}] <> ? THEN DO:
  RUN aderes/_ssearch.p (qbf-u-hook[{&ahLogo}], OUTPUT qbf-c).

  IF qbf-c = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
      SUBSTITUTE("The procedure for Admin Logo Hook, '&1', was not found. The logo procedure cannot be run.",
      qbf-u-hook[{&ahLogo}])).

  ELSE DO:
    logoHook:
    DO ON STOP UNDO logoHook, RETRY logoHook:
      IF RETRY THEN DO:
        RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,
          SUBSTITUTE("There is a problem with &1.  The logo procedure cannot be run.",qbf-c)).

        LEAVE logoHook.
      END.

      /* Run the logo program */
      RUN adecomm/_setcurs.p ("WAIT":u).
      RUN VALUE(qbf-u-hook[{&ahLogo}]).
    END.
  END.
END.

/* _alogo.p - end of file */


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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


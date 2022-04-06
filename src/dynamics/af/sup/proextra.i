/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* ====================================================================
   file      proextra.i
   by        Jurjen Dijkstra, 1997
             mailto:jurjen.dijkstra@wxs.nl
             http://www.pugcentral.org/api
   language  Progress 8.2A
   purpose   "uses proextra"
   ==================================================================== */
&IF DEFINED(PROEXTRA_I)=0 &THEN
&GLOBAL-DEFINE PROEXTRA_I

def new global shared var hpExtra as handle no-undo.
if not valid-handle(hpExtra) then run af/sup/proextra.p persistent set hpExtra.

&ENDIF  /* &IF DEFINED(PROEXTRA_I)=0 */


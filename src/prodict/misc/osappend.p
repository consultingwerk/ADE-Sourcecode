/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* This routine appends <appe> to the end of <base>. */

DEFINE INPUT PARAMETER appe AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER base AS CHARACTER NO-UNDO.

IF CAN-DO("MSDOS,WIN32",OPSYS) THEN
  DOS SILENT type VALUE(appe) >> VALUE(base).

ELSE IF OPSYS = "UNIX" THEN
  UNIX SILENT cat VALUE(appe) >> VALUE(base).

ELSE MESSAGE "osappend.p: Unknown Operating System -" OPSYS.

RETURN.

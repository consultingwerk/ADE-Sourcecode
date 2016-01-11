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

/* This routine appends <appe> to the end of <base>. */

DEFINE INPUT PARAMETER appe AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER base AS CHARACTER NO-UNDO.

IF CAN-DO("MSDOS,WIN32",OPSYS) THEN
  DOS SILENT type VALUE(appe) >> VALUE(base).

ELSE IF OPSYS = "UNIX" THEN
  UNIX SILENT cat VALUE(appe) >> VALUE(base).

ELSE MESSAGE "osappend.p: Unknown Operating System -" OPSYS.

RETURN.

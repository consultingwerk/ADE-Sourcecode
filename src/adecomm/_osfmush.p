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
**  Program: adecomm/_osfmush.p
**       By: wlb
** Descript: mush to parts of a file spec together
** Last change: jep 12/14/95 - WIN95-LFN
**              Added WIN32 to OPSYS test as part of temporary support.
*/

DEFINE INPUT  PARAMETER p_spec1   AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER p_spec2   AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_outspec AS CHARACTER NO-UNDO.

/* if both parms are NOT set then just put results in outspec */
IF p_spec1 = "" OR p_spec2 = "" THEN
p_outspec = p_spec1 + p_spec2.

ELSE  /* add a backslash between files for DOS */
IF CAN-DO("WIN32,MSDOS", OPSYS) AND NOT
  (p_spec1 MATCHES "*:" OR
  p_spec1 MATCHES "*~~~\" OR p_spec2 matches "~~~\*" OR
  p_spec1 MATCHES "*/" OR p_spec2 matches "/*") THEN
p_outspec = p_spec1 + "~\" + p_spec2.

ELSE  /* add a slash between files for DOS */
IF OPSYS = "UNIX" AND NOT(p_spec1 MATCHES "*/" OR p_spec2 matches "/*") THEN
p_outspec = p_spec1 + "/" + p_spec2.

/*
**  All of the above IFs checked for special cases where we could NOT
**  just concatinate the parms together.  Once we get to here, we know
**  that we CAN just concatinate them together.
*/
ELSE
p_outspec = p_spec1 + p_spec2.

/* Trim off a trailing \ or / as long as it does not follow a drive indicator */
IF NOT CAN-DO("WIN32,MSDOS":u, OPSYS) OR
  (NOT p_outspec MATCHES "*:/":u AND NOT p_outspec MATCHES "*:~~~\":u) THEN
  p_outspec = RIGHT-TRIM(p_outspec,"/~\":u).

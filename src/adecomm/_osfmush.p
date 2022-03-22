/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

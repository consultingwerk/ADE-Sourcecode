/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*----------------------------------------------------------------------------

File: _filter6.p

Description:
   This procedure is used against Progress V6 DICTDB (or earlier).
   The input is a RECID of a _FILE record and a filter string.  The
   output is YES or NO depending on whether the _FILE._FLD-MISC2[8]
   fields is in the filter string or not.
   (Note: _filter7.p is for DB's 7 or greater.)

Input Parameters:
   p_recid  - Recid of _FILE record
   p_filter - Comma delimited list of types to be filtered
             
Output Parameters:
   p_in     - Set to true if _FILE._FIL-MISC2[8] is in p_filter string.

Author: Ross Hunter

Date Created: 06/15/92 

----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_recid   AS RECID           NO-UNDO.
DEFINE INPUT  PARAMETER p_filter  AS CHARACTER       NO-UNDO.
DEFINE OUTPUT PARAMETER p_in      AS LOGICAL         NO-UNDO.

FIND DICTDB._FILE WHERE RECID(DICTDB._FILE) = p_recid NO-LOCK.
p_in = CAN-DO(p_filter,DICTDB._FILE._FIL-MISC2[8]).

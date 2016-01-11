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

/*----------------------------------------------------------------------------

File: _filter7.p

Description:
   This procedure is used against Progress V7 DICTDB (or later).
   The input is a RECID of a _FILE record and a filter string.  The
   output is YES or NO depending on whether the _FILE._FOR-TYPE
   field is in the filter string or not.
   (Note: _filter6.p is for DB's 6 or earlier.)

Input Parameters:
   p_recid  - Recid of _FILE record
   p_filter - Comma delimited list of types to be filtered
             
Output Parameters:
   p_in     - Set to true if _FILE._FLD-MISC2[8] is in p_filter string.

Author: Ross Hunter

Date Created: 06/15/92 

----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_recid   AS RECID           NO-UNDO.
DEFINE INPUT  PARAMETER p_filter  AS CHARACTER       NO-UNDO.
DEFINE OUTPUT PARAMETER p_in      AS LOGICAL         NO-UNDO.

FIND DICTDB._FILE WHERE RECID(DICTDB._FILE) = p_recid NO-LOCK.
p_in = CAN-DO(p_filter,DICTDB._FILE._FOR-TYPE).

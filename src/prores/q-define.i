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
/* q-define.i - local definitions for query module */

DEFINE {1} SHARED VARIABLE qbf-brow  AS CHARACTER EXTENT 5 INITIAL "" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-index AS CHARACTER EXTENT 5 INITIAL "" NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-level AS INTEGER            INITIAL  1 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-query AS LOGICAL   EXTENT 5 INITIAL  ? NO-UNDO.

/*
  qbf-brow[n]  = browse fields
  qbf-index[n] = use-index index name
  qbf-level    = depth of query ([n] in these variables)
  qbf-query[n] = ?     for no Where or Query clause
               = TRUE  for a Query
               = FALSE for a Where
*/

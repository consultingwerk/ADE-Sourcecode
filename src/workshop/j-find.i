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
 * j-find.i - variable defines for j-find*.p
 */

DEFINE {1} SHARED VARIABLE qbf-est     AS INTEGER   NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-fields  AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-nt      AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pro-dbs AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-purge   AS CHARACTER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-same    AS RECID     NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-subset  AS CHARACTER NO-UNDO.

/*
qbf-est     generous estimate of number of joins found so far.

qbf-fields  fields upon which OF-join is based.

qbf-same    is RECID of current _file being examined.

qbf-nt      is the name and type of each component of the current index.

qbf-pro-dbs is a list of all connected PROGRESS databases.

qbf-purge   holds file references for which there were multiple indexes
	    that would make index selection for OF ambiguous.  These are
	    saved and then purged en masse from the join table.

qbf-subset is the list of joins for the current file.  it is a
        comma-sep list with each entry preceded by the join code:
           '=' for 1:1
           '<' for 1:M
           '>' for M:1
           '*' for M:M
           '?' means unsure, and should be treated as M:M

This algorithm will only return 1:1 or 1:M, and "flipping" For
symmetric joins will produce M:1.  M:M is used for user-entered join
information, and '?' means the join has not yet been converted into one
of the other types (which should only be during V6->V7 conversion).

All of this information eventually winds up in the relationship table.

The basic ideas for finding the E-R stuff are based on the following 12
cases, where the four marked with asterisks are the joins that this
program finds:

  Two indexes:

  a is unique, b is unique, initial components match:
  * 1:1  a and b match index components exactly
    M:1  a contains superset
  * 1:M  b contains superset
    M:M  a and b differ after first component

  a is unique, b is not-unique (or no index), initial components match:
  * 1:M  a and b match index components exactly
    M:M  a contains superset
  * 1:M  b contains superset
    M:M  a and b differ after first component

  a and b are not-unique (or not indexed at all), initial components match:
    M:M  a and b match index components exactly
    M:M  a contains superset
    M:M  b contains superset
    M:M  a and b differ after first component
*/

/* j-find.i - end of file */


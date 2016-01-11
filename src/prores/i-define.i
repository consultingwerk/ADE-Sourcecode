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
/* i-define.i - object directory */

/* export lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-d-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-d-hi AS INTEGER NO-UNDO.

/* graph lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-g-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-g-hi AS INTEGER NO-UNDO.

/* label lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-l-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-l-hi AS INTEGER NO-UNDO.

/* query lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-q-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-q-hi AS INTEGER NO-UNDO.

/* report lo/hi in cache */
DEFINE {1} SHARED VARIABLE qbf-r-lo AS INTEGER NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-r-hi AS INTEGER NO-UNDO.


DEFINE {1} SHARED VARIABLE qbf-dir-ent  AS CHARACTER
  EXTENT { prores/s-limdir.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-dbs  AS CHARACTER
  EXTENT { prores/s-limdir.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-flg  AS LOGICAL
  EXTENT { prores/s-limdir.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-dir-ent# AS INTEGER   INITIAL  0 NO-UNDO.

DEFINE {1} SHARED VARIABLE qbf-dir-vrs  AS CHARACTER NO-UNDO.

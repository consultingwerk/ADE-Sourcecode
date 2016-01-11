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
/* This is the definitions of temp-tables built solely to use in the
   schema pickers to deal with temp-tables in the UIB.

   Created: 11/03/96
   Author:  D. Ross Hunter                                         */

DEFINE {1} SHARED TEMP-TABLE tt-tbl NO-UNDO
       FIELD tt-name AS CHARACTER FORMAT "X(32)"
       FIELD like-db AS CHARACTER
       FIELD like-table AS CHARACTER
       FIELD table-type AS CHARACTER
       INDEX tt-name IS PRIMARY UNIQUE tt-name.
DEFINE {1} SHARED TEMP-TABLE tt-fld NO-UNDO
       FIELD tt-fld   AS CHARACTER FORMAT "X(32)"
       FIELD tt-recid AS RECID
       INDEX tt-rec-fld IS PRIMARY UNIQUE tt-recid tt-fld.

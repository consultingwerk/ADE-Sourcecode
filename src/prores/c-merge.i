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
/* c-merge.i - defines for cache list of all files in all databases */

DEFINE {1} SHARED VARIABLE qbf-schema# AS INTEGER    NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-schema% AS CHARACTER  NO-UNDO.

/*
c-merge.p returns:

  qbf-schema.cValue = "filename,dbname,0000description"

but warning!  a-join.p alters the structure of this array to be:

  qbf-schema.cValue = "filename,dbname,###,###,....."

where the ### is a list of pointers into qbf-join.cValue of join records
that contains a reference to that file.

qbf-schema% is a scalar of flags to be appended to filenames ("*" or " ")
*/

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
/* s-draw.i - show db file and where clauses */

(IF qbf-file[1] = "" THEN "" ELSE qbf-db[1] + "." + qbf-file[1]
  + (IF qbf-asked[1] BEGINS " " THEN qbf-asked[1] ELSE ""))
  @ qbf-file[1]
(IF qbf-file[2] = "" THEN "" ELSE qbf-db[2] + "." + qbf-file[2]
  + (IF qbf-asked[2] BEGINS " " THEN qbf-asked[2] ELSE ""))
  @ qbf-file[2]
(IF qbf-file[3] = "" THEN "" ELSE qbf-db[3] + "." + qbf-file[3]
  + (IF qbf-asked[3] BEGINS " " THEN qbf-asked[3] ELSE ""))
  @ qbf-file[3]
(IF qbf-file[4] = "" THEN "" ELSE qbf-db[4] + "." + qbf-file[4]
  + (IF qbf-asked[4] BEGINS " " THEN qbf-asked[4] ELSE ""))
  @ qbf-file[4]
(IF qbf-file[5] = "" THEN "" ELSE qbf-db[5] + "." + qbf-file[5]
  + (IF qbf-asked[5] BEGINS " " THEN qbf-asked[5] ELSE ""))
  @ qbf-file[5]

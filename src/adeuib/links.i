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

File: links.i

Description:
    ADM Link temp-table definition.

Input Parameters:
   <None>

Output Parameters:
   <None>

Author: Gerry Seidl

Date Created: 2/27/95

Modified:
  3/1/95  wood - Added index on link-source

----------------------------------------------------------------------------*/
/* _admlinks - ADM Links */

DEFINE {1} SHARED TEMP-TABLE _admlinks
    FIELD _P-recid     AS RECID     
    FIELD _link-source AS CHARACTER FORMAT "X(30)" COLUMN-LABEL "Source"
    FIELD _link-type   AS CHARACTER FORMAT "X(10)" COLUMN-LABEL "Link Type" 
    FIELD _link-dest   AS CHARACTER FORMAT "X(30)" COLUMN-LABEL "Target"
  INDEX _P-recid       IS PRIMARY _P-recid
  INDEX _link-source  _link-source
  .

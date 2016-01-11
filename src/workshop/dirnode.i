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
/*------------------------------------------------------------------------

  File: dirnode.i

  Description: Include file that defines shared temp-table for directory
               (or project) files.

  Input Parameters: 
      <none>

  Output Parameters:
      <none>

  Author: D.M.Adams

  Created: December 1996

------------------------------------------------------------------------*/

DEFINE {1} SHARED TEMP-TABLE dir-node
  FIELD level     AS INTEGER                  /* parent-child level */
  FIELD expanded  AS LOGICAL                  /* expanded/collapsed */
  FIELD p-recid   AS CHARACTER                /* parent char. RECID */
  FIELD file-type AS CHARACTER                /* file type */
  FIELD is-dir    AS LOGICAL                  /* directory/other */
  FIELD name      AS CHARACTER CASE-SENSITIVE /* directory/file name */
  FIELD dir-path  AS CHARACTER CASE-SENSITIVE /* directory path */
  FIELD sort-fld  AS CHARACTER                /* for alpha sorting */
  INDEX is-dir   is-dir DESCENDING name ASCENDING
  INDEX p-recid  p-recid is-dir DESCENDING name ASCENDING
  INDEX sort-fld p-recid is-dir DESCENDING sort-fld ASCENDING
  .
 
/* dirnode.i - end of file */

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

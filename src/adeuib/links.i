/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

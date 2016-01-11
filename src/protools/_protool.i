/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*------------------------------------------------------------------------

  File: _protool.i

  Description: Defines PROTools temp-table

  Input Parameters:
      &NEW

  Output Parameters:
      <none>

  Author: Gerry Seidl
  
  Created: 09/07/94 - 03:32 pm
------------------------------------------------------------------------*/
DEFINE {1} SHARED TEMP-TABLE pt-function NO-UNDO
    FIELD pcFname   AS CHARACTER FORMAT "X(30)"
    FIELD pcFile    AS CHAR      FORMAT "X(65)"
    FIELD pcImage   AS CHARACTER FORMAT "X(65)"
    FIELD perrun    AS LOGICAL
    FIELD pdisplay  AS LOGICAL   
    FIELD order     AS INTEGER   FORMAT ">>>9"
    FIELD onmenu    AS LOGICAL
    INDEX pcFname   IS PRIMARY pcFname ASCENDING
    INDEX order                order   ASCENDING.
    

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
    

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
/* _HTM - .htm Objects
           Contains .htm field information.                                  */ 

DEFINE {1} SHARED TEMP-TABLE _HTM
  /* Cross reference indices. */
  FIELD _U-recid   AS RECID  LABEL "_U Recid" INITIAL ?
  FIELD _P-recid   AS RECID  LABEL "_P Recid" INITIAL ?
  /* Fields */
  FIELD _HTM-name  AS CHARACTER LABEL "HTML Field"
  FIELD _HTM-tag   AS CHARACTER LABEL "HTML Tag"
  FIELD _HTM-type  AS CHARACTER LABEL "HTML Type"
  FIELD _MDT-type  AS CHARACTER LABEL "Progress Type"    
  FIELD _i-order   AS INTEGER   LABEL "Read Order"
  INDEX U-recid    IS PRIMARY _U-recid
  INDEX P-recid               _P-recid
  INDEX i-order               _i-order
  .

/* htmwidg.i - end of file */


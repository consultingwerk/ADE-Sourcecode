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
/* tagmap.i - 
           Contains mappings of Progress types, utility proc names and handles  */ 
DEFINE {1} SHARED TEMP-TABLE tagmap NO-UNDO
    FIELD i-order        AS INTEGER   LABEL "Order"
    FIELD htm-Tag        AS CHARACTER LABEL "HTML Tag"
    FIELD htm-Type       AS CHARACTER LABEL "HTML Type"
    FIELD psc-Type       AS CHARACTER LABEL "PSC Type"
    FIELD util-Proc-Name AS CHARACTER LABEL "Util Proc Name"
    FIELD util-Proc-Hdl  AS HANDLE    LABEL "Util Proc Handle"
  INDEX i-order  IS UNIQUE PRIMARY i-order
  INDEX Tag-Type                   htm-Tag htm-Type
  .

/* tagmap.i - end of file */

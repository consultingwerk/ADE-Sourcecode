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
&SCOPED-DEFINE table {1}

ON CREATE OF {&TABLE} OVERRIDE DO:
END.

ON WRITE OF {&TABLE} OVERRIDE DO:
END.

DO ON ERROR UNDO, LEAVE:
    STATUS DEFAULT "{&table}".               
    MESSAGE "{&table}".
    PROCESS EVENTS.
    FIND _File WHERE _File-Name = "{&table}".
    ASSIGN lv_filename = "{&path}" + _File._Dump-Name + ".d".
    IF SEARCH(lv_filename) <> ? THEN
    DO:
      INPUT FROM VALUE(lv_filename).

/*        FOR EACH {&table}:
 *           DELETE {&table}.      
 *         END.*/

      REPEAT:
        CREATE {&table}.
        IMPORT {&table}.
      END.  
    END.
END.

INPUT CLOSE.

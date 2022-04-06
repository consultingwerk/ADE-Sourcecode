/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-------------------------------------------------------------
   usertrgw.i - trigger warning
      User wants to check syntax explicitly or implicitly 
      because he wants crc checking but we know it won't compile
      because table isn't committed yet.

   &widg = widget to reset to no (either the crc check toggle 
      	   or the check syntax toggle)
----------------------------------------------------------------*/

MESSAGE "Trigger code that references uncommitted schema tables"     SKIP
        "(such as this new or renamed table) will not compile"       SKIP
        "successfully."       	       	     	      	             SKIP(1)
        "You can save your trigger code now but if you want"         SKIP
        "to make sure there are no syntax errors, you must"          SKIP
        "commit table changes first. (As soon as you leave the"      SKIP
        "Table Editor the table changes are committed to the"        SKIP
      	"database.)" 	      	       	     	      	             SKIP(1)
        "NOTE: Choosing ~"Check CRC~" will require that the"         SKIP
        "trigger code be compiled before it is saved."
         view-as ALERT-BOX INFORMATION buttons OK.

{&widg}:SCREEN-VALUE = "no".

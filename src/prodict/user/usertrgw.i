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

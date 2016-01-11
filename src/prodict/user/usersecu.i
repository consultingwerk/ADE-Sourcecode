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

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/* usersecu.i - security instructions portion of frame */

"Examples:"                                         AT 2  VIEW-AS TEXT
"*" 	       	     	      	       	     	    AT 4  VIEW-AS TEXT
  "- All users (login Ids) are allowed access."     AT 23 VIEW-AS TEXT SKIP
"<user>,<user>,etc."                                AT 4  VIEW-AS TEXT
  "- Only these users have access."                 AT 23 VIEW-AS TEXT SKIP
"!<user>,!<user>,*"                                 AT 4  VIEW-AS TEXT
  "- All except these users have access."           AT 23 VIEW-AS TEXT SKIP
"acct*":t18     	     	      	       	    AT 4  VIEW-AS TEXT
  "- Only users that begin with ~"acct~" allowed."  AT 23 VIEW-AS TEXT 
&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN
     SKIP({&VM_WIDG})  /*Don't need and can't afford blank line in TTY*/
&ENDIF
"Do not use spaces in the string (they will be taken literally)." 
      	       	     	      	       	     	    AT 2  VIEW-AS TEXT



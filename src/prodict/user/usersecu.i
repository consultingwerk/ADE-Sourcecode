/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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



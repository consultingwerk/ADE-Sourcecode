/*********************************************************************
* Copyright (C) 2000,2007 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* _dmpview.p - dump _View, _View-col and _View-ref records for SQL views */

/*
in:  user_env[2] = Name of file to dump to.
     user_env[5] = "<internal defaults apply>" or "<target-code-page>"

History:
    hutegger    94/02/24    code-page - support and trailer-info added
    fernando    06/19/07    Support for large files    
*/
/*h-*/

{ prodict/user/uservar.i }


IF NOT CAN-FIND(FIRST DICTDB._View) THEN DO:
   MESSAGE "There are no views to dump." SKIP
      	   "The output file has not been modified."
      	    VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
   RETURN.
END.

run adecomm/_setcurs.p ("WAIT").

IF  user_env[5] = " "
 OR user_env[5] = ?  THEN assign user_env[5] = "<internal defaults apply>".
 
IF user_env[5] = "<internal defaults apply>"
 then OUTPUT TO VALUE(user_env[2]) NO-ECHO NO-MAP NO-CONVERT.
 else OUTPUT TO VALUE(user_env[2]) NO-ECHO NO-MAP
             CONVERT SOURCE SESSION:CHARSET TARGET user_env[5].

FOR EACH DICTDB._View:
  EXPORT DICTDB._View.
END.
PUT UNFORMATTED "." SKIP.
FOR EACH DICTDB._View-col:
  EXPORT DICTDB._View-col.
END.
PUT UNFORMATTED "." SKIP.
FOR EACH DICTDB._View-ref:
  EXPORT DICTDB._View-ref.
END.


  {prodict/dump/dmptrail.i
    &entries      = " "
    &seek-stream  = "OUTPUT"
    &stream       = " "
    }  /* adds trailer with code-page-entrie to end of file */
    
OUTPUT CLOSE.
run adecomm/_setcurs.p ("").
MESSAGE "Dump of views completed." 
        VIEW-AS ALERT-BOX INFORMATION BUTTONS OK.
RETURN.

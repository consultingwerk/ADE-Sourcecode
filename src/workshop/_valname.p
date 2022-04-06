/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: valname.p

Description:
   Check to see that a name entered by the user is a valid WebSpeed name.
 
Input Parameter:
   p_name - The name to check

Ouput Parameter:
   p_okay - Set to TRUE if name is a valid WebSpeed name.
   
Author: D.M.Adams

Date Created: March 1997

----------------------------------------------------------------------------*/

{ workshop/errors.i }

DEFINE INPUT  PARAMETER p_name  AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER p_okay  AS LOGICAL   NO-UNDO.

DEFINE VARIABLE ix AS INTEGER NO-UNDO.

IF p_name = "" OR p_name = ? THEN RETURN.

IF LENGTH(p_name,"RAW":U) > 32 THEN DO:
  RUN Add-Error IN _err-hdl ("ERROR":U, ?,
    SUBSTITUTE("The name &1 is too long.  Please enter a name that has 32 characters or less.",
    p_name)).
  RETURN "Error".
END.

IF SUBSTRING(p_name,1,1,"CHARACTER":u) < "A":u OR 
  SUBSTRING(p_name,1,1,"CHARACTER":u) > "Z":u THEN DO:
  RUN Add-Error IN _err-hdl ("ERROR":U, ?,
    "A valid WebSpeed name must start with a letter.  Please enter another name.").
  RETURN "Error".
END.

IF KEYWORD(p_name) <> ? THEN DO:
  RUN Add-Error IN _err-hdl ("ERROR":U, ?,
    SUBSTITUTE("&1 is a WebSpeed keyword.  Please enter another name.",p_name)).
  RETURN "Error".
END.

p_okay = TRUE.
DO ix = 2 TO LENGTH(p_name,"RAW":u) WHILE p_okay:
  p_okay = INDEX("#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZ":U,
             SUBSTRING(p_name,ix,1,"CHARACTER":u)) > 0.
END.

IF NOT p_okay THEN DO:
  RUN Add-Error IN _err-hdl ("ERROR":U, ?,
    SUBSTITUTE("This name contains at least one invalid character: '&1'.  Please enter another name.",
    SUBSTRING(p_name,ix - 1,1,"CHARACTER":u))).
  RETURN "Error".
END.

/* _valname.p - end of file */





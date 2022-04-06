/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*
-------------------------------------------------------------------------------
VALIDATION:
-----------

Enter the message to be displayed for disallowed deletions.
     Valmsg: _______________________________________________________________

Enter an expression that must be TRUE to allow record deletions.
     Valexp: _______________________________________________________________
             _______________________________________________________________
             _______________________________________________________________
             _______________________________________________________________


[^Table-Triggers] [^Description]
-------------------------------------------------------------------------------
*/

FORM
  SKIP(1)
  "Enter the message to be displayed for disallowed deletions." SKIP
  wfil._Valmsg    VIEW-AS EDITOR
                  INNER-CHARS 63 INNER-LINES 2
                  BUFFER-LINES 4 COLON 10 SKIP (1)

  "Enter an expression which must be TRUE to allow record deletions." SKIP
  wfil._Valexp    VIEW-AS EDITOR
      	       	  INNER-CHARS 63 INNER-LINES 2 
      	       	  BUFFER-LINES 4  COLON 10  

  {prodict/user/userbtns.i}
  WITH FRAME frame-v
    ATTR-SPACE SIDE-LABELS VIEW-AS DIALOG-BOX TITLE "Table Validation"
    ROW 5 COLUMN 2 WIDTH 78.

{adecomm/okrun.i  
   &BOX    = "rect_Btns"
   &FRAME  = "FRAME frame-v"
   &OK     = "btn_OK"
   &CANCEL = "btn_Cancel"}


PROCEDURE Tbl_Validation:
  VIEW FRAME frame-v.

  IF romode = 0 THEN
    HIDE MESSAGE NO-PAUSE.

  DISPLAY
    wfil._Valmsg
    wfil._Valexp
    WITH FRAME frame-v.

  UPDATE
    wfil._Valmsg        WHEN romode = 0
    wfil._Valexp   	WHEN romode = 0
    btn_OK btn_Cancel
    WITH FRAME frame-v.

  touched = touched
         OR FRAME frame-v wfil._Valmsg ENTERED
         OR FRAME frame-v wfil._Valexp ENTERED.

  IF romode = 0 THEN 
    IF wfil._Valexp = "" THEN wfil._Valexp = ?.
END.

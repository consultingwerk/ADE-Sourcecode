/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*************************************************************
  RETURN-VALUE processing for Procedure Window.  Used by
  adeweb/_webcom.w (_pwsavef.p and _pwsavas.p) to display
  Remote File Management messages.
  
**************************************************************/

PROCEDURE returnValue:
  DEFINE INPUT  PARAMETER pReturnValue AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pFileName    AS CHARACTER NO-UNDO.
  DEFINE INPUT  PARAMETER pAction      AS CHARACTER NO-UNDO.
  DEFINE OUTPUT PARAMETER pOkToSave    AS LOGICAL   NO-UNDO INITIAL TRUE.
  
  DEFINE VARIABLE cAction      AS CHARACTER NO-UNDO.
  DEFINE VARIABLE cReturnValue AS CHARACTER NO-UNDO.
  DEFINE VARIABLE lScrap       AS LOGICAL   NO-UNDO.
  
  IF INDEX(pReturnValue,"Not writeable":U) ne 0 THEN 
  DO:
    pOkToSave = FALSE.
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "warning":U, "ok":U,
      SUBSTITUTE("&1^Cannot save to this file.^^File is read-only or the path specified is invalid.", 
      pFileName)).
    RETURN.
  END.

  IF INDEX(pReturnValue,"File exists":U) ne 0 THEN 
  DO:
    pOkToSave = FALSE. 

    MESSAGE pFileName "already exists." SKIP
      "Do you want to replace it?"
      VIEW-AS ALERT-BOX WARNING BUTTONS YES-NO UPDATE pOkToSave.
    RETURN.
  END.

  ASSIGN
    cAction      = IF pAction ne "" THEN pAction 
                   ELSE IF NUM-ENTRIES(ENTRY(1, pReturnValue, CHR(10)), " ":U) ge 3 THEN
                          ENTRY(3, ENTRY(1, pReturnValue, CHR(10)), " ":U) 
                   ELSE pAction
    cReturnValue = SUBSTRING(pReturnValue, INDEX(pReturnValue,CHR(10)) + 1,
                            -1, "CHARACTER":U).

  RUN adecomm/_s-alert.p (INPUT-OUTPUT lScrap, "error":U, "ok":U,
    SUBSTITUTE("&1 could not be &2 for the following reason:^^&3",
    pFileName, cAction, cReturnValue)).
    
END PROCEDURE.

/* rtnval.i - end of file */

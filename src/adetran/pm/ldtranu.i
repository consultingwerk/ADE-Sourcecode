/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* Need to place this in a separate include file or in a central location with
 * input parameters */
PROCEDURE UpdateNew : 
  DEFINE INPUT PARAMETER        pSequenceNumber AS INTEGER        NO-UNDO.
  DEFINE INPUT PARAMETER        pInstanceNumber AS INTEGER        NO-UNDO.
  DEFINE INPUT PARAMETER        pLang_Name      AS CHARACTER      NO-UNDO.
  DEFINE INPUT PARAMETER        pTargetPhrase   AS CHARACTER      NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pUpdate         AS INTEGER        NO-UNDO.
  DEFINE INPUT-OUTPUT PARAMETER pDelete         AS INTEGER        NO-UNDO.

  DO TRANSACTION:
     FIND xlatedb.XL_Translation WHERE
         xlatedb.XL_Translation.Sequence_Num = pSequenceNumber
     AND xlatedb.XL_Translation.Instance_Num = pInstanceNumber
     AND xlatedb.XL_Translation.Lang_Name    = pLang_Name
     USE-INDEX seq_inst EXCLUSIVE-LOCK NO-ERROR.     
   
     IF AVAILABLE xlatedb.XL_Translation THEN 
     DO:
        IF pTargetPhrase = ? OR pTargetPhrase = "":U THEN 
        DO:
           ASSIGN pDelete = pDelete + 1.
           DELETE xlatedb.XL_Translation.
        END.
        ELSE
        ASSIGN pUpdate                         = pUpdate + 1
           xlatedb.XL_Translation.Trans_String = pTargetPhrase
           xlatedb.XL_Translation.Last_Change  = TimeDateStamp.
     END.
  END. /* Transaction */
END PROCEDURE.

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

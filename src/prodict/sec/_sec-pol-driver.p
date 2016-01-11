/*********************************************************************
* Copyright (C) 2008-2010 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/sec/_sec-pol-driver.p

Description:
    Driver program for various utilities on security policies (encryption).

Input-Parameters:
    cMode: edit - edit policies
           generate - generate encryption key
           history - shows history of policies

Output-Parameters:
    none
    
History:
    07/01/08  fernando   created

--------------------------------------------------------------------*/
                                
DEFINE INPUT PARAMETER cMode AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMsg         AS CHARACTER NO-UNDO.

/*DEF VAR cMode AS CHAR INIT "generate".*/

{prodict/misc/misc-funcs.i}
{prodict/sec/sec-pol.i}

DEF VAR myEPolicyCache AS prodict.sec._sec-pol-util.

IF NOT CAN-DO("edit,generate,history",cMode) THEN DO:
    MESSAGE 'Called with an invalid context'
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN ERROR. 
END.

IF NOT CONNECTED("DICTDB") THEN DO:
    MESSAGE "DICTDB database is required but it is not connected!"
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
END.

IF NOT dbAdmin(USERID("DICTDB")) THEN DO:
  MESSAGE "You must be a Security Administrator to access this utility!"
      VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "".
END.

IF NOT CAN-DO("history",cMode)
   AND CAN-DO("READ-ONLY",DBRESTRICTIONS("DICTDB")) THEN DO:
    MESSAGE "The dictionary is in read-only mode - alterations not allowed."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
END.

IF DBTYPE("DICTDB") NE "PROGRESS" THEN DO:
    MESSAGE "Cannot run this utility with this database type."
        VIEW-AS ALERT-BOX ERROR BUTTONS OK.
    RETURN "".
END.


DO TRANSACTION ON ERROR UNDO, LEAVE
               ON STOP  UNDO, LEAVE:
   /* this will acquire a schema lock for us on the DICTDB database */
   myEPolicyCache = NEW prodict.sec._sec-pol-util().

   IF cMode = "history" THEN
       RUN prodict/sec/_sec-pol-hist.p(INPUT myEPolicyCache).
   ELSE DO:
   
       IF NOT myEPolicyCache:canMantainPolicies THEN
          UNDO, THROW NEW Progress.Lang.AppError("Cannot run this utility if you are not the Key Store Administrator", 1).

       /* for the generate key tool, only want objects with encryption
          currently enabled (and not using the null_null_null cipher
       */
       IF cMode = "generate" THEN
          myEPolicyCache:EncryptionEnabledOnly = TRUE.

       RUN prodict/sec/_sec-obj-sel.p (INPUT myEPolicyCache,
                                       OUTPUT DATASET dsObjAttrs BY-REFERENCE).
    
       IF CAN-FIND(FIRST ttObjAttrs) THEN DO:
          /* now we have the objects selected by the user */
    
          IF cMode = "edit" THEN DO:
              RUN prodict/sec/_sec-pol-edit.p(INPUT myEPolicyCache,
                                              INPUT DATASET dsObjAttrs BY-REFERENCE).
              /* if something goes wrong, an error is thrown and we don't get to the
                 next statement.
              */
              cMsg = 'Changes committed.'.
          END.
          ELSE IF cMode = "generate" THEN DO:
              RUN prodict/sec/_sec-gen-key.p (INPUT myEPolicyCache,
                                              INPUT DATASET dsObjAttrs BY-REFERENCE).

              /* if something goes wrong, an error is thrown and we don't get to the
                 next statement.
              */
              cMsg = 'Keys generated.'.
          END.
       END.
   END.
                
   CATCH ae AS PROGRESS.Lang.AppError:
       /* 'edit' mode returns error if user did not commit, so that we undo
          the transaction. If message is blank, no need to display anything.
       */
       IF ae:GetMessage(1) NE "" THEN
          MESSAGE  ae:GetMessage(1) 
               VIEW-AS ALERT-BOX ERROR BUTTONS OK.
       DELETE OBJECT ae.
   END CATCH.
   FINALLY:
      IF VALID-OBJECT(myEPolicyCache) THEN
         DELETE OBJECT myEPolicyCache NO-ERROR.
   END FINALLY.

END.
 
/* display message when all was ok, outside the transaction so that the
   message doesn't hold the transaction open if the user leaves for a while.
*/
IF cMsg NE '' THEN
    MESSAGE cMsg
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

/*********************************************************************
* Copyright (C) 2009 by Progress Software Corporation. All rights    *
* reserved.                                                          *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/pro/_alt-buf-driver.p

Description:
    Driver program for utilities on alternate buffer pool.

Input-Parameters:
    cMode: edit - edit settings

Output-Parameters:
    none
    
History:
    03/12/09  fernando   created

--------------------------------------------------------------------*/
                                
DEFINE INPUT PARAMETER cMode AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMsg         AS CHARACTER NO-UNDO.

/*DEF VAR cMode AS CHAR INIT "edit".*/

{prodict/misc/misc-funcs.i}
{prodict/sec/sec-pol.i}

DEF VAR myObjAttributesCache AS prodict.pro._obj-attrib-util.

IF NOT CAN-DO("edit",cMode) THEN DO:
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
  
IF CAN-DO("READ-ONLY",DBRESTRICTIONS("DICTDB")) THEN DO:
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
   myObjAttributesCache = NEW prodict.pro._obj-attrib-util().

   RUN prodict/pro/_alt-buf-sel.p (INPUT myObjAttributesCache,
                                   OUTPUT DATASET dsObjAttrs BY-REFERENCE).
    
   IF CAN-FIND(FIRST ttObjAttrs) THEN DO:
      /* now we have the objects selected by the user */

      IF cMode = "edit" THEN DO:
          RUN prodict/pro/_alt-buf-edit.p(INPUT myObjAttributesCache,
                                          INPUT DATASET dsObjAttrs BY-REFERENCE).
          /* if something goes wrong, an error is thrown and we don't get to the
             next statement.
          */
          cMsg = 'Changes committed.'.
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
      IF VALID-OBJECT(myObjAttributesCache) THEN
         DELETE OBJECT myObjAttributesCache NO-ERROR.
   END FINALLY.

END.
 
/* display message when all was ok, outside the transaction so that the
   message doesn't hold the transaction open if the user leaves for a while.
*/
IF cMsg NE '' THEN
    MESSAGE cMsg
        VIEW-AS ALERT-BOX INFO BUTTONS OK.

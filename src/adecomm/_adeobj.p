/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/**************************************************************************
    Procedure:  _adeobj.p
    
    Purpose:    Run a Persistent PROGRESS ADE Object.

    Syntax :    
                RUN adecomm/_adeobj.p ( INPUT        p_Object_Name ,
                                        INPUT-OUTPUT p_hObject ) .

    Parameters:
        INPUT
            p_Object_Name - String Identifying the ADE Object to run.
        INPUT-OUTPUT    
            p_hObject - Persistent Procedure Handle of the requested object.
                            
    Description:
        1. Given an ADE Object Name p_Object_Name, identify the procedure
           run reference for that object.
        2. If caller passes the correct handle for the object, treat
           that as a query and return right away.  We just assume the
           caller was not aware they had the right handle.
        3. Trace the Persistent Procedure chain starting with SESSION:
           FIRST-PROCEDURE looking for a Persistent procedure with the
           identified file name.
        4. If match is found, returns that procedures handle via p_hObject.
        5. If no match, runs the specified file name.
        
    Notes  :
    Authors: John Palazzo
    Date   : February, 1995
    Updated: April, 1995   jep - made p_hObject INPUT-OUTPUT
**************************************************************************/

DEFINE INPUT        PARAMETER p_Object_Name   AS CHARACTER    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_hObject       AS HANDLE       NO-UNDO.

DEFINE VARIABLE Object_List AS CHARACTER    NO-UNDO .
DEFINE VARIABLE Run_List    AS CHARACTER    NO-UNDO .
DEFINE VARIABLE Obj_Run     AS CHARACTER    NO-UNDO .

/* MAIN */
DO:
    ASSIGN Object_List  = 
               "CONTAINER-API,LIB-MGR,WINMENU-MGR"
           Run_List     = 
               "adeshar/_cntrapi.p,adeshar/_mlmgr.p,adecomm/_winmenu.w"
           . /* END ASSIGN */
           
    ASSIGN Obj_Run = ENTRY( LOOKUP( p_Object_Name , Object_List ) , Run_List )
                     NO-ERROR.
    
    /* If the caller already has the correct handle to the object it
       wants, then return now.
    */
    IF VALID-HANDLE(p_hObject) AND (p_hObject:FILE-NAME = Obj_Run) THEN RETURN. 

    /* Otherwise, find the handle or dispatch the object. */
    RUN Dispatch_Object ( INPUT Obj_Run , OUTPUT p_hObject ).
    
    RETURN.
END.
/* MAIN */


PROCEDURE Dispatch_Object .

  DEFINE INPUT  PARAMETER p_File_Name       AS CHARACTER    NO-UNDO.
  DEFINE OUTPUT PARAMETER p_hObject         AS HANDLE       NO-UNDO.
  
  ASSIGN p_hObject = SESSION:FIRST-PROCEDURE.

  DO WHILE VALID-HANDLE( p_hObject ) AND
           ( p_hObject:FILE-NAME <> p_File_Name ):
    ASSIGN p_hObject = p_hObject:NEXT-SIBLING.
  END.
  
  IF NOT VALID-HANDLE( p_hObject ) THEN
    RUN VALUE( p_File_Name ) PERSISTENT SET p_hObject .
    
  RETURN.
  
END PROCEDURE.

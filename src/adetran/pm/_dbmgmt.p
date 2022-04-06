/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*

Procedure:    adetran/pm/_dbmgmt.p
Author:       R. Ryan/
Created:      1/95
Updated:      9/95
Purpose:      Performs various db management activities outside the 
              scope of the calling procedure.
Background:   The first parameter, pAction, identifies what the mode
              for this procedure will be:
                 
                CREATE      Creates a new progress DB
                CONNECT     Connects to a Progress DB
                DISCONNECT  Disconnect the Progress DB

                DELETE      Deletes a progress DB
                
Parameters:   pAction (input/char) described above
              pToDB (input/char)   name of the db to create or connect to
              pFromDB (input/char) name of the db to copy from
              pReplace (input/log) flag for replace a db if it exists
              pError (output/log)  was the operation successful?

Notes: There is no DELETE in the PROGRESS 4GL, we are simulating delete via
  OS commands.
                
*/



def input  parameter pAction as char.
def input  parameter pToDB as char.
def input  parameter pFromDB as char.
def input  parameter pReplace as logical.
def output parameter pError as logical.   

def var FakeLDB as char.
def var i as int.
def var MessageList as char.
def var cFiles as char.

main-block:
do 
  on error   undo main-block, leave main-block
  on end-key undo main-block, leave main-block
  on stop    undo main-block, leave main-block: 


  case pAction:   
    when "DISCONNECT" then do:
      /* message "Disconnecting" pFromDB view-as alert-box. */
      disconnect value(pFromDB) no-error.  
      delete alias xlatedb.
    end.
  
    when "CONNECT" then do: 
      FakeLDB = if num-entries(pFromDB,".") > 1 then
                 entry(1,pFromDB,".")
                else
                  pFromDB. 
      /* message "Connecting" FakeLDB "." view-as alert-box. */ 
      connect -db value(pFromDB) -ld value(FakeLDB) -1 no-error.          
    end. 
  
    when "CREATE" then do:                       
      /* message "Creating" pToDB "from" pFromDB "database" view-as alert-box. */ 
      if pReplace then
        create database pToDB from pFromDB replace no-error.
      else
        create database pToDB from pFromDB no-error. 
    end.

    WHEN "DELETE":U THEN DO:
       FILE-INFO:FILE-NAME = pToDB.
       RUN adetran/common/_dbfiles.p
          (INPUT FILE-INFO:FULL-PATHNAME,
           OUTPUT cFiles).
       DO i = 1 TO NUM-ENTRIES(cFiles,CHR(3)):
         FILE-INFO:FILE-NAME = ENTRY(i,cFiles,CHR(3)).
         IF FILE-INFO:FULL-PATHNAME <> ? THEN
           OS-DELETE VALUE(FILE-INFO:FULL-PATHNAME).
       END. /* remove each file */
    END. /* DELETE */
  end case. 
end.  


if error-status:error then do:
  do i = 1 to error-status:num-messages:
    MessageList = MessageList + chr(10) + error-status:get-message(i).
    
    IF error-status:get-message(i) MATCHES "*Error Creat*":U THEN
      MEssageList = MessageList + chr(10) +
                  "Check to make sure that the directory structure is correct.":U.
  end.
  
  message MessageList view-as alert-box error title "Database Error".
  pError = true. 
end.

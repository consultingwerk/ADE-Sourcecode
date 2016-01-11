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

/* ------------------------------------------------------------------- 
   Procedure _as4crcn.p                                               
   
     Procedure to create meta schema df file for DB2/400 database which
     is being added to the schema holder, connect to DB2/400 and load
     meta schema definitions.   After load, will run procedure to see what
     user wishes to do next.
               
   Created 01/20/95 D. McMann
   Modified 06/19/96 D. McMann Added reconnection and logical name support
            07/14/98 D. McMann Added _Owner to _file find
 ----------------------------------------------------------------------*/                

{ prodict/dictvar.i }
{ prodict/user/uservar.i }
{ prodict/user/userhue.i }
{ prodict/user/userhdr.f }

DEFINE VARIABLE phynam AS CHARACTER NO-UNDO.     

FIND  _db where _db._Db-name = user_dbname NO-ERROR.                                   
phynam = (IF _Db-addr = "" OR _Db-addr = ? THEN user_dbname ELSE _Db-addr).

IF AVAILABLE _db AND NOT CONNECTED(user_dbname) THEN DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  MESSAGE
    'Connecting to "' + user_dbname  + '"'.
  run adecomm/_setcurs.p ("WAIT").
  CONNECT VALUE(phynam) -ld VALUE(user_dbname) -dt VALUE(_db._Db-type) 
          VALUE(_db._Db-comm) NO-ERROR.

  PAUSE 1 NO-MESSAGE.  /* to avoid having the message flash to fast */
  RUN adecomm/_setcurs.p ("").
  HIDE MESSAGE NO-PAUSE.
END.

/* Got here by editing logical name and need to only reconnect. */
IF user_env[1] = "connect" THEN RETURN.
 
IF NOT CONNECTED(user_dbname) THEN DO TRANSACTION:
  MESSAGE
    'Could not create schema for  "' + user_dbname  + '"' + " because" SKIP
    ERROR-STATUS:GET-MESSAGE(1)
    VIEW-AS ALERT-BOX ERROR BUTTONS OK.           
  IF AVAILABLE _db THEN 
     assign user_path = "_as4schg,*C,_as4crcn,*C,_as4sydd"  
                   user_env[1] = "redo"
                   drec_db = RECID(_db) .
END.                  
ELSE  
  _loadloop:
   DO:                                                  
   { prodict/user/usercon.i  }

  CREATE ALIAS DICTDBG FOR DATABASE VALUE(user_dbname).
  
  DEFINE VARIABLE dffile     AS CHARACTER NO-UNDO.
  DEFINE VARIABLE sourcefile AS CHARACTER NO-UNDO.
  DEFINE VARIABLE save_ab    AS LOGICAL   NO-UNDO.
    
  /* Generate unique name for the .df */
  RUN "adecomm/_tmpfile.p" (INPUT "", INPUT ".df", OUTPUT dffile).
  
  OUTPUT TO VALUE(dffile).
  DISPLAY "UPDATE DATABASE" _Db._Db-name NO-LABEL.
  OUTPUT CLOSE.
  
  sourcefile = SEARCH("as4empty.df").     
  IF sourcefile = ? THEN 
     sourcefile = SEARCH("as4dict/as4empty.df").
  IF sourcefile = ? THEN DO:
    MESSAGE "as4empty.df file could not be found.  Verify that this" SKIP
                        "file was installed in the directory where PROGRESS" SKIP
                       "was installed and try this function again." SKIP
       VIEW-AS ALERT-BOX ERROR BUTTON OK.
    assign user_path = "".
    LEAVE _loadloop.
  END.
   
  OS-APPEND VALUE(sourcefile) VALUE(dffile).  
  
  ASSIGN user_env[2] = dffile
         user_env[8] = _Db._Db-name
         user_dbname = _Db._Db-name
         user_dbtype = _Db._db-type
         drec_db     = RECID(_Db).
           
  save_ab = SESSION:APPL-ALERT-BOXES.
  SESSION:APPL-ALERT-BOXES = NO.

  DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:    
    RUN "prodict/dump/_lodsddl.p".                                                                        
    
    /* This needs to be assigned here as the load program could overwrite value
        and AS400 Client needs this value to be set to know if it is a V7.  */              
        
    ASSIGN _Db._Db-misc1[8] = 7.
  END.      
  /* Delete the df file that was created by this procedure */
  OS-DELETE VALUE(dffile).     

  FIND FIRST _File WHERE _File._File-Name BEGINS "p__" 
                     AND _File._Owner = "_FOREIGN" NO-LOCK NO-ERROR.
  IF NOT AVAILABLE _File THEN  DO TRANSACTION:              
     DISCONNECT   VALUE(_db._Db-name) .      
     { prodict/user/usercon.i '' @ user_filename }     
     DELETE _Db.  
     SESSION:APPL-ALERT-BOXES = save_ab.         
     
/* Need to switch the name of the  database */
    
     &IF "{&WINDOW-SYSTEM}" = "TTY" &THEN
          ASSIGN user_path = "*N,1=sys,_usrsget".
   &ELSE
         ASSIGN user_path = "*N,1=sys,_guisget".
   &ENDIF
     RETURN.
  END. 
END.
   
SESSION:APPL-ALERT-BOXES = save_ab.

RETURN.
 


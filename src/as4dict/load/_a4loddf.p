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


/* _A4loddf - Controlling jacket program for loading .df files  */
/*            from an AS/400 database.  This mirrors the load   */
/*            process (in usermenu.i) which runs from the       */
/*            admin menu in the Data Administration function.   */
/*  Initial creation:  May 8, 1995 - NHorn                      */   
/*          Modified:  12/18/95 - to run new load procedures
                                  if DB2/400 Database is empty 
                       09/09/96 - changed assignment to user_dbname
                                  to use _Db._Db-addr since that is where the
                                  DB2/400 Dictionary Library is stored.
                       10-18096 - changed assign to user_dbname
                                  to fix bug 96-10-17-004
                       03/21/97 - added assign of user_env[34] = ""
                                  97-01-20-020  
                       02/06/01   Added support for AS/400 incremental df                                 

*/                                                                       


{as4dict/dictvar.i shared}
{as4dict/menu.i shared}
{as4dict/dump/dumpvar.i shared}

DEFINE VARIABLE save_db AS CHARACTER NO-UNDO.     
DEFINE VARIABLE schema_empty AS LOGICAL NO-UNDO.

/*  Find the correct database selected.  Preserve the one in user_dbname */
  ASSIGN 
   save_db = user_dbname  
   user_dbname = PDBNAME("as4dict").
   

/* Check if the dictionary is dirty.  If so, force commit */
IF s_DictDirty THEN DO:
    MESSAGE "You have uncommitted transactions which must"
            "be committed before starting the load utility."
       	     VIEW-AS ALERT-BOX buttons OK.
    RETURN.
END.  /* If Dictdirty */

user_env[9] = "d". 

IF user_env[33] = "as4inc" THEN DO:
  RUN as4dict/load/_incload.p.
  IF NOT user_cancel THEN DO:
    ASSIGN user_env[4] = "y".
    RUN as4dict/load/_lodench.p.
    IF user_env[35] = "error" THEN 
      LEAVE.
    IF user_env[35] <> "s" THEN DO: 
      ASSIGN user_env[9] = "h".
      RUN as4dict/load/_incload.p.
    END.
    ELSE  
      ASSIGN user_env[35] = "".
            .
  END.
  ASSIGN  user_env[33] = "".
END.
ELSE DO:
  RUN "as4dict/load/_usrload.p".

  IF NOT user_cancel THEN DO:     
    FIND FIRST as4dict.p__File NO-LOCK NO-ERROR.
    IF NOT AVAILABLE as4dict.p__File THEN 
      ASSIGN schema_empty = true.     
       
    { as4dict/setdirty.i &dirty = "true" }  
      
    IF schema_empty THEN
       RUN "as4dict/load/_lodnddl.p".
    ELSE      
       RUN "as4dict/load/_lodsddl.p". 
   
   IF schema_empty AND user_env[35] = "s" THEN
       ASSIGN user_env[35] = "error".

   IF user_env[35] = "error" THEN 
       LEAVE.

    ELSE DO:  
      assign user_env[35] = ""
             user_env[9] = "h". 
      RUN "as4dict/load/_usrload.p".   
    END.  
    
  END.
  ELSE 
    ASSIGN user_env[35] = "cancelled".
END.

/* reset user cancel so user can come back in within same process */       
/* reset user_dbname back to selected db. */
ASSIGN 
   user_env[34] = ""
   user_cancel = no
   user_dbname = save_db.


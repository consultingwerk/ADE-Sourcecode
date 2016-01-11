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


/*----------------------------------------------------------------------------

File: as4sync.p

Description:
   This procedure is for application developers to use for syncing AS/400 schema from
   their application without the user having to have access to the Data Admin tool.
   The procedure that is called is the same procedure which will be run if Synchronize 
   PROGRESS/400 Client utility is run from that tool without any I/O.  This procedure is 
   necessary to set all shared variables as new and to create the alias which can not 
   be created in the same procedure that uses the alias. 
   
   Rules:
      1.  The AS/400 database MUST be connected.  This is because you can not define
            an alias on a database which is not connected.   The calling procedure must
            pass the name of the database which you want to sync.
                Example:  RUN as4sync.p (INPUT "dbname").             
                
            If the INPUT parameter database is not connected, then this procedure will not 
            call as4dict/as4_sync.p.
                
       2.  There is no I/O to the user except in the following cases:
                a.  Someone is defining schema and a sync can not be performed.     
                b.  Trying to use the syncing procedure on an AS/400 that does not
                       have any schema defined.       
                       
        3.  This procedure must be compiled with "dlc/src" in the propath.  If PROGRESS
             was installed in a directory other than "dlc", than that directory plus "src" must
             be added.  
   
Author: Donna L. McMann

Date Created: 08/22/95  
              03/18/96 Changed from for each loop to do loop because second as400 database
                       would not sync if two schema holders were connected.
                       Bug 96-03-01-033

----------------------------------------------------------------------------*/             


DEFINE INPUT PARAMETER sync_db        AS CHARACTER            NO-UNDO.         
DEFINE VARIABLE olddictdb                         AS CHARACTER            NO-UNDO.  
DEFINE VARIABLE i                                          AS INTEGER INITIAL 1 NO-UNDO.

/* These include files are in the src/prodict directory supplied with the product */   

{ prodict/dictvar.i  NEW}
{ prodict/user/uservar.i NEW } 
{ prodict/user/userhue.i  NEW}              
{ prodict/user/userhdr.f  NEW}               

SESSION:IMMEDIATE-DISPLAY = TRUE.           

/* Save old DICTDB name in case we change to another PROGRESS database */
olddictdb = LDBNAME("DICTDB").

_setalias:
DO i = 1 TO NUM-DBS:
    IF DBTYPE(i) <> "AS400" THEN 
        NEXT _setalias.
   
    ELSE IF LDBNAME(i) = sync_db AND CONNECTED(LDBNAME(i)) THEN DO:  
         
        /* Create alias for schema holder of AS/400 database */
        CREATE ALIAS "DICTDB" FOR DATABASE VALUE(SDBNAME(i)).  
        
        ASSIGN user_dbname  = ldbname(i)
               user_dbtype  = dbtype(i)
               user_env[34] = "batch".        

        /* Create alias for AS/400 database */
        CREATE ALIAS as4dict FOR DATABASE VALUE(ldbname(i)).

        DO TRANSACTION ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE : 
            RUN "as4dict/as4_sync.p".
        END.      
        LEAVE _setalias.                                                                                                                                
    END.
END.

/* Reset alias to original */
IF olddictdb <> ? THEN
    CREATE ALIAS "DICTDB" FOR DATABASE VALUE(olddictdb).
    
HIDE MESSAGE NO-PAUSE.

RETURN.        

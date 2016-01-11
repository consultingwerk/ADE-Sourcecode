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

/* File: as4deldb.p

Description:
   This procedure is the main procedure for deleting a DB2/400
   DataServer.  It is called from prodict/as4/_as4_del.p
   
History:
      Created 01/25/95 D. McMann 
    Modified 10/27/95 D. McMann -  cancel caused client to hang because cusor was
                                                                not released.
             10/25/96 D. McMann Added logic to handle frozen schema so that
                                the dataserver schema can be deleted.  
                                
             06/26/97 D. McMann Added view as dialog box to upgrade look.                                                                          
*/

DEFINE VARIABLE undel AS LOGICAL INITIAL TRUE.  

/*===========================  Main Line Code  ===========================*/
{ prodict/dictvar.i }
{ prodict/user/uservar.i }

 
FORM
  _Db._Db-name    LABEL "Database" COLON 11 FORMAT "x(32)":u SKIP
  _File._File-name  LABEL "Table"    COLON 11 FORMAT "x(32)":u SKIP
  _Field._Field-name LABEL "Field"    COLON 11 FORMAT "x(32)":u SKIP
  _Index._Index-name LABEL "Index"    COLON 11 FORMAT "x(32)":u SKIP
  _Seq._Seq-Name   LABEL "Sequence" COLON 11 FORMAT "x(32)":u SKIP
  HEADER 
    " Deleting Definitions. Press " +
    KBLABEL("STOP") + " to terminate process." format "x(70)" 
  WITH FRAME working THREE-D
  ROW 4 CENTERED USE-TEXT SIDE-LABELS VIEW-AS DIALOG-BOX.
  
 run adecomm/_setcurs.p ("WAIT").
 _delloop:
DO TRANSACTION ON ERROR UNDO, RETRY ON ENDKEY UNDO,LEAVE _delloop
   ON STOP UNDO, LEAVE _delloop:
   
    FIND _db where _db._db-name = user_dbname.   

/*  user had cancelled from creating dataserver schema and we want to quitely
     get rid of _db record we have created.  */
    IF user_env[1] = "redo" THEN  DO:
        DELETE _db.              
        run adecomm/_setcurs.p ("").                                
        RETURN.
    END.    
  
/* The user has selected delete DataServer schema theb we want to display what is
    being deleted */
    
    ELSE DO:
        COLOR DISPLAY MESSAGES
            _Db._Db-name _File._File-name _Field._Field-name
            _Index._Index-name _Seq._Seq-Name
        WITH FRAME working.
         ASSIGN undel = FALSE.
        DISPLAY _db._Db-name with frame working.          
   
        FOR EACH _file of _db WHERE
                   (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"):  
            DISPLAY _File._File-name WITH FRAME working.    
            IF _File._Frozen THEN ASSIGN _file._Frozen = FALSE.
            FOR EACH _Index OF _File: 
                DISPLAY _Index._Index-name WITH FRAME working.
                FOR EACH _Index-field OF _Index:
                    DELETE _Index-field. 
                END.
                DELETE _Index.    
                DISPLAY "" @ _Index._Index-name WITH FRAME working.
            END.
            FOR EACH _File-trig OF _File:
                 DELETE _File-trig. 
            END.                      
            FOR EACH _Field OF _File:     
                DISPLAY _field._Field-name WITH FRAME working.
                FOR EACH _Field-trig OF _Field:
                    DELETE _Field-trig.
                END.  
                DELETE _Field. 
            END. 
            DELETE _file.  
        END.
        display "" @ _Field._Field-name with frame working.
        display "" @ _File._File-name with frame working.
   
                     /* Sequence Delete Loop */
        FOR EACH _Sequence of _db:      
            DISPLAY _Sequence._Seq-name WITH FRAME working.
            Delete _Sequence. 
        END.  /* Sequence Delete Loop */
   
        DELETE _db.   
        ASSIGN drec_db     = ?
               user_dbname = ""
               cache_dirty = TRUE.
    END.
END.                    
run adecomm/_setcurs.p ("").                    
IF undel  THEN DO:
  HIDE FRAME working NO-PAUSE.
  MESSAGE "Deletion was terminated." VIEW-AS ALERT-BOX INFORMATION BUTTON OK.
END.

ELSE HIDE FRAME working NO-PAUSE.       



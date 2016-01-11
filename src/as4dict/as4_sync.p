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

/* File: as4_sync.p

Description:
      This program synchronizes an AS/400 data dictionary (which
      resides on the AS/400) with a PROGRESS Schema on the 
      client. Basically, not much validation is done here because
      it is assumed that the validation was done upon entry to
      the AS/400 (p__xxxx) files via the AS/400 Data Dictionary.

Input Parameters:
   
Output Parameters:
   
History:
      nhorn    10/28/94   Created.   
      D. McMann 03/21/96  Modified to assign _db._Db-Misc2[2] for
                          null support.     
      D. McMann 06/19/96  Display _either _db-addr or _db-name depending
                          on whether a logical name has been defined  
      D. McMann 08/14/96  Added variable fldcnt to assign to _fld-misc1[1]
                          for null support.  
      D. McMann 09/09/96  Removed kludge for sequences not being tied to
                          specific database.  This has changed for V8. 
      D. McMann 10/09/96  Added assign of _db-Misc1[4].
      D. McMann 10/25/96  Added logic to handle changing a file from
                          frozen to unfrozen.  
      D. McMann 01/08/96  Added assignment of _db._Db-misc2[1] and _db._Db-misc2[3]
                          and removed assignment of _db._Db-misc2[2]
      D. McMann 05/08/97  Added exclusion of qdtaq-entry file for data queue support.
      D. McMann 06/26/97  Changed check for special files to look at foreign number
                          so that each time a new file is added the procedure will
                          not need to be changed.
      D. McMann 06/03/98  Added DICTDB to meta schema finds 98-04-03-003
      D. McMann 06/30/98  Added  (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN") to _File finds
                                                                                 
*/


/*===========================  Main Line Code  ===========================*/

{ prodict/dictvar.i }
{ prodict/user/uservar.i } 
{ prodict/user/userhue.i }       
{ prodict/user/userhdr.f } 


DEFINE VARIABLE oxlname AS CHARACTER                NO-UNDO.  
DEFINE VARIABLE dofield AS LOGICAL                  NO-UNDO. 
DEFINE VARIABLE answer  AS LOGICAL INITIAL FALSE    NO-UNDO.  
DEFINE VARIABLE errcode AS INTEGER                  NO-UNDO.        
DEFINE VARIABLE insync    AS CHARACTER              NO-UNDO.
DEFINE VARIABLE ctlbrk     AS LOGICAL INITIAL TRUE.    
DEFINE VARIABLE fromdict AS logical initial false   NO-UNDO.
DEFINE VARIABLE dspname  AS CHARACTER               NO-UNDO.
DEFINE VARIABLE fldcnt   AS INTEGER                 NO-UNDO.

/* defines for dumpname.i */
DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.
           

FORM
  dspname    LABEL "Database" COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__File._File-name  LABEL "Table"    COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__Field._Field-name LABEL "Field"    COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__Index._Index-name LABEL "Index"    COLON 11 FORMAT "x(32)":u SKIP
  as4dict.p__Seq._Seq-Name   LABEL "Sequence" COLON 11 FORMAT "x(32)":u SKIP   
  HEADER 
    " Synchronizing Definitions. Press " +
    KBLABEL("STOP") + " to terminate process." format "x(70)" 
  WITH FRAME working 
  ROW 4 CENTERED OVERLAY USE-TEXT SIDE-LABELS THREE-D VIEW-AS DIALOG-BOX.

SESSION:IMMEDIATE-DISPLAY = TRUE.

IF user_env[3] =  "sync"  then assign fromdict = true.     
else fromdict = false.

FIND DICTDB._db where DICTDB._db._db-name = LDBNAME("as4dict").     
IF DICTDB._Db._db-addr = ? OR DICTDB._Db._Db-addr = "" THEN
  ASSIGN dspname = DICTDB._Db._Db-name.
ELSE
  ASSIGN dspname = DICTDB._Db._Db-addr.
        
IF user_env[1] = "" THEN DO:
  FIND FIRST DICTDB._File of DICTDB._Db WHERE  NOT DICTDB._File._Hidden  AND 
         (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN") NO-LOCK NO-ERROR.
   IF NOT AVAILABLE DICTDB._File THEN ASSIGN user_env[1] = "add".
 END.   

FIND FIRST as4dict.p__file NO-LOCK NO-ERROR.
IF NOT AVAILABLE as4dict.p__file THEN DO:       
  FIND FIRST  DICTDB._File OF DICTDB._DB WHERE  NOT DICTDB._File._File-name BEGINS "P__"
                             AND  DICTDB._File._For-number > 0 
                             AND  (DICTDB._File._Owner = "PUB" OR DICTDB._File._Owner = "_FOREIGN") NO-ERROR.
   IF AVAILABLE DICTDB._File THEN.  /*  All schema was deleted so continue */                                                          
    ELSE  DO:
        IF user_env[34]<> "batch" THEN 
        MESSAGE dspname "does not have any schema defined." SKIP
            "Scynchronization can not be performed." SKIP
            VIEW-AS ALERT-BOX INFORMATION BUTTON OK.      
        ELSE ASSIGN user_env[34] = "20"
                                user_path = "".       
        RETURN "noschema".
     END.
END.                  

FIND as4dict.p__db NO-LOCK.
IF as4dict.p__db._Db-Misc1[1] = _Db._Db-misc1[1] THEN DO:    
    IF user_env[34]<> "batch" THEN 
          MESSAGE dspname "has not changed since " SKIP
                      "the last synchronization. "
                     VIEW-AS ALERT-BOX INFORMATION BUTTON OK.       
                        
      if fromdict then assign user_path = "*C,2=sync,_as4dict".
      else ASSIGN user_path = "".             
     RETURN  "insync".
END.  
ELSE  
  _uploop:
DO ON ERROR UNDO,LEAVE _uploop ON ENDKEY UNDO,LEAVE _uploop 
       ON STOP UNDO, LEAVE _uploop:          
    run adecomm/_setcurs.p ("WAIT").
    IF user_env[34] <> "batch" THEN  COLOR DISPLAY MESSAGES
        dspname as4dict.p__File._File-name as4dict.p__Field._Field-name
        as4dict.p__Index._Index-name as4dict.p__Seq._Seq-Name 
    WITH FRAME working.
    IF user_env[34] <> "batch" THEN  DISPLAY dspname with frame working.          
    IF _db._Db-xl-name <> as4dict.p__db._Db-xl-name THEN 
        ASSIGN user_env[35] = _Db._Db-name.
     
    ASSIGN _Db._Db-misc1[1] = as4dict.P__db._Db-misc1[1]
           _Db._Db-misc1[2] = as4dict.P__db._Db-misc1[2] 
           _Db._Db-misc1[3] = as4dict.p__Db._Db-misc1[3] 
           _Db._Db-misc1[4] = as4dict.p__Db._Db-misc1[4]  
           _Db._Db-misc2[1] = as4dict.P__db._Db-misc2[1]
           _Db._Db-misc2[3] = SUBSTRING(as4dict.p__Db._Db-misc2[3],1,1)
           oxlname          = _Db._Db-xl-name
           _Db._Db-xl-name  = as4dict.P__Db._Db-xl-name.
               
         
    /*------------------------ _File processing ------------------------------*/
    /* File Loop for each table in the database.  Fields, 
    File Triggers, and Indices will be processed within. p__file */
  
    _fileloop:
    FOR EACH as4dict.p__file NO-LOCK :                                                            
     /* This include is used in both the full sync and selective sync. */
       { as4dict/as4sync.i }

    END.        /* File Loop  */           

    /* Table Delete Loop.  Weed out the files beginning with as4dict.p__ and 
        the schema files since we don't want to delete them and they
        won't be in the p__xxxx files. Also ignor any file whose for-number
        is less than 0 like QCMD  */               
  
    IF user_env[1] <> "add" THEN DO:
      FIND DICTDB._db WHERE DICTDB._db._db-name = LDBNAME("as4dict").
      FOR EACH _file of _db WHERE NOT _file._file-name BEGINS "P__" 
                            AND NOT _file._file-name BEGINS "_"
                            AND (_File._Owner = "PUB" OR _File._Owner = "_FOREIGN"):     
        ASSIGN ctlbrk = FALSE.                                       
        IF _file._For-number < 0 THEN NEXT.        
        FIND as4dict.p__file WHERE as4dict.p__file._file-name = _file._file-name NO-LOCK NO-ERROR.
        IF NOT AVAILABLE(as4dict.p__file) THEN DO:      
            FOR EACH _Index OF _File:
                FOR EACH _Index-field OF _Index:
                    DELETE _Index-field. 
                END.
                DELETE _Index. 
            END.
            FOR EACH _File-trig OF _File:
                DELETE _File-trig. 
            END.
            FOR EACH _Field OF _File:
                FOR EACH _Field-trig OF _Field:
                    DELETE _Field-trig.
                END.  
                DELETE _Field. 
            END. 
            DELETE _file.  
        END.
      END.
    END.   /* File Delete Loop  */
    
    /* ------------------  Sequence Loop  -------------------------- */
    /* Sequence Update Loop */        
    _seqloop:
    FOR EACH as4dict.p__seq NO-LOCK:
       FIND _Sequence WHERE _Sequence._Seq-name = as4dict.p__Seq._Seq-name NO-ERROR.
        IF AVAILABLE (_Sequence) THEN DO:                    
            IF user_env[34] <> "batch" THEN  Display as4dict.p__Seq._Seq-name 
                with frame working.  /* MODIFY Sequence */
            {as4dict/as4synsq.i}
        END.
        ELSE DO:                                      /* ADD Sequence */
            display as4dict.p__Seq._Seq-name with frame working.  
            CREATE _Sequence.  
            ASSIGN _Sequence._Seq-name = as4dict.p__Seq._Seq-name
                             _Sequence._DB-recid = RECID(_DB).
            {as4dict/as4synsq.i}
        END. 
    END.  /* Sequence Update Loop  */

                     /* Sequence Delete Loop */
    IF user_env[1] <> "add" THEN FOR EACH _Sequence of _db:
        FIND as4dict.p__Seq WHERE as4dict.p__Seq._Seq-name = _Seq._Seq-name NO-LOCK NO-ERROR.
        IF NOT AVAILABLE (as4dict.p__Seq) THEN DO:
            Delete _Sequence.
        END.     
    END.  /* Sequence Delete Loop */                                    
END.  /* End _db update loop */            
                                                                       
 run adecomm/_setcurs.p ("").            
 
IF ctlbrk THEN DO:
  ASSIGN user_env = "".
  HIDE FRAME  working NO-PAUSE.
  RETURN "error".
END.         

IF oxlname <> _Db._Db-xl-name THEN DO:    
  IF user_env[34] <> "batch" THEN  HIDE FRAME working NO-PAUSE.
  IF user_env[34] <> "batch" THEN  
    MESSAGE "The DB2/400 code page stored in the client" SKIP
            "was changed during synchronization." SKIP
            "You will be disconnected and then asked if" SKIP
            "you want to be re-connected.  This disconnect" SKIP 
            "is necessary for the new code page to take " SKIP
            "effect.  Otherwise, you may corrupt your " SKIP
            "DB2/400 database. "
          VIEW-AS ALERT-BOX INFORMATION BUTTON OK.      
  DISCONNECT as4dict.        
  IF user_env[34] <> "batch" THEN  DO:
      { prodict/user/usercon.i '' @ user_filename }
      RUN as4dict/as4recon.p.   
   END.
  RETURN.     
END.                          
                                             
 IF user_env[34] <> "batch" AND  user_env[34] <> "as4dict" THEN   DO:
     MESSAGE "Phase 1 of Synchronization done, beginning Phase 2".    
     ASSIGN user_env[34] = "viewbut".
  END.
HIDE FRAME working NO-PAUSE.
ASSIGN user_env[1] = "".
RETURN.









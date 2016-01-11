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

/* Include as4sync.i
   Donna McMann
   September 29, 1997
   
   This include is used with both _selsync and as4_sync and does all the
   work of syncing the client schema holder with the server schema.

   History:  10/30/97 DLM Added assignment of _file and _Index original
                          area number.  Defaults to 6.
             02/04/99 DLM Added replication trigger support  
             07/12/99 DLM Added "FIND" trigger to file case statement  
             09/09/99 DLM Added delete logic to reactivating indices.  
             03/24/00 DLM Missed "FIND" in one case statement 20000315021       
                          
*/   


        ASSIGN ctlbrk = FALSE
               fldcnt = 1.
               
        FIND _file WHERE _file._file-name = as4dict.p__file._file-name 
                               AND _File._Db-recid = RECID(_Db) NO-ERROR.    
        IF AVAILABLE _File THEN DO:              
            IF _File._For-number < 0 THEN
               NEXT _fileloop.   
            IF  _File._For-Owner = as4dict.p__File._For-Owner 
                AND _File._For-Number = as4dict.p__File._File-number 
                AND _File._Fil-Misc1[4] = as4dict.p__File._Fil-Misc1[4] 
                AND _File._Fil-Misc1[1] = as4dict.p__File._Fil-Misc1[1] THEN  DO:
                ASSIGN dofield = FALSE
                                 insync = "Checking " + as4dict.p__File._File-name.
                IF user_env[34] <> "batch" THEN  
                      Display insync @ as4dict.p__file._file-name 
                                  "" @ as4dict.p__Field._Field-name with frame working.     
                               
            END.
            ELSE DO:  
                ASSIGN dofield = TRUE.
                IF _File._Frozen  THEN ASSIGN _file._Frozen = false.
                           
                IF user_env[34] <> "batch" THEN  Display as4dict.p__file._file-name with frame working.  /* MODIFY Table */
 
                /* This loop is performed because the file has been recreated since the
                    last sync.  If the field order numbers, field numbers or names have changed, 
                    it could cause errors during the field and index section so deleted everything 
                    here and recreate later */          

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
                 DELETE _File.
                 CREATE _File.
                 ASSIGN _file._file-name   = as4dict.p__file._file-name
                                 _file._DB-recid    = RECID(_DB).                
                {as4dict/as4syntb.i}
            END.         
        END.
        ELSE DO:                                           /* ADD Table */
            IF user_env[34] <> "batch" THEN  display as4dict.p__file._file-name with frame working.  
            CREATE _file.                                                                       
            ASSIGN _file._file-name         = as4dict.p__file._file-name
                   _file._DB-recid          = RECID(_DB)
                   _File._ianum             = 6
                   dofield                  = TRUE.
            {as4dict/as4syntb.i}
        END. 

        /*----------------------- _Field processing ------------------------------*/
        /* Field Loop: p__field  */
        FOR EACH as4dict.p__field 
                       WHERE as4dict.p__field._file-number = as4dict.p__file._file-number 
                       USE-INDEX p__Fieldl0 NO-LOCK:   
            IF as4dict.p__Field._Fld-misc2[5] = "A"  THEN NEXT.
            IF dofield THEN DO:
                FIND _field of _file WHERE _field._field-name = as4dict.p__field._field-name NO-ERROR.    
                IF AVAILABLE (_field) THEN DO:     /* MODIFY Field   */
                    IF user_env[34] <> "batch" THEN  display as4dict.p__field._field-name with frame working.
                    {as4dict/as4synfd.i} 
                END.
                ELSE DO:                                     /* ADD new Field  */
                    IF user_env[34] <> "batch" THEN  display as4dict.p__field._field-name with frame working.           
                    
                    CREATE _field.
                    ASSIGN _field._field-name = as4dict.p__field._field-name
                                     _field._file-recid = RECID(_file).
                    {as4dict/as4synfd.i}          
                END.  
        
       
                 /* Field Trigger Loop:  p__trgfd */
                FOR EACH as4dict.p__trgfd WHERE   as4dict.p__trgfd._File-number = as4dict.p__Field._File-number
                                                                     AND as4dict.p__trgfd._fld-number = as4dict.p__Field._fld-number NO-LOCK:
        
                    FIND _field-trig of _field WHERE _field-trig._event = as4dict.p__trgfd._event no-error.
                    IF AVAILABLE (_field-trig) THEN DO:                  
                        DELETE _field-trig.
                        CREATE _field-trig.
                        ASSIGN  _Field-trig._Field-Recid = RECID(_Field)
                                _Field-trig._File-Recid = RECID(_File)        
                                _Field-Trig._Event = as4dict.p__trgfd._event
                                _Field-Trig._Override = (If as4dict.p__trgfd._Override = "Y" then yes else no)
                                _Field-Trig._Proc-name = as4dict.p__trgfd._Proc-name.                   
            
                    END.
                    ELSE DO:                      
                        CREATE _Field-Trig.
                        ASSIGN  _Field-trig._Field-Recid = RECID(_Field)
                                          _Field-trig._File-Recid = RECID(_File)        
                                          _Field-Trig._Event = as4dict.p__trgfd._event
                                          _Field-Trig._Override = (If as4dict.p__trgfd._Override = "Y" then yes else no)
                                          _Field-Trig._Proc-name = as4dict.p__trgfd._Proc-name.              
                    END.
                END.       /* Field Trigger Loop */
            END.  /*  Field Update Loop  */
        END. /* For each p__field loop */
       
        /*  Field Delete Loop  */    
        IF user_env[1] <> "add" THEN 
        FOR EACH _field OF _file:             
            FIND as4dict.p__field WHERE as4dict.p__field._field-name = _field._field-name
                    AND as4dict.p__field._file-number = as4dict.p__file._file-number NO-LOCK NO-ERROR.
            IF NOT AVAILABLE(as4dict.p__field) THEN DO:
                FOR EACH _Field-trig of _Field:             
                    Delete _Field-trig.  
                END.                    
                DELETE _field.
            END.
        END.   /* Delete Field Loop */
   
        /*------------------------- _Index processing ----------------------------*/
        /* Table Index Loop: p__index.   */ 
        FOR EACH as4dict.p__index WHERE as4dict.p__index._file-number = as4dict.p__file._file-number NO-LOCK:
            FIND _index of _file WHERE _index._index-name = as4dict.p__index._index-name NO-ERROR.
            IF AVAILABLE _index THEN DO: 
                IF _Index._I-Misc1[4] = as4dict.P__Index._I-Misc1[4]  AND NOT dofield THEN DO:                  
                  /* Index has not be re-created only active may have been changed*/  
                  IF as4dict.p__Index._Active = "Y" AND NOT _Index._Active THEN DO:
                    FOR EACH _index-field of _Index:
                        DELETE _index-field.
                    END.
                    DELETE _index.              
                    CREATE _index.
                    ASSIGN _Index._Index-name          = as4dict.p__index._Index-name
                           _Index._File-recid          = RECID(_file)
                           _Index._ianum               = 6
                           _Index._Idx-num             = as4dict.p__Index._Idx-num.
                    { as4dict/as4synix.i }         
                    
                    IF as4dict.p__file._Prime-Index = as4dict.p__Index._idx-num  THEN
                       ASSIGN _file._Prime-Index = RECID(_Index).
  
                                      /* Add _index field record */
                    FOR EACH as4dict.p__idxfd WHERE  as4dict.p__idxfd._File-number = as4dict.p__Index._File-number 
                                    AND as4dict.p__idxfd._Idx-num = as4dict.p__Index._idx-num NO-LOCK: 
      
                      IF as4dict.p__idxfd._IF-misc2[8] = "Y" THEN NEXT.
                      CREATE _Index-Field.    
                      ASSIGN _Index-Field._Index-Recid = RECID(_Index).
                        { as4dict/as4synxf.i }         
                    END.      
                  END.  
                END.                    
                ELSE DO:
                    /* Index was deleted and re-created with same name  or p__files were re-created*/           
                    IF user_env[34] <> "batch" THEN  DISPLAY as4dict.p__index._index-name with frame working.

                    FOR EACH _index-field of _Index:
                        DELETE _index-field.
                    END.
                    DELETE _index.              
                    CREATE _index.
                    ASSIGN _Index._Index-name          = as4dict.p__index._Index-name
                           _Index._File-recid          = RECID(_file)
                           _Index._ianum               = 6
                           _Index._Idx-num             = as4dict.p__Index._Idx-num.
                    { as4dict/as4synix.i }         
                    
                    IF as4dict.p__file._Prime-Index = as4dict.p__Index._idx-num  THEN
                          ASSIGN _file._Prime-Index = RECID(_Index).
  
                                      /* Add _index field record */
                    FOR EACH as4dict.p__idxfd WHERE  as4dict.p__idxfd._File-number = as4dict.p__Index._File-number 
                                    AND as4dict.p__idxfd._Idx-num = as4dict.p__Index._idx-num NO-LOCK: 
      
                        IF as4dict.p__idxfd._IF-misc2[8] = "Y" THEN NEXT.
                        CREATE _Index-Field.    
                        ASSIGN _Index-Field._Index-Recid = RECID(_Index).
                        { as4dict/as4synxf.i }         
                    END.      
                END.  
            END.
            ELSE DO:              /* ADD Index & Idx Fields */
                IF user_env[34] <> "batch" THEN  display as4dict.p__index._index-name with frame working.         
                CREATE _Index.
                ASSIGN _Index._Index-name          = as4dict.p__index._Index-name
                       _Index._File-Recid          = RECID(_File)
                       _Index._ianum               = 6
                       _Index._Idx-num             = as4dict.p__index._Idx-num.
                {as4dict/as4synix.i}                                       

                /* Check for primary Index */       
                IF as4dict.p__File._Prime-index = -1 THEN.
          
                ELSE IF as4dict.p__file._Prime-Index = as4dict.p__Index._idx-num  THEN
                          _file._Prime-Index = RECID(_Index).  
          
                /* Add _index field record */
                FOR EACH as4dict.p__idxfd WHERE as4dict.p__idxfd._File-number = as4dict.p__Index._File-number   
                                      AND as4dict.p__idxfd._Idx-num = as4dict.p__Index._idx-num NO-LOCK: 
                    IF as4dict.p__idxfd._IF-misc2[8] = "Y" THEN NEXT.
                    CREATE _Index-Field.
                    ASSIGN _Index-Field._Index-Recid = RECID(_Index).
                    {as4dict/as4synxf.i}         
                END.    
            END. /* add new index */  
        END.  /* Index Loop */

                         /* Index Delete Loop. */
        IF user_env[1] <> "add"  AND as4dict.p__File._Prime-index > 0 THEN  
        FOR EACH _Index of _File:        
            FIND as4dict.p__Index WHERE as4dict.p__Index._Index-Name = _Index._Index-Name AND
                as4dict.p__Index._File-number = as4dict.p__file._File-Number NO-LOCK NO-ERROR.
            IF NOT AVAILABLE (as4dict.p__Index) THEN DO:
                FOR EACH _Index-Field of _Index:
                    Delete _Index-Field. 
                END.
                DELETE _Index. 
            END.           
        END.   /* Delete Index Loop */
          
              /* File Trigger Update Loop:  p__trgfl  can's update triggers must delete and recreate */
        FOR EACH as4dict.p__Trgfl WHERE as4dict.p__Trgfl._File-number = as4dict.p__file._file-number NO-LOCK: 
            FIND _File-Trig of _file where _File-Trig._Event = as4dict.p__Trgfl._Event NO-ERROR.
            IF AVAILABLE (_File-Trig) THEN DO:

              DELETE _File-trig.
              CREATE _file-trig.
              ASSIGN _File-Trig._File-recid = RECID(_file)                                         
                     _File-Trig._Override =
                                (If as4dict.p__trgfl._Override = "Y" then yes else no)  
                     _File-Trig._Proc-name = as4dict.p__trgfl._Proc-name.  
    
              CASE as4dict.p__Trgfl._Event:
                WHEN "CREATE" OR WHEN "DELETE" OR WHEN "WRITE" OR WHEN "FIND" THEN
                  ASSIGN _File-trig._Event = as4dict.p__trgfl._Event.
                WHEN "RCREAT" THEN
                  ASSIGN _File-Trig._Event = "REPLICATION-CREATE".
                WHEN "RDELET" THEN
                  ASSIGN _File-trig._Event = "REPLICATION-DELETE".
                WHEN "RWRITE" THEN
                  ASSIGN _File-trig._Event = "REPLICATION-WRITE".
              END CASE.                                      
            END.                          
            ELSE DO:
              CREATE _File-Trig.
              ASSIGN _File-Trig._File-recid = RECID(_file)         
                     _File-Trig._Override =
                                (If as4dict.p__trgfl._Override = "Y" then yes else no)  
                     _File-Trig._Proc-name = as4dict.p__trgfl._Proc-name.  
                             
              CASE as4dict.p__Trgfl._Event:
                WHEN "CREATE" OR WHEN "DELETE" OR WHEN "WRITE" OR WHEN "FIND" THEN
                  ASSIGN _File-trig._Event = as4dict.p__trgfl._Event.
                WHEN "RCREAT" THEN
                  ASSIGN _File-Trig._Event = "REPLICATION-CREATE".
                WHEN "RDELET" THEN
                  ASSIGN _File-trig._Event = "REPLICATION-DELETE".
                WHEN "RWRITE" THEN
                  ASSIGN _File-trig._Event = "REPLICATION-WRITE".
              END CASE.                     
            END.  
        END.        /* File Trigger Update Loop.  */              
    
        /*  Check for deleted File Trigger   */
        IF user_env[1] <> "add" THEN FOR EACH _File-Trig of _File:
          CASE _File-Trig._Event:
            WHEN "CREATE" OR WHEN "DELETE" OR WHEN "WRITE"  OR WHEN "FIND" THEN DO: 
              FIND as4dict.p__Trgfl WHERE as4dict.p__Trgfl._Event = _File-Trig._Event AND
                         as4dict.p__Trgfl._File-number = as4dict.p__File._File-Number NO-LOCK NO-ERROR.
              IF NOT AVAILABLE (as4dict.p__Trgfl) THEN 
                 DELETE _File-Trig. 
            END.
            WHEN "REPLICATION-CREATE" THEN DO:
              FIND as4dict.p__Trgfl WHERE as4dict.p__Trgfl._Event = "RCREAT" 
                                      AND as4dict.p__Trgfl._File-number = as4dict.p__File._File-Number 
                                      NO-LOCK NO-ERROR.
              IF NOT AVAILABLE (as4dict.p__Trgfl) THEN 
                 DELETE _File-Trig. 
            END.
            WHEN "REPLICATION-DELETE" THEN DO:
              FIND as4dict.p__Trgfl WHERE as4dict.p__Trgfl._Event = "RDELET" 
                                      AND as4dict.p__Trgfl._File-number = as4dict.p__File._File-Number 
                                      NO-LOCK NO-ERROR.
              IF NOT AVAILABLE (as4dict.p__Trgfl) THEN 
                 DELETE _File-Trig. 
            END.
            WHEN "REPLICATION-WRITE" THEN DO:
              FIND as4dict.p__Trgfl WHERE as4dict.p__Trgfl._Event = "RWRITE" 
                                      AND as4dict.p__Trgfl._File-number = as4dict.p__File._File-Number 
                                      NO-LOCK NO-ERROR.
              IF NOT AVAILABLE (as4dict.p__Trgfl) THEN 
                 DELETE _File-Trig. 
            END.
          END CASE.
        END.   /* Delete File Trigger Loop */        
        IF user_env[34] <> "batch" THEN  DISPLAY "" @ as4dict.p__Index._Index-name WITH FRAME working.

        /* Must assign here else client will not allow the schema to be built for new file */
        ASSIGN _File._Frozen = (IF as4dict.p__File._Frozen = "Y" THEN TRUE ELSE FALSE).

        RELEASE _File.    



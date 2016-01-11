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
/* File: _schsync.p
     Created:  12/18/95 D. McMann
     Modify:   05/06/96 D. McMann - reduced the size of the frame
                        since AIX has a problem.
               10/25/96 D. McMann Added assign of _Frozen. 
               06/26/97 D. McMann Added word index support        

Description:
      This program synchronizes a server schema which resides
      on the AS/400 with schema in temporary tables on the 
      client which have been loaded via the PROGRESS/400 load
      procedures.  This procedure is called only if the server
      schema was empty and all information was loaded on the client.  

*/

/*===========================  Main Line Code  ===========================*/
{ as4dict/dictvar.i  SHARED}
{ as4dict/load/loaddefs.i }

DEFINE VARIABLE oxlname AS CHARACTER             NO-UNDO.  
DEFINE VARIABLE dofield AS LOGICAL               NO-UNDO. 
DEFINE VARIABLE answer  AS LOGICAL INITIAL FALSE NO-UNDO.  
DEFINE VARIABLE errcode AS INTEGER NO-UNDO.        
DEFINE VARIABLE insync    AS CHARACTER              NO-UNDO.
DEFINE VARIABLE ctlbrk     AS LOGICAL INITIAL TRUE.    
DEFINE VARIABLE fromdict AS logical initial false  NO-UNDO.

/* defines for dumpname.i */
DEFINE VARIABLE nam  AS CHARACTER NO-UNDO.
DEFINE VARIABLE pass AS INTEGER   NO-UNDO.
           

FORM    
    as4dict.p__db._Db-name LABEL "Database" COLON 15 FORMAT "x(32)":u SKIP
  wtp__File._File-name  LABEL "Table"    COLON 15 FORMAT "x(32)":u SKIP
  wtp__Field._Field-name LABEL "Field"    COLON 15 FORMAT "x(32)":u SKIP
  wtp__Index._Index-name LABEL "Index"    COLON 15 FORMAT "x(32)":u SKIP 
  HEADER 
    "    Final Stage of Loading DB2/400 Definitions.......                     "
  WITH FRAME ldschema  OVERLAY THREE-D VIEW-AS DIALOG-BOX
  ROW 4 CENTERED USE-TEXT SIDE-LABELS.

   
COLOR DISPLAY MESSAGES
        as4dict.p__db._Db-name wtp__File._File-name wtp__Field._Field-name
        wtp__Index._Index-name 
WITH FRAME ldschema.
    
SESSION:IMMEDIATE-DISPLAY = YES.      

 run adecomm/_setcurs.p ("wait").               
 
FIND FIRST as4dict.p__db NO-LOCK.
DISPLAY as4dict.p__db._Db-name WITH FRAME  ldschema.       

  _uploop:
DO ON ERROR UNDO,LEAVE _uploop:          
        
    /*------------------------ _File processing ------------------------------*/
    /* File Loop for each table in the database.  Fields, 
    File Triggers, and Indices will be processed within. p__file */
  
    _fileloop:
    FOR EACH wtp__file NO-LOCK :            
        IF wtp__File._File-name = "qcmd" THEN NEXT _fileloop.                                        
   
        Display wtp__file._file-name with frame ldschema.  /* MODIFY Table */
 
        CREATE as4dict.p__file.                                                                       
        ASSIGN as4dict.p__file._file-name   = wtp__file._file-name
                         as4dict.p__file._DB-recid    = 1     
                         as4dict.p__file._file-number = wtp__file._File-number
                         as4dict.p__file._Dump-name = wtp__File._Dump-name  
                         as4dict.p__file._AS4-FIle = wtp__file._AS4-file
                         as4dict.p__File._AS4-Library = wtp__File._As4-Library
                         as4dict.p__file._for-name       =     wtp__file._for-name       
                         as4dict.p__file._for-number = wtp__file._For-number 
                         as4dict.p__File._Can-create = wtp__file._Can-create 
                         as4dict.p__File._Can-delete = wtp__file._Can-delete 
                         as4dict.p__File._Can-read = wtp__file._Can-read    
                         as4dict.p__File._Can-write = wtp__file._Can-write   
                         as4dict.p__File._Prime-Index = wtp__file._Prime-Index 
                         as4dict.p__file._Desc           =     wtp__file._Desc
                         as4dict.p__file._dft-pk         = wtp__file._dft-pk 
                         as4dict.p__file._Fil-Misc1[1]   =     wtp__file._Fil-Misc1[1] 
                         as4dict.p__file._Fil-Misc1[2]   =     wtp__file._Fil-Misc1[2]  
                         as4dict.p__file._Fil-Misc1[3]   =     wtp__file._Fil-Misc1[3]
                         as4dict.p__file._Fil-Misc1[4]   =     wtp__file._Fil-Misc1[4]
                         as4dict.p__file._Fil-Misc1[5]   =     wtp__file._Fil-Misc1[5]
                         as4dict.p__file._Fil-Misc1[6]   =     wtp__file._Fil-Misc1[6]  
                         as4dict.p__file._Fil-Misc1[7]   =     wtp__file._Fil-Misc1[7]
                         as4dict.p__file._Fil-Misc1[8]   =     wtp__file._Fil-Misc1[8]
                         as4dict.p__file._Fil-Misc2[1]   =     wtp__file._Fil-Misc2[1]
                         as4dict.p__file._Fil-Misc2[2]   =     wtp__file._Fil-Misc2[2]
                         as4dict.p__file._Fil-Misc2[3]   =     wtp__file._Fil-Misc2[3]
                         as4dict.p__file._Fil-Misc2[4]   =     wtp__file._Fil-Misc2[4]
                         as4dict.p__file._Fil-Misc2[5]   =     wtp__file._Fil-Misc2[5]
                         as4dict.p__file._Fil-Misc2[6]   =     wtp__file._Fil-Misc2[6]
                         as4dict.p__file._Fil-Misc2[7]   =     wtp__file._Fil-Misc2[7]
                         as4dict.p__file._Fil-Misc2[8]   =     wtp__file._Fil-Misc2[8] 
                         as4dict.p__File._Fil-Res1[2] = wtp__File._Fil-res1[2]
                         as4dict.p__File._Fil-Res1[5] = wtp__File._Fil-res1[5]
                         as4dict.p__file._File-Label     =     wtp__file._File-Label
                         as4dict.p__file._File-Label-SA  =   wtp__file._File-Label-SA 
                         as4dict.p__file._For-Format     =     wtp__file._For-Format
                         as4dict.p__file._For-Info       =     wtp__file._For-Info
                         as4dict.p__file._For-Number     =     wtp__file._For-Number
                         as4dict.p__File._Frozen         =     wtp__File._Frozen
                         as4dict.p__file._Hidden         = wtp__file._Hidden    
                         as4dict.p__File._numfld = wtp__file._numfld
                         as4dict.p__File._numkey = wtp__file._numkey   
                         as4dict.p__file._Prime-index    =     wtp__file._Prime-index       
                         as4dict.p__file._Valexp         =     wtp__file._Valexp
                         as4dict.p__file._Valmsg         =     wtp__file._Valmsg
                          as4dict.p__file._Valmsg-SA      =     wtp__file._Valmsg-SA. 
       

        /*----------------------- _Field processing ------------------------------*/
        /* Field Loop: p__field  */
        FOR EACH wtp__field WHERE wtp__field._file-number = wtp__file._file-number 
                       USE-INDEX p__Fieldl0 NO-LOCK:   
              DISPLAY wtp__field._field-name with frame ldschema.                               
              CREATE as4dict.p__field.
              ASSIGN as4dict.p__field._field-name = wtp__field._field-name     
                                as4dict.p__Field._Fld-number = wtp__field._Fld-number
                               as4dict.p__field._file-number = wtp__field._File-number  
                               as4dict.p__field._AS4-File = wtp__Field._AS4-File
                               as4dict.p__Field._AS4-Library = wtp__Field._AS4-Library    
                               as4dict.p__field._Can-read = wtp__Field._Can-read
                               as4dict.p__Field._Can-write = wtp__Field._Can-write
                                as4dict.p__field._For-name = wtp__Field._For-name
                                as4dict.p__field._Col-Label = wtp__Field._Col-Label
                                as4dict.p__field._Col-Label-SA = wtp__Field._Col-Label-SA
                                as4dict.p__field._Decimals = wtp__Field._Decimals
                                as4dict.p__field._Data-Type = wtp__Field._Data-Type
                                as4dict.p__field._Desc  =  wtp__Field._Desc
                                 as4dict.p__field._Extent = wtp__Field._Extent
                                 as4dict.p__field._Fld-case = wtp__Field._Fld-case 
                                as4dict.p__field._Fld-Misc1[1]   =     wtp__Field._Fld-Misc1[1]
                                 as4dict.p__field._Fld-Misc1[2]   =     wtp__Field._Fld-Misc1[2]     
                                as4dict.p__field._Fld-Misc1[3]   =     wtp__Field._Fld-Misc1[3]   
                                as4dict.p__field._Fld-Misc1[4]   =     wtp__Field._Fld-Misc1[4]   
                                as4dict.p__field._Fld-Misc1[5]   =     wtp__Field._Fld-Misc1[5]  
                                as4dict.p__field._Fld-Misc1[6]   =     wtp__Field._Fld-Misc1[6]  
                                as4dict.p__field._Fld-Misc1[7]   =     wtp__Field._Fld-Misc1[7] 
                                as4dict.p__field._Fld-Misc1[8]   =     wtp__Field._Fld-Misc1[8]   
                                 as4dict.p__field._Fld-Misc2[1]   =     wtp__Field._Fld-Misc2[1]    
                                as4dict.p__field._Fld-Misc2[2]   =     wtp__Field._Fld-Misc2[2]   
                                as4dict.p__field._Fld-Misc2[3]   =     wtp__Field._Fld-Misc2[3]   
                                as4dict.p__field._Fld-Misc2[4]   =     wtp__Field._Fld-Misc2[4]   
                                as4dict.p__field._Fld-Misc2[5]   =     wtp__Field._Fld-Misc2[5]  
                                as4dict.p__field._Fld-Misc2[6]   =     wtp__Field._Fld-Misc2[6] 
                                as4dict.p__field._Fld-Misc2[7]   =     wtp__Field._Fld-Misc2[7]  
                                as4dict.p__field._Fld-Misc2[8]   =     wtp__Field._Fld-Misc2[8]
                                as4dict.p__field._Fld-stdtype    =    wtp__Field._Fld-stdtype
                                as4dict.p__field._Fld-stlen      =    wtp__Field._Fld-stlen
                                 as4dict.p__field._For-allocated  =     wtp__Field._For-allocated
                                as4dict.p__field._For-Id         =     wtp__Field._For-Id
                                 as4dict.p__field._For-Maxsize    =     wtp__Field._For-Maxsize
                                as4dict.p__field._For-Scale      =     wtp__Field._For-Scale
                                as4dict.p__field._For-Separator      =     wtp__Field._For-Separator
                                 as4dict.p__field._For-Spacing       =     wtp__Field._For-Spacing
                                as4dict.p__field._For-Type       =     wtp__Field._For-Type
                                as4dict.p__field._Format         =     wtp__Field._Format
                                as4dict.p__field._Format-SA      =     wtp__Field._Format-SA
                                as4dict.p__field._Help           =     wtp__Field._Help
                                as4dict.p__field._Help-SA      =     wtp__Field._Help-SA
                                as4dict.p__field._Initial =  wtp__Field._Initial
                                as4dict.p__field._Initial-SA      =     wtp__Field._Initial-SA
                                as4dict.p__field._Label     =     wtp__Field._Label     
                                as4dict.p__Field._Label-SA = wtp__Field._Label-SA
                                as4dict.p__field._Mandatory = wtp__Field._Mandatory 
                                as4dict.p__field._Order         =     wtp__Field._Order
                                as4dict.p__field._Valexp         =     wtp__Field._Valexp
                                as4dict.p__field._Valmsg         =     wtp__Field._Valmsg
                                as4dict.p__field._Valmsg-SA      =     wtp__Field._Valmsg-SA
                                as4dict.p__field._View-As         =     wtp__Field._View-As.
        
       
                 /* Field Trigger Loop:  p__trgfd */
            FOR EACH wtp__trgfd WHERE   wtp__trgfd._File-number = wtp__Field._File-number
                                                                AND wtp__trgfd._fld-number = wtp__Field._fld-number NO-LOCK:
 
                CREATE as4dict.p__trgfd.
                 ASSIGN  as4dict.p__trgfd._Fld-number = wtp__trgfd._Fld-number
                                   as4dict.p__trgfd._File-number = wtp__trgfd._File-number        
                                   as4dict.p__trgfd._Event = wtp__trgfd._event
                                   as4dict.p__trgfd._Override = wtp__trgfd._Override 
                                   as4dict.p__trgfd._Proc-name = wtp__trgfd._Proc-name.              
        
                END.       /* Field Trigger Loop */
        END. /* For each p__field loop */
  
   
        /*------------------------- _Index processing ----------------------------*/
        /* Table Index Loop: p__index.   */ 
        FOR EACH wtp__index WHERE wtp__index._file-number = wtp__file._file-number NO-LOCK:
                DISPLAY wtp__index._index-name with frame ldschema.         
                CREATE as4dict.p__Index.
                ASSIGN as4dict.p__Index._Index-name = wtp__index._Index-name
                                as4dict.p__Index._File-number = wtp__Index._File-number   
                                as4dict.p__Index._AS4-FIle = wtp__Index._AS4-File
                                as4dict.p__Index._AS4-Library = wtp__Index._AS4-Library
                                as4dict.p__Index._Idx-num = wtp__index._Idx-num  
                                as4dict.p__Index._num-comp = wtp__Index._num-comp
                                as4dict.p__Index._Active = wtp__Index._Active 
                                as4dict.p__Index._Desc  =  wtp__Index._Desc
                                as4dict.p__Index._For-name = wtp__Index._For-name
                                 as4dict.p__Index._For-Type       =     wtp__Index._For-type
                                 as4dict.p__Index._I-Misc1[1]   =     wtp__Index._I-Misc1[1]
                                as4dict.p__Index._I-Misc1[2]   =     wtp__Index._I-Misc1[2]
                                as4dict.p__Index._I-Misc1[3]   =     wtp__Index._I-Misc1[3]
                                 as4dict.p__Index._I-Misc1[4]   =     wtp__Index._I-Misc1[4]
                                as4dict.p__Index._I-Misc1[5]   =     wtp__Index._I-Misc1[5]
                                as4dict.p__Index._I-Misc1[6]   =     wtp__Index._I-Misc1[6]
                                as4dict.p__Index._I-Misc1[7]   =     wtp__Index._I-Misc1[7]
                                as4dict.p__Index._I-Misc1[8]   =     wtp__Index._I-Misc1[8]
                                as4dict.p__Index._I-Misc2[1]   =     wtp__Index._I-Misc2[1]
                                as4dict.p__Index._I-Misc2[2]   =     wtp__Index._I-Misc2[2]
                                as4dict.p__Index._I-Misc2[3]   =     wtp__Index._I-Misc2[3]
                                as4dict.p__Index._I-Misc2[4]   =     wtp__Index._I-Misc2[4]
                                as4dict.p__Index._I-Misc2[5]   =     wtp__Index._I-Misc2[5]
                                as4dict.p__Index._I-Misc2[6]   =     wtp__Index._I-Misc2[6]
                                as4dict.p__Index._I-Misc2[7]   =     wtp__Index._I-Misc2[7]
                                as4dict.p__Index._I-Misc2[8]   =     wtp__Index._I-Misc2[8]
                                as4dict.p__Index._Unique       =     wtp__Index._Unique      
                                as4dict.p__Index._Wordidx      =     wtp__Index._Wordidx
                                as4dict.p__Index._I-Res1[1]    = wtp__Index._I-Res1[1].
  
                /* Add _index field record */
                FOR EACH wtp__idxfd WHERE wtp__idxfd._File-number = wtp__Index._File-number   
                                      AND wtp__idxfd._Idx-num = wtp__Index._idx-num NO-LOCK: 

                    FIND wtp__field where wtp__field._fld-number = wtp__idxfd._fld-number 
                        AND wtp__Field._File-number = wtp__idxfd._File-number NO-ERROR.
    
                    CREATE as4dict.p__Idxfd.
                     ASSIGN as4dict.p__Idxfd._Fld-number = wtp__Idxfd._Fld-number   
                                      as4dict.p__Idxfd._field-recid = wtp__Idxfd._Fld-number   
                                      as4dict.p__Idxfd._File-number = wtp__Idxfd._File-number
                                      as4dict.p__Idxfd._Idx-num = wtp__Idxfd._Idx-num
                                      as4dict.p__Idxfd._AS4-file = wtp__Idxfd._AS4-file  
                                      as4dict.p__Idxfd._AS4-Library = wtp__Idxfd._AS4-Library
                                        as4dict.p__Idxfd._Ascending = wtp__idxfd._Ascending 
                                        as4dict.p__Idxfd._Abbreviate = wtp__idxfd._Abbreviate 
                                        as4dict.p__Idxfd._Index-seq = wtp__idxfd._Index-seq
                                        as4dict.p__Idxfd._IF-misc1[1] = wtp__idxfd._If-misc1[1]
                                        as4dict.p__Idxfd._IF-misc1[2] = wtp__idxfd._If-misc1[2]
                                        as4dict.p__Idxfd._IF-misc1[3] = wtp__idxfd._If-misc1[3]
                                        as4dict.p__Idxfd._IF-misc1[4] = wtp__idxfd._If-misc1[4]
                                        as4dict.p__Idxfd._IF-misc1[5] = wtp__idxfd._If-misc1[5]
                                        as4dict.p__Idxfd._IF-misc1[6] = wtp__idxfd._If-misc1[6]
                                        as4dict.p__Idxfd._IF-misc1[7] = wtp__idxfd._If-misc1[7]
                                        as4dict.p__Idxfd._IF-misc1[8] = wtp__idxfd._If-misc1[8]
                                        as4dict.p__Idxfd._IF-misc2[1] = wtp__idxfd._If-misc2[1]
                                        as4dict.p__Idxfd._IF-misc2[2] = wtp__idxfd._If-misc2[2]
                                        as4dict.p__Idxfd._IF-misc2[3] = wtp__idxfd._If-misc2[3]
                                        as4dict.p__Idxfd._IF-misc2[4] = wtp__idxfd._If-misc2[4]
                                        as4dict.p__Idxfd._IF-misc2[5] = wtp__idxfd._If-misc2[5]
                                        as4dict.p__Idxfd._IF-misc2[6] = wtp__idxfd._If-misc2[6]
                                        as4dict.p__Idxfd._IF-misc2[7] = wtp__idxfd._If-misc2[7]
                                        as4dict.p__Idxfd._IF-misc2[8] = wtp__idxfd._If-misc2[8].    
                END.    
            END. /* add new index */  

          
              /* File Trigger Update Loop:  p__trgfl  can's update triggers must delete and recreate */
        FOR EACH wtp__Trgfl WHERE wtp__Trgfl._File-number = wtp__file._file-number NO-LOCK: 
 
                CREATE as4dict.p__trgfl.
                ASSIGN as4dict.p__trgfl._File-number = wtp__Trgfl._File-number         
                                as4dict.p__trgfl._Event = wtp__Trgfl._Event
                                as4dict.p__trgfl._Override = wtp__trgfl._Override 
                                as4dict.p__trgfl._Proc-name = wtp__trgfl._Proc-name.      
         
        END.        /* File Trigger Update Loop.  */              
  
        DISPLAY "" @   wtp__Index._Index-name WITH FRAME ldschema.
       
    END.        /* File Loop  */             
END.          
run adecomm/_setcurs.p ("").
HIDE FRAME ldschema NO-PAUSE.             
RETURN.




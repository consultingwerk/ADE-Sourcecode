/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/gat-mdi1.i

Description:
    
    saves the index-information in the temptables w_index & w_index-field
        
Text-Parameters:
    none

Output-Parameters:
    none
    
Included in:
    odb/_odb_mak.p
    ora/_ora6mak.p
    ora/_ora7mak.p
    rdb/_rdb_mak.p
    syb/_syb_mak.p
    
Author: Tom Hutegger

History:
    hutegger    94/07/20    creation
    
--------------------------------------------------------------------*/        
/*h-*/

    FOR EACH DICTDB._Index OF DICTDB._File:
      FOR EACH DICTDB._Index-field OF DICTDB._Index:
        FIND FIRST DICTDB._Field of DICTDB._Index-field.
        CREATE w_index-field.
        ASSIGN
          w_index-field.pro_Abbreviate = DICTDB._index-field._Abbreviate
          w_index-field.pro_Ascending  = DICTDB._index-field._Ascending
          w_index-field.pro_For-name   = DICTDB._field._For-name
          w_index-field.pro_idx-num    = DICTDB._index._idx-num   
          w_index-field.pro_Index-Seq  = DICTDB._index-field._Index-Seq
          w_index-field.pro_Unsorted   = DICTDB._index-field._Unsorted.
        DELETE DICTDB._Index-field.
      END.
      IF DICTDB._File._Prime-Index = RECID(DICTDB._Index) 
        THEN ASSIGN
          tab_PrimeIdx = DICTDB._Index._Index-name
          tab_PIForNum = DICTDB._index._idx-num.
      CREATE w_index.
      ASSIGN
        w_index.pro_active     = DICTDB._index._active  
        w_index.pro_Desc       = DICTDB._index._Desc  
        w_index.pro_For-Name   = DICTDB._index._For-Name  
        w_index.pro_idx-num    = DICTDB._index._idx-num  
        w_index.pro_Index-Name = DICTDB._index._Index-Name  
        w_index.pro_WordIdx    = DICTDB._index._WordIdx  
        w_index.pro_Unique     = DICTDB._index._Unique
        tab_RecidIdx           = ( IF DICTDB._index._I-misc2[1] begins "r"
                                    THEN DICTDB._index._For-Name
                                    ELSE tab_RecidIdx
                                 )
        tab_RIType             = ( IF DICTDB._index._I-misc2[1] begins "r"
                                    THEN DICTDB._index._I-misc2[1]
                                    ELSE tab_RIType
                                 ). 
      DELETE DICTDB._Index.
    END.

/*------------------------------------------------------------------*/        

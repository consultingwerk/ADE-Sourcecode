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

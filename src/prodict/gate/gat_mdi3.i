/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/gat-mdi3.i

Description:
    
    tries to recreate the indexes which were entered by the user using
    PROGRESS-DataDictionary and also gets rid of "left-over", old,
    "foreign" indexes
        
Text-Parameters:
    &for-obj-name    name of the name-field (sybase_objects.name, ...)

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

  /* delete all left-over, old, "foreign" indexes */
  FOR EACH w_index
    WHERE w_index.pro_for-name <> ""
    AND   w_index.pro_for-name <> ?:
    FOR EACH w_index-field
      WHERE  w_index-field.pro_idx-num = w_index.pro_idx-num:
      DELETE w_index-field.
      END.
    DELETE w_index.  
    END.

 /* try to recreate all old, "USER-defined" indexes */
  FOR EACH w_index:

    ASSIGN scrap = true.
    FOR EACH w_index-field
      WHERE  w_index-field.pro_idx-num = w_index.pro_idx-num
      WHILE scrap = true:
      FIND FIRST DICTDB._field of DICTDB._File
        WHERE DICTDB._field._for-name = w_index-field.pro_for-name
        NO-LOCK NO-ERROR.
      IF NOT AVAILABLE DICTDB._field THEN ASSIGN scrap = false.
      END.
      
    IF NOT scrap  
     THEN FOR EACH w_index-field  /* index not valid anymore */
      WHERE  w_index-field.pro_idx-num = w_index.pro_idx-num: 
      DELETE w_index-field.
      END.

     ELSE DO:  /* retain index */

      ASSIGN user_env[1] = w_index.pro_index-name.
      RUN "prodict/gate/_gat_xlt.p"
          (FALSE,RECID(DICTDB._File),INPUT-OUTPUT user_env[1]).

      IF user_env[1] <> w_index.pro_index-name
       THEN DO:

        IF trig-reass = false
         THEN DO:
          assign trig-reass = true.
          output stream stm_errors to ds_upd.e.
          output stream stm_errors close.
          END.

        output stream stm_errors to ds_upd.e append.
        PUT stream stm_errors unformatted
          "Index name changed from " 
          w_index.pro_index-name " to " user_env[1]   skip.
        output stream stm_errors close.

        END.                            
         
      CREATE DICTDB._Index.
      ASSIGN
        DICTDB._Index._Index-Name = user_env[1]
        DICTDB._Index._File-recid = RECID(DICTDB._File)
        DICTDB._Index._Unique     = w_index.pro_unique
        DICTDB._Index._For-name   = ""
        DICTDB._Index._Idx-num    = indn
        DICTDB._Index._Active     = w_index.pro_active
        DICTDB._Index._WordIdx    = w_index.pro_WordIdx
        DICTDB._Index._Desc       = w_index.pro_Desc
        indn                      = indn + 1
        keycp                     = 1.

      IF tab_PIForNum = w_index.pro_idx-num
        THEN ASSIGN DICTDB._File._Prime-Index = RECID(DICTDB._Index).
     
      FOR EACH w_index-field  
        WHERE  w_index-field.pro_idx-num = w_index.pro_idx-num: 
        
        FIND FIRST DICTDB._field of DICTDB._File
          WHERE DICTDB._field._for-name = w_index-field.pro_for-name
          NO-LOCK NO-ERROR.
        CREATE DICTDB._Index-field.
        ASSIGN
          DICTDB._Index-Field._Index-recid = RECID(DICTDB._Index)
          DICTDB._Index-Field._Index-Seq   = keycp
          DICTDB._Index-Field._Field-recid = RECID(DICTDB._Field)
          DICTDB._Index-Field._Ascending   = w_index-field.pro_Ascending
          DICTDB._Index-Field._Abbreviate  = w_index-field.pro_Abbreviate
          DICTDB._Index-Field._Unsorted    = w_index-field.pro_Unsorted
          keycp                            = keycp + 1.
        DELETE w_index-field.

        END.     /* for each w_index-field */
       
      END.     /* retain index */
       
    DELETE w_index.  
    
    END.  /* for each w_index */

/*------------------------------------------------------------------*/        

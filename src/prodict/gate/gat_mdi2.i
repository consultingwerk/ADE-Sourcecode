/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/gat-mdi2.i

Description:
    
    tries to use saved index-information for the currently created index
        
Text-Parameters:
    &for-idx-name    name of the name-field (for example:
                     sybase_objects.name + STRING(indn))
    &for-idx-nam2    ev. 2 possible name of the name-field (for example:
                     sybase_objects.name + STRING(w_index.pro_idx-num))
    &for-obj-name    name of the name-field (sybase_objects.name, ...)
    &idx-uniq-cond   condition to make this index unique
                     for example: "(DICTDBG.Syabse_keys.type = 1)"
    &frame           name of the display-frame (for example: syb_mak, ...)

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

    find first w_index
      where w_index.pro_for-name = TRIM(DICTDBG.{&for-idx-name})
      NO-ERROR.
    IF NOT AVAILABLE w_index
      THEN find first w_index
        where w_index.pro_for-name = TRIM(DICTDBG.{&for-idx-nam2})
        NO-ERROR.
    IF AVAILABLE w_index
     THEN DO:
      ASSIGN 
        idx_desc    = w_index.pro_Desc
        user_env[1] = w_index.pro_index-name.
      FOR EACH w_index-field 
        WHERE  w_index-field.pro_idx-num = w_index.pro_idx-num:
        DELETE w_index-field.
        END.
      END.
     ELSE ASSIGN
      idx_desc    = ""
      user_env[1] = TRIM(DICTDBG.{&for-idx-name}).
    
    RUN "prodict/gate/_gat_xlt.p"
          (FALSE,RECID(DICTDB._File),INPUT-OUTPUT user_env[1]).

    IF TERMINAL <> "" and NOT SESSION:BATCH-MODE THEN DISPLAY
      DICTDBG.{&for-obj-name}   @ msg[5]
      user_env[1]               @ msg[6] WITH FRAME {&frame}.
      
    CREATE DICTDB._Index.
    ASSIGN
      DICTDB._Index._Index-Name = user_env[1]
      DICTDB._Index._File-recid = RECID(DICTDB._File)
      DICTDB._Index._Unique     = ( {&idx-uniq-cond} 
                                OR  ( AVAILABLE w_index 
                                AND   w_index.pro_unique ) )
      DICTDB._Index._For-name   = TRIM(DICTDBG.{&for-idx-name})
      DICTDB._Index._Idx-num    = indn
      DICTDB._Index._Active     = TRUE
      DICTDB._Index._Desc       = idx_Desc
      DICTDB._Index._I-misc2[1] = ( IF tab_RecidIdx = TRIM(DICTDBG.{&for-idx-name})
                                     THEN "x" + tab_RIType
                                     ELSE DICTDB._Index._I-misc2[1]
                                  )
      indn                      = indn + 1.

    IF    unique-prime = NO
      AND ( indn       = 2
      OR    {&idx-uniq-cond} 
      OR    ( AVAILABLE w_index 
      AND     ( w_index.pro_idx-num = tab_PIForNum
      OR        w_index.pro_unique ) ) )
      THEN ASSIGN 
        DICTDB._File._Prime-Index = RECID(DICTDB._Index)
        unique-prime              = ( {&idx-uniq-cond} 
                                  OR  ( AVAILABLE w_index
                                  AND   tab_PIForNum = w_index.pro_idx-num
                                      )
                                    ).

    IF AVAILABLE w_index
     THEN DO:  /* w_index available */
      IF  DICTDB._Index._Index-Name <> w_index.pro_index-name
       OR {&idx-uniq-cond}          <> w_index.pro_unique
       THEN DO:  /* index-name changed */
        IF trig-reass = false
         THEN DO:
          assign trig-reass = true.
          output stream stm_errors to ds_upd.e.
          output stream stm_errors close.
          END. 
        output stream stm_errors to ds_upd.e append.
        IF DICTDB._Index._Index-Name <> w_index.pro_index-name
         THEN put stream stm_errors unformatted
          "Index name changed from "
          w_index.pro_index-name " to " user_env[1] skip.
        IF {&idx-uniq-cond}          <> w_index.pro_unique
         THEN put stream stm_errors unformatted
          "Index changed from " STRING(w_index.pro_unique,"UNIQUE/NON-UNIQUE")
          " to " STRING({&idx-uniq-cond},"UNIQUE/NON-UNIQUE") skip.
        output stream stm_errors close.       
        END.     /* index-name changed */  
      delete w_index.
      END.     /* w_index available */
      

/*------------------------------------------------------------------*/

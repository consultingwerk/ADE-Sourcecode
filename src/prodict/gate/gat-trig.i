/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/gat-trig.i

Description:
    
    To Update a DICTDB._File-definition, _<gatway>_mak.p deletes the
    original DICTDB._File-record and creates a new one.
    A DICTDB._File-record can only be deleted, if there is no trigger
    assigned to it.
    
    The same way DICTDB._Fields are handled.
    
    This include-file contains internal procedures for: 
      delete DICTDB._File
      delete DICTDB._Field
      create DICTDB._File              plus
    the definitions for the temp-tables  
    
    delete DICTDB._File:  save file-trigger information in local temp-table
    delete DICTDB._Field: save field-trigger-information in local temp-table
    create DICTDB._File:  create DICTDB._File-Trig-record and 
                    DICTDB._Field-Trig-records according to the 
                    temp-table-entries.
          
    A file (name: ds_upd.e) gets created, with all the effected triggers
    listed.
     
    NOTE: the CRC gets set to ?
        
    NOTE: the value of the variable trig-reass gets used in 
    prodict/gate/gat-trgm.i
        
Text-Parameters:
    &table-name      name of the table to be created (used for error-msg)

Output-Parameters:
    none
    
Included in:
    odb/_odb_mak.p
    ora/_ora_fun.p
    ora/_ora6mak.p
    ora/ora_lkm.i   (_ora_lkm.p, _ora7mak.p)
    rdb/_rdb_mak.p
    syb/syb_makp.i  (_syb_mak.p, _syb_m10.p)
    
Author: Tom Hutegger

History:
    hutegger    95/01/26    changed schmea-triggers to internal procs
    hutegger    94/02/04    creation
    
--------------------------------------------------------------------*/
/*h-*/

/*----------------------------  DEFINES  ---------------------------*/

define variable   trig-reass  as   logical initial false.


define variable   idx_Desc     AS CHARACTER NO-UNDO. /*_Desc   */

define temp-table w_index NO-UNDO
        field     pro_Active       like DICTDB._index._Active        
        field     pro_Desc         like DICTDB._index._Desc        
     /* field     pro_File-recid   like DICTDB._index._File-recid  */
        field     pro_For-Name     like DICTDB._index._For-Name    
     /* field     pro_For-Type     like DICTDB._index._For-Type    */
     /* field     pro_I-misc1      like DICTDB._index._I-misc1     */
     /* field     pro_I-misc2      like DICTDB._index._I-misc2     */
     /* field     pro_I-res1       like DICTDB._index._I-res1      */
     /* field     pro_I-res2       like DICTDB._index._I-res2      */
        field     pro_idx-num      like DICTDB._index._idx-num     
        field     pro_Index-Name   like DICTDB._index._Index-Name  
     /* field     pro_num-comp     like DICTDB._index._num-comp    */
        field     pro_Unique       like DICTDB._index._Unique      
        field     pro_Wordidx      like DICTDB._index._Wordidx     
        INDEX upi        IS UNIQUE PRIMARY pro_idx-num
        INDEX for-name                     pro_For-Name.
define temp-table w_index-field NO-UNDO
        field     pro_Abbreviate   like DICTDB._index-field._Abbreviate  
        field     pro_Ascending    like DICTDB._index-field._Ascending   
        field     pro_For-name     like DICTDB._field._For-name 
     /* field     pro_If-misc1     like DICTDB._index-field._If-misc1  */
     /* field     pro_If-misc2     like DICTDB._index-field._If-misc2  */
     /* field     pro_If-res1      like DICTDB._index-field._If-res1   */
     /* field     pro_If-res2      like DICTDB._index-field._If-res2   */
        field     pro_idx-num      like DICTDB._index._idx-num 
        field     pro_Index-Seq    like DICTDB._index-field._Index-Seq   
        field     pro_Unsorted     like DICTDB._index-field._Unsorted 
        INDEX upi        IS UNIQUE PRIMARY pro_idx-num
                                           pro_For-name.   

define temp-table y_Tmp-File-Trig
        field     y_Event          like DICTDB._File-Trig._Event
        field     y_Proc-name      like DICTDB._File-Trig._Proc-Name
        field     y_Override       like DICTDB._File-Trig._Override
        field     y_Trig-Crc       like DICTDB._File-Trig._Trig-Crc.
        
define temp-table y_Tmp-Field-Trig
        field     y_Event          like DICTDB._Field-Trig._Event
        field     y_Proc-name      like DICTDB._Field-Trig._Proc-Name
        field     y_Override       like DICTDB._Field-Trig._Override
        field     y_Trig-Crc       like DICTDB._Field-Trig._Trig-Crc
        field     y_Field-Name     like DICTDB._Field._field-Name.
        
define stream     stm_errors.

/*-------------------  LANGUAGE DEPENDENCIES  ----------------------*/        
define variable err-msg     as character format "x(40)" extent 9
      initial [
/*  1 */ "DETACHED FILE-TRIGGER   :",
/*  2 */ "DETACHED FIELD-TRIGGER  :",
/*  3 */ "REASSIGNED FILE-TRIGGER :",
/*  4 */ "REASSIGNED FIELD-TRIGGER:",
/*  5 */ "doesn't exist anymore! Trigger cannot be reassigned!",
/*  6 */ "Please check warnings and messages in the file ""ds_upd.e""!",
/*  7 */ "",
/*  8 */ "",
/*  9 */ "Wait, or press any key to continue ..."
              ].     

/*-----------------  LANGUAGE DEPENDENCIES END  --------------------*/        
      
/*---------------------------  TRIGGERS  ---------------------------*/
PROCEDURE delete-file.

/* on delete of DICTDB._File do: */

/* in case there is no field in the first table */
  if trig-reass = false
   then do:        
    find first DICTDB._File-Trig  of DICTDB._File no-lock no-error.
    find first DICTDB._Field-Trig of DICTDB._File no-lock no-error.
    if  available DICTDB._File-Trig
     or available DICTDB._Field-Trig
     then do:  /* delete ev. old error.files & set "errors = occured" */
      assign trig-reass = true.
      output stream stm_errors to ds_upd.e.
      output stream stm_errors close.
      end.
    end.
                 
  for each DICTDB._File-Trig of DICTDB._File exclusive-lock:

    output stream stm_errors to ds_upd.e append.
    put stream stm_errors 
      err-msg[1]               format "x(26)"
      DICTDB._File._File-Name  format "x(64)"
      DICTDB._File-Trig._Event format "x(15)" 
      DICTDB._File-Trig._Proc-Name skip.
    output stream stm_errors close.

    create y_Tmp-File-Trig.
    assign
      y_Tmp-File-Trig.y_Event     = DICTDB._File-Trig._Event
      y_Tmp-File-Trig.y_Proc-name = DICTDB._File-Trig._Proc-Name
      y_Tmp-File-Trig.y_Override  = DICTDB._File-Trig._Override
      y_Tmp-File-Trig.y_Trig-Crc  = DICTDB._File-Trig._Trig-Crc.
    delete DICTDB._File-Trig.

    end.

/**/ delete DICTDB._File.

  end. /*   "delete DICTDB._File" - Trigger */

/*------------------------------------------------------------------*/        
      
PROCEDURE delete-field.

/* on delete of DICTDB._Field do:*/

  if trig-reass = false
   then do:        
    find first DICTDB._File-Trig  of DICTDB._File no-lock no-error.
    find first DICTDB._Field-Trig of DICTDB._File no-lock no-error.
    if  available DICTDB._File-Trig
     or available DICTDB._Field-Trig
     then do:  /* delete ev. old error.files & set "errors = occured" */
      assign trig-reass = true.
      output stream stm_errors to ds_upd.e.
      output stream stm_errors close.
      end.
    end.
                 
  for each DICTDB._Field-Trig of DICTDB._Field exclusive-lock:

    output stream stm_errors to ds_upd.e append.
    put stream stm_errors 
      err-msg[2]                format "x(26)" 
      DICTDB._File._File-Name 
      DICTDB._Field._Field-Name 
      DICTDB._Field-Trig._Event format "x(15)" 
      DICTDB._Field-Trig._Proc-Name skip.
    output stream stm_errors close.

    create y_Tmp-Field-Trig.
    assign
      y_Tmp-Field-Trig.y_Event      = DICTDB._Field-Trig._Event
      y_Tmp-Field-Trig.y_Proc-name  = DICTDB._Field-Trig._Proc-Name
      y_Tmp-Field-Trig.y_Override   = DICTDB._Field-Trig._Override
      y_Tmp-Field-Trig.y_Trig-Crc   = DICTDB._Field-Trig._Trig-Crc
      y_Tmp-Field-Trig.y_Field-name = DICTDB._Field._Field-Name.

    delete DICTDB._Field-Trig.

    end.

/**/ delete DICTDB._Field.

  end. /*   "delete DICTDB._Field" - Trigger */

/*------------------------------------------------------------------*/        
      
PROCEDURE create-file.

/* on create of DICTDB._File do: */
  
/**/  create DICTDB._File.
  
  for each y_Tmp-File-Trig:     

    output stream stm_errors to ds_upd.e append.
    put stream stm_errors 
      err-msg[3]            format "x(26)" 
      {&table-name}         format "x(64)"
      y_Tmp-File-Trig.y_Event format "x(15)" 
      y_Tmp-File-Trig.y_Proc-Name skip.
    output stream stm_errors close.

    create DICTDB._File-Trig.
    assign 
      DICTDB._File-Trig._File-Recid  = RECID(_File)
      DICTDB._File-Trig._Event       = y_Tmp-File-Trig.y_Event
      DICTDB._File-Trig._Proc-Name   = y_Tmp-File-Trig.y_Proc-name 
      DICTDB._File-Trig._Override    = y_Tmp-File-Trig.y_Override  
      DICTDB._File-Trig._Trig-Crc    = ?
                                    /* y_Tmp-File-Trig.y_Trig-Crc */ 
      .
    delete y_Tmp-File-Trig.

    end.        /* create all file-triggers for this file */

  end.  /* "create DICTDB._File" - Trigger */

      
/*------------------------------------------------------------------*/        
      
Procedure _Field-Triggers:

  if CAN-FIND(first y_Tmp-Field-Trig)
   then do:     /* there are field-triggers */
    
    for each y_Tmp-Field-Trig:
      
      find first DICTDB._Field of DICTDB._File
        where DICTDB._Field._Field-Name = y_Tmp-Field-Trig.y_Field-Name
        no-lock no-error.
        
      if not available DICTDB._Field    /* in case a field got dropped or */
       then do:                         /* its name got changed */

        output stream stm_errors to ds_upd.e append.
        put stream stm_errors 
          err-msg[5]                     format "x(26)" 
          DICTDB._File._File-Name 
          y_Tmp-Field-Trig.y_Field-Name  
          y_Tmp-Field-Trig.y_Event       format "x(15)" 
          y_Tmp-Field-Trig.y_Proc-Name skip.
        output stream stm_errors close.

        end.
       else do:  /* found field to reconnect trigger */ 

        output stream stm_errors to ds_upd.e append.
        put stream stm_errors 
          err-msg[4]                    format "x(26)" 
          DICTDB._File._File-Name 
          y_Tmp-Field-Trig.y_Field-Name 
          y_Tmp-Field-Trig.y_Event      format "x(15)" 
          y_Tmp-Field-Trig.y_Proc-Name skip.
        output stream stm_errors close.

        create DICTDB._Field-Trig.
        assign 
          DICTDB._Field-Trig._Field-Recid = RECID(_Field)
          DICTDB._Field-Trig._File-Recid  = RECID(_File)
          DICTDB._Field-Trig._Event       = y_Tmp-Field-Trig.y_Event
          DICTDB._Field-Trig._Proc-Name   = y_Tmp-Field-Trig.y_Proc-name 
          DICTDB._Field-Trig._Override    = y_Tmp-Field-Trig.y_Override  
          DICTDB._Field-Trig._Trig-Crc    = ?
                                         /* y_Tmp-Field-Trig.y_Trig-Crc */
          . 

        end.    /* found field to reconnect trigger */

      delete y_Tmp-Field-Trig.
            
      end.      /* create all field-triggers for this file */
      
    end.        /* there are field-triggers */
  
  end.        /* procedure _Field-Triggers */

/*------------------------------------------------------------------*/        
      

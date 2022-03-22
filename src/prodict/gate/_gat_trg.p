/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/gate/_gat_trg.p

Description:
    
    To solve the fldpos-problem we delete all triggers and recreate
    them new

    
Author: Tom Hutegger

History:
    hutegger    95/02/23    moved from ism_trg.p to gat_trg.i
    hutegger    94/08/18    creation
    
--------------------------------------------------------------------*/        
/*h-*/

define INPUT parameter p_frecid    as   RECID.

define temp-table y_Field-Trig
        field     y_Event          like DICTDB._Field-Trig._Event
        field     y_Proc-name      like DICTDB._Field-Trig._Proc-Name
        field     y_Override       like DICTDB._Field-Trig._Override
        field     y_Trig-Crc       like DICTDB._Field-Trig._Trig-Crc
        field     y_Field-Recid    like DICTDB._Field-Trig._Field-Recid.
        

for each DICTDB._Field-trig
  where DICTDB._Field-Trig._file-recid = p_frecid:

  create y_Field-Trig.
  assign
    y_Field-Trig.y_Event       = DICTDB._Field-Trig._Event
    y_Field-Trig.y_Proc-name   = DICTDB._Field-Trig._Proc-Name
    y_Field-Trig.y_Override    = DICTDB._Field-Trig._Override
    y_Field-Trig.y_Trig-Crc    = DICTDB._Field-Trig._Trig-Crc
    y_Field-Trig.y_Field-Recid = DICTDB._Field-Trig._Field-Recid.

  delete DICTDB._Field-Trig.

  end.

for each y_Field-trig:
  
  create DICTDB._Field-Trig.
  assign
    DICTDB._Field-Trig._Field-Recid = y_Field-Trig.y_Field-Recid
    DICTDB._Field-Trig._File-Recid  = p_frecid
    DICTDB._Field-Trig._Event       = y_Field-Trig.y_Event
    DICTDB._Field-Trig._Proc-name   = y_Field-Trig.y_Proc-Name
    DICTDB._Field-Trig._Override    = y_Field-Trig.y_Override
    DICTDB._Field-Trig._Trig-Crc    = y_Field-Trig.y_Trig-Crc.
  
  delete y_Field-Trig.

  end.
  
/*------------------------------------------------------------------*/        

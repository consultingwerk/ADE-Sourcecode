/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*--------------------------------------------------------------------

File: prodict/odb/odb_pulp.i

Description:
    creates the _field-definitions out of the ODBC-definitions for
    stored procedures parameters.
    
Text-Parameters:
    &data-type      Foreign data-type in PROGRESS-Notation
                    usually DICTDBG.SQLProcCols_buffer.data-type
    &extent         in the range of 0 to n
    &order-offset   gets added to the _field._order
    
Included in:            
    prodict/odb/_odb_pul.p
    
History:
    D. McMann    01/22/98   abstracted from prodict/odb/odb_pul.i

--------------------------------------------------------------------*/

 
/* this code gets executed only for the first element of array-field   */
/* so extent-code of field is always ##1 (even with real extent >= 10) */
assign
  pnam = TRIM(DICTDBG.SQLProcCols_buffer.Column-name)
  pnam = ( if {&extent} > 0 AND LENGTH (pnam, "character") > 4 /* Drop the "##1" */
             then SUBSTRING (pnam, 1, LENGTH (pnam, "character") - 3, "character")
             else pnam )
  fnam = pnam
  pnam = ( if s_ttb_tbl.ds_type = "PROCEDURE"
            and pnam begins "@"
            then substring(pnam,2,-1,"character")
            else pnam
         ).

RUN "prodict/gate/_gat_fnm.p" 
    ( INPUT        "FIELD",
      INPUT        RECID(s_ttb_tbl),
      INPUT-OUTPUT pnam).

if NOT SESSION:BATCH-MODE
 then DISPLAY
   TRIM(DICTDBG.SQLProcCols_buffer.Column-name) @ msg[3]
   pnam                                        @ msg[4]
   WITH FRAME ds_make.

assign
  dtyp    = LOOKUP({&data-type},user_env[12])
  l_init  = ?
  ntyp    = ( if dtyp = 0
                then "undefined"
                else ENTRY(dtyp,user_env[15])
            )
  l_dcml  = 0.

CREATE s_ttb_fld.

assign
  s_ttb_fld.pro_Desc    = fld-remark
  s_ttb_fld.pro_Extnt   = {&extent}
  s_ttb_fld.pro_name    = pnam
  s_ttb_fld.ttb_tbl     = RECID(s_ttb_tbl)
  s_ttb_fld.ds_prec    = DICTDBG.SQLProcCols_buffer.Precision
  s_ttb_fld.ds_scale    = DICTDBG.SQLProcCols_buffer.Scale
  s_ttb_fld.ds_lngth    = DICTDBG.SQLProcCols_buffer.Length
  s_ttb_fld.ds_radix    = DICTDBG.SQLProcCols_buffer.Radix 
  s_ttb_fld.ds_msc23    = ( if (LENGTH(quote, "character") = 1)
                             then quote + fnam + quote
                             else ?
                          )
  s_ttb_fld.ds_msc24    = fld-properties
  s_ttb_fld.ds_stoff    = field-position
  s_ttb_fld.ds_name     = fnam
  s_ttb_fld.ds_type     = {&data-type}
  s_ttb_fld.pro_order   = IF ((INDEX(UPPER(_Db._Db-misc2[5]), "DB2/400") <> 0 OR INDEX(UPPER(_Db._Db-misc2[5]), "AS/400") <> 0)) THEN
                             field-position * 10 
                          ELSE
                             field-position * 10 + 1000 
                              + {&order-offset}
  s_ttb_fld.pro_mand    = ( if CAN-DO(fld-properties, "N")
                                then false
                                else (DICTDBG.SQLProcCols_buffer.Nullable = 0)
                          ).
/*                                                             */
/* If the field is not updatable (fld-properties contains "N") */ 
/* then the field cannot be mandatory.                         */
/*                                                             */

{prodict/gate/gat_pul2.i
  &undo = "next"
  }

/*------------------------------------------------------------------*/

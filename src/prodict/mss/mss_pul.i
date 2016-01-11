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

File: prodict/mss/mss_pul.i

Description:
    creates the _field-definitions out of the ODBC-definitions
    
Text-Parameters:
    &data-type      Foreign data-type in PROGRESS-Notation
                    usually DICTDBG.SQLColumns_buffer.data-type
    &extent         in the range of 0 to n
    &order-offset   gets added to the _field._order
    
Included in:            
    prodict/mss/_mss_pul.p
    
History:
   D. McMann  03/31/00 Created from odb/odb_pul.i
   D. McMann  05/15/01 Added check for differences between precision and
                         length
   D. McMann  10/24/02 Added check for Identity field to remove mandatory flag
                       and mark _Field._Fld-Misc2[4] as "identity"

--------------------------------------------------------------------*/


/* this code gets executed only for the first element of array-field   */
/* so extent-code of field is always ##1 (even with real extent >= 10) */
assign
  pnam = TRIM(DICTDBG.SQLColumns_buffer.Column-name)
  pnam = ( if {&extent} > 0 AND LENGTH (pnam, "character") > 3 /* Drop the "##1" */
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
   TRIM(DICTDBG.SQLColumns_buffer.Column-name) @ msg[3]
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
  s_ttb_fld.ds_prec    = DICTDBG.SQLColumns_buffer.Precision
  s_ttb_fld.ds_scale    = DICTDBG.SQLColumns_buffer.Scale
  s_ttb_fld.ds_lngth    = (IF DICTDBG.SQLColumns_buffer.LENGTH > DICTDBG.SQLColumns_buffer.PRECISION 
                              THEN DICTDBG.SQLColumns_buffer.Precision
                           ELSE DICTDBG.SQLColumns_buffer.LENGTH)
  s_ttb_fld.ds_radix    = DICTDBG.SQLColumns_buffer.Radix 
  s_ttb_fld.ds_msc23    = ( if (LENGTH(quote, "character") = 1)
                             then quote + fnam + quote
                             else ?
                          )
  s_ttb_fld.ds_msc24    = fld-properties
  s_ttb_fld.ds_stoff    = field-position
  s_ttb_fld.ds_name     = fnam
  s_ttb_fld.ds_type     = {&data-type}
  s_ttb_fld.pro_order   = field-position * 10 + 1000 
                              + {&order-offset}
 s_ttb_fld.pro_mand    = ( if CAN-DO(fld-properties, "N")
                                then false
                           ELSE IF INDEX(DICTDBG.SQLColumns_buffer.Type-name,"identity") > 0 THEN
                                FALSE
                           else (DICTDBG.SQLColumns_buffer.Nullable = 0)
                          ).
/* Check field to see if identity field and mark _field-Misc2[4] as "identity" */
 IF INDEX(DICTDBG.SQLColumns_buffer.Type-name,"identity") > 0 THEN
   ASSIGN s_ttb_fld.ds_msc24 = "identity"
          s_ttb_fld.ds_itype = 1.

 IF s_ttb_Fld.ds_scale = ? THEN 
   ASSIGN s_ttb_Fld.ds_scale = 0.
   
 IF s_ttb_Fld.ds_radix = ? THEN 
   ASSIGN s_ttb_Fld.ds_radix = 0.
  
   
/*                                                             */
/* If the field is not updatable (fld-properties contains "N") */ 
/* then the field cannot be mandatory.                         */
/*                                                             */

{prodict/gate/gat_pul2.i
  &undo = "next"
  }

/*------------------------------------------------------------------*/


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

File: prodict/gat/gat_pulf.i

Description:
    creates the _field-definitions out of the oraC-definitions
    
Text-Parameters:
    &length         ds-field containing the length
    &mand           condition for mandatory-field
    &msc23          "{&msc23}"
    &name           ds-field containing the name
    &order-offset   {0|5} to be added to the l_fld-pos
    &precision      ds-field containing the Precision
    &radix          ds-field containing the Radix
    &scale          ds-field containing the Scale
    &extent         in the range of 0 to n
    
Included in:            
    prodict/gate/gat_pul.i
    
History:
    hutegger    95/03   abstracted from prodict/ora/ora_mak.i
    mcmann    03/20/01  Added assignment of default$ on fields
    mcmann    06/19/01  Check for ending quote in Oracle V8 for defaults
    mcmann    07/03/01  Verify that initial value starts with '"' or "'"
                        20010531-003
    mcmann    08/21/01  Added check for initial value length being > 1.

--------------------------------------------------------------------*/

/* this code gets executed only for the first element of array-field   */
/* so extent-code of field is always ##1 (even with real extent >= 10) */
assign
  pnam = TRIM(DICTDBG.{&name})
  pnam = ( if {&extent} > 0 AND LENGTH (pnam, "character") > 3 /* Drop the "##1" */
             then SUBSTRING (pnam, 1, LENGTH (pnam, "character") - 3, "character")
             else pnam )
  fnam = pnam
  pnam = ( if lookup(s_ttb_tbl.ds_type,"PROCEDURE,FUNCTION,PACKAGE") <> 0
            and lookup(SUBSTRING(pnam,1,1,"character"),"@,&,#") <> 0
            then substring(pnam,2,-1,"character")
            else pnam
         ).

RUN prodict/gate/_gat_fnm.p 
    ( INPUT        "FIELD",
      INPUT        RECID(s_ttb_tbl),
      INPUT-OUTPUT pnam
    ).

if NOT SESSION:BATCH-MODE
 then DISPLAY
   TRIM(DICTDBG.{&name}) @ msg[3]
   pnam                  @ msg[4]
   WITH FRAME ds_make.

assign
  dtyp    = LOOKUP(l_dt,user_env[12])
  l_init  = ?
  ntyp    = ( if dtyp = 0
                then "undefined"
                else ENTRY(dtyp,user_env[15])
            )
  l_dcml  = 0.

CREATE s_ttb_fld.

assign
  s_ttb_fld.pro_Desc    = l_fld-descr
  s_ttb_fld.pro_Extnt   = {&extent}
  s_ttb_fld.pro_name    = pnam
  s_ttb_fld.ttb_tbl     = RECID(s_ttb_tbl)
  s_ttb_fld.ds_prec     = {&Precision}
  s_ttb_fld.ds_scale    = {&Scale}
  s_ttb_fld.ds_lngth    = {&Length}
  s_ttb_fld.ds_radix    = {&Radix}
  s_ttb_fld.ds_msc23    = {&msc23}
  s_ttb_fld.ds_msc24    = l_fld-msc24
  s_ttb_fld.ds_stoff    = l_fld-pos
  s_ttb_fld.ds_name     = fnam
  s_ttb_fld.ds_type     = l_dt
  s_ttb_fld.pro_order   = l_fld-pos * 10 + 1000 
                              + {&order-offset}
  s_ttb_fld.pro_mand    = {&mand}
  l_init                = TRIM({&init}).

IF l_init <> ? AND LENGTH(l_init) >= 3 THEN DO:
  IF l_init BEGINS '"U##' THEN 
      ASSIGN l_init = SUBSTRING(l_init, 5, (LENGTH(l_init) - 5)).
  ELSE IF l_init BEGINS 'UPPER(' THEN
      ASSIGN l_init = SUBSTRING(l_init,8, (LENGTH(l_init) - 9)).
  ELSE IF l_init BEGINS '"' OR l_init BEGINS "'"  THEN
      ASSIGN l_init = SUBSTRING(l_init, 2, (LENGTH(l_init) - 2)).
END.
 
IF LENGTH(l_init) > 1 AND (SUBSTRING(l_init, (LENGTH(l_init) - 1), 1) = '"' OR
   SUBSTRING(l_init, (LENGTH(l_init) - 1), 1) = "'")  THEN
  ASSIGN l_init = SUBSTRING(l_init, 1,(LENGTH(l_init) - 1) ).


IF s_ttb_Fld.ds_name BEGINS "SYS_NC" THEN 
  ASSIGN s_ttb_Fld.defaultname = l_init
         l_init = ?.

/* ODBC:                                                      */
/*   If the field is not updatable (l_fld-msc24 contains "N") */ 
/*   then the field cannot be mandatory.                      */
/* ORA, SYB:                                                  */
/*   l_fld-msc24 = ?                                          */

{prodict/gate/gat_pul2.i
  &undo = "next"
  }


/*------------------------------------------------------------------*/

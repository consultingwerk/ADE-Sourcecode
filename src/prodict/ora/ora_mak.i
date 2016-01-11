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

File: prodict/ora/ora_mak.i

Description:
    creates the _field-definitions out of the ORACLE-definitions
    
Text-Parameters:
    &data-type      Foreign data-type in PROGRESS-Notation
                    usually DICTDBG.{&file-name}_columns.type#, except
                    when it's "TIME" to support the date/time structure
    &extent         in the range of 0 to n
    &order-offset   gets added to the _field._order
    
Included in:            
    prodict/ora/_ora_mak.p

    
History:
    hutegger    94/07/15    reworked from previous version
    
--------------------------------------------------------------------*/

/* this code gets executed only for the first element of array-field   */
/* so extent-code of field is always ##1 (even with real extent >= 10) */
ASSIGN
  pnam = ( IF {&extent} > 0                      /* Drop the "##1" */
             AND LENGTH (DICTDBG.oracle_columns.name,"character") > 4
             THEN SUBSTRING (DICTDBG.oracle_columns.name, 1, 
               LENGTH (DICTDBG.oracle_columns.name,"character") - 3,
               "character")
             ELSE DICTDBG.oracle_columns.name )
  fnam = pnam.

RUN "prodict/gate/_gat_nam.p" 
    ( INPUT        RECID(DICTDB._File),
      INPUT-OUTPUT pnam).

if not session:batch-mode then 
   DISPLAY DICTDBG.oracle_columns.name @ msg[3] pnam @ msg[4]
      WITH FRAME ora_make.

FIND FIRST w_field
  WHERE w_field.ora_name = fnam
  AND   w_field.ora_type = {&data-type} NO-ERROR. /* needed for date-time - fields */
IF NOT AVAILABLE w_field
  THEN FIND FIRST w_field
  WHERE w_field.ora_name = fnam
  NO-ERROR.

FIND FIRST DICTDBG.oracle_comment
  WHERE DICTDBG.oracle_comment.obj# = DICTDBG.oracle_columns.obj#
    AND DICTDBG.oracle_comment.col# = DICTDBG.oracle_columns.col#
  NO-LOCK NO-ERROR.

ASSIGN
  dtyp    = LOOKUP({&data-type},user_env[12])
  l_init  = ?
  ntyp    = ENTRY(dtyp,user_env[15])
  num_dec = 0
  vfmt    = ?.

CREATE DICTDB._Field.

ASSIGN
  DICTDB._Field._Desc         = ( IF AVAILABLE w_field
                                    THEN w_field.pro_desc
                                  ELSE IF NOT AVAILABLE DICTDBG.oracle_comment
                                    OR DICTDBG.oracle_comment.comment$ = ?
                                    THEN ""
                                    ELSE DICTDBG.oracle_comment.comment$
                                 )
  DICTDB._Field._Extent       = {&extent}
  DICTDB._Field._Field-Name   = ( IF AVAILABLE w_field
                                    THEN w_field.pro_name
                                    ELSE pnam )
  DICTDB._Field._File-recid   = RECID(DICTDB._File)
  DICTDB._Field._Fld-stoff    = DICTDBG.oracle_columns.col#
  DICTDB._Field._For-Name     = fnam
  DICTDB._Field._For-Type     = {&data-type} 
  DICTDB._Field._Initial      = DICTDBG.oracle_columns.default$
  DICTDB._Field._Mandatory    = (DICTDBG.oracle_columns.null$ <> 0)
  DICTDB._Field._Order        = DICTDBG.oracle_columns.col# * 10 + 1000
                              + {&order-offset}.

{ prodict/ora/ora_mak1.i
  &data-type = "{&data-type}"
  &file-name = "oracle_columns"
  &undo      = "NEXT"
  }

/*----------------------------------------------------------------------*/    

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

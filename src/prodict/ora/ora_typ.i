/*********************************************************************
* Copyright (C) 2004 by Progress Software Corporation ("PSC"),       *
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

File: prodict/ora/ora_typ.i

Description:
    assignes the correct data-type names according to the type-number
    
Text-Parameters:
    &data-type      Foreign data-type in PROGRESS-Notation
                    usually ds_columns.type#, except
                    when it's "TIME" to support the date/time structure
    &extent         in the range of 0 to n
    &order-offset   gets added to the _field._order
    
Included in:            
    prodict/ora/_ora_pul.p
    
History:
    hutegger    95/03   abstracted from prodict/ora/ora_mak.i

--------------------------------------------------------------------*/
/*h-*/
    
assign 
  l_dt = (IF    ds_columns.type# =  1
             OR ds_columns.type# = 97  THEN "VARCHAR2"
        ELSE IF ds_columns.type# = 96  THEN "CHAR"
        ELSE IF ds_columns.type# =  2  
             OR ds_columns.type# = 29  THEN "NUMBER"         
        ELSE IF ds_columns.type# =  9  THEN "VARCHAR"
        ELSE IF ds_columns.type# = 11
             OR ds_columns.type# = 69  THEN "ROWID"
        ELSE IF ds_columns.type# = 12  THEN "DATE"
        ELSE IF ds_columns.type# =  8  THEN "LONG"
        ELSE IF ds_columns.type# = 23 
             OR ds_columns.type# = 108 THEN "RAW"
        ELSE IF ds_columns.type# = 24  THEN "LONGRAW"
        ELSE IF ds_columns.type# = 252 THEN "LOGICAL"
        ELSE IF ds_columns.type# = 102 THEN "CURSOR"
        ELSE IF ds_columns.type# = 113 THEN "BLOB"
        ELSE IF ds_columns.type# = 114 THEN "BFILE"
        ELSE                                "UNDEFINED").

&IF "{&procedure}" <> "YES"
 &THEN   /* this part is only for real columns, not for arguments */
  if      ds_columns.type#      =  2
    and   ds_columns.scale      =  ?
    and   ds_columns.precision_ <> ?  then assign l_dt = "FLOAT".
  else if ds_columns.type#      =  2
    and   ds_columns.precision_ <  0 
    and   ds_columns.scale
        - ds_columns.precision_ > 10  then assign l_dt = "FLOAT".
  &ENDIF
  

/*------------------------------------------------------------------*/


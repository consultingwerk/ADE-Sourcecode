/*********************************************************************
* Copyright (C) 2004,2007-2008 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions        *
* contributed by participants of Possenet. 
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
    fernando 06/11/07   Unicode support - adding Unicode data types, and clob support
    fernando 04/07/08   Datetime support
--------------------------------------------------------------------*/
/*h-*/
    
assign 
  l_dt = (IF    ds_columns.type# =  1
             OR ds_columns.type# = 97  THEN
               (IF ds_columns.charsetform = 1 THEN "VARCHAR2" ELSE "NVARCHAR2")
        ELSE IF ds_columns.type# = 96  THEN (IF ds_columns.charsetform = 1 THEN "CHAR" ELSE "NCHAR")
        ELSE IF ds_columns.type# =  2  
             OR ds_columns.type# = 29  THEN "NUMBER"         
        ELSE IF ds_columns.type# =  9  THEN "VARCHAR"
        ELSE IF ds_columns.type# = 11
             OR ds_columns.type# = 104 /* Bug# 20070112-004 */
             OR ds_columns.type# = 69  THEN "ROWID"
        ELSE IF ds_columns.type# = 12  THEN "DATE"
        ELSE IF ds_columns.type# =  8  THEN "LONG"
        ELSE IF ds_columns.type# = 23 
             OR ds_columns.type# = 108 THEN "RAW"
        ELSE IF ds_columns.type# = 24  THEN "LONGRAW"
        ELSE IF ds_columns.type# = 252 THEN "LOGICAL"
        ELSE IF ds_columns.type# = 102 THEN "CURSOR"
        ELSE IF ds_columns.type# = 112 THEN (IF ds_columns.charsetform = 1 THEN "CLOB" ELSE "NCLOB")
        ELSE IF ds_columns.type# = 113 THEN "BLOB"
        ELSE IF ds_columns.type# = 114 THEN "BFILE"
        ELSE IF ds_columns.type# = 180 THEN "TIMESTAMP"
        ELSE IF ds_columns.type# = 181 THEN "TIMESTAMP_TZ"
        ELSE IF ds_columns.type# = 231 THEN "TIMESTAMP_LOCAL"
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


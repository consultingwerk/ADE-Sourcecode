/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/* tyb_typ.i - converts SQL data-type number to its datatype name */
/*
  {1} is  "DICTDBG.SQLColumns_buffer.data-type"
  {2} is  bug29 == configuration "bug" #29 from odb_ctl.i
*/


(IF ({1} > 2)
THEN
    (IF     {1} =  9  THEN "DATE"
    ELSE IF {1} =  10  THEN "TIME"
    ELSE IF {1} =  3  THEN "DECIMAL"
    ELSE IF {1} =  4  THEN "INTEGER"
    ELSE IF {1} =  5   THEN "SMALLINT"
    ELSE IF {1} =  6  THEN "FLOAT"
    ELSE IF {1} =  7  THEN "REAL"
    ELSE IF {1} =  8  THEN "DOUBLE"
    ELSE IF {1} =  11  THEN "TIMESTAMP"
    ELSE IF {1} =  12  THEN "VARCHAR"
    ELSE                  "UNDEFINED")

ELSE IF  ({1} > -16) 
THEN
    (IF     {1} =   1  THEN "CHAR"
    ELSE IF {1} =   2  THEN "NUMERIC"
    ELSE IF {1} =  -1  THEN "LONGVARCHAR"
    ELSE IF {1} =  -2  THEN "BINARY"
    ELSE IF {1} =  -3  THEN "VARBINARY"
    ELSE IF {1} =  -4  THEN "LONGVARBINARY"
    ELSE IF {1} =  -5  THEN "BIGINT"
    ELSE IF {1} =  -6  THEN "TINYINT"
    ELSE IF {1} =  -7  THEN "BIT"
    ELSE                    "UNDEFINED")
ELSE
    /* do special datatypes only if bug flag on. */
   (IF      ({2} and {1} =  -98) THEN "LONGVARBINARY"
    ELSE IF ({2} and {1} =  -99) THEN "LONGVARBINARY"
    ELSE                    "UNDEFINED")

)




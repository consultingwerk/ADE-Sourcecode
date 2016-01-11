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




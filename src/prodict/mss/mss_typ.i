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

/* mss_typ.i - converts SQL data-type number to its datatype name */
/*
  {1} is  "DICTDBG.SQLColumns_buffer.data-type"
  
  History:  D. McMann removed n types
 
*/


IF      {1} =  1  THEN ASSIGN l_dt = "CHAR".
ELSE IF {1} =  2  THEN ASSIGN l_dt = "NUMERIC".
ELSE IF {1} =  3  THEN ASSIGN l_dt = "DECIMAL".
ELSE IF {1} =  4  THEN ASSIGN l_dt = "INTEGER".
ELSE IF {1} =  5   THEN ASSIGN l_dt = "SMALLINT".
ELSE IF {1} =  6  THEN ASSIGN l_dt = "FLOAT".
ELSE IF {1} =  7  THEN ASSIGN l_dt = "REAL".
ELSE IF {1} =  8  THEN ASSIGN l_dt = "DOUBLE".
ELSE IF {1} =  9  THEN ASSIGN l_dt = "DATE".
ELSE IF {1} =  10  THEN ASSIGN l_dt = "TIME".
ELSE IF {1} =  11  THEN ASSIGN l_dt = "TIMESTAMP".
ELSE IF {1} =  12  THEN ASSIGN l_dt = "VARCHAR".
ELSE IF {1} =  -1  THEN ASSIGN l_dt = "LONGVARCHAR".
ELSE IF {1} =  -2  THEN ASSIGN l_dt = "BINARY".
ELSE IF {1} =  -3  THEN ASSIGN l_dt = "VARBINARY".
ELSE IF {1} =  -4  THEN ASSIGN l_dt = "LONGVARBINARY".
ELSE IF {1} =  -5  THEN ASSIGN l_dt = "BIGINT".
ELSE IF {1} =  -6  THEN ASSIGN l_dt = "TINYINT".
ELSE IF {1} =  -7  THEN ASSIGN l_dt = "BIT".
ELSE                    ASSIGN l_dt = "UNDEFINED".




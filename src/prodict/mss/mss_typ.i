/**************************************************************************
* Copyright (C) 2006,2009 by Progress Software Corporation. All rights    *
* reserved.  Prior versions of this work may contain portions             *
* contributed by participants of Possenet.                                *
*                                                                         *
**************************************************************************/

/* mss_typ.i - converts SQL data-type number to its datatype name */
/*
  {1} is  "DICTDBG.SQLColumns_buffer.data-type"
  
  History:  D. McMann removed n types
            fernando   04/14/06  Unicode support
            knavneet   03/16/09  datetime-tz support for MSS 
            sgarg      05/22/09  ROWGUID support for MSS
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
ELSE IF {1} =  -8  THEN ASSIGN l_dt = "NCHAR".
ELSE IF {1} =  -9  THEN ASSIGN l_dt = "NVARCHAR".
ELSE IF {1} = -10  THEN ASSIGN l_dt = "NLONGVARCHAR".
ELSE IF {1} = -155 THEN ASSIGN l_dt = "TIMESTAMP-TZ".
ELSE IF {1} = -154 THEN ASSIGN l_dt = "TIME".
ELSE IF {1} = -11  THEN ASSIGN l_dt = "ROWGUID".
ELSE                    ASSIGN l_dt = "UNDEFINED".

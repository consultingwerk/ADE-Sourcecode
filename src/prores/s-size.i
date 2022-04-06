/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-size.i - returns the width of a format */

/*
&type   - datatype:
          1 = "character"
          2 = "date"
          3 = "logical"
          4 = "integer"
          5 = "decimal"
          6 = "raw"
          7 = "rowid"
&format - format string variable
*/

LENGTH(IF {&type} = 1 THEN STRING(""   ,{&format})
  ELSE IF {&type} = 2 THEN STRING(TODAY,{&format})
  ELSE IF {&type} = 3 THEN STRING(TRUE ,{&format})
  ELSE                     STRING(0    ,{&format})
)

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
       ,"RAW":u)

/* s-size.i - end of file */


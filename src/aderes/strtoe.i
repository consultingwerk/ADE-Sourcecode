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
/*
   strtoe.i - In case we are running with a non-American numeric format 
             (using -E parameter for European or -numsep and -numdec for
             other format), translate a string-ized number to non-American 
      	      format for interpretation as a number.  i.e., With -E, if we have
      	      a widget column which is stored as 2.5, if we turn this into
      	      an integer, Progress will interpret this as 25 since it sees
      	      the dot as a thousand separator.  So change the . to the 
      	      numeric decimal point.

   Input Argument:
      &str - the string to convert.
*/

(IF SESSION:NUMERIC-FORMAT <> "AMERICAN":u 
   THEN REPLACE({&str}, ".":u, SESSION:NUMERIC-DECIMAL-POINT)
   ELSE {&str})

/* strtoe.i - end of file */


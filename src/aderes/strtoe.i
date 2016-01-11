/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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


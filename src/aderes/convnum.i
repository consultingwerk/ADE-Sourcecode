/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * convnum.i - In case we are running with the -E parameter (European
      	       # format), make sure that there are no commas in a 
      	       string which are really supposed to be decimal points.
      	       This is for code generation since the compiler doesn't
      	       understand that 2,5 is really 2.5.  We don't have to
      	       worry about dots which should be commas because 
      	       internally, progress never puts thousand separators
      	       into a number when you STRINGize it.

   Input Argument:
      &num - the number to convert.
*/

(IF SESSION:NUMERIC-FORMAT = "EUROPEAN":u 
   THEN REPLACE(STRING({&num}), ",":u, ".":u)
   ELSE STRING({&num}))

/* convnum.i - end of file */

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
   numtoa.i - In case we are running with a numeric format other than 
             American (European if -E parameter is used or some other 
             format determined by -numsep and -numdec), translate a number to 
             American format for storage or output to generated code.  This 
             means we make sure that there are no characters in a string which are 
      	      really decimal points.
      	      This is for code generation since the compiler doesn't
      	      understand that 2,5 is really 2.5.  We don't have to
      	      worry about dots which should be thousands separators because 
      	      internally, progress never puts thousand separators
      	      into a number when you STRINGize it.

   Input Argument:
      &num - the number to convert.
*/

(IF SESSION:NUMERIC-FORMAT <> "AMERICAN":u 
   THEN REPLACE(STRING({&num}), SESSION:NUMERIC-DECIMAL-POINT, ".":u)
   ELSE STRING({&num}))

/* numtoa.i -  end of file */


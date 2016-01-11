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


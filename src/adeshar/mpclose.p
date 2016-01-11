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
 * MPCLOSE.P
 *
 * This procedure closes the output file, if it is defined.
 * And performs other clean-up, if any.
 */
 
{adeshar/mpd.i} /* Include global mp declarations. */

if mpOutFile NE ? then do:
  /* Write a trailer to the file */
  PUT STREAM mpOut unformatted SKIP
      "Timing Finished: " + 
      STRING(TODAY,"99/99/99") + 
      "; " + 
      STRING (TIME, "HH:MM am")
      SKIP.

  /* Close the file */
  output stream mpOut close.
end.
     

  
 


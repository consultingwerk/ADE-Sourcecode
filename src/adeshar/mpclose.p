/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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
     

  
 


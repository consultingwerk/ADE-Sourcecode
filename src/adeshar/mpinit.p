/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
 * MPINIT.P
 *
 * Does an init of the globals. Call ONCE at the top of your wrapper function.
 *
 * Parameters:  outfile ? if none, otherwise use name.
 *              messon  true if messages should be on.
 */
  DEFINE INPUT PARAMETER outfile AS CHAR.     /* Name of output file, use ?
                                               * if you want message stmnts. */
  DEFINE INPUT PARAMETER MessOn  AS LOGICAL.  /* True if messages should be 
                                               * given at all. */
  {adeshar/mpd.i} /* get access to globals */

  /* Init file stuff */
  mpOutFile = outfile.
  mpMessOn  = MessOn.
  if mpOutFile NE ? then do:
    output stream mpOut to value(mpOutFile).

    /* Write a header to the file.*/
    PUT STREAM mpOut unformatted SKIP   /* Date, and time */
      "Timing started: " + 
      STRING(TODAY,"99/99/99") + 
      "; " + 
      STRING (TIME, "HH:MM am").
    PUT STREAM mpOut unformatted SKIP   /* Propath */
      "Propath: " + PROPATH.
  end.
                       
  /* Init global mp timer */
  mpTime = 0.
  mpSavedETime = etime(yes). /* restart etime (internal Progress variable) */
  mpSavedEtime = 0.

  /* END of procedure MPINIT.P */
  

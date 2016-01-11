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
  

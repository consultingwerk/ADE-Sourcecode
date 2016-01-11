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
 * MPWRAP.P
 *
 * This is a template/example wrapper function for the mp macros.
 * It sets up an output file, initializes the global vars, and
 * calls the main function that you want to time.
 */

/* {adeshar/mpdotime.i} */  /* Comment this out to comment out timing code */

&IF {&MP-DOTIMING} &THEN
  &MESSAGE [mpwrap.p]: Including Timing code.

  DEFINE NEW GLOBAL SHARED VARIABLE output_number AS INT INIT 0. 
  DEFINE VARIABLE timing-file AS CHAR.

  {adeshar/mpd.i}     /* Include the global vars */
  
  /* Generate a filename for the timing output-- make it show up near the top, too */
  output_number = output_number + 1.  
  timing-file = "aatime" + STRING(output_number,"99") + ".i".

  /* Init the globals, set the filename, and turn messages on */
  RUN adeshar/mpinit.p (INPUT timing-file,  /* Name of outputfile. ? = use MESSAGE. */
                        INPUT TRUE          /* TRUE= messages are on */
                       ).

&ENDIF /* End optional timer include */

run _INSERT_YOUR_.P_HERE_.

&IF {&MP-DOTIMING} &THEN         

  /* Close the stream properly */
  RUN adeshar/mpclose.p.

  /* Now look at what was generated */
  run adeuib\_prvw4gl.p (timing-file,?,?,?).

&ENDIF.

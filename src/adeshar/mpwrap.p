/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * MPSTOTAL.I
 *
 * Dumps a subtotal to the current output.
 *
 * NOTE: Do not include this file directly.  First, it will not
 *       remove itself from the count of time executed.  Second,
 *       it will not comment itself out if {&MP-DOTIMING} is not
 *       defined.  Call using mp.i as a wrapper.
 *
 * Parameters: {&TIMER} name of timer to display
 *             {&INFOSTR} Description string to display [OPTIONAL]
 *             {&INFOVAR} Variable to include in the string. [OPTIONAL]
 *                  e.g. &INFOVAR="widget-name" or &INFOVAR="STRING(wid-num)"
 *             {&MP-DEBUG} define as something if you want a &MESSAGE 
 *                      showing the parameters sent in.
 *
 *             INFOSTR is displayed before INFOVAR (if both are used),
 *                 also,  INFOVAR does _not_ include its name in the 
 *                 output, if you want to, include it in INFOSTR.
 *           
*/                                                            

/* Provide info for debuggin if asked for.. */
&IF "{&MP-DEBUG}" NE "" &THEN
  &MESSAGE [mpstotal.i] Parms: TIMER={&TIMER}; INFOSTR={&INFOSTR}; INFOVAR={&INFOVAR};
&ENDIF

/* This runs a procedure instead of including code directly because we ran into
 * trouble with the Action Segment limit while trying to profile _uibmain.p
 */
RUN adeshar/mpstotal.p (INPUT-OUTPUT mpS_{&TIMER},
                        INPUT-OUTPUT mpA_{&TIMER},
                        INPUT        "{&TIMER}",
                        INPUT        mpTime,
                        INPUT        " {&INFOSTR}" 
                        &IF "{&INFOVAR}" NE "" &THEN /* Optionally tack on infovar */
                           + {&INFOVAR}
                        &ENDIF
                        ).


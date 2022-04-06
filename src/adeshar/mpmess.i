/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
 * MPMESS.I
 *
 * Display a message to the current stream.
 *    
 * NOTE: Do not include this file directly.  First, it will not
 *       remove itself from the count of time executed.  Second,
 *       it will not comment itself out if {&MP-DOTIMING} is not
 *       defined.  Call using mp.i as a wrapper.
 *
 * Parameters: {&INFOSTR} the message to display.
 *             {&INFOVAR} variable to attach at end of string.
 *                Just use var name if char var, else use
 *                {... &INFOVAR="STRING(var-name)" .... }
 *             {&TIMER} Name of the timer this is relevant to. [OPTIONAL]
 *                Only needed if you plan on using mpdrop.i to control compiles.
 */

 run adeshar/mpdisp.p ("{&INFOSTR}"                      
                       &IF "{&INFOVAR}" NE "" &THEN
                         + {&INFOVAR}
                       &ENDIF
                       ).

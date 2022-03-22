/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* 
 * MPDELAY.I
 *
 * This file inserts a delays the machine for {&DELAY} milli-seconds.
 * Good for testing mp itself, among other things.
 *
 * NOTE: INCLUDE this file directly.  Otherwise it removes itself
 *       from the timing stream, and you won't get any delay.
 *
 * Parameters: {&MP-DELAY} the number of milli seconds to delay.
 */

&IF "{&MP-DOTIMING}" NE "" &THEN
   &IF "{&MP-DROP-{&TIMER}}" EQ "" &THEN
      run adeshar/mpdelay.p (input {&MP-DELAY}).
   &ENDIF
&ENDIF

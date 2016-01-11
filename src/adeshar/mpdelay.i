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

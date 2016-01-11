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

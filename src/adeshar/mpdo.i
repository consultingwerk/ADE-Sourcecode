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
 * MPDO.I
 *
 * This file doesn't actually do anything.  Its just a handy
 * counter-part to mpdrop.i.  We use it in our global include
 * file which controls which timers are run.
 *
 * NOTE: Don't call this as a macro through mp.i
 *
 * Parameters: {&TIMER} Name of timer to continue including.
 */             
 
&IF "{&MP-DOTIMING}" NE "" &THEN /* if timing is on then process */
  &MESSAGE Using timer {&TIMER}
&ENDIF

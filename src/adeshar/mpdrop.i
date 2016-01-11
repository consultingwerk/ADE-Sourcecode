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
 * MPDROP.I
 *
 * Include this file if you want to prevent a specific timer
 * from being included in the build.  Only parsed if global 
 * timing is turned on.
 *
 * NOTE: You cannot call this macro through mp.i
 *       ALSO, this only affects the CURRENT file. (Scope 
 *       of &GLOBAL-DEFINE)
 *
 * Parameters: {&TIMER} Name of timer to stop including.
 */             
 
&IF "{&MP-DOTIMING}" NE "" &THEN /* if timing is on then process */
  &MESSAGE Shut off timer {&TIMER}
  &GLOBAL-DEFINE MP-DROP-{&TIMER} DROPPED
&ENDIF

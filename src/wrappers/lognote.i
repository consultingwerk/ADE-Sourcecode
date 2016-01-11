/*********************************************************************
* Copyright (C) 2000-2002 by Progress Software Corporation ("PSC"),  *
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
/*---------------------------------------------------------------------------------
  File: lognote.i

  Description:  Global Logging include
                It allows for conditionally compiling Logging into programs
                Useful for debugging and performance timings

  Purpose:      Code for {LOG 'message'} 
 
  Parameters:   {1} Default logtype

  History:
  --------
  
  Created:  07/10/2003 - Per Digre / PSC

-----------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* 
  Specify "logging on" to enable logging in adm2/globals.i 
  ie   &GLOBAL-DEFINE logging yes
  for other programs not using global include files then specify here
*/

&IF DEFINED(logging) = 0 &THEN
  &GLOBAL-DEFINE logging no
&ENDIF

/* Implementation */
&IF "{&logging}" = "yes" &THEN

  &IF DEFINED(WEBSTREAM) = 0 &THEN
    &GLOBAL-DEFINE log_begin _lognote(
    &GLOBAL-DEFINE log_end ).

    /* If the program is a non-Webspeed program but is executed by Webspeed
       then the reference to the Webspeed lognote must be defined           */
    DEFINE NEW GLOBAL SHARED VARIABLE web-utilities-hdl AS HANDLE NO-UNDO.
    FUNCTION logNote RETURNS CHARACTER 
      ( INPUT pcLogType AS CHARACTER 
       ,INPUT pcLogText AS CHARACTER ) IN web-utilities-hdl.

        
    DEFINE STREAM sLogNote.   /* Requires stream if run within Appserver or GUI */

    FUNCTION _lognote RETURNS CHARACTER (INPUT cMsg AS CHARACTER):
      IF SESSION:CLIENT-TYPE = "webspeed" THEN 
        lognote('{1}',cMsg).
      ELSE DO:
        OUTPUT STREAM sLogNote TO "lognote.txt" APPEND.    
        PUT    STREAM sLogNote UNFORMATTED 
          STRING(PROGRAM-NAME(2),"x(40)") 
          STRING(ETIME,">>>>>>>>>>>>9") 
          " {1} " + cMsg SKIP.
        OUTPUT STREAM sLogNote CLOSE.    
      END.  
    END FUNCTION.

  &ELSE
    /* Webspeed programs have logging already implemented */
    &GLOBAL-DEFINE log_begin lognote('{1}',
    &GLOBAL-DEFINE log_end ).

  &ENDIF
&ENDIF

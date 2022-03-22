/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
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

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
  &IF "{&no-tag}" ne "yes" &THEN
     /* javascpt.i -- common JavaScript code used by WebSpeed Workshop */
     '<SCRIPT LANGUAGE="JavaScript"> ~n'
     '<~!-- ~n' &ENDIF &IF FALSE &THEN
  /* ------------------------------------------------------------------------
   * This include file holds all the common javascript code that is
   * reused by Workshop files. This code can be inserted into an "&OUT"
   * statement.
   *
   * Parameters:
   *   segments -- a comma delimited list of segments that should be included 
   *   no-tag   -- if defined, then the <SCRIPT.../SCRIPT> won't be output.
   *
   * NOTE: I included comments in IF FALSE blocks to make a preprocess
   * expansion more readable because this section won't appear after expansion.
   *
   * Author: Wm. T. Wood    Created: 12/31/96
   *
   *  Modifications:   5/13/97 - NEH Removed ChkFld function.  If chkfld
   *                                 is needed - use workshop/chkfld.i 
   * ------------------------------------------------------------------------ 
   */  
    
  /* ------------------------------------------------------------------------
     LOAD-SIBLING --
     Adds JavaScript that loads sets the location of a sibling frame
     if the name of FRAMES[ FRAME-INDEX ] is the FRAME.  If location
     is not given, then it loads the existing frame. This is created
     as a JavaScript Function if the FUNCTION-NAME is specified. */  
  &ENDIF 
  &IF LOOKUP ('Load-Sibling', '{&SEGMENTS}') > 0 &THEN
     &IF "{&FUNCTION-NAME}" ne "" &THEN
     'function {&FUNCTION-NAME} ~{ ~n' &ENDIF  
     '  ~/~/ Redisplay the contents of the {&FRAME} frame ~n'
     '  if (parent.{&FRAME} != null) ~{ ~n'
     '    parent.{&FRAME}.location.href =' 
     &IF '{&LOCATION}' ne '':U
     &THEN ' "' {&LOCATION} '"~; ~n'
     &ELSE ' parent.{&FRAME}.location.href ~; ~n'
     &ENDIF
     '  } ~n' &IF "{&FUNCTION-NAME}" ne "" &THEN
     '} ~n' &ENDIF
  &ENDIF &IF FALSE &THEN


  /* ------------------------------------------------------------------------
     LOAD-SELF --
     Adds JavaScript that loads sets a location into the current frame. */  
  &ENDIF 
  &IF LOOKUP ('Load-Self', '{&SEGMENTS}') > 0 &THEN
     '~/~/  Redisplay the contents of the document ~n'
     'window.location.href = "' {&LOCATION} '"~; ~n'
  &ENDIF &IF FALSE &THEN  

  /* ------------------------------------------------------------------------
     CLEAR-FRAME --
     Adds JavaScript that clears the contents of a frame.
     Arguements:
       FRAME - name of the frame.
       FUNCTION-NAME -[Optional] the javascript is created as a function
   */
  &ENDIF 
  &IF LOOKUP ('Clear-Frame', '{&SEGMENTS}') > 0 &THEN
     &IF "{&FUNCTION-NAME}" ne "" &THEN
     'function {&FUNCTION-NAME} ~{ ~n' &ENDIF  
     '  ~/~/ Clear the contents of the {&FRAME} frame by loading a blank screen.~n'
     '  if ({&FRAME} != null) ~{ ~n'
     '    {&FRAME}.location.href = "' get-location('Blank':U) '"~; ~n'
     '  } ~n ' &IF "{&FUNCTION-NAME}" ne "" &THEN  
     '  return true~; ~n'
     '} ~n' &ENDIF
  &ENDIF &IF FALSE &THEN  

  /* ------------------------------------------------------------------------
     CLEAR-SELF --
     Adds JavaScript that clears the contents of a the current window. NOTE
     that CLEAR-FRAME above hangs on internet explorer 3.0. This version just
     loads a blank document.*/  
  &ENDIF 
  &IF LOOKUP ('Clear-Self', '{&SEGMENTS}') > 0 &THEN
     &IF "{&FUNCTION-NAME}" ne "" &THEN
     'function {&FUNCTION-NAME} ~{ ~n' &ENDIF  
     '  ~/~/ Clear the contents of the current window by ~n'
     '  ~/~/ loading a blank screen.~n'
     '  window.location.href = "' get-location('Blank':U) '"~; ~n' &IF "{&FUNCTION-NAME}" ne "" &THEN  
     '  return true~; ~n'
     '} ~n' &ENDIF
  &ENDIF &IF FALSE &THEN

  /* ------------------------------------------------------------------------
     GOTO-FIELD --
     Adds a GotoField function that highlights and selects the field of interest
   */
  &ENDIF
  &IF LOOKUP ('goto-Field', '{&SEGMENTS}') > 0 &THEN
     '// Highlight a field with an error. ~n' 
     'function GotoField (name) ~{ ~n'
     '  var field = document.forms[0].elements[name]~; ~n'
     '  field.focus()~; ~n'
     '  return field.select()~; ~n'
     '} ~n'
  &ENDIF
 
  &IF "{&no-tag}" ne "yes" &THEN
     '~/~/ --> ~n'
     '</SCRIPT> ~n' &ENDIF


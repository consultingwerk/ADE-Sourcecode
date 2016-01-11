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
   /* chkfld.i -- common field validation code used by WebSpeed Workshop */
   &IF "{&no-tag}" ne "yes" &THEN
     '<SCRIPT LANGUAGE="JavaScript"> ~n'
     '<~!-- ~n' 
   &ENDIF
  /* ------------------------------------------------------------------------
   * This include file contains field validation functions for 
   * HTML mapping, properties, and workshop 
   *
   * Parameters:
   *   no-tag   -- if defined, then the <SCRIPT.../SCRIPT> won't be output.
   *
   * Author: Nancy E. Horn    Created: 5/13/97 
   * ------------------------------------------------------------------------ 
   */  
    
  /* ------------------------------------------------------------------------
     CHECK-FIELD --
        Check for valid Progress Field.
     Arguments:
        NAME-ONLY -- no periods are allowed in the name.
   */
    'function chkFld(what) ~{ ~n '
    '  var okchars = "#$%&-_0123456789ETAONRISHDLFCMUGYPWBVKXJQZabcdefghijklmnopqrstuvwxyz" ~; ~n '
    '  var firstchr = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRTSUVWXYZ" ~; ~n '
    ' what.value = leftTrim( what.value )~; ~n '
    ' what.value = rightTrim( what.value )~; ~n '
    ' if (what.value.length < 1) ~{ ~n'
    '   window.alert(~'Please specify a Webspeed Field value.~')~; ~n'
    '   what.focus()~; ~n'
    '   return false~; ~n'
    '   ~} ~n '
  &IF "{&NAME-ONLY}" eq "" &THEN
    ' var fldArray = doSplit( what.value )~; ~n ' &ELSE
    ' var fldArray = what.value~; ~n ' &ENDIF
    ' for (var Idx=0; Idx<fldArray.length; Idx++) ~{ ~n '
    '   var fld = fldArray[Idx]~; ~n' 
    '   // Test #1: Name <= 32 characters ~n '
    '   if (fld.length > 32) ~{ ~n '
    '     window.alert(~'The name is too long. It must be 32 characters or less.~')~; ~n '
    '     what.focus()~; ~n '
    '     return false~; ~n '
    '    ~} ~n '
    '   // Test #2: Name must start with alphabetic character. ~n '
    '   if (firstchr.indexOf(fld.charAt(0)) == -1 ) ~{ ~n'
    '     window.alert(~'The first character of the name is invalid. The name must start with a letter (A-Z).~')~; ~n'
    '     what.focus()~; ~n '
    '     return false~; ~n '
    '    ~} ~n '
    '   // Test #3: Check for invalid characters. ~n '
    '   for (var strInd=0~; strInd != -1, strInd < fld.length~; strInd++) ~{ ~n '
    '     if ((okchars.indexOf(fld.charAt(strInd))) == -1 ) ~{ ~n '
    '       if (fld.charAt(strInd) == ~' ~') ~{ ~n'
    '         window.alert(~'The name may not contain spaces.~')~;~n'
    '       } else ~{~n'
    '         window.alert(~'The name contains an invalid character (i.e. "~' + fld.charAt(strInd) + ~'").~')~; ~n'
    '       } ~n'
    '       what.focus()~; ~n '
    '       return false~; ~n '
    '     ~} ~n '
    '   ~} ~n '
    ' ~} ~n '
    '  return true~; ~n '
    ' ~} ~n '
    ' function leftTrim(InString) ~{ ~n '
    '   OutString=InString~; ~n '
    '   for (Count=0~; Count < InString.length~; Count++ ) ~{ ~n '
    '     TempChar=InString.substring(Count, Count+1)~; ~n'
    '     if (TempChar!=~' ~') ~{  ~n '
    '        OutString=InString.substring (Count, InString.length)~; ~n '
    '        break~; ~n '
    '     ~} ~n '
    '  ~} ~n '
    '   return (OutString)~; ~n '
    ' ~} ~n '
    ' function rightTrim(InString) ~{ ~n '
    '   OutString=InString~; ~n '
    '   for (Count=InString.length~; Count > 0 ~; Count--) ~{ ~n '
    '      TempChar=InString.substring (Count-1, Count)~; ~n ' 
    '      if (TempChar!=~' ~') ~{ ~n '
    '         OutString=InString.substring(0, Count)~; ~n'
    '         break~; ~n '
    '     ~} ~n '
    '  ~} ~n '
    '   return (OutString)~; ~n '
    ' ~} ~n '
    .
    /* insert an out here to keep statement length in check */
    /* There exists a .split() function in Netscape but not in */
    /* IE.  This function simply does what .split() would do */ 
 {&OUT}
    ' function doSplit(InString)~{ ~n '
    '   fldArray = new Array()~; ~n '
    '   Start = 0~; ~n'
    '   offSet = 0 ~; ~n'
    '   i = 0 ~; ~n' 
    '   while( offSet != -1) ~{ ~n '
    '    offSet = InString.indexOf(".", Start)~; ~n '
    '    if (offSet == -1) ~n '
    '      fldArray[i] = InString.substring(Start, InString.length)~; ~n '
    '    else ~n '
    '      fldArray[i] = InString.substring(Start, offSet-1)~; ~n '
    '    i++~; ~n'
    '    Start=offSet+1~; ~n '
    '  ~} ~n '
    '   return fldArray~; ~n '
    '~} ~n'

  &IF "{&no-tag}" ne "yes" &THEN
     '~/~/ --> ~n'
     '</SCRIPT> ~n' &ENDIF

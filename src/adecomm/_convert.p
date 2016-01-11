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

  File: _fconvert.p

  Description: 
     Converts an American numeric format to non-American and vice-versa.
   
  Input Parameters:
      pType          A-TO-N  American to Non-American
                     N-TO-A  Non-American to American
      pInFormat      The input format to convert
      pNumSeparator  The numeric separator to use
      pNumDecimal    The numeric decimal point to use
      
  Output Parameters:   
       pOutFormat The resulting output format
       
  Note: In this function, CHR(6) is used as a temporary replacement 
         character because it is assume that the value should not be found
         in the format string.

  Author: Bob Ryan
  Created: 6/6/94
 
  Modified: 
    04/09/99  -  Added support for various Intl Numeric Formats (in 
                 addition to American and European).  
*/

define input parameter  pType         as char no-undo.
define input parameter  pInFormat     as char no-undo.
define input parameter  pNumSeparator as char no-undo.
define input parameter  pNumDecimal   as char no-undo.
define output parameter pOutFormat    as char no-undo.

define var FirstPass  as char no-undo.
define var SecondPass as char no-undo.

if pInFormat = "" or pType = "" then do:
  pOutFormat = pInFormat.
  return.
end.

if caps(pType) =  "A-TO-N" then
  assign
    FirstPass  = replace(pInFormat, ".", chr(6)) 
    SecondPass = replace(FirstPass, ",", pNumSeparator) 
    pOutFormat = replace(SecondPass, chr(6), pNumDecimal) .
else
  assign    
    FirstPass  = replace(pInFormat, pNumDecimal, chr(6)) 
    SecondPass = replace(FirstPass, pNumSeparator, ",") 
    pOutFormat = replace(SecondPass, chr(6), ".") .
    
    


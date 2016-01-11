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
/* aferrortxt.i Standard Error Format Include.

   This include returns an error message string formatted to conform to how the
   Astra showMessages function expects a standard error message.
   The format also conforms to the format expected by ADM2 as:
   message + CHR(4) + field + CHR(4) + table
   but we do add two extra CHR(4) delimited entries for program name 1 and 2.

   The Include takes input parameters as follows:
   {1} = Error group, e.g. AF or ? if hard coded message
   {2} = Error number, e.g. 1 or hard coded message text
   {3} = Table, e.g. gsm_user
   {4} = Field, eg. user_login_name
   {5-13} = Extra insertion arguements for error message, 9 supported 
   The include file will result in a quoted string as follows:
   "group^number^prog1:prog2^insert1|insert2|insert3,etcCHR(4)fieldnameCHR(4)tablenameCHR(4)prog1CHR(4)prog2"

   NOTES:
   Arguments must be passed as unquoted variables or single quoted literals, e.g. 'text'
   If literal contains spaces, then it must also be in dounble quotes, e.g. "'test space'"
   If double quotes are used, these are dropped automatically.
   If an arguement in the middle needs to be ommitted, a placeholder of '?' must be used 
   The simplest use for an error with no insertion codes would be:
   {af/sup2/aferrortxt.i 'AF' '1'}
   The simplest use for a hard coded message would be:
   {af/sup2/aferrortxt.i '?' "'message text'"}
   A message code with insertion parameters but no table or field would be:
   {af/sup2/aferrortxt.i 'AF' '1' '?' '?' 'insert1' 'insert2' 'insert3'}
*/

{1} + "^" + {2} + "^" + LC(PROGRAM-NAME(1)) + ":" + LC(PROGRAM-NAME(2)) + "^"
&IF "{5}" <> "" &THEN + (IF {5} = ? THEN "?" ELSE TRIM(STRING({5}))) &ENDIF
&IF "{6}" <> "" &THEN + "|" + (IF {6} = ? THEN "?" ELSE TRIM(STRING({6}))) &ENDIF
&IF "{7}" <> "" &THEN + "|" + (IF {7} = ? THEN "?" ELSE TRIM(STRING({7}))) &ENDIF
&IF "{8}" <> "" &THEN + "|" + (IF {8} = ? THEN "?" ELSE TRIM(STRING({8}))) &ENDIF
&IF "{9}" <> "" &THEN + "|" + (IF {9} = ? THEN "?" ELSE TRIM(STRING({9}))) &ENDIF
&IF "{10}" <> "" &THEN + "|" + (IF {10} = ? THEN "?" ELSE TRIM(STRING({10}))) &ENDIF
&IF "{11}" <> "" &THEN + "|" + (IF {11} = ? THEN "?" ELSE TRIM(STRING({11}))) &ENDIF
&IF "{12}" <> "" &THEN + "|" + (IF {12} = ? THEN "?" ELSE TRIM(STRING({12}))) &ENDIF
&IF "{13}" <> "" &THEN + "|" + (IF {13} = ? THEN "?" ELSE TRIM(STRING({13}))) &ENDIF
+ CHR(4)
&IF "{4}" <> "" &THEN + (IF {4} = ? THEN "?" ELSE TRIM(STRING({4}))) &ENDIF + CHR(4) 
&IF "{3}" <> "" &THEN + (IF {3} = ? THEN "?" ELSE TRIM(STRING({3}))) &ENDIF + CHR(4) + 
PROGRAM-NAME(1) + CHR(4) + 
PROGRAM-NAME(2)

&IF "{14}" <> "" &THEN 
&MESSAGE "Too many arguments to include file af/sup2/aferrortxt.i" 
&ENDIF

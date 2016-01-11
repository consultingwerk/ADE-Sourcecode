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

/* Progress Lex Converter 7.1A->7.1B Version 1.11 */

/*
   Do some OK processing for one trigger for either a table trigger or
   field trigger.
   
   Arguments:
      Frame	    - Indicates what frame to use in the form of "FRAME x".
      pname	    - The variable for the proc name 
      override      - The variable for the override flag
      crc	    - The variable for the crc flag
      new_crc_val   - The variable for the new crc value
      old_crc_val   - The variable for the new crc value
      changed       - Variable indicating if values were modified.
*/


DEFINE VAR fname AS CHAR NO-UNDO.

{&pname} = INPUT {&Frame} {&pname}.
   	    
/* If user wants to store crc and they haven't explicitly gone into
   the trigger code and recompiled, do it now in case they changed
   the source outside of the dictionary.  This is true even for new
   triggers - user may refer to an existing .p. 
*/
IF {&pname} <> "" AND {&pname} <> ? AND 
   INPUT {&Frame} {&crc} AND {&new_crc_val} = {&old_crc_val} then
DO:
   fname = SEARCH({&pname}).
   if fname = ? then fname = {&pname}.
   COMPILE VALUE(fname) NO-ERROR.
   IF NOT COMPILER:ERROR THEN
   DO:
      RCODE-INFO:FILENAME = fname.
      {&new_crc_val} = RCODE-INFO:CRC-VALUE.
   END.
   ELSE DO:
      MESSAGE "In order to store the CRC value, the trigger" SKIP
              "code must be compiled.  The following error" SKIP
              "occurred when trying to compile " fname SKIP(1) 
              ERROR-STATUS:GET-MESSAGE(1) SKIP(1)
              "Either fix this problem or turn off CRC checking."
              VIEW-AS ALERT-BOX ERROR BUTTONS OK.
      RETURN NO-APPLY.
   END.
END. 
 
/* indicates if dirty */
{&changed} = {&changed} OR
	     {&Frame} {&pname}    ENTERED OR 
	     {&Frame} {&override} ENTERED OR
	     {&Frame} {&crc}      ENTERED OR
	     {&new_crc_val} <> {&old_crc_val}.

 





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
/*----------------------------------------------------------------------------

File: _chkfmt.i

Description:
This function validates the format of a given field.

Input Parameters:
	fd-tp  - The type of the field 
	          1 - char
		  2 - date
		  3 - logical
		  4 - other (integer or decimal)
	fd-nm  - The field Name
	lbl    - The field label
   	fmt    - The field format to check

Output Parameters:
	fld-wdth - The width of the field
	lError   - TRUE if there is an error.

Author:   R. Hunter, G. O'Connor

Date Created: June 24, 1993

----------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER fd-tp     AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER fd-nm     AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER lbl       AS CHARACTER NO-UNDO.
DEFINE INPUT  PARAMETER fmt       AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER fld-wdth  AS INTEGER   NO-UNDO.
DEFINE OUTPUT PARAMETER lError    AS LOGICAL   NO-UNDO.
							    
DEFINE VARIABLE sError AS CHARACTER NO-UNDO.

/* The field width is the maximum of label-width and format width */
/* ksu 02/24/94 LENGTH use raw mode */
ASSIGN 
  fld-wdth = MAXIMUM(LENGTH(lbl, "RAW":U), 
               IF      fd-tp = 1 THEN LENGTH(STRING("A",fmt), "RAW":U)
               ELSE IF fd-tp = 2 THEN LENGTH(STRING(TODAY,fmt), "RAW":U)
               ELSE IF fd-tp = 3 THEN MAXIMUM(LENGTH(STRING(YES,fmt), "RAW":U),
                                              LENGTH(STRING(NO,fmt), "RAW":U))
               ELSE LENGTH(STRING(0,fmt), "RAW":U))
  lError   = FALSE
  NO-ERROR.

IF (ERROR-STATUS:ERROR) THEN DO:
  ASSIGN
    sError = REPLACE(ERROR-STATUS:GET-MESSAGE(1),"** ":u,"")
    sError = SUBSTRING(sError,1,INDEX(sError,".":u),"CHARACTER":u)
    lError = TRUE
    .

  IF (fd-nm > "") THEN
    MESSAGE sError SKIP
       """" + fmt + """ is not a valid format for" fd-nm + "." SKIP
       IF fd-tp = 1 THEN "The format of a character field should use X, N, A, !, " +
                        "or 9 and be followed of (n) to indicate n more of a prevous " +
                        "format character."
       ELSE IF fd-tp = 2 THEN "The format of a date field should use 9's to " +
                              "represent the month, day, and year seperated by " +
                              "a /, -, or . "
       ELSE IF fd-tp = 3 THEN "The formet for a Logical field should be two string to " +
                              "represent true and false separated by a /."
       ELSE "The format for an Integer or Decimal field should use 9, Z, z, ., ,, <, >, (, " +
            "), *, +, -, cr, dr, or db"
       SKIP " " SKIP
       IF fd-tp = 1 THEN "For example xxxxx or x(5). See help for more details."
       ELSE IF fd-tp = 2 THEN "For example 99/99/99, 99/99/9999, or 99-99-99. See help for more details."
       ELSE IF fd-tp = 3 THEN "For example true/false, yes/no, or shipped/waiting. See help fpr more details."
       ELSE "For eample ->,>>>,>>9 or >,>>>,>>9cr. See help for more details."
       VIEW-AS ALERT-BOX ERROR BUTTON OK.
  ELSE
    MESSAGE sError SKIP
      """" + fmt + """ is not a valid format." SKIP
      IF fd-tp = 1 THEN "The format of a character field should use X, N, A, !, " +
                        "or 9 and be followed of (n) to indicate n more of a prevous " +
                        "format character."
      ELSE IF fd-tp = 2 THEN "The format of a date field should use 9's to " +
                             "represent the month, day, and year seperated by " +
                             "a /, -, or . "
      ELSE IF fd-tp = 3 THEN "The formet for a Logical field should be two string to " +
                             "represent true and false separated by a /."
      ELSE "The format for an Integer or Decimal field should use 9, Z, z, ., ,, <, >, (, " +
           "), *, +, -, cr, dr, or db"
      SKIP " " SKIP
      IF fd-tp = 1 THEN "For example xxxxx or x(5). See help for more details."
      ELSE IF fd-tp = 2 THEN "For example 99/99/99 or 99/99/9999. See help for more details."
      ELSE IF fd-tp = 3 THEN "For example true/false, yes/no, or shipped/waiting. See help fpr more details."
      ELSE "For eample ->,>>>,>>9 or >,>>>,>>9cr. See help for more details."
      VIEW-AS ALERT-BOX ERROR BUTTON OK.
  ASSIGN
    fld-wdth = LENGTH(lbl,"RAW":U).
END.

RETURN.

/* _chkfmt.p - end of file */


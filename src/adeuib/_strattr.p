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

File: _strattr.p

Description:
   Validate a string attribute value the user has typed in.
   
Input Parameters:
   p_attr  : The string attribute value to validate.

Output Parameters:
   <none>

Returns: "error" if validation fails (a message will already have been
      	 displayed.  Otherwise "" is returned.   

Author: Laura Stern

Date Created: April 26, 1993

----------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER 	p_attr  	AS CHARACTER		NO-UNDO.


/*-------------------------------Macros----------------------------------*/

&GLOBAL-DEFINE IS_INT (if nxt_char >= "0" AND nxt_char <= "9" THEN yes else no)

/* Define a SKIP for alert-boxes that only exists under Motif */
&Global-define SKP &IF "{&WINDOW-SYSTEM}" = "OSF/Motif" &THEN SKIP &ELSE &ENDIF


/*------------------------------Variables--------------------------------*/

DEFINE VAR nxt_char  AS CHAR     NO-UNDO.
DEFINE VAR len       AS INTEGER  NO-UNDO.
DEFINE VAR ix        AS INTEGER  NO-UNDO INIT 1.
DEFINE VAR int_found AS LOGICAL  NO-UNDO INIT no.
DEFINE VAR is_int    AS LOGICAL  NO-UNDO INIT no.
DEFINE VAR u_found   AS LOGICAL  NO-UNDO INIT no.
DEFINE VAR j_found   AS LOGICAL  NO-UNDO INIT no. /* j for justification */
DEFINE VAR tmp_strng AS CHAR     NO-UNDO.
DEFINE VAR valid     AS LOGICAL  NO-UNDO INIT yes.


/*----------------------------Mainline Code------------------------------*/
/* ksu 02/23/94 LENGTH and SUBSTRING use default mode */
len = LENGTH(p_attr).

DO WHILE ix <= len AND valid:
   nxt_char = SUBSTR(p_attr, ix, 1).

   /* See if there's a # at the current position and if there
      if there is, skip by all the contiguous integer characters
      and flag that we've got an integer already.
   */
   is_int = {&IS_INT}.
   IF int_found AND is_int THEN 
      valid = no.
   ELSE DO:
      DO WHILE ix < len AND is_int:
   	 int_found = int_found OR is_int.
         ix = ix + 1.
         nxt_char = SUBSTR(p_attr, ix, 1).
      	 is_int = {&IS_INT}.
      END.
   
      /* If the next char is non-integer, see if it's valid */
      IF NOT is_int THEN 
      DO:
         IF CAN-DO ("L,R,T,C", nxt_char) 
         THEN DO:
   	    /* there can only be one of these in the string */
            IF j_found 
               THEN valid = no.
               ELSE j_found = yes.
   	 END.
         ELSE DO:
            IF nxt_char = "u" THEN
               IF u_found 
          	  THEN valid = no.
          	  ELSE u_found = yes.
   	    ELSE valid = no.
   	 END.
      END.

      ix = ix + 1.
   END. 
END.  /* end do while */

IF NOT valid THEN DO:
   MESSAGE "This is an invalid string attribute. It must have one" {&SKP}
           "of 'L,R,T or C' and/or a 'U' and/or one integer value." SKIP
           "Examples:" SKIP
           "  R12  - Right justify string in 12 spaces"  SKIP
           "  L10  - Left justify string in 10 spaces"   SKIP
           "  13   - Return first 13 characters (same as L13)" SKIP
           "  U    - String is ~"untranslatable~".  It cannot be" SKIP
           "         internationalized in the Translation Manager" SKIP
           "  T    - Trim blanks off either end of string"    SKIP
           "  CU30 - Center ~"untranslatable~" string in 30 spaces"  
   	   VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
   RETURN "error".
END.
tmp_strng = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(p_attr,"L":U,"":U),
                    "R":U,"":U),"T":U,"":U),"C":U,"":U),"U":U,"":U).
IF INTEGER(tmp_strng) > 5120 THEN DO:
  MESSAGE "String attribute may not have integer values greater than 5120.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN "error".
END.
RETURN "".


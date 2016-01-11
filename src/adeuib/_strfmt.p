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

File: _strfmt.p

Description:
   Given a string, return the string that will be displayed based on
   the associated string attribute.
   
Input Parameters:
   p_in_str  : The string to format
   p_attr    : The string attribute (e.g., L10)
   p_int_lbl : True if this is a column label for an integer field, 
      	       False otherwise.

Output Parameters:
   p_out_str : The formatted string.
   
Author: Laura Stern

Date Created: April 27, 1993

----------------------------------------------------------------------------*/
DEFINE INPUT        PARAMETER 	p_in_str    	AS CHARACTER		NO-UNDO.
DEFINE INPUT   	    PARAMETER 	p_attr  	AS CHARACTER      	NO-UNDO.
DEFINE INPUT   	    PARAMETER 	p_int_lbl 	AS LOGICAL      	NO-UNDO.
DEFINE OUTPUT       PARAMETER   p_out_str     	AS CHARACTER            NO-UNDO.

/* ===================================================================== */
/*                     LOCAL VARIABLES Definitions                       */
/* ===================================================================== */

DEFINE VARIABLE int_val AS INTEGER NO-UNDO INIT ?.    /* # val in attribute */
DEFINE VARIABLE left    AS LOGICAL NO-UNDO INIT no.   /* left justify */
DEFINE VARIABLE right   AS LOGICAL NO-UNDO INIT no.   /* right justify */
DEFINE VARIABLE len     AS INTEGER NO-UNDO.  	      /* in_str length */
DEFINE VARIABLE half    AS INTEGER NO-UNDO.  	      /* for center option */
DEFINE VARIABLE temp    AS CHAR    NO-UNDO.
DEFINE VARIABLE temp2   AS CHAR    NO-UNDO.

/*===============Degenerate Case: No attribute string========================*/
IF p_attr eq "" or p_attr eq ? THEN DO:
  p_out_str = p_in_str.
  RETURN.
END.

/*==============================Mainline Code================================*/

/* First - see if the attribute is ONLY a number (or only a number and a U).
   If so, default the justification to Left (most of the time) or Right if
   this is a column label for an integer field.
*/
/* ksu 02/23/94 LENGTH use raw mode and SUBSTRING use default mode */
ASSIGN len   = LENGTH(p_in_str, "raw":U)
       temp  = REPLACE (p_attr, "U", "")
       temp2 = SUBSTRING(temp,1,1)
       int_val = IF ASC(temp2) > 47 AND ASC(temp2) < 58 THEN INTEGER(temp)
                                                        ELSE ?.
IF int_val <> ? THEN  /* attribute has no alpha characters in it */
   IF p_int_lbl 
      THEN right = yes.
      ELSE left = yes.
ELSE DO:
   /* Let's extract out the number portion by replacing all possible
      characters with the null string.
   */
   ASSIGN temp = REPLACE (temp, "L", "") 
          temp = REPLACE (temp, "R", "") 
          temp = REPLACE (temp, "C", "") 
          temp = REPLACE (temp, "T", "").

   /* If there was no number at all, default to the string length. */
   IF temp = "" 
      THEN int_val = len.
      ELSE int_val = INTEGER (temp).
END.

/* 0 behaves like no number at all. */
IF int_val = 0 THEN int_val = len.

/* The "U" option is ignored.  This is only important for translation.
   So we are left with one of L,R,C or T.
   NOTE the degenerate case of int_val = len = 0 (i.e. we are asked to
   format NOTHING).  Just return NOTHING.
*/
IF int_val = 0 THEN p_out_str = "".
ELSE IF INDEX (p_attr, "T") <> 0 THEN
DO:
   /* If the attribute # is less than the non-trimmed! string length, the 
      string will be clipped but not trimmed! (I don't get this really).
      Otherwise, the string is trimmed.
   */
	/* ksu 03/08/94 SUBSTR use fiexed mode */
   if int_val < len then
      p_out_str = SUBSTR(p_in_str, 1, int_val, "fixed":U).
   else
      p_out_str = TRIM(p_in_str).
END.
ELSE IF INDEX (p_attr, "R") <> 0 OR right THEN
DO:
   /* Only if the attribute length is greater than the string length, 
      then pad on the left with blanks. Otherwise use STRING to format
      which, again, may chop off characters.
   */
   IF int_val > len THEN
      p_out_str = STRING(" ", SUBSTITUTE("x(&1)", int_val - len)) + p_in_str.
   ELSE 
      p_out_str = STRING(p_in_str, SUBSTITUTE("x(&1)", int_val)).
END.
ELSE IF INDEX (p_attr, "C") <> 0 THEN
DO:
   IF int_val > len THEN
   DO:
      /* Pad on the left with half the blanks (if there's an odd #, 1 fewer
      	 blanks end up on the left).
      */
      half = TRUNCATE ((int_val - len) / 2, 0).
      IF half > 0 THEN  /* This is a fix for 94-12-20-027. I think fill would be  */
                        /* better than STRING and SUBSTITUTE. DRH                 */
        p_in_str = STRING(" ", SUBSTITUTE("x(&1)", half)) + p_in_str.
   END.

   /* If int_val wasn't > len this does the whole job, otherwise, this 
      will add on any final blanks at the end (the other half of the blanks).
   */
   p_out_str = STRING(p_in_str, SUBSTITUTE("x(&1)", int_val)).
END.
ELSE IF INDEX (p_attr, "L") <> 0 OR left THEN
DO:
   /* Format the string with x(n) where n is the attr length.  This
      may cause characters to be chopped if n is less than the string 
      length.
   */
   p_out_str = STRING(p_in_str, SUBSTITUTE("x(&1)", int_val)).
END.





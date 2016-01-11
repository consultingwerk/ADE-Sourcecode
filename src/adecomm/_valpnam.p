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

File: _valpnam.p

Description:
   Check if an internal procedure name is a valid PROGRESS Internal
   Procedure name. OR check if an external name is valid for PROGRESS
   to recognize.
 
Input Parameter:
   p_name         - The PROGRESS internal procedure name to check.

   p_show_message - If TRUE, invalid name messages are displayed.
                    If FALSE, no messages are displayed.

   p_options      - 

          "_INTERNAL" - Check for valid internal procedure name.

          "_EXTERNAL" - Check for valid external procedure name.

Ouput Parameter:
   p_okay - Set to True if name is valid.

Author: John Palazzo

Date Created: May, 1995

----------------------------------------------------------------------------*/

DEFINE INPUT  PARAMETER p_name         AS CHARACTER    NO-UNDO.
DEFINE INPUT  PARAMETER p_show_message AS LOGICAL      NO-UNDO.
DEFINE INPUT  PARAMETER p_options      AS CHARACTER    NO-UNDO.
DEFINE OUTPUT PARAMETER p_okay         AS LOGICAL      NO-UNDO.

DEFINE VARIABLE temp-file       AS CHARACTER    NO-UNDO.       
DEFINE VARIABLE Invalid_Chars   AS CHARACTER    NO-UNDO
                INITIAL "?()=|~{~}<>:, ".
DEFINE VARIABLE i               AS INTEGER      NO-UNDO.

DO ON STOP UNDO, LEAVE: /* MAIN */
    /* Do not support commas in external procedure names. */
    IF p_options = "_EXTERNAL":U THEN ASSIGN Invalid_Chars = ",".
    
    ASSIGN p_name = TRIM(p_name).
    IF p_name = "" OR p_name = ? THEN
    DO:
      IF p_show_message THEN
      MESSAGE "Please enter a value for the name." SKIP
              "It may not be left blank or unknown."
              VIEW-AS ALERT-BOX WARNING IN WINDOW ACTIVE-WINDOW.
      RETURN.
    END.
    
    IF p_options = "_INTERNAL":U AND
       (p_name BEGINS "." OR R-INDEX(p_name, ".") = LENGTH(p_name, "CHARACTER":U)) THEN
    DO:
      IF p_show_message THEN
      MESSAGE "Procedure names cannot begin or end with a period." SKIP
              "Please enter another name."
               VIEW-AS ALERT-BOX WARNING IN WINDOW ACTIVE-WINDOW.
      RETURN.
    END.
    
    ASSIGN p_okay = TRUE.
    DO i = 1 to LENGTH(p_name,"CHARACTER":u) WHILE p_okay:
       ASSIGN p_okay = INDEX(Invalid_Chars ,
                             SUBSTRING(p_name,i,1,"CHARACTER":u)) = 0.
    END.
    IF NOT p_okay AND p_show_message THEN
       MESSAGE p_name SKIP(1)
              "This name contains at least one invalid character: " + 
               SUBSTRING(p_name,i - 1,1,"CHARACTER":u)  SKIP
              "Please enter another name."
              VIEW-AS ALERT-BOX WARNING IN WINDOW ACTIVE-WINDOW.
    RETURN.
END.

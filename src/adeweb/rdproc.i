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
File: rdproc.i

Description:
    Include file containing the internal procedures used to read files.

Author: Wm. T. Wood

Date Created: Feb. 18, 1997

---------------------------------------------------------------------------- */

/* ----------------------------------------------------------------------------
   tokenize -
      Divides the input line into tokens. A token is defined as either
      surrounded by spaces or by normal quotes. 
    
      p_case:
      4GL - Tokens surrounded by quotes are treated as 4GL.  That is,
            That is, all tildes are removed. (NOTE: the including program must
            include workshop/util4gl.i.
      HTML - Tokens surrounded by quotes
             have the &quot; replaced with " before returning. 
      
       
    Side Effect:
      This sets the token array which is global to this procedure.
   --------------------------------------------------------------------------- */
PROCEDURE tokenize :
  DEFINE INPUT PARAMETER p_line  AS CHAR    NO-UNDO.
  DEFINE INPUT PARAMETER p_case  AS CHAR    NO-UNDO.

  DEFINE VARIABLE i    AS INTEGER NO-UNDO.
  DEFINE VARIABLE ilen AS INTEGER NO-UNDO.
  DEFINE VARIABLE ipos AS INTEGER NO-UNDO.
  DEFINE VARIABLE l_4GL  AS LOGICAL NO-UNDO.
  DEFINE VARIABLE l_HTML AS LOGICAL NO-UNDO.
  
  /* Check the case. */
  IF p_case eq "4GL":U THEN l_4GL = yes.
  ELSE IF p_case eq "HTML":U THEN l_HTML = yes.

  ASSIGN token  = "" /* Erase all tokens */
         i      = 1
         p_line = TRIM(p_line)   /*  No blank tokens allowed. */
         ilen   = LENGTH (p_line, "CHARACTER":U)
         .
  DO WHILE ilen > 0 AND i <= {&MAX-TOKENS}:
    IF p_line BEGINS '"':U THEN DO:
      /* Handle special (bad case). */
      IF ilen < 2 THEN ASSIGN p_line = "":U.
      ELSE DO:
        ipos = INDEX(p_line, '"':U, 2).
        /* In 4GL code, we want to look for the closing " that is not preceeded
           by a tilde. */
        REPEAT WHILE l_4gl AND ipos > 0 AND R-INDEX(p_line, '~~':U, ipos) eq ipos - 1:
          if ipos + 1 > ilen THEN ipos = 0.
          ELSE ipos = INDEX(p_line, '"':U, ipos + 1).
        END. 
        IF ipos eq 0 
        THEN ASSIGN token[i] = SUBSTRING(p_line, 2, - 1, "CHARACTER":U)
                    p_line   = "" .
        ELSE ASSIGN token[i] = SUBSTRING(p_line, 2, ipos - 2, "CHARACTER":U)
                    p_line   = SUBSTRING(p_line, ipos + 1, - 1, "CHARACTER":U)
                    .            
        /* Do quote substitution, by default.  In 4GL substitute ~'s and special 
           characters. */
        IF l_HTML     THEN token[i] = REPLACE (token[i], "~&quot~;":U, '"':U).
        ELSE IF l_4GL THEN token[i] = 4gl-decode(token[i]).

      END. /* Longer than a single quote. */  
    END. /* Starts with QUOTE */
    ELSE DO:
      /* Go to the next space. */
      ipos = INDEX(p_line, " ":U).
      IF ipos eq 0 
      THEN ASSIGN token[i] = p_line
                  p_line   = "" .
      ELSE ASSIGN token[i] = SUBSTRING(p_line, 1, ipos - 1, "CHARACTER":U)
                  p_line   = SUBSTRING(p_line, ipos, - 1, "CHARACTER":U)
                  .            
    END.
    /* Get ready for next token. */
    ASSIGN  i      = i + 1
            p_line = LEFT-TRIM(p_line) /* No blank tokens. Right already trimmed. */
            ilen   = LENGTH (p_line, "CHARACTER":U)
            .
    
  END. /* DO WHILE... */     
 
END PROCEDURE.

/* rdproc.i - end of file */

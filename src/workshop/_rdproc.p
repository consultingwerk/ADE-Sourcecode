/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: _rdproc.p

Description:
    Readin the Procedure Settings for a procedure.

Input Parameters:
    p_proc-id:  The context id of the current procedure.
    p_mode     - Import Mode (OPEN, or OPEN UNTITLED)

Output Parameters:
   <None>

Author: Wm.T.Wood

Date Created: 1995

---------------------------------------------------------------------------- */

DEFINE INPUT PARAMETER p_proc-id AS INTEGER NO-UNDO.
DEFINE INPUT  PARAMETER p_mode       AS CHAR    NO-UNDO .

{workshop/objects.i}      /* Universal procedure TEMP-TABLE definition        */

DEFINE SHARED  STREAM    _P_QS.
DEFINE SHARED  VARIABLE  _inp_line  AS  CHAR     EXTENT 100           NO-UNDO.

DEFINE VAR i AS INTEGER NO-UNDO.

/* Use this to turn debugging on after each line that is read in. */
&Scoped-define debuga  message _inp_line[1] _inp_line[2] _inp_line[3] _inp_line[4] _inp_line[5] .

FIND _P WHERE RECID(_P) eq p_proc-id.

Find-Settings:
REPEAT:
  _inp_line = "".
  IMPORT STREAM _P_QS _inp_line.  {&debug}
  IF _inp_line[2] = "Settings":U THEN DO:
     Parse-Settings:
     REPEAT:
       _inp_line = "".
       IMPORT STREAM _P_QS _inp_line.  {&debug}
       CASE _inp_line[1]:
         WHEN "Type:"     THEN DO:
           ASSIGN _P._type = _inp_line[2].
           /* If we are creating a new procedure from a template, don't set the
              template flag */
           IF (_inp_line[3] eq "Template":U) AND p_mode ne "OPEN UNTITLED":U
           THEN _P._template = yes. 
         END.
         WHEN "Compile"   THEN _P._compile-into    = _inp_line[3].
         WHEN "Other"     THEN DO:
           /* Look at each of the remaining tokens in the line */
           i = 3.
           DO WHILE _inp_line[i] ne "":
             CASE _inp_line[i]:
               WHEN "COMPILE"      THEN  _P._compile = yes.
               WHEN "INCLUDE-ONLY" THEN DO:
                 _P._fileext = "i":U.
                 IF LOOKUP("INCLUDE":U, _P._type-list) eq 0 
                 THEN _P._type-list = _P._type-list + ",INCLUDE":U.
               END.
              END CASE.
            i = i + 1.
           END. /* DO... */
         END. /* WHEN Other */  
         
         WHEN "&ANALYZE-RESUME":U THEN LEAVE Find-Settings.
         
         /* Unsupported settings left over from UIB code.  Also unsupported are
            Other Settings: CODE-ONLY and PERSISTENT-ONLY. */
         WHEN "External"  OR
         WHEN "Allow:"    OR
         WHEN "Container" OR
         WHEN "Frames:"   OR
         WHEN "Design "   OR
         WHEN "Add"       THEN DO: /* Do nothing. */ END.

         OTHERWISE LEAVE Parse-Settings.
       END CASE.
     END. /* Parse-Settings: repeat... */
  END.
  IF _inp_line[1] = "&ANALYZE-RESUME":U THEN LEAVE Find-Settings.
END.  /* Find-Settings:... */


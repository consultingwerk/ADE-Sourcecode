/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/

/*-------------------------------------------------------------------------- 
File: _rdproc.p

Description:
    Read in the Procedure Settings for a procedure.

Input Parameters:
    p_proc-id:  The context id of the current procedure.
    p_mode     - Import Mode (WINDOW, or WINDOW UNTITLED)

Output Parameters:
   <None>

Author: Wm.T.Wood
Created: 1995
Updated: January 1998 adams Adapted for Skywalker 9.0a

-------------------------------------------------------------------------- */

DEFINE INPUT  PARAMETER p_proc-id AS INTEGER   NO-UNDO.
DEFINE INPUT  PARAMETER p_mode    AS CHARACTER NO-UNDO.

/* Shared Include File definitions */
{ adeuib/sharvars.i }    /* Shared variables                               */
{ adeuib/uniwidg.i }     /* Universal Widget TEMP-TABLE definition         */

DEFINE SHARED STREAM   _P_QS.
DEFINE SHARED VARIABLE _inp_line  AS CHARACTER EXTENT 100 NO-UNDO.

DEFINE VARIABLE ix AS INTEGER NO-UNDO.

&SCOPED-DEFINE debug-msg FALSE
&if {&debug-msg} &then
message "[_rdproc.p] #1" view-as alert-box.
&endif

/* Use this to turn debugging on after each line that is read in. */
&Scoped-define debuga  message _inp_line[1] _inp_line[2] _inp_line[3] _inp_line[4] _inp_line[5] .
FIND _P WHERE RECID(_P) eq p_proc-id.

Find-Settings:
REPEAT:
  _inp_line = "".
  IMPORT STREAM _P_QS _inp_line.  {&debug}
  
  &if {&debug-msg} &then
  message "[_rdproc.p] #2" skip
    _inp_line[1] _inp_line[2]  
    view-as alert-box.
  &endif
  
  IF _inp_line[2] = "Settings":U THEN DO:
     Parse-Settings:
     REPEAT:
       _inp_line = "".
       IMPORT STREAM _P_QS _inp_line.  {&debug}
       CASE _inp_line[1]:
         WHEN "Type:":U THEN DO:
           ASSIGN _P._type = _inp_line[2].
           /* If we are creating a new procedure from a template, don't set the
              template flag */
           IF (_inp_line[3] eq "Template":U) AND p_mode ne "WINDOW UNTITLED":U THEN
             _P._template = yes. 
         END.
         WHEN "Compile":U THEN _P._compile-into    = _inp_line[3].
         WHEN "Other":U   THEN DO:
           /* Look at each of the remaining tokens in the line */
           ix = 3.
           DO WHILE _inp_line[ix] ne "":
             CASE _inp_line[ix]:
               WHEN "COMPILE":U    THEN _P._compile = yes.
               WHEN "INCLUDE-ONLY" THEN _P._file-type = "i":U.
             END CASE.
             ix = ix + 1.
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

/* _rdproc.p - end of file */

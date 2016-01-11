/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* fbempty.p - Determine if a form or browse section is empty (devoid of 
      	       fields.

   Things don't work quite right if there is.  Someday we can be smarter
   and generate the code without referring to the empty sections.

  RETURN "error" if there are empty frames or "" if OK.
*/

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/_fdefs.i }
{ aderes/fbdefine.i }

/* These are in fbdefine.i ---
   Global defines:
      FNAM_COMP
      CALCULATED 
      TEXT_LIT   
      NOT_SUPPORTED_IN_BROWSE
      NOT_SUPPORTED_IN_FORM
*/

DEFINE INPUT PARAMETER usage AS CHARACTER NO-UNDO.

DEFINE VARIABLE qbf_i AS INTEGER   NO-UNDO. 
DEFINE VARIABLE qbf-l AS LOGICAL   NO-UNDO. 
DEFINE VARIABLE name  AS CHARACTER NO-UNDO. 
DEFINE VARIABLE stat  AS LOGICAL   NO-UNDO.

/* For macros */
DEFINE BUFFER qbf_sbuffer FOR qbf-section.
DEFINE VARIABLE qbf_l AS CHARACTER NO-UNDO.
DEFINE VARIABLE qbf_k AS INTEGER   NO-UNDO. 

section_loop:
FOR EACH qbf-section:
  qbf_l = "".
  {&GET_FRAME_SECTIONS}
  DO qbf_i = 1 TO qbf-rc#:
    IF qbf-module = "f":u THEN DO:
      IF {&NOT_SUPPORTED_IN_FORM} THEN NEXT. 
    END.
    ELSE DO: 
      IF {&NOT_SUPPORTED_IN_BROWSE} THEN NEXT. 
    END.
    {&IF_NOT_IN_FRAME_THEN_NEXT}

    /* we've got at least one field */
    NEXT section_loop.
  END.

  IF usage <> "f" THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"information":u,"ok":u,
      SUBSTITUTE("There are no fields chosen for one of the &1 sections.  You cannot work in Browse or Form view when there is an empty section.^^You must add new fields or reset your Master-Detail setting in order to use Browse or Form view.^^(You will be switched to Report View now.)",
      name)).

  ASSIGN
    qbf-redraw = TRUE
    qbf-module = "r":u.
  /* This calls _mstate to reset the menus for report view */
  RUN adeshar/_machk.p ({&resId}, OUTPUT stat).

  RETURN "error":u.
END.

RETURN "".

/* _fbempty.p -  end of file */


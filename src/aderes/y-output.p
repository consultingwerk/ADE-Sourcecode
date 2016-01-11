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
/*
* y-output.p - output to file
*/

&GLOBAL-DEFINE WIN95-BTN YES

{ aderes/s-system.i }
{ aderes/s-output.i }
{ aderes/reshlp.i }
{ adecomm/adestds.i }
{ aderes/_alayout.i }

DEFINE INPUT-OUTPUT PARAMETER qbf-f AS CHARACTER NO-UNDO. /* output file */
DEFINE OUTPUT PARAMETER       qbf-o AS LOGICAL   NO-UNDO. /* all okay? */

DEFINE VARIABLE qbf-c AS CHARACTER   NO-UNDO.  /* scrap */
DEFINE VARIABLE lRet  AS LOGICAL     NO-UNDO.

DEFINE BUTTON qbf-l LABEL "&Files...":l
  SIZE {&ADM_W_BUTTON} BY {&ADM_H_BUTTON}.

{ aderes/_asbar.i }

FORM
  SKIP({&TFM_WID})
  
  qbf-f AT 2 LABEL "F&ile" FORMAT "x(80)" {&STDPH_FILL}
    VIEW-AS FILL-IN SIZE 50 BY {&ADM_H_BUTTON}
    
  qbf-l
  SKIP({&VM_WID})

qbf-pr-app AT 2
    VIEW-AS TOGGLE-BOX LABEL "&Append to Existing File":t40
  SKIP({&VM_WID})

  {adecomm/okform.i
    &BOX    = rect_btns
    &STATUS = NO
    &OK     = qbf-ok
    &CANCEL = qbf-ee
    &HELP   = qbf-help}

  WITH FRAME qbf-output VIEW-AS DIALOG-BOX SIDE-LABELS THREE-D
  DEFAULT-BUTTON qbf-ok CANCEL-BUTTON qbf-ee
  TITLE "Print to File":t32.

/*--------------------------------------------------------------------------*/

ON LEAVE OF qbf-f DO:
  /* Check for bad names on Windows 3.1 only-- MSDOS based OS. */
  &if "{&OPSYS}" = "MSDOS":u &then

  DEFINE VARIABLE fName  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE dName  AS CHARACTER NO-UNDO.
  DEFINE VARIABLE suffix AS CHARACTER NO-UNDO.

  RUN adecomm/_osprefx.p(qbf-f:SCREEN-VALUE, OUTPUT dName, OUTPUT fName).

  IF NUM-ENTRIES(fName,".":u) = 2 THEN DO:
    ASSIGN
      suffix = ENTRY(2,fName,".":u)
      fName  = ENTRY(1,fName,".":u)
      .

    IF LENGTH(suffix,"RAW":u) > 3 THEN DO:
      RUN adecomm/_s-alert.p (INPUT-OUTPUT lRet, "error":u, "ok":u,
        SUBSTITUTE("The suffix, &1, has more than 3 characters.",
        suffix)).
      RETURN NO-APPLY.
    END.
  END.

  IF LENGTH(fName,"RAW":u) > 8 THEN DO:
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lRet, "error":u, "ok":u,
      SUBSTITUTE("The filename, &1, has more than 8 characters.",
      fName)).
    RETURN NO-APPLY.

  END.

  &endif
END.

ON CHOOSE OF qbf-l IN FRAME qbf-output DO:
  DEFINE VARIABLE ext-list AS CHARACTER EXTENT 3 NO-UNDO.

  ASSIGN
    ext-list[1] = "*.txt"
    ext-list[2] = "*.rpt"
    ext-list[3] = IF OPSYS = "UNIX":u THEN "*":u ELSE "*.*":u
    .

  SYSTEM-DIALOG GET-FILE qbf-f
    DEFAULT-EXTENSION ".txt":u
    SAVE-AS
    TITLE "Print To File":t32
    UPDATE lRet
    FILTERS
    "ASCII Text":t20 + " (":u + ext-list[1] + ")":u ext-list[1],
    "Reports":t20    + " (":u + ext-list[2] + ")":u ext-list[2],
    "All Files":t20  + " (":u + ext-list[3] + ")":u ext-list[3]
    INITIAL-FILTER 1
    .

  IF qbf-f > "" THEN
     qbf-f:SCREEN-VALUE IN FRAME qbf-output = qbf-f.

END.

ON VALUE-CHANGED OF qbf-pr-app IN FRAME qbf-output
  ASSIGN qbf-pr-app = INPUT FRAME qbf-output qbf-pr-app.

ON GO OF FRAME qbf-output DO:
            
  qbf-f = SEARCH(INPUT FRAME qbf-output qbf-f).

  IF qbf-f <> ? THEN DO:
    IF qbf-pr-app THEN
       lRet = TRUE.
    ELSE
    RUN adecomm/_s-alert.p (INPUT-OUTPUT lRet, "warning":u, "yes-no":u,
      SUBSTITUTE('&1 already exists.  Replace existing file?',
      qbf-f)).

    IF lRet <> TRUE THEN DO:
      qbf-o          = FALSE.
      APPLY "ENTRY":u TO qbf-f IN FRAME qbf-output.
      qbf-f:AUTO-ZAP = TRUE. /* re-select file name */
      RETURN NO-APPLY.
    END.
  END.

  ASSIGN
    qbf-o      = TRUE
    qbf-f      = INPUT FRAME qbf-output qbf-f.

END.

ON WINDOW-CLOSE OF FRAME qbf-output
  APPLY "END-ERROR" TO SELF.

/*--------------------------------------------------------------------------*/

{aderes/_arest.i
  &FRAME-NAME = qbf-output
  &HELP-NO    = {&Run_Output_to_File_Dlg_Box} }

{adecomm/okrun.i
  &FRAME = "FRAME qbf-output"
  &BOX   = rect_btns
  &OK    = qbf-ok
  &HELP  = qbf-help }

CASE qbf-module:
  WHEN "r":u THEN
    qbf-f = "report.txt":u.
  WHEN "l":u THEN
    qbf-f = "label.txt":u.
  WHEN "e":u THEN
    qbf-f = "export.txt":u.
END CASE.

qbf-f:SCREEN-VALUE IN FRAME qbf-output = qbf-f.
qbf-pr-app = FALSE.

ENABLE qbf-f qbf-l qbf-pr-app qbf-ok qbf-ee qbf-help
  WITH FRAME qbf-output.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  WAIT-FOR GO OF FRAME qbf-output.
END.

/* empty or unknown filename is treated same as end-error - no action */
IF qbf-f = "" OR qbf-f = ? THEN
qbf-o = FALSE.
IF qbf-o AND SEARCH(qbf-f) = ? THEN
qbf-pr-app = FALSE.

HIDE FRAME qbf-output NO-PAUSE.

RETURN.

/* y-output.p - end of file */


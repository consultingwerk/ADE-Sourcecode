/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * y-run.p - execute export/label/report procedure
 *
 * Input Parameters
 *
 *    usePrintDialog  1 = yes, 0 = no
 */

{ aderes/s-system.i }
{ aderes/s-define.i }
{ aderes/e-define.i }
{ aderes/l-define.i }
{ aderes/r-define.i }
{ aderes/y-define.i }
{ aderes/s-output.i }

DEFINE INPUT PARAMETER qbf-t          AS CHARACTER NO-UNDO. /* device type */
DEFINE INPUT PARAMETER qbf-n          AS CHARACTER NO-UNDO. /* device name */
DEFINE INPUT PARAMETER qbf-a          AS LOGICAL   NO-UNDO. /* append flag */
DEFINE INPUT PARAMETER usePrintDialog AS INTEGER   NO-UNDO.

/*
qbf-t = "clip" = To the system clipboard
      = "file" = Ask the user for a filename for the output destination
      = "prog" = Call a 4GL program to start/end output stream
      = "term" = To screen with prev-page and next-page (aka "page")
      = "thru" = THROUGH a UNIX or OS/2 spooler or filter
      = "to"   = TO a device, such as OUTPUT TO PRINTER
      = "view" = Send the report to a file, then execute this program
      = "vms"  = TO PRINTER, but surrounded by ASSIGN/JOB and DEASSIGN/JOB
*/

DEFINE VARIABLE qbf-b AS LOGICAL            NO-UNDO.
DEFINE VARIABLE qbf-c AS CHARACTER          NO-UNDO. /* scrap */
DEFINE VARIABLE qbf-d AS CHARACTER          NO-UNDO. /* output destination */
DEFINE VARIABLE qbf-e AS DECIMAL DECIMALS 3 NO-UNDO. /* used for etime */
DEFINE VARIABLE qbf-i AS INTEGER            NO-UNDO.
DEFINE VARIABLE qbf-l AS LOGICAL            NO-UNDO.
DEFINE VARIABLE qbf-p AS LOGICAL            NO-UNDO. /* MSW printed OK */
DEFINE VARIABLE qbf-s AS INTEGER            NO-UNDO. /* scrap # pages */

/* Can't print a form. Don't display an error message though. We just
   don't want to die if we get accidently. */
IF qbf-module = "f":u THEN RETURN.

RUN adecomm/_setcurs.p ("WAIT":u).

/*
> All you need to do to change printers on the fly on VMS is as follows:
>
> VMS SILENT assign/job sys$print sys$other_printer.
> output to printer. /* this is going to other_printer */
> {some progress code here}
> output close.
> VMS SILENT deassign/job sys$other_printer.
*/

/* massage input parameters */
IF qbf-t = "page":u OR KEYWORD-ALL(qbf-n) = "TERMINAL":u THEN 
  qbf-t = "term":u.
qbf-d = qbf-n.

CASE qbf-t:
  WHEN "vms":u      THEN qbf-d = "PRINTER":u.
  WHEN "clip":u     THEN qbf-d = "qbf3.d":u.
  WHEN "view":u     THEN qbf-d = qbf-tempdir + ".d":u.
  WHEN "defprint":u THEN qbf-d = IF "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u 
                                 THEN "qbf2.d":u ELSE "PRINTER":u.
  WHEN "term":u     THEN DO:
    DO qbf-i = 1 TO qbf-i + 1:
      qbf-d = qbf-tempdir + STRING(qbf-i) + ".d":u.
      FIND FIRST qbf-wsys WHERE qbf-wsys.qbf-wfile = qbf-d NO-ERROR.
      IF NOT AVAILABLE qbf-wsys THEN LEAVE.
    END.
  END.
END CASE.

/* Append only makes sense for output to FILE */
qbf-a = (qbf-a AND qbf-t = "file":u).

FIND FIRST qbf-esys.
FIND FIRST qbf-lsys.
FIND FIRST qbf-rsys WHERE qbf-rsys.qbf-live.

/* Each of the next sections will place the error message in qbf-c if a
   problem is found with the code about to be generated.  After the tests,
   then a dialog box is displayed if qbf-c <> ?.  If qbf-b is FALSE, then
   only the "ok" alert box will be used.  If qbf-b is TRUE, then the yes-no
   box will be used, allowing the user to continue despite the problem.
*/
qbf-c = ?.

/*--------------------------------------------------------------------------*/
/* export-specific validation */
/*
IF qbf-module = "e":u THEN DO:
  qbf-l = TRUE.
  DO qbf-i = 1 TO qbf-rc# WHILE qbf-l:
    qbf-l = NOT qbf-rcc[qbf-i] BEGINS "e":u.
  END.
  IF NOT qbf-l THEN
    ASSIGN
      qbf-c = "Cannot generate exports with stacked arrays."
      qbf-b = FALSE.
END.
*/
/*--------------------------------------------------------------------------*/
/* label-specific validation */

/*
 * The check to see if there any labels has been moved into _mstate. This
 * function will not be available to the user if there are no labels.
 */

IF qbf-module = "l":u THEN DO:
  DO qbf-i = EXTENT(qbf-l-text) TO 1 BY -1:
    IF qbf-l-text[qbf-i] > "" THEN LEAVE.
  END.

  qbf-l = (qbf-i <= qbf-lsys.qbf-label-ht).

  IF NOT qbf-l THEN
    ASSIGN
      qbf-c = SUBSTITUTE("Your label height is &1, but you have &2 lines defined.  Some information will not fit on the label size you have defined, and therefore will not be printed.  Do you still want to continue and print these labels?",
      qbf-lsys.qbf-label-ht,qbf-i)
      qbf-b = TRUE.
  ELSE IF qbf-i = 0 THEN
    ASSIGN
      qbf-c = "Cannot generate labels with no fields defined."
      qbf-b = FALSE.
END. /* qbf-module = "l" */

/*--------------------------------------------------------------------------*/
/* do report-specific validation */

IF qbf-module = "r":u THEN DO:
  qbf-c = ?.
  IF qbf-tables <> "" AND qbf-rcn[1] = "" THEN
    ASSIGN
      qbf-c = "Cannot generate report with no fields defined."
      qbf-b = FALSE.
  ELSE
  IF qbf-rsys.qbf-width > 255 THEN
    ASSIGN
      qbf-c = "Cannot generate report greater than 255 columns."
      qbf-b = FALSE.
  ELSE
  IF NOT qbf-summary THEN .

  /*
  ELSE
  IF qbf-sortby = "" THEN
    ASSIGN
      qbf-c = "Cannot generate Totals Only report when no order-by fields are defined."
      qbf-b = FALSE.
  */

  ELSE DO qbf-i = 1 TO qbf-rc# WHILE qbf-c = ?:
    IF qbf-rcc[qbf-i] BEGINS "e":u THEN
      ASSIGN
        qbf-c = "Cannot generate Totals Only report with stacked-array fields defined."
        qbf-b = FALSE.
  END.
END.
/*--------------------------------------------------------------------------*/

/* present alert boxes! */
IF qbf-c <> ? THEN DO:
  qbf-l = TRUE.
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,
    TRIM(STRING(qbf-b,"warning/error":u)), TRIM(STRING(qbf-b,"yes-no/ok":u)),
    qbf-c).

  IF (NOT qbf-b) OR (qbf-b AND NOT qbf-l) THEN DO:
    RUN adecomm/_setcurs.p ("":u).

    RETURN.
  END.
END.

/*--------------------------------------------------------------------------*/
/* make call to program to generate code */

CASE qbf-module:
  WHEN "e":u THEN
    RUN adecomm/_statdsp.p (wGlbStatus, 1, "Generating export program...":t72).
  WHEN "l":u THEN
    RUN adecomm/_statdsp.p (wGlbStatus, 1, "Generating labels program...":t72).
  OTHERWISE
    RUN adecomm/_statdsp.p (wGlbStatus, 1, "Generating program...":t72).
END CASE.

RUN aderes/s-write.p (qbf-tempdir + ".p":u, "r":u).

/*--------------------------------------------------------------------------*/
/* compile program just created on-the-fly */

CASE qbf-module:
  WHEN "e":u THEN
    RUN adecomm/_statdsp.p (wGlbStatus, 1, "Compiling export program...":t72).
  WHEN "l":u THEN
    RUN adecomm/_statdsp.p (wGlbStatus, 1, "Compiling labels program...":t72).
  OTHERWISE
    RUN adecomm/_statdsp.p (wGlbStatus, 1, "Compiling generated program...":t72).
END CASE.

IF SEARCH(qbf-tempdir + ".r":u) = qbf-tempdir + ".r":u THEN
  OS-DELETE VALUE(qbf-tempdir + ".r":u).

qbf-l = TRUE.
DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  COMPILE VALUE(qbf-tempdir + ".p":u) NO-ATTR-SPACE.
  qbf-l = (COMPILER:ERROR <> FALSE).
END.

IF qbf-l THEN DO: /* compile error! */
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,SUBSTITUTE(
    "The program that was generated would not compile." +
    "  Contact your Systems Administrator for further" +
    " assistance with the following message codes:^^" +
    "&1, &2, &3, &4, &5.", _MSG(1),_MSG(2),_MSG(3),_MSG(4),_MSG(5))).

  OUTPUT TO VALUE(qbf-qcfile + ".ql":u) NO-ECHO APPEND.
  PUT UNFORMATTED
    SUBSTITUTE("** Compile error - last 5 error codes: &1,&2,&3,&4,&5.":u,
      _MSG(1),_MSG(2),_MSG(3),_MSG(4),_MSG(5)) SKIP.
  OUTPUT CLOSE.

  RUN adecomm/_setcurs.p("":u).
  RETURN.
END.

/*--------------------------------------------------------------------------*/
/* run generated program */

RUN adecomm/_statdsp.p (wGlbStatus, 1, "Running generated program...":t72).

ASSIGN
  qbf-count = 0
  qbf-l     = TRUE.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO,LEAVE:
  /* the vms stuff may be important later. So leave it. 
    IF qbf-t = "vms":u THEN
      VMS SILENT "ASSIGN/JOB SYS$PRINT" VALUE(qbf-n).  */

  /* RESULTS core printing boils down to:
   *    Print Preview:      qbf-t = "term", print a temp file out
   *    To File:            qbf-t = "file", write the output to the supplied .p
   *    To Clipboard:       qbf-t = "clip"
   *    To Default Printer: qbf-t = "defprint"
   *
   * Admins will create features to do "thru" and "to" printers.
   */

  IF qbf-t = "clip":u THEN
    OUTPUT TO VALUE(qbf-d) PAGE-SIZE VALUE(qbf-rsys.qbf-page-size).
  
  ELSE
  IF qbf-t = "file":u AND qbf-a THEN DO:
    IF qbf-module = "r":u AND qbf-d <> "PRINTER":u THEN
      OUTPUT TO VALUE(qbf-d) PAGE-SIZE VALUE(qbf-rsys.qbf-page-size) APPEND.
    ELSE
      OUTPUT TO VALUE(qbf-d) PAGE-SIZE 0 APPEND.
  END.

  ELSE DO: /* term, defprint */
    IF CAN-DO("l,r":u, qbf-module) THEN
      OUTPUT TO VALUE(qbf-d) PAGE-SIZE VALUE(qbf-rsys.qbf-page-size).
    ELSE
      OUTPUT TO VALUE(qbf-d) PAGE-SIZE 0.
  END.
  
  qbf-e = ETIME.

  IF qbf-t = "prog":u THEN
    RUN VALUE(qbf-d) (qbf-tempdir + ".p":u).
  ELSE
    RUN VALUE(qbf-tempdir + ".p":u).

  ASSIGN
    qbf-e = (ETIME - qbf-e) * .001
    qbf-l = FALSE.
END.

OUTPUT CLOSE.

IF (qbf-t = "defprint":u AND "{&WINDOW-SYSTEM}":u BEGINS "MS-WIN":u)
  OR (NOT qbf-l AND qbf-t = "term":u) THEN DO:
  
  /* prescan for number of pages - dma */
  INPUT FROM VALUE(qbf-d) NO-ECHO.
  ASSIGN
    qbf-i = 0
    qbf-s = 1.
  
  REPEAT:
    IMPORT UNFORMATTED qbf-c.
    qbf-i = qbf-i + 1.

    IF qbf-c BEGINS CHR(12) OR 
      (qbf-module = "e":u AND qbf-rsys.qbf-page-size = qbf-i) THEN 
      ASSIGN
        qbf-s = qbf-s + 1
        qbf-i = 0.
  END.
  INPUT CLOSE.

  IF qbf-i = 0 THEN /* found page break on last line */
    qbf-s = qbf-s - 1.

  IF qbf-t = "defprint":u THEN DO:
    RUN adecomm/_setcurs.p ("":u).
    RUN adecomm/_osprint.p (qbf-win, qbf-d, 0, usePrintDialog,
                            (IF qbf-d <> "PRINTER":u THEN 0
                             ELSE qbf-rsys.qbf-page-size), 
                             qbf-s, OUTPUT qbf-p).
  END.
END.

/* load from qbf3.d to clipboard */
IF qbf-t = "clip":u THEN DO:
  FORM
    qbf-c VIEW-AS EDITOR LARGE SIZE 1 BY 1
    WITH FRAME a.
  
  IF SEARCH(qbf-d) = ? THEN
    RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-b, "error":u, "ok":u,
      SUBSTITUTE('Could not read from file "&1".', qbf-d)).

  ELSE DO:
    qbf-b = qbf-c:INSERT-FILE(qbf-d) IN FRAME a.

    CLIPBOARD:VALUE = qbf-c:SCREEN-VALUE IN FRAME a.
    OS-DELETE VALUE(qbf-d).
  END.
END.

DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE:
  IF qbf-t = "vms":u THEN
    VMS SILENT "DEASSIGN/JOB":u VALUE(qbf-n).
END.

/* qbf-l is TRUE here if there was an error in creating the output */
ASSIGN         /* if report didn't work, blow away time value */
  qbf-i      = ROUND(IF qbf-l THEN 0 ELSE qbf-e,0)
  qbf-timing = STRING(TRUNCATE(qbf-i / 60,0)) + ":":u
             + STRING(qbf-i MODULO 60,"99":u).

/*--------------------------------------------------------------------------*/
/* now view the thing */
RUN adecomm/_statdsp.p (wGlbStatus, 1, "").

IF NOT qbf-l AND qbf-t = "term":u THEN 
  RUN aderes/y-page.p (qbf-d, qbf-s).

IF NOT qbf-l AND qbf-t = "view":u THEN DO:
  qbf-c = qbf-d + " ":u + qbf-tempdir + ".d":u.
  DO ON ERROR UNDO,LEAVE ON ENDKEY UNDO,LEAVE ON STOP UNDO,LEAVE:
    OS-COMMAND VALUE(qbf-c).
/* JEP-WIN32 7/11/97 3:47PM
    CASE OPSYS:
      WHEN "BTOS":u  THEN BTOS VALUE(qbf-c).
      WHEN "MSDOS":u THEN DOS  VALUE(qbf-c).
      WHEN "OS2":u   THEN OS2  VALUE(qbf-c).
      WHEN "UNIX":u  THEN UNIX VALUE(qbf-c).
      WHEN "VMS":u   THEN VMS  VALUE(qbf-c).
    END CASE.
*/
  END.
END.

IF qbf-l THEN
  RUN adecomm/_s-alert.p (INPUT-OUTPUT qbf-l,"error":u,"ok":u,SUBSTITUTE(
    'Could not write to file or device "&1".', qbf-d)).
ELSE IF qbf-count < 0 THEN .
ELSE DO:
  ASSIGN
    qbf-c = IF qbf-module = "e":u THEN "&1 records exported.":t72
       ELSE IF qbf-module = "l":u THEN "&1 labels printed.":t72
       ELSE "&1 records processed.":t72.
  RUN adecomm/_statdsp.p (wGlbStatus, 1, SUBSTITUTE(qbf-c,qbf-count)).
END.

/*--------------------------------------------------------------------------*/

RUN adecomm/_setcurs.p ("":u).

RETURN.

/* y-run.p - end of file */


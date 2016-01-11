/* rtb_open.p  --  Open an object based on filename extension.
 * 1995 by John Green.
 *
 * See the Roundtable manual for a description of the parameters
 * and shared variables for this program.
 *
 * This program should serve as an example "Edit Program" for code
 * subtypes that should not be edited with the Procedure Window.
 *
 * This example assumes that your code subtype only has one part.
 */


/* --- Define parameters --- */
DEFINE INPUT  PARAMETER Pmode            AS CHARACTER NO-UNDO.
DEFINE OUTPUT PARAMETER Perror           AS CHARACTER NO-UNDO.


/* --- Define shared --- */
DEFINE SHARED VARIABLE Urtb-object     AS CHARACTER           NO-UNDO.
DEFINE SHARED VARIABLE Urtb-part       AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE SHARED VARIABLE Urtb-part-desc  AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE SHARED VARIABLE Urtb-path       AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE SHARED VARIABLE Urtb-name       AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE SHARED VARIABLE Urtb-tmpl       AS CHARACTER EXTENT 10 NO-UNDO.
DEFINE SHARED VARIABLE Urtb-num-parts  AS INTEGER             NO-UNDO.
DEFINE SHARED VARIABLE Urtb-sub-type   AS CHARACTER           NO-UNDO.
DEFINE SHARED VARIABLE Urtb-userid     AS CHARACTER           NO-UNDO.
DEFINE SHARED VARIABLE Urtb-task-num   AS INTEGER             NO-UNDO.
DEFINE SHARED VARIABLE Urtb-task-desc  AS CHARACTER           NO-UNDO.
DEFINE SHARED VARIABLE Urtb-propath    AS CHARACTER           NO-UNDO.
DEFINE SHARED VARIABLE Urtb-ws-propath AS CHARACTER           NO-UNDO.
DEFINE SHARED VARIABLE Urtb-mod-dir    AS CHARACTER           NO-UNDO.


/* --- Define locals --- */
DEFINE VARIABLE Mfile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Mcount   AS INTEGER   NO-UNDO.
DEFINE VARIABLE Merr-num AS INTEGER   NO-UNDO.
DEFINE VARIABLE Mok      AS LOGICAL   NO-UNDO.


/*............................end definitions..........................*/


/* --- Only need to view or edit bitmaps. --- */
IF Pmode <> "Edit" AND Pmode <> "View" THEN
  RETURN.


/* --- Translate the slashes ---
 * Roundtable uses Unix style slashes.  Translate these to DOS
 * style slashes before passing the filename to shell32.dll.
 * The shared variable Urtb-path holds the full paths to the
 * object parts.  In this example, we assume that the object
 * only has one part.
 * ----------------------------- */
ASSIGN Mfile = REPLACE( Urtb-path[1], "/", "~\" ).


/* --- Pass a context number to Roundtable ---
 * Roundtable tracks open objects by context number, which is any
 * unique identifier.  See _adeevnt.p for a description of p_context.
 * ------------------------------------------- */
RUN adecomm/_adeevnt.p
    ( INPUT "rtb_open",                         /* product id         */
      INPUT "open",                             /* event              */
      INPUT STRING(THIS-PROCEDURE:HANDLE),      /* context            */
      INPUT Mfile,                              /* p_other = filename */
      OUTPUT Mok ).                             /* ignored            */

IF Urtb-sub-type BEGINS "Doc":U THEN
  DO:
    RUN launch-word (INPUT Mfile).
    RETURN.
  END.

IF Urtb-sub-type BEGINS "Excel":U THEN
  DO:
    RUN launch-excel (INPUT Mfile).
    RETURN.
  END.

RUN ShellExecuteA
    ( INPUT  0,          /* Do not pass window handle                */
      INPUT  "Open",     /* Open the file                            */
      INPUT  Mfile,      /* File to open                             */
      INPUT  "",         /* Parameters if Mfile is executable        */
      INPUT  "",         /* Default directory                        */
      INPUT  1,          /* Don't hide execution window              */
      OUTPUT Merr-num ). /* Value between 0 and 32 indicates success */

/*.........................internal procedures..........................*/


PROCEDURE ShellExecuteA EXTERNAL "shell32.dll":
  DEFINE  INPUT PARAMETER  hwnd          AS SHORT.
  DEFINE  INPUT PARAMETER  lpszOp        AS CHAR.
  DEFINE  INPUT PARAMETER  lpszFile      AS CHAR.
  DEFINE  INPUT PARAMETER  lpszParams    AS CHAR.
  DEFINE  INPUT PARAMETER  lpszDir       AS CHAR.
  DEFINE  INPUT PARAMETER  fsShowCmd     AS SHORT.
  DEFINE  RETURN PARAMETER err-num       AS SHORT.
END PROCEDURE.  /* --- ShellExecuteA --- */


PROCEDURE launch-word :
/*------------------------------------------------------------------------------
  Purpose:     To launch Microsoft Word
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ip_file     AS CHARACTER         NO-UNDO.

    DEFINE VARIABLE chWordApplication  AS COM-HANDLE        NO-UNDO.
    DEFINE VARIABLE chDocument         AS COM-HANDLE        NO-UNDO.
    DEFINE VARIABLE chWorkSheet        AS COM-HANDLE        NO-UNDO.

    IF SESSION:SET-WAIT-STATE("GENERAL") THEN PROCESS EVENTS.

    CREATE "Word.Application" chWordApplication.        /* create new Word Application object   */
    chDocument = chWordApplication:Documents:Open(ip_file BY-VARIANT-POINTER).     /* create a new Document                */
    chWordApplication:Visible = True.                   /* Make the application visible         */

    IF SESSION:SET-WAIT-STATE("") THEN PROCESS EVENTS.

    RELEASE OBJECT chDocument.
    RELEASE OBJECT chWordApplication.

END PROCEDURE.

PROCEDURE launch-excel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER ip_file     AS CHARACTER         NO-UNDO.

/* This procedure will launch Microsoft Excel */
 
    DEFINE VARIABLE chExcelApplication AS COM-HANDLE        NO-UNDO.
    DEFINE VARIABLE chWorkBook         AS COM-HANDLE        NO-UNDO.
    DEFINE VARIABLE chWorkSheet        AS COM-HANDLE        NO-UNDO.

    IF SESSION:SET-WAIT-STATE("GENERAL") THEN PROCESS EVENTS.
    CREATE "Excel.Application" chExcelApplication. 
                /* create new Excel Application object */
                /* launch Excel so it is visible to the user */
    chWorkbook = chExcelApplication:Workbooks:Open(ip_file).
                /* create a new Workbook */
    chWorkSheet = chExcelApplication:Sheets:Item(1).
                /* get the active Worksheet */    
    /*chWorkSheet:Name = "Browser".*/

    IF SESSION:SET-WAIT-STATE("") THEN PROCESS EVENTS.
    chExcelApplication:Visible = True.

    RELEASE OBJECT chWorkSheet.
    RELEASE OBJECT chWorkBook.
    RELEASE OBJECT chExcelApplication.

END PROCEDURE.

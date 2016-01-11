/* rtb/adecomm/_getfile.p  --  Roundtable intercept of Common GetFile Dialog.
 * October, 1995 by John Green
 *
 * When Roundtable is active, this routine will be in the PROPATH before
 * Progress's standard _getfile.p.
 *
 * Grtb-proc-handle is a global shared variable; the procedure
 * handle to the Roundtable Tabletop.  We first run the Roundtable
 * Tabletop's 'intercept_getfile', which will tell this program to
 *    1) use the object selected within Roundtable,
 * or 2) cancel the get file operation, 
 * or 3) carry on with this program, to get a file not managed
 *       by Roundtable.
 *
 * Roundtable only intercepts if the product is UIB or Procedure.
 */


DEFINE INPUT        PARAMETER p_Window   AS WIDGET-HANDLE NO-UNDO.
DEFINE INPUT        PARAMETER p_product  AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER p_action   AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER p_title    AS CHAR    NO-UNDO.
DEFINE INPUT        PARAMETER p_mode     AS CHAR    NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER p_filename AS CHAR    NO-UNDO.
DEFINE       OUTPUT PARAMETER p_ok       AS LOGICAL NO-UNDO.

DEFINE SHARED VARIABLE Grtb-proc-handle AS HANDLE NO-UNDO.

DEFINE VARIABLE Mgetfile    AS CHARACTER NO-UNDO.
DEFINE VARIABLE Mrtb-action AS CHARACTER NO-UNDO.

/*
message
  "p_Window" p_Window
  skip
  "p_product" p_product
  skip
  "p_action" p_action
  skip
  "p_title" p_title
  skip
  "p_mode" p_mode
  skip
  "p_filename" p_filename.
*/


IF VALID-HANDLE( Grtb-proc-handle )
AND CAN-DO("UIB,Procedure",p_product)
AND p_product <> ?
THEN DO:
  RUN intercept_getfile IN Grtb-proc-handle
      ( INPUT  p_Window ,
        INPUT  p_product,
        INPUT  p_action,
        INPUT  p_title,
        INPUT  p_mode,
        INPUT-OUTPUT p_filename,
        OUTPUT Mrtb-action ).
  CASE Mrtb-action:
    WHEN "Cancel" THEN DO:
      ASSIGN p_ok = NO.
      RETURN.
    END.
    WHEN "Go" THEN DO:
      ASSIGN p_ok = YES.
      RETURN.
    END.
    OTHERWISE DO: /* nothing */ END.
  END CASE.
END.   /* --- valid-handle(Grtb-proc-handle) --- */




/* --- If we got this far, then we want to run PSC's getfile dialog. ---
 * Use the path to _adeload.r as the full path to _getfile.r.
 * (It is supposed to be in the same adecomm directory, and Roundtable has no
 *  intercept for _adeload.r.)
 * Don't use GET-KEY-VALUE to get DLC, just in case something weird has been
 * done with the path to GUI/ADECOMM.
 * --------------------------------------------------------------------- */
ASSIGN Mgetfile = SEARCH("adecomm/_adeload.r").
IF Mgetfile = ? THEN DO:
  MESSAGE "Roundtable was unable to find adecomm/_adeload.r." SKIP
          "Please ensure that your propath to PROGRESS is set correctly."
          VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.
ASSIGN Mgetfile = REPLACE(Mgetfile,"_adeload","_getfile").
IF SEARCH(Mgetfile) = ? THEN DO:
  MESSAGE "Roundtable was unable to find adecomm/_getfile.r." SKIP
          "Please ensure that your propath to PROGRESS is set correctly."
          VIEW-AS ALERT-BOX ERROR.
  RETURN.
END.
/* Note: p_filename may have been set to contain UNIX style slashes ("/")
 * by Roundtable, but that will break the SYSTEM-DIALOG GETFILE in
 * PROGRESS 8.2A+. So, when we run GUI/ADECOMM/_getfile.r, we make sure
 * that we pass it p_filename with "\" instead of "/".
 */
ASSIGN p_filename = REPLACE(p_filename,"/","~\").
RUN VALUE( Mgetfile )
    ( INPUT        p_Window,
      INPUT        p_product,
      INPUT        p_action,
      INPUT        p_title,
      INPUT        p_mode,
      INPUT-OUTPUT p_filename,
      OUTPUT       p_ok ).

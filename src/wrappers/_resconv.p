/*********************************************************************
* Copyright (C) 2000-2007 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: resconv.p

Description:
   This is the startup program for the TTY to GUI Results converter.
   It will start up the program appropriate for the environment.

Author: D. Lee

Date Created: 4/5/94

----------------------------------------------------------------------------*/

/*
ON CTRL-G GET.	/* The V6 dictionary code uses GET/PUT functions which are */
ON CTRL-P PUT.  /* not currently mapped in the GUI key bindings */
*/

DEFINE VARIABLE found    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lname    AS CHARACTER NO-UNDO INITIAL ?. /* logical db name */
DEFINE VARIABLE plFile   AS CHARACTER NO-UNDO INITIAL ?.
DEFINE VARIABLE pname    AS CHARACTER NO-UNDO INITIAL ?. /* physical db name */
DEFINE VARIABLE qbf-i    AS INTEGER   NO-UNDO.
DEFINE VARIABLE savePath AS CHARACTER NO-UNDO.
DEFINE VARIABLE type     AS CHARACTER NO-UNDO INITIAL ?. /* db type */

/* If this is WebSpeed, exit */
IF SESSION:CLIENT-TYPE = "WEBSPEED" THEN RETURN ERROR.

SESSION:THREE-D = TRUE.

/* No database connected, so do it now */
IF NUM-DBS = 0 THEN DO:
  RUN adecomm/_dbconn.p (INPUT-OUTPUT pname,
                         INPUT-OUTPUT lname,
                         INPUT-OUTPUT type).
  
  IF pname = ? THEN QUIT.
END.

/*
 * Save and set the PROPATH to get at the proclib. Look for it in the PROPATH.
 * If it isn't there then look for it in DLC.
 */
DO qbf-i = 1 TO NUM-ENTRIES(PROPATH):
  IF INDEX(ENTRY(qbf-i, PROPATH), "aderes.pl":u) > 0 THEN DO:
    found = TRUE.
    LEAVE.
  END.
END.

/* If proclib not found in the PATH then modify the path ourselves */
savePath = PROPATH.

IF NOT found THEN DO:
  plFile = SEARCH("aderes.pl":u).

  /* If the environment variable isn't set then look for it in the PROPATH. */
  IF plFile = ? THEN DO:
    plFile = OS-GETENV("DLC":u).

    IF plFile = ? THEN DO:

      /* Haven't found the proclib in PROPATH and there is no DLC
       * environment variable.
       */
      MESSAGE "The procedure libary for this product, aderes.pl" SKIP
              "could not be found in the PROPATH and DLC is not set."
              VIEW-AS ALERT-BOX.
      RETURN.
    END.
    
    plFile = plFile + "/gui/aderes.pl":u.
    
    /* Make sure that the file is there. */
    IF SEARCH(plFile) = ? THEN DO:
      MESSAGE "The procedure libary for this product," SKIP
              plFile + "," SKIP
              "could not be found."
              VIEW-AS ALERT-BOX.
      RETURN.
    END.
  END.

  PROPATH = ",":u + plFile + ",":u + PROPATH.
END.

{ adecomm/adewrap.i
  &TTY     = aderesc/_ttyconv.p
  &MSWIN   = aderesc/_ttyconv.p
  &MOTIF   = aderesc/_ttyconv.p
  &PRODUCT = "RESCONV"
}

/* _resconv.p - end of file */


/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*----------------------------------------------------------------------------

File: results.p

Description:
   This is the startup program for RESULTS.  It will start up the
   program appropriate for the environment.

Author: John Harris

Date Created: 10/26/92

----------------------------------------------------------------------------*/

&GLOBAL-DEFINE restorePath 1
/*
ON CTRL-G GET.	/* The V6 dictionary code uses GET/PUT functions which are */
ON CTRL-P PUT.  /* not current mapped in the GUI key bindings */
*/

/*
 * Save and the set the propath to get at the proc lib. Look for the proclib
 * in PROPATH. IF it isn't there then look for it in the DLC.
 */

&IF "{&WINDOW-SYSTEM}" <> "TTY" &THEN 
DEFINE VARIABLE found    AS LOGICAL   NO-UNDO.
DEFINE VARIABLE plFile   AS CHARACTER NO-UNDO INITIAL ?.
DEFINE VARIABLE qbf-i    AS INTEGER   NO-UNDO.
DEFINE VARIABLE savePath AS CHARACTER NO-UNDO.

DO qbf-i = 1 TO NUM-ENTRIES(PROPATH):
  IF INDEX(ENTRY(qbf-i, PROPATH), "aderes.pl":u) > 0 THEN DO:
    found = TRUE.
    LEAVE.
  END.
END.

/* If we don't find the proclib in the PATH then modify the path ourselves */
savePath = PROPATH.

IF NOT found THEN DO:
  plFile = SEARCH("aderes.pl":u).

  /*
   * If the environment variable isn't set then simply look for it
   * in the current PROPATH.
   */
  IF plFile = ? THEN DO:
    plFile = OS-GETENV("DLC":u).

    IF plFile = ? THEN DO:
      /*
       * Haven't found aderes.pl in the PROPATH and there
       * is no DLC environment variable.
       */
      MESSAGE "The procedure library for this product, aderes.pl," SKIP
              "could not be found in the PROPATH and DLC is not set."
              VIEW-AS ALERT-BOX ERROR.
    
      RETURN.
    END.
    
    plFile = plFile + "/gui/aderes.pl":u.
    
    /* Make sure that the file is there. */
    IF SEARCH(plFile) = ? THEN DO:
      MESSAGE "The procedure library for this product," SKIP 
              plFile + "," SKIP
              "could not be found."
              VIEW-AS ALERT-BOX ERROR.

      RETURN.
    END.
  END.

  PROPATH = ",":u + plFile + ",":u + PROPATH.
END.
&ENDIF

{ adecomm/adewrap.i
  &TTY     = prores/prores.p
  &MSWIN   = aderes/aderes.p
  &MOTIF   = aderes/aderes.p
  &PRODUCT = "RESULTS"
  &SETCURS = WAIT
}

/* results.p - end of file */


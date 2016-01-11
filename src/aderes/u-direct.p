/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/*
 * u-direct.p - program to switch query directories
 *
 *  This program provides the user interface for the "Switch Directories"
 *  button in the "Open ..." menu.  It is also used by "Application Rebuild"
 *  to locate query directories to rebuild after a schema change.
 */

{ aderes/af-idefs.i }

DEFINE INPUT-OUTPUT PARAMETER qbf-d AS CHARACTER NO-UNDO.
DEFINE OUTPUT       PARAMETER qbf-l AS LOGICAL NO-UNDO.

SYSTEM-DIALOG GET-FILE qbf-d 
  DEFAULT-EXTENSION {&qdExt}
  TITLE "Select Query Directory"
  /* MUST-EXIST */
  SAVE-AS
  UPDATE qbf-l
  FILTERS "Query Directories" "*{&qdUqExt}".

RETURN.

/* u-direct.p -  end of file */


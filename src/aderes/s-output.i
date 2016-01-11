/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-output.i - output device stuff: */

/* current output device */
DEFINE {1} SHARED VARIABLE qbf-device   AS INTEGER   INITIAL 1 NO-UNDO.

/* append to existing file */
DEFINE {1} SHARED VARIABLE qbf-pr-app   AS LOGICAL             NO-UNDO.

/* total number of output devices */
DEFINE {1} SHARED VARIABLE qbf-printer# AS INTEGER             NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-printer  AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-dev   AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-init  AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-perm  AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-type  AS CHARACTER EXTENT 64 NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-width AS INTEGER   EXTENT 64 NO-UNDO.

/*
type includes:
  to   - output to value() no-echo.
  thru - output thru value() no-echo.
  view - browse program
  prog - link to user-supplied 4GL program for output
*/

/* s-output.i - end of file */


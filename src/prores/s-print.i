/*********************************************************************
* Copyright (C) 2000 by Progress Software Corporation. All rights    *
* reserved. Prior versions of this work may contain portions         *
* contributed by participants of Possenet.                           *
*                                                                    *
*********************************************************************/
/* s-print.i - output device stuff: */

/* current output device */
DEFINE {1} SHARED VARIABLE qbf-device   AS INTEGER INITIAL     1 NO-UNDO.

/* append to existing file */
DEFINE {1} SHARED VARIABLE qbf-pr-app   AS LOGICAL INITIAL FALSE NO-UNDO.

/* total number of output devices */
DEFINE {1} SHARED VARIABLE qbf-printer# AS INTEGER INITIAL     0 NO-UNDO.

DEFINE {1} SHARED VARIABLE qbf-printer  AS CHARACTER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-perm  AS CHARACTER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-dev   AS CHARACTER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-boff  AS CHARACTER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-bon   AS CHARACTER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-comp  AS CHARACTER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-init  AS CHARACTER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-norm  AS CHARACTER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.
DEFINE {1} SHARED VARIABLE qbf-pr-width AS INTEGER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.

DEFINE {1} SHARED VARIABLE qbf-pr-type  AS CHARACTER
                                           EXTENT { prores/s-limprn.i } NO-UNDO.

/*
type includes:
  term - output to terminal paged
  file - ask for filename then output to value() no-echo.
  view - browse program
  to   - output to value() no-echo.
  thru - output thru value() no-echo.
  brow - output to terminal with prev/next page
  prog - link to user-supplied 4GL program for output
*/

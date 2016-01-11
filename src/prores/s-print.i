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
